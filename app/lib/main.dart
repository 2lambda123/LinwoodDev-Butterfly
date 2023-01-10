import 'dart:io';

import 'package:args/args.dart';
import 'package:butterfly/api/intent.dart';
import 'package:butterfly/services/sync.dart';
import 'package:butterfly/settings/behaviors/mouse.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:window_manager/window_manager.dart';

import 'api/file_system.dart';
import 'api/full_screen.dart';
import 'cubits/settings.dart';
import 'embed/embedding.dart';
import 'models/converter.dart';
import 'models/document.dart';
import 'settings/behaviors/home.dart';
import 'settings/behaviors/keyboard.dart';
import 'settings/behaviors/pen.dart';
import 'settings/behaviors/touch.dart';
import 'settings/data.dart';
import 'settings/general.dart';
import 'settings/home.dart';
import 'settings/personalization.dart';
import 'settings/remote.dart';
import 'settings/remotes.dart';
import 'setup.dart' if (dart.library.html) 'setup_web.dart';
import 'theme/manager.dart';
import 'views/error.dart';
import 'views/main.dart';
import 'views/window.dart';

const kFileVersion = 7;
const kBreakingChangesVersion = 7;
const kMobileWidth = 600.0;

Future<void> main([List<String> args = const []]) async {
  WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy();

  await setup();
  var prefs = await SharedPreferences.getInstance();
  var initialLocation = '/';
  if (args.isNotEmpty && !kIsWeb) {
    var path = args[0].replaceAll('\\', '/');
    var file = File(path);
    if (await file.exists()) {
      var directory =
          Directory(await DocumentFileSystem.fromPlatform().getDirectory());
      // Test if file is in directory
      if (file.path.startsWith(directory.path)) {
        // Relative path
        initialLocation = Uri(
          pathSegments: [
            '',
            'local',
            ...file.path.replaceFirst(directory.path, '').split('/').sublist(1),
          ],
        ).toString();
      } else {
        initialLocation = Uri(pathSegments: [
          '',
          'native',
        ], queryParameters: {
          'path': file.path,
        }).toString();
      }
    }
  }
  if (!kIsWeb && Platform.isAndroid) {
    if (await getIntentType() != null) {
      initialLocation = '/native';
    }
  }

  if (!kIsWeb && isWindow()) {
    await windowManager.ensureInitialized();
    const kWindowOptions = WindowOptions(
      minimumSize: Size(410, 300),
      title: 'Butterfly',
    );

    // Use it only after calling `hiddenWindowAtLaunch`
    windowManager.waitUntilReadyToShow(kWindowOptions).then((_) async {
      await windowManager.setResizable(true);
      // await windowManager.maximize();
      await windowManager.show();
      await windowManager.focus();
    });
  }
  final argParser = ArgParser();
  argParser.addOption('path', abbr: 'p');
  final result = argParser.parse(args);
  GeneralFileSystem.dataPath = result['path'];
  runApp(
    MultiRepositoryProvider(providers: [
      RepositoryProvider(
          create: (context) => DocumentFileSystem.fromPlatform()),
      RepositoryProvider(
          create: (context) => TemplateFileSystem.fromPlatform()),
      RepositoryProvider(create: (context) => const DocumentJsonConverter()),
    ], child: ButterflyApp(prefs: prefs, initialLocation: initialLocation)),
  );
}

const kUnsupportedLanguages = ['pt'];

List<Locale> getLocales() =>
    List<Locale>.from(AppLocalizations.supportedLocales)
        .where((l) => !kUnsupportedLanguages.contains(l.toString()))
        .toList();

class ButterflyApp extends StatelessWidget {
  final String initialLocation;
  final String importedLocation;
  final SharedPreferences prefs;

