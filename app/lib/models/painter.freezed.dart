// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'painter.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

Painter _$PainterFromJson(Map<String, dynamic> json) {
  switch (json['type']) {
    case 'label':
      return LabelPainter.fromJson(json);
    case 'pen':
      return PenPainter.fromJson(json);
    case 'eraser':
      return EraserPainter.fromJson(json);
    case 'pathEraser':
      return PathEraserPainter.fromJson(json);
    case 'layer':
      return LayerPainter.fromJson(json);
    case 'area':
      return AreaPainter.fromJson(json);

    default:
      throw CheckedFromJsonException(
          json, 'type', 'Painter', 'Invalid union type "${json['type']}"!');
  }
}

/// @nodoc
class _$PainterTearOff {
  const _$PainterTearOff();

  LabelPainter label(
      {String name = '', LabelProperty property = const LabelProperty()}) {
    return LabelPainter(
      name: name,
      property: property,
    );
  }

  PenPainter pen(
      {String name = '',
      bool zoomDependent = false,
      PenProperty property = const PenProperty()}) {
    return PenPainter(
      name: name,
      zoomDependent: zoomDependent,
      property: property,
    );
  }

  EraserPainter eraser(
      {String name = '', EraserProperty property = const EraserProperty()}) {
    return EraserPainter(
      name: name,
      property: property,
    );
  }

  PathEraserPainter pathEraser(
      {String name = '',
      double strokeWidth = 5,
      bool includeEraser = false,
      bool deleteWholeStroke = false}) {
    return PathEraserPainter(
      name: name,
      strokeWidth: strokeWidth,
      includeEraser: includeEraser,
      deleteWholeStroke: deleteWholeStroke,
    );
  }

  LayerPainter layer(
      {String name = '', String layer = '', bool includeEraser = false}) {
    return LayerPainter(
      name: name,
      layer: layer,
      includeEraser: includeEraser,
    );
  }

  AreaPainter area(
      {String name = '',
      double constrainedWidth = 0,
      double constrainedHeight = 0,
      double constrainedAspectRatio = 0}) {
    return AreaPainter(
      name: name,
      constrainedWidth: constrainedWidth,
      constrainedHeight: constrainedHeight,
      constrainedAspectRatio: constrainedAspectRatio,
    );
  }

  Painter fromJson(Map<String, Object?> json) {
    return Painter.fromJson(json);
  }
}

/// @nodoc
const $Painter = _$PainterTearOff();

/// @nodoc
mixin _$Painter {
  String get name => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String name, LabelProperty property) label,
    required TResult Function(
            String name, bool zoomDependent, PenProperty property)
        pen,
    required TResult Function(String name, EraserProperty property) eraser,
    required TResult Function(String name, double strokeWidth,
            bool includeEraser, bool deleteWholeStroke)
        pathEraser,
    required TResult Function(String name, String layer, bool includeEraser)
        layer,
    required TResult Function(String name, double constrainedWidth,
            double constrainedHeight, double constrainedAspectRatio)
        area,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(String name, LabelProperty property)? label,
    TResult Function(String name, bool zoomDependent, PenProperty property)?
        pen,
    TResult Function(String name, EraserProperty property)? eraser,
    TResult Function(String name, double strokeWidth, bool includeEraser,
            bool deleteWholeStroke)?
        pathEraser,
    TResult Function(String name, String layer, bool includeEraser)? layer,
    TResult Function(String name, double constrainedWidth,
            double constrainedHeight, double constrainedAspectRatio)?
        area,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String name, LabelProperty property)? label,
    TResult Function(String name, bool zoomDependent, PenProperty property)?
        pen,
    TResult Function(String name, EraserProperty property)? eraser,
    TResult Function(String name, double strokeWidth, bool includeEraser,
            bool deleteWholeStroke)?
        pathEraser,
    TResult Function(String name, String layer, bool includeEraser)? layer,
    TResult Function(String name, double constrainedWidth,
            double constrainedHeight, double constrainedAspectRatio)?
        area,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LabelPainter value) label,
    required TResult Function(PenPainter value) pen,
    required TResult Function(EraserPainter value) eraser,
    required TResult Function(PathEraserPainter value) pathEraser,
    required TResult Function(LayerPainter value) layer,
    required TResult Function(AreaPainter value) area,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(LabelPainter value)? label,
    TResult Function(PenPainter value)? pen,
    TResult Function(EraserPainter value)? eraser,
    TResult Function(PathEraserPainter value)? pathEraser,
    TResult Function(LayerPainter value)? layer,
    TResult Function(AreaPainter value)? area,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LabelPainter value)? label,
    TResult Function(PenPainter value)? pen,
    TResult Function(EraserPainter value)? eraser,
    TResult Function(PathEraserPainter value)? pathEraser,
    TResult Function(LayerPainter value)? layer,
    TResult Function(AreaPainter value)? area,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PainterCopyWith<Painter> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PainterCopyWith<$Res> {
  factory $PainterCopyWith(Painter value, $Res Function(Painter) then) =
      _$PainterCopyWithImpl<$Res>;
  $Res call({String name});
}

