import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SaveDialog extends StatelessWidget {
  final String data;
  const SaveDialog({Key? key, required this.data}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var isMobile = Platform.isAndroid || Platform.isIOS;
    return AlertDialog(
        title: Row(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Icon(PhosphorIcons.floppyDiskLight),
            ),
            Text(AppLocalizations.of(context)!.save),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(AppLocalizations.of(context)!.cancel)),
        ],
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          ListTile(
              onTap: () {
                Clipboard.setData(ClipboardData(text: data));
                Navigator.of(context).pop();
              },
              title: Text(AppLocalizations.of(context)!.clipboard)),
          if (!kIsWeb && !isMobile)
            ListTile(
                onTap: () {
                  FilePicker.platform.saveFile(
                      fileName: "butterfly.json",
                      type: FileType.custom,
                      allowedExtensions: ["json"]).then((value) {
                    if (value == null) {
                      return;
                    }
                    var fileName = value;
                    if (!fileName.endsWith(".json")) fileName += ".json";
                    var file = File(fileName);
                    void write() {
                      file.writeAsStringSync(data);
                      Navigator.of(context).pop();
                    }

                    if (!file.existsSync()) {
                      write();
                    } else {
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                title: Text(
                                    AppLocalizations.of(context)!.areYouSure),
                                content: Text(AppLocalizations.of(context)!
                                    .existOverride),
                                actions: [
                                  TextButton(
                                      child: Text(
                                          AppLocalizations.of(context)!.no),
                                      onPressed: () =>
                                          Navigator.of(context).pop()),
                                  TextButton(
                                      child: Text(
                                          AppLocalizations.of(context)!.yes),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        write();
                                      })
                                ],
                              ));
                    }
                  });
                },
                title: Text(AppLocalizations.of(context)!.file)),
          if (!kIsWeb && isMobile)
            ListTile(
                onTap: () {
                  Share.share(data);
                  Navigator.of(context).pop();
                },
                title: Text(AppLocalizations.of(context)!.share)),
        ]));
  }
}
