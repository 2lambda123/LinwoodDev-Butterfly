import 'package:butterfly/bloc/document_bloc.dart';
import 'package:butterfly/dialogs/area/context.dart';
import 'package:butterfly/dialogs/layer.dart';
import 'package:butterfly/models/element.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../cubits/transform.dart';
import '../../renderers/renderer.dart';
import '../../widgets/context_menu.dart';
import '../background/context.dart';

typedef ElementChangedCallback<T extends PadElement> = void Function(T element);
typedef ElementWidgetsBuilder<T extends PadElement> = List<Widget> Function(
    BuildContext context,
    Renderer<T> renderer,
    ElementChangedCallback<T> onChanged);

class GeneralElementDialog<T extends PadElement> extends StatefulWidget {
  final int index;
  final VoidCallback close;
  final Offset position;
  final ElementWidgetsBuilder<T>? builder;

  const GeneralElementDialog(
      {Key? key,
      required this.position,
      required this.index,
      required this.close,
      this.builder})
      : super(key: key);

  @override
  State<GeneralElementDialog<T>> createState() =>
      _GeneralElementDialogState<T>();
}

class _GeneralElementDialogState<T extends PadElement>
    extends State<GeneralElementDialog<T>> {
  late Renderer<T> renderer;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DocumentBloc, DocumentState>(builder: (context, state) {
      if (state is! DocumentLoadSuccess) return Container();
      final bloc = context.read<DocumentBloc>();
      final current = state.getRenderer(state.document.content[widget.index]);
      if (current is! Renderer<T>) return Container();
      renderer = current;
      final children = widget.builder == null
          ? null
          : widget.builder!(
              context,
              renderer,
              (current) => bloc.add(ElementChanged(
                  state.document.content[widget.index], current)));
      return Column(mainAxisSize: MainAxisSize.min, children: [
        _GeneralElementDialogHeader(
            close: widget.close, renderer: renderer, position: widget.position),
        const Divider(),
        Flexible(
            child: ListView(
          shrinkWrap: true,
          children: [
            if (children != null) ...children,
            if (children?.isNotEmpty ?? true) const Divider(),
            renderer.element.layer.isEmpty
                ? ListTile(
                    title: Text(AppLocalizations.of(context)!.layer),
                    leading: const Icon(PhosphorIcons.squaresFourLight),
                    subtitle: Text(AppLocalizations.of(context)!.notSet),
                    onTap: () {
                      widget.close();
                      var nameController =
                          TextEditingController(text: renderer.element.layer);
                      showDialog(
                          context: context,
                          useRootNavigator: true,
                          builder: (context) => AlertDialog(
                                title: Text(
                                    AppLocalizations.of(context)!.enterLayer),
                                content: TextField(
                                  controller: nameController,
                                  autofocus: true,
                                  decoration: InputDecoration(
                                      filled: true,
                                      hintText:
                                          AppLocalizations.of(context)!.name),
                                ),
                                actions: [
                                  TextButton(
                                    child: Text(
                                        AppLocalizations.of(context)!.cancel),
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                  ),
                                  TextButton(
                                    child:
                                        Text(AppLocalizations.of(context)!.ok),
                                    onPressed: () {
                                      bloc.add(ElementChanged(
                                          renderer.element,
                                          renderer.element.copyWith(
                                              layer: nameController.text)));
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              ));
                    })
                : ListTile(
                    leading: const Icon(PhosphorIcons.squaresFourLight),
                    title: Text(renderer.element.layer),
                    trailing: IconButton(
                      icon: const Icon(PhosphorIcons.trashLight),
                      onPressed: () => bloc.add(ElementChanged(renderer.element,
                          renderer.element.copyWith(layer: ''))),
                    ),
                    onTap: () {
                      widget.close();
                      showDialog(
                          context: context,
                          builder: (context) => BlocProvider.value(
                              value: bloc,
                              child:
                                  LayerDialog(layer: renderer.element.layer)));
                    }),
            ListTile(
              title: Text(AppLocalizations.of(context)!.move),
              leading: const Icon(PhosphorIcons.arrowsOutCardinalLight),
              onTap: () {
                // Remove the element from the document
                bloc.add(ElementsRemoved([renderer.element]));
                state.fetchHand()?.move(context, renderer);
                widget.close();
              },
            ),
            ListTile(
              title: Text(AppLocalizations.of(context)!.duplicate),
              leading: const Icon(PhosphorIcons.copyLight),
              onTap: () {
                state.fetchHand()?.move(context, renderer, true);
                widget.close();
              },
            ),
            ListTile(
                onTap: () {
                  widget.close();
                  bloc.add(ElementsRemoved([renderer.element]));
                },
                title: Text(AppLocalizations.of(context)!.delete),
                leading: const Icon(PhosphorIcons.trashLight)),
          ],
        ))
      ]);
    });
  }
}

class _GeneralElementDialogHeader extends StatelessWidget {
  final Renderer renderer;
  final Offset position;
  final VoidCallback close;
  const _GeneralElementDialogHeader(
      {Key? key,
      required this.renderer,
      this.position = Offset.zero,
      required this.close})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    IconData icon;
    switch (renderer.element.toJson()['type']) {
      case 'label':
        icon = PhosphorIcons.textTLight;
        break;
      case 'image':
        icon = PhosphorIcons.imageLight;
        break;
      case 'eraser':
        icon = PhosphorIcons.eraserLight;
        break;
      default:
        icon = PhosphorIcons.penLight;
        break;
    }

    var bloc = context.read<DocumentBloc>();
    var transformCubit = context.read<TransformCubit>();
    return Container(
      height: 75,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Icon(
            icon,
            size: 32,
          ),
        ),
        Row(children: [
          if (renderer.area != null)
            IconButton(
              tooltip: renderer.area!.name,
              onPressed: () {
                showContextMenu(
                    context: context,
                    position: position,
                    builder: (context, close) => MultiBlocProvider(
                            providers: [
                              BlocProvider.value(value: bloc),
                              BlocProvider.value(value: transformCubit),
                            ],
                            child: AreaContextMenu(
                              area: renderer.area!,
                              close: close,
                              position: position,
                            )));
                close();
              },
              padding: const EdgeInsets.all(4.0),
              icon: const Icon(PhosphorIcons.squareLight, size: 32),
            ),
          IconButton(
            tooltip: AppLocalizations.of(context)!.document,
            icon: const Icon(PhosphorIcons.fileLight, size: 32),
            padding: const EdgeInsets.all(4.0),
            onPressed: () async {
              var bloc = context.read<DocumentBloc>();
              var transformCubit = context.read<TransformCubit>();
              var actor = context.findAncestorWidgetOfExactType<Actions>();
              showContextMenu(
                  context: context,
                  position: position,
                  builder: (ctx, close) => MultiBlocProvider(
                        providers: [
                          BlocProvider.value(value: bloc),
                          BlocProvider.value(value: transformCubit),
                        ],
                        child: Actions(
                            actions: actor?.actions ?? {},
                            child: BackgroundContextMenu(
                              close: close,
                              position: position,
                            )),
                      ));
              close();
            },
          ),
        ]),
      ]),
    );
  }
}
