import 'package:dartz/dartz.dart';

import '../../../core/failure.dart';
import '../data_sources/pair_storage.dart';

abstract interface class LessonRepository {
  Map<int, bool> getMarkedLesson();

  Future<Either<Failure, void>> saveMarkedLesson(Map<int, bool> markedLessons);
}

class LessonRepositoryImpl implements LessonRepository {
  final PairStorage _pairStorage;

  const LessonRepositoryImpl({
    required PairStorage pairStorage,
  }) : _pairStorage = pairStorage;

  @override
  Map<int, bool> getMarkedLesson() {
    return _pairStorage.getMarkedLesson();
  }

  @override
  Future<Either<Failure, void>> saveMarkedLesson(Map<int, bool> markedLessons) async {
    try {
      await _pairStorage.saveMarkedLesson(markedLessons);
      return const Right(null);
    } on Exception {
      return Left(Failure());
    }
  }
}
