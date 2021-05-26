import 'package:butterfly/widgets/split/core.dart';
import 'package:butterfly/pad/bloc/document_bloc.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

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
            Row(children: [
              Expanded(
                  child: TextField(
                      decoration: InputDecoration(labelText: "X"), textAlign: TextAlign.center)),
              Expanded(
                  child: TextField(
                      decoration: InputDecoration(labelText: "Y"), textAlign: TextAlign.center)),
              Expanded(
                  child: TextField(
                      decoration: InputDecoration(labelText: "Z"), textAlign: TextAlign.center)),
            ])
          ]),
      ExpansionTile(
          title: Text(
            'Rotation',
          ),
          initiallyExpanded: true,
          childrenPadding: EdgeInsets.symmetric(horizontal: 10),
          children: <Widget>[
            Row(children: [
              Expanded(
                  child: TextField(
                      decoration: InputDecoration(labelText: "X"), textAlign: TextAlign.center)),
              Expanded(
                  child: TextField(
                      decoration: InputDecoration(labelText: "Y"), textAlign: TextAlign.center)),
              Expanded(
                  child: TextField(
                      decoration: InputDecoration(labelText: "Z"), textAlign: TextAlign.center))
            ])
          ]),
      ExpansionTile(
          title: Text(
            'Scale',
          ),
          childrenPadding: EdgeInsets.symmetric(horizontal: 10),
          initiallyExpanded: true,
          children: <Widget>[
            Row(children: [
              Expanded(
                  child: TextField(
                      decoration: InputDecoration(labelText: "Height"),
                      textAlign: TextAlign.center)),
              Expanded(
                  child: TextField(
                      decoration: InputDecoration(labelText: "Width"), textAlign: TextAlign.center))
            ])
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
          icon: Icon(PhosphorIcons.arrowsOutCardinalLight),
          tooltip: "Location",
          color: moveToolType == MoveToolType.location ? Theme.of(context!).primaryColor : null,
          onPressed: () => bloc!.add(ToolChanged(MoveTool(moveToolType: MoveToolType.location)))),
      IconButton(
          icon: Icon(PhosphorIcons.arrowClockwiseLight),
          tooltip: "Rotation",
          color: moveToolType == MoveToolType.rotation ? Theme.of(context!).primaryColor : null,
          onPressed: () => bloc!.add(ToolChanged(MoveTool(moveToolType: MoveToolType.rotation)))),
      IconButton(
          icon: Icon(PhosphorIcons.arrowsOutSimpleLight),
          tooltip: "Scale",
          color: moveToolType == MoveToolType.scale ? Theme.of(context!).primaryColor : null,
          onPressed: () => bloc!.add(ToolChanged(MoveTool(moveToolType: MoveToolType.scale))))
    ];
  }

  @override
  IconData get icon => PhosphorIcons.cursorLight;

  @override
  ToolType get type => ToolType.move;

  @override
  String get name => "Move";

  @override
  List<Object> get props => [type, moveToolType];
}
