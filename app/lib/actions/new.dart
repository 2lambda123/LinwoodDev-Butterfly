import 'package:butterfly/bloc/document_bloc.dart';
import 'package:butterfly/cubits/settings.dart';
import 'package:butterfly_api/butterfly_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../dialogs/template.dart';

class NewIntent extends Intent {
  final BuildContext context;
  final bool fromTemplate;

  const NewIntent(this.context, {this.fromTemplate = false});
}

class NewAction extends Action<NewIntent> {
  NewAction();

  @override
  Future<void> invoke(NewIntent intent) async {
    final context = intent.context;
    final bloc = context.read<DocumentBloc>();
    final settingsCubit = context.read<SettingsCubit>();
    final settings = settingsCubit.state;
    if (intent.fromTemplate && context.mounted) {
      await showDialog(
        context: context,
        builder: (context) => TemplateDialog(bloc: bloc),
      );
      return;
    }
    final templateSystem = settings.getDefaultTemplateFileSystem();
    final template = await templateSystem.getDefaultTemplate(
      templateSystem.remote?.defaultTemplate ?? settings.defaultTemplate,
    );
    openNewDocument(context, template);
  }
}

void openNewDocument(BuildContext context,
    [NoteData? template, String? remote]) {
  NoteData? document;
  String? path;
  if (template != null) {
    document = template.createDocument();
    final metadata = document.getMetadata();
    if (metadata != null) {
      path = metadata.directory;
    }
  }
  GoRouter.of(context).pushReplacementNamed('new',
      queryParameters: {'path': path, 'remote': remote}, extra: document);
}
