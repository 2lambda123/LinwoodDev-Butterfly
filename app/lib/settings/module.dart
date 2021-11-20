import 'package:butterfly/settings/data.dart';
import 'package:butterfly/settings/home.dart';
import 'package:butterfly/settings/personalization.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'behaviors.dart';

class SettingsModule extends Module {
  @override
  final List<ModularRoute> routes = [
    ChildRoute('/', child: (_, args) => const SettingsPage()),
    ChildRoute('/personalization',
        child: (_, args) => const PersonalizationSettingsPage()),
    ChildRoute('/behaviors', child: (_, args) => const BehaviorsSettingsPage()),
    ChildRoute('/data', child: (_, args) => const DataSettingsPage())
  ];
}
