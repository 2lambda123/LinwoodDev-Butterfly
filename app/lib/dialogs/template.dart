import 'package:butterfly/models/template.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../api/file_system.dart';

class TemplateDialog extends StatefulWidget {
  const TemplateDialog({Key? key}) : super(key: key);

  @override
  State<TemplateDialog> createState() => _TemplateDialogState();
}

class _TemplateDialogState extends State<TemplateDialog> {
  late TemplateFileSystem _fileSystem;
  late Future<List<DocumentTemplate>> _templatesFuture;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fileSystem = TemplateFileSystem.fromPlatform(context);
    _templatesFuture = load();
  }

  Future<List<DocumentTemplate>> load() async {
    await _fileSystem.createDefault();
    return _fileSystem.getTemplates();
  }

  @override
  Widget build(BuildContext context) {
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
                floatingActionButton: FloatingActionButton.extended(
                  onPressed: () => _showCreateDialog(),
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
                          ),
                        ),
                        const Divider(),
                        Expanded(
                            child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 15),
                                child: ValueListenableBuilder(
                                    valueListenable: _searchController,
                                    builder: (context, value, child) =>
                                        ListView.builder(
                                            itemCount: templates.length,
                                            itemBuilder: (context, index) {
                                              var template = templates[index];
                                              return ListTile(
                                                title: Text(template.name),
                                                subtitle:
                                                    Text(template.description),
                                                onTap: () =>
                                                    Navigator.of(context)
                                                        .pop(template),
                                              );
                                            }))))
                      ]);
                    }))));
  }

  void _showCreateDialog() {}
}
