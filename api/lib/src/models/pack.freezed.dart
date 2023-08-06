// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pack.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

ButterflyComponent _$ButterflyComponentFromJson(Map<String, dynamic> json) {
  return _ButterflyComponent.fromJson(json);
}

/// @nodoc
mixin _$ButterflyComponent {
  String get name => throw _privateConstructorUsedError;
  List<PadElement> get elements => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ButterflyComponentCopyWith<ButterflyComponent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ButterflyComponentCopyWith<$Res> {
  factory $ButterflyComponentCopyWith(
          ButterflyComponent value, $Res Function(ButterflyComponent) then) =
      _$ButterflyComponentCopyWithImpl<$Res, ButterflyComponent>;
  @useResult
  $Res call({String name, List<PadElement> elements});
}

/// @nodoc
class _$ButterflyComponentCopyWithImpl<$Res, $Val extends ButterflyComponent>
    implements $ButterflyComponentCopyWith<$Res> {
  _$ButterflyComponentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? elements = null,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      elements: null == elements
          ? _value.elements
          : elements // ignore: cast_nullable_to_non_nullable
              as List<PadElement>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_ButterflyComponentCopyWith<$Res>
    implements $ButterflyComponentCopyWith<$Res> {
  factory _$$_ButterflyComponentCopyWith(_$_ButterflyComponent value,
          $Res Function(_$_ButterflyComponent) then) =
      __$$_ButterflyComponentCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String name, List<PadElement> elements});
}

/// @nodoc
class __$$_ButterflyComponentCopyWithImpl<$Res>
    extends _$ButterflyComponentCopyWithImpl<$Res, _$_ButterflyComponent>
    implements _$$_ButterflyComponentCopyWith<$Res> {
  __$$_ButterflyComponentCopyWithImpl(
      _$_ButterflyComponent _value, $Res Function(_$_ButterflyComponent) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? elements = null,
  }) {
    return _then(_$_ButterflyComponent(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      elements: null == elements
          ? _value._elements
          : elements // ignore: cast_nullable_to_non_nullable
              as List<PadElement>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_ButterflyComponent implements _ButterflyComponent {
  const _$_ButterflyComponent(
      {required this.name,
      final List<PadElement> elements = const <PadElement>[]})
      : _elements = elements;

  factory _$_ButterflyComponent.fromJson(Map<String, dynamic> json) =>
      _$$_ButterflyComponentFromJson(json);

  @override
  final String name;
  final List<PadElement> _elements;
  @override
  @JsonKey()
  List<PadElement> get elements {
    if (_elements is EqualUnmodifiableListView) return _elements;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_elements);
  }

  @override
  String toString() {
    return 'ButterflyComponent(name: $name, elements: $elements)';
  }

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_ButterflyComponentCopyWith<_$_ButterflyComponent> get copyWith =>
      __$$_ButterflyComponentCopyWithImpl<_$_ButterflyComponent>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_ButterflyComponentToJson(
      this,
    );
  }
}

abstract class _ButterflyComponent implements ButterflyComponent {
  const factory _ButterflyComponent(
      {required final String name,
      final List<PadElement> elements}) = _$_ButterflyComponent;

  factory _ButterflyComponent.fromJson(Map<String, dynamic> json) =
      _$_ButterflyComponent.fromJson;

  @override
  String get name;
  @override
  List<PadElement> get elements;
  @override
  @JsonKey(ignore: true)
  _$$_ButterflyComponentCopyWith<_$_ButterflyComponent> get copyWith =>
      throw _privateConstructorUsedError;
}

ButterflyParameter _$ButterflyParameterFromJson(Map<String, dynamic> json) {
  switch (json['type']) {
    case 'text':
      return TextParameter.fromJson(json);
    case 'color':
      return ColorParameter.fromJson(json);
    case 'bool':
      return BoolParameter.fromJson(json);
    case 'int':
      return IntParameter.fromJson(json);
    case 'double':
      return DoubleParameter.fromJson(json);

    default:
      throw CheckedFromJsonException(json, 'type', 'ButterflyParameter',
          'Invalid union type "${json['type']}"!');
  }
}

/// @nodoc
mixin _$ButterflyParameter {
  int get child => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  Object get value => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int child, String name, String value) text,
    required TResult Function(int child, String name, int value) color,
    required TResult Function(int child, String name, bool value) bool,
    required TResult Function(int child, String name, int value) int,
    required TResult Function(int child, String name, double value) double,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int child, String name, String value)? text,
    TResult? Function(int child, String name, int value)? color,
    TResult? Function(int child, String name, bool value)? bool,
    TResult? Function(int child, String name, int value)? int,
    TResult? Function(int child, String name, double value)? double,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int child, String name, String value)? text,
    TResult Function(int child, String name, int value)? color,
    TResult Function(int child, String name, bool value)? bool,
    TResult Function(int child, String name, int value)? int,
    TResult Function(int child, String name, double value)? double,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(TextParameter value) text,
    required TResult Function(ColorParameter value) color,
    required TResult Function(BoolParameter value) bool,
    required TResult Function(IntParameter value) int,
    required TResult Function(DoubleParameter value) double,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(TextParameter value)? text,
    TResult? Function(ColorParameter value)? color,
    TResult? Function(BoolParameter value)? bool,
    TResult? Function(IntParameter value)? int,
    TResult? Function(DoubleParameter value)? double,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(TextParameter value)? text,
    TResult Function(ColorParameter value)? color,
    TResult Function(BoolParameter value)? bool,
    TResult Function(IntParameter value)? int,
    TResult Function(DoubleParameter value)? double,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ButterflyParameterCopyWith<ButterflyParameter> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ButterflyParameterCopyWith<$Res> {
  factory $ButterflyParameterCopyWith(
          ButterflyParameter value, $Res Function(ButterflyParameter) then) =
      _$ButterflyParameterCopyWithImpl<$Res, ButterflyParameter>;
  @useResult
  $Res call({int child, String name});
}

