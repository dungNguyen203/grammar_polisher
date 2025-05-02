import 'package:freezed_annotation/freezed_annotation.dart';

import 'lesson.dart';

part 'generated/category_data.freezed.dart';

@freezed
class CategoryData with _$CategoryData {
  const factory CategoryData({
    required int id,
    required String title,
    required String description,
    @Default([]) List<Lesson> lessons,
    @Default(0) int progress,
    @Default(0) int total,
    @Default(false) bool isBeta,
  }) = _CategoryData;
}