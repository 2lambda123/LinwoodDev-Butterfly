// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'painter.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$HandPainter _$$HandPainterFromJson(Map json) => _$HandPainter(
      name: json['name'] as String? ?? '',
      includeEraser: json['includeEraser'] as bool? ?? false,
      $type: json['type'] as String?,
    );

Map<String, dynamic> _$$HandPainterToJson(_$HandPainter instance) =>
    <String, dynamic>{
      'name': instance.name,
      'includeEraser': instance.includeEraser,
      'type': instance.$type,
    };

_$ImportPainter _$$ImportPainterFromJson(Map json) => _$ImportPainter(
      name: json['name'] as String? ?? '',
      elements: (json['elements'] as List<dynamic>)
          .map((e) => PadElement.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
      areas: (json['areas'] as List<dynamic>)
          .map((e) => Area.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
      $type: json['type'] as String?,
    );

Map<String, dynamic> _$$ImportPainterToJson(_$ImportPainter instance) =>
    <String, dynamic>{
      'name': instance.name,
      'elements': instance.elements.map((e) => e.toJson()).toList(),
      'areas': instance.areas.map((e) => e.toJson()).toList(),
      'type': instance.$type,
    };

_$UndoPainter _$$UndoPainterFromJson(Map json) => _$UndoPainter(
      name: json['name'] as String? ?? '',
      $type: json['type'] as String?,
    );

Map<String, dynamic> _$$UndoPainterToJson(_$UndoPainter instance) =>
    <String, dynamic>{
      'name': instance.name,
      'type': instance.$type,
    };

_$RedoPainter _$$RedoPainterFromJson(Map json) => _$RedoPainter(
      name: json['name'] as String? ?? '',
      $type: json['type'] as String?,
    );

Map<String, dynamic> _$$RedoPainterToJson(_$RedoPainter instance) =>
    <String, dynamic>{
      'name': instance.name,
      'type': instance.$type,
    };

_$LabelPainter _$$LabelPainterFromJson(Map json) => _$LabelPainter(
      name: json['name'] as String? ?? '',
      property: json['property'] == null
          ? const LabelProperty()
          : LabelProperty.fromJson(
              Map<String, dynamic>.from(json['property'] as Map)),
      $type: json['type'] as String?,
    );

Map<String, dynamic> _$$LabelPainterToJson(_$LabelPainter instance) =>
    <String, dynamic>{
      'name': instance.name,
      'property': instance.property.toJson(),
      'type': instance.$type,
    };

_$PenPainter _$$PenPainterFromJson(Map json) => _$PenPainter(
      name: json['name'] as String? ?? '',
      zoomDependent: json['zoomDependent'] as bool? ?? false,
      property: json['property'] == null
          ? const PenProperty()
          : PenProperty.fromJson(
              Map<String, dynamic>.from(json['property'] as Map)),
      $type: json['type'] as String?,
    );

Map<String, dynamic> _$$PenPainterToJson(_$PenPainter instance) =>
    <String, dynamic>{
      'name': instance.name,
      'zoomDependent': instance.zoomDependent,
      'property': instance.property.toJson(),
      'type': instance.$type,
    };

_$EraserPainter _$$EraserPainterFromJson(Map json) => _$EraserPainter(
      name: json['name'] as String? ?? '',
      property: json['property'] == null
          ? const EraserProperty()
          : EraserProperty.fromJson(
              Map<String, dynamic>.from(json['property'] as Map)),
      $type: json['type'] as String?,
    );

Map<String, dynamic> _$$EraserPainterToJson(_$EraserPainter instance) =>
    <String, dynamic>{
      'name': instance.name,
      'property': instance.property.toJson(),
      'type': instance.$type,
    };

_$PathEraserPainter _$$PathEraserPainterFromJson(Map json) =>
    _$PathEraserPainter(
      name: json['name'] as String? ?? '',
      strokeWidth: (json['strokeWidth'] as num?)?.toDouble() ?? 5,
      includeEraser: json['includeEraser'] as bool? ?? false,
      deleteWholeStroke: json['deleteWholeStroke'] as bool? ?? false,
      $type: json['type'] as String?,
    );

Map<String, dynamic> _$$PathEraserPainterToJson(_$PathEraserPainter instance) =>
    <String, dynamic>{
      'name': instance.name,
      'strokeWidth': instance.strokeWidth,
      'includeEraser': instance.includeEraser,
      'deleteWholeStroke': instance.deleteWholeStroke,
      'type': instance.$type,
    };

_$LayerPainter _$$LayerPainterFromJson(Map json) => _$LayerPainter(
      name: json['name'] as String? ?? '',
      strokeWidth: (json['strokeWidth'] as num?)?.toDouble() ?? 5,
      includeEraser: json['includeEraser'] as bool? ?? false,
      $type: json['type'] as String?,
    );

Map<String, dynamic> _$$LayerPainterToJson(_$LayerPainter instance) =>
    <String, dynamic>{
      'name': instance.name,
      'strokeWidth': instance.strokeWidth,
      'includeEraser': instance.includeEraser,
      'type': instance.$type,
    };

_$AreaPainter _$$AreaPainterFromJson(Map json) => _$AreaPainter(
      name: json['name'] as String? ?? '',
      constrainedWidth: (json['constrainedWidth'] as num?)?.toDouble() ?? 0,
      constrainedHeight: (json['constrainedHeight'] as num?)?.toDouble() ?? 0,
      constrainedAspectRatio:
          (json['constrainedAspectRatio'] as num?)?.toDouble() ?? 0,
      askForName: json['askForName'] as bool? ?? false,
      $type: json['type'] as String?,
    );

Map<String, dynamic> _$$AreaPainterToJson(_$AreaPainter instance) =>
    <String, dynamic>{
      'name': instance.name,
      'constrainedWidth': instance.constrainedWidth,
      'constrainedHeight': instance.constrainedHeight,
      'constrainedAspectRatio': instance.constrainedAspectRatio,
      'askForName': instance.askForName,
      'type': instance.$type,
    };

_$WaypointPainter _$$WaypointPainterFromJson(Map json) => _$WaypointPainter(
      name: json['name'] as String? ?? '',
      $type: json['type'] as String?,
    );

Map<String, dynamic> _$$WaypointPainterToJson(_$WaypointPainter instance) =>
    <String, dynamic>{
      'name': instance.name,
      'type': instance.$type,
    };

_$LaserPainter _$$LaserPainterFromJson(Map json) => _$LaserPainter(
      name: json['name'] as String? ?? '',
      duration: (json['duration'] as num?)?.toDouble() ?? 5,
      strokeWidth: (json['strokeWidth'] as num?)?.toDouble() ?? 5,
      strokeMultiplier: (json['strokeMultiplier'] as num?)?.toDouble() ?? 10,
      color: json['color'] as int? ?? kColorRed,
      $type: json['type'] as String?,
    );

Map<String, dynamic> _$$LaserPainterToJson(_$LaserPainter instance) =>
    <String, dynamic>{
      'name': instance.name,
      'duration': instance.duration,
      'strokeWidth': instance.strokeWidth,
      'strokeMultiplier': instance.strokeMultiplier,
      'color': instance.color,
      'type': instance.$type,
    };

_$ShapePainter _$$ShapePainterFromJson(Map json) => _$ShapePainter(
      name: json['name'] as String? ?? '',
      zoomDependent: json['zoomDependent'] as bool? ?? false,
      constrainedWidth: (json['constrainedWidth'] as num?)?.toDouble() ?? 0,
      constrainedHeight: (json['constrainedHeight'] as num?)?.toDouble() ?? 0,
      constrainedAspectRatio:
          (json['constrainedAspectRatio'] as num?)?.toDouble() ?? 0,
      property: json['property'] == null
          ? const ShapeProperty(shape: RectangleShape())
          : ShapeProperty.fromJson(
              Map<String, dynamic>.from(json['property'] as Map)),
      $type: json['type'] as String?,
    );

Map<String, dynamic> _$$ShapePainterToJson(_$ShapePainter instance) =>
    <String, dynamic>{
      'name': instance.name,
      'zoomDependent': instance.zoomDependent,
      'constrainedWidth': instance.constrainedWidth,
      'constrainedHeight': instance.constrainedHeight,
      'constrainedAspectRatio': instance.constrainedAspectRatio,
      'property': instance.property.toJson(),
      'type': instance.$type,
    };

_$StampPainter _$$StampPainterFromJson(Map json) => _$StampPainter(
      name: json['name'] as String? ?? '',
      pack: json['pack'] as String? ?? '',
      component: json['component'] as int? ?? 0,
      $type: json['type'] as String?,
    );

Map<String, dynamic> _$$StampPainterToJson(_$StampPainter instance) =>
    <String, dynamic>{
      'name': instance.name,
      'pack': instance.pack,
      'component': instance.component,
      'type': instance.$type,
    };