/// @nodoc
class _$ButterflyParameterCopyWithImpl<$Res, $Val extends ButterflyParameter>
    implements $ButterflyParameterCopyWith<$Res> {
  _$ButterflyParameterCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? child = null,
    Object? name = null,
  }) {
    return _then(_value.copyWith(
      child: null == child
          ? _value.child
          : child // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TextParameterCopyWith<$Res>
    implements $ButterflyParameterCopyWith<$Res> {
  factory _$$TextParameterCopyWith(
          _$TextParameter value, $Res Function(_$TextParameter) then) =
      __$$TextParameterCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int child, String name, String value});
}

/// @nodoc
class __$$TextParameterCopyWithImpl<$Res>
    extends _$ButterflyParameterCopyWithImpl<$Res, _$TextParameter>
    implements _$$TextParameterCopyWith<$Res> {
  __$$TextParameterCopyWithImpl(
      _$TextParameter _value, $Res Function(_$TextParameter) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? child = null,
    Object? name = null,
    Object? value = null,
  }) {
    return _then(_$TextParameter(
      child: null == child
          ? _value.child
          : child // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TextParameter implements TextParameter {
  const _$TextParameter(
      {required this.child,
      required this.name,
      required this.value,
      final String? $type})
      : $type = $type ?? 'text';

  factory _$TextParameter.fromJson(Map<String, dynamic> json) =>
      _$$TextParameterFromJson(json);

  @override
  final int child;
  @override
  final String name;
  @override
  final String value;

  @JsonKey(name: 'type')
  final String $type;

  @override
  String toString() {
    return 'ButterflyParameter.text(child: $child, name: $name, value: $value)';
  }

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TextParameterCopyWith<_$TextParameter> get copyWith =>
      __$$TextParameterCopyWithImpl<_$TextParameter>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int child, String name, String value) text,
    required TResult Function(int child, String name, int value) color,
    required TResult Function(int child, String name, bool value) bool,
    required TResult Function(int child, String name, int value) int,
    required TResult Function(int child, String name, double value) double,
  }) {
    return text(child, name, value);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int child, String name, String value)? text,
    TResult? Function(int child, String name, int value)? color,
    TResult? Function(int child, String name, bool value)? bool,
    TResult? Function(int child, String name, int value)? int,
    TResult? Function(int child, String name, double value)? double,
  }) {
    return text?.call(child, name, value);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int child, String name, String value)? text,
    TResult Function(int child, String name, int value)? color,
    TResult Function(int child, String name, bool value)? bool,
    TResult Function(int child, String name, int value)? int,
    TResult Function(int child, String name, double value)? double,
    required TResult orElse(),
  }) {
    if (text != null) {
      return text(child, name, value);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(TextParameter value) text,
    required TResult Function(ColorParameter value) color,
    required TResult Function(BoolParameter value) bool,
    required TResult Function(IntParameter value) int,
    required TResult Function(DoubleParameter value) double,
  }) {
    return text(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(TextParameter value)? text,
    TResult? Function(ColorParameter value)? color,
    TResult? Function(BoolParameter value)? bool,
    TResult? Function(IntParameter value)? int,
    TResult? Function(DoubleParameter value)? double,
  }) {
    return text?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(TextParameter value)? text,
    TResult Function(ColorParameter value)? color,
    TResult Function(BoolParameter value)? bool,
    TResult Function(IntParameter value)? int,
    TResult Function(DoubleParameter value)? double,
    required TResult orElse(),
  }) {
    if (text != null) {
      return text(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$TextParameterToJson(
      this,
    );
  }
}

abstract class TextParameter implements ButterflyParameter {
  const factory TextParameter(
      {required final int child,
      required final String name,
      required final String value}) = _$TextParameter;

  factory TextParameter.fromJson(Map<String, dynamic> json) =
      _$TextParameter.fromJson;

  @override
  int get child;
  @override
  String get name;
  @override
  String get value;
  @override
  @JsonKey(ignore: true)
  _$$TextParameterCopyWith<_$TextParameter> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ColorParameterCopyWith<$Res>
    implements $ButterflyParameterCopyWith<$Res> {
  factory _$$ColorParameterCopyWith(
          _$ColorParameter value, $Res Function(_$ColorParameter) then) =
      __$$ColorParameterCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int child, String name, int value});
}

