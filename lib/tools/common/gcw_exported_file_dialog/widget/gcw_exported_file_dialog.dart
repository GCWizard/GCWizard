import 'package:flutter/material.dart';
import 'package:gc_wizard/i18n/app_localizations.dart';
import 'package:gc_wizard/tools/common/base/gcw_dialog/widget/gcw_dialog.dart';
import 'package:gc_wizard/tools/common/base/gcw_text/widget/gcw_text.dart';
import 'package:gc_wizard/theme/theme_colors.dart';
import 'package:gc_wizard/theme/theme.dart';
import 'package:gc_wizard/tools/utils/file_utils/widget/file_utils.dart';

showExportedFileDialog(BuildContext context, {Widget contentWidget, int dialogHeight, FileType fileType}) {
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
