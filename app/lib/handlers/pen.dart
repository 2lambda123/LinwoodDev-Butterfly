part of 'handler.dart';

class PenHandler extends Handler<PenTool> {
  final Map<int, PenElement> elements = {};

  final Map<int, Offset> lastPosition = {};

  PenHandler(super.data);

  @override
  List<Renderer> createForegrounds(CurrentIndexCubit currentIndexCubit,
          NoteData document, DocumentPage page, DocumentInfo info,
          [Area? currentArea]) =>
      elements.values
          .map((e) {
            if (e.points.length > 1) return PenRenderer(e);
            return null;
          })
          .whereType<Renderer>()
          .toList();

  @override
  void resetInput(DocumentBloc bloc) {
    elements.clear();
    lastPosition.clear();
  }

  @override
  void onPointerUp(PointerUpEvent event, EventContext context) {
    addPoint(context.buildContext, event.pointer, event.localPosition,
        _getPressure(event), event.kind,
        refresh: false);
    submitElement(context.viewportSize, context.buildContext, event.pointer);
  }

  bool _currentlyBaking = false;

  Future<void> submitElement(
      Size viewportSize, BuildContext context, int index) async {
    final bloc = context.read<DocumentBloc>();
    final element = elements.remove(index);
    if (element == null) return;
    lastPosition.remove(index);
    bloc.add(ElementsCreated([element]));
    if (_currentlyBaking) return;
    _currentlyBaking = true;
    await bloc.bake();
    _currentlyBaking = false;
    bloc.refresh();
  }

  void addPoint(BuildContext context, int pointer, Offset localPosition,
      double pressure, PointerDeviceKind kind,
      {bool refresh = true, bool shouldCreate = false}) {
    final bloc = context.read<DocumentBloc>();
    final currentIndexCubit = context.read<CurrentIndexCubit>();
    final viewport = currentIndexCubit.state.cameraViewport;
    final transform = context.read<TransformCubit>().state;
    final state = bloc.state as DocumentLoadSuccess;
    final settings = context.read<SettingsCubit>().state;
    final penOnlyInput = settings.penOnlyInput;
    localPosition =
        viewport.utilities.getPointerPosition(localPosition, currentIndexCubit);
    if (lastPosition[pointer] == localPosition) return;
    lastPosition[pointer] = localPosition;
    if (penOnlyInput && kind != PointerDeviceKind.stylus) {
      return;
    }
    double zoom = data.zoomDependent ? transform.size : 1;

    final createNew = !elements.containsKey(pointer);

    if (createNew && !shouldCreate) return;

    final element = elements[pointer] ??
        PenElement(
          zoom: transform.size,
          layer: state.currentLayer,
          property: data.property
              .copyWith(strokeWidth: data.property.strokeWidth / zoom),
        );
    elements[pointer] = element.copyWith(
        points: List<PathPoint>.from(element.points)
          ..add(PathPoint.fromPoint(
              transform.localToGlobal(localPosition).toPoint(),
              (createNew ? 0 : pressure) / zoom)));
    if (refresh) bloc.refresh();
  }

  @override
  void onPointerDown(PointerDownEvent event, EventContext context) {
    final currentIndex = context.getCurrentIndex();
    if (currentIndex.moveEnabled && event.kind != PointerDeviceKind.stylus) {
      elements.clear();
      context.refresh();
      return;
    }
    elements.remove(event.pointer);
    addPoint(context.buildContext, event.pointer, event.localPosition,
        _getPressure(event), event.kind,
        shouldCreate: true);
  }

  double _getPressure(PointerEvent event) =>
      event.kind == PointerDeviceKind.stylus
          ? (event.pressure - event.pressureMin) /
              (event.pressureMax - event.pressureMin)
          : 0.5;

  @override
  void onPointerMove(PointerMoveEvent event, EventContext context) => addPoint(
      context.buildContext,
      event.pointer,
      event.localPosition,
      _getPressure(event),
      event.kind);

  @override
  void onScaleStartAbort(ScaleStartDetails details, EventContext context) {
    elements.clear();
    context.refresh();
  }

  @override
  PreferredSizeWidget getToolbar(DocumentBloc bloc) => ColorToolbarView(
        color: data.property.color,
        onChanged: (value) {
          final state = bloc.state;
          if (state is! DocumentLoadSuccess) return;
          final index = state.info.tools.indexOf(data);
          bloc.add(ToolsChanged({
            index: data.copyWith(
                property: data.property.copyWith(
                    color: convertOldColor(value, data.property.color)))
          }));
        },
      );

  @override
  MouseCursor get cursor => SystemMouseCursors.precise;
}
