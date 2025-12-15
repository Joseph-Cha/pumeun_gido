import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../data/models/prayer_request_model.dart';
import '../../data/models/requester_model.dart';
import '../../data/repositories/interfaces/i_prayer_repository.dart';
import '../../data/repositories/interfaces/i_requester_repository.dart';
import '../../data/services/analytics_service.dart';
import '../../core/di/repository_providers.dart';
import '../../core/di/providers.dart';

part 'prayer_view_model.freezed.dart';

/// Prayer 화면 상태
@freezed
class PrayerState with _$PrayerState {
  const factory PrayerState({
    @Default(null) PrayerRequestModel? prayer,
    @Default(false) bool isLoading,
    @Default(false) bool isSaving,
    @Default(false) bool hasChanges,
    @Default(null) RequesterModel? selectedRequester,
    @Default(PrayerCategory.general) PrayerCategory selectedCategory,
    @Default([]) List<RequesterModel> requesters,
    @Default('') String errorMessage,
  }) = _PrayerState;
}

/// Prayer ViewModel Provider (Family for prayerId)
final prayerViewModelProvider = StateNotifierProvider.autoDispose
    .family<PrayerViewModel, PrayerState, String?>((ref, prayerId) {
  final prayerRepository = ref.watch(prayerRepositoryProvider);
  final requesterRepository = ref.watch(requesterRepositoryProvider);
  final analyticsService = ref.watch(analyticsServiceProvider);
  return PrayerViewModel(prayerRepository, requesterRepository, analyticsService, prayerId);
});

/// Prayer ViewModel
class PrayerViewModel extends StateNotifier<PrayerState> {
  final IPrayerRepository _prayerRepository;
  final IRequesterRepository _requesterRepository;
  final AnalyticsService _analyticsService;
  final String? prayerId;

  PrayerViewModel(
    this._prayerRepository,
    this._requesterRepository,
    this._analyticsService,
    this.prayerId,
  ) : super(const PrayerState()) {
    _loadInitialData();
  }

  bool get isEditMode => state.prayer != null;

  Future<void> _loadInitialData() async {
    await loadRequesters();
    if (prayerId != null) {
      await loadPrayer(prayerId!);
    }
  }

  Future<void> loadPrayer(String id) async {
    state = state.copyWith(isLoading: true);
    try {
      final result = await _prayerRepository.getById(id);
      if (result != null) {
        state = state.copyWith(
          prayer: result,
          selectedRequester: result.requester,
          selectedCategory: result.category,
        );
      }
    } catch (e) {
      state = state.copyWith(errorMessage: '기도 제목을 불러오지 못했어요');
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> loadRequesters() async {
    try {
      final result = await _requesterRepository.getAll();
      state = state.copyWith(requesters: result);
    } catch (e) {
      // 조용히 처리
    }
  }

  void selectRequester(RequesterModel requester) {
    state = state.copyWith(selectedRequester: requester);
  }

  void selectCategory(PrayerCategory category) {
    state = state.copyWith(selectedCategory: category);
  }

  /// 저장 (생성 또는 수정)
  Future<bool> save({
    required String requesterName,
    required String content,
    String? memo,
  }) async {
    state = state.copyWith(isSaving: true, errorMessage: '');

    try {
      // 요청자 확인/생성
      RequesterModel requester;
      if (state.selectedRequester != null &&
          state.selectedRequester!.name == requesterName) {
        requester = state.selectedRequester!;
      } else {
        requester = await _requesterRepository.getOrCreate(requesterName);
      }

      if (isEditMode) {
        await _prayerRepository.update(
          state.prayer!.id,
          requesterId: requester.id,
          content: content.trim(),
          category: state.selectedCategory,
          memo: memo?.trim().isNotEmpty == true ? memo!.trim() : null,
        );
        // Analytics: 기도 수정 이벤트
        _analyticsService.logUpdatePrayer();
      } else {
        await _prayerRepository.create(
          requesterId: requester.id,
          content: content.trim(),
          category: state.selectedCategory,
          memo: memo?.trim().isNotEmpty == true ? memo!.trim() : null,
        );
        // Analytics: 기도 생성 이벤트
        _analyticsService.logCreatePrayer(category: state.selectedCategory.name);
      }

      state = state.copyWith(isSaving: false);
      return true;
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        errorMessage: e.toString().contains('이미 등록된')
            ? e.toString()
            : '저장에 실패했어요',
      );
      return false;
    }
  }

  /// 삭제
  Future<bool> delete() async {
    if (state.prayer == null) return false;

    state = state.copyWith(isSaving: true);
    try {
      await _prayerRepository.delete(state.prayer!.id);
      // Analytics: 기도 삭제 이벤트
      _analyticsService.logDeletePrayer();
      state = state.copyWith(isSaving: false);
      return true;
    } catch (e) {
      state = state.copyWith(isSaving: false, errorMessage: '삭제에 실패했어요');
      return false;
    }
  }

  /// 상태 토글
  Future<bool> toggleStatus() async {
    if (state.prayer == null) return false;

    try {
      final updated = await _prayerRepository.toggleStatus(state.prayer!.id);
      // Analytics: 기도 상태 변경 이벤트
      if (updated.isAnswered) {
        _analyticsService.logAnswerPrayer();
      } else {
        _analyticsService.logRevertPrayer();
      }
      state = state.copyWith(prayer: updated, hasChanges: true);
      return updated.isAnswered;
    } catch (e) {
      state = state.copyWith(errorMessage: '상태 변경에 실패했어요');
      return false;
    }
  }

  /// 변경됨으로 표시
  void markAsChanged() {
    state = state.copyWith(hasChanges: true);
  }
}
