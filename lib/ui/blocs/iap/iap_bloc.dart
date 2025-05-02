import 'dart:async';

import 'package:amplitude_flutter/amplitude.dart';
import 'package:amplitude_flutter/events/base_event.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:grammar_polisher/utils/extensions/list_extension.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import '../../../configs/di.dart';
import '../../../core/failure.dart';
import '../../../data/repositories/iap_repository.dart';
import '../../../utils/global_values.dart';

part 'iap_event.dart';

part 'iap_state.dart';

part 'generated/iap_bloc.freezed.dart';

class IapBloc extends Bloc<IapEvent, IapState> {
  final IapRepository _iapRepository;
  StreamSubscription<List<PurchaseDetails>>? _subscription;
  final _amplitude = DI().sl<Amplitude>();

  IapBloc({required IapRepository iapRepository}) : _iapRepository = iapRepository, super(const IapState()) {
    on<IapEvent>((event, emit) async {
      await event.map(
        listenForPurchases: (event) => _onListenForPurchases(event, emit),
        restorePurchases: (event) => _onRestorePurchases(event, emit),
        purchaseProduct: (event) => _onPurchaseProduct(event, emit),
        emitState: (event) => _onEmitState(event, emit),
      );
    });
  }

  _onListenForPurchases(_ListenForPurchases event, Emitter<IapState> emit) async {
    debugPrint('IapBloc -> _onListenForPurchases');
    int? boughtNoAdsTime = GlobalValues.boughtNoAdsTime;
    if (boughtNoAdsTime != null && boughtNoAdsTime != -1) {
      debugPrint('IapBloc -> _onListenForPurchases -> boughtNoAdsTime: ${DateTime.fromMillisecondsSinceEpoch(boughtNoAdsTime)}');
    } else if (boughtNoAdsTime == -1) {
      debugPrint('IapBloc -> _onListenForPurchases -> boughtNoAdsTime: premium');
    } else {
      debugPrint('IapBloc -> _onListenForPurchases -> boughtNoAdsTime: null');
    }
    if (boughtNoAdsTime != null &&
        boughtNoAdsTime != -1 &&
        DateTime.now().isAfter(DateTime.fromMillisecondsSinceEpoch(boughtNoAdsTime))) {
      emit(state.copyWith(boughtNoAdsTime: null));
      GlobalValues.setBoughtNoAdsTime(null);
    } else {
      emit(state.copyWith(boughtNoAdsTime: boughtNoAdsTime));
    }
    final productsResult = await _iapRepository.getProducts();
    productsResult.fold(
      (failure) {
        debugPrint('IapBloc -> _onListenForPurchases -> getProducts -> failure: $failure');
      },
      (products) {
        debugPrint('IapBloc -> _onListenForPurchases -> getProducts -> success -> products: ${products.length}');
        emit(state.copyWith(products: products));
      },
    );
    _subscription = _iapRepository.subscription.listen((purchases) {
      if (isClosed) {
        _subscription?.cancel();
        return;
      }
      for (final purchase in purchases) {
        debugPrint('IapBloc -> _onListenForPurchases -> purchase: ${purchase.productID} -> ${purchase.status}');
        if (purchase.status == PurchaseStatus.pending) {
          add(IapEvent.emitState(state.copyWith(isLoading: true)));
        } else {
          if (purchase.status == PurchaseStatus.error) {
            _amplitude.track(BaseEvent('purchase_error', extra: {'error': purchase.error?.message}));
            add(IapEvent.emitState(state.copyWith(failure: Failure(message: purchase.error?.message), isLoading: false)));
            add(IapEvent.emitState(state.copyWith(failure: null, isLoading: false)));
          } else {
            if (purchase.status == PurchaseStatus.purchased) {
              _amplitude.track(BaseEvent('purchase_success', extra: {'product_id': purchase.productID}));
              _processPurchase(purchase.productID);
            } else if (purchase.status == PurchaseStatus.restored) {
              _amplitude.track(BaseEvent('purchase_restored', extra: {'product_id': purchase.productID}));
              final currentPurchased = [...state.purchases];
              if (!currentPurchased.contains(purchase)) {
                currentPurchased.add(purchase);
              }
              add((IapEvent.emitState(state.copyWith(purchases: currentPurchased))));
            } else if (purchase.status == PurchaseStatus.canceled) {
              _amplitude.track(BaseEvent('purchase_canceled', extra: {'product_id': purchase.productID}));
              add(IapEvent.emitState(state.copyWith(failure: Failure(message: "Purchase canceled"), isLoading: false)));
              add(IapEvent.emitState(state.copyWith(failure: null, isLoading: false)));
            }
          }
          if (purchase.pendingCompletePurchase) {
            _iapRepository.completePurchase(purchase);
          }
        }
      }
    });
    _iapRepository.restorePurchases();
  }

