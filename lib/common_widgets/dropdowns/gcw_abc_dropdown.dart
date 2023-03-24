import 'package:flutter/material.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_dropdown.dart';
import 'package:gc_wizard/utils/alphabets.dart';

class GCWABCDropDown extends StatefulWidget {
  final void Function(int) onChanged;
  final int? value;

  const GCWABCDropDown({
    Key? key,
    required this.onChanged,
    this.value,
  }) : super(key: key);

  @override
  GCWABCDropDownState createState() => GCWABCDropDownState();
}

class GCWABCDropDownState extends State<GCWABCDropDown> {
  int? _currentValue;

  @override
  Widget build(BuildContext context) {
    return GCWDropDown(
      value: _currentValue ?? widget.value ?? 1,
      onChanged: (newValue) {
        setState(() {
          _currentValue = newValue is int ? newValue : _currentValue;
          widget.onChanged(_currentValue!);
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
