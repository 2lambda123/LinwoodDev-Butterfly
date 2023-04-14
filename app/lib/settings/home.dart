import 'package:butterfly/settings/behaviors/home.dart';
import 'package:butterfly/settings/data.dart';
import 'package:butterfly/settings/personalization.dart';
import 'package:butterfly/widgets/header.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import 'general.dart';
import 'connections.dart';

enum SettingsView { general, data, behaviors, personalization, remotes }

class SettingsPage extends StatefulWidget {
  final bool isDialog;
  const SettingsPage({super.key, this.isDialog = false});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  SettingsView _view = SettingsView.general;
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    super.dispose();

    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
        color: widget.isDialog ? Colors.transparent : null,
        child: LayoutBuilder(builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 600;
          var navigation = Column(children: [
            Header(
              title: Text(AppLocalizations.of(context).settings),
              leading: IconButton(
                icon: const PhosphorIcon(PhosphorIconsLight.x),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            Flexible(
              child: Material(
                color: widget.isDialog ? Colors.transparent : null,
                child: ListView(
                    controller: _scrollController,
                    shrinkWrap: true,
                    children: [
                      ListTile(
                        title: Text(AppLocalizations.of(context).general),
                        leading: const PhosphorIcon(PhosphorIconsLight.gear),
                        selected:
                            !isMobile ? _view == SettingsView.general : false,
                        onTap: () {
                          if (isMobile) {
                            Navigator.of(context).pop();
                            GoRouter.of(context).go('/settings/general');
                          } else {
                            setState(() {
                              _view = SettingsView.general;
                            });
                          }
                        },
                      ),
                      ListTile(
                        title: Text(AppLocalizations.of(context).data),
                        leading:
                            const PhosphorIcon(PhosphorIconsLight.database),
                        selected:
                            !isMobile ? _view == SettingsView.data : false,
                        onTap: () {
                          if (isMobile) {
                            Navigator.of(context).pop();
                            GoRouter.of(context).go('/settings/data');
                          } else {
                            setState(() {
                              _view = SettingsView.data;
                            });
                          }
                        },
                      ),
                      ListTile(
                        title: Text(AppLocalizations.of(context).behaviors),
                        leading: const PhosphorIcon(PhosphorIconsLight.faders),
                        selected:
                            !isMobile ? _view == SettingsView.behaviors : false,
                        onTap: () {
                          if (isMobile) {
                            Navigator.of(context).pop();
                            GoRouter.of(context).go('/settings/behaviors');
                          } else {
                            setState(() {
                              _view = SettingsView.behaviors;
                            });
                          }
                        },
                      ),
                      ListTile(
                          leading:
                              const PhosphorIcon(PhosphorIconsLight.monitor),
                          title: Text(
                              AppLocalizations.of(context).personalization),
                          selected: !isMobile
                              ? _view == SettingsView.personalization
                              : false,
                          onTap: () {
                            if (isMobile) {
                              Navigator.of(context).pop();
                              GoRouter.of(context)
                                  .go('/settings/personalization');
                            } else {
                              setState(() {
                                _view = SettingsView.personalization;
                              });
                            }
                          }),
                      if (!kIsWeb)
                        ListTile(
                            leading:
                                const PhosphorIcon(PhosphorIconsLight.cloud),
                            title:
                                Text(AppLocalizations.of(context).connections),
                            selected: !isMobile
                                ? _view == SettingsView.remotes
                                : false,
                            onTap: () {
                              if (isMobile) {
                                Navigator.of(context).pop();
                                GoRouter.of(context)
                                    .go('/settings/connections');
                              } else {
                                setState(() {
                                  _view = SettingsView.remotes;
                                });
                              }
                            }),
                      if (kIsWeb) ...[
                        const Divider(),
                        Padding(
                            padding: const EdgeInsets.all(5),
                            child: InkWell(
                                onTap: () => launchUrl(
                                    Uri.https('vercel.com', '', {
                                      'utm_source': 'Linwood',
                                      'utm_campaign': 'oss'
                                    }),
                                    mode: LaunchMode.externalApplication),
                                child: Material(
                                  color: Colors.transparent,
                                  child: SizedBox(
                                      height: 50,
                                      child: SvgPicture.asset(
                                          'images/powered-by-vercel.svg',
                                          placeholderBuilder: (BuildContext
                                                  context) =>
                                              Container(
                                                  padding: const EdgeInsets.all(
                                                      30.0),
                                                  child:
                                                      const CircularProgressIndicator()),
                                          semanticsLabel: 'Powered by Vercel')),
                                )))
                      ],
                    ]),
              ),
            )
          ]);
          if (isMobile) {
            return navigation;
          }
          Widget content;
          switch (_view) {
            case SettingsView.general:
              content = const GeneralSettingsPage(inView: true);
              break;
            case SettingsView.data:
              content = const DataSettingsPage(inView: true);
              break;
            case SettingsView.behaviors:
              content = const BehaviorsSettingsPage(inView: true);
              break;
            case SettingsView.personalization:
              content = const PersonalizationSettingsPage(inView: true);
              break;
            case SettingsView.remotes:
              content = const ConnectionsSettingsPage(inView: true);
              break;
          }
          return Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            SizedBox(width: 300, child: navigation),
            Expanded(child: content),
          ]);
        }),
      ),
    );
  }
}
