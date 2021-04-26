import 'package:butterfly/widgets/split/core.dart';
import 'package:butterfly/pad/bloc/document_bloc.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'type.dart';

enum MoveToolType { location, rotation, scale }

class MoveTool extends Tool {
  final MoveToolType moveToolType;
  MoveTool({this.moveToolType = MoveToolType.location});
  @override
  Widget buildInspector(DocumentBloc bloc) {
    return ListView(children: [
      ExpansionTile(
          title: Text(
            'Location',
          ),
          initiallyExpanded: true,
          childrenPadding: EdgeInsets.symmetric(horizontal: 10),
          children: <Widget>[
            TextField(decoration: InputDecoration(labelText: "X")),
            TextField(decoration: InputDecoration(labelText: "Y")),
            TextField(decoration: InputDecoration(labelText: "Z")),
          ]),
      ExpansionTile(
          title: Text(
            'Rotation',
          ),
          initiallyExpanded: true,
          childrenPadding: EdgeInsets.symmetric(horizontal: 10),
          children: <Widget>[
            TextField(decoration: InputDecoration(labelText: "X")),
            TextField(decoration: InputDecoration(labelText: "Y")),
            TextField(decoration: InputDecoration(labelText: "Z")),
          ]),
      ExpansionTile(
          title: Text(
            'Scale',
          ),
          childrenPadding: EdgeInsets.symmetric(horizontal: 10),
          initiallyExpanded: true,
          children: <Widget>[
            TextField(decoration: InputDecoration(labelText: "Height")),
            TextField(decoration: InputDecoration(labelText: "Width")),
          ])
    ]);
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
      IconButton(
          icon: Icon(MdiIcons.crosshairs),
          tooltip: "Location",
          color: moveToolType == MoveToolType.location ? Theme.of(context!).primaryColor : null,
          onPressed: () => bloc!.add(ToolChanged(MoveTool(moveToolType: MoveToolType.location)))),
      IconButton(
          icon: Icon(MdiIcons.formatRotate90),
          tooltip: "Rotation",
          color: moveToolType == MoveToolType.rotation ? Theme.of(context!).primaryColor : null,
          onPressed: () => bloc!.add(ToolChanged(MoveTool(moveToolType: MoveToolType.rotation)))),
      IconButton(
          icon: Icon(MdiIcons.resize),
          tooltip: "Scale",
          color: moveToolType == MoveToolType.scale ? Theme.of(context!).primaryColor : null,
          onPressed: () => bloc!.add(ToolChanged(MoveTool(moveToolType: MoveToolType.scale))))
    ];
  }

  @override
  IconData get icon => MdiIcons.cursorMove;

  @override
  ToolType get type => ToolType.move;

  @override
  String get name => "Move";

  @override
  List<Object> get props => [type, moveToolType];
}
