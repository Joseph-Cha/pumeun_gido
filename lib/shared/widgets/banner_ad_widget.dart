import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../data/services/ad_service.dart';

/// 배너 광고 위젯
class BannerAdWidget extends StatefulWidget {
  const BannerAdWidget({super.key});

  @override
  State<BannerAdWidget> createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends State<BannerAdWidget> {
  BannerAd? _bannerAd;
  bool _isLoaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadAd();
  }

  Future<void> _loadAd() async {
    // 이미 로드되었으면 스킵
    if (_bannerAd != null) return;

    final width = MediaQuery.of(context).size.width;
    final adSize = await AdService().getAdaptiveBannerAdSize(width);

    if (adSize == null) {
      debugPrint('[BannerAdWidget] Failed to get ad size');
      return;
    }

    _bannerAd = AdService().createBannerAd(
      adSize: adSize,
      onAdLoaded: (ad) {
        if (mounted) {
          setState(() {
            _isLoaded = true;
          });
        }
      },
      onAdFailedToLoad: (ad, error) {
        debugPrint('[BannerAdWidget] Ad failed to load: $error');
        ad.dispose();
        if (mounted) {
          setState(() {
            _bannerAd = null;
            _isLoaded = false;
          });
        }
      },
    );

    _bannerAd?.load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLoaded || _bannerAd == null) {
      return const SizedBox.shrink();
    }

    return Container(
      width: _bannerAd!.size.width.toDouble(),
      height: _bannerAd!.size.height.toDouble(),
      alignment: Alignment.center,
      child: AdWidget(ad: _bannerAd!),
    );
  }
}
