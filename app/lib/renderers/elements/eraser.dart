part of '../renderer.dart';

class EraserRenderer extends PathRenderer<EraserElement> {
  EraserRenderer(EraserElement element, [Rect rect = Rect.zero])
      : super(element, rect);

  @override
  Paint buildPaint([bool foreground = false]) => Paint()
    ..style = PaintingStyle.stroke
    ..color = Colors.white
    ..strokeCap = StrokeCap.round
    ..blendMode = foreground ? BlendMode.srcOver : BlendMode.clear;
}
