import 'package:flutter/material.dart';
import '../../../core/config/theme/app_colors.dart';
import '../../../core/config/theme/app_text_styles.dart';
import '../../../data/models/prayer_request_model.dart';

/// 필터 탭 위젯 (스와이프 연동)
class FilterTabs extends StatelessWidget {
  final int currentIndex;
  final int prayingCount;
  final int answeredCount;
  final ValueChanged<int> onTabChanged;

  const FilterTabs({
    super.key,
    required this.currentIndex,
    required this.prayingCount,
    required this.answeredCount,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          _buildTab(
            label: '기도 중',
            count: prayingCount,
            isSelected: currentIndex == 0,
            onTap: () => onTabChanged(0),
            activeColor: AppColors.praying,
          ),
          _buildTab(
            label: '응답됨',
            count: answeredCount,
            isSelected: currentIndex == 1,
            onTap: () => onTabChanged(1),
            activeColor: AppColors.answered,
          ),
        ],
      ),
    );
  }

  Widget _buildTab({
    required String label,
    required int count,
    required bool isSelected,
    required VoidCallback onTap,
    Color? activeColor,
  }) {
    final color = activeColor ?? AppColors.primary;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(vertical: 4),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.surface : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AppColors.shadow.withValues(alpha: 0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  style: AppTextStyles.labelMedium.copyWith(
                    color: isSelected ? color : AppColors.textTertiary,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
                if (count > 0) ...[
                  const SizedBox(width: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? color.withValues(alpha: 0.15)
                          : AppColors.border.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      count > 99 ? '99+' : count.toString(),
                      style: AppTextStyles.overline.copyWith(
                        color: isSelected ? color : AppColors.textTertiary,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