  _onRestorePurchases(_RestorePurchases event, Emitter<IapState> emit) async {
    debugPrint('IapBloc -> _onRestorePurchases');
    final purchased = state.purchases;
    if (purchased.isEmpty) {
      emit(state.copyWith(failure: Failure(message: "No purchases found")));
      emit(state.copyWith(failure: null));
      return;
    }
    for (final purchase in purchased) {
      await _processPurchase(purchase.productID);
    }
  }

  _onPurchaseProduct(_PurchaseProduct event, Emitter<IapState> emit) async {
    debugPrint('IapBloc -> _onPurchaseProduct -> purchasing: ${event.id}');
    emit(state.copyWith(isLoading: true));
    if (appFlavor != 'production' || event.isFree) {
      await Future.delayed(const Duration(seconds: 3));
      _processPurchase(event.id);
      return;
    }
    final product = state.products.firstWhereOrNull((element) => element.id == event.id);
    if (product == null) {
      emit(
        state.copyWith(isLoading: false, failure: Failure(message: "This product is not available now, please try again later")),
      );
      emit(state.copyWith(isLoading: false, failure: null));
      return;
    }
    final result = await _iapRepository.purchaseProduct(product);
    result.fold(
      (failure) {
        debugPrint('IapBloc -> _onPurchaseProduct -> failure: $failure');
        emit(state.copyWith(failure: failure, isLoading: false));
        emit(state.copyWith(failure: null));
      },
      (_) {
        debugPrint('IapBloc -> _onPurchaseProduct -> success');
      },
    );
  }

  _onEmitState(_EmitState event, Emitter<IapState> emit) {
    debugPrint('IapBloc -> _onEmitState');
    emit(event.state);
  }

  _processPurchase(String id) {
    if (id != const String.fromEnvironment('PRIMARY_PRODUCT_ID')) {
      final boughtNoAdsTime = GlobalValues.boughtNoAdsTime;
      debugPrint('IapBloc -> _processPurchase -> boughtNoAdsTime: $boughtNoAdsTime');
      if (boughtNoAdsTime == null) {
        final time = DateTime.now().copyWith(hour: 0, minute: 0, second: 0, millisecond: 0).add(Duration(days: 1));
        GlobalValues.setBoughtNoAdsTime(time.millisecondsSinceEpoch);
        add(IapEvent.emitState(state.copyWith(boughtNoAdsTime: time.millisecondsSinceEpoch, isLoading: false)));
      }
      if (boughtNoAdsTime != null && boughtNoAdsTime != -1) {
        final time = DateTime.fromMillisecondsSinceEpoch(boughtNoAdsTime).add(Duration(days: 1));
        GlobalValues.setBoughtNoAdsTime(time.millisecondsSinceEpoch);
        add(IapEvent.emitState(state.copyWith(boughtNoAdsTime: time.millisecondsSinceEpoch, isLoading: false)));
      }
    } else {
      GlobalValues.setBoughtNoAdsTime(-1);
      add(IapEvent.emitState(state.copyWith(boughtNoAdsTime: -1, isLoading: false)));
    }
  }
}