/// @nodoc
class __$$ColorParameterCopyWithImpl<$Res>
    extends _$ButterflyParameterCopyWithImpl<$Res, _$ColorParameter>
    implements _$$ColorParameterCopyWith<$Res> {
  __$$ColorParameterCopyWithImpl(
      _$ColorParameter _value, $Res Function(_$ColorParameter) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? child = null,
    Object? name = null,
    Object? value = null,
  }) {
    return _then(_$ColorParameter(
      child: null == child
          ? _value.child
          : child // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ColorParameter implements ColorParameter {
  const _$ColorParameter(
      {required this.child,
      required this.name,
      required this.value,
      final String? $type})
      : $type = $type ?? 'color';

  factory _$ColorParameter.fromJson(Map<String, dynamic> json) =>
      _$$ColorParameterFromJson(json);

  @override
  final int child;
  @override
  final String name;
  @override
  final int value;

  @JsonKey(name: 'type')
  final String $type;

  @override
  String toString() {
    return 'ButterflyParameter.color(child: $child, name: $name, value: $value)';
  }

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ColorParameterCopyWith<_$ColorParameter> get copyWith =>
      __$$ColorParameterCopyWithImpl<_$ColorParameter>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int child, String name, String value) text,
    required TResult Function(int child, String name, int value) color,
    required TResult Function(int child, String name, bool value) bool,
    required TResult Function(int child, String name, int value) int,
    required TResult Function(int child, String name, double value) double,
  }) {
    return color(child, name, value);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int child, String name, String value)? text,
    TResult? Function(int child, String name, int value)? color,
    TResult? Function(int child, String name, bool value)? bool,
    TResult? Function(int child, String name, int value)? int,
    TResult? Function(int child, String name, double value)? double,
  }) {
    return color?.call(child, name, value);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int child, String name, String value)? text,
    TResult Function(int child, String name, int value)? color,
    TResult Function(int child, String name, bool value)? bool,
    TResult Function(int child, String name, int value)? int,
    TResult Function(int child, String name, double value)? double,
    required TResult orElse(),
  }) {
    if (color != null) {
      return color(child, name, value);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(TextParameter value) text,
    required TResult Function(ColorParameter value) color,
    required TResult Function(BoolParameter value) bool,
    required TResult Function(IntParameter value) int,
    required TResult Function(DoubleParameter value) double,
  }) {
    return color(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(TextParameter value)? text,
    TResult? Function(ColorParameter value)? color,
    TResult? Function(BoolParameter value)? bool,
    TResult? Function(IntParameter value)? int,
    TResult? Function(DoubleParameter value)? double,
  }) {
    return color?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(TextParameter value)? text,
    TResult Function(ColorParameter value)? color,
    TResult Function(BoolParameter value)? bool,
    TResult Function(IntParameter value)? int,
    TResult Function(DoubleParameter value)? double,
    required TResult orElse(),
  }) {
    if (color != null) {
      return color(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$ColorParameterToJson(
      this,
    );
  }
}

abstract class ColorParameter implements ButterflyParameter {
  const factory ColorParameter(
      {required final int child,
      required final String name,
      required final int value}) = _$ColorParameter;

  factory ColorParameter.fromJson(Map<String, dynamic> json) =
      _$ColorParameter.fromJson;

  @override
  int get child;
  @override
  String get name;
  @override
  int get value;
  @override
  @JsonKey(ignore: true)
  _$$ColorParameterCopyWith<_$ColorParameter> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$BoolParameterCopyWith<$Res>
    implements $ButterflyParameterCopyWith<$Res> {
  factory _$$BoolParameterCopyWith(
          _$BoolParameter value, $Res Function(_$BoolParameter) then) =
      __$$BoolParameterCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int child, String name, bool value});
}

