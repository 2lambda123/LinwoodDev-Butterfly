import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:ui';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:butterfly/api/file_system.dart';
import 'package:butterfly/api/xml_helper.dart';
import 'package:butterfly/cubits/transform.dart';
import 'package:butterfly/models/background.dart';
import 'package:butterfly/cubits/current_index.dart';
import 'package:butterfly/models/document.dart';
import 'package:butterfly/models/painter.dart';
import 'package:butterfly/models/palette.dart';
import 'package:butterfly/models/viewport.dart';
import 'package:butterfly/models/waypoint.dart';
import 'package:butterfly/view_painter.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:replay_bloc/replay_bloc.dart';
import 'package:xml/xml.dart';

import '../cubits/settings.dart';
import '../embed/embedding.dart';
import '../models/area.dart';
import '../models/element.dart';
import '../models/property.dart';
import '../renderers/renderer.dart';

part 'document_event.dart';

part 'document_state.dart';

class DocumentBloc extends ReplayBloc<DocumentEvent, DocumentState> {
  DocumentBloc(
      SettingsCubit settingsCubit,
      CurrentIndexCubit currentIndexCubit,
      AppDocument initial,
      String? path,
      Renderer<Background> background,
      List<Renderer<PadElement>> renderer,
      [Embedding? embedding])
      : super(DocumentLoadSuccess(initial,
            path: path,
            settingsCubit: settingsCubit,
            currentIndexCubit: currentIndexCubit,
            embedding: embedding,
            cameraViewport: CameraViewport.unbaked(background, renderer))) {
    _init();
  }

