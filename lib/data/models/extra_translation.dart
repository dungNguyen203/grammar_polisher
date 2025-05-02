import 'package:freezed_annotation/freezed_annotation.dart';

part 'generated/extra_translation.freezed.dart';

part 'generated/extra_translation.g.dart';

@freezed
class ExtraTranslation with _$ExtraTranslation {
  const factory ExtraTranslation({
    required String label,
    required String type,
    required List<String> content,
  }) = _ExtraTranslation;

  factory ExtraTranslation.fromJson(Map<String, dynamic> json) =>
      _$ExtraTranslationFromJson(json);
}
