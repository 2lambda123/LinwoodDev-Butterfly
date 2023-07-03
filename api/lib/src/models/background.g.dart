// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'background.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$EmptyBackground _$$EmptyBackgroundFromJson(Map json) => _$EmptyBackground(
      $type: json['type'] as String?,
    );

Map<String, dynamic> _$$EmptyBackgroundToJson(_$EmptyBackground instance) =>
    <String, dynamic>{
      'type': instance.$type,
    };

_$BoxBackground _$$BoxBackgroundFromJson(Map json) => _$BoxBackground(
      boxWidth: (json['boxWidth'] as num?)?.toDouble() ?? 0,
      boxHeight: (json['boxHeight'] as num?)?.toDouble() ?? 0,
      boxXCount: json['boxXCount'] as int? ?? 1,
      boxYCount: json['boxYCount'] as int? ?? 1,
      boxXSpace: (json['boxXSpace'] as num?)?.toDouble() ?? 0,
      boxYSpace: (json['boxYSpace'] as num?)?.toDouble() ?? 0,
      boxXColor: json['boxXColor'] as int? ?? kColorBlue,
      boxYColor: json['boxYColor'] as int? ?? kColorRed,
      boxColor: json['boxColor'] as int? ?? kColorWhite,
      boxXStroke: (json['boxXStroke'] as num?)?.toDouble() ?? 0.5,
      boxYStroke: (json['boxYStroke'] as num?)?.toDouble() ?? 0.5,
      $type: json['type'] as String?,
    );

Map<String, dynamic> _$$BoxBackgroundToJson(_$BoxBackground instance) =>
    <String, dynamic>{
      'boxWidth': instance.boxWidth,
      'boxHeight': instance.boxHeight,
      'boxXCount': instance.boxXCount,
      'boxYCount': instance.boxYCount,
      'boxXSpace': instance.boxXSpace,
      'boxYSpace': instance.boxYSpace,
      'boxXColor': instance.boxXColor,
      'boxYColor': instance.boxYColor,
      'boxColor': instance.boxColor,
      'boxXStroke': instance.boxXStroke,
      'boxYStroke': instance.boxYStroke,
      'type': instance.$type,
    };

_$ImageBackground _$$ImageBackgroundFromJson(Map json) => _$ImageBackground(
      source: json['source'] as String,
      width: (json['width'] as num).toDouble(),
      height: (json['height'] as num).toDouble(),
      scaleX: (json['scaleX'] as num?)?.toDouble() ?? 1,
      scaleY: (json['scaleY'] as num?)?.toDouble() ?? 1,
      $type: json['type'] as String?,
    );

Map<String, dynamic> _$$ImageBackgroundToJson(_$ImageBackground instance) =>
    <String, dynamic>{
      'source': instance.source,
      'width': instance.width,
      'height': instance.height,
      'scaleX': instance.scaleX,
      'scaleY': instance.scaleY,
      'type': instance.$type,
    };

_$SvgBackground _$$SvgBackgroundFromJson(Map json) => _$SvgBackground(
      source: json['source'] as String,
      width: (json['width'] as num).toDouble(),
      height: (json['height'] as num).toDouble(),
      scaleX: (json['scaleX'] as num?)?.toDouble() ?? 1,
      scaleY: (json['scaleY'] as num?)?.toDouble() ?? 1,
      $type: json['type'] as String?,
    );

Map<String, dynamic> _$$SvgBackgroundToJson(_$SvgBackground instance) =>
    <String, dynamic>{
      'source': instance.source,
      'width': instance.width,
      'height': instance.height,
      'scaleX': instance.scaleX,
      'scaleY': instance.scaleY,
      'type': instance.$type,
    };
