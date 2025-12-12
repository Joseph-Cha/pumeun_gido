// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'people_view_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$PeopleState {
  List<RequesterModel> get requesters => throw _privateConstructorUsedError;
  Map<String, List<RequesterModel>> get groupedRequesters =>
      throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  String get searchQuery => throw _privateConstructorUsedError;
  String get errorMessage => throw _privateConstructorUsedError;

  /// Create a copy of PeopleState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PeopleStateCopyWith<PeopleState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PeopleStateCopyWith<$Res> {
  factory $PeopleStateCopyWith(
    PeopleState value,
    $Res Function(PeopleState) then,
  ) = _$PeopleStateCopyWithImpl<$Res, PeopleState>;
  @useResult
  $Res call({
    List<RequesterModel> requesters,
    Map<String, List<RequesterModel>> groupedRequesters,
    bool isLoading,
    String searchQuery,
    String errorMessage,
  });
}

/// @nodoc
class _$PeopleStateCopyWithImpl<$Res, $Val extends PeopleState>
    implements $PeopleStateCopyWith<$Res> {
  _$PeopleStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PeopleState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? requesters = null,
    Object? groupedRequesters = null,
    Object? isLoading = null,
    Object? searchQuery = null,
    Object? errorMessage = null,
  }) {
    return _then(
      _value.copyWith(
            requesters: null == requesters
                ? _value.requesters
                : requesters // ignore: cast_nullable_to_non_nullable
                      as List<RequesterModel>,
            groupedRequesters: null == groupedRequesters
                ? _value.groupedRequesters
                : groupedRequesters // ignore: cast_nullable_to_non_nullable
                      as Map<String, List<RequesterModel>>,
            isLoading: null == isLoading
                ? _value.isLoading
                : isLoading // ignore: cast_nullable_to_non_nullable
                      as bool,
            searchQuery: null == searchQuery
                ? _value.searchQuery
                : searchQuery // ignore: cast_nullable_to_non_nullable
                      as String,
            errorMessage: null == errorMessage
                ? _value.errorMessage
                : errorMessage // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PeopleStateImplCopyWith<$Res>
    implements $PeopleStateCopyWith<$Res> {
  factory _$$PeopleStateImplCopyWith(
    _$PeopleStateImpl value,
    $Res Function(_$PeopleStateImpl) then,
  ) = __$$PeopleStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    List<RequesterModel> requesters,
    Map<String, List<RequesterModel>> groupedRequesters,
    bool isLoading,
    String searchQuery,
    String errorMessage,
  });
}

/// @nodoc
class __$$PeopleStateImplCopyWithImpl<$Res>
    extends _$PeopleStateCopyWithImpl<$Res, _$PeopleStateImpl>
    implements _$$PeopleStateImplCopyWith<$Res> {
  __$$PeopleStateImplCopyWithImpl(
    _$PeopleStateImpl _value,
    $Res Function(_$PeopleStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PeopleState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? requesters = null,
    Object? groupedRequesters = null,
    Object? isLoading = null,
    Object? searchQuery = null,
    Object? errorMessage = null,
  }) {
    return _then(
      _$PeopleStateImpl(
        requesters: null == requesters
            ? _value._requesters
            : requesters // ignore: cast_nullable_to_non_nullable
                  as List<RequesterModel>,
        groupedRequesters: null == groupedRequesters
            ? _value._groupedRequesters
            : groupedRequesters // ignore: cast_nullable_to_non_nullable
                  as Map<String, List<RequesterModel>>,
        isLoading: null == isLoading
            ? _value.isLoading
            : isLoading // ignore: cast_nullable_to_non_nullable
                  as bool,
        searchQuery: null == searchQuery
            ? _value.searchQuery
            : searchQuery // ignore: cast_nullable_to_non_nullable
                  as String,
        errorMessage: null == errorMessage
            ? _value.errorMessage
            : errorMessage // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$PeopleStateImpl implements _PeopleState {
  const _$PeopleStateImpl({
    final List<RequesterModel> requesters = const [],
    final Map<String, List<RequesterModel>> groupedRequesters = const {},
    this.isLoading = false,
    this.searchQuery = '',
    this.errorMessage = '',
  }) : _requesters = requesters,
       _groupedRequesters = groupedRequesters;

  final List<RequesterModel> _requesters;
  @override
  @JsonKey()
  List<RequesterModel> get requesters {
    if (_requesters is EqualUnmodifiableListView) return _requesters;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_requesters);
  }

  final Map<String, List<RequesterModel>> _groupedRequesters;
  @override
  @JsonKey()
  Map<String, List<RequesterModel>> get groupedRequesters {
    if (_groupedRequesters is EqualUnmodifiableMapView)
      return _groupedRequesters;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_groupedRequesters);
  }

  @override
  @JsonKey()
  final bool isLoading;
  @override
  @JsonKey()
  final String searchQuery;
  @override
  @JsonKey()
  final String errorMessage;

  @override
  String toString() {
    return 'PeopleState(requesters: $requesters, groupedRequesters: $groupedRequesters, isLoading: $isLoading, searchQuery: $searchQuery, errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PeopleStateImpl &&
            const DeepCollectionEquality().equals(
              other._requesters,
              _requesters,
            ) &&
            const DeepCollectionEquality().equals(
              other._groupedRequesters,
              _groupedRequesters,
            ) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.searchQuery, searchQuery) ||
                other.searchQuery == searchQuery) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_requesters),
    const DeepCollectionEquality().hash(_groupedRequesters),
    isLoading,
    searchQuery,
    errorMessage,
  );

  /// Create a copy of PeopleState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PeopleStateImplCopyWith<_$PeopleStateImpl> get copyWith =>
      __$$PeopleStateImplCopyWithImpl<_$PeopleStateImpl>(this, _$identity);
}

abstract class _PeopleState implements PeopleState {
  const factory _PeopleState({
    final List<RequesterModel> requesters,
    final Map<String, List<RequesterModel>> groupedRequesters,
    final bool isLoading,
    final String searchQuery,
    final String errorMessage,
  }) = _$PeopleStateImpl;

  @override
  List<RequesterModel> get requesters;
  @override
  Map<String, List<RequesterModel>> get groupedRequesters;
  @override
  bool get isLoading;
  @override
  String get searchQuery;
  @override
  String get errorMessage;

  /// Create a copy of PeopleState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PeopleStateImplCopyWith<_$PeopleStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