  void _init() {
    on<DocumentUpdated>((event, emit) async {
      final current = state;
      if (current is DocumentLoadSuccess) {
        final renderers = event.document.content
            .map((e) => Renderer.fromInstance(e))
            .toList();
        Future.wait(renderers.map((r) async => await r.setup(event.document)));
        final background = Renderer.fromInstance(event.document.background);
        _saveDocument(
            current.copyWith(
                document: event.document,
                cameraViewport: CameraViewport.unbaked(background, renderers)),
            null);
        clearHistory();
      }
    });
    on<ElementsCreated>((event, emit) async {
      if (state is DocumentLoadSuccess) {
        final current = state as DocumentLoadSuccess;
        if (!(current.embedding?.editable ?? true)) return;
        if (event.elements.isEmpty) return;
        final renderers =
            event.elements.map((e) => Renderer.fromInstance(e)).toList();
        await Future.wait(
            renderers.map((e) async => await e.setup(current.document)));
        return _saveDocument(
            current.copyWith(
                document: current.document.copyWith(
                    content: (List.from(current.document.content)
                      ..addAll(event.elements)))),
            renderers);
      }
    });
    on<ElementsReplaced>((event, emit) async {
      if (state is DocumentLoadSuccess) {
        final current = state as DocumentLoadSuccess;
        if (!(current.embedding?.editable ?? true)) return;
        var renderers = List<Renderer<PadElement>>.from(current.renderers);
        event.replacedElements.forEach((index, element) {
          final current = element.map((e) => Renderer.fromInstance(e));
          if (index == null) {
            renderers.addAll(current);
          } else {
            renderers.removeAt(index);
            renderers.insertAll(index, current);
          }
        });
        return _saveDocument(
            current.copyWith(
              document: current.document
                  .copyWith(content: renderers.map((e) => e.element).toList()),
            ),
            null);
      }
    });
    on<ElementChanged>((event, emit) async {
      final current = state;
      if (current is DocumentLoadSuccess) {
        if (!(current.embedding?.editable ?? true)) return;
        final renderers = <Renderer<PadElement>>[];
        Renderer<PadElement>? oldRenderer, newRenderer;
        for (var renderer in current.renderers) {
          if (renderer.element == event.old) {
            newRenderer = Renderer.fromInstance(event.updated);
            await newRenderer.setup(current.document);
            oldRenderer = renderer;
            renderers.add(newRenderer);
          } else {
            renderers.add(renderer);
          }
        }
        final index = current.document.content.indexOf(event.old);
        if (index < 0) return;
        return _saveDocument(
                current.copyWith(
                    document: current.document.copyWith(
                        content: List.from(current.document.content)
                          ..[index] = event.updated),
                    cameraViewport: current.cameraViewport.unbake(renderers)),
                null)
            .then((value) async {
          if (oldRenderer == null || newRenderer == null) return;
          if (await current.currentIndexCubit
              .getHandler()
              .onRendererUpdated(current.document, oldRenderer, newRenderer)) {
            current.currentIndexCubit.refresh(this);
          }
        });
      }
    });
    on<ElementsRemoved>((event, emit) async {
      if (state is DocumentLoadSuccess) {
        final current = state as DocumentLoadSuccess;
        if (!(current.embedding?.editable ?? true)) return;
        if (event.elements.isEmpty ||
            !current.document.content
                .any((element) => event.elements.contains(element))) return;
        return _saveDocument(
            current.copyWith(
                cameraViewport: current.cameraViewport.unbake(
                  current.renderers
                      .where((element) => !event.elements.contains(
                            element.element,
                          ))
                      .toList(),
                ),
                document: current.document.copyWith(
                    content: List.from(current.document.content)
                      ..removeWhere(
                          (element) => event.elements.contains(element)))),
            null);
      }
    });
    on<DocumentDescriptorChanged>((event, emit) async {
      if (state is DocumentLoadSuccess) {
        final current = state as DocumentLoadSuccess;
        if (!(current.embedding?.editable ?? true)) return;
        return _saveDocument(current.copyWith(
            document: current.document.copyWith(
                name: event.name ?? current.document.name,
                description:
                    event.description ?? current.document.description)));
      }
    });

    on<DocumentPaletteChanged>((event, emit) async {
      if (state is DocumentLoadSuccess) {
        final current = state as DocumentLoadSuccess;
        if (!(current.embedding?.editable ?? true)) return;
        return _saveDocument(current.copyWith(
            document: current.document.copyWith(palettes: event.palette)));
      }
    });
    on<PainterCreated>((event, emit) async {
      final current = state;
      if (current is DocumentLoadSuccess) {
        if (!(current.embedding?.editable ?? true)) return;
        return _saveDocument(current.copyWith(
            document: current.document.copyWith(
                painters: List.from(current.document.painters)
                  ..add(event.painter))));
      }
    });
    on<PainterChanged>((event, emit) async {
      if (state is DocumentLoadSuccess) {
        final current = state as DocumentLoadSuccess;
        if (!(current.embedding?.editable ?? true)) return;
        return _saveDocument(current.copyWith(
            document: current.document.copyWith(
                painters: List.from(current.document.painters)
                  ..[event.index] = event.painter)));
      }
    });
    on<PainterRemoved>((event, emit) async {
      if (state is DocumentLoadSuccess) {
        final current = state as DocumentLoadSuccess;
        if (!(current.embedding?.editable ?? true)) return;
        final cubit = current.currentIndexCubit;
        return _saveDocument(current.copyWith(
                document: current.document.copyWith(
                    painters: List.from(current.document.painters)
                      ..removeAt(event.index))))
            .then((value) {
          final currentIndex = current.currentIndexCubit.state;
          if (currentIndex.index == event.index) {
            cubit.reset();
          } else if (currentIndex.index > event.index) {
            cubit.changeIndex(currentIndex.index - 1);
          } else {
            cubit.changeIndex(currentIndex.index);
          }
        });
      }
    });
    on<PainterReordered>((event, emit) async {
      if (state is DocumentLoadSuccess) {
        final current = state as DocumentLoadSuccess;
        if (!(current.embedding?.editable ?? true)) return;
        var painters = List<Painter>.from(current.document.painters);
        var oldIndex = event.oldIndex;
        var newIndex = event.newIndex;
        if (oldIndex < newIndex) {
          newIndex -= 1;
        }
        final item = painters.removeAt(oldIndex);
        painters.insert(newIndex, item);
        final cubit = current.currentIndexCubit;
        var nextCurrentIndex = cubit.state.index;
        if (nextCurrentIndex == oldIndex) {
          nextCurrentIndex = newIndex;
        } else if (nextCurrentIndex > oldIndex &&
            nextCurrentIndex <= newIndex) {
          nextCurrentIndex -= 1;
        } else if (nextCurrentIndex < oldIndex &&
            nextCurrentIndex >= newIndex) {
          nextCurrentIndex += 1;
        }
        cubit.changeIndex(nextCurrentIndex);
        return _saveDocument(current.copyWith(
          document: current.document.copyWith(painters: painters),
        ));
      }
    });
    on<DocumentBackgroundChanged>((event, emit) async {
      if (state is DocumentLoadSuccess) {
        final current = state as DocumentLoadSuccess;
        if (!(current.embedding?.editable ?? true)) return;
        final Renderer<Background> background =
            Renderer.fromInstance(event.background);
        await background.setup(current.document);
        return _saveDocument(current.copyWith(
            cameraViewport: current.cameraViewport.withBackground(background),
            document: current.document.copyWith(
              background: event.background,
            )));
      }
    });
    on<WaypointCreated>((event, emit) async {
      if (state is DocumentLoadSuccess) {
        final current = state as DocumentLoadSuccess;
        if (!(current.embedding?.editable ?? true)) return;
        return _saveDocument(current.copyWith(
            document: current.document.copyWith(
                waypoints: List<Waypoint>.from(current.document.waypoints)
                  ..add(event.waypoint))));
      }
    });
    on<WaypointRemoved>((event, emit) async {
      if (state is DocumentLoadSuccess) {
        final current = state as DocumentLoadSuccess;
        if (!(current.embedding?.editable ?? true)) return;
        return _saveDocument(current.copyWith(
            document: current.document.copyWith(
                waypoints: List<Waypoint>.from(current.document.waypoints)
                  ..removeAt(event.index))));
      }
    });
    on<HandPropertyChanged>((event, emit) async {
      if (state is DocumentLoadSuccess) {
        final current = state as DocumentLoadSuccess;
        if (!(current.embedding?.editable ?? true)) return;
        return _saveDocument(current.copyWith(
            document: current.document.copyWith(handProperty: event.property)));
      }
    });

    on<LayerRenamed>((event, emit) async {
      if (state is DocumentLoadSuccess) {
        final current = state as DocumentLoadSuccess;
        if (!(current.embedding?.editable ?? true)) return;
        return _saveDocument(current.copyWith(
            document: current.document.copyWith(
                content: List<PadElement>.from(current.document.content)
                    .map((e) => e.layer == event.oldName
                        ? e.copyWith(layer: event.newName)
                        : e)
                    .toList())));
      }
    });

    on<LayerRemoved>((event, emit) async {
      if (state is DocumentLoadSuccess) {
        final current = state as DocumentLoadSuccess;
        if (!(current.embedding?.editable ?? true)) return;
        var renderers = await Future.wait(
            List<Renderer<PadElement>>.from(current.renderers).map((e) async {
          if (e.element.layer == event.name) {
            var renderer = Renderer.fromInstance(e.element.copyWith(layer: ''));
            await renderer.setup(current.document);
            return renderer;
          }
          return e;
        }));
        return _saveDocument(
            current.copyWith(
                cameraViewport: current.cameraViewport.unbake(renderers),
                document: current.document.copyWith(
                    content: List<PadElement>.from(current.document.content)
                        .where((e) => e.layer == event.name)
                        .map((e) => e.copyWith(layer: ''))
                        .toList())),
            null);
      }
    });

    on<LayerElementsDeleted>((event, emit) async {
      if (state is DocumentLoadSuccess) {
        final current = state as DocumentLoadSuccess;
        if (!(current.embedding?.editable ?? true)) return;
        return _saveDocument(
            current.copyWith(
                document: current.document.copyWith(
                    content: List<PadElement>.from(current.document.content)
                        .where((e) => e.layer != event.name)
                        .toList())),
            null);
      }
    });

    on<LayerVisibilityChanged>((event, emit) async {
      if (state is DocumentLoadSuccess) {
        final current = state as DocumentLoadSuccess;
        var invisibleLayers = List<String>.from(current.invisibleLayers);
        var isVisible = current.isLayerVisible(event.name);
        if (isVisible) {
          invisibleLayers.add(event.name);
        } else {
          invisibleLayers.remove(event.name);
        }
        return _saveDocument(
            current.copyWith(
                cameraViewport: isVisible
                    ? current.cameraViewport.unbake(
                        List<Renderer<PadElement>>.from(current.renderers)
                            .where((e) => e.element.layer == event.name)
                            .toList())
                    : null,
                invisibleLayers: invisibleLayers),
            isVisible
                ? null
                : List<Renderer<PadElement>>.from(current.renderers)
              ?..addAll(current.document.content
                  .where((e) => e.layer == event.name)
                  .map((e) => Renderer.fromInstance(e))));
      }
    });

    on<CurrentLayerChanged>((event, emit) async {
      if (state is DocumentLoadSuccess) {
        final current = state as DocumentLoadSuccess;
        if (!(current.embedding?.editable ?? true)) return;
        return _saveDocument(current.copyWith(
          currentLayer: event.name,
        ));
      }
    });

    on<ElementsLayerChanged>((event, emit) async {
      if (state is DocumentLoadSuccess) {
        final current = state as DocumentLoadSuccess;
        if (!(current.embedding?.editable ?? true)) return;
        var content = List<PadElement>.from(current.document.content);
        for (var element in event.elements) {
          var i = current.document.content.indexOf(element);
          if (i != -1) {
            content[i] = element.copyWith(layer: event.layer);
          }
        }
        return _saveDocument(current.copyWith(
            document: current.document.copyWith(
          content: content,
        )));
      }
    });
    on<ImageBaked>((event, emit) async {
      var current = state;
      if (current is! DocumentLoadSuccess) return;
      if (event.viewportSize.height <= 0 || event.viewportSize.width <= 0) {
        return;
      }
      final eq = const ListEquality().equals;

      var renderers = current.renderers;
      var recorder = ui.PictureRecorder();
      var size = event.viewportSize;
      var canvas = ui.Canvas(recorder);
      var last = current.cameraViewport;
      var invisibleLayers = current.invisibleLayers;
      var reset = last.width != size.width.round() ||
          last.height != size.height.round() ||
          last.x != event.cameraTransform.position.dx ||
          last.y != event.cameraTransform.position.dy ||
          last.scale != event.cameraTransform.size;
      if (renderers.isEmpty && !reset) return;
      if (reset) {
        renderers = renderers
            .where(
                (element) => !invisibleLayers.contains(element.element.layer))
            .toList();
      }
      canvas.scale(event.pixelRatio);

      ViewPainter(
        current.document,
        transform: event.cameraTransform,
        cameraViewport: reset ? current.cameraViewport.unbake(renderers) : last,
        renderBackground: false,
        renderBaked: !reset,
      ).paint(canvas, event.viewportSize);

      var picture = recorder.endRecording();

      var newImage = await picture.toImage(
          (size.width * event.pixelRatio).ceil(),
          (size.height * event.pixelRatio).ceil());

      current = state as DocumentLoadSuccess;
      var currentElements = current.renderers;
      if (reset) {
        currentElements = renderers
            .where(
                (element) => !invisibleLayers.contains(element.element.layer))
            .toList();
      }
      if (!eq(renderers, currentElements)) return;
      if (last != current.cameraViewport) return;
      emit(current.copyWith(
          cameraViewport: current.cameraViewport.bake(
              height: size.height.round(),
              width: size.width.round(),
              scale: event.cameraTransform.size,
              x: event.cameraTransform.position.dx,
              y: event.cameraTransform.position.dy,
              image: newImage,
              bakedElements: renderers,
              unbakedElements: [])));
    }, transformer: restartable());
    on<ImageUnbaked>((event, emit) {
      final current = state;
      if (current is DocumentLoadSuccess) {
        emit(current.copyWith(
            cameraViewport: current.cameraViewport.unbake(current.renderers)));
      }
    });
    on<TemplateCreated>((event, emit) {
      final current = state;
      if (current is! DocumentLoadSuccess) return;
      TemplateFileSystem.fromPlatform().createTemplate(current.document);

      if (event.deleteDocument) {
        emit(current.copyWith(removePath: true));
      }
    });
    on<DocumentPathChanged>((event, emit) {
      final current = state;
      if (current is! DocumentLoadSuccess) return;
      if (!(current.embedding?.editable ?? true)) return;
      emit(current.copyWith(path: event.path));
    });
    on<AreaCreated>((event, emit) async {
      final current = state;
      if (current is! DocumentLoadSuccess) return;
      final currentDocument = current.document.copyWith(
          areas: List<Area>.from(current.document.areas)..add(event.area));
      emit(current.copyWith(document: currentDocument));
      for (var element in current.renderers) {
        if (await element.onAreaUpdate(currentDocument, event.area)) {
          _repaint();
        }
      }
    });
    on<AreaRemoved>((event, emit) async {
      final current = state;
      if (current is! DocumentLoadSuccess) return;
      if (!(current.embedding?.editable ?? true)) return;
      final areas = List<Area>.from(current.document.areas);
      final area = areas.removeAt(event.index);
      final currentDocument = current.document.copyWith(areas: areas);
      emit(current.copyWith(document: currentDocument));
      for (var element in current.renderers) {
        if (element.area == area &&
            await element.onAreaUpdate(currentDocument, null)) {
          _repaint();
        }
      }
    });
    on<AreaChanged>((event, emit) async {
      final current = state;
      if (current is! DocumentLoadSuccess) return;
      if (!(current.embedding?.editable ?? true)) return;
      final areas = List<Area>.from(current.document.areas);
      final area = areas[event.index];
      final currentDocument =
          current.document.copyWith(areas: areas..[event.index] = event.area);
      emit(current.copyWith(document: currentDocument));
      for (var element in current.renderers) {
        if (element.area == area) {
          if (await element.onAreaUpdate(currentDocument, event.area)) {
            _repaint();
          }
        }
      }
    });
    on<CurrentAreaChanged>((event, emit) {
      final current = state;
      if (current is! DocumentLoadSuccess) return;
      if (!(current.embedding?.editable ?? true)) return;
      emit(current.copyWith(currentAreaIndex: event.area));
    });
    on<DocumentSaved>((event, emit) async {
      final current = state;
      if (current is! DocumentLoadSuccess) return;
      if (!(current.embedding?.editable ?? true)) return;
      undo();
      emit(current.copyWith(saved: true));
    });
  }

