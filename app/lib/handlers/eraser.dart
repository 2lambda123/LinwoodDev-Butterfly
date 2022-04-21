part of 'handler.dart';

class EraserHandler extends Handler {
  final Map<int, EraserElement> elements = {};

  EraserHandler();

  @override
  List<Renderer> createForegrounds(AppDocument document, [Area? currentArea]) =>
      elements.values.map((e) => EraserRenderer(e)).toList();

  @override
  void onPointerUp(
      Size viewportSize, BuildContext context, PointerUpEvent event) {
    addPoint(context, event.pointer, event.localPosition, event.pressure,
        event.kind);
    submitElement(context, event.pointer);
  }

  void submitElement(BuildContext context, int index) {
    final bloc = context.read<DocumentBloc>();
    var element = elements.remove(index);
    if (element != null) bloc.add(ElementsCreated([element]));
    bloc.add(const IndexRefreshed());
  }

  void addPoint(BuildContext context, int pointer, Offset localPosition,
      double pressure, PointerDeviceKind kind) {
    final bloc = context.read<DocumentBloc>();
    final transform = context.read<TransformCubit>().state;
    final state = bloc.state as DocumentLoadSuccess;
    final painter = state.currentPainter as EraserPainter;
    final inputType = context.read<SettingsCubit>().state.inputType;
    if (!inputType.canCreate(pointer, elements.keys.firstOrNull, kind)) {
      return;
    }

    final element = elements[pointer] ??
        EraserElement(
          layer: state.currentLayer,
          property: painter.property
              .copyWith(strokeWidth: painter.property.strokeWidth),
        );

    elements[pointer] = element.copyWith(
        points: List<PathPoint>.from(element.points)
          ..add(PathPoint.fromOffset(
              transform.localToGlobal(localPosition), pressure)));
    bloc.add(const IndexRefreshed());
  }

  @override
  void onPointerDown(
          Size viewportSize, BuildContext context, PointerDownEvent event) =>
      addPoint(context, event.pointer, event.localPosition, event.pressure,
          event.kind);

  @override
  void onPointerMove(
          Size viewportSize, BuildContext context, PointerMoveEvent event) =>
      addPoint(context, event.pointer, event.localPosition, event.pressure,
          event.kind);
}
