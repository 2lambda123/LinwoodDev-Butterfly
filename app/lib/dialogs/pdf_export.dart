import 'dart:io';

import 'package:butterfly/widgets/header.dart';
import 'package:butterfly_api/butterfly_api.dart';
import 'package:collection/collection.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../api/open.dart';
import '../bloc/document_bloc.dart';
import '../widgets/exact_slider.dart';
import 'name.dart';

class PdfExportDialog extends StatefulWidget {
  final List<AreaPreset> areas;

  const PdfExportDialog({
    super.key,
    this.areas = const [],
  });

  @override
  State<PdfExportDialog> createState() => _PdfExportDialogState();
}

class _PdfExportDialogState extends State<PdfExportDialog> {
  final List<AreaPreset> areas = [];
  int quality = 1;

  @override
  void initState() {
    super.initState();
    areas.addAll(widget.areas);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1000, maxHeight: 700),
        child:
            BlocBuilder<DocumentBloc, DocumentState>(builder: (context, state) {
          if (state is! DocumentLoadSuccess) {
            return const Center(child: CircularProgressIndicator());
          }
          final currentIndex = state.currentIndexCubit;
          return Column(mainAxisSize: MainAxisSize.min, children: [
            Header(
              title: Text(AppLocalizations.of(context).exportPdf),
              actions: [
                IconButton(
                  icon: const PhosphorIcon(PhosphorIconsLight.list),
                  tooltip: AppLocalizations.of(context).presets,
                  onPressed: () async {
                    final preset = await showDialog<ExportPreset>(
                        context: context,
                        builder: (ctx) => BlocProvider.value(
                            value: context.read<DocumentBloc>(),
                            child: ExportPresetsDialog(areas: areas)));
                    if (preset != null) {
                      setState(() {
                        areas.clear();
                        areas.addAll(preset.areas);
                      });
                    }
                  },
                ),
                IconButton(
                  onPressed: () async {
                    final area = await showDialog<String>(
                      context: context,
                      builder: (context) => _AreaSelectionDialog(
                          areas: state.document.areas
                              .map((element) => element.name)
                              .toList()),
                    );
                    if (area != null) {
                      setState(() {
                        areas.add(AreaPreset(name: area));
                      });
                    }
                  },
                  icon: const PhosphorIcon(PhosphorIconsLight.plus),
                  tooltip: AppLocalizations.of(context).add,
                )
              ],
            ),
            Flexible(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Flexible(
                    child: SingleChildScrollView(
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: areas.mapIndexed((i, e) {
                          final area =
                              e.area ?? state.document.getAreaByName(e.name);
                          if (area == null) {
                            return Container();
                          }
                          return FutureBuilder<ByteData?>(
                            future: currentIndex.render(state.document,
                                width: area.width,
                                height: area.height,
                                quality: e.quality,
                                x: area.position.x,
                                y: area.position.y),
                            builder: (context, snapshot) => _AreaPreview(
                              area: area,
                              quality: e.quality,
                              onRemove: () {
                                setState(() {
                                  areas.removeAt(i);
                                });
                              },
                              onQualityChanged: (value) {
                                setState(() {
                                  areas[i] = e.copyWith(quality: value);
                                });
                              },
                              image: snapshot.data?.buffer.asUint8List(),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
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
                          Navigator.of(context).pop();
                          final document = await currentIndex
                              .renderPDF(state.document, areas: areas);
                          final data = await document.save();
                          if (!kIsWeb &&
                              (Platform.isWindows ||
                                  Platform.isLinux ||
                                  Platform.isMacOS)) {
                            var path = await FilePicker.platform.saveFile(
                              type: FileType.custom,
                              allowedExtensions: ['pdf'],
                              fileName: 'export.pdf',
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
                            openPdf(data.buffer.asUint8List());
                          }
                        },
                      ),
                    ],
                  )
                ]),
              ),
            ),
          ]);
        }),
      ),
    );
  }
}

