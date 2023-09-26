import 'dart:convert';

import 'package:butterfly/api/full_screen.dart' as full_screen_api;
import 'package:butterfly/api/file_system/file_system.dart';
import 'package:butterfly/widgets/window.dart';
import 'package:butterfly_api/butterfly_api.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:window_manager/window_manager.dart';

import '../views/navigator.dart';

part 'settings.freezed.dart';
part 'settings.g.dart';

const kDefaultIceServers = ['stunserver.stunprotocol.org:3478'];

const secureStorage = FlutterSecureStorage(
  aOptions: AndroidOptions(
    encryptedSharedPreferences: true,
  ),
);
const kRecentHistorySize = 5;

enum PlatformTheme {
  system,
  mobile,
  desktop;

  bool isMobile(BuildContext context) {
    final platform = Theme.of(context).platform;
    return switch (this) {
      PlatformTheme.mobile => true,
      PlatformTheme.desktop => false,
      PlatformTheme.system =>
        platform == TargetPlatform.iOS || platform == TargetPlatform.android,
    };
  }
}

@freezed
class RemoteStorage with _$RemoteStorage {
  const factory RemoteStorage.dav({
    required String username,
    required String url,
    required String path,
    required String documentsPath,
    required String templatesPath,
    required String packsPath,
    @Default([]) List<String> cachedDocuments,
    @Default([]) List<String> starred,
    @Uint8ListJsonConverter() required Uint8List icon,
    DateTime? lastSynced,
  }) = DavRemoteStorage;

  factory RemoteStorage.fromJson(Map<String, dynamic> json) =>
      _$RemoteStorageFromJson(json);

  const RemoteStorage._();

  Uri get uri => Uri.parse(url);

  String get displayName => '$username@${uri.host}';

  Uri buildUri({
    List<String> path = const [],
    Map<String, String> query = const {},
  }) {
    final currentUri = uri;
    final paths = List<String>.from(currentUri.pathSegments);
    if (paths.lastOrNull == '') {
      paths.removeLast();
    }
    return Uri(
      scheme: currentUri.scheme,
      port: currentUri.port,
      host: currentUri.host,
      queryParameters: {
        ...currentUri.queryParameters,
        ...query,
      },
      pathSegments: {
        ...paths,
        ...path,
      },
    );
  }

  Uri buildDocumentsUri({
    List<String> path = const [],
    Map<String, String> query = const {},
  }) {
    return buildUri(
      path: [...documentsPath.split('/'), ...path],
      query: query,
    );
  }

  Uri buildTemplatesUri({
    List<String> path = const [],
    Map<String, String> query = const {},
  }) {
    return buildUri(
      path: [...templatesPath.split('/'), ...path],
      query: query,
    );
  }

  Uri buildPacksUri({
    List<String> path = const [],
    Map<String, String> query = const {},
  }) {
    return buildUri(
      path: [...packsPath.split('/'), ...path],
      query: query,
    );
  }

  String get identifier => '$username@${uri.host}/$path';

  DocumentFileSystem get documentFileSystem =>
      DocumentFileSystem.fromPlatform(remote: this);

  TemplateFileSystem get templateFileSystem =>
      TemplateFileSystem.fromPlatform(remote: this);

  bool hasDocumentCached(String name) {
    if (!name.startsWith('/')) {
      name = '/$name';
    }
    return cachedDocuments.any((doc) {
      if (doc == name) {
        return true;
      }
      if (name.startsWith(doc)) {
        return !name.substring(doc.length + 1).contains('/');
      }
      return false;
    });
  }

  String encodeIdentifier() => base64Encode(utf8.encode(identifier));

  Future<String?> getRemotePassword() =>
      secureStorage.read(key: 'remote ${encodeIdentifier()}');

  Future<void> writeRemotePassword(String password) =>
      secureStorage.write(key: 'remote ${encodeIdentifier()}', value: password);
}

enum SyncMode { always, noMobile, manual }

@freezed
class InputConfiguration with _$InputConfiguration {
  const InputConfiguration._();

  const factory InputConfiguration({
    int? leftMouse,
    @Default(-1) int? middleMouse,
    @Default(1) int? rightMouse,
    int? pen,
    @Default(2) int? firstPenButton,
    @Default(1) int? secondPenButton,
    int? touch,
  }) = _InputConfiguration;

  factory InputConfiguration.fromJson(Map<String, dynamic> json) =>
      _$InputConfigurationFromJson(json);

