import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/config/app_config.dart';
import '../../core/config/theme/app_colors.dart';
import '../../core/config/theme/app_text_styles.dart';
import '../../data/models/prayer_request_model.dart';
import 'prayer_view_model.dart';

/// 기도 제목 추가/수정 화면
class PrayerFormScreen extends ConsumerStatefulWidget {
  final String? prayerId;

  const PrayerFormScreen({super.key, this.prayerId});

  @override
  ConsumerState<PrayerFormScreen> createState() => _PrayerFormScreenState();
}

class _PrayerFormScreenState extends ConsumerState<PrayerFormScreen> {
  final TextEditingController _requesterNameController =
      TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _memoController = TextEditingController();

  @override
  void dispose() {
    _requesterNameController.dispose();
    _contentController.dispose();
    _memoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(prayerViewModelProvider(widget.prayerId));
    final viewModel =
        ref.read(prayerViewModelProvider(widget.prayerId).notifier);

    // 폼 초기화 (수정 모드)
    if (state.prayer != null && _contentController.text.isEmpty) {
      _requesterNameController.text = state.prayer!.requesterName;
      _contentController.text = state.prayer!.content;
      _memoController.text = state.prayer!.memo ?? '';
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(context, state, viewModel),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildForm(context, state, viewModel),
    );
  }

  PreferredSizeWidget _buildAppBar(
    BuildContext context,
    PrayerState state,
    PrayerViewModel viewModel,
  ) {
    return AppBar(
      backgroundColor: AppColors.background,
      title: Text(
        viewModel.isEditMode ? '기도 제목 수정' : '기도 제목 추가',
        style: AppTextStyles.headlineSmall,
      ),
      leading: IconButton(
        onPressed: () => context.pop(),
        icon: const Icon(Icons.close_rounded),
      ),
      actions: [
        TextButton(
          onPressed: state.isSaving ? null : () => _save(viewModel),
          child: state.isSaving
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(
                  '저장',
                  style: AppTextStyles.buttonMedium.copyWith(
                    color: AppColors.primary,
                  ),
                ),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildForm(
    BuildContext context,
    PrayerState state,
    PrayerViewModel viewModel,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildRequesterInput(state, viewModel),
          const SizedBox(height: 24),
          _buildContentInput(),
          const SizedBox(height: 24),
          _buildCategorySelector(state, viewModel),
          const SizedBox(height: 24),
          _buildMemoInput(),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildRequesterInput(PrayerState state, PrayerViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '누구를 위해 기도하나요?',
          style: AppTextStyles.titleMedium.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Autocomplete<String>(
          optionsBuilder: (TextEditingValue textEditingValue) {
            if (textEditingValue.text.isEmpty) {
              return state.requesters.map((r) => r.name);
            }
            return state.requesters
                .where((r) => r.name
                    .toLowerCase()
                    .contains(textEditingValue.text.toLowerCase()))
                .map((r) => r.name);
          },
          onSelected: (String selection) {
            final requester =
                state.requesters.where((r) => r.name == selection).firstOrNull;
            if (requester != null) {
              viewModel.selectRequester(requester);
              _requesterNameController.text = selection;
            }
          },
          fieldViewBuilder:
              (context, textController, focusNode, onFieldSubmitted) {
            if (textController.text != _requesterNameController.text) {
              textController.text = _requesterNameController.text;
              textController.selection = TextSelection.fromPosition(
                TextPosition(offset: textController.text.length),
              );
            }

            return TextField(
              controller: textController,
              focusNode: focusNode,
              onChanged: (value) {
                _requesterNameController.text = value;
              },
              decoration: InputDecoration(
                hintText: '이름을 입력하세요',
                prefixIcon: const Icon(Icons.person_outline_rounded),
                suffixIcon: state.selectedRequester != null
                    ? const Icon(Icons.check_circle_rounded,
                        color: AppColors.success)
                    : const SizedBox.shrink(),
              ),
              style: AppTextStyles.bodyLarge,
              maxLength: AppConfig.maxRequesterNameLength,
              buildCounter: (context,
                      {required currentLength,
                      required isFocused,
                      maxLength}) =>
                  null,
            );
          },
          optionsViewBuilder: (context, onSelected, options) {
            return Align(
              alignment: Alignment.topLeft,
              child: Material(
                elevation: 4,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: MediaQuery.of(context).size.width - 40,
                  constraints: const BoxConstraints(maxHeight: 200),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    shrinkWrap: true,
                    itemCount: options.length,
                    itemBuilder: (context, index) {
                      final option = options.elementAt(index);
                      return ListTile(
                        leading: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: AppColors.secondaryLight,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              option[0],
                              style: AppTextStyles.titleMedium.copyWith(
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ),
                        title: Text(option, style: AppTextStyles.bodyMedium),
                        onTap: () => onSelected(option),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 4,
                        ),
                      );
                    },
                  ),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 8),
        Text(
          '기존에 등록된 분을 선택하거나 새로운 이름을 입력하세요',
          style: AppTextStyles.caption.copyWith(color: AppColors.textTertiary),
        ),
      ],
    );
  }

  Widget _buildContentInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '기도 제목',
              style: AppTextStyles.titleMedium.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            ValueListenableBuilder(
              valueListenable: _contentController,
              builder: (context, value, child) {
                return Text(
                  '${value.text.length}/${AppConfig.maxPrayerContentLength}',
                  style: AppTextStyles.caption,
                );
              },
            ),
          ],
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _contentController,
          maxLines: 6,
          maxLength: AppConfig.maxPrayerContentLength,
          decoration: InputDecoration(
            hintText: '기도 제목을 입력하세요',
            alignLabelWithHint: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
          style: AppTextStyles.bodyLarge.copyWith(height: 1.6),
          buildCounter: (context,
                  {required currentLength, required isFocused, maxLength}) =>
              null,
        ),
      ],
    );
  }

