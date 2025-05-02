import 'package:freezed_annotation/freezed_annotation.dart';

import 'extra_translation.dart';

part 'generated/translate_snapshot.freezed.dart';

part 'generated/translate_snapshot.g.dart';

@freezed
class TranslateSnapshot with _$TranslateSnapshot {
  const factory TranslateSnapshot({
    @Default('') String content,
    String? spelling,
    String? type,
    @Default([]) List<ExtraTranslation> moreTranslations,
  }) = _TranslateSnapshot;

  factory TranslateSnapshot.fromJson(Map<String, dynamic> json) =>
      _$TranslateSnapshotFromJson(json);
}
