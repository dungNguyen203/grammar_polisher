import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

abstract interface class PairStorage {
  Future<void> saveMarkedLesson(Map<int, bool> markedLessons);

  Map<int, bool> getMarkedLesson();

  Future<void> setTimeStreak(int timeStreak);

  int getTimeStreak();

  Future<void> setStreak(int streak);

  int get streak;

  int get longestStreak;

  bool get streakedToday;
}

class SharedPreferencesStorage implements PairStorage {
  static const String _markedLessonsKey = 'marked_lessons';
  static const String _streakKey = 'streak';
  static const String _longestStreakKey = 'longest_streak';
  final SharedPreferences _sharedPreferences;

  const SharedPreferencesStorage({
    required SharedPreferences sharedPreferences,
  }) : _sharedPreferences = sharedPreferences;

  @override
  Map<int, bool> getMarkedLesson() {
    final markedLessonJson = _sharedPreferences.getString(_markedLessonsKey);
    if (markedLessonJson == null) {
      return {};
    }
    final markedLessonMap = jsonDecode(markedLessonJson) as Map<String, dynamic>;
    return markedLessonMap.map((key, value) => MapEntry(int.parse(key), value as bool));
  }

  @override
  Future<void> saveMarkedLesson(Map<int, bool> markedLessons) async {
    var markedLessonJson = jsonEncode(markedLessons.map((key, value) => MapEntry(key.toString(), value)));
    await _sharedPreferences.setString(_markedLessonsKey, markedLessonJson);
  }

  @override
  int getTimeStreak() {
    final now = DateTime.now();
    final key = '${now.year}-${now.month}-${now.day}';
    return _sharedPreferences.getInt(key) ?? 0;
  }

  @override
  Future<void> setTimeStreak(int timeStreak) {
    final now = DateTime.now();
    final key = '${now.year}-${now.month}-${now.day}';
    return _sharedPreferences.setInt(key, timeStreak);
  }

  @override
  int get streak {
    final now = DateTime.now();
    final yesterday = now.subtract(const Duration(days: 1));
    final yesterdayKey = '${yesterday.year}-${yesterday.month}-${yesterday.day}-streaked';
    final yesterdayStreaked = _sharedPreferences.getBool(yesterdayKey) ?? false;
    if (!yesterdayStreaked) {
      final todayKey = '${now.year}-${now.month}-${now.day}-streaked';
      _sharedPreferences.setBool(todayKey, false);
      _sharedPreferences.setInt(_streakKey, 0);
      return 0;
    }
    return _sharedPreferences.getInt(_streakKey) ?? 0;
  }

  @override
  int get longestStreak {
    return _sharedPreferences.getInt(_longestStreakKey) ?? 0;
  }

  @override
  Future<void> setStreak(int streak) async {
    final now = DateTime.now();
    final key = '${now.year}-${now.month}-${now.day}-streaked';
    await _sharedPreferences.setBool(key, true);
    await _sharedPreferences.setInt(_streakKey, streak);
    if (streak > longestStreak) {
      await _sharedPreferences.setInt(_longestStreakKey, streak);
    }
  }

  @override
  bool get streakedToday {
    final now = DateTime.now();
    final key = '${now.year}-${now.month}-${now.day}-streaked';
    return _sharedPreferences.getBool(key) ?? false;
  }
}