  Set<int> getShortcuts() => {
        leftMouse,
        middleMouse,
        rightMouse,
        pen,
        firstPenButton,
        secondPenButton,
        touch
      }.whereNotNull().toSet();
}

enum SortBy { name, created, modified }

enum SortOrder { ascending, descending }

enum BannerVisibility { always, never, onlyOnUpdates }

enum ToolbarPosition {
  top,
  bottom,
  left,
  right;

  String getLocalizedName(BuildContext context) => switch (this) {
        ToolbarPosition.top => AppLocalizations.of(context).top,
        ToolbarPosition.bottom => AppLocalizations.of(context).bottom,
        ToolbarPosition.left => AppLocalizations.of(context).left,
        ToolbarPosition.right => AppLocalizations.of(context).right
      };

  Alignment get alignment => switch (this) {
        ToolbarPosition.left => Alignment.centerLeft,
        ToolbarPosition.right => Alignment.centerRight,
        ToolbarPosition.top => Alignment.topCenter,
        ToolbarPosition.bottom => Alignment.bottomCenter,
      };

  Axis get axis => switch (this) {
        ToolbarPosition.left => Axis.vertical,
        ToolbarPosition.right => Axis.vertical,
        ToolbarPosition.top => Axis.horizontal,
        ToolbarPosition.bottom => Axis.horizontal,
      };
}

enum ThemeDensity {
  compact,
  comfortable,
  standard,
  system;

  VisualDensity toFlutter() => switch (this) {
        ThemeDensity.comfortable => VisualDensity.comfortable,
        ThemeDensity.compact => VisualDensity.compact,
        ThemeDensity.standard => VisualDensity.standard,
        ThemeDensity.system => VisualDensity.adaptivePlatformDensity,
      };
}

@freezed
class ButterflySettings with _$ButterflySettings {
  const ButterflySettings._();
  const factory ButterflySettings({
    @Default(ThemeMode.system) ThemeMode theme,
    @Default(ThemeDensity.system) ThemeDensity density,
    @Default('') String localeTag,
    @Default('') String documentPath,
    @Default(1) double touchSensitivity,
    @Default(1) double mouseSensitivity,
    @Default(1) double penSensitivity,
    @Default(5) double selectSensitivity,
    @Default(false) bool penOnlyInput,
    @Default(true) bool inputGestures,
    @Default('') String design,
    @Default(BannerVisibility.always) BannerVisibility bannerVisibility,
    @Default([]) List<AssetLocation> history,
    @Default(false) bool navigatorEnabled,
    @Default(true) bool zoomEnabled,
    String? lastVersion,
    @Default([]) List<RemoteStorage> remotes,
    @Default('') String defaultRemote,
    @Default(false) bool nativeTitleBar,
    @Default(false) bool startInFullScreen,
    @Default(true) bool navigationRail,
    required bool fullScreen,
    @Default(SyncMode.noMobile) SyncMode syncMode,
    @Default(InputConfiguration()) InputConfiguration inputConfiguration,
    @Default('') String fallbackPack,
    @Default([]) List<String> starred,
    @Default('') String defaultTemplate,
    @Default(NavigatorPage.waypoints) NavigatorPage navigatorPage,
    @Default(ToolbarPosition.top) ToolbarPosition toolbarPosition,
    @Default(SortBy.name) SortBy sortBy,
    @Default(SortOrder.ascending) SortOrder sortOrder,
    @Default(0.5) double imageScale,
    @Default(2) double pdfQuality,
    @Default(PlatformTheme.system) PlatformTheme platformTheme,
    @Default(kDefaultIceServers) List<String> iceServers,
  }) = _ButterflySettings;

