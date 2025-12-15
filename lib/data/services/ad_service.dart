import 'dart:async';
import 'dart:io';

import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/config/app_config.dart';

/// AdMob 광고 서비스
class AdService {
  static final AdService _instance = AdService._internal();
  factory AdService() => _instance;
  AdService._internal();

  bool _isInitialized = false;
  InterstitialAd? _interstitialAd;
  bool _isInterstitialAdReady = false;

  static const String _saveCountKey = 'prayer_save_count';
  static const int _adShowInterval = 5; // 5개마다 광고 표시

  /// AdMob SDK 초기화
  Future<void> initialize() async {
    if (_isInitialized) return;

    // iOS에서 ATT (App Tracking Transparency) 요청
    if (Platform.isIOS) {
      await _requestTrackingAuthorization();
    }

    await MobileAds.instance.initialize();
    _isInitialized = true;

    // 전면 광고 미리 로드
    _preloadInterstitialAd();

    if (kDebugMode) {
      debugPrint('[AdService] AdMob SDK initialized');
    }
  }

  /// iOS App Tracking Transparency 권한 요청
  Future<void> _requestTrackingAuthorization() async {
    // ATT 상태 확인
    final status = await AppTrackingTransparency.trackingAuthorizationStatus;

    if (kDebugMode) {
      debugPrint('[AdService] ATT status: $status');
    }

    // 아직 요청하지 않은 경우에만 요청
    if (status == TrackingStatus.notDetermined) {
      // iOS 가이드라인에 따라 약간의 딜레이 후 요청
      // (앱 시작 직후 요청하면 거부될 확률이 높음)
      await Future.delayed(const Duration(milliseconds: 500));

      final result =
          await AppTrackingTransparency.requestTrackingAuthorization();

      if (kDebugMode) {
        debugPrint('[AdService] ATT request result: $result');
      }
    }
  }

  /// ATT 권한 상태 확인
  Future<TrackingStatus> getTrackingStatus() async {
    if (Platform.isIOS) {
      return await AppTrackingTransparency.trackingAuthorizationStatus;
    }
    // Android는 항상 authorized로 처리
    return TrackingStatus.authorized;
  }

  /// 배너 광고 단위 ID (환경변수에서 로드)
  String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return AppConfig.admobAndroidBannerId;
    } else if (Platform.isIOS) {
      return AppConfig.admobIosBannerId;
    }
    throw UnsupportedError('Unsupported platform');
  }

  /// 전면 광고 단위 ID (환경변수에서 로드)
  String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return AppConfig.admobAndroidInterstitialId;
    } else if (Platform.isIOS) {
      return AppConfig.admobIosInterstitialId;
    }
    throw UnsupportedError('Unsupported platform');
  }

  /// 적응형 배너 광고 크기 계산
  Future<AnchoredAdaptiveBannerAdSize?> getAdaptiveBannerAdSize(
    double width,
  ) async {
    return await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
      width.truncate(),
    );
  }

  /// 배너 광고 생성
  BannerAd createBannerAd({
    required AdSize adSize,
    required void Function(Ad) onAdLoaded,
    required void Function(Ad, LoadAdError) onAdFailedToLoad,
  }) {
    return BannerAd(
      adUnitId: bannerAdUnitId,
      size: adSize,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: onAdLoaded,
        onAdFailedToLoad: onAdFailedToLoad,
        onAdOpened: (ad) {
          if (kDebugMode) {
            debugPrint('[AdService] Banner ad opened');
          }
        },
        onAdClosed: (ad) {
          if (kDebugMode) {
            debugPrint('[AdService] Banner ad closed');
          }
        },
      ),
    );
  }

  /// 전면 광고 미리 로드
  void _preloadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _isInterstitialAdReady = true;
          _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _isInterstitialAdReady = false;
              _preloadInterstitialAd(); // 다음 광고 미리 로드
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              _isInterstitialAdReady = false;
              _preloadInterstitialAd();
            },
          );
          if (kDebugMode) {
            debugPrint('[AdService] Interstitial ad preloaded');
          }
        },
        onAdFailedToLoad: (error) {
          _isInterstitialAdReady = false;
          if (kDebugMode) {
            debugPrint('[AdService] Interstitial ad failed to preload: $error');
          }
          // 5초 후 다시 시도
          Future.delayed(const Duration(seconds: 5), _preloadInterstitialAd);
        },
      ),
    );
  }

  /// 기도 저장 횟수 증가 및 광고 표시 여부 반환
  /// 5개마다 true를 반환하여 전면 광고를 표시해야 함을 알림
  Future<bool> incrementSaveCountAndCheckAd() async {
    final prefs = await SharedPreferences.getInstance();
    int count = prefs.getInt(_saveCountKey) ?? 0;
    count++;
    await prefs.setInt(_saveCountKey, count);

    if (kDebugMode) {
      debugPrint('[AdService] Prayer save count: $count');
    }

    // 5개마다 광고 표시
    return count % _adShowInterval == 0;
  }

  /// 전면 광고 표시
  /// 광고가 준비되어 있으면 표시하고, 그렇지 않으면 스킵
  Future<void> showInterstitialAd() async {
    if (_isInterstitialAdReady && _interstitialAd != null) {
      if (kDebugMode) {
        debugPrint('[AdService] Showing interstitial ad');
      }
      await _interstitialAd!.show();
    } else {
      if (kDebugMode) {
        debugPrint('[AdService] Interstitial ad not ready, skipping');
      }
    }
  }

  /// 기도 저장 시 호출 - 5개마다 전면 광고 표시
  Future<void> onPrayerSaved() async {
    final shouldShowAd = await incrementSaveCountAndCheckAd();
    if (shouldShowAd) {
      await showInterstitialAd();
    }
  }

  /// 전면 광고 로드 (외부에서 직접 사용할 경우)
  Future<InterstitialAd?> loadInterstitialAd({
    required void Function(InterstitialAd) onAdLoaded,
    required void Function(LoadAdError) onAdFailedToLoad,
  }) async {
    InterstitialAd? interstitialAd;

    await InterstitialAd.load(
      adUnitId: interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          interstitialAd = ad;
          onAdLoaded(ad);
          if (kDebugMode) {
            debugPrint('[AdService] Interstitial ad loaded');
          }
        },
        onAdFailedToLoad: (error) {
          onAdFailedToLoad(error);
          if (kDebugMode) {
            debugPrint('[AdService] Interstitial ad failed to load: $error');
          }
        },
      ),
    );

    return interstitialAd;
  }
}
