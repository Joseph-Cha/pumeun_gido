import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/config/theme/app_colors.dart';
import '../../core/config/theme/app_text_styles.dart';
import '../../core/router/app_router.dart';
import '../../data/models/user_model.dart';
import 'settings_view_model.dart';

/// 설정 화면
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(settingsViewModelProvider);
    final viewModel = ref.read(settingsViewModelProvider.notifier);

    ref.listen<SettingsState>(settingsViewModelProvider, (previous, next) {
      if (next.isLoggedOut || next.isAccountDeleted) {
        context.go(AppRoutes.login);
      } else if (next.errorMessage.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage),
            backgroundColor: Colors.red.shade400,
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(16),
          ),
        );
      }
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildProfileSection(viewModel.currentUser),
                  const SizedBox(height: 24),
                  _buildSection(
                    title: '계정',
                    children: [
                      _buildMenuItem(
                        icon: Icons.logout_rounded,
                        title: '로그아웃',
                        onTap: () => _showLogoutDialog(context, viewModel),
                      ),
                      _buildMenuItem(
                        icon: Icons.person_remove_outlined,
                        title: '회원 탈퇴',
                        onTap: () => _showDeleteAccountDialog(context, viewModel),
                        isDestructive: true,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _buildSection(
                    title: '정보',
                    children: [
                      _buildMenuItem(
                        icon: Icons.info_outline_rounded,
                        title: '앱 정보',
                        onTap: () => _showAppInfo(context),
                      ),
                      _buildMenuItem(
                        icon: Icons.privacy_tip_outlined,
                        title: '개인정보처리방침',
                        onTap: () => _openUrl('https://example.com/privacy'),
                        showArrow: true,
                      ),
                      _buildMenuItem(
                        icon: Icons.description_outlined,
                        title: '이용약관',
                        onTap: () => _openUrl('https://example.com/terms'),
                        showArrow: true,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _buildSection(
                    title: '지원',
                    children: [
                      _buildMenuItem(
                        icon: Icons.mail_outline_rounded,
                        title: '문의하기',
                        onTap: () => _openUrl('mailto:support@example.com'),
                        showArrow: true,
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  Center(
                    child: Text(
                      '품은기도 v1.0.0',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.background,
      title: Text(
        '설정',
        style: AppTextStyles.headlineSmall,
      ),
    );
  }

  Widget _buildProfileSection(UserModel? user) {

    return Container(
      margin: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppColors.secondaryLight,
              borderRadius: BorderRadius.circular(16),
              image: user?.profileImageUrl != null
                  ? DecorationImage(
                      image: NetworkImage(user!.profileImageUrl!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: user?.profileImageUrl == null
                ? Center(
                    child: Text(
                      user?.name.isNotEmpty == true ? user!.name[0] : '?',
                      style: AppTextStyles.headlineMedium.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user?.name ?? '사용자',
                  style: AppTextStyles.titleLarge.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  user?.email ?? '',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textTertiary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            title,
            style: AppTextStyles.labelMedium.copyWith(
              color: AppColors.textTertiary,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.borderLight),
          ),
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool showArrow = false,
    bool isDestructive = false,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Icon(
                icon,
                size: 22,
                color: isDestructive
                    ? Colors.red.shade400
                    : AppColors.textSecondary,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: isDestructive
                        ? Colors.red.shade400
                        : AppColors.textPrimary,
                  ),
                ),
              ),
              if (showArrow)
                Icon(
                  Icons.chevron_right_rounded,
                  size: 22,
                  color: AppColors.textTertiary,
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, SettingsViewModel viewModel) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('로그아웃'),
        content: const Text('로그아웃 하시겠어요?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              viewModel.logout();
            },
            child: const Text('로그아웃'),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog(
      BuildContext context, SettingsViewModel viewModel) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('회원 탈퇴'),
        content: const Text('정말 탈퇴하시겠어요?\n모든 데이터가 삭제되며 복구할 수 없습니다.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              viewModel.deleteAccount();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('탈퇴'),
          ),
        ],
      ),
    );
  }

  void _showAppInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('품은기도'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('버전: 1.0.0'),
            SizedBox(height: 8),
            Text('지인의 기도 제목을 마음에 품고 기도하는 앱입니다.'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }

  void _openUrl(String url) {
    // TODO: url_launcher 의존성 추가 후 구현
    debugPrint('Opening URL: $url');
  }
}
