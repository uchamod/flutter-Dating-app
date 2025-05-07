import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class InterstitialAdService {
  InterstitialAd? _interstitialAd;
  bool _isAdLoaded = false;

  //singleton patterns
  static final InterstitialAdService _instance =
      InterstitialAdService._internal();
  factory InterstitialAdService() => _instance;
  InterstitialAdService._internal();
  final adUnitId =
      Platform.isAndroid
          ? 'ca-app-pub-3940256099942544/1033173712'
          : 'ca-app-pub-3940256099942544/4411468910';

  /// Loads an interstitial ad.
  void loadAd() {
    InterstitialAd.load(
      adUnitId: adUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        // Called when an ad is successfully received.
        onAdLoaded: (ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            // Called when the ad showed the full screen content.
            onAdShowedFullScreenContent: (ad) {},
            // Called when an impression occurs on the ad.
            onAdImpression: (ad) {},
            // Called when the ad failed to show full screen content.
            onAdFailedToShowFullScreenContent: (ad, err) {
              // Dispose the ad here to free resources.
              ad.dispose();
              _isAdLoaded = false;
              loadAd();
            },
            // Called when the ad dismissed full screen content.
            onAdDismissedFullScreenContent: (ad) {
              // Dispose the ad here to free resources.
              ad.dispose();
              _isAdLoaded = false;
              loadAd();
            },
            // Called when a click is recorded for an ad.
            onAdClicked: (ad) {},
          );

          debugPrint('load new Interstitial ad $ad');
          // Keep a reference to the ad so you can show it later.
          _interstitialAd = ad;
          _isAdLoaded = true;
        },
        // Called when an ad request failed.
        onAdFailedToLoad: (LoadAdError error) {
          debugPrint('InterstitialAd failed to load: $error');
        },
      ),
    );
  }

  //show ad unit
  void showInterstitialAd() {
    if (_interstitialAd != null && _isAdLoaded) {
      _interstitialAd!.show();
    } else {
      print('Interstitial ad not ready yet.');
      loadAd();
    }
  }

  bool get isAdLoaded => _isAdLoaded;
}
