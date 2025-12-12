import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/config/app_config.dart';

/// Supabase 서비스 (Riverpod 버전)
/// Supabase 클라이언트 초기화 및 관리
class SupabaseService {
  late final SupabaseClient _client;

  SupabaseClient get client => _client;

  /// 앱 시작 시 Supabase 초기화 (main.dart에서 호출)
  static Future<void> initialize() async {
    await Supabase.initialize(
      url: AppConfig.supabaseUrl,
      anonKey: AppConfig.supabaseAnonKey,
    );
  }

  /// 서비스 초기화
  Future<SupabaseService> init() async {
    _client = Supabase.instance.client;
    return this;
  }

  /// 현재 사용자 ID
  String? get currentUserId => _client.auth.currentUser?.id;

  /// 현재 사용자
  User? get currentUser => _client.auth.currentUser;

  /// 로그인 상태
  bool get isLoggedIn => currentUser != null;

  /// 세션
  Session? get currentSession => _client.auth.currentSession;

  /// Auth 상태 변경 스트림
  Stream<AuthState> get authStateChanges => _client.auth.onAuthStateChange;

  /// 테이블 참조
  SupabaseQueryBuilder from(String table) => _client.from(table);
}
