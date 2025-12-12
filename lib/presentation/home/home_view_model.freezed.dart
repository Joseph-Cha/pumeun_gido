// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'home_view_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$HomeState {
  List<PrayerRequestModel> get prayers => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  bool get isLoadingMore => throw _privateConstructorUsedError;
  String get errorMessage => throw _privateConstructorUsedError;
  PrayerStatus? get selectedStatus => throw _privateConstructorUsedError;
  String get searchQuery => throw _privateConstructorUsedError;
  Map<String, int> get statusCounts => throw _privateConstructorUsedError;
  bool get hasMore => throw _privateConstructorUsedError;

  /// Create a copy of HomeState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HomeStateCopyWith<HomeState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HomeStateCopyWith<$Res> {
  factory $HomeStateCopyWith(HomeState value, $Res Function(HomeState) then) =
      _$HomeStateCopyWithImpl<$Res, HomeState>;
  @useResult
  $Res call({
    List<PrayerRequestModel> prayers,
    bool isLoading,
    bool isLoadingMore,
    String errorMessage,
    PrayerStatus? selectedStatus,
    String searchQuery,
    Map<String, int> statusCounts,
    bool hasMore,
  });
}

/// @nodoc
class _$HomeStateCopyWithImpl<$Res, $Val extends HomeState>
    implements $HomeStateCopyWith<$Res> {
  _$HomeStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of HomeState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? prayers = null,
    Object? isLoading = null,
    Object? isLoadingMore = null,
    Object? errorMessage = null,
    Object? selectedStatus = freezed,
    Object? searchQuery = null,
    Object? statusCounts = null,
    Object? hasMore = null,
  }) {
    return _then(
      _value.copyWith(
            prayers: null == prayers
                ? _value.prayers
                : prayers // ignore: cast_nullable_to_non_nullable
                      as List<PrayerRequestModel>,
            isLoading: null == isLoading
                ? _value.isLoading
                : isLoading // ignore: cast_nullable_to_non_nullable
                      as bool,
            isLoadingMore: null == isLoadingMore
                ? _value.isLoadingMore
                : isLoadingMore // ignore: cast_nullable_to_non_nullable
                      as bool,
            errorMessage: null == errorMessage
                ? _value.errorMessage
                : errorMessage // ignore: cast_nullable_to_non_nullable
                      as String,
            selectedStatus: freezed == selectedStatus
                ? _value.selectedStatus
                : selectedStatus // ignore: cast_nullable_to_non_nullable
                      as PrayerStatus?,
            searchQuery: null == searchQuery
                ? _value.searchQuery
                : searchQuery // ignore: cast_nullable_to_non_nullable
                      as String,
            statusCounts: null == statusCounts
                ? _value.statusCounts
                : statusCounts // ignore: cast_nullable_to_non_nullable
                      as Map<String, int>,
            hasMore: null == hasMore
                ? _value.hasMore
                : hasMore // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$HomeStateImplCopyWith<$Res>
    implements $HomeStateCopyWith<$Res> {
  factory _$$HomeStateImplCopyWith(
    _$HomeStateImpl value,
    $Res Function(_$HomeStateImpl) then,
  ) = __$$HomeStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    List<PrayerRequestModel> prayers,
    bool isLoading,
    bool isLoadingMore,
    String errorMessage,
    PrayerStatus? selectedStatus,
    String searchQuery,
    Map<String, int> statusCounts,
    bool hasMore,
  });
}

/// @nodoc
class __$$HomeStateImplCopyWithImpl<$Res>
    extends _$HomeStateCopyWithImpl<$Res, _$HomeStateImpl>
    implements _$$HomeStateImplCopyWith<$Res> {
  __$$HomeStateImplCopyWithImpl(
    _$HomeStateImpl _value,
    $Res Function(_$HomeStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of HomeState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? prayers = null,
    Object? isLoading = null,
    Object? isLoadingMore = null,
    Object? errorMessage = null,
    Object? selectedStatus = freezed,
    Object? searchQuery = null,
    Object? statusCounts = null,
    Object? hasMore = null,
  }) {
    return _then(
      _$HomeStateImpl(
        prayers: null == prayers
            ? _value._prayers
            : prayers // ignore: cast_nullable_to_non_nullable
                  as List<PrayerRequestModel>,
        isLoading: null == isLoading
            ? _value.isLoading
            : isLoading // ignore: cast_nullable_to_non_nullable
                  as bool,
        isLoadingMore: null == isLoadingMore
            ? _value.isLoadingMore
            : isLoadingMore // ignore: cast_nullable_to_non_nullable
                  as bool,
        errorMessage: null == errorMessage
            ? _value.errorMessage
            : errorMessage // ignore: cast_nullable_to_non_nullable
                  as String,
        selectedStatus: freezed == selectedStatus
            ? _value.selectedStatus
            : selectedStatus // ignore: cast_nullable_to_non_nullable
                  as PrayerStatus?,
        searchQuery: null == searchQuery
            ? _value.searchQuery
            : searchQuery // ignore: cast_nullable_to_non_nullable
                  as String,
        statusCounts: null == statusCounts
            ? _value._statusCounts
            : statusCounts // ignore: cast_nullable_to_non_nullable
                  as Map<String, int>,
        hasMore: null == hasMore
            ? _value.hasMore
            : hasMore // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc

class _$HomeStateImpl implements _HomeState {
  const _$HomeStateImpl({
    final List<PrayerRequestModel> prayers = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.errorMessage = '',
    this.selectedStatus = null,
    this.searchQuery = '',
    final Map<String, int> statusCounts = const {},
    this.hasMore = true,
  }) : _prayers = prayers,
       _statusCounts = statusCounts;

  final List<PrayerRequestModel> _prayers;
  @override
  @JsonKey()
  List<PrayerRequestModel> get prayers {
    if (_prayers is EqualUnmodifiableListView) return _prayers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_prayers);
  }

  @override
  @JsonKey()
  final bool isLoading;
  @override
  @JsonKey()
  final bool isLoadingMore;
  @override
  @JsonKey()
  final String errorMessage;
  @override
  @JsonKey()
  final PrayerStatus? selectedStatus;
  @override
  @JsonKey()
  final String searchQuery;
  final Map<String, int> _statusCounts;
  @override
  @JsonKey()
  Map<String, int> get statusCounts {
    if (_statusCounts is EqualUnmodifiableMapView) return _statusCounts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_statusCounts);
  }

  @override
  @JsonKey()
  final bool hasMore;

  @override
  String toString() {
    return 'HomeState(prayers: $prayers, isLoading: $isLoading, isLoadingMore: $isLoadingMore, errorMessage: $errorMessage, selectedStatus: $selectedStatus, searchQuery: $searchQuery, statusCounts: $statusCounts, hasMore: $hasMore)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HomeStateImpl &&
            const DeepCollectionEquality().equals(other._prayers, _prayers) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.isLoadingMore, isLoadingMore) ||
                other.isLoadingMore == isLoadingMore) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage) &&
            (identical(other.selectedStatus, selectedStatus) ||
                other.selectedStatus == selectedStatus) &&
            (identical(other.searchQuery, searchQuery) ||
                other.searchQuery == searchQuery) &&
            const DeepCollectionEquality().equals(
              other._statusCounts,
              _statusCounts,
            ) &&
            (identical(other.hasMore, hasMore) || other.hasMore == hasMore));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_prayers),
    isLoading,
    isLoadingMore,
    errorMessage,
    selectedStatus,
    searchQuery,
    const DeepCollectionEquality().hash(_statusCounts),
    hasMore,
  );

  /// Create a copy of HomeState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HomeStateImplCopyWith<_$HomeStateImpl> get copyWith =>
      __$$HomeStateImplCopyWithImpl<_$HomeStateImpl>(this, _$identity);
}

abstract class _HomeState implements HomeState {
  const factory _HomeState({
    final List<PrayerRequestModel> prayers,
    final bool isLoading,
    final bool isLoadingMore,
    final String errorMessage,
    final PrayerStatus? selectedStatus,
    final String searchQuery,
    final Map<String, int> statusCounts,
    final bool hasMore,
  }) = _$HomeStateImpl;

  @override
  List<PrayerRequestModel> get prayers;
  @override
  bool get isLoading;
  @override
  bool get isLoadingMore;
  @override
  String get errorMessage;
  @override
  PrayerStatus? get selectedStatus;
  @override
  String get searchQuery;
  @override
  Map<String, int> get statusCounts;
  @override
  bool get hasMore;

  /// Create a copy of HomeState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HomeStateImplCopyWith<_$HomeStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
