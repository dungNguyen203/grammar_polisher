import '../data_sources/pair_storage.dart';

abstract interface class StreakRepository {
  Future<void> setTimeStreak(int timeStreak);

  int getTimeStreak();

  Future<void> setStreak(int streak);

  int get streak;

  int get longestStreak;

  bool get streakedToday;
}

class StreakRepositoryImpl implements StreakRepository {
  final PairStorage _pairStorage;

  StreakRepositoryImpl({
    required PairStorage pairStorage,
  }) : _pairStorage = pairStorage;

  @override
  int getTimeStreak() {
    return _pairStorage.getTimeStreak();
  }

  @override
  Future<void> setTimeStreak(int timeStreak) {
    return _pairStorage.setTimeStreak(timeStreak);
  }

  @override
  int get streak => _pairStorage.streak;

  @override
  int get longestStreak => _pairStorage.longestStreak;

  @override
  bool get streakedToday => _pairStorage.streakedToday;

  @override
  Future<void> setStreak(int streak) {
    return _pairStorage.setStreak(streak);
  }
}