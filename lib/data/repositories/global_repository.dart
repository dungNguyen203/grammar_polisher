import 'package:dartz/dartz.dart';

import '../data_sources/translation_data.dart';
import '../models/translate_snapshot.dart';

abstract interface class GlobalRepository {
  Future<Either<Exception, TranslateSnapshot>> translate({required String text, required String from, required String to});
}

class GlobalRepositoryImpl implements GlobalRepository {
  final TranslationData _translationData;

  GlobalRepositoryImpl({required TranslationData translationData}) : _translationData = translationData;

  @override
  Future<Either<Exception, TranslateSnapshot>> translate({required String text, required String from, required String to}) async {
    try {
      var result = await _translationData.translate(text, from, to);
      return Right(result);
    } catch (e) {
      return Left(Exception(e));
    }
  }
}
