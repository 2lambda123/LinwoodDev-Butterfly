import 'package:butterfly/bloc/document_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class LayerDialog extends StatelessWidget {
  final String layer;
  final bool popupMenu;
  const LayerDialog({super.key, required this.layer, this.popupMenu = false});

  @override
  Widget build(BuildContext context) {
    if (popupMenu) {
      return PopupMenuButton(
          itemBuilder: (context) => _buildListTiles(context)
              .map((e) => PopupMenuItem(padding: EdgeInsets.zero, child: e))
              .toList());
    }
    return AlertDialog(
      title: Row(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Icon(PhosphorIcons.squaresFourLight),
          ),
          Text(layer),
        ],
      ),
      content: Column(
          mainAxisSize: MainAxisSize.min, children: _buildListTiles(context)),
      actions: [
        TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(AppLocalizations.of(context)!.cancel)),
      ],
    );
  }

  List<Widget> _buildListTiles(BuildContext context) => [
        ListTile(
          title: Text(AppLocalizations.of(context)!.rename),
          leading: const Icon(PhosphorIcons.textTLight),
          onTap: () async {
            final bloc = context.read<DocumentBloc>();
            final nameController = TextEditingController(text: layer);
            final success = await showDialog<bool>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                          title: Text(AppLocalizations.of(ctx)!.rename),
                          content: TextField(
                            controller: nameController,
                            autofocus: true,
                            onSubmitted: (value) => Navigator.of(ctx).pop(true),
                            decoration: InputDecoration(
                                filled: true,
                                hintText: AppLocalizations.of(context)!.name),
                          ),
                          actions: [
                            TextButton(
                              child: Text(AppLocalizations.of(ctx)!.cancel),
                              onPressed: () => Navigator.of(ctx).pop(false),
                            ),
                            ElevatedButton(
                              child: Text(AppLocalizations.of(ctx)!.ok),
                              onPressed: () => Navigator.of(ctx).pop(true),
                            ),
                          ],
                        )) ??
                false;
            if (!success) return;
            if (nameController.text != layer) {
              bloc.add(LayerRenamed(layer, nameController.text));
            }
          },
        ),
        ListTile(
          title: Text(AppLocalizations.of(context)!.deleteElements),
          leading: const Icon(PhosphorIcons.trashLight),
          onTap: () {
            showDialog<void>(
                context: context,
                builder: (ctx) => AlertDialog(
                      title: Text(AppLocalizations.of(ctx)!.deleteElements),
                      content:
                          Text(AppLocalizations.of(ctx)!.deleteElementsConfirm),
                      actions: [
                        TextButton(
                          child: Text(AppLocalizations.of(ctx)!.no),
                          onPressed: () => Navigator.pop(ctx),
                        ),
                        ElevatedButton(
                          child: Text(AppLocalizations.of(ctx)!.yes),
                          onPressed: () {
                            Navigator.pop(ctx);
                            context
                                .read<DocumentBloc>()
                                .add(LayerElementsDeleted(layer));
                            Navigator.pop(ctx);
                          },
                        ),
                      ],
                    ));
          },
        ),
        ListTile(
          title: Text(AppLocalizations.of(context)!.remove),
          leading: const Icon(PhosphorIcons.xLight),
          onTap: () {
            context.read<DocumentBloc>().add(LayerRemoved(layer));
            Navigator.pop(context);
          },
        ),
      ];
}
