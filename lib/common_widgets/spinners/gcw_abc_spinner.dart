import 'package:flutter/material.dart';
import 'package:gc_wizard/application/theme/theme.dart';
import 'package:gc_wizard/common_widgets/spinners/gcw_dropdown_spinner.dart';
import 'package:gc_wizard/common_widgets/spinners/spinner_constants.dart';
import 'package:gc_wizard/utils/alphabets.dart';

class GCWABCSpinner extends StatefulWidget {
  final void Function(int) onChanged;
  final SpinnerLayout layout;
  final int value;
  final bool suppressLetterValues;
  final String? title;

  const GCWABCSpinner(
      {Key? key,
      this.value = 1,
      required this.onChanged,
      this.layout = SpinnerLayout.HORIZONTAL,
      this.suppressLetterValues = false,
      this.title})
      : super(key: key);

  @override
  _GCWABCSpinnerState createState() => _GCWABCSpinnerState();
}

class _GCWABCSpinnerState extends State<GCWABCSpinner> {
  int? _currentValue;

  @override
  Widget build(BuildContext context) {
    return GCWDropDownSpinner(
      title: widget.title,
      index: _currentValue ?? widget.value - 1,
      layout: widget.layout,
      items: alphabet_AZ.entries.map((entry) {
        var text = entry.key;
        if (!widget.suppressLetterValues) text += ' (${entry.value})';

        return Text(
          text,
          style: gcwTextStyle(),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _currentValue = value;
          widget.onChanged(_currentValue! + 1);
        });
      },
    );
  }
}
