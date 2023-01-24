part of '../selection.dart';

class EraserPainterSelection extends PainterSelection<EraserPainter> {
  EraserPainterSelection(super.selected);

  @override
  List<Widget> buildProperties(BuildContext context) {
    return [
      ...super.buildProperties(context),
      ExactSlider(
        header: Text(AppLocalizations.of(context)!.strokeWidth),
        value: selected.first.strokeWidth,
        min: 0,
        max: 70,
        defaultValue: 5,
        onChangeEnd: (value) => update(context,
            selected.map((e) => e.copyWith(strokeWidth: value)).toList()),
      ),
    ];
  }

  @override
  Selection insert(dynamic element) {
    if (element is EraserPainter) {
      return EraserPainterSelection([...selected, element]);
    }
    return super.insert(element);
  }

  @override
  String getLocalizedName(BuildContext context) =>
      AppLocalizations.of(context)!.eraser;

  @override
  IconData getIcon({bool filled = false}) =>
      filled ? PhosphorIcons.eraserFill : PhosphorIcons.eraserLight;

  @override
  List<String> get help => ['painters', 'eraser'];
}
