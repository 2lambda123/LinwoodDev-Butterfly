import 'package:butterfly/bloc/document_bloc.dart';
import 'package:butterfly/dialogs/name.dart';
import 'package:butterfly_api/butterfly_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_leap/material_leap.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../dialogs/delete.dart';

typedef _PageEntity = ({
  String path,
  String name,
  bool isFile,
});

class PagesView extends StatelessWidget {
  const PagesView({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController locationController = TextEditingController();
    return BlocBuilder<DocumentBloc, DocumentState>(
      buildWhen: (previous, current) =>
          previous.data != current.data ||
          previous.pageName != current.pageName,
      builder: (context, state) {
        if (state is! DocumentLoadSuccess) return const SizedBox.shrink();
        final currentName = state.pageName;
        final current = state.page;
        return StreamBuilder<NoteData>(
            stream: state.data.onChange,
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const SizedBox.shrink();
              final pages = snapshot.data!.getPages();
              return Stack(
                children: [
                  Column(
                    children: [
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: locationController,
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context).location,
                          suffixIcon: IconButton(
                            icon:
                                const PhosphorIcon(PhosphorIconsLight.arrowUp),
                            onPressed: () {
                              final paths = locationController.text.split('/');
                              if (paths.length <= 1) {
                                locationController.text = '';
                                return;
                              }
                              paths.removeLast();
                              locationController.text = paths.join('/');
                            },
                          ),
                          border: const OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: ValueListenableBuilder<TextEditingValue>(
                          valueListenable: locationController,
                          builder: (context, value, child) {
                            final query =
                                value.text.isEmpty ? '' : '${value.text}/';
                            final queried = pages
                                .where((element) => element.startsWith(query))
                                .map((e) => (
                                      path: e,
                                      name: e.substring(query.length),
                                      isFile: true
                                    ))
                                .toList();
                            final files = queried.where(
                                (element) => !element.name.contains('/'));
                            final folders = queried
                                .where((element) => element.name.contains('/'))
                                .map((e) => e.name.split('/').first)
                                .map((e) {
                              var path = value.text;
                              if (path.isNotEmpty) path += '/';
                              path += e;
                              return (path: path, name: e, isFile: false);
                            }).toSet();
                            final all = [...folders, ...files];
                            return ReorderableListView.builder(
                                itemCount: all.length,
                                onReorder: (oldIndex, newIndex) {
                                  final current = all[oldIndex];
                                  final name = current.path;
                                  final isFile = current.isFile;
                                  if (!isFile) return;
                                  final next = all[newIndex];
                                  final nextIndex =
                                      snapshot.data?.getPageIndex(next.name);
                                  if (!next.isFile || nextIndex == null) return;
                                  snapshot.data?.reoderPage(name, nextIndex);
                                  state.save();
                                },
                                itemBuilder: (BuildContext context, int index) {
                                  final entity = all[index];
                                  return _PageEntityListTile(
                                    entity: entity,
                                    selected: entity.path == currentName,
                                    locationController: locationController,
                                    data: snapshot.data!,
                                    key: ValueKey(entity.path),
                                  );
                                });
                          },
                        ),
                      ),
                    ],
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FloatingActionButton.extended(
                            label: Text(AppLocalizations.of(context).create),
                            icon: const PhosphorIcon(PhosphorIconsLight.plus),
                            onPressed: () {
                              final name = snapshot.data?.addPage(current);
                              if (name == null) return;
                              context
                                  .read<DocumentBloc>()
                                  .add(PageChanged(name));
                            },
                          ),
                          IconButton(
                            icon: const PhosphorIcon(
                                PhosphorIconsLight.plusSquare),
                            tooltip: AppLocalizations.of(context).insert,
                            onPressed: () {
                              final index =
                                  snapshot.data?.getPageIndex(state.pageName);
                              final name =
                                  snapshot.data?.addPage(current, index);
                              if (name == null) return;
                              context
                                  .read<DocumentBloc>()
                                  .add(PageChanged(name));
                            },
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              );
            });
      },
    );
  }
}

class _PageEntityListTile extends StatelessWidget {
  const _PageEntityListTile({
    required this.entity,
    required this.selected,
    required this.locationController,
    required this.data,
    super.key,
  });

  final _PageEntity entity;
  final bool selected;
  final NoteData data;
  final TextEditingController locationController;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(entity.name),
      selected: selected,
      leading: Icon(entity.isFile
          ? PhosphorIconsLight.file
          : PhosphorIconsLight.folderSimple),
      onTap: () {
        if (entity.isFile) {
          context.read<DocumentBloc>().add(PageChanged(entity.path));
        } else {
          locationController.text = entity.path;
        }
      },
      trailing: entity.isFile && !selected
          ? MenuAnchor(
              builder: defaultMenuButton(),
              menuChildren: [
                MenuItemButton(
                  leadingIcon: const PhosphorIcon(PhosphorIconsLight.textT),
                  onPressed: () async {
                    final result = await showDialog<String>(
                        context: context,
                        builder: (context) => NameDialog(
                              value: entity.name,
                              validator: defaultFileNameValidator(
                                  context, data.getPages()),
                            ));
                    if (result == null) return;
                    data.renamePage(entity.path, result);
                  },
                  child: Text(AppLocalizations.of(context).rename),
                ),
                MenuItemButton(
                  leadingIcon: const PhosphorIcon(PhosphorIconsLight.trash),
                  onPressed: () async {
                    final result = await showDialog<bool>(
                        context: context,
                        builder: (context) => const DeleteDialog());
                    if (result != true) {
                      return;
                    }
                    data.removePage(entity.path);
                  },
                  child: Text(AppLocalizations.of(context).delete),
                )
              ],
            )
          : null,
    );
  }
}
