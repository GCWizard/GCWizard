import 'package:flutter/material.dart';
import 'package:gc_wizard/theme/theme.dart';
import 'package:gc_wizard/utils/alphabets.dart';
import 'package:gc_wizard/tools/common/gcw_dropdown_spinner/widget/gcw_dropdown_spinner.dart';
import 'package:gc_wizard/tools/utils/common_widget_utils/widget/common_widget_utils.dart';

class GCWABCSpinner extends StatefulWidget {
  final Function onChanged;
  final SpinnerLayout layout;
  final int value;
  final bool suppressLetterValues;
  final String title;

  const GCWABCSpinner(
      {Key key,
      this.value: 1,
      this.onChanged,
      this.layout: SpinnerLayout.HORIZONTAL,
      this.suppressLetterValues: false,
      this.title})
      : super(key: key);

  @override
  GCWABCSpinnerState createState() => GCWABCSpinnerState();
}

class GCWABCSpinnerState extends State<GCWABCSpinner> {
  var _currentValue;

  @override
  Widget build(BuildContext context) {
    return GCWDropDownSpinner(
      title: widget.title,
      index: _currentValue ?? (widget.value != null ? widget.value - 1 : null) ?? 0,
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
          widget.onChanged(_currentValue + 1);
        });
      },
    );
  }
}