  factory ButterflySettings.fromPrefs(
      SharedPreferences prefs, bool fullScreen) {
    final remotes = prefs.getStringList('remotes')?.map((e) {
          final data = json.decode(e) as Map<String, dynamic>;
          if (!data.containsKey('packsPath')) {
            data['packsPath'] = data['path'] + '/Packs';
          }
          return RemoteStorage.fromJson(data);
        }).toList() ??
        const [];
    return ButterflySettings(
      fullScreen: fullScreen,
      localeTag: prefs.getString('locale') ?? '',
      penOnlyInput: prefs.getBool('pen_only_input') ?? false,
      inputGestures: prefs.getBool('input_gestures') ?? true,
      documentPath: prefs.getString('document_path') ?? '',
      theme: prefs.containsKey('theme_mode')
          ? ThemeMode.values.byName(prefs.getString('theme_mode')!)
          : ThemeMode.system,
      density: prefs.containsKey('theme_density')
          ? ThemeDensity.values.byName(prefs.getString('theme_density')!)
          : ThemeDensity.system,
      touchSensitivity: prefs.getDouble('touch_sensitivity') ?? 1,
      mouseSensitivity: prefs.getDouble('mouse_sensitivity') ?? 1,
      penSensitivity: prefs.getDouble('pen_sensitivity') ?? 1,
      selectSensitivity: prefs.getDouble('select_sensitivity') ?? 5,
      design: prefs.getString('design') ?? '',
      bannerVisibility: prefs.containsKey('banner_visibility')
          ? BannerVisibility.values
              .byName(prefs.getString('banner_visibility')!)
          : BannerVisibility.always,
      history: prefs
              .getStringList('history')
              ?.map((e) {
                // Try to parse the asset location
                try {
                  return AssetLocation.fromJson(json.decode(e));
                } catch (e) {
                  return null;
                }
              })
              .whereType<AssetLocation>()
              .toList() ??
          [],
      zoomEnabled: prefs.getBool('zoom_enabled') ?? true,
      lastVersion: prefs.getString('last_version'),
      remotes: remotes,
      defaultRemote: prefs.getString('default_remote') ?? '',
      nativeTitleBar: prefs.getBool('native_title_bar') ?? false,
      startInFullScreen: prefs.getBool('start_in_full_screen') ?? false,
      syncMode:
          SyncMode.values.byName(prefs.getString('sync_mode') ?? 'noMobile'),
      inputConfiguration: InputConfiguration.fromJson(
        json.decode(prefs.getString('input_configuration') ?? '{}'),
      ),
      fallbackPack: prefs.getString('fallback_pack') ?? '',
      starred: prefs.getStringList('starred') ?? [],
      defaultTemplate: prefs.getString('default_template') ?? '',
      toolbarPosition: prefs.containsKey('toolbar_position')
          ? ToolbarPosition.values.byName(prefs.getString('toolbar_position')!)
          : ToolbarPosition.top,
      navigationRail: prefs.getBool('navigation_rail') ?? true,
      sortBy: prefs.containsKey('sort_by')
          ? SortBy.values.byName(prefs.getString('sort_by')!)
          : SortBy.name,
      sortOrder: prefs.containsKey('sort_order')
          ? SortOrder.values.byName(prefs.getString('sort_order')!)
          : SortOrder.ascending,
      imageScale: prefs.getDouble('image_scale') ?? 0.5,
      pdfQuality: prefs.getDouble('pdf_quality') ?? 2,
      platformTheme: prefs.containsKey('platform_theme')
          ? PlatformTheme.values.byName(prefs.getString('platform_theme')!)
          : PlatformTheme.system,
      iceServers: prefs.getStringList('ice_servers') ?? kDefaultIceServers,
    );
  }

  Locale? get locale {
    if (localeTag.isEmpty) {
      return null;
    }
    if (localeTag.contains('-')) {
      return Locale(localeTag.split('-')[0], localeTag.split('-')[1]);
    }
    return Locale(localeTag);
  }