/// @nodoc
class __$$BoolParameterCopyWithImpl<$Res>
    extends _$ButterflyParameterCopyWithImpl<$Res, _$BoolParameter>
    implements _$$BoolParameterCopyWith<$Res> {
  __$$BoolParameterCopyWithImpl(
      _$BoolParameter _value, $Res Function(_$BoolParameter) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? child = null,
    Object? name = null,
    Object? value = null,
  }) {
    return _then(_$BoolParameter(
      child: null == child
          ? _value.child
          : child // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BoolParameter implements BoolParameter {
  const _$BoolParameter(
      {required this.child,
      required this.name,
      required this.value,
      final String? $type})
      : $type = $type ?? 'bool';

  factory _$BoolParameter.fromJson(Map<String, dynamic> json) =>
      _$$BoolParameterFromJson(json);

  @override
  final int child;
  @override
  final String name;
  @override
  final bool value;

  @JsonKey(name: 'type')
  final String $type;

  @override
  String toString() {
    return 'ButterflyParameter.bool(child: $child, name: $name, value: $value)';
  }

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BoolParameterCopyWith<_$BoolParameter> get copyWith =>
      __$$BoolParameterCopyWithImpl<_$BoolParameter>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int child, String name, String value) text,
    required TResult Function(int child, String name, int value) color,
    required TResult Function(int child, String name, bool value) bool,
    required TResult Function(int child, String name, int value) int,
    required TResult Function(int child, String name, double value) double,
  }) {
    return bool(child, name, value);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int child, String name, String value)? text,
    TResult? Function(int child, String name, int value)? color,
    TResult? Function(int child, String name, bool value)? bool,
    TResult? Function(int child, String name, int value)? int,
    TResult? Function(int child, String name, double value)? double,
  }) {
    return bool?.call(child, name, value);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int child, String name, String value)? text,
    TResult Function(int child, String name, int value)? color,
    TResult Function(int child, String name, bool value)? bool,
    TResult Function(int child, String name, int value)? int,
    TResult Function(int child, String name, double value)? double,
    required TResult orElse(),
  }) {
    if (bool != null) {
      return bool(child, name, value);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(TextParameter value) text,
    required TResult Function(ColorParameter value) color,
    required TResult Function(BoolParameter value) bool,
    required TResult Function(IntParameter value) int,
    required TResult Function(DoubleParameter value) double,
  }) {
    return bool(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(TextParameter value)? text,
    TResult? Function(ColorParameter value)? color,
    TResult? Function(BoolParameter value)? bool,
    TResult? Function(IntParameter value)? int,
    TResult? Function(DoubleParameter value)? double,
  }) {
    return bool?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(TextParameter value)? text,
    TResult Function(ColorParameter value)? color,
    TResult Function(BoolParameter value)? bool,
    TResult Function(IntParameter value)? int,
    TResult Function(DoubleParameter value)? double,
    required TResult orElse(),
  }) {
    if (bool != null) {
      return bool(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$BoolParameterToJson(
      this,
    );
  }
}

abstract class BoolParameter implements ButterflyParameter {
  const factory BoolParameter(
      {required final int child,
      required final String name,
      required final bool value}) = _$BoolParameter;

  factory BoolParameter.fromJson(Map<String, dynamic> json) =
      _$BoolParameter.fromJson;

  @override
  int get child;
  @override
  String get name;
  @override
  bool get value;
  @override
  @JsonKey(ignore: true)
  _$$BoolParameterCopyWith<_$BoolParameter> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$IntParameterCopyWith<$Res>
    implements $ButterflyParameterCopyWith<$Res> {
  factory _$$IntParameterCopyWith(
          _$IntParameter value, $Res Function(_$IntParameter) then) =
      __$$IntParameterCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int child, String name, int value});
}

