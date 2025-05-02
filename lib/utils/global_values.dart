import 'package:shared_preferences/shared_preferences.dart';

class GlobalValues {
  const GlobalValues._();

  static const isShowFlashCardAppDialogKey = 'isShowFlashCardAppDialog';
  static const isShowInAppReviewKey = 'isShowInAppReview';
  static const isShowOnboardingKey = 'isShowOnboarding';
  static const boughtNoAdsTimeKey = 'boughtNoAds';
  static const lastReviewTimeKey = 'lastPolishTime';
  static const isShowFreeTrialKey = 'isShowFreeTrial';

  static SharedPreferences? _sharedPreferences;

  static Future<void> init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  static bool get isShowFlashCardAppDialog => _sharedPreferences?.getBool(isShowFlashCardAppDialogKey) ?? false;

  static set isShowFlashCardAppDialog(bool value) {
    _sharedPreferences?.setBool(isShowFlashCardAppDialogKey, value);
  }

  static bool get isShowInAppReview => _sharedPreferences?.getBool(isShowInAppReviewKey) ?? false;

  static set isShowInAppReview(bool value) {
    _sharedPreferences?.setBool(isShowInAppReviewKey, value);
  }

  static bool get isShowOnboarding => _sharedPreferences?.getBool(isShowOnboardingKey) ?? false;

  static set isShowOnboarding(bool value) {
    _sharedPreferences?.setBool(isShowOnboardingKey, value);
  }

  static int? get boughtNoAdsTime {
    final result = _sharedPreferences?.getInt(boughtNoAdsTimeKey);
    return result;
  }

  static Future<bool>? setBoughtNoAdsTime(int? value) {
    if (value == null) {
      return _sharedPreferences?.remove(boughtNoAdsTimeKey);
    }
    return _sharedPreferences?.setInt(boughtNoAdsTimeKey, value);
  }

  static DateTime? get lastReviewTime {
    final result = _sharedPreferences?.getInt(lastReviewTimeKey);
    return result != null ? DateTime.fromMillisecondsSinceEpoch(result) : null;
  }

  static Future<bool>? setLastReviewTime(DateTime value) {
    return _sharedPreferences?.setInt(lastReviewTimeKey, value.millisecondsSinceEpoch);
  }

  static bool get isShowFreeTrial => _sharedPreferences?.getBool(isShowFreeTrialKey) ?? false;
  static set isShowFreeTrial(bool value) {
    _sharedPreferences?.setBool(isShowFreeTrialKey, value);
  }
}
