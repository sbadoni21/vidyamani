import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdManagerService {
  static final BannerAdListener bannerAdListener = BannerAdListener(
    onAdLoaded: (ad) => debugPrint('ad loaded'),
    onAdFailedToLoad: ((ad, error) =>
        {ad.dispose(), debugPrint('ad failed $error')}),
    onAdOpened: (ad) => debugPrint('ad opened'),
    onAdClosed: (ad) => debugPrint('ad closed'),
  );
}
