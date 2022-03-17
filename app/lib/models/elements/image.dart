import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:butterfly/models/elements/element.dart';
import 'package:butterfly/models/elements/positioned.dart';
import 'package:flutter/material.dart';

class ImageElement extends PositionedElement {
  final Uint8List pixels;
  final int width, height;
  final double scale;

  const ImageElement(
      {required this.pixels,
      required this.width,
      required this.height,
      Offset position = Offset.zero,
      String layer = '',
      this.scale = 1})
      : super(layer: layer, position: position);
  static Future<ImageElement> fromImage(ui.Image image,
          [Offset position = Offset.zero, double scale = 1]) =>
      image.toByteData(format: ui.ImageByteFormat.rawRgba).then((value) =>
          ImageElement(
              pixels: value?.buffer.asUint8List() ?? Uint8List(0),
              width: image.width,
              height: image.height,
              position: position,
              scale: scale));

  ImageElement.fromJson(Map<String, dynamic> json, [int? fileVersion])
      : pixels = Uint8List.fromList(base64.decode(json['pixels'])),
        height = json['height'],
        width = json['width'],
        scale = json['scale'] ?? 1,
        super.fromJson(json);

  @override
  Map<String, dynamic> toJson() => {
        'pixels': base64.encode(pixels.toList()),
        'height': height,
        'width': width,
        'scale': scale,
      }..addAll(super.toJson());

  @override
  ImageElement copyWith(
      {String? layer,
      Uint8List? pixels,
      int? width,
      int? height,
      Offset? position,
      double? scale}) {
    return ImageElement(
        layer: layer ?? this.layer,
        pixels: pixels ?? this.pixels,
        width: width ?? this.width,
        height: height ?? this.height,
        position: position ?? this.position,
        scale: scale ?? this.scale);
  }

  @override
  bool hit(Offset offset, [double radius = 1]) {
    return offset.dx >= position.dx &&
        offset.dy >= position.dy &&
        offset.dx <= position.dx + width * scale &&
        offset.dy <= position.dy + height * scale;
  }

  @override
  void paint(Canvas canvas, [bool preview = false]) =>
      throw UnimplementedError();

  @override
  ui.Rect get rect =>
      Rect.fromLTWH(position.dx, position.dy, width * scale, height * scale);

  @override
  ImageElement moveBy(Offset offset) => copyWith(position: position + offset);

  @override
  ElementType get type => ElementType.image;
}
