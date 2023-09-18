import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:butterfly/api/file_system/file_system.dart';
import 'package:butterfly/cubits/current_index.dart';
import 'package:butterfly/handlers/handler.dart';
import 'package:butterfly_api/butterfly_api.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:replay_bloc/replay_bloc.dart';

import '../cubits/settings.dart';
import '../cubits/transform.dart';
import '../embed/embedding.dart';
import '../models/defaults.dart';
import '../models/viewport.dart';
import '../renderers/renderer.dart';
import '../selections/selection.dart';
import '../services/asset.dart';
import '../services/network.dart';

part 'document_state.dart';

enum ConnectionStatus { none, server, client }

class DocumentBloc extends ReplayBloc<DocumentEvent, DocumentState> {
  DocumentBloc(
    CurrentIndexCubit currentIndexCubit,
    SettingsCubit settingsCubit,
    NoteData initial,
    AssetLocation location,
    List<Renderer<PadElement>> renderer, [
    AssetService? assetService,
    DocumentPage? page,
    String? pageName,
  ]) : super(DocumentLoadSuccess(
          initial,
          page: page,
          assetService: assetService,
          networkService: NetworkService(),
          currentIndexCubit: currentIndexCubit,
          location: location,
          settingsCubit: settingsCubit,
          pageName: pageName ?? initial.getPages().firstOrNull ?? 'default',
        )) {
    _init();
  }

  DocumentBloc.error(SettingsCubit settingsCubit, String message,
      [StackTrace? stackTrace])
      : super(DocumentLoadFailure(settingsCubit, message, stackTrace));

  DocumentBloc.placeholder(
    SettingsCubit settingsCubit,
  ) : super(DocumentLoadFailure(settingsCubit, ''));

