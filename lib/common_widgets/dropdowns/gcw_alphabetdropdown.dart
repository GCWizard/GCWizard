import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/app_localizations.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_dropdown.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';

class GCWAlphabetDropDown<T extends Object?> extends StatefulWidget {
  final void Function(T) onChanged;
  final void Function(String)? onCustomAlphabetChanged;
  final Map<Object, String> items;
  final Object customModeKey;
  final Object value;
  final TextEditingController? textFieldController;
  final String? textFieldHintText;

  const GCWAlphabetDropDown({
    Key? key,
    required this.value,
    required this.items,
    required this.onChanged,
    this.onCustomAlphabetChanged,
    required this.customModeKey,
    this.textFieldController,
    this.textFieldHintText,
  }) : super(key: key);

  @override
  _GCWAlphabetDropDownState createState() => _GCWAlphabetDropDownState();
}

class _GCWAlphabetDropDownState extends State<GCWAlphabetDropDown> {
  Object? _currentMode;

  @override
  Widget build(BuildContext context) {

    return Column(children: <Widget>[
      GCWDropDown<Object>(
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
          hintText: widget.textFieldHintText ?? i18n(context, 'common_alphabet'),
          controller: widget.textFieldController,
          onChanged: widget.onCustomAlphabetChanged,
        ),
    ]);
  }
}
