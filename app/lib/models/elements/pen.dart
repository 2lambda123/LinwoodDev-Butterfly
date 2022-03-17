import 'package:butterfly/models/elements/path.dart';
import 'package:butterfly/models/properties/pen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

import 'element.dart';

class PenElement extends PathElement {
  @override
  final PenProperty property;

  const PenElement(
      {String layer = '',
      List<PathPoint> points = const [],
      this.property = const PenProperty()})
      : super(layer: layer, points: points);

  PenElement.fromJson(Map<String, dynamic> json, [int? fileVersion])
      : property = PenProperty.fromJson(json),
        super.fromJson(json);

  @override
  Paint buildPaint([bool preview = false]) => Paint()
    ..color = property.color
    ..style = property.fill ? PaintingStyle.fill : PaintingStyle.stroke
    ..strokeCap = StrokeCap.round;

  @override
  void paint(Canvas canvas, [bool preview = false]) {
    if (!property.fill) {
      super.paint(canvas, preview);
    } else if (points.isNotEmpty) {
      var path = Path();
      path.moveTo(points.first.x, points.first.y);
      for (var element in points.sublist(1)) {
        path.lineTo(element.x, element.y);
      }
      canvas.drawPath(path, buildPaint(preview));
    }
  }

  @override
  PenElement copyWith(
          {String? layer, List<PathPoint>? points, PenProperty? property}) =>
      PenElement(
          layer: layer ?? this.layer,
          points: points ?? this.points,
          property: property ?? this.property);

  @override
  ElementType get type => ElementType.pen;
}
