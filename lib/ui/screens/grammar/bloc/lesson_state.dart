part of 'lesson_bloc.dart';

@freezed
class LessonState with _$LessonState {
  const factory LessonState({
    @Default({}) Map<int, bool> markedLessons,
    @Default(null) String? error,
    @Default(null) String? message,
  }) = _LessonState;
}
