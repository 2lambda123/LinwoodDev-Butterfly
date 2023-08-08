// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tool.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

ToolState _$ToolStateFromJson(Map<String, dynamic> json) {
  return _ToolState.fromJson(json);
}

/// @nodoc
mixin _$ToolState {
  bool get lockZoom => throw _privateConstructorUsedError;
  bool get lockHorizontal => throw _privateConstructorUsedError;
  bool get lockVertical => throw _privateConstructorUsedError;
  bool get rulerEnabled => throw _privateConstructorUsedError;
  bool get gridEnabled => throw _privateConstructorUsedError;
  @DoublePointJsonConverter()
  Point<double> get rulerPosition => throw _privateConstructorUsedError;
  double get rulerAngle => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ToolStateCopyWith<ToolState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ToolStateCopyWith<$Res> {
  factory $ToolStateCopyWith(ToolState value, $Res Function(ToolState) then) =
      _$ToolStateCopyWithImpl<$Res, ToolState>;
  @useResult
  $Res call(
      {bool lockZoom,
      bool lockHorizontal,
      bool lockVertical,
      bool rulerEnabled,
      bool gridEnabled,
      @DoublePointJsonConverter() Point<double> rulerPosition,
      double rulerAngle});
}

/// @nodoc
class _$ToolStateCopyWithImpl<$Res, $Val extends ToolState>
    implements $ToolStateCopyWith<$Res> {
  _$ToolStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? lockZoom = null,
    Object? lockHorizontal = null,
    Object? lockVertical = null,
    Object? rulerEnabled = null,
    Object? gridEnabled = null,
    Object? rulerPosition = null,
    Object? rulerAngle = null,
  }) {
    return _then(_value.copyWith(
      lockZoom: null == lockZoom
          ? _value.lockZoom
          : lockZoom // ignore: cast_nullable_to_non_nullable
              as bool,
      lockHorizontal: null == lockHorizontal
          ? _value.lockHorizontal
          : lockHorizontal // ignore: cast_nullable_to_non_nullable
              as bool,
      lockVertical: null == lockVertical
          ? _value.lockVertical
          : lockVertical // ignore: cast_nullable_to_non_nullable
              as bool,
      rulerEnabled: null == rulerEnabled
          ? _value.rulerEnabled
          : rulerEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      gridEnabled: null == gridEnabled
          ? _value.gridEnabled
          : gridEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      rulerPosition: null == rulerPosition
          ? _value.rulerPosition
          : rulerPosition // ignore: cast_nullable_to_non_nullable
              as Point<double>,
      rulerAngle: null == rulerAngle
          ? _value.rulerAngle
          : rulerAngle // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_ToolStateCopyWith<$Res> implements $ToolStateCopyWith<$Res> {
  factory _$$_ToolStateCopyWith(
          _$_ToolState value, $Res Function(_$_ToolState) then) =
      __$$_ToolStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool lockZoom,
      bool lockHorizontal,
      bool lockVertical,
      bool rulerEnabled,
      bool gridEnabled,
      @DoublePointJsonConverter() Point<double> rulerPosition,
      double rulerAngle});
}

