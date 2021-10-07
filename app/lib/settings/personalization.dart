import 'package:butterfly/pad/cubits/language.dart';
import 'package:flutter/material.dart';
import 'package:butterfly/theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PersonalizationSettingsPage extends StatefulWidget {
  const PersonalizationSettingsPage({Key? key}) : super(key: key);

  @override
  _PersonalizationSettingsPageState createState() => _PersonalizationSettingsPageState();
}

class _PersonalizationSettingsPageState extends State<PersonalizationSettingsPage> {
  String getThemeName(ThemeMode mode) {
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

  String getLocaleName(String? locale) {
    switch (locale) {
      case "fr":
        return AppLocalizations.of(context)!.french;
      case "de":
        return AppLocalizations.of(context)!.german;
      case "en":
        return AppLocalizations.of(context)!.english;
      default:
        return AppLocalizations.of(context)!.defaultLocale;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(AppLocalizations.of(context)!.personalization)),
        body: Builder(
          builder: (context) => ListView(children: [
            ListTile(
                title: Text(AppLocalizations.of(context)!.theme),
                subtitle: Text(
                    getThemeName(ThemeController.of(context)?.currentTheme ?? ThemeMode.system)),
                onTap: () => _openThemeModal()),
            ListTile(
                title: Text(AppLocalizations.of(context)!.locale),
                subtitle: Text(getLocaleName(context.read<LanguageCubit>().state?.languageCode)),
                onTap: () => _openLocaleModal())
          ]),
        ));
  }

  void _openThemeModal() async {
    var currentTheme = ThemeController.of(context)?.currentTheme;
    var themeMode = await showModalBottomSheet<ThemeMode>(
        context: context,
        builder: (context) {
          return Container(
              margin: const EdgeInsets.only(bottom: 20),
              child: ListView(shrinkWrap: true, children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  child: Text(
                    AppLocalizations.of(context)!.theme,
                    style: Theme.of(context).textTheme.headline5,
                    textAlign: TextAlign.center,
                  ),
                ),
                ListTile(
                    title: Text(AppLocalizations.of(context)!.systemTheme),
                    selected: currentTheme == ThemeMode.system,
                    leading: const Icon(Icons.settings_outlined),
                    onTap: () => Navigator.of(context).pop(ThemeMode.system)),
                ListTile(
                    title: Text(AppLocalizations.of(context)!.lightTheme),
                    selected: currentTheme == ThemeMode.light,
                    leading: const Icon(Icons.wb_sunny_outlined),
                    onTap: () => Navigator.of(context).pop(ThemeMode.light)),
                ListTile(
                    title: Text(AppLocalizations.of(context)!.darkTheme),
                    selected: currentTheme == ThemeMode.dark,
                    leading: const Icon(Icons.nightlight_round),
                    onTap: () => Navigator.of(context).pop(ThemeMode.dark)),
                const SizedBox(height: 32),
              ]));
        });
    if (themeMode != null) setState(() => ThemeController.of(context)?.currentTheme = themeMode);
  }

  void _openLocaleModal() async {
    var cubit = context.read<LanguageCubit>();
    var currentLocale = cubit.state;
    var locales = AppLocalizations.supportedLocales;
    var locale = await showModalBottomSheet<String>(
        context: context,
        builder: (context) {
          return Container(
              margin: const EdgeInsets.only(bottom: 20),
              child: ListView(shrinkWrap: true, children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  child: Text(
                    AppLocalizations.of(context)!.theme,
                    style: Theme.of(context).textTheme.headline5,
                    textAlign: TextAlign.center,
                  ),
                ),
                ListTile(
                    title: Text(AppLocalizations.of(context)!.defaultLocale),
                    selected: currentLocale == null,
                    onTap: () => Navigator.of(context).pop(null)),
                ...locales
                    .map((e) => ListTile(
                        title: Text(getLocaleName(e.languageCode)),
                        selected: currentLocale?.languageCode == e.languageCode,
                        onTap: () => Navigator.of(context).pop(e.languageCode)))
                    .toList(),
                const SizedBox(height: 32),
              ]));
        });
    cubit.change(locale);
    cubit.save();
  }
}
