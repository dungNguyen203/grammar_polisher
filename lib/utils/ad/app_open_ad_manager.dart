import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'dart:io' show Platform;

import '../global_values.dart';
import 'consent_manager.dart';

class AppOpenAdManager {
  static final Duration maxCacheDuration = const Duration(hours: 4);
  static DateTime? _appOpenLoadTime;

  static AppOpenAd? _appOpenAd;
  static bool _isShowingAd = false;

  static String adUnitId =
      Platform.isAndroid
          ? const String.fromEnvironment('ANDROID_APP_OPEN_AD_UNIT_ID')
          : const String.fromEnvironment('IOS_APP_OPEN_AD_UNIT_ID');

  static void loadAd() async {
    var canRequestAds = await ConsentManager.canRequestAds();
    if (!canRequestAds || GlobalValues.boughtNoAdsTime != null) {
      return;
    }
    AppOpenAd.load(
      adUnitId: adUnitId,
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          debugPrint('AppOpenAd loaded');
          _appOpenLoadTime = DateTime.now();
          _appOpenAd = ad;
        },
        onAdFailedToLoad: (error) {
          debugPrint('AppOpenAd failed to load: $error');
        },
      ),
    );
  }

  static bool get isAdAvailable {
    return _appOpenAd != null;
  }

  static void showAdIfAvailable() {
    if (!isAdAvailable || GlobalValues.boughtNoAdsTime != null) {
      debugPrint('Tried to show ad before available.');
      loadAd();
      return;
    }
    if (_isShowingAd) {
      debugPrint('Tried to show ad while already showing an ad.');
      return;
    }
    if (DateTime.now().subtract(maxCacheDuration).isAfter(_appOpenLoadTime!)) {
      debugPrint('Maximum cache duration exceeded. Loading another ad.');
      _appOpenAd!.dispose();
      _appOpenAd = null;
      loadAd();
      return;
    }
    _appOpenAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) {
        _isShowingAd = true;
        debugPrint('$ad onAdShowedFullScreenContent');
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        debugPrint('$ad onAdFailedToShowFullScreenContent: $error');
        _isShowingAd = false;
        ad.dispose();
        _appOpenAd = null;
      },
      onAdDismissedFullScreenContent: (ad) {
        debugPrint('$ad onAdDismissedFullScreenContent');
        _isShowingAd = false;
        ad.dispose();
        _appOpenAd = null;
        loadAd();
      },
    );
    _appOpenAd!.show();
  }
}
