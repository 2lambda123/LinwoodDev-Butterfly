import 'package:butterfly/cubits/settings.dart';
import 'package:butterfly/views/main.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../theme/manager.dart';

class PersonalizationSettingsPage extends StatelessWidget {
  final bool inView;
  const PersonalizationSettingsPage({super.key, this.inView = false});

  String _getThemeName(BuildContext context, ThemeMode mode) {
    switch (mode) {
      case ThemeMode.system:
        return AppLocalizations.of(context)!.systemTheme;
      case ThemeMode.light:
        return AppLocalizations.of(context)!.lightTheme;
      case ThemeMode.dark:
        return AppLocalizations.of(context)!.darkTheme;
      default:
        return AppLocalizations.of(context)!.systemTheme;
    }
  }

  String _getLocaleName(BuildContext context, String? locale) {
    switch (locale) {
      case 'fr':
        return AppLocalizations.of(context)!.french;
      case 'de':
        return AppLocalizations.of(context)!.german;
      case 'en':
        return AppLocalizations.of(context)!.english;
      default:
        return AppLocalizations.of(context)!.defaultLocale;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: inView ? Colors.transparent : null,
        appBar: AppBar(
          automaticallyImplyLeading: !inView,
          backgroundColor: inView ? Colors.transparent : null,
          title: Text(AppLocalizations.of(context)!.personalization),
          actions: [
            if (!inView && !kIsWeb && isWindow()) ...[
              const VerticalDivider(),
              const WindowButtons()
            ]
          ],
        ),
        body: BlocBuilder<SettingsCubit, ButterflySettings>(
          builder: (context, state) => ListView(children: [
            ListTile(
                leading: const Icon(PhosphorIcons.eyeLight),
                title: Text(AppLocalizations.of(context)!.theme),
                subtitle: Text(_getThemeName(context, state.theme)),
                onTap: () => _openThemeModal(context)),
            ListTile(
              leading: const Icon(PhosphorIcons.paletteLight),
              title: Text(AppLocalizations.of(context)!.design),
              subtitle: Text(state.design),
              onTap: () => _openDesignModal(context),
            ),
            ListTile(
                leading: const Icon(PhosphorIcons.translateLight),
                title: Text(AppLocalizations.of(context)!.locale),
                subtitle: Text(_getLocaleName(context, state.localeTag)),
                onTap: () => _openLocaleModal(context)),
            CheckboxListTile(
              secondary: const Icon(PhosphorIcons.squaresFourLight),
              title: Text(AppLocalizations.of(context)!.start),
              value: state.startEnabled,
              onChanged: (value) => context
                  .read<SettingsCubit>()
                  .changeStartEnabled(value ?? true),
            ),
          ]),
        ));
  }

  void _openDesignModal(BuildContext context) {
    final cubit = context.read<SettingsCubit>();
    final currentDesign = cubit.state.design;

    showModalBottomSheet(
        context: context,
        builder: (context) {
          void changeDesign(String design) {
            cubit.changeDesign(design);
          }

          return Container(
              margin: const EdgeInsets.only(bottom: 20),
              child: ListView(shrinkWrap: true, children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  child: Text(
                    AppLocalizations.of(context)!.theme,
                    style: Theme.of(context).textTheme.headline5,
                    textAlign: TextAlign.center,
                  ),
                ),
                ...ThemeManager.getThemes().map((e) => ListTile(
                      title: Text(e),
                      selected: e == currentDesign,
                      onTap: () => changeDesign(e),
                    ))
              ]));
        });
  }

  void _openThemeModal(BuildContext context) {
    final cubit = context.read<SettingsCubit>();
    final currentTheme = cubit.state.theme;

    showModalBottomSheet(
        context: context,
        builder: (ctx) {
          void changeTheme(ThemeMode themeMode) {
            cubit.changeTheme(themeMode);
          }

          return Container(
              margin: const EdgeInsets.only(bottom: 20),
              child: ListView(shrinkWrap: true, children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  child: Text(
                    AppLocalizations.of(context)!.theme,
                    style: Theme.of(context).textTheme.headline5,
                    textAlign: TextAlign.center,
                  ),
                ),
                ListTile(
                    title: Text(AppLocalizations.of(context)!.systemTheme),
                    selected: currentTheme == ThemeMode.system,
                    leading: const Icon(PhosphorIcons.powerLight),
                    onTap: () => changeTheme(ThemeMode.system)),
                ListTile(
                    title: Text(AppLocalizations.of(context)!.lightTheme),
                    selected: currentTheme == ThemeMode.light,
                    leading: const Icon(PhosphorIcons.sunLight),
                    onTap: () => changeTheme(ThemeMode.light)),
                ListTile(
                    title: Text(AppLocalizations.of(context)!.darkTheme),
                    selected: currentTheme == ThemeMode.dark,
                    leading: const Icon(PhosphorIcons.moonLight),
                    onTap: () => changeTheme(ThemeMode.dark)),
                const SizedBox(height: 32),
              ]));
        });
  }

  void _openLocaleModal(BuildContext context) {
    final cubit = context.read<SettingsCubit>();
    var currentLocale = cubit.state.localeTag;
    var locales = AppLocalizations.supportedLocales;
    showModalBottomSheet<String>(
        context: context,
        builder: (context) {
          void changeLocale(Locale? locale) {
            cubit.changeLocale(locale);
            Navigator.of(context).pop();
          }

          return Container(
              margin: const EdgeInsets.only(bottom: 20),
              child: ListView(shrinkWrap: true, children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  child: Text(
                    AppLocalizations.of(context)!.theme,
                    style: Theme.of(context).textTheme.headline5,
                    textAlign: TextAlign.center,
                  ),
                ),
                ListTile(
                    title: Text(AppLocalizations.of(context)!.defaultLocale),
                    selected: currentLocale.isEmpty,
                    onTap: () => changeLocale(null)),
                ...locales
                    .map((e) => ListTile(
                        title: Text(_getLocaleName(context, e.languageCode)),
                        selected: currentLocale == e.languageCode,
                        onTap: () => changeLocale(e)))
                    .toList(),
                const SizedBox(height: 32),
              ]));
        });
  }
}
