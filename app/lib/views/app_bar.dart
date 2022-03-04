import 'package:butterfly/actions/change_path.dart';
import 'package:butterfly/api/shortcut_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:window_manager/window_manager.dart';

import '../actions/export.dart';
import '../actions/image_export.dart';
import '../actions/import.dart';
import '../actions/new.dart';
import '../actions/open.dart';
import '../actions/project.dart';
import '../actions/redo.dart';
import '../actions/settings.dart';
import '../actions/undo.dart';
import '../bloc/document_bloc.dart';
import 'main.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:butterfly/api/full_screen_stub.dart'
    if (dart.library.io) 'package:butterfly/api/full_screen_io.dart'
    if (dart.library.js) 'package:butterfly/api/full_screen_html.dart';

class PadAppBar extends StatelessWidget with PreferredSizeWidget {
  static const double _height = 65;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _areaController = TextEditingController();

  PadAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var bloc = context.read<DocumentBloc>();
    return AppBar(
        toolbarHeight: _height,
        leadingWidth: 90,
        leading: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              icon: const Icon(PhosphorIcons.arrowCounterClockwiseLight),
              tooltip: AppLocalizations.of(context)!.undo,
              onPressed: () {
                Actions.maybeInvoke<UndoIntent>(context, UndoIntent(context));
              },
            ),
            IconButton(
              icon: const Icon(PhosphorIcons.arrowClockwiseLight),
              tooltip: AppLocalizations.of(context)!.redo,
              onPressed: () {
                Actions.maybeInvoke<RedoIntent>(context, RedoIntent(context));
              },
            ),
          ],
        ),
        title: BlocBuilder<DocumentBloc, DocumentState>(
            buildWhen: (previous, current) {
          if (current is! DocumentLoadSuccess ||
              previous is! DocumentLoadSuccess) return true;
          return _nameController.text != current.document.name ||
              previous.path != current.path ||
              _areaController.text != current.currentArea?.name;
        }, builder: (ctx, state) {
          Widget title;
          if (state is DocumentLoadSuccess) {
            _nameController.text = state.document.name;
            var titleEdit = false;
            var titleFocus = FocusNode();
            var area = state.currentArea;
            _areaController.text = area?.name ?? '';
            title = StatefulBuilder(
              builder: (context, setState) => Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        setState(() => titleEdit = true);

                        FocusScope.of(context).requestFocus(titleFocus);
                        _nameController.selection = TextSelection.fromPosition(
                            TextPosition(offset: _nameController.text.length));
                      },
                      child: Focus(
                        onFocusChange: (value) {
                          if (!value) setState(() => titleEdit = false);
                        },
                        autofocus: titleEdit,
                        child: IgnorePointer(
                          ignoring: !titleEdit,
                          child: TextField(
                            controller: area == null
                                ? _nameController
                                : _areaController,
                            textAlign: TextAlign.center,
                            focusNode: titleFocus,
                            style: area == null
                                ? Theme.of(context).textTheme.headline6
                                : Theme.of(context).textTheme.headline4,
                            onChanged: (value) {
                              if (area == null) {
                                bloc.add(
                                    DocumentDescriptorChanged(name: value));
                              } else {
                                bloc.add(AreaChanged(
                                  state.currentAreaIndex,
                                  area.copyWith(name: value),
                                ));
                              }
                            },
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.zero,
                              hintText: AppLocalizations.of(context)!.untitled,
                              hintStyle: area == null
                                  ? Theme.of(context).textTheme.headline6
                                  : Theme.of(context).textTheme.headline4,
                              border: InputBorder.none,
                              constraints: const BoxConstraints(maxWidth: 500),
                            ),
                          ),
                        ),
                      ),
                    ),
                    if (state.path != null && area == null)
                      Text(
                        state.path!,
                        style: Theme.of(ctx).textTheme.caption,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ]),
            );
          } else {
            title = Text(AppLocalizations.of(ctx)!.loading);
          }
          if (isWindow()) {
            title = DragToMoveArea(
              child: title,
            );
          }
          return SizedBox(height: _height, child: title);
        }),
        actions: [
          const _MainPopupMenu(),
          if (isWindow()) ...[const VerticalDivider(), const WindowButtons()]
        ]);
  }

  @override
  Size get preferredSize => const Size.fromHeight(_height);
}

