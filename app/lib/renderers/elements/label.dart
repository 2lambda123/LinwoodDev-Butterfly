part of '../renderer.dart';

class LabelRenderer extends Renderer<LabelElement> {
  @override
  Rect rect;

  LabelRenderer(LabelElement element, [this.rect = Rect.zero]) : super(element);

  TextAlign _convertAlignment(HorizontalAlignment alignment) {
    switch (alignment) {
      case HorizontalAlignment.left:
        return TextAlign.left;
      case HorizontalAlignment.right:
        return TextAlign.right;
      case HorizontalAlignment.center:
        return TextAlign.center;
      case HorizontalAlignment.justify:
        return TextAlign.justify;
    }
  }

  TextPainter _createPainter() => TextPainter(
      text: TextSpan(
          style: TextStyle(
              fontSize: element.property.size,
              fontStyle:
                  element.property.italic ? FontStyle.italic : FontStyle.normal,
              color: Color(element.property.color),
              fontWeight: FontWeight.values[element.property.fontWeight],
              letterSpacing: element.property.letterSpacing,
              decorationColor: Color(element.property.decorationColor),
              decorationStyle: element.property.decorationStyle,
              decorationThickness: element.property.decorationThickness,
              decoration: TextDecoration.combine([
                if (element.property.underline) TextDecoration.underline,
                if (element.property.lineThrough) TextDecoration.lineThrough,
                if (element.property.overline) TextDecoration.overline,
              ])),
          text: element.text),
      textAlign: _convertAlignment(element.property.horizontalAlignment),
      textDirection: TextDirection.ltr,
      textScaleFactor: 1.0);

  @override
  FutureOr<void> setup(AppDocument document) {
    _updateRect();
    super.setup(document);
  }

  @override
  FutureOr<void> onAreaUpdate(AppDocument document) async {
    await super.onAreaUpdate(document);
    _updateRect();
  }

  void _updateRect() {
    var maxWidth = double.infinity;
    final constraints = element.constraints;
    if (constraints is FixedElementConstraints) {
      if (constraints.width > 0) maxWidth = constraints.width;
    } else if (constraints is DynamicElementConstraints) {
      if (constraints.width > 0) maxWidth = constraints.width;
      if (constraints.includeArea && area != null) {
        maxWidth = min(maxWidth + element.position.dx, area!.rect.right) -
            element.position.dx;
      }
    }
    final tp = _createPainter();
    tp.layout(maxWidth: maxWidth);
    var height = tp.height;
    if (constraints is FixedElementConstraints) {
      if (height < constraints.height) {
        height = constraints.height;
      }
    } else if (constraints is DynamicElementConstraints) {
      if (height < constraints.height) {
        height = constraints.height;
      } else if (constraints.aspectRatio > 0) {
        height = maxWidth / constraints.aspectRatio;
      } else if (constraints.includeArea && area != null) {
        height = min(height, area!.rect.bottom - element.position.dy);
      }
    }
    rect = Rect.fromLTWH(
        element.position.dx, element.position.dy, tp.width, height);
  }

  @override
  FutureOr<void> build(Canvas canvas, Size size, CameraTransform transform,
      [bool foreground = false]) {
    final tp = _createPainter();
    tp.layout(maxWidth: rect.width);
    var current = element.position;
    // Change vertical alignment
    final align = element.property.verticalAlignment;
    switch (align) {
      case VerticalAlignment.top:
        current = current.translate(0, 0);
        break;
      case VerticalAlignment.bottom:
        current = current.translate(0, rect.height - tp.height);
        break;
      case VerticalAlignment.center:
        current = current.translate(0, (rect.height - tp.height) / 2);
        break;
    }
    tp.paint(canvas, current);
  }

  @override
  LabelElement move(Offset position) => element.copyWith(position: position);
}
