import 'package:butterfly/cubits/current_index.dart';
import 'package:butterfly/handlers/handler.dart';
import 'package:butterfly/helpers/color_helper.dart';
import 'package:butterfly/services/import.dart';
import 'package:butterfly/visualizer/element.dart';
import 'package:butterfly/visualizer/tool.dart';
import 'package:butterfly/visualizer/property.dart';
import 'package:butterfly_api/butterfly_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:material_leap/material_leap.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../api/open.dart';
import '../../bloc/document_bloc.dart';

class AddDialog extends StatelessWidget {
  final TextEditingController _searchController = TextEditingController();

  AddDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<DocumentBloc>();
    final currentIndexCubit = context.read<CurrentIndexCubit>();
    void addTool(Tool tool) {
      final state = bloc.state;
      if (state is! DocumentLoaded) return;
      final background =
          state.page.backgrounds.firstOrNull?.defaultColor ?? kColorWhite;
      final defaultTool = updateToolDefaultColor(tool, background);
      bloc.add(ToolCreated(defaultTool));
      Navigator.of(context).pop();
    }

    Widget buildTool(Tool tool) {
      final caption = tool.getLocalizedCaption(context);
      final handler = Handler.fromTool(tool);
      final color =
          handler.getStatus(context.read<DocumentBloc>()) == ToolStatus.disabled
              ? Theme.of(context).disabledColor
              : null;
      return BoxTile(
        title: Text(
          tool.getLocalizedName(context),
          textAlign: TextAlign.center,
        ),
        size: tool.isAction() ? 110 : 100,
        subtitle: caption.isEmpty ? null : Text(caption),
        icon: Stack(
          alignment: Alignment.topCenter,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: PhosphorIcon(
                tool.icon(PhosphorIconsStyle.light),
                color: color,
                size: tool.isAction() ? 38 : 32,
              ),
            ),
            if (tool.isAction())
              Align(
                alignment: Alignment.bottomRight,
                child: IconButton(
                  onPressed: () =>
                      handler.onSelected(bloc, currentIndexCubit, false),
                  icon: const PhosphorIcon(PhosphorIconsLight.playCircle),
                  tooltip: AppLocalizations.of(context).play,
                ),
              ),
          ],
        ),
        onTap: () => addTool(tool),
      );
    }

    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(AppLocalizations.of(context).add),
          Flexible(
              child: SearchBar(
            constraints: const BoxConstraints(maxWidth: 200, minHeight: 50),
            leading: const PhosphorIcon(PhosphorIconsLight.magnifyingGlass),
            hintText: AppLocalizations.of(context).search,
            controller: _searchController,
          )),
          IconButton(
            onPressed: () => openHelp(['add']),
            icon: const PhosphorIcon(PhosphorIconsLight.sealQuestion),
            tooltip: AppLocalizations.of(context).help,
          ),
        ],
      ),
      scrollable: true,
      actions: [
        TextButton(
          child: Text(AppLocalizations.of(context).cancel),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
      content: SizedBox(
        width: 1000,
        child: Material(
          color: Colors.transparent,
          child: ValueListenableBuilder(
              valueListenable: _searchController,
              builder: (context, value, _) {
                final search = value.text;
                final imports = ImportType.values
                    .where((e) => e.isAvailable())
                    .where((e) => e
                        .getLocalizedName(context)
                        .toLowerCase()
                        .contains(search.toLowerCase()))
                    .toList();
                final tools = [
                  Tool.hand,
                  () => Tool.select(mode: SelectMode.lasso),
                  () => Tool.select(mode: SelectMode.rectangle),
                  Tool.pen,
                  Tool.stamp,
                  Tool.laser,
                  Tool.pathEraser,
                  Tool.label,
                  Tool.eraser,
                  Tool.layer,
                  Tool.area,
                  Tool.presentation,
                  () => Tool.spacer(axis: Axis2D.vertical),
                  () => Tool.spacer(axis: Axis2D.horizontal),
                  Tool.eyeDropper,
                ]
                    .map((e) => e())
                    .where((e) => e
                        .getLocalizedName(context)
                        .toLowerCase()
                        .contains(search.toLowerCase()))
                    .toList();
                final shapes = [
                  PathShape.circle,
                  PathShape.rectangle,
                  PathShape.line,
                ]
                    .map((e) => e())
                    .where((e) => e
                        .getLocalizedName(context)
                        .toLowerCase()
                        .contains(search.toLowerCase()))
                    .toList();
                final textures = [SurfaceTexture.pattern]
                    .map((e) => e())
                    .where((e) => e
                        .getLocalizedName(context)
                        .toLowerCase()
                        .contains(search.toLowerCase()))
                    .toList();
                final actions = [
                  Tool.undo,
                  Tool.redo,
                  Tool.fullSceen,
                ]
                    .map((e) => e())
                    .where((e) => e
                        .getLocalizedName(context)
                        .toLowerCase()
                        .contains(search.toLowerCase()))
                    .toList();
                return BlocBuilder<DocumentBloc, DocumentState>(
                    builder: (context, state) => Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            if (imports.isNotEmpty) ...[
                              Text(
                                AppLocalizations.of(context).import,
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              const SizedBox(height: 16),
                              Wrap(
                                alignment: WrapAlignment.start,
                                children: imports
                                    .map(
                                      (e) => BoxTile(
                                        size: 128,
                                        title: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              e.getLocalizedName(context),
                                              textAlign: TextAlign.center,
                                            ),
                                            const SizedBox(width: 8),
                                            IconButton(
                                              onPressed: () => addTool(
                                                  Tool.asset(importType: e)),
                                              tooltip:
                                                  AppLocalizations.of(context)
                                                      .pin,
                                              icon: const PhosphorIcon(
                                                  PhosphorIconsLight.pushPin),
                                            ),
                                          ],
                                        ),
                                        icon: PhosphorIcon(
                                            e.icon(PhosphorIconsStyle.light)),
                                        onTap: () async {
                                          final bloc =
                                              context.read<DocumentBloc>();
                                          final importService =
                                              context.read<ImportService>();
                                          Navigator.of(context).pop();
                                          await showImportAssetWizard(
                                              e, context, bloc, importService);
                                        },
                                      ),
                                    )
                                    .toList(),
                              ),
                              const SizedBox(height: 32),
                            ],
                            if (tools.isNotEmpty) ...[
                              Text(
                                AppLocalizations.of(context).tools,
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              const SizedBox(height: 16),
                              Wrap(
                                alignment: WrapAlignment.start,
                                children: tools.map(buildTool).toList(),
                              ),
                              const SizedBox(height: 32),
                            ],
                            if (shapes.isNotEmpty || textures.isNotEmpty) ...[
                              Text(
                                AppLocalizations.of(context).surface,
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              const SizedBox(height: 16),
                              Wrap(
                                alignment: WrapAlignment.start,
                                children: [
                                  ...shapes.map((e) => BoxTile(
                                        title: Text(
                                          e.getLocalizedName(context),
                                          textAlign: TextAlign.center,
                                        ),
                                        icon: Icon(
                                            e.icon(PhosphorIconsStyle.light)),
                                        onTap: () => addTool(ShapeTool(
                                            property: ShapeProperty(shape: e))),
                                      )),
                                  ...textures.map((e) => BoxTile(
                                        title: Text(
                                          e.getLocalizedName(context),
                                          textAlign: TextAlign.center,
                                        ),
                                        icon: Icon(
                                            e.icon(PhosphorIconsStyle.light)),
                                        onTap: () =>
                                            addTool(TextureTool(texture: e)),
                                      )),
                                ],
                              ),
                              const SizedBox(height: 32),
                            ],
                            if (actions.isNotEmpty) ...[
                              Text(
                                AppLocalizations.of(context).actions,
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              const SizedBox(height: 16),
                              Wrap(
                                alignment: WrapAlignment.start,
                                children: actions.map(buildTool).toList(),
                              ),
                            ],
                          ],
                        ));
              }),
        ),
      ),
    );
  }
}
