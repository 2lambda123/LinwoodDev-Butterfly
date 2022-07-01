import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

typedef ContextMenuBuilder = Widget Function(
    BuildContext context, VoidCallback close);

class ContextMenu extends StatefulWidget {
  final Offset position;
  final ContextMenuBuilder builder;
  final VoidCallback close;
  final double maxWidth, maxHeight;

  const ContextMenu(
      {super.key,
      this.position = Offset.zero,
      required this.close,
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

  void _close() {
    if (!mounted) return;
    _controller.reverse().then<void>((_) {
      if (!mounted) return;
      widget.close();
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final width = constraints.maxWidth;
      final height = constraints.maxHeight;
      final x = widget.position.dx;
      final y = widget.position.dy;
      // Responsive context menu
      final maxWidth = min(width, widget.maxWidth);
      final maxHeight = min(height, widget.maxHeight);
      final xOffset = x + maxWidth > width ? width - maxWidth : x;
      final yOffset = y + maxHeight > height ? height - maxHeight : y;
      var current = widget.builder(context, _close);
      return Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              onTap: _close,
              child: Container(
                color: Colors.transparent,
              ),
            ),
          ),
          Positioned(
            left: xOffset,
            top: yOffset,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: maxWidth,
                maxHeight: maxHeight,
              ),
              child: ClipRect(
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0, -.5),
                          end: Offset.zero,
                        ).animate(_animation),
                        transformHitTests: false,
                        child: Material(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: current),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    });
  }
}

Future<void> showContextMenu(
    {required BuildContext context,
    Offset position = Offset.zero,
    required ContextMenuBuilder builder,
    double maxHeight = 200,
    double maxWidth = 300}) async {
  var completer = Completer<void>();
  final overlayState = Overlay.of(context);
  late OverlayEntry overlayEntry;
  final navigator = Navigator(
    onGenerateRoute: (settings) => MaterialPageRoute(
      builder: (context) => ContextMenu(
          position: position,
          close: () {
            overlayEntry.remove();
            completer.complete();
          },
          builder: builder),
    ),
  );
  overlayEntry =
      OverlayEntry(maintainState: true, builder: (context) => navigator);
  overlayState?.insert(overlayEntry);
  if (overlayState != null) {
    return completer.future;
  }
}
