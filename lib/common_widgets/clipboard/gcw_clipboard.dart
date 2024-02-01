import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/application/settings/logic/preferences.dart';
import 'package:gc_wizard/common_widgets/gcw_snackbar.dart';
import 'package:gc_wizard/utils/data_type_utils/object_type_utils.dart';
import 'package:gc_wizard/utils/json_utils.dart';
import 'package:prefs/prefs.dart';

String _CLIPBOARD_ITEM_FIELD_TEXT = 'text';
String _CLIPBOARD_ITEM_FIELD_CREATED = 'created';

class ClipboardItem {
  String text;
  DateTime datetime;

  ClipboardItem(this.text, this.datetime);

  static ClipboardItem? fromJson(String jsonString) {
    var decoded = jsonDecode(jsonString);
    if (decoded == null || !(isJsonMap(decoded))) {
      return null;
    }

    var created = toStringOrNull(decoded[_CLIPBOARD_ITEM_FIELD_CREATED]) ?? '0';

    int createdValue = int.tryParse(created) ?? 0;
    DateTime datetime = DateTime.fromMillisecondsSinceEpoch(createdValue);

    var text = toStringOrNull(decoded[_CLIPBOARD_ITEM_FIELD_TEXT]) ?? '';
    return ClipboardItem(text, datetime);
  }

  String toJson() {
    return jsonEncode(
        {_CLIPBOARD_ITEM_FIELD_TEXT: text, _CLIPBOARD_ITEM_FIELD_CREATED: datetime.microsecondsSinceEpoch.toString()});
  }

  @override
  String toString() {
    return 'text ($datetime)';
  }
}

void insertIntoGCWClipboard(BuildContext context, String text, {bool useGlobalClipboard = true}) async {
  if (useGlobalClipboard) Clipboard.setData(ClipboardData(text: text));

  var gcwClipboard = Prefs.getStringList(PREFERENCE_CLIPBOARD_ITEMS);

  String? existingText = gcwClipboard.firstWhereOrNull((item) => jsonDecode(item)['text'] == text);

  if (existingText != null) {
    gcwClipboard.remove(existingText);
    gcwClipboard.insert(
        0,
        jsonEncode({
          _CLIPBOARD_ITEM_FIELD_TEXT: jsonDecode(existingText)[_CLIPBOARD_ITEM_FIELD_TEXT],
          _CLIPBOARD_ITEM_FIELD_CREATED: DateTime.now().millisecondsSinceEpoch.toString()
        }));
  } else {
    gcwClipboard.insert(
        0,
        jsonEncode({
          _CLIPBOARD_ITEM_FIELD_TEXT: text,
          _CLIPBOARD_ITEM_FIELD_CREATED: DateTime.now().millisecondsSinceEpoch.toString()
        }));
    while (gcwClipboard.length > Prefs.getInt(PREFERENCE_CLIPBOARD_MAX_ITEMS)) {
      gcwClipboard.removeLast();
    }
  }

  Prefs.setStringList(PREFERENCE_CLIPBOARD_ITEMS, gcwClipboard);

  if (useGlobalClipboard) showSnackBar(i18n(context, 'common_clipboard_copied') + ':\n\n' + text, context);
}
