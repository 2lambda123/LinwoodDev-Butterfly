part of '../selection.dart';

class PainterSelection<T extends Painter> extends Selection<T> {
  PainterSelection(super.selected);

  factory PainterSelection.from(T selected) {
    if (selected is AreaPainter) {
      return AreaPainterSelection([selected]) as PainterSelection<T>;
    }
    if (selected is EraserPainter) {
      return EraserPainterSelection([selected]) as PainterSelection<T>;
    }
    if (selected is LabelPainter) {
      return LabelPainterSelection([selected]) as PainterSelection<T>;
    }
    if (selected is LayerPainter) {
      return LayerPainterSelection([selected]) as PainterSelection<T>;
    }
    if (selected is PathEraserPainter) {
      return PathEraserPainterSelection([selected]) as PainterSelection<T>;
    }
    if (selected is PenPainter) {
      return PenPainterSelection([selected]) as PainterSelection<T>;
    }
    if (selected is ShapePainter) {
      return ShapePainterSelection([selected]) as PainterSelection<T>;
    }
    return PainterSelection([selected]);
  }

  @override
  List<Widget> buildProperties(BuildContext context) {
    var initialName = selected.first.name;
    if (!selected.every((e) => e.name == initialName)) {
      initialName = '';
    }
    return [
      TextFormField(
          decoration: InputDecoration(
              filled: true, labelText: AppLocalizations.of(context)!.name),
          initialValue: initialName,
          onChanged: (value) => update(context,
              selected.map((e) => e.copyWith(name: value) as T).toList())),
    ];
  }

  @override
  void update(BuildContext context, List<T> selected) {
    final updatedElements = Map<T, T>.fromIterables(this.selected, selected);
    context.read<DocumentBloc>().add(PaintersChanged(updatedElements));
    super.update(context, selected);
  }

  @override
  bool get showDeleteButton => true;

  @override
  void onDelete(BuildContext context) {
    context.read<DocumentBloc>().add(PaintersRemoved(selected));
  }

  @override
  Selection insert(element) {
    if (element is Painter) {
      return PainterSelection([...selected, element]);
    }
    return super.insert(element);
  }

  @override
  String getLocalizedName(BuildContext context) =>
      AppLocalizations.of(context)!.painter;

  @override
  IconData getIcon({bool filled = false}) =>
      filled ? PhosphorIcons.paintRollerFill : PhosphorIcons.paintRollerLight;
}
