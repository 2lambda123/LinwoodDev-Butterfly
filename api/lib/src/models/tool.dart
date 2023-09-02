import 'dart:math';

import 'package:butterfly_api/butterfly_api.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'tool.g.dart';
part 'tool.freezed.dart';

const double _kSquareRatio = 1.0;
const double _kAPortraitRatio = 1 / sqrt2;
const double _kLandscapeRatio = sqrt2;

enum AspectRatioPreset {
  square,
  portrait,
  landscape,
}

extension RatioPresetExtension on AspectRatioPreset {
  double get ratio {
    switch (this) {
      case AspectRatioPreset.square:
        return _kSquareRatio;
      case AspectRatioPreset.portrait:
        return _kAPortraitRatio;
      case AspectRatioPreset.landscape:
        return _kLandscapeRatio;
    }
  }
}

enum LabelMode { markdown, text }

enum Axis2D { horizontal, vertical }

enum ImportType { image, camera, svg, pdf, document }

@Freezed(equal: false)
sealed class Tool with _$Tool {
  Tool._();

  factory Tool.select({
    @Default('') String name,
    @Default('') String displayIcon,
  }) = SelectTool;

  factory Tool.hand({
    @Default('') String name,
    @Default('') String displayIcon,
  }) = HandTool;

  factory Tool.import({
    @Default('') String name,
    @Default('') String displayIcon,
    required List<PadElement> elements,
    required List<Area> areas,
  }) = ImportTool;

  factory Tool.undo({
    @Default('') String name,
    @Default('') String displayIcon,
  }) = UndoTool;

  factory Tool.redo({
    @Default('') String name,
    @Default('') String displayIcon,
  }) = RedoTool;

  factory Tool.label({
    @Default('') String name,
    @Default('') String displayIcon,
    @Default(LabelMode.text) LabelMode mode,
    @Default(true) bool zoomDependent,
    @Default(kColorBlack) int foreground,
    @Default(PackAssetLocation()) PackAssetLocation styleSheet,
  }) = LabelTool;

  factory Tool.pen({
    @Default('') String name,
    @Default('') String displayIcon,
    @Default(true) bool zoomDependent,
    @Default(PenProperty()) PenProperty property,
  }) = PenTool;

  factory Tool.eraser({
    @Default('') String name,
    @Default('') String displayIcon,
    @Default(5) double strokeWidth,
  }) = EraserTool;

  factory Tool.pathEraser({
    @Default('') String name,
    @Default('') String displayIcon,
    @Default(5) double strokeWidth,
  }) = PathEraserTool;

  factory Tool.layer({
    @Default('') String name,
    @Default('') String displayIcon,
    @Default(5) double strokeWidth,
  }) = LayerTool;

  factory Tool.area({
    @Default('') String name,
    @Default('') String displayIcon,
    @Default(0) double constrainedWidth,
    @Default(0) double constrainedHeight,
    @Default(0) double constrainedAspectRatio,
    @Default(false) bool askForName,
  }) = AreaTool;

  factory Tool.laser({
    @Default('') String name,
    @Default('') String displayIcon,
    @Default(5) double duration,
    @Default(5) double strokeWidth,
    @Default(0.4) double thinning,
    @Default(kColorRed) int color,
  }) = LaserTool;

  factory Tool.shape({
    @Default('') String name,
    @Default('') String displayIcon,
    @Default(true) bool zoomDependent,
    @Default(0) double constrainedWidth,
    @Default(0) double constrainedHeight,
    @Default(0) double constrainedAspectRatio,
    @Default(ShapeProperty(shape: RectangleShape())) ShapeProperty property,
  }) = ShapeTool;

  factory Tool.stamp({
    @Default('') String name,
    @Default('') String displayIcon,
    @Default(PackAssetLocation()) PackAssetLocation component,
  }) = StampTool;

  factory Tool.presentation({
    @Default('') String name,
    @Default('') String displayIcon,
  }) = PresentationTool;

  factory Tool.spacer({
    @Default('') String name,
    @Default('') String displayIcon,
    @Default(Axis2D.horizontal) Axis2D axis,
  }) = SpacerTool;

  factory Tool.fullSceen({
    @Default('') String name,
    @Default('') String displayIcon,
  }) = FullScreenTool;

  factory Tool.asset({
    @Default('') String name,
    @Default('') String displayIcon,
    @Default(ImportType.document) ImportType importType,
  }) = AssetTool;

  factory Tool.texture({
    @Default('') String name,
    @Default('') String displayIcon,
    @Default(true) bool zoomDependent,
    @Default(0) double constrainedWidth,
    @Default(0) double constrainedHeight,
    @Default(0) double constrainedAspectRatio,
    @Default(SurfaceTexture.pattern()) SurfaceTexture texture,
  }) = TextureTool;

  factory Tool.fromJson(Map<String, dynamic> json) => _$ToolFromJson(json);
}
