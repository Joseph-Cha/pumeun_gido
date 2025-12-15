import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../data/services/auth_service.dart';
import '../../data/services/analytics_service.dart';
import '../../core/di/providers.dart';

part 'login_view_model.freezed.dart';

/// Login 상태
@freezed
class LoginState with _$LoginState {
  const factory LoginState({
    @Default(false) bool isLoading,
    @Default('') String errorMessage,
    @Default(false) bool isSuccess,
  }) = _LoginState;
}

/// Login ViewModel Provider
final loginViewModelProvider =
    StateNotifierProvider.autoDispose<LoginViewModel, LoginState>((ref) {
  final authService = ref.watch(authServiceProvider);
  final analyticsService = ref.watch(analyticsServiceProvider);
  return LoginViewModel(authService, analyticsService);
});

/// Login ViewModel
class LoginViewModel extends StateNotifier<LoginState> {
  final AuthService _authService;
  final AnalyticsService _analyticsService;

  LoginViewModel(this._authService, this._analyticsService) : super(const LoginState());

  Future<void> signInWithGoogle() async {
    if (state.isLoading) return;

    state = state.copyWith(isLoading: true, errorMessage: '');

    try {
      final response = await _authService.signInWithGoogle();

      if (response != null && response.user != null) {
        // Analytics: 로그인 이벤트
        _analyticsService.logLogin(method: 'google');
        _analyticsService.setUserId(response.user!.id);
        state = state.copyWith(isLoading: false, isSuccess: true);
      } else {
        state = state.copyWith(isLoading: false);
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: '로그인에 실패했어요. 다시 시도해주세요.',
      );
    }
  }

  Future<void> signInWithApple() async {
    if (state.isLoading) return;

    state = state.copyWith(isLoading: true, errorMessage: '');

    try {
      final response = await _authService.signInWithApple();

      if (response != null && response.user != null) {
        // Analytics: 로그인 이벤트
        _analyticsService.logLogin(method: 'apple');
        _analyticsService.setUserId(response.user!.id);
        state = state.copyWith(isLoading: false, isSuccess: true);
      } else {
        state = state.copyWith(isLoading: false);
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: '로그인에 실패했어요. 다시 시도해주세요.',
      );
    }
  }
}
