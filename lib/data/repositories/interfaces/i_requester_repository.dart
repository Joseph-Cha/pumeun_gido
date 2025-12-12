import '../../models/requester_model.dart';

/// 요청자 Repository 인터페이스
abstract class IRequesterRepository {
  /// 요청자 목록 조회 (기도 제목 수 포함)
  Future<List<RequesterModel>> getAll({
    String? searchQuery,
    bool sortByName = true,
  });

  /// 요청자 상세 조회
  Future<RequesterModel?> getById(String id);

  /// 이름으로 요청자 조회
  Future<RequesterModel?> getByName(String name);

  /// 요청자 생성
  Future<RequesterModel> create(String name);

  /// 요청자 수정
  Future<RequesterModel> update(String id, String name);

  /// 요청자 삭제 (Soft Delete)
  Future<void> delete(String id);

  /// 요청자 생성 또는 기존 반환
  Future<RequesterModel> getOrCreate(String name);

  /// 초성별 그룹핑
  Future<Map<String, List<RequesterModel>>> getGroupedByInitial();
}
