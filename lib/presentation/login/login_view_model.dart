import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../data/services/auth_service.dart';
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
  return LoginViewModel(authService);
});

/// Login ViewModel
class LoginViewModel extends StateNotifier<LoginState> {
  final AuthService _authService;

  LoginViewModel(this._authService) : super(const LoginState());

  Future<void> signInWithGoogle() async {
    if (state.isLoading) return;

    state = state.copyWith(isLoading: true, errorMessage: '');

    try {
      final response = await _authService.signInWithGoogle();

      if (response != null && response.user != null) {
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
