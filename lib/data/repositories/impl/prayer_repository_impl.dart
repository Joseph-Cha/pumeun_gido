import '../interfaces/i_prayer_repository.dart';
import '../../models/prayer_request_model.dart';
import '../../services/supabase_service.dart';

/// 기도 제목 Repository 구현
class PrayerRepositoryImpl implements IPrayerRepository {
  final SupabaseService _supabaseService;

  PrayerRepositoryImpl(this._supabaseService);

  static const String _tableName = 'prayer_requests';

  /// 현재 사용자 ID
  String? get _userId => _supabaseService.currentUserId;

  @override
  Future<List<PrayerRequestModel>> getAll({
    PrayerStatus? status,
    String? requesterId,
    String? searchQuery,
    int limit = 20,
    int offset = 0,
  }) async {
    if (_userId == null) throw Exception('로그인이 필요합니다.');

    var query = _supabaseService
        .from(_tableName)
        .select('*, requesters(*)')
        .eq('user_id', _userId!)
        .isFilter('deleted_at', null);

    // 상태 필터
    if (status != null) {
      query = query.eq('status', status.value);
    }

    // 요청자 필터
    if (requesterId != null) {
      query = query.eq('requester_id', requesterId);
    }

    // 검색어 필터
    if (searchQuery != null && searchQuery.isNotEmpty) {
      query = query.ilike('content', '%$searchQuery%');
    }

    // 정렬 및 페이지네이션
    final response = await query
        .order('created_at', ascending: false)
        .range(offset, offset + limit - 1);

    return (response as List)
        .map((json) => PrayerRequestModel.fromJson(json))
        .toList();
  }

  @override
  Future<PrayerRequestModel?> getById(String id) async {
    if (_userId == null) throw Exception('로그인이 필요합니다.');

    final response = await _supabaseService
        .from(_tableName)
        .select('*, requesters(*)')
        .eq('id', id)
        .eq('user_id', _userId!)
        .isFilter('deleted_at', null)
        .maybeSingle();

    if (response == null) return null;
    return PrayerRequestModel.fromJson(response);
  }

  @override
  Future<PrayerRequestModel> create({
    required String requesterId,
    required String content,
    String? title,
    PrayerCategory category = PrayerCategory.general,
    String? memo,
  }) async {
    if (_userId == null) throw Exception('로그인이 필요합니다.');

    final response = await _supabaseService.from(_tableName).insert({
      'user_id': _userId,
      'requester_id': requesterId,
      'title': title,
      'content': content,
      'category': category.value,
      'memo': memo,
    }).select('*, requesters(*)').single();

    return PrayerRequestModel.fromJson(response);
  }

  @override
  Future<PrayerRequestModel> update(
    String id, {
    String? requesterId,
    String? content,
    String? title,
    PrayerCategory? category,
    String? memo,
    PrayerStatus? status,
  }) async {
    if (_userId == null) throw Exception('로그인이 필요합니다.');

    final updateData = <String, dynamic>{
      'updated_at': DateTime.now().toIso8601String(),
    };

    if (requesterId != null) updateData['requester_id'] = requesterId;
    if (content != null) updateData['content'] = content;
    if (title != null) updateData['title'] = title;
    if (category != null) updateData['category'] = category.value;
    if (memo != null) updateData['memo'] = memo;
    if (status != null) {
      updateData['status'] = status.value;
      if (status == PrayerStatus.answered) {
        updateData['answered_at'] = DateTime.now().toIso8601String();
      } else {
        updateData['answered_at'] = null;
      }
    }

    final response = await _supabaseService
        .from(_tableName)
        .update(updateData)
        .eq('id', id)
        .eq('user_id', _userId!)
        .select('*, requesters(*)')
        .single();

    return PrayerRequestModel.fromJson(response);
  }

  @override
  Future<PrayerRequestModel> toggleStatus(String id) async {
    final prayer = await getById(id);
    if (prayer == null) throw Exception('기도 제목을 찾을 수 없습니다.');

    final newStatus =
        prayer.isPraying ? PrayerStatus.answered : PrayerStatus.praying;

    return update(id, status: newStatus);
  }

  @override
  Future<void> delete(String id) async {
    if (_userId == null) throw Exception('로그인이 필요합니다.');

    await _supabaseService
        .from(_tableName)
        .update({'deleted_at': DateTime.now().toIso8601String()})
        .eq('id', id)
        .eq('user_id', _userId!);
  }

  @override
  Future<int> getCountByRequester(String requesterId) async {
    if (_userId == null) return 0;

    final response = await _supabaseService
        .from(_tableName)
        .select()
        .eq('user_id', _userId!)
        .eq('requester_id', requesterId)
        .isFilter('deleted_at', null);

    return (response as List).length;
  }

  @override
  Future<Map<String, int>> getStatusCounts() async {
    if (_userId == null) return {'total': 0, 'praying': 0, 'answered': 0};

    final response = await _supabaseService
        .from(_tableName)
        .select('status')
        .eq('user_id', _userId!)
        .isFilter('deleted_at', null);

    final list = response as List;
    final praying = list.where((e) => e['status'] == 'praying').length;
    final answered = list.where((e) => e['status'] == 'answered').length;

    return {
      'total': list.length,
      'praying': praying,
      'answered': answered,
    };
  }
}
