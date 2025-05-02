import 'package:dio/dio.dart';

import '../models/extra_translation.dart';
import '../models/translate_snapshot.dart';

abstract interface class TranslationData {
  Future<TranslateSnapshot> translate(String text, String from, String to);
}

class GoogleTranslateData implements TranslationData {
  final Dio _dio;

  GoogleTranslateData({required Dio dio}) : _dio = dio;

  @override
  Future<TranslateSnapshot> translate(String text, String from, String to) async {
    var result = await _dio.get(
      "/translate_a/single",
      queryParameters: {
        "client": "gtx",
        "sl": from,
        "tl": to,
        "dt": ["bd", "ex", "md", "rm", "t"],
        "q": text,
        "ie": "UTF-8",
        "oe": "UTF-8"
      },
    );
    var content = "";
    try {
      content = result.data[0][0][0] as String;
    } catch (e) {
      content = "";
    }
    String? type;
    try {
      type = result.data[1][0][0] as String;
    } catch (e) {
      type = null;
    }
    String? spelling;
    try {
      spelling = result.data[0][1][2] as String;
    } catch (e) {
      spelling = null;
    }
    List<ExtraTranslation> moreTranslations = [];
    try {
      for (var item in result.data[1][0][2]) {
        List<String> value = [];
        for (var v in item[1]) {
          value.add(v);
        }
        moreTranslations.add(ExtraTranslation(
          label: item[0],
          type: result.data[1][0][0] as String,
          content: value,
        ));
      }
    } catch (e) {
      moreTranslations = [];
    }

    var translateSnapshot = TranslateSnapshot(
      content: content,
      spelling: spelling,
      type: type,
      moreTranslations: moreTranslations,
    );
    return translateSnapshot;
  }
}
