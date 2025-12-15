import '../interfaces/i_requester_repository.dart';
import '../../models/requester_model.dart';
import '../../services/supabase_service.dart';

/// 요청자 Repository 구현
class RequesterRepositoryImpl implements IRequesterRepository {
  final SupabaseService _supabaseService;

  RequesterRepositoryImpl(this._supabaseService);

  static const String _tableName = 'requesters';

  /// 현재 사용자 ID
  String? get _userId => _supabaseService.currentUserId;

  @override
  Future<List<RequesterModel>> getAll({
    String? searchQuery,
    bool sortByName = true,
  }) async {
    if (_userId == null) throw Exception('로그인이 필요합니다.');

    // RPC 함수를 사용하여 삭제되지 않은 기도 제목 카운트 포함
    final response = await _supabaseService.client
        .rpc('get_requesters_with_prayer_count', params: {'p_user_id': _userId});

    var list = (response as List)
        .map((json) => RequesterModel.fromJsonWithCount(json))
        .toList();

    // 정렬
    if (!sortByName) {
      list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    }

    // 검색어 필터 (클라이언트 사이드)
    if (searchQuery != null && searchQuery.isNotEmpty) {
      final lowerQuery = searchQuery.toLowerCase();
      list =
          list.where((r) => r.name.toLowerCase().contains(lowerQuery)).toList();
    }

    return list;
  }

  @override
  Future<RequesterModel?> getById(String id) async {
    if (_userId == null) throw Exception('로그인이 필요합니다.');

    // 기본 정보 조회
    final response = await _supabaseService
        .from(_tableName)
        .select()
        .eq('id', id)
        .eq('user_id', _userId!)
        .isFilter('deleted_at', null)
        .maybeSingle();

    if (response == null) return null;

    // 삭제되지 않은 기도 제목 수 별도 조회
    final countResponse = await _supabaseService
        .from('prayer_requests')
        .select()
        .eq('requester_id', id)
        .isFilter('deleted_at', null);

    final prayerCount = (countResponse as List).length;

    return RequesterModel(
      id: response['id'] as String,
      userId: response['user_id'] as String,
      name: response['name'] as String,
      createdAt: DateTime.parse(response['created_at'] as String),
      updatedAt: DateTime.parse(response['updated_at'] as String),
      deletedAt: response['deleted_at'] != null
          ? DateTime.parse(response['deleted_at'] as String)
          : null,
      prayerCount: prayerCount,
    );
  }

  @override
  Future<RequesterModel?> getByName(String name) async {
    if (_userId == null) throw Exception('로그인이 필요합니다.');

    // 중복 체크용으로 사용되므로 prayerCount 없이 조회
    final response = await _supabaseService
        .from(_tableName)
        .select()
        .eq('user_id', _userId!)
        .eq('name', name)
        .isFilter('deleted_at', null)
        .maybeSingle();

    if (response == null) return null;
    return RequesterModel.fromJson(response);
  }

  @override
  Future<RequesterModel> create(String name) async {
    if (_userId == null) throw Exception('로그인이 필요합니다.');

    // 중복 체크
    final existing = await getByName(name);
    if (existing != null) {
      throw Exception('이미 등록된 이름이에요');
    }

    final response = await _supabaseService.from(_tableName).insert({
      'user_id': _userId,
      'name': name.trim(),
    }).select().single();

    return RequesterModel.fromJson(response);
  }

  @override
  Future<RequesterModel> update(String id, String name) async {
    if (_userId == null) throw Exception('로그인이 필요합니다.');

    // 중복 체크 (자신 제외)
    final existing = await getByName(name);
    if (existing != null && existing.id != id) {
      throw Exception('이미 등록된 이름이에요');
    }

    final response = await _supabaseService
        .from(_tableName)
        .update({
          'name': name.trim(),
          'updated_at': DateTime.now().toIso8601String(),
        })
        .eq('id', id)
        .eq('user_id', _userId!)
        .select()
        .single();

    return RequesterModel.fromJson(response);
  }

  @override
  Future<void> delete(String id) async {
    if (_userId == null) throw Exception('로그인이 필요합니다.');

    // 기도 제목 수 확인
    final requester = await getById(id);
    if (requester == null) throw Exception('요청자를 찾을 수 없습니다.');
    if ((requester.prayerCount ?? 0) > 0) {
      throw Exception('이 분의 기도 제목이 있어 삭제할 수 없어요');
    }

    await _supabaseService
        .from(_tableName)
        .update({'deleted_at': DateTime.now().toIso8601String()})
        .eq('id', id)
        .eq('user_id', _userId!);
  }

  @override
  Future<RequesterModel> getOrCreate(String name) async {
    final existing = await getByName(name);
    if (existing != null) return existing;
    return create(name);
  }

  @override
  Future<Map<String, List<RequesterModel>>> getGroupedByInitial() async {
    final requesters = await getAll(sortByName: true);

    final grouped = <String, List<RequesterModel>>{};
    for (final requester in requesters) {
      final initial = requester.initial;
      if (!grouped.containsKey(initial)) {
        grouped[initial] = [];
      }
      grouped[initial]!.add(requester);
    }

    return grouped;
  }
}
