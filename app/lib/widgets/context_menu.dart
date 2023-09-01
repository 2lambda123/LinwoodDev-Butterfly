import 'dart:async';
import 'dart:math';

import 'package:animations/animations.dart';
import 'package:butterfly/cubits/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

typedef ContextMenuBuilder = List<ContextMenuEntry> Function(
    BuildContext context);

sealed class ContextMenuEntry {
  final String label;
  final Widget icon;
  final MenuSerializableShortcut? shortcut;

  ContextMenuEntry({
    required this.label,
    required this.icon,
    this.shortcut,
  });
}

class ContextMenuItem extends ContextMenuEntry {
  final VoidCallback? onPressed;

  ContextMenuItem({
    required super.label,
    required super.icon,
    this.onPressed,
    super.shortcut,
  });
}

class ContextMenuGroup extends ContextMenuEntry {
  final List<Widget> children;

  ContextMenuGroup({
    required super.label,
    required super.icon,
    required this.children,
    super.shortcut,
  });
}

class ContextMenu extends StatefulWidget {
  final Offset position;
  final ContextMenuBuilder builder;
  final double maxWidth, maxHeight;

  const ContextMenu(
      {super.key,
      this.position = Offset.zero,
      required this.builder,
      this.maxHeight = 300,
      this.maxWidth = 300});

  @override
  State<ContextMenu> createState() => _ContextMenuState();
}

class _ContextMenuState extends State<ContextMenu>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.fastOutSlowIn,
    );
    _controller.forward();
  }

  late Animation<double> _animation;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile =
        context.read<SettingsCubit>().state.platformTheme.isMobile(context);
    final items = widget.builder(context);
    return CustomSingleChildLayout(
      delegate: DesktopTextSelectionToolbarLayoutDelegate(
        anchor: widget.position,
      ),
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, -.5),
          end: Offset.zero,
        ).animate(_animation),
        transformHitTests: false,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: widget.maxWidth,
            maxHeight: min(widget.maxHeight, isMobile ? 50 : double.infinity),
          ),
          child: Material(
            borderRadius: BorderRadius.circular(12),
            child: ListView(
              scrollDirection: isMobile ? Axis.horizontal : Axis.vertical,
              shrinkWrap: true,
              children: items.map((item) {
                Widget buildItemWidget(VoidCallback? onPressed) => IconButton(
                      icon: item.icon,
                      tooltip: item.label,
                      onPressed: onPressed,
                    );
                return switch (item) {
                  ContextMenuItem() => isMobile
                      ? buildItemWidget(item.onPressed)
                      : MenuItemButton(
                          leadingIcon: item.icon,
                          onPressed: item.onPressed,
                          child: Text(item.label),
                        ),
                  ContextMenuGroup() => isMobile
                      ? MenuAnchor(
                          menuChildren: item.children,
                          builder: (context, controller, child) =>
                              buildItemWidget(
                            () => controller.isOpen
                                ? controller.close()
                                : controller.open(),
                          ),
                        )
                      : SubmenuButton(
                          menuChildren: item.children,
                          leadingIcon: item.icon,
                          child: Text(item.label),
                        ),
                };
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}

Future<T?> showContextMenu<T>(
    {required BuildContext context,
    Offset position = Offset.zero,
    required ContextMenuBuilder builder,
    double maxHeight = 400,
    double maxWidth = 300}) async {
  final RenderBox box = context.findRenderObject() as RenderBox;
  final Offset globalPos = box.localToGlobal(position);
  AdaptiveTextSelectionToolbar;
  return showModal<T>(
      context: context,
      useRootNavigator: true,
      builder: (context) {
        return ContextMenu(
          position: globalPos,
          builder: builder,
          maxHeight: maxHeight,
          maxWidth: maxWidth,
        );
      });
}
