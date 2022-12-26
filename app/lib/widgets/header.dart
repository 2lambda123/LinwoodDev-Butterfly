import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../api/open.dart';

class Header extends StatelessWidget {
  final Widget? leading;
  final Widget title;
  final List<String>? help;
  final List<Widget> actions;
  const Header(
      {super.key,
      this.leading,
      required this.title,
      this.help,
      this.actions = const []});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(children: [
        if (leading != null)
          IconTheme(
              data: Theme.of(context).appBarTheme.iconTheme ??
                  Theme.of(context).iconTheme,
              child: leading!),
        const SizedBox(width: 16),
        Expanded(
          child: DefaultTextStyle(
              style: Theme.of(context).textTheme.headline5 ??
                  const TextStyle(fontSize: 20),
              child: title),
        ),
        ...actions,
        if (help != null)
          IconButton(
              tooltip: AppLocalizations.of(context)!.help,
              icon: const Icon(PhosphorIcons.circleWavyQuestionLight),
              onPressed: () => openHelp(help!)),
      ]),
    );
  }
}
