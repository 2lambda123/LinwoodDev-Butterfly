import 'dart:convert';
import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';

import '../helpers/asset_helper.dart';
import 'data.dart';
import 'meta.dart';

part 'asset.freezed.dart';
part 'asset.g.dart';

enum AssetFileType { note, page, image, markdown, pdf, svg }

@freezed
sealed class AssetLocation with _$AssetLocation {
  const factory AssetLocation({
    @Default('') String remote,
    required String path,
    @Default(false) bool absolute,
  }) = _AssetLocation;

  factory AssetLocation.local(String path, [bool absolute = false]) =>
      AssetLocation(path: path, absolute: absolute);

  factory AssetLocation.fromJson(Map<String, dynamic> json) =>
      _$AssetLocationFromJson(json);

  const AssetLocation._();

  String get identifier =>
      remote == '' ? pathWithLeadingSlash : '$pathWithLeadingSlash@$remote';

  String get pathWithLeadingSlash => path.startsWith('/') ? path : '/$path';

  String get pathWithoutLeadingSlash =>
      path.startsWith('/') ? path.substring(1) : path;

  String get fileExtension =>
      fileName.contains('.') ? fileName.split('.').last : '';

  AssetFileType? get fileType =>
      AssetFileTypeHelper.fromFileExtension(fileExtension);

  String get fileName => path.split('/').last;

  bool isSame(AssetLocation other) =>
      pathWithLeadingSlash == other.pathWithLeadingSlash &&
      remote == other.remote;
}

@freezed
class AppDocumentEntity with _$AppDocumentEntity {
  const AppDocumentEntity._();

  const factory AppDocumentEntity.file(
    AssetLocation location,
    List<int> data, {
    @Default(false) bool cached,
    FileMetadata? metadata,
    Uint8List? thumbnail,
  }) = AppDocumentFile;

  factory AppDocumentEntity.fileFromMap(
    AssetLocation location,
    Map<String, dynamic> map, {
    bool cached = false,
    FileMetadata? metadata,
    Uint8List? thumbnail,
  }) =>
      AppDocumentFile(
          location, Uint8List.fromList(utf8.encode(json.encode(map))),
          metadata: metadata, thumbnail: thumbnail, cached: cached);

  const factory AppDocumentEntity.directory(
          AssetLocation location, List<AppDocumentEntity> assets) =
      AppDocumentDirectory;

  String get fileName => location.fileName;

  String get fileExtension => location.fileExtension;

  String get fileNameWithoutExtension => fileName.substring(0,
      fileName.contains('.') ? fileName.lastIndexOf('.') : fileName.length - 1);

  String get pathWithLeadingSlash => location.pathWithLeadingSlash;

  String get pathWithoutLeadingSlash => location.pathWithoutLeadingSlash;

  String get parent => pathWithLeadingSlash
      .split('/')
      .sublist(0, pathWithLeadingSlash.split('/').length - 1)
      .join('/');
}

extension EntityFileTypeExtension on AppDocumentEntity {
  AssetFileType? get fileType => location.fileType;
}

extension AppDocumentLoadExtension on AppDocumentFile {
  NoteData load({bool disableMigrations = false}) =>
      NoteData.fromData(Uint8List.fromList(data),
          disableMigrations: disableMigrations);
}
