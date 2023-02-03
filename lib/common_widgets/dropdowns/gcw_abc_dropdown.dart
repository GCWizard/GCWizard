import 'package:flutter/material.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_dropdown.dart';
import 'package:gc_wizard/utils/alphabets.dart';

class GCWABCDropDown extends StatefulWidget {
  final Function onChanged;
  final value;

  const GCWABCDropDown({
    Key key,
    this.onChanged,
    this.value,
  }) : super(key: key);

  @override
  GCWABCDropDownState createState() => GCWABCDropDownState();
}

class GCWABCDropDownState extends State<GCWABCDropDown> {
  int _currentValue;

  @override
  Widget build(BuildContext context) {
    return GCWDropDown(
      value: _currentValue ?? widget.value ?? 1,
      onChanged: (newValue) {
        setState(() {
          _currentValue = newValue;
          widget.onChanged(_currentValue);
        });
      },
      items: alphabet_AZ.entries.map((entry) {
        return GCWDropDownMenuItem(
          value: entry.value,
          child: '${entry.key} (${entry.value})',
        );
      }).toList(),
    );
  }
}
