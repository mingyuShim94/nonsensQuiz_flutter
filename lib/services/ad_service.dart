import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'dart:io' show Platform;

class AdService {
  static String get rewardedAdUnitId {
    if (kDebugMode) {
      return Platform.isAndroid
          ? 'ca-app-pub-3940256099942544/5224354917' // 안드로이드 테스트 ID
          : 'ca-app-pub-3940256099942544/1712485313'; // iOS 테스트 ID
    }
    return Platform.isAndroid
        ? 'ca-app-pub-8647279125417942/4504184381' // 안드로이드 실제 ID
        : 'ca-app-pub-8647279125417942/8543238414'; // iOS 실제 ID
  }

  static Future<bool> showRewardedAd({
    required Function onRewarded,
    required Function onAdFailed,
  }) async {
    try {
      RewardedAd? rewardedAd;
      bool isRewarded = false;

      await RewardedAd.load(
        adUnitId: rewardedAdUnitId,
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (ad) {
            debugPrint('✅ Rewarded ad loaded successfully');
            rewardedAd = ad;

            rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
              onAdDismissedFullScreenContent: (ad) {
                debugPrint('Ad dismissed');
                ad.dispose();
                if (isRewarded) {
                  onRewarded();
                }
              },
              onAdFailedToShowFullScreenContent: (ad, error) {
                debugPrint('Ad failed to show: $error');
                ad.dispose();
                onAdFailed();
              },
            );

            rewardedAd!.show(
              onUserEarnedReward: (ad, reward) {
                debugPrint('User earned reward: ${reward.amount}');
                isRewarded = true;
              },
            );
          },
          onAdFailedToLoad: (error) {
            debugPrint('❌ Rewarded ad failed to load: $error');
            onAdFailed();
          },
        ),
      );

      return true;
    } catch (e) {
      debugPrint('❌ Error showing rewarded ad: $e');
      onAdFailed();
      return false;
    }
  }

  static String get coinRewardedAdUnitId {
    if (kDebugMode) {
      return Platform.isAndroid
          ? 'ca-app-pub-3940256099942544/5224354917' // 안드로이드 테스트 ID
          : 'ca-app-pub-3940256099942544/1712485313'; // iOS 테스트 ID
    }
    return Platform.isAndroid
        ? 'ca-app-pub-8647279125417942/1303305971' // 안드로이드 실제 ID
        : 'ca-app-pub-8647279125417942/5945258567'; // iOS 실제 ID
  }

  static Future<bool> showCoinRewardedAd({
    required Function onRewarded,
    required Function onAdFailed,
  }) async {
    try {
      RewardedAd? rewardedAd;
      bool isRewarded = false;

      await RewardedAd.load(
        adUnitId: coinRewardedAdUnitId,
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (ad) {
            debugPrint('✅ Coin rewarded ad loaded successfully');
            rewardedAd = ad;

            rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
              onAdDismissedFullScreenContent: (ad) {
                debugPrint('Coin ad dismissed');
                ad.dispose();
                if (isRewarded) {
                  onRewarded();
                }
              },
              onAdFailedToShowFullScreenContent: (ad, error) {
                debugPrint('Coin ad failed to show: $error');
                ad.dispose();
                onAdFailed();
              },
            );

            rewardedAd!.show(
              onUserEarnedReward: (ad, reward) {
                debugPrint('User earned coin reward: ${reward.amount}');
                isRewarded = true;
              },
            );
          },
          onAdFailedToLoad: (error) {
            debugPrint('❌ Coin rewarded ad failed to load: $error');
            onAdFailed();
          },
        ),
      );

      return true;
    } catch (e) {
      debugPrint('❌ Error showing coin rewarded ad: $e');
      onAdFailed();
      return false;
    }
  }
}
