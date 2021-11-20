import 'package:butterfly/models/backgrounds/box.dart';
import 'package:butterfly/models/elements/eraser.dart';
import 'package:butterfly/models/painters/eraser.dart';
import 'package:butterfly/models/painters/image.dart';
import 'package:butterfly/models/painters/label.dart';
import 'package:butterfly/models/painters/painter.dart';
import 'package:butterfly/models/painters/path_eraser.dart';
import 'package:butterfly/models/painters/pen.dart';
import 'package:butterfly/models/palette.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'elements/element.dart';
import 'elements/image.dart';
import 'elements/label.dart';
import 'elements/pen.dart';
import 'waypoint.dart';

@immutable
class AppDocumentFile {
  final String path;

  final Map<String, dynamic> json;

  const AppDocumentFile(this.path, this.json);

  int get fileVersion => json['fileVersion'];

  String get name => json['name'];

  String get description => json['description'];
}

@immutable
class AppDocument {
  final String name, description;

  //final List<PackCollection> packs;
  final List<ElementLayer> content;
  final List<Painter> painters;
  final BoxBackground? background;
  final List<ColorPalette> palettes;
  final List<Waypoint> waypoints;
  final DateTime createdAt;
  final DateTime updatedAt;

  const AppDocument(
      {required this.name,
      this.description = '',
      this.content = const [],
      this.background,
      this.palettes = const [],
      this.waypoints = const [],
      required this.createdAt,
      DateTime? updatedAt,
      this.painters = const [
        PenPainter(),
        EraserPainter(),
        LabelPainter(),
        ImagePainter()
      ]})
      : updatedAt = updatedAt ?? createdAt;

  factory AppDocument.fromJson(Map<String, dynamic> json) {
    var version = json['fileVersion'] is int
        ? json['fileVersion']
        : int.tryParse(json['fileVersion']) ??
            GetIt.I.get<int>(instanceName: 'fileVersion');
    if (version >= 0 && version < 4) {
      json['palettes'] = List<dynamic>.from(
          Map<String, dynamic>.from(json['palettes'] ?? [])
              .entries
              .map<ColorPalette>((e) => ColorPalette(
                  colors: List<int>.from(e.value).map((e) => Color(e)).toList(),
                  name: e.key))
              .map((e) => e.toJson())
              .toList());
    }
    var name = json['name'];
    var description = json['description'];
    var palettes = (List<Map<String, dynamic>>.from(json['palettes'] ?? []))
        .map<ColorPalette>(
            (e) => ColorPalette.fromJson(Map<String, dynamic>.from(e)))
        .toList();
    var background = json['background'] == null
        ? null
        : BoxBackground.fromJson(json['background'], version);
    var waypoints = List<Map<String, dynamic>>.from(json['waypoints'] ?? [])
        .map((e) => Waypoint.fromJson(e))
        .toList();
    var painters = List<Map<String, dynamic>>.from(json['painters'] ?? [])
        .map<Painter>((e) {
      switch (e['type']) {
        case 'eraser':
          return EraserPainter.fromJson(e, version);
        case 'path-eraser':
          return PathEraserPainter.fromJson(e, version);
        case 'label':
          return LabelPainter.fromJson(e, version);
        case 'image':
          return ImagePainter.fromJson(e, version);
        default:
          return PenPainter.fromJson(e, version);
      }
    }).toList();
    var content =
        List<Map<String, dynamic>>.from(json['content']).map<ElementLayer>((e) {
      switch (e['type']) {
        case 'label':
          return LabelElement.fromJson(e, version);
        case 'eraser':
          return EraserElement.fromJson(e, version);
        case 'image':
          return ImageElement.fromJson(e, version);
        default:
          return PenElement.fromJson(e, version);
      }
    }).toList();
    var createdAt =
        DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now();
    var updatedAt = DateTime.tryParse(json['updatedAt'] ?? '') ?? createdAt;
    return AppDocument(
        createdAt: createdAt,
        updatedAt: updatedAt,
        name: name,
        background: background,
        content: content,
        description: description,
        painters: painters,
        palettes: palettes,
        waypoints: waypoints);
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'description': description,
        'palettes': palettes.map((e) => e.toJson()).toList(),
        'painters':
            painters.map<Map<String, dynamic>>((e) => e.toJson()).toList(),
        'content':
            content.map<Map<String, dynamic>>((e) => e.toJson()).toList(),
        'waypoints': waypoints.map((e) => e.toJson()).toList(),
        'background': background?.toJson(),
        'fileVersion': GetIt.I.get<int>(instanceName: 'fileVersion'),
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String()
      };

  AppDocument copyWith(
      {String? name,
      String? description,
      List<ElementLayer>? content,
      List<Painter>? painters,
      BoxBackground? background,
      List<ColorPalette>? palettes,
      List<Waypoint>? waypoints,
      bool removeBackground = false,
      DateTime? createdAt,
      DateTime? updatedAt}) {
    return AppDocument(
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        name: name ?? this.name,
        description: description ?? this.description,
        content: content ?? this.content,
        painters: painters ?? this.painters,
        palettes: palettes ?? this.palettes,
        waypoints: waypoints ?? this.waypoints,
        background: removeBackground ? null : (background ?? this.background));
  }
}
