import 'package:code_text_field/code_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_highlight/themes/atom-one-dark.dart';
import 'package:flutter_highlight/themes/atom-one-light.dart';
import 'package:gc_wizard/application/settings/logic/preferences.dart';
import 'package:gc_wizard/application/theme/theme_colors.dart';
import 'package:gc_wizard/common_widgets/gcw_textselectioncontrols.dart';
import 'package:highlight/highlight_core.dart';
import 'package:highlight/languages/lua.dart';
import 'package:prefs/prefs.dart';

enum CodeHighlightingLanguage { LUA }

class GCWCodeTextField extends StatefulWidget {
  final TextEditingController controller;
  final Map<String, TextStyle>? patternMap; // Regexes
  final Map<String, TextStyle>? stringMap; // complete strings
  final Map<String, TextStyle>? theme;
  final TextStyle? textStyle;
  final bool readOnly;
  final bool? wrap;
  final CodeHighlightingLanguage? language;
  final bool? lineNumbers;
  final GCWCodeTextFieldLineNumberStyle? lineNumberStyle;

  const GCWCodeTextField(
      {Key? key,
      required this.controller,
      this.stringMap,
      this.patternMap,
      this.theme,
      this.textStyle,
      this.readOnly = true,
      this.wrap,
      this.language,
      this.lineNumbers = false,
      this.lineNumberStyle})
      : super(key: key);

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
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return CodeTheme(
      data: CodeThemeData(styles:
          widget.theme ?? (Prefs.getString(PREFERENCE_THEME_COLOR) == ThemeType.DARK.toString()
              ? atomOneDarkTheme
              : atomOneLightTheme)
          ),
      child: CodeField(
          controller: CodeController(
            text: widget.controller.text,
            language: _language,
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
              : const LineNumberStyle(width: 0.0, margin: 0.0, textStyle: TextStyle(fontSize: 0.1, color: Colors.black54)),
        )
    );
  }
}

class GCWCodeTextFieldLineNumberStyle {
  /// Width of the line number column
  final double width;

  const GCWCodeTextFieldLineNumberStyle({
    this.width = 42.0,
  });
}
