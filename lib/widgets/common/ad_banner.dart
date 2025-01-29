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

  // 플랫폼별 광고 ID 설정
  String get _adUnitId {
    if (kDebugMode) {
      return Platform.isAndroid
          ? 'ca-app-pub-3940256099942544/9214589741'
          : 'ca-app-pub-3940256099942544/2435281174';
    } else {
      return Platform.isAndroid
          ? 'ca-app-pub-8647279125417942/6368631090'
          : 'ca-app-pub-8647279125417942/7315709234';
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isAdLoading) {
      _isAdLoading = true;
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
    if (!mounted || _isAdLoading) return;

    setState(() {
      _isAdLoading = true;
    });

    try {
      final width = MediaQuery.of(context).size.width.truncate();
      final size = await AdSize.getAnchoredAdaptiveBannerAdSize(
        Orientation.portrait,
        width,
      );

      if (size == null || !mounted) {
        setState(() {
          _isAdLoading = false;
        });
        return;
      }

      _bannerAd = BannerAd(
        adUnitId: _adUnitId,
        size: size,
        request: const AdRequest(),
        listener: BannerAdListener(
          onAdLoaded: (ad) {
            setState(() {
              _isLoaded = true;
              _isAdLoading = false;
            });
          },
          onAdFailedToLoad: (ad, error) {
            ad.dispose();
            setState(() {
              _isAdLoading = false;
            });
          },
        ),
      );

      await _bannerAd!.load();
    } catch (e) {
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
