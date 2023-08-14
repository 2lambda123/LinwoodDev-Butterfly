import 'package:butterfly_api/butterfly_api.dart';
import 'package:flutter/material.dart';

bool isDarkColor(Color color) {
  // Berechne die Helligkeit der Farbe basierend auf dem relativen Luminanzwert.
  double luminance = color.computeLuminance();
  // Definiere einen Schwellenwert, der angibt, ab welchem Luminanzwert eine Farbe als "dunkel" gilt.
  const double threshold = 0.5;
  // Wenn die Helligkeit der Farbe unter dem Schwellenwert liegt, geben wir true zurück (die Farbe ist dunkel).
  // Andernfalls geben wir false zurück (die Farbe ist hell).
  return luminance < threshold;
}

extension BackgroundColor on Background {
  int get defaultColor =>
      maybeMap(pattern: (box) => box.boxColor, orElse: () => kColorWhite);
}

Tool updateToolDefaultColor(Tool tool, int color) {
  final defaultColor = isDarkColor(Color(color)) ? kColorWhite : kColorBlack;
  return tool.maybeMap(
    pen: (pen) =>
        pen.copyWith(property: pen.property.copyWith(color: defaultColor)),
    shape: (shape) =>
        shape.copyWith(property: shape.property.copyWith(color: defaultColor)),
    label: (label) => label.copyWith(foreground: defaultColor),
    orElse: () => tool,
  );
}
