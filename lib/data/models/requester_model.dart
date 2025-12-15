/// 기도 요청자 모델
class RequesterModel {
  final String id;
  final String userId;
  final String name;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final int? prayerCount; // 기도 제목 수 (집계용)

  RequesterModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    this.prayerCount,
  });

  factory RequesterModel.fromJson(Map<String, dynamic> json) {
    // prayer count 처리 (View 또는 기존 JOIN 결과)
    int? count;

    // 새로운 View 방식: requester_prayer_counts
    if (json['requester_prayer_counts'] != null) {
      final viewData = json['requester_prayer_counts'];
      if (viewData is List && viewData.isNotEmpty) {
        count = viewData[0]['active_prayer_count'] as int?;
      } else if (viewData is Map) {
        count = viewData['active_prayer_count'] as int?;
      }
    }
    // 기존 방식: prayer_requests (호환성 유지)
    else if (json['prayer_requests'] != null) {
      if (json['prayer_requests'] is List) {
        count = (json['prayer_requests'] as List).length;
      } else if (json['prayer_requests'] is Map) {
        count = json['prayer_requests']['count'] as int?;
      }
    }

    return RequesterModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      name: json['name'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      deletedAt: json['deleted_at'] != null
          ? DateTime.parse(json['deleted_at'] as String)
          : null,
      prayerCount: count,
    );
  }

  /// RPC 함수 결과에서 생성 (prayer_count 포함)
  factory RequesterModel.fromJsonWithCount(Map<String, dynamic> json) {
    return RequesterModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      name: json['name'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      deletedAt: json['deleted_at'] != null
          ? DateTime.parse(json['deleted_at'] as String)
          : null,
      prayerCount: (json['prayer_count'] as num?)?.toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
    };
  }

  /// 새로운 요청자 생성용 JSON (id, timestamps 제외)
  Map<String, dynamic> toCreateJson() {
    return {
      'name': name,
    };
  }

  RequesterModel copyWith({
    String? id,
    String? userId,
    String? name,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    int? prayerCount,
  }) {
    return RequesterModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      prayerCount: prayerCount ?? this.prayerCount,
    );
  }

  /// 초성 추출 (가나다순 정렬용)
  String get initial {
    if (name.isEmpty) return '#';

    final firstChar = name[0];
    final code = firstChar.codeUnitAt(0);

    // 한글 초성 추출
    if (code >= 0xAC00 && code <= 0xD7A3) {
      final chosung = [
        'ㄱ', 'ㄲ', 'ㄴ', 'ㄷ', 'ㄸ', 'ㄹ', 'ㅁ', 'ㅂ', 'ㅃ',
        'ㅅ', 'ㅆ', 'ㅇ', 'ㅈ', 'ㅉ', 'ㅊ', 'ㅋ', 'ㅌ', 'ㅍ', 'ㅎ'
      ];
      final index = ((code - 0xAC00) / 588).floor();
      return chosung[index];
    }

    // 영문 대문자로 변환
    if (code >= 65 && code <= 90) return firstChar;
    if (code >= 97 && code <= 122) return firstChar.toUpperCase();

    return '#';
  }

  @override
  String toString() {
    return 'RequesterModel(id: $id, name: $name, prayerCount: $prayerCount)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is RequesterModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
