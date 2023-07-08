part of 'handler.dart';

const cornerSize = 32.0;
const visibleSize = cornerSize / 2;

class HandSelectionRenderer extends Renderer<Rect> {
  final ColorScheme scheme;
  final HandTransformMode? transformMode;
  final HandTransformCorner? transformCorner;
  HandSelectionRenderer(super.element, this.scheme,
      [this.transformMode, this.transformCorner]);

  @override
  void build(Canvas canvas, Size size, NoteData document, DocumentPage page,
      DocumentInfo info, CameraTransform transform,
      [ColorScheme? colorScheme, bool foreground = false]) {
    final paint = Paint()
      ..color = scheme.primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4 / transform.size
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..isAntiAlias = true
      ..filterQuality = FilterQuality.high
      ..colorFilter =
          ColorFilter.mode(Colors.grey.withOpacity(0.5), BlendMode.srcATop);
    canvas.drawRect(element, paint);
    if (transformMode == null) return;
    final color = transformMode == HandTransformMode.scaleProp
        ? scheme.secondary
        : scheme.error;
    final transformPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2 / transform.size
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..isAntiAlias = true
      ..filterQuality = FilterQuality.high
      ..colorFilter =
          ColorFilter.mode(Colors.grey.withOpacity(0.5), BlendMode.srcATop);
    final realSize = visibleSize / transform.size;
    if (element.width < 2 * realSize || element.height < 2 * realSize) return;
    final showCenter =
        element.width > 3 * realSize && element.height > 3 * realSize;
    HandTransformCorner.values
        .where((element) => !element.isCenter() || showCenter)
        .forEach((corner) {
      final position = corner.getFromRect(element);
      canvas.drawRect(
        Rect.fromCenter(
          center: position,
          width: realSize,
          height: realSize,
        ),
        transformPaint,
      );
      if (corner == transformCorner) {
        canvas.drawRect(
          Rect.fromCenter(
            center: position,
            width: realSize / 2,
            height: realSize / 2,
          ),
          paint,
        );
      }
    });
  }
}

enum HandTransformMode { scale, scaleProp }

enum HandTransformCorner {
  topLeft,
  topCenter,
  topRight,
  centerLeft,
  centerRight,
  bottomLeft,
  bottomCenter,
  bottomRight,
}

extension HandTransformCornerExtension on HandTransformCorner {
  bool isCenter() {
    switch (this) {
      case HandTransformCorner.topCenter:
      case HandTransformCorner.centerLeft:
      case HandTransformCorner.centerRight:
      case HandTransformCorner.bottomCenter:
        return true;
      default:
        return false;
    }
  }

  Offset getFromRect(Rect rect) {
    switch (this) {
      case HandTransformCorner.topLeft:
        return rect.topLeft;
      case HandTransformCorner.topCenter:
        return rect.topCenter;
      case HandTransformCorner.topRight:
        return rect.topRight;
      case HandTransformCorner.centerLeft:
        return rect.centerLeft;
      case HandTransformCorner.centerRight:
        return rect.centerRight;
      case HandTransformCorner.bottomLeft:
        return rect.bottomLeft;
      case HandTransformCorner.bottomCenter:
        return rect.bottomCenter;
      case HandTransformCorner.bottomRight:
        return rect.bottomRight;
    }
  }
}

class HandHandler extends Handler<HandPainter> {
  HandTransformMode _transformMode = HandTransformMode.scale;
  HandTransformCorner? _transformCorner;
  List<Renderer<PadElement>> _movingElements = [];
  List<Renderer<PadElement>> _selected = [];
  Offset? _currentMovePosition;
  Offset? _currentTransformOffset;
  Offset _contextMenuOffset = Offset.zero;
  Rect? _freeSelection;
  double _rotation = 0;
  Offset? _currentRotationTransform;

  HandHandler(super.data);

  void toggleScaleMode(DocumentBloc bloc) {
    _transformMode = _transformMode == HandTransformMode.scaleProp
        ? HandTransformMode.scale
        : HandTransformMode.scaleProp;
    bloc.refresh();
  }

  void rotate(DocumentBloc bloc, List<Renderer<PadElement>> next,
      [bool duplicate = false]) {
    submitTransformation(bloc);
    _movingElements = next;
    _selected = [];
    _currentMovePosition = null;
    _currentRotationTransform = Offset.zero;
    bloc.add(ElementsRemoved(next.map((e) => e.element).toList()));
    bloc.refresh();
  }

  @override
  void resetInput(DocumentBloc bloc) {
    _resetTransform();
    submitTransformation(bloc);
    _movingElements.clear();
    _selected.clear();
    _currentMovePosition = null;
    _freeSelection = null;
    bloc.refresh();
  }

