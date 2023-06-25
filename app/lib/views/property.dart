import 'dart:math';

import 'package:butterfly/api/open.dart';
import 'package:butterfly/cubits/current_index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_leap/material_leap.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../selections/selection.dart';

class PropertyView extends StatefulWidget {
  const PropertyView({super.key});

  @override
  State<PropertyView> createState() => _PropertyViewState();
}

class _PropertyViewState extends State<PropertyView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 200),
    vsync: this,
  );
  late final Animation<Offset> _offsetAnimation = Tween<Offset>(
    begin: Offset.zero,
    end: const Offset(1.5, 0.0),
  ).animate(CurvedAnimation(parent: _controller, curve: Curves.bounceInOut));
  final _scrollController = ScrollController();

  double _size = 500;

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  bool pinned = false;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final isMobile = MediaQuery.of(context).size.width < _size;
      Selection? lastSelection;
      return BlocBuilder<CurrentIndexCubit, CurrentIndex>(
          buildWhen: (previous, current) =>
              previous.selection?.selected != current.selection?.selected,
          builder: (context, state) {
            var selection = state.selection;
            if (selection == null) {
              _controller.forward();
            } else if (selection.runtimeType.toString() !=
                lastSelection.runtimeType.toString()) {
              _controller.reset();
              _controller.reverse(from: 1);
            } else {
              lastSelection = selection;
              _controller.reverse();
            }
            selection ??= lastSelection;
            if (selection != null) {
              lastSelection = selection;
            }
            if (selection == null) {
              return Container();
            }
            return StatefulBuilder(builder: (context, setState) {
              return Stack(children: [
                Listener(
                  behavior: pinned || state.selection == null
                      ? HitTestBehavior.translucent
                      : HitTestBehavior.opaque,
                  onPointerUp: (details) {
                    if (!pinned) _closeView();
                  },
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: SlideTransition(
                    position: _offsetAnimation,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      constraints:
                          BoxConstraints(maxWidth: _size, maxHeight: 500),
                      child: Material(
                        elevation: 6,
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        child: Row(children: [
                          if (!isMobile)
                            MouseRegion(
                              cursor: SystemMouseCursors.resizeLeftRight,
                              child: GestureDetector(
                                child: const PhosphorIcon(
                                    PhosphorIconsLight.dotsSixVertical),
                                onPanUpdate: (details) {
                                  final delta = details.delta.dx;
                                  setState(() {
                                    _size -= delta;
                                    _size = max(_size, 450);
                                  });
                                },
                              ),
                            ),
                          Expanded(child: Builder(builder: (context) {
                            final help = selection!.help;
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Header(
                                  title:
                                      Text(selection.getLocalizedName(context)),
                                  leading: PhosphorIcon(selection.icon(
                                      selection.selected.length > 1
                                          ? PhosphorIconsStyle.fill
                                          : PhosphorIconsStyle.light)),
                                  actions: [
                                    if (selection.showDeleteButton)
                                      IconButton(
                                          icon: const PhosphorIcon(
                                              PhosphorIconsLight.trash),
                                          onPressed: () {
                                            selection?.onDelete(context);
                                            context
                                                .read<CurrentIndexCubit>()
                                                .resetSelection();
                                          }),
                                    if (help.isNotEmpty)
                                      IconButton(
                                        tooltip:
                                            AppLocalizations.of(context).help,
                                        icon: const PhosphorIcon(
                                            PhosphorIconsLight.sealQuestion),
                                        onPressed: () => openHelp(help),
                                      ),
                                    const SizedBox(
                                        height: 16, child: VerticalDivider()),
                                    if (!isMobile)
                                      IconButton(
                                        tooltip: pinned
                                            ? AppLocalizations.of(context).unpin
                                            : AppLocalizations.of(context).pin,
                                        icon: pinned
                                            ? const PhosphorIcon(
                                                PhosphorIconsFill.mapPin)
                                            : const PhosphorIcon(
                                                PhosphorIconsLight.mapPin),
                                        onPressed: () =>
                                            setState(() => pinned = !pinned),
                                      ),
                                    IconButton(
                                      tooltip:
                                          AppLocalizations.of(context).close,
                                      icon: const PhosphorIcon(
                                          PhosphorIconsLight.x),
                                      onPressed: _closeView,
                                    ),
                                  ],
                                ),
                                Flexible(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 16),
                                    child: ListView(
                                        shrinkWrap: true,
                                        primary: true,
                                        children:
                                            selection.buildProperties(context)),
                                  ),
                                ),
                              ],
                            );
                          })),
                        ]),
                      ),
                    ),
                  ),
                ),
              ]);
            });
          });
    });
  }

  void _closeView() {
    context.read<CurrentIndexCubit>().resetSelection();
  }
}
