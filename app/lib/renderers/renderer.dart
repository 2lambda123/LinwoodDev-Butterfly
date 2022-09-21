import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:ui' show Image;

import 'package:butterfly/models/area.dart';
import 'package:butterfly/models/document.dart';
import 'package:butterfly/models/element.dart';
import 'package:butterfly/visualizer/element.dart';
import 'package:butterfly/visualizer/int.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:perfect_freehand/perfect_freehand.dart' as pf;
import 'package:xml/xml.dart';

import '../cubits/transform.dart';
import '../helpers/xml_helper.dart';
import '../models/background.dart';
import '../models/path_point.dart';
import '../models/property.dart';

part 'backgrounds/box.dart';
part 'backgrounds/empty.dart';
part 'elements/eraser.dart';
part 'elements/image.dart';
part 'elements/label.dart';
part 'elements/path.dart';
part 'elements/pen.dart';
part 'elements/shape.dart';
part 'elements/svg.dart';

class DefaultHitCalculator extends HitCalculator {
  final Rect rect;

  DefaultHitCalculator(this.rect);

  @override
  bool hit(Rect rect) => this.rect.overlaps(rect);
}

abstract class HitCalculator {
  bool hit(Rect rect);
}

abstract class Renderer<T> {
  final T element;
  Area? area;

  Renderer(this.element);

  @mustCallSuper
  FutureOr<void> setup(AppDocument document) async => _updateArea(document);

  void _updateArea(AppDocument document) => area = rect == null
      ? null
      : document.areas.firstWhereOrNull((area) => area.rect.overlaps(rect!));
  FutureOr<bool> onAreaUpdate(AppDocument document, Area? area) async {
    if (area?.rect.overlaps(rect!) ?? false) {
      this.area = area;
    }
    return false;
  }

  Rect? get rect => null;
  void build(
      Canvas canvas, Size size, AppDocument document, CameraTransform transform,
      [bool foreground = false]);
  bool hit(Rect rect) => this.rect?.overlaps(rect) ?? false;
  void buildSvg(XmlDocument xml, AppDocument document, Rect viewportRect) {}
  factory Renderer.fromInstance(T element) {
    // Elements
    if (element is PadElement) {
      if (element is PenElement) {
        return PenRenderer(element) as Renderer<T>;
      }
      if (element is ShapeElement) {
        return ShapeRenderer(element) as Renderer<T>;
      }
      if (element is EraserElement) {
        return EraserRenderer(element) as Renderer<T>;
      }
      if (element is LabelElement) {
        return LabelRenderer(element) as Renderer<T>;
      }
      if (element is ImageElement) {
        return ImageRenderer(element) as Renderer<T>;
      }
      if (element is SvgElement) {
        return SvgRenderer(element) as Renderer<T>;
      }
    }

    // Backgrounds
    if (element is Background) {
      if (element is EmptyBackground) {
        return EmptyBackgroundRenderer(element) as Renderer<T>;
      }
      if (element is BoxBackground) {
        return BoxBackgroundRenderer(element) as Renderer<T>;
      }
    }

    throw Exception('Invalid instance type');
  }

  Renderer<T>? transform(
          {Offset position = Offset.zero,
          double scaleX = 1,
          double scaleY = 1,
          bool relative = true}) =>
      null;
}