  void _init() {
    (state as DocumentLoaded).networkService.setup(this);
    on<PageAdded>((event, emit) async {
      final current = state;
      if (current is! DocumentLoadSuccess) return;
      final (newData, pageName) = current.data.addPage(event.page, event.index);
      return _saveState(
        emit,
        current.copyWith(data: newData, pageName: pageName),
        null,
      );
    });
    on<PageChanged>((event, emit) async {
      final current = state;
      if (current is! DocumentLoadSuccess) return;
      final data = current.data.setPage(current.page, current.pageName);
      final page = current.data.getPage(event.pageName);
      if (page == null) return;
      current.currentIndexCubit
          .loadElements(current.data, current.assetService, page);
      refresh();
      return _saveState(
        emit,
        current.copyWith(
          page: page,
          data: data,
          pageName: event.pageName,
        ),
        null,
      );
    });
    on<PageReordered>((event, emit) async {
      final current = state;
      if (current is! DocumentLoadSuccess) return;
      final newData = current.data.reorderPage(event.page, event.newIndex);
      return _saveState(
        emit,
        current.copyWith(data: newData),
        null,
      );
    });
    on<PageRenamed>((event, emit) async {
      final current = state;
      if (current is! DocumentLoadSuccess) return;
      final newData = current.data.renamePage(event.oldName, event.newName);
      return _saveState(
        emit,
        current.copyWith(data: newData),
        null,
      );
    });
    on<PageRemoved>((event, emit) async {
      final current = state;
      if (current is! DocumentLoadSuccess) return;
      final newData = current.data.removePage(event.page);
      return _saveState(
        emit,
        current.copyWith(data: newData),
        null,
      );
    });
    on<ThumbnailCaptured>((event, emit) async {
      final current = state;
      if (current is! DocumentLoadSuccess) return;
      final newData = current.data.setThumbnail(event.data);
      return _saveState(
        emit,
        current.copyWith(data: newData),
        null,
      );
    });
    on<ElementsCreated>((event, emit) async {
      final current = state;
      if (current is! DocumentLoadSuccess) return;
      if (!(current.embedding?.editable ?? true)) return;
      var data = current.data;
      String importImage(String source, String fileExtension) {
        final uriData = Uri.tryParse(source)?.data;
        if (uriData == null) return source;
        final result = data.addImage(uriData.contentAsBytes(), fileExtension);
        data = result.$1;
        return result.$2;
      }

      final elements = event.elements.map((e) => e.maybeMap(
            image: (value) =>
                value.copyWith(source: importImage(value.source, 'png')),
            svg: (value) =>
                value.copyWith(source: importImage(value.source, 'svg')),
            orElse: () => e,
          ));
      final renderers = elements.map((e) => Renderer.fromInstance(e)).toList();
      if (renderers.isEmpty) return;
      if (current.currentIndexCubit
          .getHandler()
          .onRenderersCreated(current.page, renderers)) {
        refresh();
      }
      return _saveState(
          emit,
          current.copyWith(
              page: current.page.copyWith(
                  content: (List.from(current.page.content)
                    ..addAll(elements)))),
          renderers);
    }, transformer: sequential());
    on<ElementsChanged>((event, emit) async {
      final current = state;
      if (current is! DocumentLoadSuccess) return;
      if (!(current.embedding?.editable ?? true)) return;
      final renderers = <Renderer<PadElement>>[];
      var selection = current.currentIndexCubit.state.selection;
      Renderer<PadElement>? oldRenderer, newRenderer;
      final page = current.page;
      for (final renderer in current.renderers) {
        final index = page.content.indexOf(renderer.element);
        final updated = event.elements[index];
        if (updated != null) {
          for (final element in updated) {
            newRenderer = Renderer.fromInstance(element);
            await newRenderer.setup(
                current.data, current.assetService, current.page);
            oldRenderer = renderer;
            oldRenderer.dispose();
            renderers.add(newRenderer);
            var newSelection = selection?.remove(oldRenderer);
            if (newSelection != selection && selection != null) {
              if (newSelection == null) {
                newSelection = Selection.from(newRenderer);
              } else {
                newSelection.insert(newRenderer);
              }
              selection = newSelection;
            }
          }
        } else {
          renderers.add(renderer);
        }
      }
      current.currentIndexCubit.unbake(unbakedElements: renderers);
      if (oldRenderer == null || newRenderer == null) return;
      if (current.currentIndexCubit
          .getHandler()
          .onRendererUpdated(current.page, oldRenderer, newRenderer)) {
        refresh();
      }
      if (selection != null) {
        current.currentIndexCubit.changeSelection(selection);
      }
      final content = List.of(page.content);
      for (final updated in event.elements.entries) {
        content.removeAt(updated.key);
        content.insertAll(updated.key, updated.value);
      }
      await _saveState(
          emit,
          current.copyWith(
            page: page.copyWith(
              content: content,
            ),
          ),
          null);
    }, transformer: sequential());
    on<ElementsArranged>((event, emit) async {
      final current = state;
      if (current is! DocumentLoadSuccess) return;
      final content = List<PadElement>.from(current.page.content);
      final renderers = List<Renderer<PadElement>>.from(current.renderers);
      final transform = current.transformCubit.state;
      for (final index in event.elements) {
        final element = content.removeAt(index);
        var newIndex = index;
        var newRendererIndex =
            renderers.indexWhere((e) => e.element == element);
        final renderer =
            newRendererIndex >= 0 ? renderers.removeAt(newRendererIndex) : null;
        if (event.arrangement == Arrangement.front) {
          newIndex = content.length - 1;
          newRendererIndex = renderers.length - 1;
        } else if (event.arrangement == Arrangement.back) {
          newIndex = 0;
          newRendererIndex = 0;
        } else {
          final rect = renderer?.rect;
          if (rect != null) {
            final hits = (await rayCastRect(rect, this, transform))
                .map((e) => e.element)
                .toList();
            final hitIndex = hits.indexOf(renderer!.element);
            if (hitIndex != -1) {
              if (event.arrangement == Arrangement.backward && hitIndex != 0) {
                newIndex = content.indexOf(hits[hitIndex - 1]);
              } else if (event.arrangement == Arrangement.forward &&
                  hitIndex != hits.length - 1) {
                newIndex = content.indexOf(hits[hitIndex + 1]) + 1;
              }
              if (newIndex >= 0) {
                final element =
                    newIndex < content.length ? content[newIndex] : null;
                newRendererIndex = element == null
                    ? renderers.length
                    : renderers.indexWhere((e) => e.element == element);
              }
            }
          }
        }
        if (newIndex >= 0) {
          content.insert(newIndex, element);
        } else {
          content.add(element);
        }
        if (renderer != null) {
          if (newRendererIndex >= 0) {
            renderers.insert(newRendererIndex, renderer);
          } else {
            renderers.add(renderer);
          }
        }
      }
      current.currentIndexCubit.unbake(
        unbakedElements: renderers,
      );
      final newPage = current.page.copyWith(content: content);
      return _saveState(
          emit,
          current.copyWith(
            page: newPage,
          ),
          null);
    });
    on<ElementsRemoved>((event, emit) async {
      final current = state;
      if (current is! DocumentLoadSuccess) return;
      if (!(current.embedding?.editable ?? true)) return;
      if (event.elements.isEmpty) return;
      final page = current.page;
      final renderers = current.renderers;
      final newContent = page.content
          .whereIndexed((index, element) => !event.elements.contains(index))
          .toList();
      current.currentIndexCubit.unbake(
        unbakedElements: renderers.where((renderer) {
          if (newContent.contains(renderer.element)) return true;
          renderer.dispose();
          return false;
        }).toList(),
      );
      current.currentIndexCubit.removeSelection(event.elements);
      final newPage = page.copyWith(content: newContent);
      // Remove unused assets
      final unusedAssets = <String>{};
      event.elements.whereType<SourcedElement>().forEach((element) {
        final uri = Uri.tryParse(element.source);
        if (uri?.scheme == '' && !newPage.usesSource(element.source)) {
          unusedAssets.add(element.source);
        }
      });
      final data = current.data.removeAssets(unusedAssets.toList());
      await _saveState(emit, current.copyWith(page: newPage, data: data), null);
    }, transformer: sequential());
    on<DocumentDescriptionChanged>((event, emit) async {
      final current = state;
      if (current is! DocumentLoadSuccess) return;
      if (!(current.embedding?.editable ?? true)) return;
      return _saveState(
        emit,
        current.copyWith(
          metadata: current.metadata.copyWith(
            name: event.name ?? current.metadata.name,
            description: event.description ?? current.metadata.description,
          ),
        ),
      );
    });
    on<ToolCreated>((event, emit) async {
      final current = state;
      if (current is! DocumentLoadSuccess) return;
      if (!(current.embedding?.editable ?? true)) return;
      return _saveState(
              emit,
              current.copyWith(
                  info: current.info.copyWith(
                      tools: List.from(current.info.tools)..add(event.tool))))
          .then((value) {
        current.currentIndexCubit
            .changeTool(this, current.info.tools.length, null, true);
      });
    });
    on<ToolsChanged>((event, emit) async {
      final current = state;
      if (current is! DocumentLoadSuccess) return;
      if (!(current.embedding?.editable ?? true)) return;
      final oldTools = current.info.tools;
      var selection = current.currentIndexCubit.state.selection;
      await _saveState(
          emit,
          current.copyWith(
              info: current.info.copyWith(
                  tools: List<Tool>.from(current.info.tools).mapIndexed((i, e) {
            final updated = event.tools[i];
            if (updated != null) {
              var newSelection = selection?.remove(e);
              if (newSelection != selection && selection != null) {
                if (newSelection == null) {
                  newSelection = Selection.from(updated);
                } else {
                  newSelection.insert(updated);
                }
                selection = newSelection;
              }
              return updated;
            } else {
              return e;
            }
          }).toList())));
      final updatedCurrent = event.tools.entries.firstWhereOrNull((element) =>
          oldTools[element.key] ==
          current.currentIndexCubit.state.handler.data);
      if (updatedCurrent != null) {
        current.currentIndexCubit.updateTool(this, updatedCurrent.value);
      }
      final updatedTempCurrent = event.tools.entries.firstWhereOrNull(
          (element) =>
              oldTools[element.key] ==
              current.currentIndexCubit.state.temporaryHandler?.data);
      if (updatedTempCurrent != null) {
        current.currentIndexCubit
            .updateTemporaryTool(this, updatedTempCurrent.value);
      }
      if (selection != null) {
        current.currentIndexCubit.changeSelection(selection);
      }
    });
    on<ToolsRemoved>((event, emit) async {
      final current = state;
      if (current is! DocumentLoadSuccess) return;
      if (!(current.embedding?.editable ?? true)) return;
      final cubit = current.currentIndexCubit;
      return _saveState(
              emit,
              current.copyWith(
                  info: current.info.copyWith(
                      tools: current.info.tools
                          .whereIndexed(
                              (index, _) => !event.tools.contains(index))
                          .toList())))
          .then((value) {
        cubit.updateIndex(this);
      });
    });
    on<ToolReordered>((event, emit) async {
      final current = state;
      if (current is! DocumentLoadSuccess) return;
      if (!(current.embedding?.editable ?? true)) return;
      var tools = List<Tool>.from(current.info.tools);
      var oldIndex = event.oldIndex;
      var newIndex = event.newIndex;
      if (oldIndex < newIndex) {
        newIndex -= 1;
      }
      final item = tools.removeAt(oldIndex);
      tools.insert(newIndex, item);
      final cubit = current.currentIndexCubit;
      var nextCurrentIndex = cubit.state.index;
      if (nextCurrentIndex != null) {
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
      }
      return _saveState(
          emit,
          current.copyWith(
            info: current.info.copyWith(tools: tools),
          ));
    });
    on<DocumentBackgroundsChanged>((event, emit) async {
      final current = state;
      if (current is! DocumentLoadSuccess) return;
      if (!(current.embedding?.editable ?? true)) return;
      final List<Renderer<Background>> backgrounds =
          event.backgrounds.map(Renderer.fromInstance).toList();
      await Future.wait(backgrounds.map((e) async =>
          e.setup(current.data, current.assetService, current.page)));
      await _saveState(
          emit,
          current.copyWith(
              page: current.page.copyWith(
            backgrounds: event.backgrounds,
          )));
      current.currentIndexCubit.unbake(backgrounds: backgrounds);
    });
    on<WaypointCreated>((event, emit) async {
      final current = state;
      if (current is! DocumentLoadSuccess) return;
      if (!(current.embedding?.editable ?? true)) return;
      return _saveState(
          emit,
          current.copyWith(
              page: current.page.copyWith(
                  waypoints: List<Waypoint>.from(current.page.waypoints)
                    ..add(event.waypoint))));
    });
    on<WaypointRenamed>((event, emit) async {
      final current = state;
      if (current is! DocumentLoadSuccess) return;
      if (!(current.embedding?.editable ?? true)) return;
      return _saveState(
          emit,
          current.copyWith(
              page: current.page.copyWith(
                  waypoints: List<Waypoint>.from(current.page.waypoints)
                    ..[event.index] = current.page.waypoints[event.index]
                        .copyWith(name: event.name))));
    });
    on<WaypointRemoved>((event, emit) async {
      final current = state;
      if (current is! DocumentLoadSuccess) return;
      if (!(current.embedding?.editable ?? true)) return;
      return _saveState(
          emit,
          current.copyWith(
              page: current.page.copyWith(
                  waypoints: List<Waypoint>.from(current.page.waypoints)
                    ..removeAt(event.index))));
    });

    on<LayerRenamed>((event, emit) async {
      final current = state;
      if (current is! DocumentLoadSuccess) return;
      if (!(current.embedding?.editable ?? true)) return;
      final content = List<PadElement>.from(current.page.content)
          .map((e) =>
              e.layer == event.oldName ? e.copyWith(layer: event.newName) : e)
          .toList();
      final renderer = content.map((e) => Renderer.fromInstance(e)).toList();
      await Future.wait(renderer.map((e) async =>
          await e.setup(current.data, current.assetService, current.page)));
      await _saveState(
          emit,
          current.copyWith(
              page: current.page.copyWith(content: content),
              currentLayer: current.currentLayer == event.oldName
                  ? event.newName
                  : current.currentLayer),
          null);
      current.currentIndexCubit.unbake(unbakedElements: renderer);
    });

    on<LayerRemoved>((event, emit) async {
      final current = state;
      if (current is! DocumentLoadSuccess) return;
      if (!(current.embedding?.editable ?? true)) return;
      final renderers = await Future.wait(
          List<Renderer<PadElement>>.from(current.renderers).map((e) async {
        if (e.element.layer == event.name) {
          var renderer = Renderer.fromInstance(e.element.copyWith(layer: ''));
          await renderer.setup(
              current.data, current.assetService, current.page);
          return renderer;
        }
        return e;
      }));
      final content = <PadElement>[];
      for (var element in current.page.content) {
        if (element.layer == event.name) {
          content.add(element.copyWith(layer: ''));
        } else {
          content.add(element);
        }
      }
      await _saveState(
          emit,
          current.copyWith(page: current.page.copyWith(content: content)),
          null);
      current.currentIndexCubit.unbake(unbakedElements: renderers);
    });

    on<LayerElementsRemoved>((event, emit) async {
      final current = state;
      if (current is! DocumentLoadSuccess) return;
      if (!(current.embedding?.editable ?? true)) return;
      final renderers = current.renderers
          .where((e) => e.element.layer != event.name)
          .toList();
      await _saveState(
          emit,
          current.copyWith(
            page: current.page.copyWith(
              content: List<PadElement>.from(current.page.content)
                  .where((e) => e.layer != event.name)
                  .toList(),
            ),
          ),
          null);
      current.currentIndexCubit.unbake(unbakedElements: renderers);
    });

    on<LayerVisibilityChanged>((event, emit) async {
      final current = state;
      if (current is! DocumentLoadSuccess) return;
      var invisibleLayers = List<String>.from(current.invisibleLayers);
      var isVisible = current.isLayerVisible(event.name);
      if (isVisible) {
        invisibleLayers.add(event.name);
      } else {
        invisibleLayers.remove(event.name);
      }
      return _saveState(
          emit, current.copyWith(invisibleLayers: invisibleLayers), null);
    });

    on<CurrentLayerChanged>((event, emit) async {
      final current = state;
      if (current is! DocumentLoadSuccess) return;
      if (!(current.embedding?.editable ?? true)) return;
      return _saveState(
          emit,
          current.copyWith(
            currentLayer: event.name,
          ));
    });

    on<ElementsLayerChanged>((event, emit) async {
      final current = state;
      if (current is! DocumentLoadSuccess) return;
      if (!(current.embedding?.editable ?? true)) return;
      var content = List<PadElement>.from(current.page.content);
      for (var element in event.elements) {
        content[element] = content[element].copyWith(layer: event.layer);
      }
      final renderer = content.map((e) => Renderer.fromInstance(e)).toList();
      await Future.wait(renderer.map((e) async =>
          await e.setup(current.data, current.assetService, current.page)));
      await _saveState(
          emit,
          current.copyWith(
            page: current.page.copyWith(
              content: content,
            ),
          ),
          null);
      current.currentIndexCubit.unbake(unbakedElements: renderer);
    });
    on<TemplateCreated>((event, emit) async {
      final current = state;
      if (current is! DocumentLoadSuccess) return;
      final data = current.saveData();
      final render = await current.currentIndexCubit.render(
          current.data, current.page, current.info,
          width: kThumbnailWidth.toDouble(),
          height: kThumbnailHeight.toDouble());
      final thumbnail = render?.buffer.asUint8List();
      final settings = current.settingsCubit.state;
      final remote = settings.getRemote(event.remote);
      TemplateFileSystem.fromPlatform(remote: remote)
          .createTemplate(data.createTemplate(
        thumbnail: thumbnail,
      ));

      if (event.deleteDocument) {
        current.currentIndexCubit.setSaveState(
            location:
                AssetLocation(remote: remote?.identifier ?? '', path: ''));
      }
    });
    on<DocumentPathChanged>((event, emit) {
      final current = state;
      if (current is! DocumentLoadSuccess) return;
      if (!(current.embedding?.editable ?? true)) return;
      current.currentIndexCubit.setSaveState(
          location:
              AssetLocation(remote: current.location.remote, path: event.path));
    });
    on<AreasCreated>((event, emit) async {
      final current = state;
      if (current is! DocumentLoadSuccess) return;
      final currentDocument = current.page.copyWith(
          areas: List<Area>.from(current.page.areas)..addAll(event.areas));
      _saveState(emit, current.copyWith(page: currentDocument));
      for (var element in current.renderers) {
        final needRepaint = await Future.wait(event.areas.map<Future<bool>>(
            (area) async => await element.onAreaUpdate(
                current.data, currentDocument, area)));
        if (needRepaint.any((element) => element)) {
          _repaint(emit);
        }
      }
    });
    on<AreasRemoved>((event, emit) async {
      final current = state;
      if (current is! DocumentLoadSuccess) return;
      if (!(current.embedding?.editable ?? true)) return;
      final areas = List<Area>.from(current.page.areas)
        ..removeWhere((e) => event.areas.contains(e.name));
      final currentDocument = current.page.copyWith(areas: areas);
      for (var element in current.renderers) {
        if (areas.contains(element.area) &&
            await element.onAreaUpdate(current.data, currentDocument, null)) {
          _repaint(emit);
        }
      }
      _saveState(emit, current.copyWith(page: currentDocument));
    });
    on<AreaChanged>((event, emit) async {
      final current = state;
      if (current is! DocumentLoadSuccess) return;
      if (!(current.embedding?.editable ?? true)) return;
      final areas = current.page.areas.map((e) {
        if (e.name == event.name) {
          return event.area;
        }
        return e;
      }).toList();
      final currentDocument = current.page.copyWith(areas: areas);
      emit(current.copyWith(page: currentDocument));
      for (var element in current.renderers) {
        if (element.area?.name == event.name) {
          if (await element.onAreaUpdate(
              current.data, currentDocument, event.area)) {
            _repaint(emit);
          }
        }
      }
    });
    on<ExportPresetCreated>((event, emit) {
      final current = state;
      if (current is! DocumentLoadSuccess) return;
      if (current.info.getExportPreset(event.name) != null) return;
      final preset = ExportPreset(name: event.name, areas: event.areas);
      var currentInfo = current.info;
      currentInfo = currentInfo.copyWith(
          exportPresets: List<ExportPreset>.from(currentInfo.exportPresets)
            ..add(preset));
      _saveState(emit, current.copyWith(info: currentInfo));
    });
    on<ExportPresetUpdated>((event, emit) {
      final current = state;
      if (current is! DocumentLoadSuccess) return;
      var currentInfo = current.info;
      final presets = currentInfo.exportPresets.map((e) {
        if (e.name == event.name) {
          return e.copyWith(areas: event.areas);
        }
        return e;
      }).toList();
      currentInfo = currentInfo.copyWith(exportPresets: presets);
      _saveState(emit, current.copyWith(info: currentInfo));
    });
    on<ExportPresetRemoved>((event, emit) {
      final current = state;
      if (current is! DocumentLoadSuccess) return;
      var currentInfo = current.info;
      currentInfo = currentInfo.copyWith(
          exportPresets: currentInfo.exportPresets
              .where((element) => element.name != event.name)
              .toList());
      _saveState(emit, current.copyWith(info: currentInfo));
    });
    on<CurrentAreaChanged>((event, emit) {
      final current = state;
      if (current is! DocumentLoadSuccess) return;
      if (!(current.embedding?.editable ?? true)) return;
      emit(current.copyWith(currentAreaName: event.name));
      current.bake();
    });
    on<PackAdded>((event, emit) {
      final current = state;
      if (current is! DocumentLoadSuccess) return;
      if (!(current.embedding?.editable ?? true)) return;
      var name = event.pack.name ?? '';
      var i = 1;
      while (current.data.getPack(name) != null) {
        name = '${event.pack.name} ($i)';
        i++;
      }
      final pack = event.pack.setName(name);
      _saveState(
        emit,
        current.copyWith(data: current.data.setPack(pack)),
      );
    });
    on<PackUpdated>((event, emit) {
      final current = state;
      if (current is! DocumentLoadSuccess) return;
      if (!(current.embedding?.editable ?? true)) return;
      _saveState(
        emit,
        current.copyWith(data: current.data.setPack(event.pack)),
      );
    });
    on<PackRemoved>((event, emit) {
      final current = state;
      if (current is! DocumentLoadSuccess) return;
      if (!(current.embedding?.editable ?? true)) return;
      _saveState(
        emit,
        current.copyWith(data: current.data.removePack(event.name)),
      );
    });
    on<AnimationAdded>((event, emit) {
      final current = state;
      if (current is! DocumentLoadSuccess) return;
      if (!(current.embedding?.editable ?? true)) return;
      if (current.page.getAnimation(event.animation.name) != null) return;
      final currentDocument = current.page.copyWith(
          animations: List<AnimationTrack>.from(current.page.animations)
            ..add(event.animation));
      _saveState(emit, current.copyWith(page: currentDocument));
    });
    on<AnimationUpdated>((event, emit) {
      final current = state;
      if (current is! DocumentLoadSuccess) return;
      if (!(current.embedding?.editable ?? true)) return;
      final currentDocument = current.page.copyWith(
          animations: current.page.animations.map((e) {
        if (e.name == event.animation.name) {
          return event.animation;
        }
        return e;
      }).toList());
      _saveState(emit, current.copyWith(page: currentDocument));
    });
    on<AnimationRemoved>((event, emit) {
      final current = state;
      if (current is! DocumentLoadSuccess) return;
      if (!(current.embedding?.editable ?? true)) return;
      final currentDocument = current.page.copyWith(
          animations: current.page.animations
              .where((element) => element.name != event.name)
              .toList());
      _saveState(emit, current.copyWith(page: currentDocument));
    });
    on<DocumentSaved>((event, emit) async {
      final current = state;
      if (current is! DocumentLoadSuccess) return;
      if (!(current.embedding?.editable ?? true)) return;
      current.currentIndexCubit
          .setSaveState(saved: SaveState.saved, location: event.location);
    });
    on<PresentationModeEntered>((event, emit) {
      final current = state;
      if (current is! DocumentLoadSuccess) return;
      current.currentIndexCubit.fetchHandler<PresentationHandler>()?.stop(this);
      emit(DocumentPresentationState(
        this,
        current,
        event.track,
        event.fullScreen,
        networkService: current.networkService,
        assetService: current.assetService,
        pageName: current.pageName,
        page: current.page,
        metadata: current.metadata,
      ));
    });
    on<PresentationModeExited>((event, emit) {
      final current = state;
      if (current is! DocumentPresentationState) return;
      current.handler.dispose(this);
      emit(current.oldState);
      current.settingsCubit.setFullScreen(current.fullScreen);
    });
    on<PresentationTick>((event, emit) {
      final current = state;
      if (current is! DocumentPresentationState) return;
      emit(current.copyWith(frame: event.tick));
    });
  }

