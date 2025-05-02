part of 'streak_bloc.dart';

@freezed
class StreakEvent with _$StreakEvent {
  const factory StreakEvent.watchStreak() = WatchStreak;
  const factory StreakEvent.emitState(StreakState state) = EmitState;
}
