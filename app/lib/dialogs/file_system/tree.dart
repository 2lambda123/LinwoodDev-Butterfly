import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../api/file_system.dart';
import '../../models/document.dart';

typedef PathSelectedCallback = void Function(String path);

class FileSystemDirectoryTreeView extends StatefulWidget {
  final String path, selectedPath;
  final PathSelectedCallback onPathSelected;
  final bool initialExpanded;

  const FileSystemDirectoryTreeView(
      {Key? key,
      required this.path,
      required this.onPathSelected,
      this.initialExpanded = false,
      this.selectedPath = '/'})
      : super(key: key);

  @override
  FileSystemDirectoryTreeViewState createState() =>
      FileSystemDirectoryTreeViewState();
}

class FileSystemDirectoryTreeViewState
    extends State<FileSystemDirectoryTreeView> {
  late DocumentFileSystem _fileSystem;
  bool _expanded = false;
  late Future<AppDocumentDirectory> _directoryFuture;
  String _selected = '/';

  @override
  void initState() {
    super.initState();
    _fileSystem = DocumentFileSystem.fromPlatform();
    _expanded = widget.initialExpanded;
    _selected = widget.selectedPath;
    _directoryFuture = load();
  }

  Future<AppDocumentDirectory> load() {
    return _fileSystem
        .getAsset(widget.path)
        .then((value) => value as AppDocumentDirectory);
  }

  @override
  void didUpdateWidget(covariant FileSystemDirectoryTreeView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.path != widget.path) {
      setState(() => _directoryFuture = load());
    }
    if (oldWidget.selectedPath != widget.selectedPath) {
      setState(() => _selected = widget.selectedPath);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<AppDocumentDirectory>(
        future: _directoryFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var directory = snapshot.data!;
            var children = directory.assets.whereType<AppDocumentDirectory>();
            var name = directory.path.split('/').last;
            if (name.isEmpty) {
              name = '/';
            }
            return Column(children: [
              ListTile(
                leading: _expanded
                    ? const Icon(PhosphorIcons.folderOpenLight)
                    : const Icon(PhosphorIcons.folderLight),
                title: Text(name),
                trailing: _selected == widget.path
                    ? const Icon(PhosphorIcons.check)
                    : null,
                onTap: () {
                  if (_selected == widget.path) {
                    setState(() {
                      _expanded = !_expanded;
                    });
                  } else {
                    setState(() {
                      _expanded = true;
                      _selected = widget.path;
                    });
                    widget.onPathSelected(directory.path);
                  }
                },
                selected: _selected == widget.path,
              ),
              if (_expanded)
                Padding(
                    padding: const EdgeInsets.only(left: 5.0),
                    child: Column(
                      children: List.generate(
                        children.length,
                        (index) {
                          var current = children.elementAt(index);
                          return FileSystemDirectoryTreeView(
                              path: current.path,
                              selectedPath: _selected,
                              onPathSelected: (value) {
                                setState(() {
                                  _selected = value;
                                  _expanded = true;
                                });
                                widget.onPathSelected(value);
                              });
                        },
                      ),
                    ))
            ]);
          }
          return Container();
        });
  }
}
