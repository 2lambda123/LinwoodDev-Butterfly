import 'package:butterfly/dialogs/elements/general.dart';
import 'package:butterfly/dialogs/elements/label.dart';
import 'package:butterfly/models/element.dart';
import 'package:butterfly/visualizer/element.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../renderers/renderer.dart';

class ElementsDialog extends StatefulWidget {
  final List<Renderer<PadElement>> elements;
  final VoidCallback close;
  final Offset position;
  final ValueChanged<Renderer<PadElement>>? onChanged;
  const ElementsDialog(
      {Key? key,
      required this.elements,
      required this.close,
      this.onChanged,
      required this.position})
      : super(key: key);

  @override
  State<ElementsDialog> createState() => _ElementsDialogState();
}

class _ElementsDialogState extends State<ElementsDialog> {
  int _selectedElement = 0;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    PadElement? element;
    if (_selectedElement < widget.elements.length && _selectedElement >= 0) {
      element = widget.elements[_selectedElement].element;
    }
    Widget content =
        Center(child: Text(AppLocalizations.of(context)!.selectElement));
    if (element is LabelElement) {
      content = LabelElementDialog(
          index: _selectedElement,
          close: widget.close,
          position: widget.position);
    } else if (element is LabelElement) {
      content = LabelElementDialog(
          index: _selectedElement,
          close: widget.close,
          position: widget.position);
    } else if (element != null) {
      content = GeneralElementDialog(
          position: widget.position,
          index: _selectedElement,
          close: widget.close);
    }
    return Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      if (widget.elements.length > 1) ...[
        SizedBox(
          width: 50,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: widget.elements.length,
            itemBuilder: (context, index) => InkWell(
              onTap: () {
                widget.onChanged?.call(widget.elements[index]);
                setState(() => _selectedElement = index);
              },
              child: Icon(widget.elements[index].element.getIcon(), size: 30),
            ),
          ),
        ),
      ],
      const SizedBox(width: 10),
      Expanded(child: content)
    ]);
  }
}