  Future<void> _saveState(Emitter<DocumentState> emit,
      [DocumentLoadSuccess? current,
      List<Renderer<PadElement>>? unbakedElements = const []]) async {
    if (state is! DocumentLoadSuccess) return;
    current ??= state as DocumentLoadSuccess;
    final cameraViewport = current.cameraViewport;
    var elements = cameraViewport.unbakedElements;
    if (unbakedElements != null) {
      for (var renderer in unbakedElements) {
        await renderer.setup(current.data, current.assetService, current.page);
      }
      elements = List<Renderer<PadElement>>.from(elements)
        ..addAll(unbakedElements);
    }
    emit(current);

    if (unbakedElements == null) {
      current.currentIndexCubit.unbake(
          unbakedElements: List<Renderer<PadElement>>.from(elements)
            ..addAll(cameraViewport.bakedElements));
    } else {
      current.currentIndexCubit.withUnbaked(elements);
    }

    current.currentIndexCubit.setSaveState(saved: SaveState.unsaved);
    if (current.embedding != null) {
      return;
    }
    AssetLocation? path = current.location;
    if (current.hasAutosave()) {
      current.currentIndexCubit.setSaveState(saved: SaveState.saving);
      path = await current.save();
      current.currentIndexCubit
          .setSaveState(saved: SaveState.saved, location: path);
    }
  }

  void _repaint(Emitter<DocumentState> emit) {
    final current = state;
    if (current is! DocumentLoadSuccess) return;
    current.currentIndexCubit.unbake();
  }

  void refresh() {
    final current = state;
    if (current is! DocumentLoadSuccess) return;
    current.currentIndexCubit.refresh(
        current.data, current.assetService, current.page, current.info);
  }

  Future<void> bake(
      {Size? viewportSize, double? pixelRatio, bool reset = false}) async {
    final current = state;
    if (current is! DocumentLoaded) return;
    return current.bake(
        viewportSize: viewportSize, pixelRatio: pixelRatio, reset: reset);
  }

  Future<void> load() async {
    final current = state;
    if (current is! DocumentLoaded) return;
    final currentIndexCubit = current.currentIndexCubit;
    final document = current.data;
    final page = current.page;
    final assetService = current.assetService;
    currentIndexCubit.setSaveState(saved: SaveState.saved);
    final tool = UtilitiesRenderer(const UtilitiesState());
    await tool.setup(document, assetService, page);
    currentIndexCubit.unbake(tool: tool);
    currentIndexCubit.loadElements(document, assetService, page);
    currentIndexCubit.init(this);
  }

  void dispose() {
    state.assetService?.dispose();
  }
}
