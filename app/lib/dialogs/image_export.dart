import 'dart:ui' as ui;

import 'package:butterfly/api/open_image.dart';
import 'package:butterfly/bloc/document_bloc.dart';
import 'package:butterfly/cubits/transform.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../view_painter.dart';

class ImageExportDialog extends StatefulWidget {
  final DocumentBloc bloc;

  const ImageExportDialog({Key? key, required this.bloc}) : super(key: key);

  @override
  State<ImageExportDialog> createState() => _ImageExportDialogState();
}

class _ImageExportDialogState extends State<ImageExportDialog> {
  final TextEditingController _xController = TextEditingController(text: '0');

  final TextEditingController _yController = TextEditingController(text: '0');
  final TextEditingController _sizeController =
      TextEditingController(text: '100');

  final TextEditingController _widthController =
      TextEditingController(text: '1000');

  final TextEditingController _heightController =
      TextEditingController(text: '1000');

  bool _renderBackground = true;
  int x = 0, y = 0, width = 1000, height = 1000;
  double size = 1;

  ByteData? _previewImage;
  Future? _regeneratingFuture;

  @override
  void initState() {
    _regeneratePreviewImage();
    super.initState();
  }

  Future<void> _regeneratePreviewImage() async {
    var imageFuture = generateImage();
    _regeneratingFuture =
        _regeneratingFuture?.then((value) => imageFuture) ?? imageFuture;
    var image = await _regeneratingFuture;
    if (mounted) setState(() => _previewImage = image);
  }

  Future<ByteData?> generateImage() async {
    var recorder = ui.PictureRecorder();
    var canvas = Canvas(recorder);
    var document = (widget.bloc.state as DocumentLoadSuccess).document;
    var images = await loadImages(document);
    var painter = ViewPainter(
        (widget.bloc.state as DocumentLoadSuccess).document,
        renderBackground: _renderBackground,
        images: images,
        transform: CameraTransform(-Offset(x.toDouble(), y.toDouble()), size));
    painter.paint(canvas, Size(width.toDouble(), height.toDouble()));
    var picture = recorder.endRecording();
    var image = await picture.toImage(width, height);
    return await image.toByteData(format: ui.ImageByteFormat.png);
  }

  @override
  Widget build(BuildContext context) {
    if (size.toStringAsFixed(2) != _sizeController.text) {
      _sizeController.text = (size * 100).toStringAsFixed(2);
    }
    return BlocProvider.value(
      value: widget.bloc,
      child: Builder(builder: (context) {
        return Dialog(
          child: Container(
            constraints: const BoxConstraints(maxHeight: 500, maxWidth: 1000),
            child: Scaffold(
                backgroundColor: Colors.transparent,
                appBar: AppBar(
                  title: Text(AppLocalizations.of(context)!.export),
                  leading: const Icon(PhosphorIcons.exportLight),
                ),
                body: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  child: Column(
                    children: [
                      Expanded(
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child:
                                      BlocBuilder<DocumentBloc, DocumentState>(
                                          builder: (context, state) {
                                    if (state is! DocumentLoadSuccess ||
                                        _previewImage == null) {
                                      return Container();
                                    }
                                    return InteractiveViewer(
                                        child: Image.memory(_previewImage!
                                            .buffer
                                            .asUint8List()));
                                  }),
                                ),
                              ),
                              Expanded(
                                  child: ListView(children: [
                                TextField(
                                    controller: _xController,
                                    decoration:
                                        const InputDecoration(labelText: 'X'),
                                    onChanged: (value) =>
                                        x = int.tryParse(value) ?? x,
                                    onSubmitted: (value) =>
                                        _regeneratePreviewImage()),
                                TextField(
                                    controller: _yController,
                                    decoration:
                                        const InputDecoration(labelText: 'Y'),
                                    onChanged: (value) =>
                                        y = int.tryParse(value) ?? y,
                                    onSubmitted: (value) =>
                                        _regeneratePreviewImage()),
                                TextField(
                                    controller: _widthController,
                                    decoration: InputDecoration(
                                        labelText: AppLocalizations.of(context)!
                                            .width),
                                    onChanged: (value) =>
                                        width = int.tryParse(value) ?? width,
                                    onSubmitted: (value) =>
                                        _regeneratePreviewImage()),
                                TextField(
                                    controller: _heightController,
                                    decoration: InputDecoration(
                                        labelText: AppLocalizations.of(context)!
                                            .height),
                                    onChanged: (value) =>
                                        height = int.tryParse(value) ?? height,
                                    onSubmitted: (value) =>
                                        _regeneratePreviewImage()),
                                Row(children: [
                                  ConstrainedBox(
                                    constraints:
                                        const BoxConstraints(maxWidth: 100),
                                    child: TextField(
                                        decoration: InputDecoration(
                                            labelText:
                                                AppLocalizations.of(context)!
                                                    .size),
                                        controller: _sizeController,
                                        onSubmitted: (value) =>
                                            _regeneratePreviewImage(),
                                        onChanged: (value) => setState(() =>
                                            size = (double.tryParse(value) ??
                                                    (size * 100)) /
                                                100)),
                                  ),
                                  Expanded(
                                    child: Slider(
                                        value: size.clamp(0.1, 10),
                                        min: 0.1,
                                        max: 10,
                                        onChanged: (value) {
                                          setState(() => size = value);
                                          _regeneratePreviewImage();
                                        }),
                                  )
                                ]),
                                CheckboxListTile(
                                    value: _renderBackground,
                                    title: Text(AppLocalizations.of(context)!
                                        .background),
                                    onChanged: (value) {
                                      setState(() => _renderBackground =
                                          value ?? _renderBackground);
                                      _regeneratePreviewImage();
                                    })
                              ]))
                            ]),
                      ),
                      const Divider(),
                      Row(
                        children: [
                          Expanded(child: Container()),
                          TextButton(
                            child: Text(AppLocalizations.of(context)!.cancel),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                          ElevatedButton(
                            child: Text(AppLocalizations.of(context)!.export),
                            onPressed: () async {
                              var data = await generateImage();
                              if (data == null) {
                                return;
                              }
                              openImage(data.buffer.asUint8List());
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      )
                    ],
                  ),
                )),
          ),
        );
      }),
    );
  }
}
