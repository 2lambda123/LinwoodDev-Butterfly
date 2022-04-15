// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'element.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ScaledPadConstraints _$$ScaledPadConstraintsFromJson(Map json) =>
    _$ScaledPadConstraints(
      (json['scale'] as num).toDouble(),
      $type: json['type'] as String?,
    );

Map<String, dynamic> _$$ScaledPadConstraintsToJson(
        _$ScaledPadConstraints instance) =>
    <String, dynamic>{
      'scale': instance.scale,
      'type': instance.$type,
    };

_$FixedPadConstraints _$$FixedPadConstraintsFromJson(Map json) =>
    _$FixedPadConstraints(
      (json['height'] as num).toDouble(),
      (json['width'] as num).toDouble(),
      $type: json['type'] as String?,
    );

Map<String, dynamic> _$$FixedPadConstraintsToJson(
        _$FixedPadConstraints instance) =>
    <String, dynamic>{
      'height': instance.height,
      'width': instance.width,
      'type': instance.$type,
    };

_$DynamicPadConstraints _$$DynamicPadConstraintsFromJson(Map json) =>
    _$DynamicPadConstraints(
      height: (json['height'] as num?)?.toDouble() ?? 0,
      width: (json['width'] as num?)?.toDouble() ?? 0,
      aspectRatio: (json['aspectRatio'] as num?)?.toDouble() ?? null,
      includeArea: json['includeArea'] as bool? ?? true,
      $type: json['type'] as String?,
    );

Map<String, dynamic> _$$DynamicPadConstraintsToJson(
        _$DynamicPadConstraints instance) =>
    <String, dynamic>{
      'height': instance.height,
      'width': instance.width,
      'aspectRatio': instance.aspectRatio,
      'includeArea': instance.includeArea,
      'type': instance.$type,
    };

_$PenElement _$$PenElementFromJson(Map json) => _$PenElement(
      layer: json['layer'] as String? ?? '',
      points: (json['points'] as List<dynamic>?)
              ?.map((e) =>
                  PathPoint.fromJson(Map<String, dynamic>.from(e as Map)))
              .toList() ??
          const [],
      property: json['property'] == null
          ? const PenProperty()
          : PenProperty.fromJson(
              Map<String, dynamic>.from(json['property'] as Map)),
      $type: json['type'] as String?,
    );

Map<String, dynamic> _$$PenElementToJson(_$PenElement instance) =>
    <String, dynamic>{
      'layer': instance.layer,
      'points': instance.points.map((e) => e.toJson()).toList(),
      'property': instance.property.toJson(),
      'type': instance.$type,
    };

_$EraserElement _$$EraserElementFromJson(Map json) => _$EraserElement(
      layer: json['layer'] as String? ?? '',
      points: (json['points'] as List<dynamic>?)
              ?.map((e) =>
                  PathPoint.fromJson(Map<String, dynamic>.from(e as Map)))
              .toList() ??
          const [],
      property: json['property'] == null
          ? const EraserProperty()
          : EraserProperty.fromJson(
              Map<String, dynamic>.from(json['property'] as Map)),
      $type: json['type'] as String?,
    );

Map<String, dynamic> _$$EraserElementToJson(_$EraserElement instance) =>
    <String, dynamic>{
      'layer': instance.layer,
      'points': instance.points.map((e) => e.toJson()).toList(),
      'property': instance.property.toJson(),
      'type': instance.$type,
    };

_$LabelElement _$$LabelElementFromJson(Map json) => _$LabelElement(
      layer: json['layer'] as String? ?? '',
      position: json['position'] == null
          ? Offset.zero
          : const OffsetJsonConverter()
              .fromJson(json['position'] as Map<String, dynamic>),
      text: json['text'] as String? ?? '',
      property: json['property'] == null
          ? const LabelProperty()
          : LabelProperty.fromJson(
              Map<String, dynamic>.from(json['property'] as Map)),
      $type: json['type'] as String?,
    );

Map<String, dynamic> _$$LabelElementToJson(_$LabelElement instance) =>
    <String, dynamic>{
      'layer': instance.layer,
      'position': const OffsetJsonConverter().toJson(instance.position),
      'text': instance.text,
      'property': instance.property.toJson(),
      'type': instance.$type,
    };

_$ImageElement _$$ImageElementFromJson(Map json) => _$ImageElement(
      layer: json['layer'] as String? ?? '',
      position: json['position'] == null
          ? Offset.zero
          : const OffsetJsonConverter()
              .fromJson(json['position'] as Map<String, dynamic>),
      constraints: json['constraints'] == null
          ? const ScaledPadConstraints(1)
          : PadConstraints.fromJson(
              Map<String, dynamic>.from(json['constraints'] as Map)),
      pixels: const Uint8ListJsonConverter().fromJson(json['pixels'] as String),
      width: json['width'] as int,
      height: json['height'] as int,
      $type: json['type'] as String?,
    );

Map<String, dynamic> _$$ImageElementToJson(_$ImageElement instance) =>
    <String, dynamic>{
      'layer': instance.layer,
      'position': const OffsetJsonConverter().toJson(instance.position),
      'constraints': instance.constraints?.toJson(),
      'pixels': const Uint8ListJsonConverter().toJson(instance.pixels),
      'width': instance.width,
      'height': instance.height,
      'type': instance.$type,
    };
