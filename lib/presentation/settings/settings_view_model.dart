import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../data/models/user_model.dart';
import '../../data/services/auth_service.dart';
import '../../core/di/providers.dart';

part 'settings_view_model.freezed.dart';

/// Settings 상태
@freezed
class SettingsState with _$SettingsState {
  const factory SettingsState({
    @Default(false) bool isLoading,
    @Default(false) bool isLoggedOut,
    @Default(false) bool isAccountDeleted,
    @Default('') String errorMessage,
  }) = _SettingsState;
}

/// Settings ViewModel Provider
final settingsViewModelProvider =
    StateNotifierProvider.autoDispose<SettingsViewModel, SettingsState>((ref) {
  final authService = ref.watch(authServiceProvider);
  return SettingsViewModel(authService);
});

/// Settings ViewModel
class SettingsViewModel extends StateNotifier<SettingsState> {
  final AuthService _authService;

  SettingsViewModel(this._authService) : super(const SettingsState());

  UserModel? get currentUser => _authService.currentUser;

  Future<void> logout() async {
    state = state.copyWith(isLoading: true);
    try {
      await _authService.signOut();
      state = state.copyWith(isLoading: false, isLoggedOut: true);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: '로그아웃에 실패했어요');
    }
  }

  Future<void> deleteAccount() async {
    state = state.copyWith(isLoading: true);
    try {
      await _authService.deleteAccount();
      state = state.copyWith(isLoading: false, isAccountDeleted: true);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: '탈퇴 처리에 실패했어요');
    }
  }
}
