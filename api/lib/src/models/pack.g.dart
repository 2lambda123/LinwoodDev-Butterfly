// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pack.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_ButterflyComponent _$$_ButterflyComponentFromJson(Map json) =>
    _$_ButterflyComponent(
      name: json['name'] as String,
      thumbnail: json['thumbnail'] as String?,
      elements: (json['elements'] as List<dynamic>?)
              ?.map((e) =>
                  PadElement.fromJson(Map<String, dynamic>.from(e as Map)))
              .toList() ??
          const <PadElement>[],
    );

Map<String, dynamic> _$$_ButterflyComponentToJson(
        _$_ButterflyComponent instance) =>
    <String, dynamic>{
      'name': instance.name,
      'thumbnail': instance.thumbnail,
      'elements': instance.elements.map((e) => e.toJson()).toList(),
    };

_$TextParameter _$$TextParameterFromJson(Map json) => _$TextParameter(
      child: json['child'] as int,
      name: json['name'] as String,
      value: json['value'] as String,
      $type: json['type'] as String?,
    );

Map<String, dynamic> _$$TextParameterToJson(_$TextParameter instance) =>
    <String, dynamic>{
      'child': instance.child,
      'name': instance.name,
      'value': instance.value,
      'type': instance.$type,
    };

_$ColorParameter _$$ColorParameterFromJson(Map json) => _$ColorParameter(
      child: json['child'] as int,
      name: json['name'] as String,
      value: json['value'] as int,
      $type: json['type'] as String?,
    );

Map<String, dynamic> _$$ColorParameterToJson(_$ColorParameter instance) =>
    <String, dynamic>{
      'child': instance.child,
      'name': instance.name,
      'value': instance.value,
      'type': instance.$type,
    };

_$BoolParameter _$$BoolParameterFromJson(Map json) => _$BoolParameter(
      child: json['child'] as int,
      name: json['name'] as String,
      value: json['value'] as bool,
      $type: json['type'] as String?,
    );

Map<String, dynamic> _$$BoolParameterToJson(_$BoolParameter instance) =>
    <String, dynamic>{
      'child': instance.child,
      'name': instance.name,
      'value': instance.value,
      'type': instance.$type,
    };

_$IntParameter _$$IntParameterFromJson(Map json) => _$IntParameter(
      child: json['child'] as int,
      name: json['name'] as String,
      value: json['value'] as int,
      $type: json['type'] as String?,
    );

Map<String, dynamic> _$$IntParameterToJson(_$IntParameter instance) =>
    <String, dynamic>{
      'child': instance.child,
      'name': instance.name,
      'value': instance.value,
      'type': instance.$type,
    };

_$DoubleParameter _$$DoubleParameterFromJson(Map json) => _$DoubleParameter(
      child: json['child'] as int,
      name: json['name'] as String,
      value: (json['value'] as num).toDouble(),
      $type: json['type'] as String?,
    );

Map<String, dynamic> _$$DoubleParameterToJson(_$DoubleParameter instance) =>
    <String, dynamic>{
      'child': instance.child,
      'name': instance.name,
      'value': instance.value,
      'type': instance.$type,
    };

_$_PackAssetLocation _$$_PackAssetLocationFromJson(Map json) =>
    _$_PackAssetLocation(
      json['pack'] as String? ?? '',
      json['name'] as String? ?? '',
    );

Map<String, dynamic> _$$_PackAssetLocationToJson(
        _$_PackAssetLocation instance) =>
    <String, dynamic>{
      'pack': instance.pack,
      'name': instance.name,
    };
