import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gc_wizard/application/i18n/app_localizations.dart';
import 'package:gc_wizard/application/settings/logic/preferences.dart';
import 'package:gc_wizard/common_widgets/gcw_toast.dart';
import 'package:prefs/prefs.dart';

insertIntoGCWClipboard(BuildContext context, String text, {useGlobalClipboard: true}) {
  if (useGlobalClipboard) Clipboard.setData(ClipboardData(text: text));

  var gcwClipboard = Prefs.getStringList(PREFERENCE_CLIPBOARD_ITEMS);

  var existingText = gcwClipboard.firstWhere((item) => jsonDecode(item)['text'] == text, orElse: () => null);

  if (existingText != null) {
    gcwClipboard.remove(existingText);
    gcwClipboard.insert(
        0,
        jsonEncode(
            {'text': jsonDecode(existingText)['text'], 'created': DateTime.now().millisecondsSinceEpoch.toString()}));
  } else {
    gcwClipboard.insert(0, jsonEncode({'text': text, 'created': DateTime.now().millisecondsSinceEpoch.toString()}));
    while (gcwClipboard.length > Prefs.get(PREFERENCE_CLIPBOARD_MAX_ITEMS)) gcwClipboard.removeLast();
  }

  Prefs.setStringList(PREFERENCE_CLIPBOARD_ITEMS, gcwClipboard);

  if (useGlobalClipboard) showToast(i18n(context, 'common_clipboard_copied') + ':\n' + text);
}