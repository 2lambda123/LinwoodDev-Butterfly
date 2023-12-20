import 'dart:ui' as ui;

import 'package:butterfly/api/save.dart';
import 'package:butterfly/bloc/document_bloc.dart';
import 'package:butterfly_api/butterfly_api.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:material_leap/material_leap.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class ImageExportDialog extends StatefulWidget {
  final double x, y;
  final double width, height;
  final double scale, quality;

  const ImageExportDialog(
      {super.key,
      this.x = 0,
      this.y = 0,
      this.width = 1000,
      this.height = 1000,
      this.scale = 1,
      this.quality = 1});

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
  double _x = 0, y = 0;
  double width = 1000.0, height = 1000.0;
  double scale = 1, quality = 1;

  ByteData? _previewImage;
  Future<ByteData?>? _regeneratingFuture;

  @override
  void initState() {
    _x = widget.x;
    y = widget.y;
    width = widget.width;
    height = widget.height;
    scale = widget.scale;
    quality = widget.quality;
    _xController.text = _x.toString();
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
    final bloc = context.read<DocumentBloc>();
    final state = bloc.state;
    if (state is! DocumentLoaded) return null;
    return state.currentIndexCubit.render(
      state.data,
      state.page,
      state.info,
      width: width,
      height: height,
      renderBackground: _renderBackground,
      x: _x,
      y: y,
      scale: scale,
      quality: quality,
    );
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
                              final state = context.read<DocumentBloc>().state;
                              if (state is! DocumentLoadSuccess) {
                                return;
                              }
                              final data = await generateImage();
                              if (data == null) {
                                return;
                              }
                              await exportImage(
                                  context, data.buffer.asUint8List());
                              if (mounted) Navigator.of(context).pop();
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
            fit: BoxFit.contain,
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

  Widget _buildProperties() =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          AppLocalizations.of(context).position,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _xController,
                decoration: const InputDecoration(labelText: 'X', filled: true),
                onChanged: (value) => _x = double.tryParse(value) ?? _x,
                onSubmitted: (value) => _regeneratePreviewImage(),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextField(
                controller: _yController,
                decoration: const InputDecoration(labelText: 'Y', filled: true),
                onChanged: (value) => y = double.tryParse(value) ?? y,
                onSubmitted: (value) => _regeneratePreviewImage(),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          AppLocalizations.of(context).size,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _widthController,
                decoration: InputDecoration(
                    labelText: AppLocalizations.of(context).width,
                    filled: true),
                onChanged: (value) => width = double.tryParse(value) ?? width,
                onSubmitted: (value) => _regeneratePreviewImage(),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextField(
                controller: _heightController,
                decoration: InputDecoration(
                    labelText: AppLocalizations.of(context).height,
                    filled: true),
                onChanged: (value) => height = double.tryParse(value) ?? height,
                onSubmitted: (value) => _regeneratePreviewImage(),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
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
        const SizedBox(height: 8),
        ExactSlider(
            header: Text(AppLocalizations.of(context).quality),
            min: 0.1,
            max: 10,
            value: quality,
            defaultValue: 1,
            onChangeEnd: (value) {
              quality = value;
              _regeneratePreviewImage();
            }),
        const SizedBox(height: 8),
        CheckboxListTile(
            value: _renderBackground,
            title: Text(AppLocalizations.of(context).background),
            onChanged: (value) {
              setState(() => _renderBackground = value ?? _renderBackground);
              _regeneratePreviewImage();
            })
      ]);
}