  Future<void> _saveDocument(DocumentLoadSuccess current,
      [List<Renderer<PadElement>>? unbakedElements = const []]) async {
    var elements = current.cameraViewport.unbakedElements;
    if (unbakedElements != null) {
      for (var renderer in unbakedElements) {
        await renderer.setup(current.document);
      }
      elements = List<Renderer<PadElement>>.from(elements)
        ..addAll(unbakedElements);
    }
    var nextState = current.copyWith(
        saved: false,
        document: current.document.copyWith(updatedAt: DateTime.now()),
        cameraViewport: unbakedElements == null
            ? current.cameraViewport.unbake(elements)
            : current.cameraViewport.withUnbaked(elements));
    if (current.embedding != null) {
      emit(nextState);
      return;
    }
    emit(nextState);
    String? path = current.path;
    if (!kIsWeb) {
      path = await nextState.save();
      var currentState = state;
      if (currentState is! DocumentLoadSuccess) return;
      if (currentState.path == null && state is DocumentLoadSuccess) {
        emit(currentState.copyWith(path: path, saved: true));
        clearHistory();
      }
    }
  }

  @override
  bool shouldReplay(DocumentState state) {
    // Disable replay for state where only camera viewport has changed.
    final statement = state is DocumentLoadSuccess &&
        state.cameraViewport.unbakedElements.isNotEmpty;
    return statement;
  }

  void _repaint() {
    final current = state;
    if (current is! DocumentLoadSuccess) return;
    emit(current.copyWith(cameraViewport: current.cameraViewport.unbake()));
  }
}
