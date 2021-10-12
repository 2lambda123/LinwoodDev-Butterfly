part of 'document_bloc.dart';

abstract class DocumentEvent extends ReplayEvent with EquatableMixin {
  const DocumentEvent();

  @override
  List<Object?> get props => [];
}

class LayerCreated extends DocumentEvent {
  final ElementLayer layer;

  const LayerCreated(this.layer);
  @override
  List<Object?> get props => [layer];
}

class LayersRemoved extends DocumentEvent {
  final List<ElementLayer> layers;

  const LayersRemoved(this.layers);
  @override
  List<Object?> get props => [layers];
}

class DocumentDescriptorChanged extends DocumentEvent {
  final String? name, description;

  const DocumentDescriptorChanged({this.name, this.description});
  @override
  List<Object?> get props => [name, description];
}

class ToolChanged extends DocumentEvent {
  final ToolType tool;

  const ToolChanged(this.tool);

  @override
  List<Object?> get props => [tool];
}

class CurrentPainterChanged extends DocumentEvent {
  final int painter;

  const CurrentPainterChanged(this.painter);

  @override
  List<Object?> get props => [painter];
}

class PainterCreated extends DocumentEvent {
  final Painter painter;

  const PainterCreated(this.painter);

  @override
  List<Object?> get props => [painter];
}

class PainterChanged extends DocumentEvent {
  final Painter painter;
  final int index;

  const PainterChanged(this.painter, this.index);

  @override
  List<Object?> get props => [painter, index];
}

class PainterRemoved extends DocumentEvent {
  final int index;

  const PainterRemoved(this.index);

  @override
  List<Object?> get props => [index];
}

class PainterReordered extends DocumentEvent {
  final int oldIndex, newIndex;

  const PainterReordered(this.oldIndex, this.newIndex);

  @override
  List<Object?> get props => [oldIndex, newIndex];
}

class DocumentBackgroundChanged extends DocumentEvent {
  final dynamic background;

  const DocumentBackgroundChanged(this.background);

  @override
  List<Object?> get props => [background];
}
