import 'package:butterfly/models/elements/document.dart';
import 'package:butterfly/pad/bloc/document_bloc.dart';
import 'package:butterfly/pad/dialogs/create_layer.dart';
import 'package:butterfly/widgets/split/core.dart';
import 'package:butterfly/widgets/split/scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mdi/mdi.dart';

class LayersView extends StatefulWidget {
  final DocumentBloc documentBloc;
  final SplitView view;
  final SplitWindow window;
  final bool expanded;

  const LayersView({Key key, this.documentBloc, this.view, this.window, this.expanded})
      : super(key: key);
  @override
  _LayersViewState createState() => _LayersViewState();
}

class _LayersViewState extends State<LayersView> {
  // ignore: close_sinks
  DocumentBloc _bloc;

  @override
  void initState() {
    _bloc = widget.documentBloc;
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) => _bloc,
        child: SplitScaffold(
            view: widget.view,
            window: widget.window,
            expanded: widget.expanded,
            title: "Layers",
            icon: Icon(Mdi.cubeOutline),
            floatingActionButton: FloatingActionButton(
                onPressed: () => showDialog(
                    builder: (context) => CreateLayerDialog(documentBloc: widget.documentBloc),
                    context: context),
                child: Icon(Mdi.plus),
                tooltip: "Create layer"),
            body: Container(
                child: BlocBuilder<DocumentBloc, DocumentState>(builder: (context, state) {
              print("state updated!");
              if (state is DocumentLoadSuccess && state.document.root != null) {
                var document = state.document;
                return ListView.builder(
                    itemCount: document.root.children.length,
                    itemBuilder: (BuildContext context, int index) => Builder(
                        builder: (context) =>
                            document.root.children[index].buildTile(context, document)));
              } else
                return CircularProgressIndicator();
            }))));
  }
}
