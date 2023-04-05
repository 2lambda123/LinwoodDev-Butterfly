part of '../selection.dart';

class ImageElementSelection extends ElementSelection<ImageElement> {
  ImageElementSelection(super.selected);

  @override
  List<Widget> buildProperties(BuildContext context) {
    final element = selected.first.element;
    return [
      ...super.buildProperties(context),
      ConstraintsView(
        enableScaled: true,
        initialConstraints: element.constraints,
        onChanged: (constraints) => updateElements(context,
            elements.map((e) => e.copyWith(constraints: constraints)).toList()),
      ),
      ListTile(
        title: Text(AppLocalizations.of(context).export),
        leading: PhosphorIcon(PhosphorIcons.light.export),
        onTap: () async {
          final localization = AppLocalizations.of(context);
          final data = await element.getData();
          if (!kIsWeb &&
              (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
            var path = await FilePicker.platform.saveFile(
              type: FileType.image,
              fileName: 'export.png',
              dialogTitle: localization.export,
            );
            if (path != null) {
              var file = File(path);
              if (!(await file.exists())) {
                file.create(recursive: true);
              }
              await file.writeAsBytes(data);
            }
          } else {
            openImage(data);
          }
        },
      ),
    ];
  }

  @override
  Selection insert(element) {
    if (element is Renderer<ImageElement>) {
      return ImageElementSelection([...selected, element]);
    }
    return super.insert(element);
  }

  @override
  PhosphorIconData getIcon({bool filled = false}) =>
      filled ? PhosphorIcons.fill.image : PhosphorIcons.light.image;

  @override
  String getLocalizedName(BuildContext context) =>
      AppLocalizations.of(context).image;
}
