part of 'lesson_bloc.dart';

@freezed
class LessonEvent with _$LessonEvent {
  const factory LessonEvent.markLesson({
    required int id,
    required bool isMarked,
  }) = _MarkLesson;

  const factory LessonEvent.loadMarkedLessons() = _LoadMarkedLessons;
}
