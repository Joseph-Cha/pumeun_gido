import 'package:flutter/material.dart';
import '../../core/config/theme/app_colors.dart';
import '../../core/config/theme/app_text_styles.dart';

/// 빈 상태 위젯
class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;

  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.actionLabel,
    this.onAction,
  });

  /// 기도 목록 빈 상태
  factory EmptyState.prayers({VoidCallback? onAction}) {
    return EmptyState(
      icon: Icons.volunteer_activism_rounded,
      title: '아직 등록된 기도 제목이 없어요',
      subtitle: '첫 기도 제목을 추가해보세요',
      actionLabel: '기도 제목 추가하기',
      onAction: onAction,
    );
  }

  /// 기도 중 필터 빈 상태
  factory EmptyState.praying() {
    return const EmptyState(
      icon: Icons.favorite_border_rounded,
      title: '기도 중인 제목이 없어요',
      subtitle: '모든 기도가 응답되었거나\n새로운 기도 제목을 추가해보세요',
    );
  }

  /// 응답됨 필터 빈 상태
  factory EmptyState.answered() {
    return const EmptyState(
      icon: Icons.check_circle_outline_rounded,
      title: '응답된 기도가 없어요',
      subtitle: '기도가 응답되면 여기에 표시됩니다',
    );
  }

  /// 검색 결과 빈 상태
  factory EmptyState.searchResult({
    required String query,
    VoidCallback? onClear,
  }) {
    return EmptyState(
      icon: Icons.search_off_rounded,
      title: "'$query'에 대한 결과가 없어요",
      subtitle: '다른 검색어로 시도해보세요',
      actionLabel: '전체 목록 보기',
      onAction: onClear,
    );
  }

  /// 사람 목록 빈 상태
  factory EmptyState.people() {
    return const EmptyState(
      icon: Icons.people_outline_rounded,
      title: '아직 등록된 분이 없어요',
      subtitle: '기도 제목을 추가하면\n자동으로 등록돼요',
    );
  }

  /// 오류 상태
  factory EmptyState.error({
    required String message,
    VoidCallback? onRetry,
  }) {
    return EmptyState(
      icon: Icons.error_outline_rounded,
      title: message,
      actionLabel: '다시 시도',
      onAction: onRetry,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 아이콘
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.secondaryLight,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Icon(
                icon,
                size: 40,
                color: AppColors.primary.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: 24),
            // 제목
            Text(
              title,
              style: AppTextStyles.titleLarge.copyWith(
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            // 부제
            if (subtitle != null) ...[
              const SizedBox(height: 8),
              Text(
                subtitle!,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textTertiary,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            // 액션 버튼
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 24),
              TextButton(
                onPressed: onAction,
                style: TextButton.styleFrom(
                  backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  actionLabel!,
                  style: AppTextStyles.buttonMedium.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