  @override
  Future<bool> onRendererUpdated(
      DocumentPage page, Renderer old, Renderer updated) async {
    if (_movingElements.contains(old.element) &&
        updated is Renderer<PadElement>) {
      _movingElements.remove(old.element);
      _movingElements.add(updated);
    } else if (old is Renderer<PadElement> &&
        _selected.contains(old) &&
        updated is Renderer<PadElement>) {
      _selected.remove(old);
      _selected.add(updated);
    } else {
      return false;
    }
    return true;
  }

  Rect? getSelectionRect() {
    Rect? rect;
    for (final element in _selected) {
      final current = element.expandedRect;
      if (current != null) {
        rect = rect?.expandToInclude(current) ?? current;
      }
    }
    return rect;
  }

  @override
  List<Renderer> createForegrounds(CurrentIndexCubit currentIndexCubit,
      NoteData document, DocumentPage page, DocumentInfo info,
      [Area? currentArea]) {
    final foregrounds = <Renderer>[];
    if (_movingElements.isNotEmpty) {
      final renderers = _movingElements.map((e) {
        return e.transform(
              position: _currentMovePosition == null
                  ? null
                  : currentIndexCubit.getGridPosition(
                      (e.rect?.center ?? Offset.zero) + _currentMovePosition!,
                      page,
                      info),
              rotation: _currentRotationTransform == null
                  ? null
                  : _currentRotationTransform!.getRotation(e.rect!.center) /
                      pi *
                      180,
              relative: false,
            ) ??
            e;
      }).toList();
      foregrounds.addAll(renderers);
    }
    final selectionRect = getSelectionRect();
    final scheme = currentIndexCubit.getTheme(false).colorScheme;
    if (selectionRect != null) {
      foregrounds.add(HandSelectionRenderer(
          selectionRect, scheme, _transformMode, _transformCorner));
    }
    if (_freeSelection != null) {
      foregrounds.add(HandSelectionRenderer(_freeSelection!, scheme));
    }
    return foregrounds;
  }

  void move(DocumentBloc bloc, List<Renderer<PadElement>> next,
      [bool duplicate = false]) {
    submitTransformation(bloc);
    _movingElements = next;
    _selected = [];
    _currentMovePosition = Offset.zero;
    if (!duplicate) {
      bloc.add(ElementsRemoved(next.map((e) => e.element).toList()));
      bloc.refresh();
    }
  }

  void submitTransformation(DocumentBloc bloc) {
    if (_movingElements.isEmpty) return;
    final state = bloc.state;
    if (state is! DocumentLoadSuccess) return;
    final page = state.page;
    final cubit = state.currentIndexCubit;
    final current = _movingElements
        .map((e) {
          return e.transform(
                position: _currentMovePosition == null
                    ? null
                    : cubit.getGridPosition(
                        (e.rect?.center ?? Offset.zero) +
                            (_currentMovePosition ?? Offset.zero),
                        page,
                        state.info),
                rotation: _currentRotationTransform == null
                    ? null
                    : _currentRotationTransform!.getRotation(e.rect!.center) /
                        pi *
                        180,
                relative: false,
              ) ??
              e;
        })
        .map((e) => e.element)
        .toList();
    _currentMovePosition = null;
    _currentRotationTransform = null;
    _movingElements = [];
    _transformMode = HandTransformMode.scale;
    bloc.add(ElementsCreated(current));
    bloc.refresh();
  }

  @override
  void onTapUp(TapUpDetails details, EventContext context) async {
    _onSelectionAdd(context, details.localPosition, false);
  }

  @override
  void onLongPressEnd(LongPressEndDetails details, EventContext context) {
    _onSelectionAdd(context, details.localPosition, true);
  }

  HandTransformCorner? _getCornerHit(Offset position) {
    final selectionRect = getSelectionRect();

    if (selectionRect == null) return null;
    return HandTransformCorner.values.firstWhereOrNull((element) {
      final corner = element.getFromRect(selectionRect);
      return Rect.fromCenter(
              center: corner, width: cornerSize, height: cornerSize)
          .contains(position);
    });
  }

  Future<void> _onSelectionAdd(EventContext context, Offset localPosition,
      [bool forceAdd = false]) async {
    if (_movingElements.isNotEmpty) {
      return;
    }
    final transform = context.getCameraTransform();
    final globalPos = transform.localToGlobal(localPosition);
    final selectionRect = getSelectionRect();
    if (selectionRect?.contains(globalPos) ?? false) {
      toggleScaleMode(context.getDocumentBloc());
      return;
    }
    _resetTransform();
    final settings = context.getSettings();
    final radius = settings.selectSensitivity / transform.size;
    final hits = await rayCast(globalPos, context.getDocumentBloc(),
        context.getCameraTransform(), radius);
    if (hits.isEmpty) {
      if (!context.isCtrlPressed) {
        _selected.clear();
        _resetTransform();
        context.refresh();
      }
      return;
    }
    final hit = hits.first;
    if (context.isCtrlPressed || forceAdd) {
      if (_selected.contains(hit)) {
        _selected.remove(hit);
      } else {
        _selected.add(hit);
      }
    } else {
      _selected.clear();
      _selected.add(hit);
    }
    _resetTransform();
    context.refresh();
  }

