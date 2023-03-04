import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../bloc/document_bloc.dart';
import '../dialogs/color_pick.dart';

class ColorField extends StatelessWidget {
  final bool enabled, custom;
  final Color value;
  final Color? defaultColor;
  final Widget? title;
  final Widget? subtitle;
  final Widget? leading;
  final ValueChanged<Color>? onChanged;
  final VoidCallback? onOpen;

  const ColorField(
      {super.key,
      this.value = Colors.white,
      this.defaultColor,
      this.custom = false,
      this.enabled = true,
      this.leading,
      this.title,
      this.subtitle,
      this.onOpen,
      this.onChanged});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () async {
        onOpen?.call();
        int? nextColor;
        if (custom) {
          final response = await showDialog<ColorPickerResponse>(
            context: context,
            builder: (ctx) => CustomColorPicker(
              defaultColor: value,
            ),
          );
          nextColor = response?.color;
        } else {
          nextColor = await showDialog<int>(
              context: context,
              builder: (ctx) => BlocProvider.value(
                    value: context.read<DocumentBloc>(),
                    child: ColorPickerDialog(defaultColor: value),
                  ));
        }
        if (nextColor != null) {
          onChanged?.call(Color(nextColor));
        }
      },
      leading: leading,
      title: title,
      subtitle: subtitle,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
                color: value,
                border:
                    Border.all(color: Theme.of(context).primaryColor, width: 2),
                borderRadius: const BorderRadius.all(Radius.circular(32))),
          ),
          if (defaultColor != null) ...[
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(PhosphorIcons.clockCounterClockwiseLight),
              onPressed: () async {
                onChanged?.call(defaultColor!);
              },
            ),
          ]
        ],
      ),
    );
  }
}
