part of 'translate_cubit.dart';

@freezed
class TranslateState with _$TranslateState {
  const factory TranslateState({
    TranslateSnapshot? translateSnapshot,
    String? errorMessage,
    @Default(false) bool isLoading,
  }) = _TranslateState;
}