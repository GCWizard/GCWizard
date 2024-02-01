import 'package:code_text_field/code_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_highlight/themes/atom-one-dark.dart';
import 'package:flutter_highlight/themes/atom-one-light.dart';
import 'package:gc_wizard/application/settings/logic/preferences.dart';
import 'package:gc_wizard/application/theme/theme.dart';
import 'package:gc_wizard/application/theme/theme_colors.dart';
import 'package:gc_wizard/common_widgets/gcw_textselectioncontrols.dart';
import 'package:highlight/highlight_core.dart';
import 'package:highlight/languages/basic.dart';
import 'package:highlight/languages/lua.dart';
import 'package:prefs/prefs.dart';

enum CodeHighlightingLanguage { LUA, BASIC }

class GCWCodeTextField extends StatefulWidget {
  final TextEditingController controller;
  final void Function(String)? onChanged;
  final Map<String, TextStyle>? patternMap; // Regexes
  final Map<String, TextStyle>? stringMap; // complete strings
  final Map<String, TextStyle>? theme;
  TextStyle? textStyle;
  final bool readOnly;
  final bool? wrap;
  final CodeHighlightingLanguage? language;
  final bool? lineNumbers;
  final GCWCodeTextFieldLineNumberStyle? lineNumberStyle;

  GCWCodeTextField(
      {Key? key,
      this.onChanged,
      required this.controller,
      this.stringMap,
      this.patternMap,
      this.theme,
      this.readOnly = true,
      this.wrap,
      this.language,
      this.lineNumbers = false,
      this.lineNumberStyle})
      : super(key: key) {
    textStyle ??= gcwMonotypeTextStyle();
  }

  @override
  _GCWCodeTextFieldState createState() => _GCWCodeTextFieldState();
}

class _GCWCodeTextFieldState extends State<GCWCodeTextField> {
  Mode? _language;

  @override
  void initState() {
    super.initState();

    if (widget.language != null) {
      switch (widget.language!) {
        case CodeHighlightingLanguage.LUA:
          _language = lua;
          break;
        case CodeHighlightingLanguage.BASIC:
          _language = basic;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return CodeTheme(
        data: CodeThemeData(
            styles: widget.theme ??
                (Prefs.getString(PREFERENCE_THEME_COLOR) == ThemeType.DARK.toString()
                    ? atomOneDarkTheme
                    : atomOneLightTheme)),
        child: CodeField(
          controller: (widget.controller is CodeController)
              ? (widget.controller as CodeController)
              : CodeController(
                  text: widget.controller.text,
                  language: _language,
                  stringMap: widget.stringMap,
                  patternMap: widget.patternMap,
                ),
          readOnly: widget.readOnly,
          selectionControls: GCWTextSelectionControls(),
          wrap: widget.wrap ?? false,
          textStyle: widget.textStyle ?? const TextStyle(fontFamily: 'SourceCode'),
          lineNumbers: widget.lineNumbers!,
          lineNumberStyle: widget.lineNumberStyle != null
              ? LineNumberStyle(
                  width: widget.lineNumberStyle!.width,
                )
              : const LineNumberStyle(
                  width: 0.0, margin: 0.0, textStyle: TextStyle(fontSize: 0.1, color: Colors.black54)),
          onChanged: widget.onChanged,
        ));
  }
}

class GCWCodeTextFieldLineNumberStyle {
  /// Width of the line number column
  final double width;

  const GCWCodeTextFieldLineNumberStyle({
    this.width = 42.0,
  });
}

Mode? getLanguage(CodeHighlightingLanguage? language) {
  if (language != null) {
    switch (language) {
      case CodeHighlightingLanguage.LUA:
        return lua;
      case CodeHighlightingLanguage.BASIC:
        return basic;
    }
  }
  return null;
}
