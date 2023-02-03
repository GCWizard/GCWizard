import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/app_localizations.dart';
import 'package:gc_wizard/common_widgets/dialogs/gcw_dialog.dart';

showDeleteAlertDialog(BuildContext context, String deleteableText, Function onOKPressed) {
  showGCWAlertDialog(context, i18n(context, 'common_deletealtert_title'),
      i18n(context, 'common_deletealtert_text', parameters: [deleteableText]), onOKPressed);
}
