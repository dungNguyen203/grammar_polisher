import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'app_open_ad_manager.dart';
import 'consent_manager.dart';

class AppLifecycleReactor {
  AppLifecycleReactor._();

  static void listenToShowAds() {
    AppStateEventNotifier.startListening();
    AppStateEventNotifier.appStateStream.forEach((state) => _onAppStateChanged(state));
    ConsentManager.gatherConsent((consentError) {
      if (consentError != null) {
        debugPrint("Consent error: ${consentError.errorCode}: ${consentError.message}");
      }
      AppOpenAdManager.loadAd();
    });
  }

  static void _onAppStateChanged(AppState appState) {
    debugPrint('New AppState state: $appState');
    if (appState == AppState.foreground) {
      AppOpenAdManager.showAdIfAvailable();
    }
  }
}
