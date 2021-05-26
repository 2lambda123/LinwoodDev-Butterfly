import 'package:butterfly/models/tools/type.dart';
import 'package:butterfly/pad/views/inspector.dart';
import 'package:butterfly/pad/views/layers.dart';
import 'package:butterfly/pad/views/project.dart';
import 'package:butterfly/widgets/split/core.dart';
import 'package:butterfly/pad/bloc/document_bloc.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class ViewTool extends Tool {
  const ViewTool();
  @override
  Widget buildInspector(DocumentBloc bloc) {
    return (bloc.state as DocumentLoadSuccess).currentSelected!.buildInspector(bloc);
  }

  @override
  List<Widget> buildOptions(
      {BuildContext? context,
      DocumentBloc? bloc,
      bool? expanded,
      bool? isMobile,
      SplitWindow? window,
      SplitView? view}) {
    return [
      if (isMobile!) ...[
        IconButton(
            icon: Icon(PhosphorIcons.cubeLight),
            onPressed: () =>
                Navigator.of(context!).push(MaterialPageRoute(builder: (context) => LayersView()))),
        IconButton(
            icon: Icon(PhosphorIcons.fadersLight),
            onPressed: () => Navigator.of(context!)
                .push(MaterialPageRoute(builder: (context) => InspectorView()))),
        IconButton(
            icon: Icon(PhosphorIcons.rowsLight),
            onPressed: () =>
                Navigator.of(context!).push(MaterialPageRoute(builder: (context) => ProjectView())))
      ] else ...[
        IconButton(
            icon: Icon(expanded! ? PhosphorIcons.arrowsInLight : PhosphorIcons.arrowsOutLight),
            tooltip: expanded ? 'Minimize' : 'Maximize',
            onPressed: expanded
                ? Navigator.of(context!).pop
                : () => window!.expand(context!, view, window))
      ],
      VerticalDivider(),
      IconButton(
          icon: Icon(PhosphorIcons.magnifyingGlassPlusLight), tooltip: "Zoom in", onPressed: () {}),
      IconButton(
          icon: Icon(PhosphorIcons.magnifyingGlassLight), tooltip: "Reset zoom", onPressed: () {}),
      IconButton(
          icon: Icon(PhosphorIcons.magnifyingGlassMinusLight),
          tooltip: "Zoom out",
          onPressed: () {}),
      VerticalDivider(),
      IconButton(
          icon: Icon(PhosphorIcons.arrowSquareOutLight), tooltip: "Export", onPressed: () {}),
      IconButton(icon: Icon(PhosphorIcons.printerLight), tooltip: "Print", onPressed: () {}),
      IconButton(
          icon: Icon(PhosphorIcons.monitorPlayLight), tooltip: "Presentation", onPressed: () {}),
      VerticalDivider(),
      IconButton(
          icon: Icon(PhosphorIcons.mapPinLight),
          tooltip: "Focus in project view",
          onPressed: () {}),
    ];
  }

  @override
  IconData get icon => PhosphorIcons.cursorLight;

  @override
  ToolType get type => ToolType.view;

  @override
  String get name => "View";
}
