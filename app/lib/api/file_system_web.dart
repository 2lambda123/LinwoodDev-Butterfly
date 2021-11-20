import 'package:butterfly/models/document.dart';
import 'package:idb_shim/idb.dart';
import 'package:idb_shim/idb_browser.dart';

import 'file_system.dart';

class WebDocumentFileSystem extends DocumentFileSystem {
  Future<Database> _getDatabase() async {
    var idbFactory = getIdbFactory()!;
    return await idbFactory.open('butterfly.db', version: 1,
        onUpgradeNeeded: (VersionChangeEvent event) {
      Database db = event.database;
      // create the store
      db.createObjectStore('documents', autoIncrement: true);
    });
  }

  @override
  Future<AppDocumentFile> importDocument(AppDocument document) async {
    var path = document.name;
    var counter = 1;
    while (await hasDocument(path)) {
      path = '${document.name}_${++counter}';
    }
    var db = await _getDatabase();
    var txn = db.transaction('documents', 'readwrite');
    var doc = document.toJson();
    var store = txn.objectStore('documents');
    await store.add(doc, path);
    await txn.completed;
    return AppDocumentFile(path, doc);
  }

  @override
  Future<void> deleteDocument(String path) async {
    var db = await _getDatabase();
    var txn = db.transaction('documents', 'readwrite');
    var store = txn.objectStore('documents');
    var deleted = await store.delete(path);
    await txn.completed;
    return deleted;
  }

  @override
  Future<AppDocumentFile?> getDocument(String path) async {
    var db = await _getDatabase();
    var txn = db.transaction('documents', 'readonly');
    var store = txn.objectStore('documents');
    var doc = await store.getObject(path);
    await txn.completed;
    var map = Map<String, dynamic>.from(doc as Map<dynamic, dynamic>);
    return AppDocumentFile(path, map);
  }

  @override
  Future<List<AppDocumentFile>> getDocuments() async {
    var db = await _getDatabase();
    var txn = db.transaction('documents', 'readonly');
    var store = txn.objectStore('documents');
    var docs = await store.getAll();
    await txn.completed;
    return docs.map((doc) {
      // Convert doc to Map
      var map = Map<String, dynamic>.from(doc as Map<dynamic, dynamic>);

      return AppDocumentFile(map['name'] as String, map);
    }).toList();
  }

  @override
  Future<bool> hasDocument(String name) async {
    var db = await _getDatabase();
    var txn = db.transaction('documents', 'readonly');
    var store = txn.objectStore('documents');
    var doc = await store.getObject(name);
    await txn.completed;
    return doc != null;
  }

  @override
  Future<AppDocumentFile> updateDocument(
      String path, AppDocument document) async {
    var db = await _getDatabase();
    var txn = db.transaction('documents', 'readwrite');
    var store = txn.objectStore('documents');
    var doc = document.toJson();
    await store.put(doc, path);
    await txn.completed;
    return AppDocumentFile(path, doc);
  }
}
