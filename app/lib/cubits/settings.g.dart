// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DavRemoteStorage _$$DavRemoteStorageFromJson(Map json) => _$DavRemoteStorage(
      username: json['username'] as String,
      url: json['url'] as String,
      path: json['path'] as String,
      documentsPath: json['documentsPath'] as String,
      templatesPath: json['templatesPath'] as String,
      cachedDocuments: (json['cachedDocuments'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      icon: const Uint8ListJsonConverter().fromJson(json['icon'] as String),
      lastSynced: json['lastSynced'] == null
          ? null
          : DateTime.parse(json['lastSynced'] as String),
    );

Map<String, dynamic> _$$DavRemoteStorageToJson(_$DavRemoteStorage instance) =>
    <String, dynamic>{
      'username': instance.username,
      'url': instance.url,
      'path': instance.path,
      'documentsPath': instance.documentsPath,
      'templatesPath': instance.templatesPath,
      'cachedDocuments': instance.cachedDocuments,
      'icon': const Uint8ListJsonConverter().toJson(instance.icon),
      'lastSynced': instance.lastSynced?.toIso8601String(),
    };

_$_InputConfiguration _$$_InputConfigurationFromJson(Map json) =>
    _$_InputConfiguration(
      leftMouse: json['leftMouse'] as int?,
      middleMouse: json['middleMouse'] as int? ?? 0,
      rightMouse: json['rightMouse'] as int? ?? 1,
      pen: json['pen'] as int?,
      firstPenButton: json['firstPenButton'] as int? ?? 2,
      secondPenButton: json['secondPenButton'] as int? ?? 1,
      touch: json['touch'] as int?,
    );

Map<String, dynamic> _$$_InputConfigurationToJson(
        _$_InputConfiguration instance) =>
    <String, dynamic>{
      'leftMouse': instance.leftMouse,
      'middleMouse': instance.middleMouse,
      'rightMouse': instance.rightMouse,
      'pen': instance.pen,
      'firstPenButton': instance.firstPenButton,
      'secondPenButton': instance.secondPenButton,
      'touch': instance.touch,
    };
