import 'package:butterfly/bloc/document_bloc.dart';
import 'package:butterfly/cubits/current_index.dart';
import 'package:butterfly/dialogs/add.dart';
import 'package:butterfly/services/import.dart';
import 'package:butterfly/visualizer/painter.dart';
import 'package:butterfly/widgets/option_button.dart';
import 'package:butterfly_api/butterfly_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:material_leap/material_leap.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../cubits/settings.dart';
import '../handlers/handler.dart';

class EditToolbar extends StatefulWidget {
  final bool isMobile;
  final bool? centered;
  final Axis direction;

  const EditToolbar({
    super.key,
    required this.isMobile,
    this.centered,
    this.direction = Axis.horizontal,
  });

  @override
  State<EditToolbar> createState() => _EditToolbarState();
}

enum _MouseState { normal, multi }

class _EditToolbarState extends State<EditToolbar> {
  final ScrollController _scrollController = ScrollController();

  _MouseState _mouseState = _MouseState.normal;

  @override
  void initState() {
    super.initState();

    RawKeyboard.instance.addListener(_handleKey);
  }

  @override
  void dispose() {
    RawKeyboard.instance.removeListener(_handleKey);
    super.dispose();
  }

  void _handleKey(RawKeyEvent event) {
    if (event.data.isControlPressed) {
      _mouseState = _MouseState.multi;
    } else {
      _mouseState = _MouseState.normal;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
        controller: _scrollController,
        child: SizedBox(
          height: widget.direction == Axis.horizontal ? 60 : null,
          width: widget.direction == Axis.horizontal ? null : 80,
          child: BlocBuilder<SettingsCubit, ButterflySettings>(
              buildWhen: (previous, current) =>
                  previous.inputConfiguration != current.inputConfiguration ||
                  previous.fullScreen != current.fullScreen,
              builder: (context, settings) {
                final shortcuts = settings.inputConfiguration.getShortcuts();
                return BlocBuilder<DocumentBloc, DocumentState>(
                  buildWhen: (previous, current) =>
                      previous is! DocumentLoadSuccess ||
                      current is! DocumentLoadSuccess ||
                      previous.painter != current.painter ||
                      previous.info.painters != current.info.painters,
                  builder: (context, state) {
                    if (state is! DocumentLoadSuccess) return Container();
                    var painters = state.info.painters;

                    return BlocBuilder<CurrentIndexCubit, CurrentIndex>(
                      buildWhen: (previous, current) =>
                          previous.handler != current.handler ||
                          previous.temporaryHandler !=
                              current.temporaryHandler ||
                          previous.selection != current.selection,
                      builder: (context, currentIndex) {
                        return Material(
                          color: Colors.transparent,
                          child: Align(
                            alignment: widget.centered ?? widget.isMobile
                                ? Alignment.center
                                : Alignment.centerRight,
                            child: Card(
                              elevation: 10,
                              child: _buildBody(
                                state,
                                currentIndex,
                                settings,
                                painters,
                                shortcuts,
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              }),
        ));
  }

  Widget _buildIcon(PhosphorIconData data, bool action, [Color? color]) => Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(width: 8),
          PhosphorIcon(
            data,
            color: color,
          ),
          SizedBox(
            width: 8,
            child: action
                ? PhosphorIcon(
                    PhosphorIconsLight.playCircle,
                    size: 16,
                    color: color,
                  )
                : null,
          ),
        ],
      );
  ListView _buildBody(
    DocumentLoadSuccess state,
    CurrentIndex currentIndex,
    ButterflySettings settings,
    List<Painter> painters,
    Set<int> shortcuts,
  ) {
    final temp = currentIndex.temporaryHandler;
    final tempData = temp?.data;
    PhosphorIconData icon = PhosphorIconsLight.cube;
    PhosphorIconData iconFilled = PhosphorIconsFill.cube;
    var tooltip = tempData?.name.trim();
    if (tooltip?.isEmpty ?? false) {
      if (tempData is Painter) {
        tooltip = tempData.getLocalizedName(context);
        icon = tempData.icon(PhosphorIconsStyle.light);
        iconFilled = tempData.icon(PhosphorIconsStyle.fill);
      }
    }
    tooltip ??= '';
    int lastReorderable = 0;
    return ListView(
        controller: _scrollController,
        scrollDirection: widget.direction,
        shrinkWrap: true,
        children: [
          if (state.embedding?.editable ?? true) ...[
            if (temp != null && tempData != null) ...[
              OptionButton(
                tooltip: tooltip,
                selected: true,
                highlighted:
                    currentIndex.selection?.selected.contains(tempData) ??
                        false,
                icon: PhosphorIcon(icon),
                selectedIcon: PhosphorIcon(iconFilled),
                onLongPressed: () =>
                    context.read<CurrentIndexCubit>().changeSelection(tempData),
                onPressed: () {
                  if (tempData == null) return;
                  if (_mouseState == _MouseState.multi) {
                    context
                        .read<CurrentIndexCubit>()
                        .insertSelection(tempData, true);
                  } else {
                    context
                        .read<CurrentIndexCubit>()
                        .changeSelection(tempData, true);
                  }
                },
              ),
              const VerticalDivider(),
            ],
            ReorderableListView.builder(
              shrinkWrap: true,
              buildDefaultDragHandles: false,
              scrollDirection: widget.direction,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: painters.length + 1,
              itemBuilder: (context, i) {
                if (painters.length <= i) {
                  final add = Padding(
                    padding: widget.direction == Axis.horizontal
                        ? const EdgeInsets.all(8)
                        : const EdgeInsets.all(16),
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: FloatingActionButton.small(
                        tooltip: AppLocalizations.of(context).add,
                        heroTag: null,
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (ctx) => MultiBlocProvider(
                              providers: [
                                BlocProvider.value(
                                  value: context.read<DocumentBloc>(),
                                ),
                                BlocProvider.value(
                                  value: context.read<CurrentIndexCubit>(),
                                ),
                              ],
                              child: RepositoryProvider.value(
                                value: context.read<ImportService>(),
                                child: const AddDialog(),
                              ),
                            ),
                          );
                        },
                        child: const PhosphorIcon(PhosphorIconsLight.plus),
                      ),
                    ),
                  );

                  if (widget.direction == Axis.horizontal) {
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      key: const ValueKey('add'),
                      children: [
                        const VerticalDivider(),
                        add,
                      ],
                    );
                  } else {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      key: const ValueKey('add'),
                      children: [
                        const Divider(),
                        add,
                      ],
                    );
                  }
                }
                var e = painters[i];
                final selected = i == currentIndex.index;
                final highlighted = currentIndex.selection?.selected
                        .any((element) => element.hashCode == e.hashCode) ??
                    false;
                String tooltip = e.name.trim();
                if (tooltip.isEmpty) {
                  tooltip = e.getLocalizedName(context);
                }

                final bloc = context.read<DocumentBloc>();

                final handler = Handler.fromPainter(e);

                final color = handler.getStatus(context.read<DocumentBloc>()) ==
                        PainterStatus.disabled
                    ? Theme.of(context).disabledColor
                    : null;
                var icon = handler.getIcon(bloc) ??
                    e.icon(selected
                        ? PhosphorIconsStyle.fill
                        : PhosphorIconsStyle.light);
                final toolWidget = Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: OptionButton(
                        tooltip: tooltip,
                        onLongPressed: () => context
                            .read<CurrentIndexCubit>()
                            .insertSelection(e, true),
                        focussed: shortcuts.contains(i),
                        selected: selected,
                        highlighted: highlighted,
                        selectedIcon: _buildIcon(icon, e.isAction(), color),
                        icon: _buildIcon(icon, e.isAction(), color),
                        onPressed: () {
                          if (_mouseState == _MouseState.multi) {
                            context
                                .read<CurrentIndexCubit>()
                                .insertSelection(e, true);
                          } else if (!selected || temp != null) {
                            context.read<CurrentIndexCubit>().resetSelection();
                            context.read<CurrentIndexCubit>().changePainter(
                                  context.read<DocumentBloc>(),
                                  i,
                                  handler,
                                );
                          } else {
                            context
                                .read<CurrentIndexCubit>()
                                .changeSelection(e, true);
                          }
                        }));
                return ReorderableDelayedDragStartListener(
                  index: i,
                  key: ObjectKey(i),
                  enabled: selected,
                  child: toolWidget,
                );
              },
              onReorderStart: (index) => lastReorderable = index,
              onReorderEnd: (index) {
                if (lastReorderable != index) return;
                context
                    .read<CurrentIndexCubit>()
                    .insertSelection(painters[index], true);
              },
              onReorder: (oldIndex, newIndex) {
                if (oldIndex == newIndex) {
                  return;
                }
                final bloc = context.read<DocumentBloc>();
                final delete = newIndex > painters.length;
                if (delete) {
                  bloc.add(PaintersRemoved([painters[oldIndex]]));
                  return;
                }
                bloc.add(PainterReordered(oldIndex, newIndex));
              },
            ),
            IconButton(
              icon: const PhosphorIcon(PhosphorIconsLight.wrench),
              tooltip: AppLocalizations.of(context).tools,
              onPressed: () {
                final cubit = context.read<CurrentIndexCubit>();
                final state = cubit.state.cameraViewport.tool.element;
                cubit.changeSelection(state);
              },
            ),
            if (settings.fullScreen &&
                painters.every((e) => e is! FullScreenPainter))
              IconButton(
                icon: const PhosphorIcon(PhosphorIconsLight.arrowsIn),
                tooltip: AppLocalizations.of(context).exitFullScreen,
                onPressed: () {
                  context.read<SettingsCubit>().setFullScreen(false);
                },
              ),
            BlocBuilder<DocumentBloc, DocumentState>(
              buildWhen: (previous, current) =>
                  previous.pageName != current.pageName ||
                  previous.data != current.data,
              builder: (context, state) {
                final pageName = state.pageName;
                return StreamBuilder<NoteData>(
                    stream: state.data?.onChange,
                    builder: (context, snapshot) {
                      final pages = snapshot.data?.getPages();
                      return MenuAnchor(
                        menuChildren: [
                          ...pages
                                  ?.map((e) => MenuItemButton(
                                        child: Text(
                                          e,
                                          style: pageName == e
                                              ? TextStyle(
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                )
                                              : null,
                                        ),
                                        onPressed: () => context
                                            .read<DocumentBloc>()
                                            .add(PageChanged(e)),
                                      ))
                                  .toList() ??
                              [],
                          const Divider(),
                          MenuItemButton(
                              child: Text(AppLocalizations.of(context).add),
                              onPressed: () {
                                final state =
                                    context.read<DocumentBloc>().state;
                                final name = state.data?.addPage(state.page);
                                if (name != null) {
                                  context
                                      .read<DocumentBloc>()
                                      .add(PageChanged(name));
                                }
                              }),
                        ],
                        style: const MenuStyle(
                          alignment: Alignment.bottomRight,
                        ),
                        builder: defaultMenuButton(PhosphorIconsLight.book),
                      );
                    });
              },
            ),
          ],
        ]);
  }
}
