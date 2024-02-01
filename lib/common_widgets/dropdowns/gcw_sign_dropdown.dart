import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_dropdown.dart';

class GCWSignDropDown extends StatefulWidget {
  final void Function(int) onChanged;
  final int? value;
  final List<String> itemList;
  final String? title;

  const GCWSignDropDown({Key? key, required this.itemList, required this.onChanged, this.value = 1, this.title})
      : super(key: key);

  @override
  _GCWSignDropDownState createState() => _GCWSignDropDownState();
}

class _GCWSignDropDownState extends State<GCWSignDropDown> {
  var _dropdownValue = 1;

  @override
  Widget build(BuildContext context) {
    return GCWDropDown<int>(
      title: widget.title,
      value: widget.value ?? _dropdownValue,
      onChanged: (newValue) {
        setState(() {
          _dropdownValue = newValue;
          widget.onChanged(_dropdownValue);
        });
      },
      items: widget.itemList.map((char) {
        var _value = 1;
        if (['S', 'W', '-', i18n(context, 'coords_common_south'), i18n(context, 'coords_common_west')].contains(char)) {
          _value = -1;
        }

        return GCWDropDownMenuItem(
          value: _value,
          child: char,
        );
      }).toList(),
    );
  }
}
