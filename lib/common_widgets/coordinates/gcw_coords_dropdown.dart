import 'package:flutter/material.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_dropdown.dart';

class GCWCoordsDropDown extends StatefulWidget {
  final Function onChanged;
  final String value;
  final List<dynamic> itemList;

  const GCWCoordsDropDown({Key key, this.itemList, this.onChanged, this.value}) : super(key: key);

  @override
  _GCWCoordsDropDownState createState() => _GCWCoordsDropDownState();
}

class _GCWCoordsDropDownState extends State<GCWCoordsDropDown> {
  var _dropdownValue;

  @override
  Widget build(BuildContext context) {
    return GCWDropDown(
      value: widget.value ?? _dropdownValue,
      onChanged: (newValue) {
        setState(() {
          _dropdownValue = newValue;
          widget.onChanged(newValue);
        });
      },
      items: widget.itemList.map((entry) {
        return GCWDropDownMenuItem(
          value: entry.key,
          child: entry.name,
        );
      }).toList(),
    );
  }
}
