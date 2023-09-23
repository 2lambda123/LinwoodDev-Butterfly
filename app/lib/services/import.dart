import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:butterfly/api/file_system/file_system.dart';
import 'package:butterfly/bloc/document_bloc.dart';
import 'package:butterfly/dialogs/confirmation.dart';
import 'package:butterfly/helpers/color_helper.dart';
import 'package:butterfly/helpers/offset_helper.dart';
import 'package:butterfly/models/defaults.dart';
import 'package:butterfly/renderers/renderer.dart';
import 'package:butterfly_api/butterfly_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../api/save_data.dart';
import '../cubits/current_index.dart';
import '../cubits/settings.dart';
import '../dialogs/error.dart';
import '../dialogs/image_export.dart';
import '../dialogs/pages.dart';
import '../dialogs/pdf_export.dart';
import '../dialogs/svg_export.dart';

class ImportService {
  final DocumentBloc? bloc;
  final BuildContext context;

  ImportService(this.context, [this.bloc]);

  DocumentLoadSuccess? _getState() => bloc?.state is DocumentLoadSuccess
      ? (bloc?.state as DocumentLoadSuccess)
      : null;
  CurrentIndexCubit? get currentIndexCubit => _getState()?.currentIndexCubit;
  DocumentFileSystem getFileSystem() => context.read<DocumentFileSystem>();
  TemplateFileSystem getTemplateFileSystem() =>
      context.read<TemplateFileSystem>();
  PackFileSystem getPackFileSystem() => context.read<PackFileSystem>();
  SettingsCubit getSettingsCubit() => context.read<SettingsCubit>();