/// @nodoc
class __$$IntParameterCopyWithImpl<$Res>
    extends _$ButterflyParameterCopyWithImpl<$Res, _$IntParameter>
    implements _$$IntParameterCopyWith<$Res> {
  __$$IntParameterCopyWithImpl(
      _$IntParameter _value, $Res Function(_$IntParameter) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? child = null,
    Object? name = null,
    Object? value = null,
  }) {
    return _then(_$IntParameter(
      child: null == child
          ? _value.child
          : child // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$IntParameter implements IntParameter {
  const _$IntParameter(
      {required this.child,
      required this.name,
      required this.value,
      final String? $type})
      : $type = $type ?? 'int';

  factory _$IntParameter.fromJson(Map<String, dynamic> json) =>
      _$$IntParameterFromJson(json);

  @override
  final int child;
  @override
  final String name;
  @override
  final int value;

  @JsonKey(name: 'type')
  final String $type;

  @override
  String toString() {
    return 'ButterflyParameter.int(child: $child, name: $name, value: $value)';
  }

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$IntParameterCopyWith<_$IntParameter> get copyWith =>
      __$$IntParameterCopyWithImpl<_$IntParameter>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int child, String name, String value) text,
    required TResult Function(int child, String name, int value) color,
    required TResult Function(int child, String name, bool value) bool,
    required TResult Function(int child, String name, int value) int,
    required TResult Function(int child, String name, double value) double,
  }) {
    return int(child, name, value);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int child, String name, String value)? text,
    TResult? Function(int child, String name, int value)? color,
    TResult? Function(int child, String name, bool value)? bool,
    TResult? Function(int child, String name, int value)? int,
    TResult? Function(int child, String name, double value)? double,
  }) {
    return int?.call(child, name, value);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int child, String name, String value)? text,
    TResult Function(int child, String name, int value)? color,
    TResult Function(int child, String name, bool value)? bool,
    TResult Function(int child, String name, int value)? int,
    TResult Function(int child, String name, double value)? double,
    required TResult orElse(),
  }) {
    if (int != null) {
      return int(child, name, value);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(TextParameter value) text,
    required TResult Function(ColorParameter value) color,
    required TResult Function(BoolParameter value) bool,
    required TResult Function(IntParameter value) int,
    required TResult Function(DoubleParameter value) double,
  }) {
    return int(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(TextParameter value)? text,
    TResult? Function(ColorParameter value)? color,
    TResult? Function(BoolParameter value)? bool,
    TResult? Function(IntParameter value)? int,
    TResult? Function(DoubleParameter value)? double,
  }) {
    return int?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(TextParameter value)? text,
    TResult Function(ColorParameter value)? color,
    TResult Function(BoolParameter value)? bool,
    TResult Function(IntParameter value)? int,
    TResult Function(DoubleParameter value)? double,
    required TResult orElse(),
  }) {
    if (int != null) {
      return int(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$IntParameterToJson(
      this,
    );
  }
}

abstract class IntParameter implements ButterflyParameter {
  const factory IntParameter(
      {required final int child,
      required final String name,
      required final int value}) = _$IntParameter;

  factory IntParameter.fromJson(Map<String, dynamic> json) =
      _$IntParameter.fromJson;

  @override
  int get child;
  @override
  String get name;
  @override
  int get value;
  @override
  @JsonKey(ignore: true)
  _$$IntParameterCopyWith<_$IntParameter> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$DoubleParameterCopyWith<$Res>
    implements $ButterflyParameterCopyWith<$Res> {
  factory _$$DoubleParameterCopyWith(
          _$DoubleParameter value, $Res Function(_$DoubleParameter) then) =
      __$$DoubleParameterCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int child, String name, double value});
}

