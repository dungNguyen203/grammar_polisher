import 'package:freezed_annotation/freezed_annotation.dart';

part 'generated/lesson.freezed.dart';

@freezed
class Lesson with _$Lesson {
  const factory Lesson({
    required int id,
    required String title,
    @Default(null) String? subTitle,
    @Default('') String path,
  }) = _Lesson;
}