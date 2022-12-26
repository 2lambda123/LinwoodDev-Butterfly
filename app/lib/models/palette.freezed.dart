// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'palette.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

ColorPalette _$ColorPaletteFromJson(Map<String, dynamic> json) {
  return _ColorPalette.fromJson(json);
}

/// @nodoc
mixin _$ColorPalette {
  String get name => throw _privateConstructorUsedError;
  List<int> get colors => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ColorPaletteCopyWith<ColorPalette> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ColorPaletteCopyWith<$Res> {
  factory $ColorPaletteCopyWith(
          ColorPalette value, $Res Function(ColorPalette) then) =
      _$ColorPaletteCopyWithImpl<$Res, ColorPalette>;
  @useResult
  $Res call({String name, List<int> colors});
}

/// @nodoc
class _$ColorPaletteCopyWithImpl<$Res, $Val extends ColorPalette>
    implements $ColorPaletteCopyWith<$Res> {
  _$ColorPaletteCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? colors = null,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      colors: null == colors
          ? _value.colors
          : colors // ignore: cast_nullable_to_non_nullable
              as List<int>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_ColorPaletteCopyWith<$Res>
    implements $ColorPaletteCopyWith<$Res> {
  factory _$$_ColorPaletteCopyWith(
          _$_ColorPalette value, $Res Function(_$_ColorPalette) then) =
      __$$_ColorPaletteCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String name, List<int> colors});
}

/// @nodoc
class __$$_ColorPaletteCopyWithImpl<$Res>
    extends _$ColorPaletteCopyWithImpl<$Res, _$_ColorPalette>
    implements _$$_ColorPaletteCopyWith<$Res> {
  __$$_ColorPaletteCopyWithImpl(
      _$_ColorPalette _value, $Res Function(_$_ColorPalette) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? colors = null,
  }) {
    return _then(_$_ColorPalette(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      colors: null == colors
          ? _value._colors
          : colors // ignore: cast_nullable_to_non_nullable
              as List<int>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_ColorPalette implements _ColorPalette {
  const _$_ColorPalette({required this.name, final List<int> colors = const []})
      : _colors = colors;

  factory _$_ColorPalette.fromJson(Map<String, dynamic> json) =>
      _$$_ColorPaletteFromJson(json);

  @override
  final String name;
  final List<int> _colors;
  @override
  @JsonKey()
  List<int> get colors {
    if (_colors is EqualUnmodifiableListView) return _colors;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_colors);
  }

  @override
  String toString() {
    return 'ColorPalette(name: $name, colors: $colors)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ColorPalette &&
            (identical(other.name, name) || other.name == name) &&
            const DeepCollectionEquality().equals(other._colors, _colors));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, name, const DeepCollectionEquality().hash(_colors));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_ColorPaletteCopyWith<_$_ColorPalette> get copyWith =>
      __$$_ColorPaletteCopyWithImpl<_$_ColorPalette>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_ColorPaletteToJson(
      this,
    );
  }
}

abstract class _ColorPalette implements ColorPalette {
  const factory _ColorPalette(
      {required final String name, final List<int> colors}) = _$_ColorPalette;

  factory _ColorPalette.fromJson(Map<String, dynamic> json) =
      _$_ColorPalette.fromJson;

  @override
  String get name;
  @override
  List<int> get colors;
  @override
  @JsonKey(ignore: true)
  _$$_ColorPaletteCopyWith<_$_ColorPalette> get copyWith =>
      throw _privateConstructorUsedError;
}
