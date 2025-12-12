import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../core/config/theme/app_colors.dart';
import '../../core/config/theme/app_text_styles.dart';
import '../../core/router/app_router.dart';
import '../../data/models/prayer_request_model.dart';
import '../../shared/widgets/empty_state.dart';
import 'home_view_model.dart';
import 'widgets/filter_tabs.dart';
import 'widgets/prayer_card.dart';

/// 홈 화면 (기도 목록)
class HomeScreen extends ConsumerStatefulWidget {
  final String? requesterId;
  final String? requesterName;

  const HomeScreen({
    super.key,
    this.requesterId,
    this.requesterName,
  });

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    // 초기 상태를 "기도 중"으로 설정
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(homeViewModelProvider.notifier).setStatusFilter(PrayerStatus.praying);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _onTabChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    _updateStatusFilter(index);
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
    _updateStatusFilter(index);
  }

  void _updateStatusFilter(int index) {
    final viewModel = ref.read(homeViewModelProvider.notifier);
    if (index == 0) {
      viewModel.setStatusFilter(PrayerStatus.praying);
    } else {
      viewModel.setStatusFilter(PrayerStatus.answered);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(homeViewModelProvider);
    final viewModel = ref.read(homeViewModelProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(viewModel),
            _buildSearchBar(state, viewModel),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: FilterTabs(
                currentIndex: _currentIndex,
                prayingCount: viewModel.prayingCount,
                answeredCount: viewModel.answeredCount,
                onTabChanged: _onTabChanged,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                children: [
                  _buildPrayerList(state, viewModel, PrayerStatus.praying),
                  _buildPrayerList(state, viewModel, PrayerStatus.answered),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _buildFab(),
    );
  }

  Widget _buildHeader(HomeViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 12, 8),
      child: Row(
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.secondaryLight,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: SvgPicture.asset(
                    'assets/icons/app_icon_symbol.svg',
                    width: 22,
                    height: 22,
                    colorFilter: const ColorFilter.mode(
                      AppColors.accent,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                widget.requesterName ?? '품은기도',
                style: AppTextStyles.headlineMedium.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const Spacer(),
          if (widget.requesterId == null) ...[
            IconButton(
              onPressed: () => context.push(AppRoutes.people),
              icon: const Icon(Icons.people_outline_rounded),
              color: AppColors.textSecondary,
              tooltip: '사람 목록',
            ),
            IconButton(
              onPressed: () => context.push(AppRoutes.settings),
              icon: const Icon(Icons.settings_outlined),
              color: AppColors.textSecondary,
              tooltip: '설정',
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSearchBar(HomeState state, HomeViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
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
            hintText: '사람 검색',
            hintStyle: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textTertiary,
            ),
            prefixIcon: const Icon(
              Icons.person_search_rounded,
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

  Widget _buildPrayerList(HomeState state, HomeViewModel viewModel, PrayerStatus status) {
    if (state.isLoading && state.prayers.isEmpty) {
      return _buildLoadingState();
    }

    if (viewModel.isEmpty) {
      return _buildEmptyState(state, viewModel, status);
    }

    return RefreshIndicator(
      onRefresh: viewModel.refresh,
      color: AppColors.primary,
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
        itemCount: state.prayers.length + 1,
        itemBuilder: (context, index) {
          if (index == state.prayers.length) {
            return state.isLoadingMore
                ? const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(
                      child: SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                  )
                : const SizedBox.shrink();
          }

          if (index == state.prayers.length - 3) {
            viewModel.loadMore();
          }

          final prayer = state.prayers[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: PrayerCard(
              prayer: prayer,
              onTap: () async {
                final result = await context.push<bool>('/prayer/${prayer.id}');
                if (result == true) {
                  viewModel.refresh();
                }
              },
              onStatusToggle: () async {
                final isAnswered = await viewModel.togglePrayerStatus(prayer);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        isAnswered ? '기도가 응답되었어요!' : '다시 기도 중으로 변경했어요',
                      ),
                      behavior: SnackBarBehavior.floating,
                      margin: const EdgeInsets.all(16),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                }
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildLoadingState() {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _buildShimmerCard(),
        );
      },
    );
  }

  Widget _buildShimmerCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.shimmerBase,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(width: 10),
              Container(
                width: 80,
                height: 16,
                decoration: BoxDecoration(
                  color: AppColors.shimmerBase,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            height: 16,
            decoration: BoxDecoration(
              color: AppColors.shimmerBase,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: 200,
            height: 16,
            decoration: BoxDecoration(
              color: AppColors.shimmerBase,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(HomeState state, HomeViewModel viewModel, PrayerStatus status) {
    final isSearching = viewModel.isSearching;

    if (isSearching) {
      return EmptyState.searchResult(
        query: state.searchQuery,
        onClear: () {
          _searchController.clear();
          viewModel.clearSearch();
        },
      );
    }

    if (status == PrayerStatus.praying) {
      return EmptyState.praying();
    } else {
      return EmptyState.answered();
    }
  }

  Widget _buildFab() {
    return FloatingActionButton(
      onPressed: () async {
        final result = await context.push<bool>(AppRoutes.prayerForm);
        if (result == true) {
          ref.read(homeViewModelProvider.notifier).refresh();
        }
      },
      backgroundColor: AppColors.accent,
      elevation: 4,
      child: const Icon(
        Icons.add_rounded,
        size: 28,
        color: AppColors.textOnPrimary,
      ),
    );
  }
}
