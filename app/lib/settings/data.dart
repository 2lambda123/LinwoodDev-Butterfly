import 'package:archive/archive.dart';
import 'package:butterfly/api/file_system/file_system_io.dart';
import 'package:butterfly/api/save_data.dart';
import 'package:butterfly/bloc/document_bloc.dart';
import 'package:butterfly/cubits/settings.dart';
import 'package:butterfly/widgets/window.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../api/file_system/file_system.dart';
import '../dialogs/packs/dialog.dart';

class DataSettingsPage extends StatefulWidget {
  final bool inView;
  const DataSettingsPage({super.key, this.inView = false});

  @override
  State<DataSettingsPage> createState() => _DataSettingsPageState();
}

class _DataSettingsPageState extends State<DataSettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: widget.inView ? Colors.transparent : null,
        appBar: WindowTitleBar(
          inView: widget.inView,
          backgroundColor: widget.inView ? Colors.transparent : null,
          title: Text(AppLocalizations.of(context).data),
        ),
        body: BlocBuilder<SettingsCubit, ButterflySettings>(
            builder: (context, state) {
          return ListView(
            children: [
              Card(
                margin: const EdgeInsets.all(8),
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (!kIsWeb)
                          ListTile(
                            title: Text(
                                AppLocalizations.of(context).documentDirectory),
                            leading:
                                const PhosphorIcon(PhosphorIconsLight.folder),
                            subtitle: state.documentPath.isNotEmpty
                                ? FutureBuilder<String>(
                                    future: getButterflyDirectory(true),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        return Text(snapshot.data!);
                                      }
                                      return const SizedBox(
                                        height: 16,
                                        width: 16,
                                        child: CircularProgressIndicator(),
                                      );
                                    },
                                  )
                                : Text(
                                    AppLocalizations.of(context).defaultPath),
                            onTap: () async {
                              final settingsCubit =
                                  context.read<SettingsCubit>();
                              final selectedDir =
                                  await FilePicker.platform.getDirectoryPath();
                              if (selectedDir != null) {
                                _changePath(settingsCubit, selectedDir);
                              }
                            },
                            trailing: state.documentPath.isNotEmpty
                                ? IconButton(
                                    icon: const PhosphorIcon(
                                        PhosphorIconsLight.trash),
                                    onPressed: () => _changePath(
                                        context.read<SettingsCubit>(), ''),
                                  )
                                : null,
                          ),
                        ListTile(
                          title: Text(AppLocalizations.of(context).packs),
                          leading:
                              const PhosphorIcon(PhosphorIconsLight.package),
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (ctx) => MultiBlocProvider(
                                providers: [
                                  BlocProvider.value(
                                      value: context.read<SettingsCubit>()),
                                  BlocProvider(
                                    lazy: false,
                                    create: (ctx) => DocumentBloc.placeholder(
                                        context.read<SettingsCubit>()),
                                  ),
                                ],
                                child: const PacksDialog(globalOnly: true),
                              ),
                            );
                          },
                        ),
                        ListTile(
                          title: Text(AppLocalizations.of(context).export),
                          leading:
                              const PhosphorIcon(PhosphorIconsLight.export),
                          onTap: () async {
                            final fileSystem =
                                DocumentFileSystem.fromPlatform();
                            final directory =
                                await fileSystem.getRootDirectory();
                            final archive = exportDirectory(directory);
                            final encoder = ZipEncoder();
                            final bytes = encoder.encode(archive);
                            if (bytes != null) {
                              exportZip(context, bytes);
                            }
                          },
                        ),
                      ]),
                ),
              ),
            ],
          );
        }));
  }

  Future<void> _changePath(SettingsCubit settingsCubit, String newPath) async {
    final oldPath = settingsCubit.state.documentPath;
    if (!(await DocumentFileSystem.fromPlatform()
        .moveAbsolute(oldPath, newPath))) {
      return;
    }
    settingsCubit.changeDocumentPath(newPath);
  }
}
