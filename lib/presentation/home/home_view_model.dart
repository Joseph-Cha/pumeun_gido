import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../data/models/prayer_request_model.dart';
import '../../data/repositories/interfaces/i_prayer_repository.dart';
import '../../core/di/repository_providers.dart';

part 'home_view_model.freezed.dart';

/// Home 화면 상태
@freezed
class HomeState with _$HomeState {
  const factory HomeState({
    @Default([]) List<PrayerRequestModel> prayers,
    @Default(false) bool isLoading,
    @Default(false) bool isLoadingMore,
    @Default('') String errorMessage,
    @Default(null) PrayerStatus? selectedStatus,
    @Default('') String searchQuery,
    @Default({}) Map<String, int> statusCounts,
    @Default(true) bool hasMore,
  }) = _HomeState;
}

/// Home ViewModel Provider
final homeViewModelProvider =
    StateNotifierProvider.autoDispose<HomeViewModel, HomeState>((ref) {
  final repository = ref.watch(prayerRepositoryProvider);
  return HomeViewModel(repository);
});

/// Home ViewModel
class HomeViewModel extends StateNotifier<HomeState> {
  final IPrayerRepository _repository;

  int _currentOffset = 0;
  static const int _pageSize = 20;

  HomeViewModel(this._repository) : super(const HomeState()) {
    loadPrayers();
    loadStatusCounts();
  }

  /// 기도 목록 로드
  Future<void> loadPrayers({bool refresh = true}) async {
    if (state.isLoading) return;

    if (refresh) {
      _currentOffset = 0;
      state = state.copyWith(hasMore: true);
    }

    state = state.copyWith(isLoading: true, errorMessage: '');

    try {
      final result = await _repository.getAll(
        status: state.selectedStatus,
        searchQuery: state.searchQuery.isNotEmpty ? state.searchQuery : null,
        limit: _pageSize,
        offset: _currentOffset,
      );

      if (refresh) {
        state = state.copyWith(prayers: result);
      } else {
        state = state.copyWith(prayers: [...state.prayers, ...result]);
      }

      state = state.copyWith(hasMore: result.length >= _pageSize);
      _currentOffset += result.length;
    } catch (e) {
      state = state.copyWith(errorMessage: '기도 목록을 불러오지 못했어요');
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  /// 더 불러오기
  Future<void> loadMore() async {
    // 새로고침 중이거나 이미 더 불러오는 중이면 중복 호출 방지
    if (state.isLoading || state.isLoadingMore || !state.hasMore) return;

    state = state.copyWith(isLoadingMore: true);

    try {
      final result = await _repository.getAll(
        status: state.selectedStatus,
        searchQuery: state.searchQuery.isNotEmpty ? state.searchQuery : null,
        limit: _pageSize,
        offset: _currentOffset,
      );

      state = state.copyWith(
        prayers: [...state.prayers, ...result],
        hasMore: result.length >= _pageSize,
      );
      _currentOffset += result.length;
    } catch (e) {
      // 조용히 처리
    } finally {
      state = state.copyWith(isLoadingMore: false);
    }
  }

  /// 통계 로드
  Future<void> loadStatusCounts() async {
    try {
      final counts = await _repository.getStatusCounts();
      state = state.copyWith(statusCounts: counts);
    } catch (e) {
      // 조용히 처리
    }
  }

  /// 새로고침
  Future<void> refresh() async {
    await loadPrayers(refresh: true);
    await loadStatusCounts();
  }

  /// 필터 변경
  void setStatusFilter(PrayerStatus? status) {
    if (state.selectedStatus == status) return;
    // 필터 변경 시 기존 목록을 비워서 로딩 상태가 일관되게 표시되도록 함
    state = state.copyWith(selectedStatus: status, prayers: []);
    loadPrayers(refresh: true);
  }

  /// 검색
  void search(String query) {
    state = state.copyWith(searchQuery: query);
    loadPrayers(refresh: true);
  }

  /// 검색 초기화
  void clearSearch() {
    state = state.copyWith(searchQuery: '');
    loadPrayers(refresh: true);
  }

  /// 기도 상태 토글
  Future<bool> togglePrayerStatus(PrayerRequestModel prayer) async {
    try {
      final updated = await _repository.toggleStatus(prayer.id);

      final prayers = state.prayers.map((p) {
        return p.id == prayer.id ? updated : p;
      }).toList();

      // 필터가 적용되어 있으면 목록에서 제거
      if (state.selectedStatus != null &&
          updated.status != state.selectedStatus) {
        prayers.removeWhere((p) => p.id == prayer.id);
      }

      state = state.copyWith(prayers: prayers);
      loadStatusCounts();
      return updated.isAnswered;
    } catch (e) {
      return false;
    }
  }

  // Computed properties
  int get totalCount => state.statusCounts['total'] ?? 0;
  int get prayingCount => state.statusCounts['praying'] ?? 0;
  int get answeredCount => state.statusCounts['answered'] ?? 0;
  bool get isEmpty => state.prayers.isEmpty && !state.isLoading;
  bool get isSearching => state.searchQuery.isNotEmpty;
}
