part of 'streak_bloc.dart';

@freezed
class StreakState with _$StreakState {
  const factory StreakState({
    @Default(0) int streak,
    @Default(0) int longestStreak,
    @Default(0) int spentTimeToday,
  }) = _StreakState;
}
