import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../data/repositories/streak_repository.dart';

part 'streak_event.dart';

part 'streak_state.dart';

part 'generated/streak_bloc.freezed.dart';

class StreakBloc extends Bloc<StreakEvent, StreakState> {
  final StreakRepository _streakRepository;
  static const int timePerDayNeeded = 60 * 5; // 5 minutes

  Timer? _streakTimer;

  StreakBloc({
    required StreakRepository streakRepository,
  })  : _streakRepository = streakRepository,
        super(const StreakState()) {
    on<StreakEvent>((event, emit) async {
      await event.map(
        watchStreak: (event) => _onWatchStreak(event, emit),
        emitState: (event) => _onEmitState(event, emit),
      );
    });
  }

  _onWatchStreak(WatchStreak event, Emitter<StreakState> emit) {
    debugPrint('StreakBloc: watchStreak');
    final timeStreak = _streakRepository.getTimeStreak();
    final longestStreak = _streakRepository.longestStreak;
    final streak = _streakRepository.streak;
    debugPrint('StreakBloc: timeStreak: $timeStreak');
    debugPrint('StreakBloc: longestStreak: $longestStreak');
    debugPrint('StreakBloc: streak: $streak');
    emit(StreakState(
      spentTimeToday: timeStreak,
      longestStreak: longestStreak,
      streak: streak,
    ));
    _streakTimer?.cancel();
    _streakTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (isClosed) {
        timer.cancel();
        return;
      }
      final newSpentTimeToday = _streakRepository.getTimeStreak() + 1;
      add(StreakEvent.emitState(state.copyWith(
        spentTimeToday: newSpentTimeToday,
      )));
      if (!_streakRepository.streakedToday) {
        _streakRepository.setTimeStreak(newSpentTimeToday);
      }
      debugPrint('StreakBloc: newSpentTimeToday: $newSpentTimeToday');
      if (newSpentTimeToday >= timePerDayNeeded && !_streakRepository.streakedToday) {
        final newStreak = _streakRepository.streak + 1;
        final newLongestStreak = newStreak > longestStreak ? newStreak : longestStreak;
        add(StreakEvent.emitState(state.copyWith(
          streak: newStreak,
          longestStreak: newLongestStreak,
        )));
        _streakRepository.setStreak(newStreak);
      }
    });
  }

  _onEmitState(EmitState event, Emitter<StreakState> emit) {
    emit(event.state);
  }
}
