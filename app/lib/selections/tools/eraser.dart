part of '../selection.dart';

class EraserPainterSelection extends ToolSelection<EraserTool> {
  EraserPainterSelection(super.selected);

  @override
  List<Widget> buildProperties(BuildContext context) {
    return [
      ...super.buildProperties(context),
      ExactSlider(
        header: Text(AppLocalizations.of(context).strokeWidth),
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
    if (element is EraserTool) {
      return EraserPainterSelection([...selected, element]);
    }
    return super.insert(element);
  }
}
