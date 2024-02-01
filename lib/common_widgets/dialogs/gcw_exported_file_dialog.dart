import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/application/theme/theme_colors.dart';
import 'package:gc_wizard/common_widgets/dialogs/gcw_dialog.dart';

void showExportedFileDialog(BuildContext context, {Widget? contentWidget}) {
  showGCWDialog(
      context,
      i18n(context, 'common_exportfile_saved'),
      contentWidget == null
          ? null
          : Column(
              children: [contentWidget],
            ),
      [
        GCWDialogButton(
          text: i18n(context, 'common_ok'),
        )
      ],
      cancelButton: false);
}

Widget imageContent(BuildContext context, Uint8List data) {
  return Container(
      margin: const EdgeInsets.only(top: 25),
      decoration: BoxDecoration(border: Border.all(color: themeColors().dialogText())),
      child: Image.memory(data));
}
