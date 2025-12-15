import 'package:firebase_analytics/firebase_analytics.dart';

/// Analytics 서비스
/// Firebase Analytics를 통한 이벤트 추적
class AnalyticsService {
  static final AnalyticsService _instance = AnalyticsService._internal();
  factory AnalyticsService() => _instance;
  AnalyticsService._internal();

  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  /// FirebaseAnalyticsObserver (GoRouter와 함께 사용)
  FirebaseAnalyticsObserver get observer =>
      FirebaseAnalyticsObserver(analytics: _analytics);

  // ==================== 화면 추적 ====================

  /// 화면 조회 이벤트
  Future<void> logScreenView({
    required String screenName,
    String? screenClass,
  }) async {
    await _analytics.logScreenView(
      screenName: screenName,
      screenClass: screenClass,
    );
  }

  // ==================== 인증 이벤트 ====================

  /// 로그인 이벤트
  Future<void> logLogin({required String method}) async {
    await _analytics.logLogin(loginMethod: method);
  }

  /// 회원가입 이벤트
  Future<void> logSignUp({required String method}) async {
    await _analytics.logSignUp(signUpMethod: method);
  }

  /// 로그아웃 이벤트
  Future<void> logLogout() async {
    await _analytics.logEvent(name: 'logout');
  }

  /// 회원탈퇴 이벤트
  Future<void> logDeleteAccount() async {
    await _analytics.logEvent(name: 'delete_account');
  }

  // ==================== 기도 관련 이벤트 ====================

  /// 기도 제목 생성
  Future<void> logCreatePrayer({String? category}) async {
    await _analytics.logEvent(
      name: 'create_prayer',
      parameters: {
        if (category != null) 'category': category,
      },
    );
  }

  /// 기도 제목 수정
  Future<void> logUpdatePrayer() async {
    await _analytics.logEvent(name: 'update_prayer');
  }

  /// 기도 제목 삭제
  Future<void> logDeletePrayer() async {
    await _analytics.logEvent(name: 'delete_prayer');
  }

  /// 기도 응답 처리
  Future<void> logAnswerPrayer() async {
    await _analytics.logEvent(name: 'answer_prayer');
  }

  /// 기도 상태 변경 (응답됨 → 기도중)
  Future<void> logRevertPrayer() async {
    await _analytics.logEvent(name: 'revert_prayer');
  }

  // ==================== 기도 요청자 관련 이벤트 ====================

  /// 기도 요청자 추가
  Future<void> logCreateRequester() async {
    await _analytics.logEvent(name: 'create_requester');
  }

  /// 기도 요청자 수정
  Future<void> logUpdateRequester() async {
    await _analytics.logEvent(name: 'update_requester');
  }

  /// 기도 요청자 삭제
  Future<void> logDeleteRequester() async {
    await _analytics.logEvent(name: 'delete_requester');
  }

  // ==================== 사용자 속성 ====================

  /// 사용자 ID 설정
  Future<void> setUserId(String? userId) async {
    await _analytics.setUserId(id: userId);
  }

  /// 사용자 속성 설정
  Future<void> setUserProperty({
    required String name,
    required String? value,
  }) async {
    await _analytics.setUserProperty(name: name, value: value);
  }

  // ==================== 커스텀 이벤트 ====================

  /// 커스텀 이벤트 로깅
  Future<void> logCustomEvent({
    required String name,
    Map<String, Object>? parameters,
  }) async {
    await _analytics.logEvent(
      name: name,
      parameters: parameters,
    );
  }
}
