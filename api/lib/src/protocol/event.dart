import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:replay_bloc/replay_bloc.dart';

import '../../butterfly_models.dart';

part 'event.freezed.dart';
part 'event.g.dart';

enum Arrangement { forward, backward, front, back }

enum DocumentPermission { read, write, admin }

@freezed
class DocumentEvent extends ReplayEvent with _$DocumentEvent {
  const DocumentEvent._();

  const factory DocumentEvent.pageAdded(DocumentPage page, [int? index]) =
      PageAdded;

  const factory DocumentEvent.pageChanged(
    String pageName,
  ) = PageChanged;

  const factory DocumentEvent.pageReordered(String page, [int? newIndex]) =
      PageReordered;

  const factory DocumentEvent.pageRenamed(String oldName, String newName) =
      PageRenamed;

  const factory DocumentEvent.pageRemoved(String page) = PageRemoved;

  const factory DocumentEvent.thumbnailCaptured(
    @Uint8ListJsonConverter() Uint8List data,
  ) = ThumbnailCaptured;

  const factory DocumentEvent.viewChanged(ViewOption view) = ViewChanged;

  const factory DocumentEvent.utilitiesChanged(UtilitiesState state) =
      UtilitiesChanged;

  const factory DocumentEvent.elementsCreated(
    List<PadElement> elements,
  ) = ElementsCreated;

  const factory DocumentEvent.elementsChanged(
    Map<int, List<PadElement>> elements,
  ) = ElementsChanged;

  const factory DocumentEvent.elementsRemoved(
    List<int> elements,
  ) = ElementsRemoved;

  const factory DocumentEvent.elementsArranged(
    Arrangement arrangement,
    List<int> elements,
  ) = ElementsArranged;

  const factory DocumentEvent.documentDescriptionChanged({
    String? name,
    String? description,
  }) = DocumentDescriptionChanged;

  const factory DocumentEvent.documentPathChanged(String path) =
      DocumentPathChanged;

  const factory DocumentEvent.documentSaved([AssetLocation? location]) =
      DocumentSaved;

  const factory DocumentEvent.toolCreated(
    Tool tool,
  ) = ToolCreated;

  const factory DocumentEvent.toolsChanged(
    Map<int, Tool> tools,
  ) = ToolsChanged;

  const factory DocumentEvent.toolsRemoved(
    List<int> tools,
  ) = ToolsRemoved;

  const factory DocumentEvent.toolReordered(
    int oldIndex,
    int newIndex,
  ) = ToolReordered;

  const factory DocumentEvent.documentBackgroundsChanged(
    List<Background> backgrounds,
  ) = DocumentBackgroundsChanged;

  const factory DocumentEvent.waypointCreated(
    Waypoint waypoint,
  ) = WaypointCreated;

  const factory DocumentEvent.waypointRenamed(
    int index,
    String name,
  ) = WaypointRenamed;

  const factory DocumentEvent.waypointRemoved(
    int index,
  ) = WaypointRemoved;

  const factory DocumentEvent.layerRenamed(
    String oldName,
    String newName,
  ) = LayerRenamed;

  const factory DocumentEvent.layerRemoved(
    String name,
  ) = LayerRemoved;

  const factory DocumentEvent.layerElementsRemoved(
    String name,
  ) = LayerElementsRemoved;

  const factory DocumentEvent.layerVisibilityChanged(
    String name,
  ) = LayerVisibilityChanged;

  const factory DocumentEvent.currentLayerChanged(
    String name,
  ) = CurrentLayerChanged;

  const factory DocumentEvent.elementsLayerChanged(
    String layer,
    List<int> elements,
  ) = ElementsLayerChanged;

  const factory DocumentEvent.templateCreated(String directory,
      [String? remote, @Default(true) bool deleteDocument]) = TemplateCreated;

  const factory DocumentEvent.areasCreated(
    List<Area> areas,
  ) = AreasCreated;

  const factory DocumentEvent.areasRemoved(
    List<String> areas,
  ) = AreasRemoved;

  const factory DocumentEvent.areaChanged(
    String name,
    Area area,
  ) = AreaChanged;

  const factory DocumentEvent.currentAreaChanged(
    String name,
  ) = CurrentAreaChanged;

  const factory DocumentEvent.exportPresetCreated(String name,
      [@Default([]) List<AreaPreset> areas]) = ExportPresetCreated;

  const factory DocumentEvent.exportPresetUpdated(
    String name,
    List<AreaPreset> areas,
  ) = ExportPresetUpdated;

  const factory DocumentEvent.exportPresetRemoved(
    String name,
  ) = ExportPresetRemoved;

  const factory DocumentEvent.packAdded(
    NoteData pack,
  ) = PackAdded;

  const factory DocumentEvent.packUpdated(
    String name,
    NoteData pack,
  ) = PackUpdated;

  const factory DocumentEvent.packRemoved(
    String name,
  ) = PackRemoved;

  const factory DocumentEvent.animationAdded(
    AnimationTrack animation,
  ) = AnimationAdded;

  const factory DocumentEvent.animationUpdated(
    String name,
    AnimationTrack animation,
  ) = AnimationUpdated;

  const factory DocumentEvent.animationRemoved(
    String name,
  ) = AnimationRemoved;

  const factory DocumentEvent.presentationModeEntered(
    AnimationTrack track,
    bool fullScreen,
  ) = PresentationModeEntered;

  const factory DocumentEvent.presentationModeExited() = PresentationModeExited;

  const factory DocumentEvent.presentationTick(int tick) = PresentationTick;

  factory DocumentEvent.fromJson(Map<String, dynamic> json) =>
      _$DocumentEventFromJson(json);

  bool shouldSync() => maybeMap(
        currentLayerChanged: (_) => false,
        templateCreated: (_) => false,
        documentSaved: (_) => false,
        documentPathChanged: (_) => false,
        currentAreaChanged: (_) => false,
        layerVisibilityChanged: (_) => false,
        utilitiesChanged: (_) => false,
        presentationModeEntered: (_) => false,
        presentationModeExited: (_) => false,
        presentationTick: (_) => false,
        orElse: () => true,
      );

  bool isAllowed(DocumentPermission permission) {
    if (permission == DocumentPermission.read) return false;
    if (!shouldSync()) return false;
    return maybeMap(
      orElse: () => true,
    );
  }
}