  void _resetTransform() {
    _transformCorner = null;
    _transformMode = HandTransformMode.scale;
    _currentTransformOffset = null;
  }

  @override
  void onSecondaryTapUp(TapUpDetails details, EventContext context) async {
    _onSelectionContext(context, details.localPosition);
  }

  @override
  void onDoubleTapDown(TapDownDetails details, EventContext context) {
    _contextMenuOffset = details.localPosition;
  }

  @override
  void onDoubleTap(EventContext context) {
    _onSelectionContext(context, _contextMenuOffset);
  }

  Future<void> _onSelectionContext(
      EventContext context, Offset localPosition) async {
    if (_movingElements.isNotEmpty) {
      return;
    }
    final position = context.getCameraTransform().localToGlobal(localPosition);
    final hits = await rayCast(
        position, context.getDocumentBloc(), context.getCameraTransform(), 0.0);
    final hit = hits.firstOrNull;
    final rect = hit?.expandedRect;
    if ((rect != null && !(getSelectionRect()?.contains(position) ?? false)) &&
        !context.isCtrlPressed) {
      _selected.clear();
      if (hit != null) _selected.add(hit);
    }
    context.refresh();
    final buildContext = context.buildContext;
    if (_selected.isEmpty && buildContext.mounted) {
      return;
    }
    if (buildContext.mounted) {
      final result = await showContextMenu<bool>(
        context: buildContext,
        position: localPosition,
        builder: (ctx) => MultiBlocProvider(
          providers: context.getProviders(),
          child: RepositoryProvider.value(
            value: context.getImportService(),
            child: Actions(
              actions: context.getActions(),
              child:
                  ElementsDialog(position: localPosition, renderers: _selected),
            ),
          ),
        ),
      );
      if (result ?? false) {
        _selected.clear();
      }
    }
    context.refresh();
  }

  bool _ruler = false;

  @override
  bool onScaleStart(ScaleStartDetails details, EventContext context) {
    final viewport = context.getCameraViewport();
    _rotation = 0;
    if (viewport.tool.hitRuler(details.localFocalPoint, viewport.toSize())) {
      _ruler = true;
      return true;
    }
    final globalPos =
        context.getCameraTransform().localToGlobal(details.localFocalPoint);
    final bloc = context.getDocumentBloc();
    _setMove(bloc, globalPos, false);
    _setRotation(bloc, globalPos, false);
    _transformCorner = _getCornerHit(globalPos);
    context.refresh();
    return false;
  }

  @override
  bool canChange(PointerDownEvent event, EventContext context) =>
      event.kind == PointerDeviceKind.mouse &&
      event.buttons != kSecondaryMouseButton;

  @override
  void onScaleUpdate(ScaleUpdateDetails details, EventContext context) {
    final currentIndex = context.getCurrentIndex();
    final globalPos =
        context.getCameraTransform().localToGlobal(details.localFocalPoint);
    if (_ruler) {
      final state = context.getState();
      if (state == null) return;
      var toolState = context.getCameraViewport().tool.element;
      final currentRotation = details.rotation * 180 / pi * details.scale;
      final delta = currentRotation - _rotation;
      var angle = toolState.rulerAngle + delta;
      while (angle < 0) {
        angle += 360;
      }
      angle %= 360;
      toolState = toolState.copyWith(
        rulerPosition: toolState.rulerPosition +
            Point(
              details.focalPointDelta.dx,
              details.focalPointDelta.dy,
            ),
        rulerAngle: angle,
      );
      _rotation = currentRotation;
      context
          .getCurrentIndexCubit()
          .updateTool(state.data, state.page, state.assetService, toolState);
      return;
    }
    _currentTransformOffset = globalPos;
    if (_transformCorner != null) return;
    if (currentIndex.buttons != kSecondaryMouseButton &&
        details.pointerCount == 1) {
      if (details.scale == 1.0) {
        final topLeft = _freeSelection?.topLeft ?? globalPos;
        _freeSelection =
            Rect.fromLTRB(topLeft.dx, topLeft.dy, globalPos.dx, globalPos.dy);
        context.refresh();
      }
      return;
    }
    if (_movingElements.isNotEmpty) {
      var current = _currentMovePosition ?? Offset.zero;
      current += details.focalPointDelta / context.getCameraTransform().size;
      _currentMovePosition = current;
      context.refresh();
      return;
    }
    context
        .getTransformCubit()
        .move(details.focalPointDelta / context.getCameraTransform().size);
  }