/// @nodoc
class _$PainterCopyWithImpl<$Res> implements $PainterCopyWith<$Res> {
  _$PainterCopyWithImpl(this._value, this._then);

  final Painter _value;
  // ignore: unused_field
  final $Res Function(Painter) _then;

  @override
  $Res call({
    Object? name = freezed,
  }) {
    return _then(_value.copyWith(
      name: name == freezed
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
abstract class $LabelPainterCopyWith<$Res> implements $PainterCopyWith<$Res> {
  factory $LabelPainterCopyWith(
          LabelPainter value, $Res Function(LabelPainter) then) =
      _$LabelPainterCopyWithImpl<$Res>;
  @override
  $Res call({String name, LabelProperty property});
}

/// @nodoc
class _$LabelPainterCopyWithImpl<$Res> extends _$PainterCopyWithImpl<$Res>
    implements $LabelPainterCopyWith<$Res> {
  _$LabelPainterCopyWithImpl(
      LabelPainter _value, $Res Function(LabelPainter) _then)
      : super(_value, (v) => _then(v as LabelPainter));

  @override
  LabelPainter get _value => super._value as LabelPainter;

  @override
  $Res call({
    Object? name = freezed,
    Object? property = freezed,
  }) {
    return _then(LabelPainter(
      name: name == freezed
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      property: property == freezed
          ? _value.property
          : property // ignore: cast_nullable_to_non_nullable
              as LabelProperty,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LabelPainter implements LabelPainter {
  const _$LabelPainter(
      {this.name = '', this.property = const LabelProperty(), String? $type})
      : $type = $type ?? 'label';

  factory _$LabelPainter.fromJson(Map<String, dynamic> json) =>
      _$$LabelPainterFromJson(json);

  @JsonKey()
  @override
  final String name;
  @JsonKey()
  @override
  final LabelProperty property;

  @JsonKey(name: 'type')
  final String $type;

  @override
  String toString() {
    return 'Painter.label(name: $name, property: $property)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is LabelPainter &&
            const DeepCollectionEquality().equals(other.name, name) &&
            const DeepCollectionEquality().equals(other.property, property));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(name),
      const DeepCollectionEquality().hash(property));

  @JsonKey(ignore: true)
  @override
  $LabelPainterCopyWith<LabelPainter> get copyWith =>
      _$LabelPainterCopyWithImpl<LabelPainter>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String name, LabelProperty property) label,
    required TResult Function(
            String name, bool zoomDependent, PenProperty property)
        pen,
    required TResult Function(String name, EraserProperty property) eraser,
    required TResult Function(String name, double strokeWidth,
            bool includeEraser, bool deleteWholeStroke)
        pathEraser,
    required TResult Function(String name, String layer, bool includeEraser)
        layer,
    required TResult Function(String name, double constrainedWidth,
            double constrainedHeight, double constrainedAspectRatio)
        area,
  }) {
    return label(name, property);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(String name, LabelProperty property)? label,
    TResult Function(String name, bool zoomDependent, PenProperty property)?
        pen,
    TResult Function(String name, EraserProperty property)? eraser,
    TResult Function(String name, double strokeWidth, bool includeEraser,
            bool deleteWholeStroke)?
        pathEraser,
    TResult Function(String name, String layer, bool includeEraser)? layer,
    TResult Function(String name, double constrainedWidth,
            double constrainedHeight, double constrainedAspectRatio)?
        area,
  }) {
    return label?.call(name, property);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String name, LabelProperty property)? label,
    TResult Function(String name, bool zoomDependent, PenProperty property)?
        pen,
    TResult Function(String name, EraserProperty property)? eraser,
    TResult Function(String name, double strokeWidth, bool includeEraser,
            bool deleteWholeStroke)?
        pathEraser,
    TResult Function(String name, String layer, bool includeEraser)? layer,
    TResult Function(String name, double constrainedWidth,
            double constrainedHeight, double constrainedAspectRatio)?
        area,
    required TResult orElse(),
  }) {
    if (label != null) {
      return label(name, property);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LabelPainter value) label,
    required TResult Function(PenPainter value) pen,
    required TResult Function(EraserPainter value) eraser,
    required TResult Function(PathEraserPainter value) pathEraser,
    required TResult Function(LayerPainter value) layer,
    required TResult Function(AreaPainter value) area,
  }) {
    return label(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(LabelPainter value)? label,
    TResult Function(PenPainter value)? pen,
    TResult Function(EraserPainter value)? eraser,
    TResult Function(PathEraserPainter value)? pathEraser,
    TResult Function(LayerPainter value)? layer,
    TResult Function(AreaPainter value)? area,
  }) {
    return label?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LabelPainter value)? label,
    TResult Function(PenPainter value)? pen,
    TResult Function(EraserPainter value)? eraser,
    TResult Function(PathEraserPainter value)? pathEraser,
    TResult Function(LayerPainter value)? layer,
    TResult Function(AreaPainter value)? area,
    required TResult orElse(),
  }) {
    if (label != null) {
      return label(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$LabelPainterToJson(this);
  }
}

abstract class LabelPainter implements Painter {
  const factory LabelPainter({String name, LabelProperty property}) =
      _$LabelPainter;

  factory LabelPainter.fromJson(Map<String, dynamic> json) =
      _$LabelPainter.fromJson;

  @override
  String get name;
  LabelProperty get property;
  @override
  @JsonKey(ignore: true)
  $LabelPainterCopyWith<LabelPainter> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PenPainterCopyWith<$Res> implements $PainterCopyWith<$Res> {
  factory $PenPainterCopyWith(
          PenPainter value, $Res Function(PenPainter) then) =
      _$PenPainterCopyWithImpl<$Res>;
  @override
  $Res call({String name, bool zoomDependent, PenProperty property});
}

/// @nodoc
class _$PenPainterCopyWithImpl<$Res> extends _$PainterCopyWithImpl<$Res>
    implements $PenPainterCopyWith<$Res> {
  _$PenPainterCopyWithImpl(PenPainter _value, $Res Function(PenPainter) _then)
      : super(_value, (v) => _then(v as PenPainter));

  @override
  PenPainter get _value => super._value as PenPainter;

  @override
  $Res call({
    Object? name = freezed,
    Object? zoomDependent = freezed,
    Object? property = freezed,
  }) {
    return _then(PenPainter(
      name: name == freezed
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      zoomDependent: zoomDependent == freezed
          ? _value.zoomDependent
          : zoomDependent // ignore: cast_nullable_to_non_nullable
              as bool,
      property: property == freezed
          ? _value.property
          : property // ignore: cast_nullable_to_non_nullable
              as PenProperty,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PenPainter implements PenPainter {
  const _$PenPainter(
      {this.name = '',
      this.zoomDependent = false,
      this.property = const PenProperty(),
      String? $type})
      : $type = $type ?? 'pen';

  factory _$PenPainter.fromJson(Map<String, dynamic> json) =>
      _$$PenPainterFromJson(json);

  @JsonKey()
  @override
  final String name;
  @JsonKey()
  @override
  final bool zoomDependent;
  @JsonKey()
  @override
  final PenProperty property;

  @JsonKey(name: 'type')
  final String $type;

  @override
  String toString() {
    return 'Painter.pen(name: $name, zoomDependent: $zoomDependent, property: $property)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PenPainter &&
            const DeepCollectionEquality().equals(other.name, name) &&
            const DeepCollectionEquality()
                .equals(other.zoomDependent, zoomDependent) &&
            const DeepCollectionEquality().equals(other.property, property));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(name),
      const DeepCollectionEquality().hash(zoomDependent),
      const DeepCollectionEquality().hash(property));

  @JsonKey(ignore: true)
  @override
  $PenPainterCopyWith<PenPainter> get copyWith =>
      _$PenPainterCopyWithImpl<PenPainter>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String name, LabelProperty property) label,
    required TResult Function(
            String name, bool zoomDependent, PenProperty property)
        pen,
    required TResult Function(String name, EraserProperty property) eraser,
    required TResult Function(String name, double strokeWidth,
            bool includeEraser, bool deleteWholeStroke)
        pathEraser,
    required TResult Function(String name, String layer, bool includeEraser)
        layer,
    required TResult Function(String name, double constrainedWidth,
            double constrainedHeight, double constrainedAspectRatio)
        area,
  }) {
    return pen(name, zoomDependent, property);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(String name, LabelProperty property)? label,
    TResult Function(String name, bool zoomDependent, PenProperty property)?
        pen,
    TResult Function(String name, EraserProperty property)? eraser,
    TResult Function(String name, double strokeWidth, bool includeEraser,
            bool deleteWholeStroke)?
        pathEraser,
    TResult Function(String name, String layer, bool includeEraser)? layer,
    TResult Function(String name, double constrainedWidth,
            double constrainedHeight, double constrainedAspectRatio)?
        area,
  }) {
    return pen?.call(name, zoomDependent, property);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String name, LabelProperty property)? label,
    TResult Function(String name, bool zoomDependent, PenProperty property)?
        pen,
    TResult Function(String name, EraserProperty property)? eraser,
    TResult Function(String name, double strokeWidth, bool includeEraser,
            bool deleteWholeStroke)?
        pathEraser,
    TResult Function(String name, String layer, bool includeEraser)? layer,
    TResult Function(String name, double constrainedWidth,
            double constrainedHeight, double constrainedAspectRatio)?
        area,
    required TResult orElse(),
  }) {
    if (pen != null) {
      return pen(name, zoomDependent, property);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LabelPainter value) label,
    required TResult Function(PenPainter value) pen,
    required TResult Function(EraserPainter value) eraser,
    required TResult Function(PathEraserPainter value) pathEraser,
    required TResult Function(LayerPainter value) layer,
    required TResult Function(AreaPainter value) area,
  }) {
    return pen(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(LabelPainter value)? label,
    TResult Function(PenPainter value)? pen,
    TResult Function(EraserPainter value)? eraser,
    TResult Function(PathEraserPainter value)? pathEraser,
    TResult Function(LayerPainter value)? layer,
    TResult Function(AreaPainter value)? area,
  }) {
    return pen?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LabelPainter value)? label,
    TResult Function(PenPainter value)? pen,
    TResult Function(EraserPainter value)? eraser,
    TResult Function(PathEraserPainter value)? pathEraser,
    TResult Function(LayerPainter value)? layer,
    TResult Function(AreaPainter value)? area,
    required TResult orElse(),
  }) {
    if (pen != null) {
      return pen(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$PenPainterToJson(this);
  }
}

abstract class PenPainter implements Painter {
  const factory PenPainter(
      {String name, bool zoomDependent, PenProperty property}) = _$PenPainter;

  factory PenPainter.fromJson(Map<String, dynamic> json) =
      _$PenPainter.fromJson;

  @override
  String get name;
  bool get zoomDependent;
  PenProperty get property;
  @override
  @JsonKey(ignore: true)
  $PenPainterCopyWith<PenPainter> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EraserPainterCopyWith<$Res> implements $PainterCopyWith<$Res> {
  factory $EraserPainterCopyWith(
          EraserPainter value, $Res Function(EraserPainter) then) =
      _$EraserPainterCopyWithImpl<$Res>;
  @override
  $Res call({String name, EraserProperty property});
}

/// @nodoc
class _$EraserPainterCopyWithImpl<$Res> extends _$PainterCopyWithImpl<$Res>
    implements $EraserPainterCopyWith<$Res> {
  _$EraserPainterCopyWithImpl(
      EraserPainter _value, $Res Function(EraserPainter) _then)
      : super(_value, (v) => _then(v as EraserPainter));

  @override
  EraserPainter get _value => super._value as EraserPainter;

  @override
  $Res call({
    Object? name = freezed,
    Object? property = freezed,
  }) {
    return _then(EraserPainter(
      name: name == freezed
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      property: property == freezed
          ? _value.property
          : property // ignore: cast_nullable_to_non_nullable
              as EraserProperty,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$EraserPainter implements EraserPainter {
  const _$EraserPainter(
      {this.name = '', this.property = const EraserProperty(), String? $type})
      : $type = $type ?? 'eraser';

  factory _$EraserPainter.fromJson(Map<String, dynamic> json) =>
      _$$EraserPainterFromJson(json);

  @JsonKey()
  @override
  final String name;
  @JsonKey()
  @override
  final EraserProperty property;

  @JsonKey(name: 'type')
  final String $type;

  @override
  String toString() {
    return 'Painter.eraser(name: $name, property: $property)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is EraserPainter &&
            const DeepCollectionEquality().equals(other.name, name) &&
            const DeepCollectionEquality().equals(other.property, property));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(name),
      const DeepCollectionEquality().hash(property));

  @JsonKey(ignore: true)
  @override
  $EraserPainterCopyWith<EraserPainter> get copyWith =>
      _$EraserPainterCopyWithImpl<EraserPainter>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String name, LabelProperty property) label,
    required TResult Function(
            String name, bool zoomDependent, PenProperty property)
        pen,
    required TResult Function(String name, EraserProperty property) eraser,
    required TResult Function(String name, double strokeWidth,
            bool includeEraser, bool deleteWholeStroke)
        pathEraser,
    required TResult Function(String name, String layer, bool includeEraser)
        layer,
    required TResult Function(String name, double constrainedWidth,
            double constrainedHeight, double constrainedAspectRatio)
        area,
  }) {
    return eraser(name, property);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(String name, LabelProperty property)? label,
    TResult Function(String name, bool zoomDependent, PenProperty property)?
        pen,
    TResult Function(String name, EraserProperty property)? eraser,
    TResult Function(String name, double strokeWidth, bool includeEraser,
            bool deleteWholeStroke)?
        pathEraser,
    TResult Function(String name, String layer, bool includeEraser)? layer,
    TResult Function(String name, double constrainedWidth,
            double constrainedHeight, double constrainedAspectRatio)?
        area,
  }) {
    return eraser?.call(name, property);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String name, LabelProperty property)? label,
    TResult Function(String name, bool zoomDependent, PenProperty property)?
        pen,
    TResult Function(String name, EraserProperty property)? eraser,
    TResult Function(String name, double strokeWidth, bool includeEraser,
            bool deleteWholeStroke)?
        pathEraser,
    TResult Function(String name, String layer, bool includeEraser)? layer,
    TResult Function(String name, double constrainedWidth,
            double constrainedHeight, double constrainedAspectRatio)?
        area,
    required TResult orElse(),
  }) {
    if (eraser != null) {
      return eraser(name, property);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LabelPainter value) label,
    required TResult Function(PenPainter value) pen,
    required TResult Function(EraserPainter value) eraser,
    required TResult Function(PathEraserPainter value) pathEraser,
    required TResult Function(LayerPainter value) layer,
    required TResult Function(AreaPainter value) area,
  }) {
    return eraser(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(LabelPainter value)? label,
    TResult Function(PenPainter value)? pen,
    TResult Function(EraserPainter value)? eraser,
    TResult Function(PathEraserPainter value)? pathEraser,
    TResult Function(LayerPainter value)? layer,
    TResult Function(AreaPainter value)? area,
  }) {
    return eraser?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LabelPainter value)? label,
    TResult Function(PenPainter value)? pen,
    TResult Function(EraserPainter value)? eraser,
    TResult Function(PathEraserPainter value)? pathEraser,
    TResult Function(LayerPainter value)? layer,
    TResult Function(AreaPainter value)? area,
    required TResult orElse(),
  }) {
    if (eraser != null) {
      return eraser(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$EraserPainterToJson(this);
  }
}

abstract class EraserPainter implements Painter {
  const factory EraserPainter({String name, EraserProperty property}) =
      _$EraserPainter;

  factory EraserPainter.fromJson(Map<String, dynamic> json) =
      _$EraserPainter.fromJson;

  @override
  String get name;
  EraserProperty get property;
  @override
  @JsonKey(ignore: true)
  $EraserPainterCopyWith<EraserPainter> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PathEraserPainterCopyWith<$Res>
    implements $PainterCopyWith<$Res> {
  factory $PathEraserPainterCopyWith(
          PathEraserPainter value, $Res Function(PathEraserPainter) then) =
      _$PathEraserPainterCopyWithImpl<$Res>;
  @override
  $Res call(
      {String name,
      double strokeWidth,
      bool includeEraser,
      bool deleteWholeStroke});
}

/// @nodoc
class _$PathEraserPainterCopyWithImpl<$Res> extends _$PainterCopyWithImpl<$Res>
    implements $PathEraserPainterCopyWith<$Res> {
  _$PathEraserPainterCopyWithImpl(
      PathEraserPainter _value, $Res Function(PathEraserPainter) _then)
      : super(_value, (v) => _then(v as PathEraserPainter));

  @override
  PathEraserPainter get _value => super._value as PathEraserPainter;

  @override
  $Res call({
    Object? name = freezed,
    Object? strokeWidth = freezed,
    Object? includeEraser = freezed,
    Object? deleteWholeStroke = freezed,
  }) {
    return _then(PathEraserPainter(
      name: name == freezed
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      strokeWidth: strokeWidth == freezed
          ? _value.strokeWidth
          : strokeWidth // ignore: cast_nullable_to_non_nullable
              as double,
      includeEraser: includeEraser == freezed
          ? _value.includeEraser
          : includeEraser // ignore: cast_nullable_to_non_nullable
              as bool,
      deleteWholeStroke: deleteWholeStroke == freezed
          ? _value.deleteWholeStroke
          : deleteWholeStroke // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PathEraserPainter implements PathEraserPainter {
  const _$PathEraserPainter(
      {this.name = '',
      this.strokeWidth = 5,
      this.includeEraser = false,
      this.deleteWholeStroke = false,
      String? $type})
      : $type = $type ?? 'pathEraser';

  factory _$PathEraserPainter.fromJson(Map<String, dynamic> json) =>
      _$$PathEraserPainterFromJson(json);

  @JsonKey()
  @override
  final String name;
  @JsonKey()
  @override
  final double strokeWidth;
  @JsonKey()
  @override
  final bool includeEraser;
  @JsonKey()
  @override
  final bool deleteWholeStroke;

  @JsonKey(name: 'type')
  final String $type;

  @override
  String toString() {
    return 'Painter.pathEraser(name: $name, strokeWidth: $strokeWidth, includeEraser: $includeEraser, deleteWholeStroke: $deleteWholeStroke)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PathEraserPainter &&
            const DeepCollectionEquality().equals(other.name, name) &&
            const DeepCollectionEquality()
                .equals(other.strokeWidth, strokeWidth) &&
            const DeepCollectionEquality()
                .equals(other.includeEraser, includeEraser) &&
            const DeepCollectionEquality()
                .equals(other.deleteWholeStroke, deleteWholeStroke));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(name),
      const DeepCollectionEquality().hash(strokeWidth),
      const DeepCollectionEquality().hash(includeEraser),
      const DeepCollectionEquality().hash(deleteWholeStroke));

  @JsonKey(ignore: true)
  @override
  $PathEraserPainterCopyWith<PathEraserPainter> get copyWith =>
      _$PathEraserPainterCopyWithImpl<PathEraserPainter>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String name, LabelProperty property) label,
    required TResult Function(
            String name, bool zoomDependent, PenProperty property)
        pen,
    required TResult Function(String name, EraserProperty property) eraser,
    required TResult Function(String name, double strokeWidth,
            bool includeEraser, bool deleteWholeStroke)
        pathEraser,
    required TResult Function(String name, String layer, bool includeEraser)
        layer,
    required TResult Function(String name, double constrainedWidth,
            double constrainedHeight, double constrainedAspectRatio)
        area,
  }) {
    return pathEraser(name, strokeWidth, includeEraser, deleteWholeStroke);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(String name, LabelProperty property)? label,
    TResult Function(String name, bool zoomDependent, PenProperty property)?
        pen,
    TResult Function(String name, EraserProperty property)? eraser,
    TResult Function(String name, double strokeWidth, bool includeEraser,
            bool deleteWholeStroke)?
        pathEraser,
    TResult Function(String name, String layer, bool includeEraser)? layer,
    TResult Function(String name, double constrainedWidth,
            double constrainedHeight, double constrainedAspectRatio)?
        area,
  }) {
    return pathEraser?.call(
        name, strokeWidth, includeEraser, deleteWholeStroke);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String name, LabelProperty property)? label,
    TResult Function(String name, bool zoomDependent, PenProperty property)?
        pen,
    TResult Function(String name, EraserProperty property)? eraser,
    TResult Function(String name, double strokeWidth, bool includeEraser,
            bool deleteWholeStroke)?
        pathEraser,
    TResult Function(String name, String layer, bool includeEraser)? layer,
    TResult Function(String name, double constrainedWidth,
            double constrainedHeight, double constrainedAspectRatio)?
        area,
    required TResult orElse(),
  }) {
    if (pathEraser != null) {
      return pathEraser(name, strokeWidth, includeEraser, deleteWholeStroke);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LabelPainter value) label,
    required TResult Function(PenPainter value) pen,
    required TResult Function(EraserPainter value) eraser,
    required TResult Function(PathEraserPainter value) pathEraser,
    required TResult Function(LayerPainter value) layer,
    required TResult Function(AreaPainter value) area,
  }) {
    return pathEraser(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(LabelPainter value)? label,
    TResult Function(PenPainter value)? pen,
    TResult Function(EraserPainter value)? eraser,
    TResult Function(PathEraserPainter value)? pathEraser,
    TResult Function(LayerPainter value)? layer,
    TResult Function(AreaPainter value)? area,
  }) {
    return pathEraser?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LabelPainter value)? label,
    TResult Function(PenPainter value)? pen,
    TResult Function(EraserPainter value)? eraser,
    TResult Function(PathEraserPainter value)? pathEraser,
    TResult Function(LayerPainter value)? layer,
    TResult Function(AreaPainter value)? area,
    required TResult orElse(),
  }) {
    if (pathEraser != null) {
      return pathEraser(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$PathEraserPainterToJson(this);
  }
}

abstract class PathEraserPainter implements Painter {
  const factory PathEraserPainter(
      {String name,
      double strokeWidth,
      bool includeEraser,
      bool deleteWholeStroke}) = _$PathEraserPainter;

  factory PathEraserPainter.fromJson(Map<String, dynamic> json) =
      _$PathEraserPainter.fromJson;

  @override
  String get name;
  double get strokeWidth;
  bool get includeEraser;
  bool get deleteWholeStroke;
  @override
  @JsonKey(ignore: true)
  $PathEraserPainterCopyWith<PathEraserPainter> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LayerPainterCopyWith<$Res> implements $PainterCopyWith<$Res> {
  factory $LayerPainterCopyWith(
          LayerPainter value, $Res Function(LayerPainter) then) =
      _$LayerPainterCopyWithImpl<$Res>;
  @override
  $Res call({String name, String layer, bool includeEraser});
}

/// @nodoc
class _$LayerPainterCopyWithImpl<$Res> extends _$PainterCopyWithImpl<$Res>
    implements $LayerPainterCopyWith<$Res> {
  _$LayerPainterCopyWithImpl(
      LayerPainter _value, $Res Function(LayerPainter) _then)
      : super(_value, (v) => _then(v as LayerPainter));

  @override
  LayerPainter get _value => super._value as LayerPainter;

  @override
  $Res call({
    Object? name = freezed,
    Object? layer = freezed,
    Object? includeEraser = freezed,
  }) {
    return _then(LayerPainter(
      name: name == freezed
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      layer: layer == freezed
          ? _value.layer
          : layer // ignore: cast_nullable_to_non_nullable
              as String,
      includeEraser: includeEraser == freezed
          ? _value.includeEraser
          : includeEraser // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LayerPainter implements LayerPainter {
  const _$LayerPainter(
      {this.name = '',
      this.layer = '',
      this.includeEraser = false,
      String? $type})
      : $type = $type ?? 'layer';

  factory _$LayerPainter.fromJson(Map<String, dynamic> json) =>
      _$$LayerPainterFromJson(json);

  @JsonKey()
  @override
  final String name;
  @JsonKey()
  @override
  final String layer;
  @JsonKey()
  @override
  final bool includeEraser;

  @JsonKey(name: 'type')
  final String $type;

  @override
  String toString() {
    return 'Painter.layer(name: $name, layer: $layer, includeEraser: $includeEraser)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is LayerPainter &&
            const DeepCollectionEquality().equals(other.name, name) &&
            const DeepCollectionEquality().equals(other.layer, layer) &&
            const DeepCollectionEquality()
                .equals(other.includeEraser, includeEraser));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(name),
      const DeepCollectionEquality().hash(layer),
      const DeepCollectionEquality().hash(includeEraser));

  @JsonKey(ignore: true)
  @override
  $LayerPainterCopyWith<LayerPainter> get copyWith =>
      _$LayerPainterCopyWithImpl<LayerPainter>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String name, LabelProperty property) label,
    required TResult Function(
            String name, bool zoomDependent, PenProperty property)
        pen,
    required TResult Function(String name, EraserProperty property) eraser,
    required TResult Function(String name, double strokeWidth,
            bool includeEraser, bool deleteWholeStroke)
        pathEraser,
    required TResult Function(String name, String layer, bool includeEraser)
        layer,
    required TResult Function(String name, double constrainedWidth,
            double constrainedHeight, double constrainedAspectRatio)
        area,
  }) {
    return layer(name, this.layer, includeEraser);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(String name, LabelProperty property)? label,
    TResult Function(String name, bool zoomDependent, PenProperty property)?
        pen,
    TResult Function(String name, EraserProperty property)? eraser,
    TResult Function(String name, double strokeWidth, bool includeEraser,
            bool deleteWholeStroke)?
        pathEraser,
    TResult Function(String name, String layer, bool includeEraser)? layer,
    TResult Function(String name, double constrainedWidth,
            double constrainedHeight, double constrainedAspectRatio)?
        area,
  }) {
    return layer?.call(name, this.layer, includeEraser);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String name, LabelProperty property)? label,
    TResult Function(String name, bool zoomDependent, PenProperty property)?
        pen,
    TResult Function(String name, EraserProperty property)? eraser,
    TResult Function(String name, double strokeWidth, bool includeEraser,
            bool deleteWholeStroke)?
        pathEraser,
    TResult Function(String name, String layer, bool includeEraser)? layer,
    TResult Function(String name, double constrainedWidth,
            double constrainedHeight, double constrainedAspectRatio)?
        area,
    required TResult orElse(),
  }) {
    if (layer != null) {
      return layer(name, this.layer, includeEraser);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LabelPainter value) label,
    required TResult Function(PenPainter value) pen,
    required TResult Function(EraserPainter value) eraser,
    required TResult Function(PathEraserPainter value) pathEraser,
    required TResult Function(LayerPainter value) layer,
    required TResult Function(AreaPainter value) area,
  }) {
    return layer(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(LabelPainter value)? label,
    TResult Function(PenPainter value)? pen,
    TResult Function(EraserPainter value)? eraser,
    TResult Function(PathEraserPainter value)? pathEraser,
    TResult Function(LayerPainter value)? layer,
    TResult Function(AreaPainter value)? area,
  }) {
    return layer?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LabelPainter value)? label,
    TResult Function(PenPainter value)? pen,
    TResult Function(EraserPainter value)? eraser,
    TResult Function(PathEraserPainter value)? pathEraser,
    TResult Function(LayerPainter value)? layer,
    TResult Function(AreaPainter value)? area,
    required TResult orElse(),
  }) {
    if (layer != null) {
      return layer(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$LayerPainterToJson(this);
  }
}

abstract class LayerPainter implements Painter {
  const factory LayerPainter({String name, String layer, bool includeEraser}) =
      _$LayerPainter;

  factory LayerPainter.fromJson(Map<String, dynamic> json) =
      _$LayerPainter.fromJson;

  @override
  String get name;
  String get layer;
  bool get includeEraser;
  @override
  @JsonKey(ignore: true)
  $LayerPainterCopyWith<LayerPainter> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AreaPainterCopyWith<$Res> implements $PainterCopyWith<$Res> {
  factory $AreaPainterCopyWith(
          AreaPainter value, $Res Function(AreaPainter) then) =
      _$AreaPainterCopyWithImpl<$Res>;
  @override
  $Res call(
      {String name,
      double constrainedWidth,
      double constrainedHeight,
      double constrainedAspectRatio});
}

/// @nodoc
class _$AreaPainterCopyWithImpl<$Res> extends _$PainterCopyWithImpl<$Res>
    implements $AreaPainterCopyWith<$Res> {
  _$AreaPainterCopyWithImpl(
      AreaPainter _value, $Res Function(AreaPainter) _then)
      : super(_value, (v) => _then(v as AreaPainter));

  @override
  AreaPainter get _value => super._value as AreaPainter;

  @override
  $Res call({
    Object? name = freezed,
    Object? constrainedWidth = freezed,
    Object? constrainedHeight = freezed,
    Object? constrainedAspectRatio = freezed,
  }) {
    return _then(AreaPainter(
      name: name == freezed
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      constrainedWidth: constrainedWidth == freezed
          ? _value.constrainedWidth
          : constrainedWidth // ignore: cast_nullable_to_non_nullable
              as double,
      constrainedHeight: constrainedHeight == freezed
          ? _value.constrainedHeight
          : constrainedHeight // ignore: cast_nullable_to_non_nullable
              as double,
      constrainedAspectRatio: constrainedAspectRatio == freezed
          ? _value.constrainedAspectRatio
          : constrainedAspectRatio // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AreaPainter implements AreaPainter {
  const _$AreaPainter(
      {this.name = '',
      this.constrainedWidth = 0,
      this.constrainedHeight = 0,
      this.constrainedAspectRatio = 0,
      String? $type})
      : $type = $type ?? 'area';

  factory _$AreaPainter.fromJson(Map<String, dynamic> json) =>
      _$$AreaPainterFromJson(json);

  @JsonKey()
  @override
  final String name;
  @JsonKey()
  @override
  final double constrainedWidth;
  @JsonKey()
  @override
  final double constrainedHeight;
  @JsonKey()
  @override
  final double constrainedAspectRatio;

  @JsonKey(name: 'type')
  final String $type;

  @override
  String toString() {
    return 'Painter.area(name: $name, constrainedWidth: $constrainedWidth, constrainedHeight: $constrainedHeight, constrainedAspectRatio: $constrainedAspectRatio)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AreaPainter &&
            const DeepCollectionEquality().equals(other.name, name) &&
            const DeepCollectionEquality()
                .equals(other.constrainedWidth, constrainedWidth) &&
            const DeepCollectionEquality()
                .equals(other.constrainedHeight, constrainedHeight) &&
            const DeepCollectionEquality()
                .equals(other.constrainedAspectRatio, constrainedAspectRatio));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(name),
      const DeepCollectionEquality().hash(constrainedWidth),
      const DeepCollectionEquality().hash(constrainedHeight),
      const DeepCollectionEquality().hash(constrainedAspectRatio));

  @JsonKey(ignore: true)
  @override
  $AreaPainterCopyWith<AreaPainter> get copyWith =>
      _$AreaPainterCopyWithImpl<AreaPainter>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String name, LabelProperty property) label,
    required TResult Function(
            String name, bool zoomDependent, PenProperty property)
        pen,
    required TResult Function(String name, EraserProperty property) eraser,
    required TResult Function(String name, double strokeWidth,
            bool includeEraser, bool deleteWholeStroke)
        pathEraser,
    required TResult Function(String name, String layer, bool includeEraser)
        layer,
    required TResult Function(String name, double constrainedWidth,
            double constrainedHeight, double constrainedAspectRatio)
        area,
  }) {
    return area(
        name, constrainedWidth, constrainedHeight, constrainedAspectRatio);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(String name, LabelProperty property)? label,
    TResult Function(String name, bool zoomDependent, PenProperty property)?
        pen,
    TResult Function(String name, EraserProperty property)? eraser,
    TResult Function(String name, double strokeWidth, bool includeEraser,
            bool deleteWholeStroke)?
        pathEraser,
    TResult Function(String name, String layer, bool includeEraser)? layer,
    TResult Function(String name, double constrainedWidth,
            double constrainedHeight, double constrainedAspectRatio)?
        area,
  }) {
    return area?.call(
        name, constrainedWidth, constrainedHeight, constrainedAspectRatio);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String name, LabelProperty property)? label,
    TResult Function(String name, bool zoomDependent, PenProperty property)?
        pen,
    TResult Function(String name, EraserProperty property)? eraser,
    TResult Function(String name, double strokeWidth, bool includeEraser,
            bool deleteWholeStroke)?
        pathEraser,
    TResult Function(String name, String layer, bool includeEraser)? layer,
    TResult Function(String name, double constrainedWidth,
            double constrainedHeight, double constrainedAspectRatio)?
        area,
    required TResult orElse(),
  }) {
    if (area != null) {
      return area(
          name, constrainedWidth, constrainedHeight, constrainedAspectRatio);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LabelPainter value) label,
    required TResult Function(PenPainter value) pen,
    required TResult Function(EraserPainter value) eraser,
    required TResult Function(PathEraserPainter value) pathEraser,
    required TResult Function(LayerPainter value) layer,
    required TResult Function(AreaPainter value) area,
  }) {
    return area(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(LabelPainter value)? label,
    TResult Function(PenPainter value)? pen,
    TResult Function(EraserPainter value)? eraser,
    TResult Function(PathEraserPainter value)? pathEraser,
    TResult Function(LayerPainter value)? layer,
    TResult Function(AreaPainter value)? area,
  }) {
    return area?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LabelPainter value)? label,
    TResult Function(PenPainter value)? pen,
    TResult Function(EraserPainter value)? eraser,
    TResult Function(PathEraserPainter value)? pathEraser,
    TResult Function(LayerPainter value)? layer,
    TResult Function(AreaPainter value)? area,
    required TResult orElse(),
  }) {
    if (area != null) {
      return area(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$AreaPainterToJson(this);
  }
}

abstract class AreaPainter implements Painter {
  const factory AreaPainter(
      {String name,
      double constrainedWidth,
      double constrainedHeight,
      double constrainedAspectRatio}) = _$AreaPainter;

  factory AreaPainter.fromJson(Map<String, dynamic> json) =
      _$AreaPainter.fromJson;

  @override
  String get name;
  double get constrainedWidth;
  double get constrainedHeight;
  double get constrainedAspectRatio;
  @override
  @JsonKey(ignore: true)
  $AreaPainterCopyWith<AreaPainter> get copyWith =>
      throw _privateConstructorUsedError;
}
