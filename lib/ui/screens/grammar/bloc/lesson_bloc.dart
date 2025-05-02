import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../data/repositories/lesson_repository.dart';

part 'lesson_event.dart';

part 'lesson_state.dart';

part 'generated/lesson_bloc.freezed.dart';

class LessonBloc extends Bloc<LessonEvent, LessonState> {
  final LessonRepository _lessonRepository;

  LessonBloc({
    required LessonRepository lessonRepository,
  })  : _lessonRepository = lessonRepository,
        super(const LessonState()) {
    on<LessonEvent>((event, emit) async {
      await event.map(
        loadMarkedLessons: (event) => _onLoadMarkedLessons(event, emit),
        markLesson: (event) => _onMarkLesson(event, emit),
      );
    });

    add(const LessonEvent.loadMarkedLessons());
  }

  _onLoadMarkedLessons(_LoadMarkedLessons event, Emitter<LessonState> emit) {
    final markedLessons = _lessonRepository.getMarkedLesson();
    emit(state.copyWith(markedLessons: markedLessons));
  }

  _onMarkLesson(_MarkLesson event, Emitter<LessonState> emit) async {
    final markedLessons = Map<int, bool>.from(state.markedLessons);
    markedLessons[event.id] = event.isMarked;
    final result = await _lessonRepository.saveMarkedLesson(markedLessons);
    result.fold(
      (failure) {
        emit(state.copyWith(error: failure.message));
        emit(state.copyWith(error: null));
      },
      (_) {
        final message = event.isMarked ? 'Lesson marked' : null;
        emit(state.copyWith(markedLessons: markedLessons, message: message));
        if (message != null) emit(state.copyWith(message: null));
      },
    );
  }
}