  Future<void> save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('theme_mode', theme.name);
    await prefs.setString('theme_density', density.name);
    await prefs.setString('locale', localeTag);
    await prefs.setBool('input_pen_only', penOnlyInput);
    await prefs.setBool('move_with_two_fingers', inputGestures);
    await prefs.setString('document_path', documentPath);
    await prefs.setDouble('touch_sensitivity', touchSensitivity);
    await prefs.setDouble('mouse_sensitivity', mouseSensitivity);
    await prefs.setDouble('pen_sensitivity', penSensitivity);
    await prefs.setDouble('select_sensitivity', selectSensitivity);
    await prefs.setString('design', design);
    await prefs.setString('banner_visibility', bannerVisibility.name);
    await prefs.setStringList(
        'history', history.map((e) => json.encode(e.toJson())).toList());
    await prefs.setBool('zoom_enabled', zoomEnabled);
    if (lastVersion == null && prefs.containsKey('last_version')) {
      await prefs.remove('last_version');
    } else if (lastVersion != null) {
      await prefs.setString('last_version', lastVersion!);
    }
    await prefs.setStringList(
        'remotes', remotes.map((e) => json.encode(e.toJson())).toList());
    await prefs.setString('default_remote', defaultRemote);
    await prefs.setBool('native_title_bar', nativeTitleBar);
    await prefs.setBool('start_in_full_screen', startInFullScreen);
    await prefs.setString('sync_mode', syncMode.name);
    await prefs.setString(
        'input_configuration', json.encode(inputConfiguration.toJson()));
    await prefs.setString('fallback_pack', fallbackPack);
    await prefs.setStringList('starred', starred);
    await prefs.setInt('version', 0);
    await prefs.setString('default_template', defaultTemplate);
    await prefs.setString('toolbar_position', toolbarPosition.name);
    await prefs.setBool('navigation_rail', navigationRail);
    await prefs.setString('sort_by', sortBy.name);
    await prefs.setString('sort_order', sortOrder.name);
    await prefs.setDouble('image_scale', imageScale);
    await prefs.setStringList('ice_servers', iceServers);
  }

  RemoteStorage? getRemote(String? identifier) {
    return remotes
        .firstWhereOrNull((e) => e.identifier == (identifier ?? defaultRemote));
  }

  bool hasRemote(String identifier) {
    return remotes.any((e) => e.identifier == identifier);
  }

  RemoteStorage? getDefaultRemote() {
    return remotes.firstWhereOrNull((e) => e.identifier == defaultRemote);
  }

  DocumentFileSystem getDefaultDocumentFileSystem() =>
      DocumentFileSystem.fromPlatform(remote: getDefaultRemote());

  TemplateFileSystem getDefaultTemplateFileSystem() =>
      TemplateFileSystem.fromPlatform(remote: getDefaultRemote());

  bool isStarred(AssetLocation location) {
    if (location.remote.isEmpty) {
      return starred.contains(location.path);
    }
    return getRemote(location.remote)?.starred.contains(location.path) ?? false;
  }
}

class SettingsCubit extends Cubit<ButterflySettings> {
  SettingsCubit(SharedPreferences prefs, bool fullScreen)
      : super(ButterflySettings.fromPrefs(prefs, fullScreen));

  void setTheme(MediaQueryData mediaQuery, [ThemeMode? theme]) {
    if (kIsWeb || !isWindow) return;
    final brightness = switch (theme ?? state.theme) {
      ThemeMode.light => Brightness.light,
      ThemeMode.dark => Brightness.dark,
      ThemeMode.system => mediaQuery.platformBrightness,
    };
    windowManager.setBrightness(brightness);
  }

  Future<void> changeTheme(ThemeMode theme, [MediaQueryData? modify]) async {
    if (modify != null) {
      setTheme(modify, theme);
    }
    emit(state.copyWith(theme: theme));
    return save();
  }

  Future<void> changeDensity(ThemeDensity density) async {
    emit(state.copyWith(density: density));
    return save();
  }

  Future<void> changeDesign(String design) async {
    emit(state.copyWith(design: design));
    return save();
  }

  Future<void> resetDesign() async {
    emit(state.copyWith(design: ''));
    return save();
  }

  Future<void> changeLocale(Locale? locale) {
    emit(state.copyWith(localeTag: locale?.toLanguageTag() ?? ''));
    return save();
  }

  Future<void> resetLocale() {
    emit(state.copyWith(localeTag: ''));
    return save();
  }

  Future<void> changeToolbarPosition(ToolbarPosition pos) {
    emit(state.copyWith(toolbarPosition: pos));
    return save();
  }

  Future<void> resetToolbarPosition() {
    emit(state.copyWith(toolbarPosition: ToolbarPosition.top));
    return save();
  }

  void changeLocaleTemporarily(String locale) {
    emit(state.copyWith(localeTag: locale));
  }

  Future<void> changeDocumentPath(String documentPath) {
    emit(state.copyWith(documentPath: documentPath));
    return save();
  }

  Future<void> resetDocumentPath() {
    emit(state.copyWith(documentPath: ''));
    return save();
  }

  Future<void> changePenOnlyInput(bool penOnlyInput) {
    emit(state.copyWith(penOnlyInput: penOnlyInput));
    return save();
  }

  Future<void> resetPenOnlyInput() {
    emit(state.copyWith(penOnlyInput: false));
    return save();
  }

  Future<void> changeInputGestures(bool inputGestures) {
    emit(state.copyWith(inputGestures: inputGestures));
    return save();
  }