  Widget _buildCategorySelector(PrayerState state, PrayerViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '카테고리 (선택)',
          style: AppTextStyles.titleMedium.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: PrayerCategory.values.map((category) {
            return _buildCategoryChip(
              category: category,
              isSelected: state.selectedCategory == category,
              onTap: () => viewModel.selectCategory(category),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildCategoryChip({
    required PrayerCategory category,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.1)
              : AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Text(
          category.label,
          style: AppTextStyles.labelMedium.copyWith(
            color: isSelected ? AppColors.primary : AppColors.textSecondary,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildMemoInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '메모 (선택)',
              style: AppTextStyles.titleMedium.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            ValueListenableBuilder(
              valueListenable: _memoController,
              builder: (context, value, child) {
                return Text(
                  '${value.text.length}/${AppConfig.maxMemoLength}',
                  style: AppTextStyles.caption,
                );
              },
            ),
          ],
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _memoController,
          maxLines: 3,
          maxLength: AppConfig.maxMemoLength,
          decoration: InputDecoration(
            hintText: '추가로 기록할 내용이 있다면 적어주세요',
            alignLabelWithHint: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
          style: AppTextStyles.bodyMedium.copyWith(height: 1.5),
          buildCounter: (context,
                  {required currentLength, required isFocused, maxLength}) =>
              null,
        ),
      ],
    );
  }

  Future<void> _save(PrayerViewModel viewModel) async {
    final requesterName = _requesterNameController.text.trim();
    final content = _contentController.text.trim();

    if (requesterName.isEmpty) {
      _showError('누구를 위해 기도하는지 입력해주세요');
      return;
    }

    if (content.isEmpty) {
      _showError('기도 제목을 입력해주세요');
      return;
    }

    final success = await viewModel.save(
      requesterName: requesterName,
      content: content,
      memo: _memoController.text.trim(),
    );

    if (success && mounted) {
      context.pop(true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            viewModel.isEditMode ? '기도 제목이 수정되었어요' : '기도 제목이 추가되었어요',
          ),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
        ),
      );
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red.shade400,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
      ),
    );
  }
}
