// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pack.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_ButterflyPack _$$_ButterflyPackFromJson(Map json) => _$_ButterflyPack(
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      author: json['author'] as String? ?? '',
      components: (json['components'] as List<dynamic>?)
              ?.map((e) => ButterflyComponent.fromJson(
                  Map<String, dynamic>.from(e as Map)))
              .toList() ??
          const <ButterflyComponent>[],
      styles: (json['styles'] as List<dynamic>?)
              ?.map((e) =>
                  TextStyleSheet.fromJson(Map<String, dynamic>.from(e as Map)))
              .toList() ??
          const <TextStyleSheet>[],
      palettes: (json['palettes'] as List<dynamic>?)
              ?.map((e) =>
                  ColorPalette.fromJson(Map<String, dynamic>.from(e as Map)))
              .toList() ??
          const <ColorPalette>[],
      createdAt:
          const DateTimeJsonConverter().fromJson(json['createdAt'] as int),
      updatedAt:
          const DateTimeJsonConverter().fromJson(json['updatedAt'] as int),
    );

Map<String, dynamic> _$$_ButterflyPackToJson(_$_ButterflyPack instance) =>
    <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'author': instance.author,
      'components': instance.components.map((e) => e.toJson()).toList(),
      'styles': instance.styles.map((e) => e.toJson()).toList(),
      'palettes': instance.palettes.map((e) => e.toJson()).toList(),
      'createdAt': const DateTimeJsonConverter().toJson(instance.createdAt),
      'updatedAt': const DateTimeJsonConverter().toJson(instance.updatedAt),
    };

_$_ButterflyComponent _$$_ButterflyComponentFromJson(Map json) =>
    _$_ButterflyComponent(
      name: json['name'] as String,
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
      pack: json['pack'] as String? ?? '',
      name: json['name'] as String? ?? '',
    );

Map<String, dynamic> _$$_PackAssetLocationToJson(
        _$_PackAssetLocation instance) =>
    <String, dynamic>{
      'pack': instance.pack,
      'name': instance.name,
    };
