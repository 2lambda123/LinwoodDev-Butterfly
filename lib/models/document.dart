import 'package:butterfly/models/packs/collection.dart';
import 'package:butterfly/models/project/folder.dart';
import 'package:butterfly/models/project/pad.dart';
import 'package:flutter/foundation.dart';

class AppDocument {
  String name;
  String description;
  String mainPad = 'pads/main';
  FolderProjectItem folder = FolderProjectItem(name: 'pads')..addFile(PadProjectItem(name: 'main'));
  List<PackCollection> packs = [];

  AppDocument({@required this.name, this.description});

  AppDocument.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        description = json['description'],
        mainPad = json['mainPad'],
        folder = FolderProjectItem.fromJson(json['folder']);
}
