import 'package:butterfly/models/project/folder.dart';
import 'package:butterfly/pad/bloc/document_bloc.dart';
import 'package:butterfly/pad/dialogs/path.dart';
import 'package:butterfly/widgets/split/core.dart';
import 'package:butterfly/widgets/split/scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mdi/mdi.dart';

class ProjectView extends StatefulWidget {
  final DocumentBloc documentBloc;
  final SplitView view;
  final SplitWindow window;
  final bool expanded;

  const ProjectView({Key key, this.documentBloc, this.view, this.window, this.expanded})
      : super(key: key);
  @override
  _ProjectViewState createState() => _ProjectViewState();
}

class _ProjectViewState extends State<ProjectView> {
  // ignore: close_sinks
  DocumentBloc _bloc;

  @override
  void initState() {
    _bloc = widget.documentBloc;
    super.initState();
  }

  BuildContext _systemContext;

  @override
  Widget build(BuildContext context) {
    return Hero(
        tag: 'project_view',
        child: SplitScaffold(
            bloc: _bloc,
            view: widget.view,
            window: widget.window,
            expanded: widget.expanded,
            title: "Project",
            icon: Icon(Mdi.tableOfContents),
            actions: [
              IconButton(
                  icon: Icon(Mdi.homeOutline),
                  tooltip: "Home",
                  onPressed: () => Navigator.popUntil(_systemContext, (route) => route.isFirst)),
              IconButton(
                  icon: Icon(Mdi.arrowUp),
                  tooltip: "Up",
                  onPressed: () {
                    if (Navigator.canPop(_systemContext)) Navigator.pop(_systemContext);
                  }),
              IconButton(
                  icon: Icon(Mdi.magnify),
                  tooltip: "Path",
                  onPressed: () => showDialog(
                      context: context,
                      builder: (context) => FilePathDialog(
                          callback: (path) => Navigator.of(_systemContext).push(MaterialPageRoute(
                              builder: (_) => _ProjectViewSystem(bloc: _bloc, path: path)))))),
              IconButton(
                  icon: Icon(Mdi.reload), tooltip: "Reload", onPressed: () => setState(() {})),
              VerticalDivider()
            ],
            floatingActionButton: FloatingActionButton(
                heroTag: null,
                onPressed: () => _showNewSheet(context),
                child: Icon(Mdi.plus),
                tooltip: "New"),
            body: Navigator(
                onGenerateRoute: (settings) => MaterialPageRoute(builder: (context) {
                      _systemContext = context;
                      return _ProjectViewSystem(bloc: _bloc);
                    }))));
  }

  void _showNewSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (context) => Container(
            padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Text("Create", style: Theme.of(context).textTheme.headline5),
              ListTile(title: Text("Pad"), leading: Icon(Mdi.paletteOutline), onTap: () {}),
              Divider(),
              ListTile(title: Text("Import"), leading: Icon(Mdi.import), onTap: () {})
            ])));
  }
}

class _ProjectViewSystem extends StatelessWidget {
  final DocumentBloc bloc;
  final String path;

  const _ProjectViewSystem({Key key, this.bloc, this.path = ''}) : super(key: key);

  void _changeSelected(DocumentLoadSuccess state, String currentPath) {
    bloc.add(SelectedChanged(currentPath));
    bloc.add(InspectorChanged(state.document.getFile(currentPath)));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        child: BlocBuilder<DocumentBloc, DocumentState>(builder: (context, state) {
          if (state is DocumentLoadSuccess) {
            var file = state.document.getFile(path);
            if (file == null || !(file is FolderProjectItem))
              return Center(child: Text("Directory not found"));
            var folder = file as FolderProjectItem;
            return SizedBox.expand(
                child: SingleChildScrollView(
                    child: Wrap(
                        children: folder.files.map((file) {
              var currentPath = path.isNotEmpty ? path + '/' : '';
              currentPath += file.name;
              return Card(
                  child: InkWell(
                      onLongPress: () => _changeSelected(state, currentPath),
                      onTap: () {
                        if (file is FolderProjectItem) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      _ProjectViewSystem(bloc: bloc, path: currentPath)));
                        } else
                          _changeSelected(state, currentPath);
                      },
                      child: Container(
                          constraints: BoxConstraints(maxWidth: 200),
                          child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
                              child: Column(children: [
                                Icon(file.icon, size: 50),
                                Text(file.name, overflow: TextOverflow.ellipsis)
                              ])))));
            }).toList())));
          } else
            return CircularProgressIndicator();
        }));
  }
}
