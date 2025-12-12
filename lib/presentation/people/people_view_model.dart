import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../data/models/requester_model.dart';
import '../../data/repositories/interfaces/i_requester_repository.dart';
import '../../core/di/repository_providers.dart';

part 'people_view_model.freezed.dart';

/// People 화면 상태
@freezed
class PeopleState with _$PeopleState {
  const factory PeopleState({
    @Default([]) List<RequesterModel> requesters,
    @Default({}) Map<String, List<RequesterModel>> groupedRequesters,
    @Default(false) bool isLoading,
    @Default('') String searchQuery,
    @Default('') String errorMessage,
  }) = _PeopleState;
}

/// People ViewModel Provider
final peopleViewModelProvider =
    StateNotifierProvider.autoDispose<PeopleViewModel, PeopleState>((ref) {
  final repository = ref.watch(requesterRepositoryProvider);
  return PeopleViewModel(repository);
});

/// People ViewModel
class PeopleViewModel extends StateNotifier<PeopleState> {
  final IRequesterRepository _repository;

  PeopleViewModel(this._repository) : super(const PeopleState()) {
    loadRequesters();
  }

  Future<void> loadRequesters() async {
    state = state.copyWith(isLoading: true);

    try {
      final result = await _repository.getAll(
        searchQuery: state.searchQuery.isNotEmpty ? state.searchQuery : null,
      );
      state = state.copyWith(requesters: result);
      _groupByInitial();
    } catch (e) {
      state = state.copyWith(errorMessage: '목록을 불러오지 못했어요');
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  void _groupByInitial() {
    final grouped = <String, List<RequesterModel>>{};

    for (final requester in state.requesters) {
      final initial = requester.initial;
      if (!grouped.containsKey(initial)) {
        grouped[initial] = [];
      }
      grouped[initial]!.add(requester);
    }

    // 초성 순서 정렬
    final sortedKeys = grouped.keys.toList()
      ..sort((a, b) {
        final aIsKorean = _isKoreanInitial(a);
        final bIsKorean = _isKoreanInitial(b);
        if (aIsKorean && !bIsKorean) return -1;
        if (!aIsKorean && bIsKorean) return 1;
        return a.compareTo(b);
      });

    final sortedGrouped = <String, List<RequesterModel>>{};
    for (final key in sortedKeys) {
      sortedGrouped[key] = grouped[key]!;
    }

    state = state.copyWith(groupedRequesters: sortedGrouped);
  }

  bool _isKoreanInitial(String s) {
    if (s.isEmpty) return false;
    final code = s.codeUnitAt(0);
    return code >= 0x3131 && code <= 0x3163;
  }

  void search(String query) {
    state = state.copyWith(searchQuery: query);
    loadRequesters();
  }

  void clearSearch() {
    state = state.copyWith(searchQuery: '');
    loadRequesters();
  }

  Future<void> refresh() async {
    await loadRequesters();
  }

  Future<bool> editRequester(String id, String newName) async {
    try {
      await _repository.update(id, newName);
      await loadRequesters();
      return true;
    } catch (e) {
      state = state.copyWith(
        errorMessage: e.toString().contains('이미 등록된')
            ? '이미 등록된 이름이에요'
            : '수정에 실패했어요',
      );
      return false;
    }
  }

  Future<bool> deleteRequester(RequesterModel requester) async {
    if ((requester.prayerCount ?? 0) > 0) {
      state = state.copyWith(errorMessage: '이 분의 기도 제목이 있어 삭제할 수 없어요');
      return false;
    }

    try {
      await _repository.delete(requester.id);
      await loadRequesters();
      return true;
    } catch (e) {
      state = state.copyWith(
        errorMessage: e.toString().contains('기도 제목이 있어')
            ? '이 분의 기도 제목이 있어 삭제할 수 없어요'
            : '삭제에 실패했어요',
      );
      return false;
    }
  }

  bool get isEmpty => state.requesters.isEmpty && !state.isLoading;
  bool get isSearching => state.searchQuery.isNotEmpty;
  int get totalCount => state.requesters.length;
}