/// @nodoc
class __$$DoubleParameterCopyWithImpl<$Res>
    extends _$ButterflyParameterCopyWithImpl<$Res, _$DoubleParameter>
    implements _$$DoubleParameterCopyWith<$Res> {
  __$$DoubleParameterCopyWithImpl(
      _$DoubleParameter _value, $Res Function(_$DoubleParameter) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? child = null,
    Object? name = null,
    Object? value = null,
  }) {
    return _then(_$DoubleParameter(
      child: null == child
          ? _value.child
          : child // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DoubleParameter implements DoubleParameter {
  const _$DoubleParameter(
      {required this.child,
      required this.name,
      required this.value,
      final String? $type})
      : $type = $type ?? 'double';

  factory _$DoubleParameter.fromJson(Map<String, dynamic> json) =>
      _$$DoubleParameterFromJson(json);

  @override
  final int child;
  @override
  final String name;
  @override
  final double value;

  @JsonKey(name: 'type')
  final String $type;

  @override
  String toString() {
    return 'ButterflyParameter.double(child: $child, name: $name, value: $value)';
  }

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DoubleParameterCopyWith<_$DoubleParameter> get copyWith =>
      __$$DoubleParameterCopyWithImpl<_$DoubleParameter>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int child, String name, String value) text,
    required TResult Function(int child, String name, int value) color,
    required TResult Function(int child, String name, bool value) bool,
    required TResult Function(int child, String name, int value) int,
    required TResult Function(int child, String name, double value) double,
  }) {
    return double(child, name, value);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int child, String name, String value)? text,
    TResult? Function(int child, String name, int value)? color,
    TResult? Function(int child, String name, bool value)? bool,
    TResult? Function(int child, String name, int value)? int,
    TResult? Function(int child, String name, double value)? double,
  }) {
    return double?.call(child, name, value);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int child, String name, String value)? text,
    TResult Function(int child, String name, int value)? color,
    TResult Function(int child, String name, bool value)? bool,
    TResult Function(int child, String name, int value)? int,
    TResult Function(int child, String name, double value)? double,
    required TResult orElse(),
  }) {
    if (double != null) {
      return double(child, name, value);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(TextParameter value) text,
    required TResult Function(ColorParameter value) color,
    required TResult Function(BoolParameter value) bool,
    required TResult Function(IntParameter value) int,
    required TResult Function(DoubleParameter value) double,
  }) {
    return double(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(TextParameter value)? text,
    TResult? Function(ColorParameter value)? color,
    TResult? Function(BoolParameter value)? bool,
    TResult? Function(IntParameter value)? int,
    TResult? Function(DoubleParameter value)? double,
  }) {
    return double?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(TextParameter value)? text,
    TResult Function(ColorParameter value)? color,
    TResult Function(BoolParameter value)? bool,
    TResult Function(IntParameter value)? int,
    TResult Function(DoubleParameter value)? double,
    required TResult orElse(),
  }) {
    if (double != null) {
      return double(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$DoubleParameterToJson(
      this,
    );
  }
}

abstract class DoubleParameter implements ButterflyParameter {
  const factory DoubleParameter(
      {required final int child,
      required final String name,
      required final double value}) = _$DoubleParameter;

  factory DoubleParameter.fromJson(Map<String, dynamic> json) =
      _$DoubleParameter.fromJson;

  @override
  int get child;
  @override
  String get name;
  @override
  double get value;
  @override
  @JsonKey(ignore: true)
  _$$DoubleParameterCopyWith<_$DoubleParameter> get copyWith =>
      throw _privateConstructorUsedError;
}

PackAssetLocation _$PackAssetLocationFromJson(Map<String, dynamic> json) {
  return _PackAssetLocation.fromJson(json);
}

/// @nodoc
mixin _$PackAssetLocation {
  String get pack => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PackAssetLocationCopyWith<PackAssetLocation> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PackAssetLocationCopyWith<$Res> {
  factory $PackAssetLocationCopyWith(
          PackAssetLocation value, $Res Function(PackAssetLocation) then) =
      _$PackAssetLocationCopyWithImpl<$Res, PackAssetLocation>;
  @useResult
  $Res call({String pack, String name});
}

/// @nodoc
class _$PackAssetLocationCopyWithImpl<$Res, $Val extends PackAssetLocation>
    implements $PackAssetLocationCopyWith<$Res> {
  _$PackAssetLocationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pack = null,
    Object? name = null,
  }) {
    return _then(_value.copyWith(
      pack: null == pack
          ? _value.pack
          : pack // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_PackAssetLocationCopyWith<$Res>
    implements $PackAssetLocationCopyWith<$Res> {
  factory _$$_PackAssetLocationCopyWith(_$_PackAssetLocation value,
          $Res Function(_$_PackAssetLocation) then) =
      __$$_PackAssetLocationCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String pack, String name});
}

/// @nodoc
class __$$_PackAssetLocationCopyWithImpl<$Res>
    extends _$PackAssetLocationCopyWithImpl<$Res, _$_PackAssetLocation>
    implements _$$_PackAssetLocationCopyWith<$Res> {
  __$$_PackAssetLocationCopyWithImpl(
      _$_PackAssetLocation _value, $Res Function(_$_PackAssetLocation) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pack = null,
    Object? name = null,
  }) {
    return _then(_$_PackAssetLocation(
      null == pack
          ? _value.pack
          : pack // ignore: cast_nullable_to_non_nullable
              as String,
      null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_PackAssetLocation extends _PackAssetLocation {
  const _$_PackAssetLocation([this.pack = '', this.name = '']) : super._();

  factory _$_PackAssetLocation.fromJson(Map<String, dynamic> json) =>
      _$$_PackAssetLocationFromJson(json);

  @override
  @JsonKey()
  final String pack;
  @override
  @JsonKey()
  final String name;

  @override
  String toString() {
    return 'PackAssetLocation(pack: $pack, name: $name)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_PackAssetLocation &&
            (identical(other.pack, pack) || other.pack == pack) &&
            (identical(other.name, name) || other.name == name));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, pack, name);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_PackAssetLocationCopyWith<_$_PackAssetLocation> get copyWith =>
      __$$_PackAssetLocationCopyWithImpl<_$_PackAssetLocation>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_PackAssetLocationToJson(
      this,
    );
  }
}

abstract class _PackAssetLocation extends PackAssetLocation {
  const factory _PackAssetLocation([final String pack, final String name]) =
      _$_PackAssetLocation;
  const _PackAssetLocation._() : super._();

  factory _PackAssetLocation.fromJson(Map<String, dynamic> json) =
      _$_PackAssetLocation.fromJson;

  @override
  String get pack;
  @override
  String get name;
  @override
  @JsonKey(ignore: true)
  _$$_PackAssetLocationCopyWith<_$_PackAssetLocation> get copyWith =>
      throw _privateConstructorUsedError;
}
