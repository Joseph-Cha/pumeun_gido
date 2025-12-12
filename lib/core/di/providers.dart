import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/services/supabase_service.dart';
import '../../data/services/auth_service.dart';
import '../../data/models/user_model.dart';

/// Supabase Service Provider
/// main.dart에서 override되어 초기화된 인스턴스가 주입됨
final supabaseServiceProvider = Provider<SupabaseService>((ref) {
  throw UnimplementedError(
    'supabaseServiceProvider는 main.dart에서 override되어야 합니다',
  );
});

/// Auth Service Provider
final authServiceProvider = Provider<AuthService>((ref) {
  final supabaseService = ref.watch(supabaseServiceProvider);
  final authService = AuthService(supabaseService);

  ref.onDispose(() {
    authService.dispose();
  });

  return authService;
});

/// 현재 사용자 상태 Provider
final currentUserProvider = StreamProvider<UserModel?>((ref) {
  final authService = ref.watch(authServiceProvider);
  return authService.currentUserStream;
});

/// 로그인 상태 Provider
final isLoggedInProvider = Provider<bool>((ref) {
  final authService = ref.watch(authServiceProvider);
  return authService.isLoggedIn;
});
