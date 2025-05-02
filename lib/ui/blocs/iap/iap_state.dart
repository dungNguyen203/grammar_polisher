part of 'iap_bloc.dart';

@freezed
class IapState with _$IapState {
  const factory IapState({
    @Default(null) Failure? failure,
    @Default(false) bool isLoading,
    @Default([]) List<ProductDetails> products,
    @Default([]) List<PurchaseDetails> purchases,
    @Default(null) int? boughtNoAdsTime,
  }) = _IapState;
}
