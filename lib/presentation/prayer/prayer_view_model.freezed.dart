// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'prayer_view_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$PrayerState {
  PrayerRequestModel? get prayer => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  bool get isSaving => throw _privateConstructorUsedError;
  bool get hasChanges => throw _privateConstructorUsedError;
  RequesterModel? get selectedRequester => throw _privateConstructorUsedError;
  PrayerCategory get selectedCategory => throw _privateConstructorUsedError;
  List<RequesterModel> get requesters => throw _privateConstructorUsedError;
  String get errorMessage => throw _privateConstructorUsedError;

  /// Create a copy of PrayerState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PrayerStateCopyWith<PrayerState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PrayerStateCopyWith<$Res> {
  factory $PrayerStateCopyWith(
    PrayerState value,
    $Res Function(PrayerState) then,
  ) = _$PrayerStateCopyWithImpl<$Res, PrayerState>;
  @useResult
  $Res call({
    PrayerRequestModel? prayer,
    bool isLoading,
    bool isSaving,
    bool hasChanges,
    RequesterModel? selectedRequester,
    PrayerCategory selectedCategory,
    List<RequesterModel> requesters,
    String errorMessage,
  });
}

/// @nodoc
class _$PrayerStateCopyWithImpl<$Res, $Val extends PrayerState>
    implements $PrayerStateCopyWith<$Res> {
  _$PrayerStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PrayerState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? prayer = freezed,
    Object? isLoading = null,
    Object? isSaving = null,
    Object? hasChanges = null,
    Object? selectedRequester = freezed,
    Object? selectedCategory = null,
    Object? requesters = null,
    Object? errorMessage = null,
  }) {
    return _then(
      _value.copyWith(
            prayer: freezed == prayer
                ? _value.prayer
                : prayer // ignore: cast_nullable_to_non_nullable
                      as PrayerRequestModel?,
            isLoading: null == isLoading
                ? _value.isLoading
                : isLoading // ignore: cast_nullable_to_non_nullable
                      as bool,
            isSaving: null == isSaving
                ? _value.isSaving
                : isSaving // ignore: cast_nullable_to_non_nullable
                      as bool,
            hasChanges: null == hasChanges
                ? _value.hasChanges
                : hasChanges // ignore: cast_nullable_to_non_nullable
                      as bool,
            selectedRequester: freezed == selectedRequester
                ? _value.selectedRequester
                : selectedRequester // ignore: cast_nullable_to_non_nullable
                      as RequesterModel?,
            selectedCategory: null == selectedCategory
                ? _value.selectedCategory
                : selectedCategory // ignore: cast_nullable_to_non_nullable
                      as PrayerCategory,
            requesters: null == requesters
                ? _value.requesters
                : requesters // ignore: cast_nullable_to_non_nullable
                      as List<RequesterModel>,
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
abstract class _$$PrayerStateImplCopyWith<$Res>
    implements $PrayerStateCopyWith<$Res> {
  factory _$$PrayerStateImplCopyWith(
    _$PrayerStateImpl value,
    $Res Function(_$PrayerStateImpl) then,
  ) = __$$PrayerStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    PrayerRequestModel? prayer,
    bool isLoading,
    bool isSaving,
    bool hasChanges,
    RequesterModel? selectedRequester,
    PrayerCategory selectedCategory,
    List<RequesterModel> requesters,
    String errorMessage,
  });
}

/// @nodoc
class __$$PrayerStateImplCopyWithImpl<$Res>
    extends _$PrayerStateCopyWithImpl<$Res, _$PrayerStateImpl>
    implements _$$PrayerStateImplCopyWith<$Res> {
  __$$PrayerStateImplCopyWithImpl(
    _$PrayerStateImpl _value,
    $Res Function(_$PrayerStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PrayerState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? prayer = freezed,
    Object? isLoading = null,
    Object? isSaving = null,
    Object? hasChanges = null,
    Object? selectedRequester = freezed,
    Object? selectedCategory = null,
    Object? requesters = null,
    Object? errorMessage = null,
  }) {
    return _then(
      _$PrayerStateImpl(
        prayer: freezed == prayer
            ? _value.prayer
            : prayer // ignore: cast_nullable_to_non_nullable
                  as PrayerRequestModel?,
        isLoading: null == isLoading
            ? _value.isLoading
            : isLoading // ignore: cast_nullable_to_non_nullable
                  as bool,
        isSaving: null == isSaving
            ? _value.isSaving
            : isSaving // ignore: cast_nullable_to_non_nullable
                  as bool,
        hasChanges: null == hasChanges
            ? _value.hasChanges
            : hasChanges // ignore: cast_nullable_to_non_nullable
                  as bool,
        selectedRequester: freezed == selectedRequester
            ? _value.selectedRequester
            : selectedRequester // ignore: cast_nullable_to_non_nullable
                  as RequesterModel?,
        selectedCategory: null == selectedCategory
            ? _value.selectedCategory
            : selectedCategory // ignore: cast_nullable_to_non_nullable
                  as PrayerCategory,
        requesters: null == requesters
            ? _value._requesters
            : requesters // ignore: cast_nullable_to_non_nullable
                  as List<RequesterModel>,
        errorMessage: null == errorMessage
            ? _value.errorMessage
            : errorMessage // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$PrayerStateImpl implements _PrayerState {
  const _$PrayerStateImpl({
    this.prayer = null,
    this.isLoading = false,
    this.isSaving = false,
    this.hasChanges = false,
    this.selectedRequester = null,
    this.selectedCategory = PrayerCategory.general,
    final List<RequesterModel> requesters = const [],
    this.errorMessage = '',
  }) : _requesters = requesters;

  @override
  @JsonKey()
  final PrayerRequestModel? prayer;
  @override
  @JsonKey()
  final bool isLoading;
  @override
  @JsonKey()
  final bool isSaving;
  @override
  @JsonKey()
  final bool hasChanges;
  @override
  @JsonKey()
  final RequesterModel? selectedRequester;
  @override
  @JsonKey()
  final PrayerCategory selectedCategory;
  final List<RequesterModel> _requesters;
  @override
  @JsonKey()
  List<RequesterModel> get requesters {
    if (_requesters is EqualUnmodifiableListView) return _requesters;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_requesters);
  }

  @override
  @JsonKey()
  final String errorMessage;

  @override
  String toString() {
    return 'PrayerState(prayer: $prayer, isLoading: $isLoading, isSaving: $isSaving, hasChanges: $hasChanges, selectedRequester: $selectedRequester, selectedCategory: $selectedCategory, requesters: $requesters, errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PrayerStateImpl &&
            (identical(other.prayer, prayer) || other.prayer == prayer) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.isSaving, isSaving) ||
                other.isSaving == isSaving) &&
            (identical(other.hasChanges, hasChanges) ||
                other.hasChanges == hasChanges) &&
            (identical(other.selectedRequester, selectedRequester) ||
                other.selectedRequester == selectedRequester) &&
            (identical(other.selectedCategory, selectedCategory) ||
                other.selectedCategory == selectedCategory) &&
            const DeepCollectionEquality().equals(
              other._requesters,
              _requesters,
            ) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    prayer,
    isLoading,
    isSaving,
    hasChanges,
    selectedRequester,
    selectedCategory,
    const DeepCollectionEquality().hash(_requesters),
    errorMessage,
  );

  /// Create a copy of PrayerState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PrayerStateImplCopyWith<_$PrayerStateImpl> get copyWith =>
      __$$PrayerStateImplCopyWithImpl<_$PrayerStateImpl>(this, _$identity);
}

abstract class _PrayerState implements PrayerState {
  const factory _PrayerState({
    final PrayerRequestModel? prayer,
    final bool isLoading,
    final bool isSaving,
    final bool hasChanges,
    final RequesterModel? selectedRequester,
    final PrayerCategory selectedCategory,
    final List<RequesterModel> requesters,
    final String errorMessage,
  }) = _$PrayerStateImpl;

  @override
  PrayerRequestModel? get prayer;
  @override
  bool get isLoading;
  @override
  bool get isSaving;
  @override
  bool get hasChanges;
  @override
  RequesterModel? get selectedRequester;
  @override
  PrayerCategory get selectedCategory;
  @override
  List<RequesterModel> get requesters;
  @override
  String get errorMessage;

  /// Create a copy of PrayerState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PrayerStateImplCopyWith<_$PrayerStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