class _MainPopupMenu extends StatelessWidget {
  const _MainPopupMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DocumentBloc, DocumentState>(builder: (context, state) {
      if (state is! DocumentLoadSuccess) return const SizedBox();
      return PopupMenuButton(
        itemBuilder: (context) => <PopupMenuEntry>[
          if (state.path != null) ...[
            PopupMenuItem(
              padding: EdgeInsets.zero,
              child: ListTile(
                leading: const Icon(PhosphorIcons.folderLight),
                title: Text(AppLocalizations.of(context)!.changeDocumentPath),
                subtitle: Text(context.getShortcut('S')),
                onTap: () {
                  Navigator.of(context).pop();
                  Actions.maybeInvoke<ChangePathIntent>(
                      context, ChangePathIntent(context));
                },
              ),
            ),
            const PopupMenuDivider(),
          ],
          PopupMenuItem(
              padding: EdgeInsets.zero,
              child: ListTile(
                leading: const Icon(PhosphorIcons.filePlusLight),
                title: Text(AppLocalizations.of(context)!.newContent),
                subtitle: Text(context.getShortcut('N')),
                onTap: () {
                  Navigator.of(context).pop();
                  Actions.maybeInvoke<NewIntent>(context, NewIntent(context));
                },
              )),
          PopupMenuItem(
              padding: EdgeInsets.zero,
              child: ListTile(
                leading: const Icon(PhosphorIcons.fileLight),
                title: Text(AppLocalizations.of(context)!.templates),
                subtitle: Text(context.getShortcut('N', shiftKey: true)),
                onTap: () {
                  Navigator.of(context).pop();
                  Actions.maybeInvoke<NewIntent>(
                      context, NewIntent(context, fromTemplate: true));
                },
              )),
          PopupMenuItem(
              padding: EdgeInsets.zero,
              child: ListTile(
                  leading: const Icon(PhosphorIcons.folderOpenLight),
                  title: Text(AppLocalizations.of(context)!.open),
                  subtitle: Text(context.getShortcut('O')),
                  onTap: () {
                    Navigator.of(context).pop();
                    Actions.maybeInvoke<OpenIntent>(
                        context, OpenIntent(context));
                  })),
          PopupMenuItem(
              padding: EdgeInsets.zero,
              child: ListTile(
                leading: const Icon(PhosphorIcons.arrowSquareInLight),
                title: Text(AppLocalizations.of(context)!.import),
                subtitle: Text(context.getShortcut('I')),
                onTap: () {
                  Navigator.of(context).pop();
                  Actions.maybeInvoke<ImportIntent>(
                      context, ImportIntent(context));
                },
              )),
          PopupMenuItem(
              padding: EdgeInsets.zero,
              child: PopupMenuButton(
                  itemBuilder: (popupContext) => <PopupMenuEntry>[
                        PopupMenuItem(
                            padding: EdgeInsets.zero,
                            child: ListTile(
                                leading:
                                    const Icon(PhosphorIcons.caretLeftLight),
                                title: Text(AppLocalizations.of(context)!.back),
                                onTap: () async {
                                  Navigator.of(context).pop();
                                })),
                        const PopupMenuDivider(),
                        PopupMenuItem(
                            padding: EdgeInsets.zero,
                            child: ListTile(
                                leading:
                                    const Icon(PhosphorIcons.databaseLight),
                                title: Text(AppLocalizations.of(context)!.data),
                                subtitle: Text(context.getShortcut('E')),
                                onTap: () async {
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                  Actions.maybeInvoke<ExportIntent>(
                                      context, ExportIntent(context));
                                })),
                        PopupMenuItem(
                            padding: EdgeInsets.zero,
                            child: ListTile(
                                leading: const Icon(PhosphorIcons.imageLight),
                                title:
                                    Text(AppLocalizations.of(context)!.image),
                                subtitle: Text(
                                    context.getShortcut('E', shiftKey: true)),
                                onTap: () {
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                  Actions.maybeInvoke<ImageExportIntent>(
                                      context, ImageExportIntent(context));
                                })),
                      ],
                  tooltip: '',
                  child: ListTile(
                      mouseCursor: MouseCursor.defer,
                      leading: const Icon(PhosphorIcons.exportLight),
                      trailing: const Icon(PhosphorIcons.caretRightLight),
                      title: Text(AppLocalizations.of(context)!.export)))),
          PopupMenuItem(
              child: ListTile(
                  onTap: () {
                    Navigator.of(context).pop();
                    Actions.maybeInvoke<ProjectIntent>(
                        context, ProjectIntent(context));
                  },
                  subtitle: Text(
                      context.getShortcut('S', shiftKey: true, altKey: true)),
                  leading: const Icon(PhosphorIcons.wrenchLight),
                  title: Text(AppLocalizations.of(context)!.projectSettings)),
              padding: EdgeInsets.zero),
          const PopupMenuDivider(),
          PopupMenuItem(
              padding: EdgeInsets.zero,
              child: ListTile(
                  leading: const Icon(PhosphorIcons.arrowsOutLight),
                  title: Text(AppLocalizations.of(context)!.fullscreen),
                  subtitle: Text(context.getShortcut('F11', ctrlKey: false)),
                  onTap: () async {
                    setFullScreen(!(await isFullScreen()));
                    Navigator.of(context).pop();
                  })),
          PopupMenuItem(
              padding: EdgeInsets.zero,
              child: ListTile(
                  leading: const Icon(PhosphorIcons.gearLight),
                  title: Text(AppLocalizations.of(context)!.settings),
                  subtitle: Text(context.getShortcut('S', altKey: true)),
                  onTap: () {
                    Navigator.of(context).pop();
                    Actions.maybeInvoke<SettingsIntent>(
                        context, SettingsIntent(context));
                  })),
        ],
      );
    });
  }
}
