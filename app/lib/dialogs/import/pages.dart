import 'dart:typed_data';

import 'package:butterfly/cubits/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:material_leap/material_leap.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

@immutable
class PageDialogCallback {
  final List<int> pages;
  final double quality;

  const PageDialogCallback(this.pages, this.quality);
}

class PagesDialog extends StatefulWidget {
  final List<Uint8List> pages;
  const PagesDialog({super.key, required this.pages});

  @override
  State<PagesDialog> createState() => _PagesDialogState();
}

class _PagesDialogState extends State<PagesDialog> {
  List<int> _selected = const [];
  double _quality = 2.0;
  double _defaultQuality = 2.0;

  @override
  void initState() {
    super.initState();
    _selected = List.generate(widget.pages.length, (i) => i);
    _defaultQuality = context.read<SettingsCubit>().state.pdfQuality;
    _quality = _defaultQuality;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
        child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 500),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Header(
            title:
                Text(AppLocalizations.of(context).countPages(_selected.length)),
            actions: [
              IconButton(
                  tooltip: AppLocalizations.of(context).invertSelection,
                  icon: const PhosphorIcon(PhosphorIconsLight.selectionInverse),
                  onPressed: () {
                    setState(() {
                      // Remove all selected pages and add all other pages.
                      _selected = List.generate(widget.pages.length, (i) => i)
                          .toSet()
                          .difference(_selected.toSet())
                          .toList();
                    });
                  }),
            ],
          ),
          Flexible(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Material(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: widget.pages.length,
                itemBuilder: (context, index) {
                  // Show border for selected pages
                  final border = _selected.contains(index)
                      ? Border.all(
                          width: 4,
                          color: Theme.of(context).primaryColor,
                        )
                      : null;
                  return InkWell(
                    onTap: () {
                      setState(() {
                        _selected = _selected.contains(index)
                            ? _selected.where((e) => e != index).toList()
                            : [..._selected, index];
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.all(5),
                      decoration: BoxDecoration(border: border),
                      child: Image.memory(widget.pages[index]),
                    ),
                  );
                },
              ),
            ),
          )),
          ExactSlider(
            onChanged: (value) => setState(() => _quality = value),
            defaultValue: _defaultQuality,
            value: _quality,
            max: 10,
            min: 0.5,
            label: AppLocalizations.of(context).quality,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  child: Text(AppLocalizations.of(context).cancel),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                ElevatedButton(
                  child: Text(AppLocalizations.of(context).ok),
                  onPressed: () => Navigator.of(context)
                      .pop(PageDialogCallback(_selected, _quality)),
                ),
              ],
            ),
          ),
        ],
      ),
    ));
  }
}