  ButterflyApp(
      {super.key,
      required this.prefs,
      this.initialLocation = '/',
      this.importedLocation = ''})
      : _router = GoRouter(
          initialLocation: initialLocation,
          errorBuilder: (context, state) =>
              ErrorPage(message: state.error.toString()),
          routes: [
            GoRoute(
                name: 'home',
                path: '/',
                builder: (context, state) {
                  return const ProjectPage();
                },
                routes: [
                  GoRoute(
                    path: 'settings',
                    builder: (context, state) => const SettingsPage(),
                    routes: [
                      GoRoute(
                        path: 'general',
                        builder: (context, state) =>
                            const GeneralSettingsPage(),
                      ),
                      GoRoute(
                        path: 'behaviors',
                        builder: (context, state) =>
                            const BehaviorsSettingsPage(),
                        routes: [
                          GoRoute(
                            path: 'mouse',
                            builder: (context, state) =>
                                const MouseBehaviorSettings(),
                          ),
                          GoRoute(
                            path: 'pen',
                            builder: (context, state) =>
                                const PenBehaviorSettings(),
                          ),
                          GoRoute(
                            path: 'keyboard',
                            builder: (context, state) =>
                                const KeyboardBehaviorSettings(),
                          ),
                          GoRoute(
                            path: 'touch',
                            builder: (context, state) =>
                                const TouchBehaviorSettings(),
                          ),
                        ],
                      ),
                      GoRoute(
                        path: 'personalization',
                        builder: (context, state) =>
                            const PersonalizationSettingsPage(),
                      ),
                      GoRoute(
                        path: 'data',
                        builder: (context, state) => const DataSettingsPage(),
                      ),
                      GoRoute(
                        path: 'remotes',
                        builder: (context, state) =>
                            const RemotesSettingsPage(),
                        routes: [
                          GoRoute(
                            path: ':id',
                            builder: (context, state) =>
                                RemoteSettingsPage(remote: state.params['id']!),
                          )
                        ],
                      ),
                    ],
                  ),
                ]),
            GoRoute(
              name: 'local',
              path: '/local/:path(.*)',
              builder: (context, state) {
                final path = state.params['path']
                    ?.split('/')
                    .map((e) => Uri.decodeComponent(e))
                    .join('/');
                return ProjectPage(
                    data: state.extra,
                    location: AssetLocation.local(path ?? ''));
              },
            ),
            GoRoute(
              name: 'remote',
              path: '/remote/:remote/:path(.*)',
              builder: (context, state) {
                final remote =
                    Uri.decodeComponent(state.params['remote'] ?? '');
                final path = state.params['path']
                    ?.split('/')
                    .map((e) => Uri.decodeComponent(e))
                    .join('/');
                return ProjectPage(
                    data: state.extra,
                    location: AssetLocation(remote: remote, path: path ?? ''));
              },
            ),
            GoRoute(
              path: '/native',
              builder: (context, state) {
                final type = state.queryParams['type'] ?? '';
                final path = state.queryParams['path'] ?? '';
                final data = state.extra;
                return ProjectPage(
                  location: AssetLocation.local(path, true),
                  type: type,
                  data: data,
                );
              },
            ),
            GoRoute(
              path: '/native/:path(.*)',
              builder: (context, state) {
                final path = state.params['path'] ?? '';
                return ProjectPage(location: AssetLocation.local(path, true));
              },
            ),
            GoRoute(
              name: 'embed',
              path: '/embed',
              builder: (context, state) {
                return ProjectPage(
                    embedding: Embedding.fromQuery(state.queryParams));
              },
            ),
          ],
        );

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SettingsCubit.fromPrefs(prefs),
      child: BlocBuilder<SettingsCubit, ButterflySettings>(
        buildWhen: (previous, current) =>
            previous.nativeWindowTitleBar != current.nativeWindowTitleBar,
        builder: (context, settings) {
          if (!kIsWeb && isWindow()) {
            windowManager.waitUntilReadyToShow().then((_) async {
              windowManager.setTitleBarStyle(settings.nativeWindowTitleBar
                  ? TitleBarStyle.normal
                  : TitleBarStyle.hidden);
              windowManager.setFullScreen(settings.startInFullScreen);
            });
          } else {
            setFullScreen(settings.startInFullScreen);
          }
          return RepositoryProvider(
            create: (context) =>
                SyncService(context, context.read<SettingsCubit>()),
            lazy: false,
            child: _buildApp(),
          );
        },
      ),
    );
  }

  Widget _buildApp() {
    return BlocBuilder<SettingsCubit, ButterflySettings>(
        buildWhen: (previous, current) =>
            previous.theme != current.theme ||
            previous.localeTag != current.localeTag ||
            previous.design != current.design,
        builder: (context, state) => MaterialApp.router(
              locale: state.locale,
              title: 'Butterfly',
              routeInformationProvider: _router.routeInformationProvider,
              routeInformationParser: _router.routeInformationParser,
              routerDelegate: _router.routerDelegate,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: getLocales(),
              theme: ThemeManager.getThemeByName(state.design),
              themeMode: state.theme,
              builder: (context, child) {
                if (child == null) {
                  return const Center(child: CircularProgressIndicator());
                }
                return child;
              },
              darkTheme: ThemeManager.getThemeByName(state.design, dark: true),
            ));
  }

  final GoRouter _router;
}
