import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../data/models/user_model.dart';
import '../../data/services/auth_service.dart';
import '../../data/services/analytics_service.dart';
import '../../core/di/providers.dart';

part 'settings_view_model.freezed.dart';

/// Settings 상태
@freezed
class SettingsState with _$SettingsState {
  const factory SettingsState({
    @Default(false) bool isLoading,
    @Default(false) bool isLoggedOut,
    @Default(false) bool isAccountDeleted,
    @Default(false) bool isNameUpdated,
    @Default('') String errorMessage,
    @Default('') String successMessage,
  }) = _SettingsState;
}

/// Settings ViewModel Provider
final settingsViewModelProvider =
    StateNotifierProvider.autoDispose<SettingsViewModel, SettingsState>((ref) {
  final authService = ref.watch(authServiceProvider);
  final analyticsService = ref.watch(analyticsServiceProvider);
  return SettingsViewModel(authService, analyticsService);
});

/// Settings ViewModel
class SettingsViewModel extends StateNotifier<SettingsState> {
  final AuthService _authService;
  final AnalyticsService _analyticsService;

  SettingsViewModel(this._authService, this._analyticsService) : super(const SettingsState());

  UserModel? get currentUser => _authService.currentUser;

  Future<void> logout() async {
    state = state.copyWith(isLoading: true);
    try {
      // Analytics: 로그아웃 이벤트
      _analyticsService.logLogout();
      _analyticsService.setUserId(null);

      await _authService.signOut();
      state = state.copyWith(isLoading: false, isLoggedOut: true);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: '로그아웃에 실패했어요');
    }
  }

  Future<void> deleteAccount() async {
    state = state.copyWith(isLoading: true);
    try {
      // Analytics: 회원탈퇴 이벤트
      _analyticsService.logDeleteAccount();
      _analyticsService.setUserId(null);

      await _authService.deleteAccount();
      state = state.copyWith(isLoading: false, isAccountDeleted: true);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: '탈퇴 처리에 실패했어요');
    }
  }

  Future<void> updateName(String newName) async {
    if (newName.trim().isEmpty) {
      state = state.copyWith(errorMessage: '이름을 입력해주세요');
      return;
    }

    state = state.copyWith(isLoading: true, errorMessage: '', successMessage: '');
    try {
      await _authService.updateUserName(newName.trim());
      state = state.copyWith(
        isLoading: false,
        isNameUpdated: true,
        successMessage: '이름이 변경되었어요',
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: '이름 변경에 실패했어요',
      );
    }
  }

  void resetNameUpdatedFlag() {
    state = state.copyWith(isNameUpdated: false, successMessage: '');
  }
}
