import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/config/theme/app_colors.dart';
import '../../core/config/theme/app_text_styles.dart';
import '../../core/router/app_router.dart';
import 'splash_view_model.dart';

/// 스플래시 화면
class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<SplashStatus>(splashViewModelProvider, (previous, next) {
      if (next == SplashStatus.authenticated) {
        context.go(AppRoutes.home);
      } else if (next == SplashStatus.unauthenticated) {
        context.go(AppRoutes.login);
      }
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.softGradient,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLogo(),
              const SizedBox(height: 24),
              _buildAppName(),
              const SizedBox(height: 8),
              _buildSlogan(),
              const SizedBox(height: 48),
              _buildLoadingIndicator(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: child,
        );
      },
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: const Center(
          child: Icon(
            Icons.volunteer_activism_rounded,
            size: 52,
            color: AppColors.accent,
          ),
        ),
      ),
    );
  }

  Widget _buildAppName() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - value)),
            child: child,
          ),
        );
      },
      child: Text(
        '품은기도',
        style: AppTextStyles.displayLarge.copyWith(
          color: AppColors.primary,
          letterSpacing: 2,
        ),
      ),
    );
  }

  Widget _buildSlogan() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: child,
        );
      },
      child: Text(
        '마음에 품은 기도를 함께',
        style: AppTextStyles.bodyLarge.copyWith(
          color: AppColors.textSecondary,
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: child,
        );
      },
      child: SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          valueColor: AlwaysStoppedAnimation<Color>(
            AppColors.accent.withValues(alpha: 0.7),
          ),
        ),
      ),
    );
  }
}
