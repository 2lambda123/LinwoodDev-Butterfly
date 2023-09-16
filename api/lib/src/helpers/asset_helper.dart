import 'package:collection/collection.dart';

import '../models/asset.dart';

extension AssetFileTypeHelper on AssetFileType {
  List<String> getFileExtensions() {
    switch (this) {
      case AssetFileType.note:
        return ['bfly', 'json'];
      case AssetFileType.image:
        return ['png', 'jpg', 'jpeg', 'gif', 'bmp', 'ico'];
      case AssetFileType.pdf:
        return ['pdf'];
      case AssetFileType.svg:
        return ['svg'];
      case AssetFileType.markdown:
        return ['md', 'markdown'];
      case AssetFileType.page:
        return [];
    }
  }

  String getMime() {
    switch (this) {
      case AssetFileType.note:
        return 'application/zip';
      case AssetFileType.image:
        return 'image/*';
      case AssetFileType.markdown:
        return 'text/markdown';
      case AssetFileType.pdf:
        return 'application/pdf';
      case AssetFileType.svg:
        return 'image/svg+xml';
      case AssetFileType.page:
        return 'application/json';
    }
  }

  bool isMimeType(String mimeType) {
    final mime = getMime();
    return RegExp(mime).hasMatch(mime);
  }

  static AssetFileType? fromFileExtension(String? ext) {
    return AssetFileType.values.firstWhereOrNull(
      (type) => type.getFileExtensions().contains(ext),
    );
  }

  static AssetFileType? fromMime(String mime) {
    return AssetFileType.values.firstWhereOrNull(
      (type) => type.isMimeType(mime),
    );
  }
}
