import 'package:butterfly/api/file_system.dart';
import 'package:butterfly/dialogs/file_system/dialog.dart';
import 'package:butterfly/dialogs/file_system/menu.dart';
import 'package:butterfly/visualizer/asset.dart';
import 'package:butterfly_api/butterfly_api.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import 'rich_text.dart';

class FileSystemGridView extends StatelessWidget {
  final AssetLocation? selectedPath;
  final List<AppDocumentEntity> assets;
  final AssetOpenedCallback onOpened;
  final VoidCallback onRefreshed;
  final DocumentFileSystem fileSystem;
  const FileSystemGridView(
      {super.key,
      required this.assets,
      required this.selectedPath,
      required this.onOpened,
      required this.onRefreshed,
      required this.fileSystem});

  @override
  Widget build(BuildContext context) {
    final files = assets.whereType<AppDocumentFile>().toList();
    final directories = assets.whereType<AppDocumentDirectory>().toList();
    return SingleChildScrollView(
        child: Scrollbar(
      child: Column(children: [
        Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: List.generate(directories.length, (index) {
              final directory = directories[index];
              return ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 300),
                  child: Card(
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(16))),
                      child: InkWell(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(16)),
                          onTap: () => onOpened(directory),
                          child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Row(children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 8.0),
                                      child: PhosphorIcon(
                                        PhosphorIcons.light.folder,
                                        size: 32,
                                      ),
                                    ),
                                    Expanded(
                                      child: Tooltip(
                                        message:
                                            directory.pathWithoutLeadingSlash,
                                        child: Text(directory.fileName,
                                            overflow: TextOverflow.ellipsis,
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleLarge),
                                      ),
                                    ),
                                    FileSystemAssetMenu(
                                      selectedPath: selectedPath,
                                      asset: directory,
                                      onOpened: onOpened,
                                      onRefreshed: onRefreshed,
                                      fileSystem: fileSystem,
                                    )
                                  ]),
                                ],
                              )))));
            })),
        Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: List.generate(files.length, (index) {
              final file = files[index];
              final info = file.getDocumentInfo();
              return ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 300),
                  child: Card(
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(16))),
                      child: InkWell(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(16)),
                          onTap: () => onOpened(file),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Row(children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: PhosphorIcon(
                                      file.fileType.getIcon(),
                                      size: 32,
                                    ),
                                  ),
                                  Expanded(
                                    child: Tooltip(
                                      message: file.pathWithoutLeadingSlash,
                                      child: Text(info?.name ?? file.fileName,
                                          overflow: TextOverflow.ellipsis,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleLarge
                                              ?.copyWith(
                                                  color: selectedPath ==
                                                          file.location
                                                      ? Theme.of(context)
                                                          .colorScheme
                                                          .primary
                                                      : null)),
                                    ),
                                  ),
                                  FileSystemAssetMenu(
                                      fileSystem: fileSystem,
                                      selectedPath: selectedPath,
                                      asset: file,
                                      onOpened: onOpened,
                                      onRefreshed: onRefreshed)
                                ]),
                                if (info != null)
                                  FileSystemFileRichText(
                                    file: file,
                                  ),
                              ],
                            ),
                          ))));
            })),
      ]),
    ));
  }
}
