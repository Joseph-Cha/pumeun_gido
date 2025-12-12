import '../../models/prayer_request_model.dart';

/// 기도 제목 Repository 인터페이스
abstract class IPrayerRepository {
  /// 기도 제목 목록 조회
  Future<List<PrayerRequestModel>> getAll({
    PrayerStatus? status,
    String? requesterId,
    String? searchQuery,
    int limit = 20,
    int offset = 0,
  });

  /// 기도 제목 상세 조회
  Future<PrayerRequestModel?> getById(String id);

  /// 기도 제목 생성
  Future<PrayerRequestModel> create({
    required String requesterId,
    required String content,
    String? title,
    PrayerCategory category = PrayerCategory.general,
    String? memo,
  });

  /// 기도 제목 수정
  Future<PrayerRequestModel> update(
    String id, {
    String? requesterId,
    String? content,
    String? title,
    PrayerCategory? category,
    String? memo,
    PrayerStatus? status,
  });

  /// 기도 상태 토글
  Future<PrayerRequestModel> toggleStatus(String id);

  /// 기도 제목 삭제 (Soft Delete)
  Future<void> delete(String id);

  /// 요청자별 기도 제목 수 조회
  Future<int> getCountByRequester(String requesterId);

  /// 통계: 전체/기도중/응답됨 카운트
  Future<Map<String, int>> getStatusCounts();
}
