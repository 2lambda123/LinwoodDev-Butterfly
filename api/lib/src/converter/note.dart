import 'dart:convert';
import 'dart:typed_data';

import 'package:archive/archive.dart';

import '../../butterfly_api.dart';

const kArchiveSignature = 0x50;

NoteData noteDataMigrator(Uint8List data) {
  Archive archive;
  if (data.isNotEmpty && data[0] != kArchiveSignature) {
    final map = json.decode(utf8.decode(data)) as Map<String, dynamic>;
    archive = convertLegacyDataToArchive(map);
  } else {
    archive = ZipDecoder().decodeBytes(data);
  }
  final noteData = NoteData(archive);
  var metadata = noteData.getMetadata();
  if (metadata != null &&
      (metadata.fileVersion ?? kFileVersion) < kFileVersion) {
    _migrate(noteData, metadata);
    metadata = noteData.getMetadata();
    if (metadata != null) {
      noteData.setMetadata(metadata.copyWith(
        fileVersion: kFileVersion,
        updatedAt: DateTime.now(),
      ));
    }
  }
  return noteData;
}

void _migrate(NoteData noteData, FileMetadata metadata) {
  final version = metadata.fileVersion ?? kFileVersion;
  if (version < 9) {
    final pagePath = '$kPagesArchiveDirectory/default.json';
    final page = noteData.getAsset(pagePath);
    if (page != null) {
      final pageData = json.decode(utf8.decode(page)) as Map<String, dynamic>;
      noteData.setAsset(
          kInfoArchiveFile,
          utf8.encode(json.encode({
            'painters': (pageData['painters'] as List?)
                ?.where((element) => element['type'] != 'waypoint'),
            ...pageData,
          })));
    }
  }
  if (version < 10) {
    for (final page in noteData.getAssets(kPagesArchiveDirectory)) {
      final data = noteData.getAsset('$kPagesArchiveDirectory/$page');
      if (data == null) continue;
      final pageData = json.decode(utf8.decode(data)) as Map<String, dynamic>;
      if (pageData['background']?['type'] == 'box') {
        pageData['background']['type'] = 'pattern';
        noteData.setAsset('$kPagesArchiveDirectory/$page',
            utf8.encode(json.encode(pageData)));
      }
    }
  }
}
