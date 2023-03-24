import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gc_wizard/application/theme/theme.dart';

WidgetSpan superscriptedTextForRichText(String text, {TextStyle? textStyle}) {
  var style = textStyle ?? gcwTextStyle();

  return WidgetSpan(
      child: Transform.translate(
          offset: Offset(0.0, -1 * defaultFontSize() / 2.0),
          child: Text(text, style: style.copyWith(fontSize: defaultFontSize() / 1.4))));
}

WidgetSpan subscriptedTextForRichText(String text, {TextStyle? textStyle}) {
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
Object buildSubOrSuperscriptedRichTextIfNecessary(String input) {
  var supSubRegExp = RegExp(r'(\^(.+?)\^|_(.+?)_)');

  if (supSubRegExp.hasMatch(input)) {
    var textSpans = <InlineSpan>[];

    var lastEnd = 0;
    supSubRegExp.allMatches(input).forEach((element) {
      textSpans.add(TextSpan(text: input.substring(lastEnd, element.start)));

      WidgetSpan widgetSpan;
      if (element.group(1)!.startsWith('_')) {
        widgetSpan = subscriptedTextForRichText(element.group(1)!.replaceAll('_', ''));
      } else {
        widgetSpan = superscriptedTextForRichText(element.group(1)!.replaceAll('^', ''));
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