import 'requester_model.dart';

/// 기도 상태
enum PrayerStatus {
  praying('praying', '기도 중'),
  answered('answered', '응답됨');

  final String value;
  final String label;

  const PrayerStatus(this.value, this.label);

  static PrayerStatus fromString(String value) {
    return PrayerStatus.values.firstWhere(
      (e) => e.value == value,
      orElse: () => PrayerStatus.praying,
    );
  }
}

/// 기도 카테고리
enum PrayerCategory {
  general('general', '일반'),
  health('health', '건강'),
  career('career', '진로/직장'),
  family('family', '가정'),
  relationship('relationship', '관계'),
  faith('faith', '신앙'),
  other('other', '기타');

  final String value;
  final String label;

  const PrayerCategory(this.value, this.label);

  static PrayerCategory fromString(String? value) {
    if (value == null) return PrayerCategory.general;
    return PrayerCategory.values.firstWhere(
      (e) => e.value == value,
      orElse: () => PrayerCategory.general,
    );
  }
}

/// 기도 제목 모델
class PrayerRequestModel {
  final String id;
  final String userId;
  final String requesterId;
  final String? title;
  final String content;
  final PrayerCategory category;
  final PrayerStatus status;
  final String? memo;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final DateTime? answeredAt;
  final RequesterModel? requester; // JOIN 결과

  PrayerRequestModel({
    required this.id,
    required this.userId,
    required this.requesterId,
    this.title,
    required this.content,
    this.category = PrayerCategory.general,
    this.status = PrayerStatus.praying,
    this.memo,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    this.answeredAt,
    this.requester,
  });

  factory PrayerRequestModel.fromJson(Map<String, dynamic> json) {
    // 요청자 정보 파싱 (JOIN 결과)
    RequesterModel? requesterModel;
    if (json['requesters'] != null && json['requesters'] is Map) {
      requesterModel = RequesterModel.fromJson(
        Map<String, dynamic>.from(json['requesters'] as Map),
      );
    }

    return PrayerRequestModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      requesterId: json['requester_id'] as String,
      title: json['title'] as String?,
      content: json['content'] as String,
      category: PrayerCategory.fromString(json['category'] as String?),
      status: PrayerStatus.fromString(json['status'] as String),
      memo: json['memo'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      deletedAt: json['deleted_at'] != null
          ? DateTime.parse(json['deleted_at'] as String)
          : null,
      answeredAt: json['answered_at'] != null
          ? DateTime.parse(json['answered_at'] as String)
          : null,
      requester: requesterModel,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'requester_id': requesterId,
      'title': title,
      'content': content,
      'category': category.value,
      'status': status.value,
      'memo': memo,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
      'answered_at': answeredAt?.toIso8601String(),
    };
  }

  /// 새로운 기도 제목 생성용 JSON
  Map<String, dynamic> toCreateJson() {
    return {
      'requester_id': requesterId,
      'title': title,
      'content': content,
      'category': category.value,
      'memo': memo,
    };
  }

  /// 기도 제목 수정용 JSON
  Map<String, dynamic> toUpdateJson() {
    final Map<String, dynamic> data = {
      'content': content,
      'title': title,
      'category': category.value,
      'memo': memo,
      'updated_at': DateTime.now().toIso8601String(),
    };

    // 상태가 변경된 경우
    if (status == PrayerStatus.answered && answeredAt != null) {
      data['status'] = status.value;
      data['answered_at'] = answeredAt!.toIso8601String();
    } else {
      data['status'] = status.value;
    }

    return data;
  }

  PrayerRequestModel copyWith({
    String? id,
    String? userId,
    String? requesterId,
    String? title,
    String? content,
    PrayerCategory? category,
    PrayerStatus? status,
    String? memo,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    DateTime? answeredAt,
    RequesterModel? requester,
  }) {
    return PrayerRequestModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      requesterId: requesterId ?? this.requesterId,
      title: title ?? this.title,
      content: content ?? this.content,
      category: category ?? this.category,
      status: status ?? this.status,
      memo: memo ?? this.memo,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      answeredAt: answeredAt ?? this.answeredAt,
      requester: requester ?? this.requester,
    );
  }

  /// 기도 상태 토글
  PrayerRequestModel toggleStatus() {
    if (status == PrayerStatus.praying) {
      return copyWith(
        status: PrayerStatus.answered,
        answeredAt: DateTime.now(),
      );
    } else {
      return copyWith(
        status: PrayerStatus.praying,
        answeredAt: null,
      );
    }
  }

  /// 응답된 상태인지 확인
  bool get isAnswered => status == PrayerStatus.answered;

  /// 기도 중인 상태인지 확인
  bool get isPraying => status == PrayerStatus.praying;

  /// 요청자 이름 (없으면 '알 수 없음')
  String get requesterName => requester?.name ?? '알 수 없음';

  /// 등록 후 경과 일수
  int get daysSinceCreated {
    return DateTime.now().difference(createdAt).inDays;
  }

  /// 응답까지 걸린 일수 (응답된 경우만)
  int? get daysToAnswer {
    if (answeredAt == null) return null;
    return answeredAt!.difference(createdAt).inDays;
  }

  @override
  String toString() {
    return 'PrayerRequestModel(id: $id, content: ${content.substring(0, content.length > 20 ? 20 : content.length)}..., status: ${status.label})';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PrayerRequestModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
