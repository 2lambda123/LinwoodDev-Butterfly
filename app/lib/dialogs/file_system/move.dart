import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../api/file_system.dart';
import '../../models/document.dart';
import 'tree.dart';

enum MoveMode { duplicate, move }

class FileSystemAssetMoveDialog extends StatefulWidget {
  final MoveMode? moveMode;
  final AppDocumentEntity asset;
  final DocumentFileSystem fileSystem;
  const FileSystemAssetMoveDialog(
      {super.key,
      this.moveMode,
      required this.asset,
      required this.fileSystem});

  @override
  State<FileSystemAssetMoveDialog> createState() =>
      _FileSystemAssetMoveDialogState();
}

class _FileSystemAssetMoveDialogState extends State<FileSystemAssetMoveDialog> {
  final TextEditingController _nameController = TextEditingController();
  late String selectedPath;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.asset.fileName;
    selectedPath = widget.asset.parent;
  }

  Future<void> _move(bool duplicate) async {
    final navigator = Navigator.of(context);
    var newPath = selectedPath;
    if (selectedPath != '/') {
      newPath += '/';
    }
    newPath += _nameController.text;
    if (duplicate) {
      await widget.fileSystem
          .duplicateAsset(widget.asset.pathWithLeadingSlash, newPath);
    } else {
      await widget.fileSystem
          .moveAsset(widget.asset.pathWithLeadingSlash, newPath);
    }
    navigator.pop(newPath);
  }

  @override
  Widget build(BuildContext context) {
    String title;
    switch (widget.moveMode) {
      case MoveMode.duplicate:
        title = AppLocalizations.of(context)!.duplicate;
        break;
      case MoveMode.move:
        title = AppLocalizations.of(context)!.move;
        break;
      default:
        title = AppLocalizations.of(context)!.changeDocumentPath;
    }
    return AlertDialog(
        actions: [
          TextButton(
            child: Text(AppLocalizations.of(context)!.cancel),
            onPressed: () => Navigator.of(context).pop(),
          ),
          if (widget.moveMode != null)
            ElevatedButton(
              child: Text(AppLocalizations.of(context)!.ok),
              onPressed: () => _move(widget.moveMode == MoveMode.duplicate),
            ),
          if (widget.moveMode == null) ...[
            ElevatedButton(
                onPressed: () => _move(true),
                child: Text(AppLocalizations.of(context)!.duplicate)),
            ElevatedButton(
                onPressed: () => _move(false),
                child: Text(AppLocalizations.of(context)!.move)),
          ]
        ],
        title: Text(title),
        scrollable: true,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FileSystemDirectoryTreeView(
              fileSystem: widget.fileSystem,
              path: '/',
              onPathSelected: (path) => selectedPath = path,
              initialExpanded: true,
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                  filled: true, hintText: AppLocalizations.of(context)!.name),
              autofocus: true,
              controller: _nameController,
            ),
          ],
        ));
  }
}