  Future<void> changeTouchSensitivity(double sensitivity) {
    emit(state.copyWith(touchSensitivity: sensitivity));
    return save();
  }

  Future<void> resetTouchSensitivity() {
    emit(state.copyWith(touchSensitivity: 1));
    return save();
  }

  Future<void> changeMouseSensitivity(double sensitivity) {
    emit(state.copyWith(mouseSensitivity: sensitivity));
    return save();
  }

  Future<void> resetMouseSensitivity() {
    emit(state.copyWith(mouseSensitivity: 1));
    return save();
  }

  Future<void> changePenSensitivity(double sensitivity) {
    emit(state.copyWith(penSensitivity: sensitivity));
    return save();
  }

  Future<void> resetPenSensitivity() {
    emit(state.copyWith(penSensitivity: 1));
    return save();
  }

  Future<void> changeSelectSensitivity(double sensitivity) {
    emit(state.copyWith(selectSensitivity: sensitivity));
    return save();
  }

  Future<void> resetSelectSensitivity() {
    emit(state.copyWith(selectSensitivity: 1));
    return save();
  }

  Future<void> changeBannerVisibility(BannerVisibility visibility) {
    emit(state.copyWith(bannerVisibility: visibility));
    return save();
  }

  Future<void> addRecentHistory(AssetLocation location) async {
    final history = state.history.toList();
    if (!location.path.startsWith('/')) {
      location = AssetLocation(
        path: '/${location.path}',
        remote: location.remote,
      );
    }
    history.remove(location);
    history.insert(0, location);
    if (history.length > 10) {
      history.removeLast();
    }
    emit(state.copyWith(history: history));
    return save();
  }

  Future<void> removeRecentHistory(AssetLocation location) async {
    final history = state.history.toList();
    history.remove(location);
    emit(state.copyWith(history: history));
    return save();
  }

  Future<void> resetRecentHistory() {
    emit(state.copyWith(history: []));
    return save();
  }

  Future<void> changeZoomEnabled(bool value) {
    emit(state.copyWith(zoomEnabled: value));
    return save();
  }

  Future<void> resetZoomEnabled() => changeZoomEnabled(true);

  Future<void> changeStartInFullScreen(bool value) {
    emit(state.copyWith(startInFullScreen: value));
    return save();
  }

  bool isFirstStart() {
    return state.lastVersion == null;
  }

