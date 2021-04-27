import 'package:butterfly/pad/bloc/document_bloc.dart';
import 'package:butterfly/pad/dialogs/create_layer.dart';
import 'package:butterfly/widgets/split/core.dart';
import 'package:butterfly/widgets/split/scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:butterfly/models/elements/type.dart';

class LayersView extends StatefulWidget {
  final SplitView? view;
  final SplitWindow? window;
  final bool? expanded;

  const LayersView({Key? key, this.view, this.window, this.expanded}) : super(key: key);
  @override
  _LayersViewState createState() => _LayersViewState();
}

class _LayersViewState extends State<LayersView> {
  @override
  Widget build(BuildContext context) {
    // ignore: close_sinks
    var bloc = BlocProvider.of<DocumentBloc>(context);
    return Hero(
        tag: 'layers_view',
        child: SplitScaffold(
            bloc: bloc,
            view: widget.view,
            window: widget.window,
            expanded: widget.expanded,
            title: "Layers",
            icon: MdiIcons.cubeOutline,
            floatingActionButton: FloatingActionButton(
                heroTag: null,
                onPressed: () {
                  if ((bloc.state as DocumentLoadSuccess).currentPad != null)
                    showDialog(
                        builder: (context) => BlocProvider.value(
                            value: bloc,
                            child: CreateLayerDialog(
                                parent: (bloc.state as DocumentLoadSuccess).currentPad!.root)),
                        context: context);
                },
                child: Icon(MdiIcons.plus),
                tooltip: "Create layer"),
            body: Navigator(
                onGenerateRoute: (settings) => MaterialPageRoute(
                    builder: (context) => Container(
                        alignment: Alignment.center,
                        child: BlocBuilder<DocumentBloc, DocumentState>(builder: (context, state) {
                          if (state is DocumentLoadSuccess &&
                              state.currentPad != null &&
                              state.currentPad!.root != null) {
                            return ListView.builder(
                                itemCount: state.currentPad!.root!.children.length,
                                itemBuilder: (BuildContext context, int index) {
                                  var current = state.currentPad!.root!.children[index]!;
                                  return ListTile(
                                    title: Text(current.name!),
                                    subtitle: Text(current.type.name),
                                    leading: Icon(current.type.icon),
                                    selected: state.currentLayer == current,
                                    onTap: () => bloc.add(LayerChanged(
                                        state.currentLayer == current ? null : current)),
                                  );
                                });
                          } else
                            return Text("No pad selected");
                        }))))));
  }
}
