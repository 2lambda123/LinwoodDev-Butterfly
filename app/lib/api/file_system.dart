import 'dart:async';

import 'package:butterfly/api/file_system_io.dart';
import 'package:butterfly/api/file_system_web.dart';
import 'package:butterfly/models/document.dart';
import 'package:butterfly/models/palette.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as path;

abstract class DocumentFileSystem {
  Future<AppDocumentDirectory> getRootDirectory() {
    return getAsset('').then((value) => value as AppDocumentDirectory);
  }

  Future<AppDocumentAsset?> getAsset(String path);

  Future<AppDocumentDirectory> createDirectory(String name);

  Future<AppDocumentFile> createDocument(String name,
          {List<ColorPalette> palettes = const []}) =>
      importDocument(AppDocument(
          name: name, palettes: palettes, createdAt: DateTime.now()));

  Future<bool> hasAsset(String path);

  Future<AppDocumentFile> updateDocument(String path, AppDocument document);

  Future<void> deleteAsset(String path);

  Future<AppDocumentFile> importDocument(AppDocument document);

  Future<AppDocumentAsset?> renameAsset(String path, String newName) async {
    // Remove leading slash
    if (path.startsWith('/')) {
      path = path.substring(1);
    }
    final asset = await getAsset(path);
    if (asset == null) return null;
    AppDocumentAsset? newAsset;
    if (asset is AppDocumentFile) {
      newAsset = await updateDocument(newName, asset.load());
    } else {
      newAsset = await createDirectory(newName);
      var assets = (asset as AppDocumentDirectory).assets;
      for (var current in assets) {
        var currentPath = current.path;
        if (currentPath.startsWith('/')) currentPath = currentPath.substring(1);
        final newPath = newName + currentPath.substring(path.length);
        await renameAsset(currentPath, newPath);
      }
    }
    await deleteAsset(path);
    return newAsset;
  }

  static DocumentFileSystem fromPlatform() {
    if (kIsWeb) {
      return WebDocumentFileSystem();
    } else {
      return IODocumentFileSystem();
    }
  }

  String convertNameToFile(String name) {
    return name.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '_') + '.bfly';
  }

  FutureOr<String> getAbsolutePath(String relativePath) async {
    // Remove leading slash
    if (relativePath.startsWith('/')) {
      relativePath = relativePath.substring(1);
    }
    final root = await getDirectory();
    var absolutePath = path.join(root, relativePath);
    if (!absolutePath.startsWith(root)) {
      throw Exception('Path is not in root directory');
    }
    return absolutePath;
  }

  FutureOr<String> getDirectory() {
    return '/';
  }
}
