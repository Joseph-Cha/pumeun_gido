import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/config/theme/app_colors.dart';
import '../../core/config/theme/app_text_styles.dart';
import '../../core/router/app_router.dart';
import '../../shared/utils/date_utils.dart';
import 'prayer_view_model.dart';

/// 기도 제목 상세 화면
class PrayerDetailScreen extends ConsumerWidget {
  final String prayerId;

  const PrayerDetailScreen({super.key, required this.prayerId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(prayerViewModelProvider(prayerId));
    final viewModel = ref.read(prayerViewModelProvider(prayerId).notifier);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        context.pop(state.hasChanges);
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: _buildAppBar(context, state, viewModel),
        body: state.isLoading
            ? const Center(child: CircularProgressIndicator())
            : state.prayer == null
                ? const Center(child: Text('기도 제목을 찾을 수 없습니다'))
                : _buildBody(context, state, viewModel),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(
    BuildContext context,
    PrayerState state,
    PrayerViewModel viewModel,
  ) {
    return AppBar(
      backgroundColor: AppColors.background,
      title: const Text('기도 제목'),
      leading: IconButton(
        onPressed: () => context.pop(state.hasChanges),
        icon: const Icon(Icons.arrow_back),
      ),
      actions: [
        IconButton(
          onPressed: () async {
            final result = await context.push<bool>(
              AppRoutes.prayerForm,
              extra: prayerId,
            );
            if (result == true) {
              viewModel.loadPrayer(prayerId);
            }
          },
          icon: const Icon(Icons.edit_outlined),
          tooltip: '수정',
        ),
        IconButton(
          onPressed: () => _showDeleteDialog(context, viewModel),
          icon: const Icon(Icons.delete_outline_rounded),
          tooltip: '삭제',
        ),
        const SizedBox(width: 4),
      ],
    );
  }

  Widget _buildBody(
    BuildContext context,
    PrayerState state,
    PrayerViewModel viewModel,
  ) {
    final prayer = state.prayer!;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStatusBanner(prayer),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildRequesterInfo(prayer),
                const SizedBox(height: 20),
                _buildContent(prayer),
                if (prayer.memo != null && prayer.memo!.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  _buildMemo(prayer),
                ],
                const SizedBox(height: 24),
                _buildDateInfo(prayer),
                const SizedBox(height: 32),
                _buildStatusToggleButton(context, prayer, viewModel),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBanner(prayer) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      color: prayer.isAnswered
          ? AppColors.answeredBackground
          : AppColors.prayingBackground,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            prayer.isAnswered
                ? Icons.check_circle_rounded
                : Icons.favorite_rounded,
            size: 18,
            color: prayer.isAnswered ? AppColors.answered : AppColors.praying,
          ),
          const SizedBox(width: 8),
          Text(
            prayer.isAnswered ? '응답된 기도입니다' : '기도 중입니다',
            style: AppTextStyles.labelMedium.copyWith(
              color:
                  prayer.isAnswered ? AppColors.answered : AppColors.praying,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (prayer.isAnswered && prayer.daysToAnswer != null) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.answered.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '${prayer.daysToAnswer}일',
                style: AppTextStyles.overline.copyWith(
                  color: AppColors.answered,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRequesterInfo(prayer) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.secondaryLight,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Center(
            child: Text(
              prayer.requesterName.isNotEmpty ? prayer.requesterName[0] : '?',
              style: AppTextStyles.headlineSmall.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                prayer.requesterName,
                style: AppTextStyles.titleLarge.copyWith(
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                prayer.category.label,
                style: AppTextStyles.labelSmall.copyWith(
                  color: AppColors.textTertiary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildContent(prayer) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Text(
        prayer.content,
        style: AppTextStyles.prayerContent.copyWith(
          color:
              prayer.isAnswered ? AppColors.textSecondary : AppColors.textPrimary,
        ),
      ),
    );
  }

  Widget _buildMemo(prayer) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.note_outlined,
              size: 18,
              color: AppColors.textTertiary,
            ),
            const SizedBox(width: 6),
            Text(
              '메모',
              style: AppTextStyles.labelMedium.copyWith(
                color: AppColors.textTertiary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surfaceVariant,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            prayer.memo!,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateInfo(prayer) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          _buildDateRow(
            icon: Icons.add_circle_outline_rounded,
            label: '등록일',
            date: AppDateUtils.formatFull(prayer.createdAt),
            subtext: '${prayer.daysSinceCreated}일 전',
          ),
          if (prayer.isAnswered && prayer.answeredAt != null) ...[
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Divider(height: 1),
            ),
            _buildDateRow(
              icon: Icons.check_circle_outline_rounded,
              label: '응답일',
              date: AppDateUtils.formatFull(prayer.answeredAt!),
              subtext: '${prayer.daysToAnswer}일만에 응답',
              iconColor: AppColors.answered,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDateRow({
    required IconData icon,
    required String label,
    required String date,
    required String subtext,
    Color? iconColor,
  }) {
    return Row(
      children: [
        Icon(icon, size: 20, color: iconColor ?? AppColors.textTertiary),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textTertiary,
              ),
            ),
            Text(
              date,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        const Spacer(),
        Text(
          subtext,
          style: AppTextStyles.labelSmall.copyWith(
            color: iconColor ?? AppColors.textTertiary,
          ),
        ),
      ],
    );
  }

  Widget _buildStatusToggleButton(
    BuildContext context,
    prayer,
    PrayerViewModel viewModel,
  ) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: () async {
          final isAnswered = await viewModel.toggleStatus();
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  isAnswered ? '기도가 응답되었어요!' : '다시 기도 중으로 변경했어요',
                ),
                behavior: SnackBarBehavior.floating,
                margin: const EdgeInsets.all(16),
              ),
            );
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor:
              prayer.isAnswered ? AppColors.praying : AppColors.answered,
          foregroundColor: AppColors.textOnPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              prayer.isAnswered
                  ? Icons.replay_rounded
                  : Icons.check_circle_rounded,
              size: 22,
            ),
            const SizedBox(width: 8),
            Text(
              prayer.isAnswered ? '다시 기도하기' : '응답됨으로 변경',
              style: AppTextStyles.buttonLarge,
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, PrayerViewModel viewModel) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('기도 제목 삭제'),
        content: const Text('이 기도 제목을 삭제할까요?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              final success = await viewModel.delete();
              if (success && context.mounted) {
                context.pop(true);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('기도 제목이 삭제되었어요'),
                    behavior: SnackBarBehavior.floating,
                    margin: EdgeInsets.all(16),
                  ),
                );
              }
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('삭제'),
          ),
        ],
      ),
    );
  }
}
