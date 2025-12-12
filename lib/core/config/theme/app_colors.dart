import 'package:flutter/material.dart';

/// 품은기도 앱 컬러 팔레트
/// 컨셉: "고요한 성소" - 따뜻하고 절제된 영성
class AppColors {
  AppColors._();

  // Primary Colors - 따뜻한 브라운 계열
  static const Color primary = Color(0xFF8B7355);
  static const Color primaryLight = Color(0xFFB09A7D);
  static const Color primaryDark = Color(0xFF5E4D3A);

  // Secondary Colors - 크림 베이지 계열 (한지 느낌)
  static const Color secondary = Color(0xFFE8DDD4);
  static const Color secondaryLight = Color(0xFFF5F0EB);
  static const Color secondaryDark = Color(0xFFD4C4B5);

  // Accent Color - 골드 브라운 (촛불, 희망)
  static const Color accent = Color(0xFFC4956A);
  static const Color accentLight = Color(0xFFDDB892);
  static const Color accentDark = Color(0xFF9A7350);

  // Background Colors
  static const Color background = Color(0xFFFAF8F5);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF5F2EE);

  // Text Colors
  static const Color textPrimary = Color(0xFF3D3D3D);
  static const Color textSecondary = Color(0xFF6B6B6B);
  static const Color textTertiary = Color(0xFF9B9B9B);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // Status Colors
  static const Color success = Color(0xFF7A9E7E); // 세이지 그린 - 응답됨
  static const Color successLight = Color(0xFFE8F0E9);
  static const Color warning = Color(0xFFD4A574);
  static const Color warningLight = Color(0xFFFFF3E6);
  static const Color error = Color(0xFFBF6B6B);
  static const Color errorLight = Color(0xFFFCECEC);

  // Prayer Status Colors
  static const Color praying = Color(0xFFC4956A); // 기도 중
  static const Color prayingBackground = Color(0xFFFFF8F2);
  static const Color answered = Color(0xFF7A9E7E); // 응답됨
  static const Color answeredBackground = Color(0xFFF2F7F3);

  // Category Colors
  static const Color categoryGeneral = Color(0xFF8B7355);
  static const Color categoryHealth = Color(0xFF7A9E7E);
  static const Color categoryCareer = Color(0xFF6B8BA4);
  static const Color categoryFamily = Color(0xFFBF8B6B);
  static const Color categoryRelationship = Color(0xFFA4869E);
  static const Color categoryFaith = Color(0xFFC4956A);
  static const Color categoryOther = Color(0xFF9B9B9B);

  // Divider & Border
  static const Color divider = Color(0xFFE8E4E0);
  static const Color border = Color(0xFFDDD8D3);
  static const Color borderLight = Color(0xFFEEEAE5);

  // Shadow
  static const Color shadow = Color(0x1A8B7355);
  static const Color shadowDark = Color(0x338B7355);

  // Shimmer
  static const Color shimmerBase = Color(0xFFE8E4E0);
  static const Color shimmerHighlight = Color(0xFFF5F2EE);

  // Gradient for special elements
  static const LinearGradient warmGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFC4956A),
      Color(0xFF8B7355),
    ],
  );

  static const LinearGradient softGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFFFAF8F5),
      Color(0xFFE8DDD4),
    ],
  );
}
