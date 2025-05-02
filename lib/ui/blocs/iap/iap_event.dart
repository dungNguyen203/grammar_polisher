part of 'iap_bloc.dart';

@freezed
class IapEvent with _$IapEvent {
  const factory IapEvent.listenForPurchases() = _ListenForPurchases;
  const factory IapEvent.restorePurchases() = _RestorePurchases;
  const factory IapEvent.purchaseProduct(String id, {@Default(false) bool isFree}) = _PurchaseProduct;
  const factory IapEvent.emitState(IapState state) = _EmitState;
}
