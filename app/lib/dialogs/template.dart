import 'package:butterfly/cubits/settings.dart';
import 'package:butterfly/models/document.dart';
import 'package:butterfly/models/template.dart';
import 'package:butterfly/widgets/header.dart';
import 'package:butterfly/widgets/remote_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/file_system.dart';
import '../bloc/document_bloc.dart';

class TemplateDialog extends StatefulWidget {
  final AppDocument? currentDocument;
  const TemplateDialog({super.key, required this.currentDocument});

  @override
  State<TemplateDialog> createState() => _TemplateDialogState();
}

class _TemplateDialogState extends State<TemplateDialog> {
  late TemplateFileSystem _fileSystem;
  late Future<List<DocumentTemplate>>? _templatesFuture;
  final TextEditingController _searchController = TextEditingController();
  SharedPreferences? _prefs;

  @override
  void initState() {
    super.initState();
    _fileSystem =
        context.read<SettingsCubit>().state.getDefaultTemplateFileSystem();
    SharedPreferences.getInstance().then((value) => _prefs = value);
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
            child: Column(
              children: [
                Header(
                  title: Text(AppLocalizations.of(context)!.templates),
                  leading: IconButton(
                    icon: const Icon(PhosphorIcons.xLight),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  actions: [
                    RemoteButton(
                      currentRemote: _fileSystem.remote?.identifier ?? '',
                      onChanged: (value) {
                        _fileSystem =
                            TemplateFileSystem.fromPlatform(remote: value);
                        load();
                        setState(() {});
                      },
                    ),
                    IconButton(
                      icon:
                          const Icon(PhosphorIcons.clockCounterClockwiseLight),
                      tooltip: AppLocalizations.of(context)!.defaultTemplate,
                      onPressed: () async {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text(
                                AppLocalizations.of(context)!.defaultTemplate),
                            content:
                                Text(AppLocalizations.of(context)!.reallyReset),
                            actions: [
                              TextButton(
                                child:
                                    Text(AppLocalizations.of(context)!.cancel),
                                onPressed: () => Navigator.of(context).pop(),
                              ),
                              TextButton(
                                child: Text(AppLocalizations.of(context)!.ok),
                                onPressed: () async {
                                  final navigator = Navigator.of(context);
                                  await _fileSystem.createDefault(this.context,
                                      force: true);
                                  navigator.pop();
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    ...widget.currentDocument == null
                        ? []
                        : [
                            IconButton(
                              onPressed: () =>
                                  _showCreateDialog(widget.currentDocument!),
                              tooltip: AppLocalizations.of(context)!.create,
                              icon: const Icon(PhosphorIcons.plusLight),
                            )
                          ],
                  ],
                ),
                Flexible(
                  child: FutureBuilder<List<DocumentTemplate>>(
                      future: _templatesFuture,
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Text(snapshot.error.toString());
                        }
                        if (!snapshot.hasData || _prefs == null) {
                          return const Center(
                              child: CircularProgressIndicator());
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
                                        return _TemplateItem(
                                          prefs: _prefs!,
                                          template: template,
                                          document: widget.currentDocument,
                                          onChanged: () {
                                            load();
                                            setState(() {});
                                          },
                                        );
                                      })))
                        ]);
                      }),
                ),
              ],
            )));
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
              ElevatedButton(
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

class _TemplateItem extends StatelessWidget {
  final AppDocument? document;
  final DocumentTemplate template;
  final VoidCallback onChanged;
  final SharedPreferences prefs;
  const _TemplateItem(
      {required this.template,
      required this.onChanged,
      required this.document,
      required this.prefs});

  @override
  Widget build(BuildContext context) {
    final isDefault = prefs.getString('default_template') == template.name;
    return ListTile(
      title: Text(template.name),
      subtitle: Text(template.description),
      trailing: PopupMenuButton(
        itemBuilder: (context) => [
          PopupMenuItem(
            padding: EdgeInsets.zero,
            child: CheckboxListTile(
                value: isDefault,
                controlAffinity: ListTileControlAffinity.leading,
                title: Text(AppLocalizations.of(context)!.defaultTemplate),
                onChanged: (value) async {
                  if (value ?? true) {
                    prefs.setString('default_template', template.name);
                  } else {
                    prefs.remove('default_template');
                  }
                  Navigator.of(context).pop();
                  onChanged();
                }),
          ),
          PopupMenuItem(
            padding: EdgeInsets.zero,
            child: ListTile(
                leading: const Icon(PhosphorIcons.textTLight),
                title: Text(AppLocalizations.of(context)!.rename),
                onTap: () async {
                  Navigator.of(context).pop();
                  final TextEditingController nameController =
                      TextEditingController(text: template.document.name);
                  await showDialog<String>(
                      context: context,
                      builder: (context) => AlertDialog(
                            title: Text(AppLocalizations.of(context)!.rename),
                            content: TextField(
                                decoration: InputDecoration(
                                    filled: true,
                                    hintText:
                                        AppLocalizations.of(context)!.name),
                                autofocus: true,
                                controller: nameController),
                            actions: [
                              TextButton(
                                  child: Text(
                                      AppLocalizations.of(context)!.cancel),
                                  onPressed: () => Navigator.of(context).pop()),
                              ElevatedButton(
                                  child: Text(AppLocalizations.of(context)!.ok),
                                  onPressed: () async {
                                    Navigator.of(context).pop();
                                    await TemplateFileSystem.fromPlatform()
                                        .renameTemplate(template.document.name,
                                            nameController.text);
                                    onChanged();
                                  })
                            ],
                          ));
                }),
          ),
          PopupMenuItem(
              padding: EdgeInsets.zero,
              child: ListTile(
                  leading: const Icon(PhosphorIcons.clipboardLight),
                  title: Text(AppLocalizations.of(context)!.replace),
                  onTap: () async {
                    Navigator.of(context).pop();
                    if (document == null) return;
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text(AppLocalizations.of(context)!.replace),
                        content:
                            Text(AppLocalizations.of(context)!.reallyReplace),
                        actions: [
                          TextButton(
                              child: Text(AppLocalizations.of(context)!.no),
                              onPressed: () {
                                Navigator.of(context).pop();
                              }),
                          ElevatedButton(
                              child: Text(AppLocalizations.of(context)!.yes),
                              onPressed: () async {
                                Navigator.of(context).pop();
                                await TemplateFileSystem.fromPlatform()
                                    .updateTemplate(template.copyWith(
                                        document:
                                            document ?? template.document));
                                onChanged();
                              })
                        ],
                      ),
                    );
                  })),
          PopupMenuItem(
              padding: EdgeInsets.zero,
              child: ListTile(
                  leading: const Icon(PhosphorIcons.trashLight),
                  title: Text(AppLocalizations.of(context)!.delete),
                  onTap: () async {
                    Navigator.of(context).pop();
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text(AppLocalizations.of(context)!.delete),
                            content: Text(
                                AppLocalizations.of(context)!.reallyDelete),
                            actions: <Widget>[
                              TextButton(
                                child:
                                    Text(AppLocalizations.of(context)!.cancel),
                                onPressed: () => Navigator.of(context).pop(),
                              ),
                              ElevatedButton(
                                child:
                                    Text(AppLocalizations.of(context)!.delete),
                                onPressed: () async {
                                  Navigator.of(context).pop();
                                  await TemplateFileSystem.fromPlatform()
                                      .deleteTemplate(template.document.name);
                                  onChanged();
                                },
                              ),
                            ],
                          );
                        });
                  }))
        ],
      ),
      onTap: () => Navigator.of(context).pop(template),
    );
  }
}