class _AreaPreview extends StatelessWidget {
  final Area area;
  final Uint8List? image;
  final VoidCallback onRemove;
  final double quality;
  final ValueChanged<double> onQualityChanged;

  const _AreaPreview(
      {required this.area,
      this.image,
      required this.onRemove,
      required this.quality,
      required this.onQualityChanged});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 200),
          child: Column(children: [
            image == null
                ? const CircularProgressIndicator()
                : Image.memory(image!),
            const SizedBox(height: 8),
            Text(area.name),
            const SizedBox(height: 16),
            ExactSlider(
              value: quality,
              min: 1,
              max: 10,
              onChanged: onQualityChanged,
              label: AppLocalizations.of(context).quality,
            ),
            OutlinedButton(
                onPressed: onRemove,
                child: Text(AppLocalizations.of(context).remove)),
          ]),
        ),
      ),
    );
  }
}

class _AreaSelectionDialog extends StatefulWidget {
  final List<String> areas;

  const _AreaSelectionDialog({required this.areas});

  @override
  State<_AreaSelectionDialog> createState() => _AreaSelectionDialogState();
}

class _AreaSelectionDialogState extends State<_AreaSelectionDialog> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 500, maxWidth: 300),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Header(title: Text(AppLocalizations.of(context).selectArea)),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context).search,
                filled: true,
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          Flexible(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: widget.areas
                  .where((element) => element.contains(_searchQuery))
                  .map((e) {
                return ListTile(
                  title: Text(e),
                  onTap: () => Navigator.of(context).pop(e),
                );
              }).toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextButton(
              child: Text(AppLocalizations.of(context).cancel),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ]),
      ),
    );
  }
}

class ExportPresetsDialog extends StatefulWidget {
  final List<AreaPreset>? areas;

  const ExportPresetsDialog({this.areas, super.key});

  @override
  State<ExportPresetsDialog> createState() => _ExportPresetsDialogState();
}

class _ExportPresetsDialogState extends State<ExportPresetsDialog> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 500, maxWidth: 300),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Header(title: Text(AppLocalizations.of(context).presets), actions: [
            if (widget.areas != null)
              IconButton(
                onPressed: () async {
                  final bloc = context.read<DocumentBloc>();
                  final state = bloc.state;
                  if (state is! DocumentLoadSuccess) return;
                  final name = await showDialog<String>(
                    context: context,
                    builder: (context) => NameDialog(
                      validator: defaultNameValidator(
                          context,
                          state.document.exportPresets
                              .map((e) => e.name)
                              .toList()),
                    ),
                  );
                  if (name == null) return;
                  bloc.add(ExportPresetCreated(name, widget.areas!));
                },
                icon: const PhosphorIcon(PhosphorIconsLight.plus),
                tooltip: AppLocalizations.of(context).create,
              )
          ]),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context).search,
                filled: true,
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          Flexible(
            child: BlocBuilder<DocumentBloc, DocumentState>(
                builder: (context, state) {
              if (state is! DocumentLoadSuccess) return Container();
              return Column(mainAxisSize: MainAxisSize.min, children: [
                ...state.document.exportPresets
                    .where((element) => element.name.contains(_searchQuery))
                    .map((e) {
                  return Dismissible(
                    key: ObjectKey(e.name),
                    onDismissed: (direction) {
                      context
                          .read<DocumentBloc>()
                          .add(ExportPresetRemoved(e.name));
                    },
                    child: ListTile(
                      title: Text(e.name),
                      onTap: () => Navigator.of(context).pop(e),
                    ),
                  );
                }).toList(),
                if (widget.areas == null)
                  ListTile(
                    title: Text(AppLocalizations.of(context).newContent),
                    onTap: () =>
                        Navigator.of(context).pop(const ExportPreset()),
                  )
              ]);
            }),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextButton(
              child: Text(AppLocalizations.of(context).cancel),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ]),
      ),
    );
  }
}