  Future<bool> hasNewerVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version != state.lastVersion;
  }

  Future<void> updateLastVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    emit(state.copyWith(lastVersion: packageInfo.version));
    return save();
  }

  Future<void> save() => state.save();

  Future<void> addRemote(RemoteStorage storage, {required String password}) {
    emit(state.copyWith(
        remotes: List.from(state.remotes)
          ..removeWhere((element) => element.identifier == storage.identifier)
          ..add(storage)));
    storage.writeRemotePassword(password);
    return save();
  }

  Future<void> deleteRemote(String identifier) async {
    emit(state.copyWith(
        remotes:
            state.remotes.where((r) => r.identifier != identifier).toList()));
    const FlutterSecureStorage().delete(key: 'remotes/$identifier');
    return save();
  }

  Future<void> setDefaultRemote(String identifier) async {
    emit(state.copyWith(defaultRemote: identifier));
    return save();
  }

  Future<void> addCache(String identifier, String current) async {
    if (current.endsWith('/')) {
      current = current.substring(0, current.length - 1);
    }
    if (!current.startsWith('/')) {
      current = '/$current';
    }
    emit(state.copyWith(
        remotes: List<RemoteStorage>.from(state.remotes).map((e) {
      if (e.identifier == identifier) {
        final documents = List<String>.from(e.cachedDocuments);
        return e.copyWith(
            cachedDocuments: documents
              ..removeWhere((element) => element == current)
              ..add(current));
      }
      return e;
    }).toList()));
    return save();
  }

  Future<void> removeCache(String identifier, String current) {
    emit(state.copyWith(
        remotes: List<RemoteStorage>.from(state.remotes).map((e) {
      if (e.identifier == identifier) {
        return e.copyWith(
            cachedDocuments: List<String>.from(e.cachedDocuments)
              ..remove(current));
      }
      return e;
    }).toList()));
    return save();
  }

  Future<void> updateLastSynced(String identifier) {
    emit(state.copyWith(
        remotes: List<RemoteStorage>.from(state.remotes).map((e) {
      if (e.identifier == identifier) {
        return e.copyWith(lastSynced: DateTime.now().toUtc());
      }
      return e;
    }).toList()));
    return save();
  }

  Future<void> clearCaches(RemoteStorage storage) {
    emit(state.copyWith(
        remotes: List<RemoteStorage>.from(state.remotes).map((e) {
      if (e.identifier == storage.identifier) {
        return e.copyWith(cachedDocuments: []);
      }
      return e;
    }).toList()));
    return save();
  }

  void setNativeTitleBar([bool? value]) {
    if (kIsWeb || !isWindow) return;
    windowManager.setTitleBarStyle(
        (value ?? state.nativeTitleBar)
            ? TitleBarStyle.normal
            : TitleBarStyle.hidden,
        windowButtonVisibility: state.nativeTitleBar);
  }

  Future<void> changeNativeTitleBar(bool value, [bool modify = true]) {
    if (modify) setNativeTitleBar(value);
    emit(state.copyWith(nativeTitleBar: value));
    return save();
  }

  Future<void> resetNativeTitleBar() => changeNativeTitleBar(false);

  Future<void> changeSyncMode(SyncMode syncMode) {
    emit(state.copyWith(syncMode: syncMode));
    return save();
  }

  Future<void> changeInputConfiguration(InputConfiguration inputConfiguration) {
    emit(state.copyWith(inputConfiguration: inputConfiguration));
    return save();
  }

  RemoteStorage? getRemote([String? remote]) {
    return state.remotes.firstWhereOrNull(
        (element) => element.identifier == (remote ?? state.defaultRemote));
  }

  Future<void> toggleStarred(AssetLocation location) {
    if (location.remote.isEmpty) {
      final starred = state.starred.toList();
      if (starred.contains(location.path)) {
        starred.remove(location.path);
      } else {
        starred.add(location.path);
      }
      emit(state.copyWith(starred: starred));
    } else {
      final remote = getRemote(location.remote);
      if (remote != null) {
        final starred = remote.starred.toList();
        if (starred.contains(location.path)) {
          starred.remove(location.path);
        } else {
          starred.add(location.path);
        }
        emit(state.copyWith(
            remotes: List<RemoteStorage>.from(state.remotes).map((e) {
          if (e.identifier == remote.identifier) {
            return e.copyWith(starred: starred);
          }
          return e;
        }).toList()));
      }
    }
    return save();
  }

  Future<void> changeNavigatorEnabled(bool value) {
    emit(state.copyWith(navigatorEnabled: value));
    return save();
  }

  Future<void> changeDefaultTemplate(String name) {
    emit(state.copyWith(defaultTemplate: name));
    return save();
  }

  void setNavigatorPage(NavigatorPage page) {
    emit(state.copyWith(navigatorPage: page));
  }

  void setFullScreen(bool value, [bool modify = true]) {
    if (value != state.fullScreen && modify) {
      full_screen_api.setFullScreen(value);
    }
    emit(state.copyWith(fullScreen: value));
  }

  void toggleFullScreen() => setFullScreen(!state.fullScreen);

  Future<void> changeNavigationRail(bool value) {
    emit(state.copyWith(navigationRail: value));
    return save();
  }

  Future<void> changeSortBy(SortBy value) {
    emit(state.copyWith(sortBy: value));
    return save();
  }

  Future<void> changeSortOrder(SortOrder value) {
    emit(state.copyWith(sortOrder: value));
    return save();
  }

  Future<void> changeImageScale(double value) {
    emit(state.copyWith(imageScale: value));
    return save();
  }

  Future<void> resetImageScale() => changeImageScale(0.5);

  Future<void> changePdfQuality(double value) {
    emit(state.copyWith(pdfQuality: value));
    return save();
  }

  Future<void> resetPdfQuality() => changePdfQuality(2);

  Future<void> changePlatformTheme(PlatformTheme locale) {
    emit(state.copyWith(platformTheme: locale));
    return save();
  }

  Future<void> resetPlatformTheme() =>
      changePlatformTheme(PlatformTheme.system);

  Future<void> addIceServer(String server) {
    emit(state.copyWith(iceServers: {...state.iceServers, server}.toList()));
    return save();
  }

  Future<void> removeIceServer(String server) {
    emit(state.copyWith(
        iceServers:
            state.iceServers.where((element) => element != server).toList()));
    return save();
  }

  Future<void> resetIceServers() {
    emit(state.copyWith(iceServers: kDefaultIceServers));
    return save();
  }
}
