// ignore_for_file: prefer_const_constructors

import 'package:butterfly/visualizer/property.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../models/painter.dart';

extension PainterVisualizer on Painter {
  String getLocalizedName(BuildContext context) {
    if (this is HandPainter) {
      return AppLocalizations.of(context)!.hand;
    }
    if (this is UndoPainter) {
      return AppLocalizations.of(context)!.undo;
    }
    if (this is RedoPainter) {
      return AppLocalizations.of(context)!.redo;
    }
    if (this is PenPainter) {
      return AppLocalizations.of(context)!.pen;
    }
    if (this is ShapePainter) {
      return AppLocalizations.of(context)!.shape;
    }
    if (this is LabelPainter) {
      return AppLocalizations.of(context)!.label;
    }
    if (this is PathEraserPainter) {
      return AppLocalizations.of(context)!.pathEraser;
    }
    if (this is EraserPainter) {
      return AppLocalizations.of(context)!.eraser;
    }
    if (this is AreaPainter) {
      return AppLocalizations.of(context)!.area;
    }
    if (this is AreaPainter) {
      return AppLocalizations.of(context)!.area;
    }
    if (this is LayerPainter) {
      return AppLocalizations.of(context)!.layer;
    }
    if (this is LaserPainter) {
      return AppLocalizations.of(context)!.laser;
    }
    if (this is StampPainter) {
      return AppLocalizations.of(context)!.stamp;
    }
    throw UnimplementedError();
  }

  IconData getIcon({bool filled = false}) {
    if (this is HandPainter) {
      return filled ? PhosphorIcons.handFill : PhosphorIcons.hand;
    }
    if (this is UndoPainter) {
      return filled
          ? PhosphorIcons.arrowCounterClockwiseFill
          : PhosphorIcons.arrowCounterClockwiseLight;
    }
    if (this is RedoPainter) {
      return filled
          ? PhosphorIcons.arrowClockwiseFill
          : PhosphorIcons.arrowClockwiseLight;
    }
    if (this is PenPainter) {
      return filled ? PhosphorIcons.penFill : PhosphorIcons.penLight;
    }
    if (this is ShapePainter) {
      final shape = (this as ShapePainter).property.shape;
      return shape.getIcon(filled: filled);
    }
    if (this is LabelPainter) {
      return filled ? PhosphorIcons.textTFill : PhosphorIcons.textTLight;
    }
    if (this is PathEraserPainter) {
      return filled ? PhosphorIcons.pathFill : PhosphorIcons.pathLight;
    }
    if (this is EraserPainter) {
      return filled ? PhosphorIcons.eraserFill : PhosphorIcons.eraserLight;
    }
    if (this is AreaPainter) {
      return filled ? PhosphorIcons.monitorFill : PhosphorIcons.monitorLight;
    }
    if (this is LayerPainter) {
      return filled
          ? PhosphorIcons.squaresFourFill
          : PhosphorIcons.squaresFourLight;
    }
    if (this is LaserPainter) {
      return filled ? PhosphorIcons.cursorFill : PhosphorIcons.cursorLight;
    }
    if (this is StampPainter) {
      return filled ? PhosphorIcons.stampFill : PhosphorIcons.stampLight;
    }
    throw UnimplementedError();
  }

  bool isAction() {
    if (this is UndoPainter || this is RedoPainter) {
      return true;
    }
    return false;
  }
}
