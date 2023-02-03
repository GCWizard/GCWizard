import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/app_localizations.dart';
import 'package:gc_wizard/application/theme/theme_colors.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_dropdown.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';

class GCWAlphabetDropDown extends StatefulWidget {
  final Function onChanged;
  final Function onCustomAlphabetChanged;
  final Map<dynamic, String> items;
  final customModeKey;
  final value;
  final textFieldController;
  final textFieldHintText;

  const GCWAlphabetDropDown({
    Key key,
    this.value,
    this.items,
    this.onChanged,
    this.onCustomAlphabetChanged,
    this.customModeKey,
    this.textFieldController,
    this.textFieldHintText,
  }) : super(key: key);

  @override
  _GCWAlphabetDropDownState createState() => _GCWAlphabetDropDownState();
}

class _GCWAlphabetDropDownState extends State<GCWAlphabetDropDown> {
  dynamic _currentMode;

  @override
  Widget build(BuildContext context) {
    ThemeColors colors = themeColors();

    return Column(children: <Widget>[
      GCWDropDown(
        value: widget.value,
        onChanged: (value) {
          setState(() {
            _currentMode = value;
            widget.onChanged(_currentMode);
          });
        },
        items: widget.items.entries.map((mode) {
          return GCWDropDownMenuItem(value: mode.key, child: mode.value);
        }).toList(),
      ),
      if (_currentMode == widget.customModeKey)
        GCWTextField(
          hintText: widget.textFieldHintText == null ? i18n(context, 'common_alphabet') : widget.textFieldHintText,
          controller: widget.textFieldController,
          onChanged: widget.onCustomAlphabetChanged,
        ),
    ]);
  }
}
