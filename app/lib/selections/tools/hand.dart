part of '../selection.dart';

class HandSelection extends ToolSelection<HandTool> {
  HandSelection(super.selected);

  @override
  List<Widget> buildProperties(BuildContext context) {
    final state = context.read<DocumentBloc>().state;
    if (state is! DocumentLoadSuccess) return [];

    return [];
  }
}
