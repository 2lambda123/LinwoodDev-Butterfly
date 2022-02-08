import 'package:butterfly/models/document.dart';
import 'package:butterfly/models/template.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../api/file_system.dart';
import '../bloc/document_bloc.dart';

class TemplateDialog extends StatefulWidget {
  final AppDocument? currentDocument;
  const TemplateDialog({Key? key, required this.currentDocument})
      : super(key: key);

  @override
  State<TemplateDialog> createState() => _TemplateDialogState();
}

class _TemplateDialogState extends State<TemplateDialog> {
  late TemplateFileSystem _fileSystem;
  late Future<List<DocumentTemplate>>? _templatesFuture;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fileSystem = TemplateFileSystem.fromPlatform();
  }

  void load() {
    _templatesFuture = _fileSystem.createDefault(context).then((value) async {
      var templates = await _fileSystem.getTemplates();
      templates = templates
          .where((element) => element.name.contains(_searchController.text))
          .toList();
      return templates;
    });
  }

  @override
  Widget build(BuildContext context) {
    load();
    return Dialog(
        child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600, maxHeight: 800),
            child: Scaffold(
                appBar: AppBar(
                  title: Text(AppLocalizations.of(context)!.templates),
                  leading: IconButton(
                    icon: const Icon(PhosphorIcons.xLight),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
                floatingActionButton: widget.currentDocument == null
                    ? null
                    : FloatingActionButton.extended(
                        onPressed: () =>
                            _showCreateDialog(widget.currentDocument!),
                        label: Text(AppLocalizations.of(context)!.create),
                        icon: const Icon(PhosphorIcons.plusLight),
                      ),
                backgroundColor: Colors.transparent,
                body: FutureBuilder<List<DocumentTemplate>>(
                    future: _templatesFuture,
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Text(snapshot.error.toString());
                      }
                      if (!snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      var templates = snapshot.data!;
                      return Column(children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                              decoration: const InputDecoration(
                                filled: true,
                                prefixIcon:
                                    Icon(PhosphorIcons.magnifyingGlassLight),
                              ),
                              textAlignVertical: TextAlignVertical.center,
                              controller: _searchController,
                              autofocus: true,
                              onChanged: (value) async {
                                load();
                                setState(() {});
                              }),
                        ),
                        const Divider(),
                        Expanded(
                            child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 15),
                                child: ListView.builder(
                                    itemCount: templates.length,
                                    itemBuilder: (context, index) {
                                      var template = templates[index];
                                      return ListTile(
                                        title: Text(template.name),
                                        subtitle: Text(template.description),
                                        trailing: PopupMenuButton(
                                          itemBuilder: (context) => [
                                            PopupMenuItem(
                                                padding: EdgeInsets.zero,
                                                child: ListTile(
                                                    leading: const Icon(
                                                        PhosphorIcons
                                                            .textTLight),
                                                    title: Text(
                                                        AppLocalizations.of(
                                                                context)!
                                                            .rename),
                                                    onTap: () async {})),
                                            PopupMenuItem(
                                                padding: EdgeInsets.zero,
                                                child: ListTile(
                                                    leading: const Icon(
                                                        PhosphorIcons
                                                            .folderLight),
                                                    title: Text(
                                                        AppLocalizations.of(
                                                                context)!
                                                            .folder),
                                                    onTap: () async {})),
                                            PopupMenuItem(
                                                padding: EdgeInsets.zero,
                                                child: ListTile(
                                                    leading: const Icon(
                                                        PhosphorIcons
                                                            .copyLight),
                                                    title: Text(
                                                        AppLocalizations.of(
                                                                context)!
                                                            .duplicate),
                                                    onTap: () async {})),
                                            PopupMenuItem(
                                                padding: EdgeInsets.zero,
                                                child: ListTile(
                                                    leading: const Icon(
                                                        PhosphorIcons
                                                            .trashLight),
                                                    title: Text(
                                                        AppLocalizations.of(
                                                                context)!
                                                            .delete),
                                                    onTap: () async {}))
                                          ],
                                        ),
                                        onTap: () =>
                                            Navigator.of(context).pop(template),
                                      );
                                    })))
                      ]);
                    }))));
  }

  void _showCreateDialog(AppDocument document) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(AppLocalizations.of(context)!.createTemplate),
            content: Text(AppLocalizations.of(context)!.createTemplateContent),
            actions: <Widget>[
              TextButton(
                child: Text(AppLocalizations.of(context)!.cancel),
                onPressed: () => Navigator.of(context).pop(),
              ),
              TextButton(
                child: Text(AppLocalizations.of(context)!.create),
                onPressed: () async {
                  this
                      .context
                      .read<DocumentBloc>()
                      .add(const TemplateCreated());
                  Navigator.of(context).pop();
                  load();
                  setState(() {});
                },
              ),
            ],
          );
        });
  }
}
