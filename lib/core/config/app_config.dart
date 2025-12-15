import 'package:flutter_dotenv/flutter_dotenv.dart';

/// 환경 타입
enum Environment {
  beta, // 개발/테스트 환경
  real, // 실제 배포 환경
}

/// 앱 설정
class AppConfig {
  AppConfig._();

  /// 현재 환경 (기본값: real)
  static Environment _currentEnv = Environment.real;

  /// 현재 환경 확인
  static Environment get currentEnvironment => _currentEnv;

  /// 베타 환경인지 확인
  static bool get isBeta => _currentEnv == Environment.beta;

  /// 리얼 환경인지 확인
  static bool get isReal => _currentEnv == Environment.real;

  /// 환경변수 로드
  /// [env] 파라미터로 환경을 지정할 수 있음 (기본값: real)
  static Future<void> loadEnv({Environment env = Environment.real}) async {
    _currentEnv = env;

    final fileName = switch (env) {
      Environment.beta => '.env.beta',
      Environment.real => '.env',
    };

    await dotenv.load(fileName: fileName);
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Supabase 설정 (환경변수에서 로드)
  // ─────────────────────────────────────────────────────────────────────────

  static String get supabaseUrl => dotenv.env['SUPABASE_URL'] ?? '';
  static String get supabaseAnonKey => dotenv.env['SUPABASE_ANON_KEY'] ?? '';

  // ─────────────────────────────────────────────────────────────────────────
  // Google OAuth 설정 (환경변수에서 로드)
  // ─────────────────────────────────────────────────────────────────────────

  static String get googleWebClientId =>
      dotenv.env['GOOGLE_WEB_CLIENT_ID'] ?? '';
  static String get googleIosClientId =>
      dotenv.env['GOOGLE_IOS_CLIENT_ID'] ?? '';

  // ─────────────────────────────────────────────────────────────────────────
  // AdMob 설정 (환경변수에서 로드)
  // ─────────────────────────────────────────────────────────────────────────

  /// Android 배너 광고 ID
  static String get admobAndroidBannerId =>
      dotenv.env['ADMOB_ANDROID_BANNER_ID'] ?? '';

  /// Android 전면 광고 ID
  static String get admobAndroidInterstitialId =>
      dotenv.env['ADMOB_ANDROID_INTERSTITIAL_ID'] ?? '';

  /// iOS 배너 광고 ID
  static String get admobIosBannerId =>
      dotenv.env['ADMOB_IOS_BANNER_ID'] ?? '';

  /// iOS 전면 광고 ID
  static String get admobIosInterstitialId =>
      dotenv.env['ADMOB_IOS_INTERSTITIAL_ID'] ?? '';

  // ─────────────────────────────────────────────────────────────────────────
  // Firebase 설정 (환경변수에서 로드)
  // ─────────────────────────────────────────────────────────────────────────

  /// Firebase Android API 키
  static String get firebaseAndroidApiKey =>
      dotenv.env['FIREBASE_ANDROID_API_KEY'] ?? '';

  /// Firebase iOS API 키
  static String get firebaseIosApiKey =>
      dotenv.env['FIREBASE_IOS_API_KEY'] ?? '';

  // ─────────────────────────────────────────────────────────────────────────
  // 앱 정보
  // ─────────────────────────────────────────────────────────────────────────

  static const String appName = '품은기도';
  static const String appVersion = '1.0.0';

  // ─────────────────────────────────────────────────────────────────────────
  // 페이지네이션
  // ─────────────────────────────────────────────────────────────────────────

  static const int defaultPageSize = 20;

  // ─────────────────────────────────────────────────────────────────────────
  // 입력 제한
  // ─────────────────────────────────────────────────────────────────────────

  static const int maxPrayerContentLength = 2000;
  static const int maxMemoLength = 1000;
  static const int maxRequesterNameLength = 50;
  static const int maxTitleLength = 100;

  // ─────────────────────────────────────────────────────────────────────────
  // 타임아웃
  // ─────────────────────────────────────────────────────────────────────────

  static const Duration apiTimeout = Duration(seconds: 30);
  static const Duration splashDuration = Duration(milliseconds: 1500);

  // ─────────────────────────────────────────────────────────────────────────
  // 애니메이션
  // ─────────────────────────────────────────────────────────────────────────

  static const Duration animationFast = Duration(milliseconds: 200);
  static const Duration animationNormal = Duration(milliseconds: 300);
  static const Duration animationSlow = Duration(milliseconds: 500);
}
