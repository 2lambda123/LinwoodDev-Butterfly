// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'export.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_ExportPreset _$$_ExportPresetFromJson(Map json) => _$_ExportPreset(
      name: json['name'] as String? ?? '',
      areas: (json['areas'] as List<dynamic>?)
              ?.map((e) =>
                  AreaPreset.fromJson(Map<String, dynamic>.from(e as Map)))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$_ExportPresetToJson(_$_ExportPreset instance) =>
    <String, dynamic>{
      'name': instance.name,
      'areas': instance.areas.map((e) => e.toJson()).toList(),
    };

_$_AreaPreset _$$_AreaPresetFromJson(Map json) => _$_AreaPreset(
      name: json['name'] as String? ?? '',
      quality: (json['quality'] as num?)?.toDouble() ?? 1,
      area: json['area'] == null
          ? null
          : Area.fromJson(Map<String, dynamic>.from(json['area'] as Map)),
    );

Map<String, dynamic> _$$_AreaPresetToJson(_$_AreaPreset instance) =>
    <String, dynamic>{
      'name': instance.name,
      'quality': instance.quality,
      'area': instance.area?.toJson(),
    };
