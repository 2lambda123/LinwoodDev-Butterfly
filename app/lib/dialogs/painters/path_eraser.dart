import 'package:butterfly/api/open_help.dart';
import 'package:butterfly/bloc/document_bloc.dart';
import 'package:butterfly/models/painters/path_eraser.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class PathEraserPainterDialog extends StatefulWidget {
  final DocumentBloc bloc;
  final int painterIndex;
  const PathEraserPainterDialog(
      {Key? key, required this.bloc, required this.painterIndex})
      : super(key: key);

  @override
  _PathEraserPainterDialogState createState() =>
      _PathEraserPainterDialogState();
}

class _PathEraserPainterDialogState extends State<PathEraserPainterDialog> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _strokeWidthController = TextEditingController();
  final TextEditingController _strokeMultiplierController =
      TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: widget.bloc,
      child: Dialog(child:
          BlocBuilder<DocumentBloc, DocumentState>(builder: (context, state) {
        if (state is! DocumentLoadSuccess) return Container();
        var painter =
            state.document.painters[widget.painterIndex] as PathEraserPainter;
        return Container(
            constraints: const BoxConstraints(maxWidth: 600, maxHeight: 800),
            child: StatefulBuilder(builder: (context, setState) {
              if (_nameController.text != painter.name) {
                _nameController.text = painter.name;
              }
              if (double.tryParse(_strokeWidthController.text) !=
                  painter.strokeWidth) {
                _strokeWidthController.text =
                    painter.strokeWidth.toStringAsFixed(2);
              }
              if (double.tryParse(_strokeMultiplierController.text) !=
                  painter.strokeMultiplier) {
                _strokeMultiplierController.text =
                    painter.strokeMultiplier.toStringAsFixed(2);
              }
              return Scaffold(
                  backgroundColor: Colors.transparent,
                  appBar: AppBar(
                    backgroundColor: Colors.transparent,
                    title: Text(AppLocalizations.of(context)!.pathEraser),
                    leading: const Icon(PhosphorIcons.penLight),
                    actions: [
                      IconButton(
                          tooltip: AppLocalizations.of(context)!.help,
                          icon:
                              const Icon(PhosphorIcons.circleWavyQuestionLight),
                          onPressed: () =>
                              openHelp(['painters', 'path_eraser'])),
                    ],
                  ),
                  body: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 15),
                    child: Column(
                      children: [
                        Expanded(
                          child: ListView(children: [
                            TextField(
                                decoration: InputDecoration(
                                    labelText:
                                        AppLocalizations.of(context)!.name),
                                controller: _nameController,
                                onChanged: (value) => setState(() =>
                                    painter = painter.copyWith(name: value))),
                            Row(children: [
                              ConstrainedBox(
                                  constraints:
                                      const BoxConstraints(maxWidth: 100),
                                  child: TextField(
                                    decoration: InputDecoration(
                                        labelText: AppLocalizations.of(context)!
                                            .strokeWidth),
                                    controller: _strokeWidthController,
                                    onChanged: (value) => setState(() =>
                                        painter = painter.copyWith(
                                            strokeWidth:
                                                double.tryParse(value))),
                                  )),
                              Expanded(
                                child: Slider(
                                    value: painter.strokeWidth.clamp(0, 10),
                                    min: 0,
                                    max: 10,
                                    onChanged: (value) => setState(() =>
                                        painter = painter.copyWith(
                                            strokeWidth: value))),
                              )
                            ]),
                            Row(children: [
                              ConstrainedBox(
                                  constraints:
                                      const BoxConstraints(maxWidth: 100),
                                  child: TextField(
                                    decoration: InputDecoration(
                                        labelText: AppLocalizations.of(context)!
                                            .strokeMultiplier),
                                    controller: _strokeMultiplierController,
                                    onChanged: (value) => setState(() =>
                                        painter = painter.copyWith(
                                            strokeMultiplier:
                                                double.tryParse(value))),
                                  )),
                              Expanded(
                                child: Slider(
                                    value:
                                        painter.strokeMultiplier.clamp(0, 100),
                                    min: 0,
                                    max: 100,
                                    onChanged: (value) => setState(() =>
                                        painter = painter.copyWith(
                                            strokeMultiplier: value))),
                              )
                            ]),
                            CheckboxListTile(
                                value: painter.canDeleteEraser,
                                title: Text(AppLocalizations.of(context)!
                                    .canDeleteEraser),
                                onChanged: (value) => setState(() => painter =
                                    painter.copyWith(canDeleteEraser: value))),
                          ]),
                        ),
                        const Divider(),
                        Row(
                          children: [
                            OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                  primary: Theme.of(context).colorScheme.error),
                              child: Text(AppLocalizations.of(context)!.delete),
                              onPressed: () {
                                Navigator.of(context).pop();
                                showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                            actions: [
                                              TextButton(
                                                child: Text(AppLocalizations.of(
                                                        context)!
                                                    .no),
                                                onPressed: () =>
                                                    Navigator.of(context).pop(),
                                              ),
                                              TextButton(
                                                child: Text(AppLocalizations.of(
                                                        context)!
                                                    .yes),
                                                onPressed: () {
                                                  widget.bloc.add(
                                                      PainterRemoved(
                                                          widget.painterIndex));
                                                  Navigator.of(context).pop();
                                                },
                                              )
                                            ],
                                            title: Text(
                                                AppLocalizations.of(context)!
                                                    .areYouSure),
                                            content: Text(
                                                AppLocalizations.of(context)!
                                                    .reallyDelete)));
                              },
                            ),
                            Expanded(child: Container()),
                            TextButton(
                              child: Text(AppLocalizations.of(context)!.cancel),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                            ElevatedButton(
                              child: Text(AppLocalizations.of(context)!.ok),
                              onPressed: () {
                                widget.bloc.add(PainterChanged(
                                    painter, widget.painterIndex));
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
