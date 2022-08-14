import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:butterfly/api/file_system.dart';
import 'package:butterfly/bloc/document_bloc.dart';
import 'package:butterfly/models/element.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/parser.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

import '../dialogs/error.dart';
import '../dialogs/pages.dart';
import '../models/document.dart';

class ImportService {
  final BuildContext context;

  ImportService(this.context) {
    _load();
  }

  Future<void> _load() async {
    print('Importing');
    final state = bloc.state;
    if (state is! DocumentLoadSuccess) return;
    final location = state.location;
    if (!location.absolute || location.remote.isNotEmpty) return;
    final bytes =
        await DocumentFileSystem.fromPlatform().loadAbsolute(location.path);
    if (bytes == null) return;
    await import(location.fileType, location.fileName, bytes);
  }

  DocumentBloc get bloc => context.read<DocumentBloc>();

  Future<void> import(AssetFileType type, String name, Uint8List bytes) {
    switch (type) {
      case AssetFileType.note:
        return importNote(name, bytes);
      case AssetFileType.image:
        return importImage(name, bytes);
      case AssetFileType.svg:
        return importSvg(name, bytes);
      case AssetFileType.pdf:
        return importPdf(name, bytes);
      default:
        return Future.value();
    }
  }

  Future<void> importNote(String name, Uint8List bytes) async {
    final doc = AppDocument.fromJson(
      json.decode(
        String.fromCharCodes(bytes),
      ),
    );
    bloc.add(DocumentUpdated(doc));
  }

  Future<void> importImage(String name, Uint8List bytes) async {
    var codec = await ui.instantiateImageCodec(bytes);
    var frame = await codec.getNextFrame();
    var image = frame.image.clone();

    var newBytes = await image.toByteData(format: ui.ImageByteFormat.png);
    var state = bloc.state;
    if (state is! DocumentLoadSuccess) return;
    _submit([
      ImageElement(
          height: image.height,
          width: image.width,
          layer: state.currentLayer,
          pixels: newBytes?.buffer.asUint8List() ?? Uint8List(0),
          position: Offset.zero)
    ]);
  }

  Future<void> importSvg(String name, Uint8List bytes) async {
    var contentString = String.fromCharCodes(bytes);
    final SvgParser parser = SvgParser();
    try {
      var document = await parser.parse(contentString,
          warningsAsErrors: true, key: contentString);
      final size = document.viewport.viewBox;
      var height = size.height, width = size.width;
      if (!height.isFinite) height = 0;
      if (!width.isFinite) width = 0;
      _submit([
        SvgElement(
          width: width,
          height: height,
          data: contentString,
          position: Offset.zero,
        ),
      ]);
    } catch (e, stackTrace) {
      showDialog(
          context: context,
          builder: (context) => ErrorDialog(
                error: e,
                stackTrace: stackTrace,
              ));
    }
  }

  Future<void> importPdf(String name, Uint8List bytes) async {
    final elements = <Uint8List>[];
    await for (var page in Printing.raster(bytes)) {
      final png = await page.toPng();
      elements.add(png);
    }
    final callback = await showDialog<PageDialogCallback>(
        context: context, builder: (context) => PagesDialog(pages: elements));
    if (callback == null) return;
    final selectedElements = <ImageElement>[];
    var y = 0.0;
    await for (var page in Printing.raster(bytes,
        pages: callback.pages, dpi: PdfPageFormat.inch * callback.quality)) {
      final png = await page.toPng();
      final scale = 1 / callback.quality;
      selectedElements.add(ImageElement(
          height: page.height,
          width: page.width,
          pixels: png,
          constraints: ElementConstraints.scaled(scale),
          position: Offset(0, y)));
      y += page.height;
    }
    _submit(selectedElements);
  }

  void _submit(List<PadElement> elements) =>
      bloc.add(ElementsCreated(elements));
}
