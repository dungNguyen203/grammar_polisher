import 'dart:io';
import 'package:amplitude_flutter/amplitude.dart';
import 'package:amplitude_flutter/events/base_event.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../../configs/di.dart';
import '../../../utils/ad/consent_manager.dart';
import '../../../utils/app_snack_bar.dart';
import '../dialogs/paywall_dialog.dart';

mixin RewardedAdMixin<T extends StatefulWidget> on State<T> {
  RewardedAd? _rewardedAd;

  final _adUnitId = Platform.isAndroid
      ? const String.fromEnvironment('ANDROID_REWARDED_AD_UNIT_ID')
      : const String.fromEnvironment('IOS_REWARDED_AD_UNIT_ID');

  final _amplitude = DI().sl<Amplitude>();

  @override
  void initState() {
    super.initState();
    ConsentManager.gatherConsent((consentError) {
      if (consentError != null) {
        debugPrint("Consent error: ${consentError.errorCode}: ${consentError.message}");
        _rewardedAd?.dispose();
        _loadRewardedAd();
      }
    });
    _loadRewardedAd();
  }

  void _loadRewardedAd() async {
    if (!await ConsentManager.canRequestAds() || !mounted || isPremium) {
      return;
    }
    debugPrint('Loading RewardedAd');
    RewardedAd.load(
      adUnitId: _adUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdShowedFullScreenContent: (ad) {},
            onAdImpression: (ad) {
              _amplitude.track(BaseEvent("rewarded_ad_impression"));
            },
            onAdFailedToShowFullScreenContent: (ad, err) {
              ad.dispose();
              _loadRewardedAd();
            },
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _amplitude.track(BaseEvent("rewarded_ad_dismissed"));
              _loadRewardedAd();
            },
            onAdClicked: (ad) {},
          );
          debugPrint('RewardedAd loaded.');
          _rewardedAd?.dispose();
          _rewardedAd = ad;
        },
        onAdFailedToLoad: (LoadAdError error) {
          _amplitude.track(BaseEvent("rewarded_ad_error", extra: {"error": error.toString()}));
          debugPrint('RewardedAd failed to load: $error');
        },
      ),
    );
  }

  void showRewardedAd(Function(AdWithoutView, RewardItem) onUserEarnedReward) {
    if (isPremium) return;
    if (_rewardedAd != null) {
      _rewardedAd!.show(onUserEarnedReward: onUserEarnedReward);
      _rewardedAd = null;
    } else {
      debugPrint('InterstitialAd is not ready yet.');
      AppSnackBar.showError(context, 'Ad is not ready yet!');
      Future.delayed(Duration(milliseconds: 1000), () {
        if (mounted) {
          showDialog(context: context, builder: (context) => PaywallDialog());
        }
      });
    }
  }

  @override
  void dispose() {
    _rewardedAd?.dispose();
    super.dispose();
  }

  bool get isPremium;
}