  @override
  void onScaleEnd(ScaleEndDetails details, EventContext context) async {
    final freeSelection = _freeSelection?.normalized();
    if (_ruler) {
      _ruler = false;
      return;
    }
    if (_handleTransform(context.getDocumentBloc())) return;
    if (freeSelection != null && !freeSelection.isEmpty) {
      _freeSelection = null;
      if (!context.isCtrlPressed) {
        _selected.clear();
      }
      final hits = await rayCastRect(freeSelection, context.getDocumentBloc(),
          context.getCameraTransform());
      _selected.addAll(hits);
      context.refresh();
    }
  }

  bool _handleTransform(DocumentBloc bloc) {
    final selectionRect = getSelectionRect();
    final corner = _transformCorner;
    final offset = _currentTransformOffset;
    if (corner == null || offset == null || selectionRect == null) return false;
    final previous = corner.getFromRect(selectionRect);
    var delta = offset - previous;
    var scaleX = 1.0;
    var scaleY = 1.0;
    var position = Offset.zero;
    switch (corner) {
      case HandTransformCorner.topLeft:
        position = delta;
        scaleX += -delta.dx / selectionRect.size.width;
        scaleY += -delta.dy / selectionRect.size.height;
        break;
      case HandTransformCorner.topCenter:
        position = Offset(0, delta.dy);
        scaleY += -delta.dy / selectionRect.size.height;
        break;
      case HandTransformCorner.topRight:
        position = Offset(0, delta.dy);
        scaleX += delta.dx / selectionRect.size.width;
        scaleY += -delta.dy / selectionRect.size.height;
        break;
      case HandTransformCorner.centerLeft:
        position = Offset(delta.dx, 0);
        scaleX += -delta.dx / selectionRect.size.width;
        break;
      case HandTransformCorner.centerRight:
        scaleX += delta.dx / selectionRect.size.width;
        break;
      case HandTransformCorner.bottomLeft:
        position = Offset(delta.dx, 0);
        scaleX += -delta.dx / selectionRect.size.width;
        scaleY += delta.dy / selectionRect.size.height;
        break;
      case HandTransformCorner.bottomCenter:
        scaleY += delta.dy / selectionRect.size.height;
        break;
      case HandTransformCorner.bottomRight:
        scaleX += delta.dx / selectionRect.size.width;
        scaleY += delta.dy / selectionRect.size.height;
        break;
    }
    scaleX = scaleX.clamp(0.1, 10.0);
    scaleY = scaleY.clamp(0.1, 10.0);
    if (_transformMode == HandTransformMode.scaleProp) {
      final scale = max(scaleX, scaleY);
      scaleX = scale;
      scaleY = scale;
    }
    final updated = Map<Renderer<PadElement>, Renderer<PadElement>>.fromEntries(
      _selected.map(
        (e) {
          var offset = e.rect?.topLeft ?? Offset.zero;
          offset -= selectionRect.topLeft;
          offset = offset.scale(scaleX - 1, scaleY - 1);
          offset += position;
          return MapEntry<Renderer<PadElement>, Renderer<PadElement>>(
              e,
              e.transform(
                      position: offset,
                      scaleX: scaleX,
                      scaleY: scaleY,
                      relative: true) ??
                  e);
        },
      ),
    );
    _selected = updated.values.toList();
    _transformCorner = null;
    _currentTransformOffset = null;
    bloc.add(ElementsChanged(
      updated.map((key, value) => MapEntry(key.element, [value.element])),
    ));
    bloc.refresh();
    return true;
  }

  void _setRotation(DocumentBloc bloc, Offset current, [bool refresh = true]) {
    if (_currentRotationTransform == null) return;
    _currentRotationTransform = current;
    if (refresh) bloc.refresh();
  }

  void _setMove(DocumentBloc bloc, Offset current, [bool refresh = true]) {
    if (_currentMovePosition == null) return;
    _currentMovePosition =
        current - (_movingElements.first.rect?.center ?? Offset.zero);
    if (refresh) bloc.refresh();
  }

  @override
  void onPointerHover(PointerHoverEvent event, EventContext context) {
    final bloc = context.getDocumentBloc();
    final globalPos =
        context.getCameraTransform().localToGlobal(event.localPosition);
    _setMove(bloc, globalPos);
    _setRotation(bloc, globalPos);
  }

  @override
  void onPointerUp(PointerUpEvent event, EventContext context) {
    if (_movingElements.isNotEmpty) {
      submitTransformation(context.getDocumentBloc());
    }
  }

  @override
  MouseCursor? get cursor {
    if (_currentMovePosition != null) return SystemMouseCursors.move;
    if (_currentRotationTransform != null) return SystemMouseCursors.grab;
    return null;
  }
}
