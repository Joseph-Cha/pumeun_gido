import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/config/theme/app_colors.dart';
import '../../core/config/theme/app_text_styles.dart';
import '../../data/models/requester_model.dart';
import '../../shared/widgets/empty_state.dart';
import 'people_view_model.dart';

/// 사람 목록 화면
class PeopleListScreen extends ConsumerStatefulWidget {
  const PeopleListScreen({super.key});

  @override
  ConsumerState<PeopleListScreen> createState() => _PeopleListScreenState();
}

class _PeopleListScreenState extends ConsumerState<PeopleListScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(peopleViewModelProvider);
    final viewModel = ref.read(peopleViewModelProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildSearchBar(state, viewModel),
          const SizedBox(height: 8),
          _buildCountInfo(viewModel),
          const SizedBox(height: 8),
          Expanded(
            child: _buildPeopleList(state, viewModel),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.background,
      title: Text(
        '사람 목록',
        style: AppTextStyles.headlineSmall,
      ),
    );
  }

  Widget _buildSearchBar(PeopleState state, PeopleViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(12),
        ),
        child: TextField(
          controller: _searchController,
          onChanged: (value) {
            Future.delayed(const Duration(milliseconds: 300), () {
              if (_searchController.text == value) {
                viewModel.search(value);
              }
            });
          },
          decoration: InputDecoration(
            hintText: '이름 검색',
            hintStyle: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textTertiary,
            ),
            prefixIcon: const Icon(
              Icons.search_rounded,
              color: AppColors.textTertiary,
              size: 22,
            ),
            suffixIcon: viewModel.isSearching
                ? IconButton(
                    onPressed: () {
                      _searchController.clear();
                      viewModel.clearSearch();
                    },
                    icon: const Icon(
                      Icons.close_rounded,
                      color: AppColors.textTertiary,
                      size: 20,
                    ),
                  )
                : const SizedBox.shrink(),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
          style: AppTextStyles.bodyMedium,
        ),
      ),
    );
  }

  Widget _buildCountInfo(PeopleViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Text(
            '전체 ${viewModel.totalCount}명',
            style: AppTextStyles.labelMedium.copyWith(
              color: AppColors.textTertiary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPeopleList(PeopleState state, PeopleViewModel viewModel) {
    if (state.isLoading && state.requesters.isEmpty) {
      return _buildLoadingState();
    }

    if (viewModel.isEmpty) {
      return _buildEmptyState(state, viewModel);
    }

    return RefreshIndicator(
      onRefresh: viewModel.refresh,
      color: AppColors.primary,
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
        itemCount: state.groupedRequesters.keys.length,
        itemBuilder: (context, index) {
          final initial = state.groupedRequesters.keys.elementAt(index);
          final people = state.groupedRequesters[initial]!;

          return _buildInitialGroup(initial, people, viewModel);
        },
      ),
    );
  }

  Widget _buildInitialGroup(
    String initial,
    List<RequesterModel> people,
    PeopleViewModel viewModel,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 16, bottom: 8),
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppColors.secondaryLight,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    initial,
                    style: AppTextStyles.titleMedium.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${people.length}명',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textTertiary,
                ),
              ),
            ],
          ),
        ),
        ...people.map((person) => _buildPersonCard(person, viewModel)),
      ],
    );
  }

  Widget _buildPersonCard(RequesterModel person, PeopleViewModel viewModel) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => context.push(
            '/home',
            extra: {'requesterId': person.id, 'requesterName': person.name},
          ),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.secondaryLight,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      person.name.isNotEmpty ? person.name[0] : '?',
                      style: AppTextStyles.titleLarge.copyWith(
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
                        person.name,
                        style: AppTextStyles.titleMedium.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                      if (person.prayerCount != null && person.prayerCount! > 0)
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                            '기도 ${person.prayerCount}개',
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.textTertiary,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'edit') {
                      _showEditDialog(person, viewModel);
                    } else if (value == 'delete') {
                      _showDeleteDialog(person, viewModel);
                    }
                  },
                  icon: const Icon(
                    Icons.more_vert_rounded,
                    color: AppColors.textTertiary,
                    size: 20,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          const Icon(Icons.edit_outlined, size: 20),
                          const SizedBox(width: 12),
                          Text('이름 수정', style: AppTextStyles.bodyMedium),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete_outline_rounded,
                              size: 20, color: Colors.red.shade400),
                          const SizedBox(width: 12),
                          Text('삭제',
                              style: AppTextStyles.bodyMedium
                                  .copyWith(color: Colors.red.shade400)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showEditDialog(RequesterModel person, PeopleViewModel viewModel) {
    final nameController = TextEditingController(text: person.name);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('이름 수정'),
        content: TextField(
          controller: nameController,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: '이름을 입력하세요',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () async {
              final newName = nameController.text.trim();
              if (newName.isNotEmpty && newName != person.name) {
                Navigator.pop(context);
                final success =
                    await viewModel.editRequester(person.id, newName);
                if (success && mounted) {
                  ScaffoldMessenger.of(this.context).showSnackBar(
                    const SnackBar(
                      content: Text('이름이 수정되었어요'),
                      behavior: SnackBarBehavior.floating,
                      margin: EdgeInsets.all(16),
                    ),
                  );
                }
              }
            },
            child: const Text('수정'),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(RequesterModel person, PeopleViewModel viewModel) {
    final hasPrayers = (person.prayerCount ?? 0) > 0;

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('삭제'),
        content: Text(hasPrayers
            ? '${person.name}님의 기도 제목이 ${person.prayerCount}개 있어요.\n먼저 기도 제목을 삭제해 주세요.'
            : '${person.name}님을 삭제할까요?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(hasPrayers ? '확인' : '취소'),
          ),
          if (!hasPrayers)
            TextButton(
              onPressed: () async {
                Navigator.pop(dialogContext);
                final success = await viewModel.deleteRequester(person);
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(success ? '삭제되었어요' : '삭제에 실패했어요'),
                      behavior: SnackBarBehavior.floating,
                      margin: const EdgeInsets.all(16),
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

  Widget _buildLoadingState() {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      itemCount: 8,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.borderLight),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.shimmerBase,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 80,
                      height: 16,
                      decoration: BoxDecoration(
                        color: AppColors.shimmerBase,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      width: 50,
                      height: 12,
                      decoration: BoxDecoration(
                        color: AppColors.shimmerBase,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(PeopleState state, PeopleViewModel viewModel) {
    if (viewModel.isSearching) {
      return EmptyState.searchResult(
        query: state.searchQuery,
        onClear: () {
          _searchController.clear();
          viewModel.clearSearch();
        },
      );
    }
    return const EmptyState(
      icon: Icons.people_outline_rounded,
      title: '아직 등록된 분이 없어요',
      subtitle: '기도 제목을 추가하면\n자동으로 등록됩니다',
    );
  }
}
