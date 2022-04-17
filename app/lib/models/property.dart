import 'package:butterfly/models/colors.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'property.freezed.dart';
part 'property.g.dart';

abstract class PathProperty {
  double get strokeWidth;
  double get strokeMultiplier;

  Map<String, dynamic> toJson();
}

enum HorizontalAlignment { left, center, right, justify }

enum VerticalAlignment { top, center, bottom }

@freezed
class Property with _$Property {
  const factory Property.hand({@Default(false) bool includeEraser}) =
      HandProperty;

  const factory Property.label(
      {@Default(12)
          double size,
      @Default(kColorBlack)
          int color,
      @Default(3)
          int fontWeight,
      @Default(false)
          bool lineThrough,
      @Default(false)
          bool underline,
      @Default(false)
          bool overline,
      @Default(false)
          bool italic,
      @Default(0)
          double letterSpacing,
      @Default(kColorBlack)
          int decorationColor,
      @Default(TextDecorationStyle.solid)
          TextDecorationStyle decorationStyle,
      @Default(1)
          double decorationThickness,
      @Default(HorizontalAlignment.left)
          HorizontalAlignment horizontalAlignment,
      @Default(VerticalAlignment.top)
          VerticalAlignment verticalAlignment}) = LabelProperty;

  @With<PathProperty>()
  const factory Property.eraser(
      {@Default(5) double strokeWidth,
      @Default(10) double strokeMultiplier,
      @Default(kColorBlack) int color}) = EraserProperty;

  @With<PathProperty>()
  const factory Property.pen(
      {@Default(5) double strokeWidth,
      @Default(10) double strokeMultiplier,
      @Default(kColorBlack) int color,
      @Default(false) bool fill}) = PenProperty;

  factory Property.fromJson(Map<String, dynamic> json) =>
      _$PropertyFromJson(json);
}
