import 'dart:convert';
import 'dart:math';

import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gc_wizard/i18n/app_localizations.dart';
import 'package:gc_wizard/theme/theme.dart';
import 'package:gc_wizard/theme/theme_colors.dart';
import 'package:gc_wizard/utils/settings/preferences.dart';
import 'package:gc_wizard/widgets/common/base/gcw_iconbutton.dart';
import 'package:gc_wizard/widgets/common/base/gcw_text.dart';
import 'package:gc_wizard/widgets/common/base/gcw_toast.dart';
import 'package:gc_wizard/widgets/common/gcw_tool.dart';
import 'package:prefs/prefs.dart';
import 'package:url_launcher/url_launcher.dart' as urlLauncher;

String className(Widget widget) {
  return widget.runtimeType.toString();
}

enum SpinnerLayout { HORIZONTAL, VERTICAL }

String printErrorMessage(BuildContext context, String message) {
  return i18n(context, 'common_error') + ': ' + i18n(context, message);
}

defaultFontSize() {
  var fontSize = Prefs.get(PREFERENCE_THEME_FONT_SIZE);

  if (fontSize < FONT_SIZE_MIN) {
    Prefs.setDouble(PREFERENCE_THEME_FONT_SIZE, FONT_SIZE_MIN.toDouble());
    return FONT_SIZE_MIN;
  }

  if (fontSize > FONT_SIZE_MAX) {
    Prefs.setDouble(PREFERENCE_THEME_FONT_SIZE, FONT_SIZE_MAX.toDouble());
    return FONT_SIZE_MAX;
  }

  return fontSize;
}

WidgetSpan superscriptedTextForRichText(String text, {TextStyle textStyle}) {
  var style = textStyle ?? gcwTextStyle();

  return WidgetSpan(
      child: Transform.translate(
          offset: Offset(0.0, -1 * defaultFontSize() / 2.0),
          child: Text(text, style: style.copyWith(fontSize: defaultFontSize() / 1.4))));
}

WidgetSpan subscriptedTextForRichText(String text, {TextStyle textStyle}) {
  var style = textStyle ?? gcwTextStyle();

  return WidgetSpan(
      child: Transform.translate(
          offset: Offset(0.0, defaultFontSize() / 4.0),
          child: Text(text, style: style.copyWith(fontSize: defaultFontSize() / 1.4))));
}

/* Takes string input. If "_foo_" or "^bar^" exists, a RichText widget with
   sub- or superscripted TextSpans will be created,
   otherwise the input will be returned as String
*/
buildSubOrSuperscriptedRichTextIfNecessary(String input) {
  var supSubRegExp = RegExp(r'(\^(.+?)\^|_(.+?)_)');

  if (supSubRegExp.hasMatch(input)) {
    var textSpans = <InlineSpan>[];

    var lastEnd = 0;
    supSubRegExp.allMatches(input).forEach((element) {
      textSpans.add(TextSpan(text: input.substring(lastEnd, element.start)));

      var widgetSpan;
      if (element.group(1).startsWith('_')) {
        widgetSpan = subscriptedTextForRichText(element.group(1).replaceAll('_', ''));
      } else {
        widgetSpan = superscriptedTextForRichText(element.group(1).replaceAll('^', ''));
      }

      textSpans.add(widgetSpan);
      lastEnd = element.end;
    });

    if (lastEnd < input.length) {
      textSpans.add(TextSpan(text: input.substring(lastEnd)));
    }

    return RichText(text: TextSpan(style: gcwTextStyle(), children: textSpans));
  } else {
    return input;
  }
}

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

String textControllerInsertText(String input, String currentText, TextEditingController textController) {
  var cursorPosition = max(textController.selection.end, 0);

  currentText = currentText.substring(0, cursorPosition) + input + currentText.substring(cursorPosition);
  textController.text = currentText;
  textController.selection = TextSelection.collapsed(offset: cursorPosition + input.length);

  return currentText;
}

String textControllerDoBackSpace(String currentText, TextEditingController textController) {
  var cursorPosition = max(textController.selection.end, 0);
  if (cursorPosition == 0) return currentText;

  currentText = currentText.substring(0, cursorPosition - 1) + currentText.substring(cursorPosition);
  textController.text = currentText;
  textController.selection = TextSelection.collapsed(offset: cursorPosition - 1);

  return currentText;
}

double maxScreenHeight(BuildContext context) {
  return MediaQuery.of(context).size.height - 100;
}

int _sortToolListAlphabetically(GCWTool a, GCWTool b) {
  return removeDiacritics(a.toolName).toLowerCase().compareTo(removeDiacritics(b.toolName).toLowerCase());
}

int sortToolList(GCWTool a, GCWTool b) {
  if (Prefs.getBool(PREFERENCE_TOOL_COUNT_SORT) != null && !Prefs.getBool(PREFERENCE_TOOL_COUNT_SORT)) {
    return _sortToolListAlphabetically(a, b);
  }

  Map<String, int> toolCounts = Map<String, int>.from(jsonDecode(Prefs.get(PREFERENCE_TOOL_COUNT)));

  var toolCountA = toolCounts[a.id];
  var toolCountB = toolCounts[b.id];

  if (toolCountA == null && toolCountB == null) {
    return _sortToolListAlphabetically(a, b);
  }

  if (toolCountA == null && toolCountB != null) {
    return 1;
  }

  if (toolCountA != null && toolCountB == null) {
    return -1;
  }

  if (toolCountA != null && toolCountB != null) {
    if (toolCountA == toolCountB) {
      return _sortToolListAlphabetically(a, b);
    } else {
      return toolCountB.compareTo(toolCountA);
    }
  }

  return null;
}

Future<bool> launchUrl(Uri url) async {
  return urlLauncher.launchUrl(url, mode: urlLauncher.LaunchMode.externalApplication);
}
