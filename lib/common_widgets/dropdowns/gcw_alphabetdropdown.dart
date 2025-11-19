import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_dropdown.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';

class GCWAlphabetDropDown<T> extends StatefulWidget {
  final void Function(T) onChanged;
  final void Function(String)? onCustomAlphabetChanged;
  final Map<T, String> items;
  final Map<T, String>? subtitles;
  final T? customModeKey;
  final T value;
  final TextEditingController? textFieldController;
  final String? textFieldHintText;

  const GCWAlphabetDropDown({
    super.key,
    required this.value,
    required this.items,
    this.subtitles,
    required this.onChanged,
    this.onCustomAlphabetChanged,
    this.customModeKey,
    this.textFieldController,
    this.textFieldHintText,
  });

  @override
  _GCWAlphabetDropDownState<T> createState() => _GCWAlphabetDropDownState<T>();
}

class _GCWAlphabetDropDownState<T> extends State<GCWAlphabetDropDown<T>> {
  T? _currentMode;

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      GCWDropDown<T>(
        value: widget.value,
        onChanged: (value) {
          setState(() {
            _currentMode = value;
            widget.onChanged(value);
          });
        },
        items: widget.items.entries.map((mode) {
          return GCWDropDownMenuItem(
            value: mode.key,
            child: mode.value,
            subtitle: widget.subtitles?[mode.key] ?? ''
          );
        }).toList(),
      ),
      if (widget.customModeKey != null && _currentMode == widget.customModeKey)
        GCWTextField(
          hintText: widget.textFieldHintText ?? i18n(context, 'common_alphabet'),
          controller: widget.textFieldController,
          onChanged: widget.onCustomAlphabetChanged,
        ),
    ]);
  }
}