  Future<NoteData?> load(
      {String type = '', Object? data, NoteData? document}) async {
    final state = bloc?.state is DocumentLoadSuccess
        ? (bloc?.state as DocumentLoadSuccess)
        : null;
    final location = state?.location;
    document ??= state?.data;
    document ??= DocumentDefaults.createDocument();
    Uint8List? bytes;
    if (data is Uint8List) {
      bytes = data;
    } else if (data is String) {
      bytes = Uint8List.fromList(utf8.encode(data));
    } else if (data is AppDocumentFile) {
      bytes = Uint8List.fromList(data.data);
    } else if (location != null) {
      bytes = await getFileSystem().loadAbsolute(location.path);
    } else if (data is List) {
      bytes = Uint8List.fromList(List<int>.from(data));
    } else if (data is NoteData) {
      return data;
    }
    if (type.isEmpty) type = 'note';
    AssetFileType? fileType;
    try {
      fileType = type.isNotEmpty
          ? AssetFileType.values.byName(type)
          : location?.fileType;
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) =>
            UnknownImportConfirmationDialog(message: e.toString()),
      );
      return null;
    }
    if (bytes == null) return null;
    return import(fileType ?? AssetFileType.note, bytes, document);
  }

  Future<NoteData?> import(
      AssetFileType type, Uint8List bytes, NoteData document,
      {Offset? position}) async {
    switch (type) {
      case AssetFileType.note:
        return importBfly(bytes, document, position);
      case AssetFileType.image:
        return importImage(bytes, document, position);
      case AssetFileType.svg:
        return importSvg(bytes, document, position);
      case AssetFileType.markdown:
        return importMarkdown(bytes, document, position);
      case AssetFileType.pdf:
        return importPdf(bytes, document, position, true);
      case AssetFileType.page:
        return importPage(bytes, document, position);
    }
  }

  FutureOr<NoteData?> importBfly(Uint8List bytes,
      [NoteData? document, Offset? position]) async {
    try {
      document ??= DocumentDefaults.createDocument();
      final data = NoteData.fromData(bytes);
      final type = data.getMetadata()?.type;
      switch (type) {
        case NoteFileType.document:
          return _importDocument(data, document, position);
        case NoteFileType.template:
          await _importTemplate(data);
          break;
        case NoteFileType.pack:
          await _importPack(data);
          break;
        default:
          showDialog(
            context: context,
            builder: (context) => UnknownImportConfirmationDialog(
                message: AppLocalizations.of(context).unknownImportType),
          );
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) =>
            UnknownImportConfirmationDialog(message: e.toString()),
      );
    }
    return null;
  }

  NoteData? _importDocument(NoteData data, NoteData document,
      [Offset? position]) {
    if (position == null) {
      return data;
    }
    return _importPage(data.getPage(), document, position) ??
        data.createDocument(
          createdAt: DateTime.now(),
        );
  }

  NoteData? importPage(Uint8List bytes, NoteData document, [Offset? position]) {
    try {
      final page = DocumentPage.fromJson(json.decode(utf8.decode(bytes)));
      return _importPage(page, document, position);
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) =>
            UnknownImportConfirmationDialog(message: e.toString()),
      );
    }
    return null;
  }

  NoteData? _importPage(DocumentPage? page, NoteData document,
      [Offset? position]) {
    final firstPos = position ?? Offset.zero;
    if (page == null) return null;
    final areas = page.areas
        .map((e) => e.copyWith(position: e.position + firstPos.toPoint()))
        .toList();

    final content = page.content
        .map((e) =>
            Renderer.fromInstance(e)
                .transform(position: firstPos, relative: true)
                ?.element ??
            e)
        .toList();
    return _submit(document,
        elements: content, areas: areas, choosePosition: position == null);
  }

  Future<bool> _importTemplate(NoteData template) async {
    final metadata = template.getMetadata();
    if (metadata == null) return false;
    final result = await showDialog<bool>(
      context: context,
      builder: (context) =>
          TemplateImportConfirmationDialog(template: metadata),
    );
    if (result != true) return false;
    if (context.mounted) {
      getTemplateFileSystem().createTemplate(template);
    }
    return true;
  }

  Future<bool> _importPack(NoteData pack) async {
    final metadata = pack.getMetadata();
    if (metadata == null) return false;
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => PackImportConfirmationDialog(pack: metadata),
    );
    if (result != true) return false;
    if (context.mounted) {
      getPackFileSystem().createPack(pack);
    }
    return true;
  }

  Future<NoteData?> importImage(Uint8List bytes, NoteData document,
      [Offset? position]) async {
    try {
      final screen = MediaQuery.of(context).size;
      final firstPos = position ?? Offset.zero;
      final codec = await ui.instantiateImageCodec(bytes);
      final frame = await codec.getNextFrame();
      final image = frame.image;

      final newBytes = await image.toByteData(format: ui.ImageByteFormat.png);
      final state = _getState();
      String dataPath;
      if (newBytes == null) return null;
      final newData = newBytes.buffer.asUint8List();
      dataPath = Uri.dataFromBytes(newData, mimeType: 'image/png').toString();
      final height = image.height.toDouble(), width = image.width.toDouble();
      image.dispose();
      final settingsScale = getSettingsCubit().state.imageScale;
      ElementConstraints? constraints;
      if (position == null && currentIndexCubit != null && settingsScale > 0) {
        final scale = min((screen.width * settingsScale) / width,
                (screen.height * settingsScale) / height) /
            currentIndexCubit!.state.cameraViewport.scale;
        constraints = ElementConstraints.scaled(scaleX: scale, scaleY: scale);
      }
      return _submit(document,
          elements: [
            ImageElement(
                height: height,
                width: width,
                layer: state?.currentLayer ?? '',
                source: dataPath,
                constraints: constraints,
                position: firstPos.toPoint())
          ],
          choosePosition: position == null);
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) =>
            UnknownImportConfirmationDialog(message: e.toString()),
      );
    }
    return null;
  }

  Future<NoteData?> importSvg(Uint8List bytes, NoteData document,
      [Offset? position]) async {
    try {
      final screen = MediaQuery.of(context).size;
      final firstPos = position ?? Offset.zero;
      final contentString = String.fromCharCodes(bytes);
      try {
        var info = await vg.loadPicture(SvgStringLoader(contentString), null);
        final size = info.size;
        var height = size.height, width = size.width;
        if (!height.isFinite) height = 0;
        if (!width.isFinite) width = 0;
        final state = _getState();
        String dataPath;
        if (state != null) {
          dataPath =
              Uri.dataFromBytes(bytes, mimeType: 'image/svg+xml').toString();
        } else {
          dataPath = UriData.fromBytes(
            bytes,
            mimeType: 'image/svg+xml',
          ).toString();
        }
        final settingsScale = getSettingsCubit().state.imageScale;
        ElementConstraints? constraints;
        if (position == null &&
            currentIndexCubit != null &&
            settingsScale > 0) {
          final scale = min((screen.width * settingsScale) / width,
                  (screen.height * settingsScale) / height) /
              currentIndexCubit!.state.cameraViewport.scale;
          constraints = ElementConstraints.scaled(scaleX: scale, scaleY: scale);
        }
        return _submit(document,
            elements: [
              SvgElement(
                width: width,
                height: height,
                source: dataPath,
                constraints: constraints,
                position: firstPos.toPoint(),
              ),
            ],
            choosePosition: position == null);
      } catch (e, stackTrace) {
        showDialog<void>(
            context: context,
            builder: (context) => ErrorDialog(
                  error: e,
                  stackTrace: stackTrace,
                ));
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) =>
            UnknownImportConfirmationDialog(message: e.toString()),
      );
    }
    return null;
  }

  Future<NoteData?> importMarkdown(Uint8List bytes, NoteData document,
      [Offset? position]) async {
    try {
      final firstPos = position ?? Offset.zero;
      final contentString = String.fromCharCodes(bytes);
      final styleSheet = document.findStyle();
      final state = _getState();
      final background =
          state?.page.backgrounds.firstOrNull?.defaultColor ?? kColorWhite;
      final foreground =
          isDarkColor(Color(background)) ? kColorWhite : kColorBlack;
      return _submit(document,
          elements: [
            MarkdownElement(
              position: firstPos.toPoint(),
              text: contentString,
              styleSheet: styleSheet,
              foreground: foreground,
            ),
          ],
          choosePosition: position == null);
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) =>
            UnknownImportConfirmationDialog(message: e.toString()),
      );
    }
    return null;
  }

  Future<NoteData?> importPdf(Uint8List bytes, NoteData document,
      [Offset? position, bool createAreas = false]) async {
    try {
      final firstPos = position ?? Offset.zero;
      final elements = <Uint8List>[];
      final localizations = AppLocalizations.of(context);
      await for (var page in Printing.raster(bytes)) {
        final png = await page.toPng();
        elements.add(png);
      }
      if (context.mounted) {
        final callback = await showDialog<PageDialogCallback>(
            context: context,
            builder: (context) => PagesDialog(pages: elements));
        if (callback == null) return document;
        final selectedElements = <ImageElement>[];
        final areas = <Area>[];
        var y = firstPos.dx;
        await for (var page in Printing.raster(bytes,
            pages: callback.pages,
            dpi: PdfPageFormat.inch * callback.quality)) {
          final png = await page.toPng();
          final scale = 1 / callback.quality;
          final height = page.height;
          final width = page.width;
          final dataPath = Uri.dataFromBytes(png).toString();
          selectedElements.add(ImageElement(
              height: height.toDouble(),
              width: width.toDouble(),
              source: dataPath,
              constraints:
                  ElementConstraints.scaled(scaleX: scale, scaleY: scale),
              position: Point(firstPos.dx, y)));
          if (createAreas) {
            areas.add(Area(
              height: height * scale,
              width: width * scale,
              position: Point(firstPos.dx, y),
              name: localizations.pageIndex(areas.length + 1),
            ));
          }
          y += height * scale;
        }
        return _submit(
          document,
          elements: selectedElements,
          areas: createAreas ? areas : [],
          choosePosition: position == null,
        );
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) =>
            UnknownImportConfirmationDialog(message: e.toString()),
      );
    }
    return null;
  }

  Future<void> export() async {
    final state = _getState();
    if (state == null) return;
    final location = state.location;
    final fileType = location.fileType;
    final currentIndexCubit = state.currentIndexCubit;
    final viewport = currentIndexCubit.state.cameraViewport;
    switch (fileType) {
      case AssetFileType.note:
        saveData(context, Uint8List.fromList(state.saveData().save()));
        break;
      case AssetFileType.image:
        return showDialog<void>(
            context: context,
            builder: (context) => BlocProvider.value(
                value: bloc!,
                child: ImageExportDialog(
                  height: viewport.height?.toDouble() ?? 1000.0,
                  width: viewport.width?.toDouble() ?? 1000.0,
                  scale: viewport.scale,
                  x: viewport.x,
                  y: viewport.y,
                )));
      case AssetFileType.pdf:
        return showDialog<void>(
            context: context,
            builder: (context) => BlocProvider.value(
                value: bloc!,
                child: PdfExportDialog(
                    areas: state.page.areas
                        .map((e) => AreaPreset(name: e.name, area: e))
                        .toList())));
      case AssetFileType.svg:
        return showDialog<void>(
            context: context,
            builder: (context) => BlocProvider.value(
                value: bloc!,
                child: SvgExportDialog(
                    width: ((viewport.width ?? 1000) / viewport.scale).round(),
                    height:
                        ((viewport.height ?? 1000) / viewport.scale).round(),
                    x: viewport.x,
                    y: viewport.y)));
      default:
        return;
    }
  }

  NoteData? _submit(
    NoteData document, {
    required List<PadElement> elements,
    List<Area> areas = const [],
    bool choosePosition = false,
  }) {
    final state = _getState();
    DocumentPage page =
        state?.page ?? document.getPage() ?? DocumentDefaults.createPage();
    if (choosePosition && state != null) {
      state.currentIndexCubit.changeTemporaryHandler(
          bloc!, ImportTool(elements: elements, areas: areas));
    } else {
      bloc
        ?..add(ElementsCreated(elements))
        ..add(AreasCreated(areas));
    }
    document = document.setPage(page);
    return document;
  }
}
