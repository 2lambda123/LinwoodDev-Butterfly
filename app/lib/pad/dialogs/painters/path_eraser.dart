import 'package:butterfly/pad/bloc/document_bloc.dart';
import 'package:butterfly/painter/path_eraser.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class PathEraserPainterDialog extends StatefulWidget {
  final DocumentBloc bloc;
  final int painterIndex;
  const PathEraserPainterDialog({Key? key, required this.bloc, required this.painterIndex})
      : super(key: key);

  @override
  _PathEraserPainterDialogState createState() => _PathEraserPainterDialogState();
}

class _PathEraserPainterDialogState extends State<PathEraserPainterDialog> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _strokeWidthController = TextEditingController();
  final TextEditingController _strokeMultiplierController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: widget.bloc,
      child: Dialog(child: BlocBuilder<DocumentBloc, DocumentState>(builder: (context, state) {
        if (state is! DocumentLoadSuccess) return Container();
        var painter = state.document.painters[widget.painterIndex] as PathEraserPainter;
        return Container(
            constraints: const BoxConstraints(maxWidth: 600, maxHeight: 800),
            child: StatefulBuilder(builder: (context, setState) {
              if (_nameController.text != painter.name) _nameController.text = painter.name;
              if (_strokeWidthController.text != painter.strokeWidth.toStringAsFixed(2)) {
                _strokeWidthController.text = painter.strokeWidth.toStringAsFixed(2);
              }
              if (_strokeMultiplierController.text != painter.strokeMultiplier.toStringAsFixed(2)) {
                _strokeMultiplierController.text = painter.strokeMultiplier.toStringAsFixed(2);
              }
              return Scaffold(
                  appBar: AppBar(
                    title: Text(AppLocalizations.of(context)!.pathEraser),
                    leading: const Icon(PhosphorIcons.penLight),
                  ),
                  body: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    child: Column(
                      children: [
                        Expanded(
                          child: ListView(children: [
                            TextField(
                                decoration:
                                    InputDecoration(labelText: AppLocalizations.of(context)!.name),
                                controller: _nameController,
                                onChanged: (value) =>
                                    setState(() => painter = painter.copyWith(name: value))),
                            Row(children: [
                              ConstrainedBox(
                                  constraints: const BoxConstraints(maxWidth: 100),
                                  child: TextField(
                                    decoration: InputDecoration(
                                        labelText: AppLocalizations.of(context)!.strokeWidth),
                                    controller: _strokeWidthController,
                                    onChanged: (value) => setState(() => painter =
                                        painter.copyWith(strokeWidth: double.tryParse(value))),
                                  )),
                              Expanded(
                                child: Slider(
                                    value: painter.strokeWidth.clamp(0, 10),
                                    min: 0,
                                    max: 10,
                                    onChanged: (value) => setState(
                                        () => painter = painter.copyWith(strokeWidth: value))),
                              )
                            ]),
                            Row(children: [
                              ConstrainedBox(
                                  constraints: const BoxConstraints(maxWidth: 100),
                                  child: TextField(
                                    decoration: InputDecoration(
                                        labelText: AppLocalizations.of(context)!.strokeMultiplier),
                                    controller: _strokeMultiplierController,
                                    onChanged: (value) => setState(() => painter =
                                        painter.copyWith(strokeMultiplier: double.tryParse(value))),
                                  )),
                              Expanded(
                                child: Slider(
                                    value: painter.strokeMultiplier.clamp(0, 5),
                                    min: 0,
                                    max: 5,
                                    onChanged: (value) => setState(
                                        () => painter = painter.copyWith(strokeMultiplier: value))),
                              )
                            ]),
                            CheckboxListTile(
                                value: painter.canDeleteEraser,
                                title: Text(AppLocalizations.of(context)!.canDeleteEraser),
                                onChanged: (value) => setState(
                                    () => painter = painter.copyWith(canDeleteEraser: value))),
                          ]),
                        ),
                        const Divider(),
                        Row(
                          children: [
                            OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                  primary: Theme.of(context).colorScheme.error),
                              child: Text(AppLocalizations.of(context)!.delete.toUpperCase()),
                              onPressed: () {
                                Navigator.of(context).pop();
                                showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                            actions: [
                                              TextButton(
                                                child: Text(
                                                    AppLocalizations.of(context)!.no.toUpperCase()),
                                                onPressed: () => Navigator.of(context).pop(),
                                              ),
                                              TextButton(
                                                child: Text(AppLocalizations.of(context)!
                                                    .yes
                                                    .toUpperCase()),
                                                onPressed: () {
                                                  widget.bloc
                                                      .add(PainterRemoved(widget.painterIndex));
                                                  Navigator.of(context).pop();
                                                },
                                              )
                                            ],
                                            title: Text(AppLocalizations.of(context)!.areYouSure),
                                            content:
                                                Text(AppLocalizations.of(context)!.reallyDelete)));
                              },
                            ),
                            Expanded(child: Container()),
                            TextButton(
                              child: Text(AppLocalizations.of(context)!.cancel.toUpperCase()),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                            ElevatedButton(
                              child: Text(AppLocalizations.of(context)!.ok.toUpperCase()),
                              onPressed: () {
                                widget.bloc.add(PainterChanged(painter, widget.painterIndex));
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        )
                      ],
                    ),
                  ));
            }));
      })),
    );
  }
}