/// @nodoc
class __$$_ToolStateCopyWithImpl<$Res>
    extends _$ToolStateCopyWithImpl<$Res, _$_ToolState>
    implements _$$_ToolStateCopyWith<$Res> {
  __$$_ToolStateCopyWithImpl(
      _$_ToolState _value, $Res Function(_$_ToolState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? lockZoom = null,
    Object? lockHorizontal = null,
    Object? lockVertical = null,
    Object? rulerEnabled = null,
    Object? gridEnabled = null,
    Object? rulerPosition = null,
    Object? rulerAngle = null,
  }) {
    return _then(_$_ToolState(
      lockZoom: null == lockZoom
          ? _value.lockZoom
          : lockZoom // ignore: cast_nullable_to_non_nullable
              as bool,
      lockHorizontal: null == lockHorizontal
          ? _value.lockHorizontal
          : lockHorizontal // ignore: cast_nullable_to_non_nullable
              as bool,
      lockVertical: null == lockVertical
          ? _value.lockVertical
          : lockVertical // ignore: cast_nullable_to_non_nullable
              as bool,
      rulerEnabled: null == rulerEnabled
          ? _value.rulerEnabled
          : rulerEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      gridEnabled: null == gridEnabled
          ? _value.gridEnabled
          : gridEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      rulerPosition: null == rulerPosition
          ? _value.rulerPosition
          : rulerPosition // ignore: cast_nullable_to_non_nullable
              as Point<double>,
      rulerAngle: null == rulerAngle
          ? _value.rulerAngle
          : rulerAngle // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_ToolState implements _ToolState {
  const _$_ToolState(
      {this.lockZoom = false,
      this.lockHorizontal = false,
      this.lockVertical = false,
      this.rulerEnabled = false,
      this.gridEnabled = false,
      @DoublePointJsonConverter() this.rulerPosition = const Point(0.0, 0.0),
      this.rulerAngle = 0});

  factory _$_ToolState.fromJson(Map<String, dynamic> json) =>
      _$$_ToolStateFromJson(json);

  @override
  @JsonKey()
  final bool lockZoom;
  @override
  @JsonKey()
  final bool lockHorizontal;
  @override
  @JsonKey()
  final bool lockVertical;
  @override
  @JsonKey()
  final bool rulerEnabled;
  @override
  @JsonKey()
  final bool gridEnabled;
  @override
  @JsonKey()
  @DoublePointJsonConverter()
  final Point<double> rulerPosition;
  @override
  @JsonKey()
  final double rulerAngle;

  @override
  String toString() {
    return 'ToolState(lockZoom: $lockZoom, lockHorizontal: $lockHorizontal, lockVertical: $lockVertical, rulerEnabled: $rulerEnabled, gridEnabled: $gridEnabled, rulerPosition: $rulerPosition, rulerAngle: $rulerAngle)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ToolState &&
            (identical(other.lockZoom, lockZoom) ||
                other.lockZoom == lockZoom) &&
            (identical(other.lockHorizontal, lockHorizontal) ||
                other.lockHorizontal == lockHorizontal) &&
            (identical(other.lockVertical, lockVertical) ||
                other.lockVertical == lockVertical) &&
            (identical(other.rulerEnabled, rulerEnabled) ||
                other.rulerEnabled == rulerEnabled) &&
            (identical(other.gridEnabled, gridEnabled) ||
                other.gridEnabled == gridEnabled) &&
            (identical(other.rulerPosition, rulerPosition) ||
                other.rulerPosition == rulerPosition) &&
            (identical(other.rulerAngle, rulerAngle) ||
                other.rulerAngle == rulerAngle));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, lockZoom, lockHorizontal,
      lockVertical, rulerEnabled, gridEnabled, rulerPosition, rulerAngle);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_ToolStateCopyWith<_$_ToolState> get copyWith =>
      __$$_ToolStateCopyWithImpl<_$_ToolState>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_ToolStateToJson(
      this,
    );
  }
}

abstract class _ToolState implements ToolState {
  const factory _ToolState(
      {final bool lockZoom,
      final bool lockHorizontal,
      final bool lockVertical,
      final bool rulerEnabled,
      final bool gridEnabled,
      @DoublePointJsonConverter() final Point<double> rulerPosition,
      final double rulerAngle}) = _$_ToolState;

  factory _ToolState.fromJson(Map<String, dynamic> json) =
      _$_ToolState.fromJson;

  @override
  bool get lockZoom;
  @override
  bool get lockHorizontal;
  @override
  bool get lockVertical;
  @override
  bool get rulerEnabled;
  @override
  bool get gridEnabled;
  @override
  @DoublePointJsonConverter()
  Point<double> get rulerPosition;
  @override
  double get rulerAngle;
  @override
  @JsonKey(ignore: true)
  _$$_ToolStateCopyWith<_$_ToolState> get copyWith =>
      throw _privateConstructorUsedError;
}
