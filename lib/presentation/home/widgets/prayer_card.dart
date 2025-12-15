import 'package:flutter/material.dart';
import '../../../core/config/theme/app_colors.dart';
import '../../../core/config/theme/app_text_styles.dart';
import '../../../data/models/prayer_request_model.dart';
import '../../../shared/utils/date_utils.dart';

/// 기도 카드 위젯
class PrayerCard extends StatelessWidget {
  final PrayerRequestModel prayer;
  final VoidCallback? onTap;
  final VoidCallback? onStatusToggle;

  const PrayerCard({
    super.key,
    required this.prayer,
    this.onTap,
    this.onStatusToggle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: prayer.isAnswered
                ? AppColors.answered.withValues(alpha: 0.3)
                : AppColors.borderLight,
            width: prayer.isAnswered ? 1.5 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 12),
            _buildContent(),
            const SizedBox(height: 12),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: prayer.isAnswered
                ? AppColors.answeredBackground
                : AppColors.secondaryLight,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              prayer.requesterName.isNotEmpty
                  ? prayer.requesterName[0]
                  : '?',
              style: AppTextStyles.titleMedium.copyWith(
                color: prayer.isAnswered
                    ? AppColors.answered
                    : AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            prayer.requesterName,
            style: AppTextStyles.requesterName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        _buildStatusButton(),
      ],
    );
  }

  Widget _buildStatusButton() {
    return GestureDetector(
      onTap: onStatusToggle,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: prayer.isAnswered
              ? AppColors.answeredBackground
              : AppColors.prayingBackground,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: prayer.isAnswered
                ? AppColors.answered.withValues(alpha: 0.3)
                : AppColors.praying.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              prayer.isAnswered
                  ? Icons.check_circle_rounded
                  : Icons.favorite_rounded,
              size: 14,
              color: prayer.isAnswered
                  ? AppColors.answered
                  : AppColors.praying,
            ),
            const SizedBox(width: 4),
            Text(
              prayer.status.label,
              style: AppTextStyles.labelSmall.copyWith(
                color: prayer.isAnswered
                    ? AppColors.answered
                    : AppColors.praying,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Text(
      prayer.content,
      style: AppTextStyles.bodyMedium.copyWith(
        color: prayer.isAnswered
            ? AppColors.textSecondary
            : AppColors.textPrimary,
        height: 1.5,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildFooter() {
    return Row(
      children: [
        Icon(
          Icons.schedule_rounded,
          size: 14,
          color: AppColors.textTertiary,
        ),
        const SizedBox(width: 4),
        Text(
          AppDateUtils.formatRelative(prayer.createdAt),
          style: AppTextStyles.caption,
        ),
        if (prayer.isAnswered && prayer.answeredAt != null) ...[
          const SizedBox(width: 12),
          Icon(
            Icons.check_rounded,
            size: 14,
            color: AppColors.answered,
          ),
          const SizedBox(width: 4),
          Text(
            '${prayer.daysToAnswer}일만에 응답',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.answered,
            ),
          ),
        ],
        const Spacer(),
        if (prayer.category != PrayerCategory.general)
          _buildCategoryChip(),
      ],
    );
  }

  Widget _buildCategoryChip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: _getCategoryColor().withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        prayer.category.label,
        style: AppTextStyles.overline.copyWith(
          color: _getCategoryColor(),
          fontSize: 10,
        ),
      ),
    );
  }

  Color _getCategoryColor() {
    switch (prayer.category) {
      case PrayerCategory.health:
        return AppColors.categoryHealth;
      case PrayerCategory.career:
        return AppColors.categoryCareer;
      case PrayerCategory.family:
        return AppColors.categoryFamily;
      case PrayerCategory.relationship:
        return AppColors.categoryRelationship;
      case PrayerCategory.faith:
        return AppColors.categoryFaith;
      case PrayerCategory.other:
        return AppColors.categoryOther;
      default:
        return AppColors.categoryGeneral;
    }
  }
}
