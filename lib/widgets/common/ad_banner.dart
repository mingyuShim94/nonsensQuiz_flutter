import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'dart:io' show Platform;

class AdBanner extends StatefulWidget {
  const AdBanner({super.key});

  @override
  State<AdBanner> createState() => _AdBannerState();
}

class _AdBannerState extends State<AdBanner> {
  BannerAd? _bannerAd;
  bool _isLoaded = false;
  bool _isAdLoading = false;

  // 테스트 광고 ID
  String get _adUnitId {
    if (kDebugMode) {
      return Platform.isAndroid
          ? 'ca-app-pub-3940256099942544/6300978111' // 안드로이드 테스트 ID
          : 'ca-app-pub-3940256099942544/2934735716'; // iOS 테스트 ID
    }
    return Platform.isAndroid
        ? 'ca-app-pub-8647279125417942/6368631090'
        : 'ca-app-pub-8647279125417942~5983280418';
  }

  @override
  void initState() {
    super.initState();
    // initState에서는 MediaQuery 사용 불가
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isAdLoading) {
      _loadAd();
    }
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    _isLoaded = false;
    _isAdLoading = false;
    super.dispose();
  }

  void _loadAd() async {
    if (!mounted || _isAdLoading) {
      debugPrint(
          '🚫 Ad loading skipped: mounted=$mounted, isLoading=$_isAdLoading');
      return;
    }

    debugPrint('📱 Starting to load banner ad...');
    debugPrint('📱 Ad Unit ID: $_adUnitId');

    setState(() {
      _isAdLoading = true;
    });

    try {
      final width = MediaQuery.of(context).size.width.truncate();
      debugPrint('📱 Screen width: $width');

      final size =
          await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
        width,
      );

      if (size == null || !mounted) {
        debugPrint('❌ Failed to get ad size or widget unmounted');
        setState(() {
          _isAdLoading = false;
        });
        return;
      }

      debugPrint('📱 Ad size: ${size.width}x${size.height}');

      _bannerAd = BannerAd(
        adUnitId: _adUnitId,
        size: size,
        request: const AdRequest(),
        listener: BannerAdListener(
          onAdLoaded: (ad) {
            debugPrint('✅ Banner ad loaded successfully: $ad');
            setState(() {
              _isLoaded = true;
              _isAdLoading = false;
            });
          },
          onAdFailedToLoad: (ad, error) {
            debugPrint('❌ Banner ad failed to load: $error');
            debugPrint('Error code: ${error.code}');
            debugPrint('Error message: ${error.message}');
            debugPrint('Error domain: ${error.domain}');
            ad.dispose();
            setState(() {
              _isAdLoading = false;
            });
          },
        ),
      );

      debugPrint('📱 Attempting to load banner ad...');
      await _bannerAd!.load();
    } catch (e, stackTrace) {
      debugPrint('❌ Error loading banner ad: $e');
      debugPrint('Stack trace: $stackTrace');
      _bannerAd?.dispose();
      _bannerAd = null;
      setState(() {
        _isAdLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLoaded || _bannerAd == null) {
      return Container(
        height: 50,
        color: Colors.transparent,
      );
    }

    return Container(
      width: MediaQuery.of(context).size.width,
      height: _bannerAd!.size.height.toDouble(),
      alignment: Alignment.center,
      child: AdWidget(ad: _bannerAd!),
    );
  }
}
