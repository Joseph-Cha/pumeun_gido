import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/config/app_config.dart';
import '../../data/services/auth_service.dart';
import '../../core/di/providers.dart';

/// Splash 상태
enum SplashStatus { loading, authenticated, unauthenticated }

/// Splash ViewModel Provider
final splashViewModelProvider =
    StateNotifierProvider.autoDispose<SplashViewModel, SplashStatus>((ref) {
  final authService = ref.watch(authServiceProvider);
  return SplashViewModel(authService);
});

/// Splash ViewModel
class SplashViewModel extends StateNotifier<SplashStatus> {
  final AuthService _authService;

  SplashViewModel(this._authService) : super(SplashStatus.loading) {
    _checkAuthAndNavigate();
  }

  Future<void> _checkAuthAndNavigate() async {
    // 최소 스플래시 표시 시간
    await Future.delayed(AppConfig.splashDuration);

    try {
      final isLoggedIn = await _authService.checkAutoLogin();
      state =
          isLoggedIn ? SplashStatus.authenticated : SplashStatus.unauthenticated;
    } catch (e) {
      state = SplashStatus.unauthenticated;
    }
  }
}
