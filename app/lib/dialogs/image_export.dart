import 'dart:io';
import 'dart:ui' as ui;

import 'package:butterfly/api/file_system/file_system.dart';
import 'package:butterfly/api/open.dart';
import 'package:butterfly/bloc/document_bloc.dart';
import 'package:butterfly/cubits/transform.dart';
import 'package:butterfly_api/butterfly_api.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:material_leap/material_leap.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../view_painter.dart';

class ImageExportDialog extends StatefulWidget {
  final double x, y;
  final int width, height;
  final double scale;

  const ImageExportDialog(
      {super.key,
      this.x = 0,
      this.y = 0,
      this.width = 1000,
      this.height = 1000,
      this.scale = 1});

  @override
  State<ImageExportDialog> createState() => _ImageExportDialogState();
}

class _ImageExportDialogState extends State<ImageExportDialog> {
  Map<PadElement, ui.Image>? images;
  final TextEditingController _xController = TextEditingController(text: '0');

  final TextEditingController _yController = TextEditingController(text: '0');

  final TextEditingController _widthController =
      TextEditingController(text: '1000');

  final TextEditingController _heightController =
      TextEditingController(text: '1000');

  bool _renderBackground = true;
  double x = 0, y = 0;
  int width = 1000, height = 1000;
  double scale = 1;

  ByteData? _previewImage;
  Future<ByteData?>? _regeneratingFuture;

  @override
  void initState() {
    x = widget.x;
    y = widget.y;
    width = widget.width;
    height = widget.height;
    scale = widget.scale;
    _xController.text = x.toString();
    _yController.text = y.toString();
    _widthController.text = width.toString();
    _heightController.text = height.toString();
    _regeneratePreviewImage();

    super.initState();
  }

  Future<void> _regeneratePreviewImage() async {
    if (_regeneratingFuture != null) return;
    var imageFuture = generateImage();
    _regeneratingFuture =
        _regeneratingFuture?.then((value) => imageFuture) ?? imageFuture;
    var image = await _regeneratingFuture;
    _regeneratingFuture = null;
    if (mounted) setState(() => _previewImage = image);
  }

  Future<ByteData?> generateImage() async {
    var recorder = ui.PictureRecorder();
    var canvas = Canvas(recorder);
    var current = context.read<DocumentBloc>().state as DocumentLoadSuccess;
    final currentPosition = Offset(
      width < 0 ? x + width : x,
      height < 0 ? y + height : y,
    );
    final currentSize = Size(
      width.abs().toDouble(),
      height.abs().toDouble(),
    );
    var painter = ViewPainter(current.data, current.page,
        renderBackground: _renderBackground,
        cameraViewport:
            current.cameraViewport.unbake(unbakedElements: current.renderers),
        transform: CameraTransform(-currentPosition, scale));
    painter.paint(canvas, currentSize);
    var picture = recorder.endRecording();
    var image = await picture.toImage(
        currentSize.width.toInt(), currentSize.height.toInt());
    return await image.toByteData(format: ui.ImageByteFormat.png);
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return Dialog(
        child: Container(
          constraints: const BoxConstraints(maxHeight: 500, maxWidth: 1000),
          child: Column(
            children: [
              Header(
                title: Text(AppLocalizations.of(context).export),
                leading: const PhosphorIcon(PhosphorIconsLight.export),
              ),
              Flexible(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  child: Column(
                    children: [
                      Expanded(
                        child: LayoutBuilder(builder: (context, constraints) {
                          var isMobile = constraints.maxWidth < 600;
                          if (isMobile) {
                            return ListView(
                              children: [_buildPreview(), _buildProperties()],
                            );
                          }
                          return Row(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Expanded(
                                  child: _buildPreview(),
                                ),
                                Expanded(
                                  child: SingleChildScrollView(
                                    child: _buildProperties(),
                                  ),
                                )
                              ]);
                        }),
                      ),
                      const Divider(),
                      Row(
                        children: [
                          Expanded(child: Container()),
                          TextButton(
                            child: Text(AppLocalizations.of(context).cancel),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                          ElevatedButton(
                            child: Text(AppLocalizations.of(context).export),
                            onPressed: () async {
                              final localization = AppLocalizations.of(context);
                              final state = context.read<DocumentBloc>().state;
                              Navigator.of(context).pop();
                              if (state is! DocumentLoadSuccess) {
                                return;
                              }
                              final data = await generateImage();
                              if (data == null) {
                                return;
                              }
                              final location = state.location;
                              if (location.absolute) {
                                DocumentFileSystem.fromPlatform().saveAbsolute(
                                    location.path, data.buffer.asUint8List());
                              } else if (!kIsWeb &&
                                  (Platform.isWindows ||
                                      Platform.isLinux ||
                                      Platform.isMacOS)) {
                                var path = await FilePicker.platform.saveFile(
                                  type: FileType.image,
                                  fileName: 'export.png',
                                  dialogTitle: localization.export,
                                );
                                if (path != null) {
                                  var file = File(path);
                                  if (!(await file.exists())) {
                                    file.create(recursive: true);
                                  }
                                  await file
                                      .writeAsBytes(data.buffer.asUint8List());
                                }
                              } else {
                                openImage(data.buffer.asUint8List());
                              }
                            },
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildPreview() => Padding(
        padding: const EdgeInsets.all(8.0),
        child:
            BlocBuilder<DocumentBloc, DocumentState>(builder: (context, state) {
          if (state is! DocumentLoadSuccess || _previewImage == null) {
            return const Center(child: CircularProgressIndicator());
          }
          return Image(
            image: MemoryImage(_previewImage!.buffer.asUint8List()),
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) {
                return child;
              }
              return Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                      : null,
                ),
              );
            },
          );
        }),
      );

  Widget _buildProperties() => Column(children: [
        TextField(
            controller: _xController,
            decoration: const InputDecoration(labelText: 'X'),
            onChanged: (value) => x = double.tryParse(value) ?? x,
            onSubmitted: (value) => _regeneratePreviewImage()),
        const SizedBox(height: 8),
        TextField(
            controller: _yController,
            decoration: const InputDecoration(labelText: 'Y'),
            onChanged: (value) => y = double.tryParse(value) ?? y,
            onSubmitted: (value) => _regeneratePreviewImage()),
        const SizedBox(height: 8),
        TextField(
            controller: _widthController,
            decoration:
                InputDecoration(labelText: AppLocalizations.of(context).width),
            onChanged: (value) => width = int.tryParse(value) ?? width,
            onSubmitted: (value) => _regeneratePreviewImage()),
        const SizedBox(height: 8),
        TextField(
            controller: _heightController,
            decoration:
                InputDecoration(labelText: AppLocalizations.of(context).height),
            onChanged: (value) => height = int.tryParse(value) ?? height,
            onSubmitted: (value) => _regeneratePreviewImage()),
        ExactSlider(
            header: Text(AppLocalizations.of(context).scale),
            min: 0.1,
            max: 10,
            value: scale,
            defaultValue: 1,
            onChangeEnd: (value) {
              scale = value;
              _regeneratePreviewImage();
            }),
        CheckboxListTile(
            value: _renderBackground,
            title: Text(AppLocalizations.of(context).background),
            onChanged: (value) {
              setState(() => _renderBackground = value ?? _renderBackground);
              _regeneratePreviewImage();
            })
      ]);
}
