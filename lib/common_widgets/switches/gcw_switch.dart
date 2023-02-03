import 'package:flutter/material.dart';

class GCWSwitch extends StatefulWidget {
  final Function onChanged;
  final value;
  final inactiveTrackColor;
  final inactiveThumbColor;
  final activeThumbColor;
  final activeTrackColor;

  const GCWSwitch(
      {Key key,
      this.value: false,
      this.onChanged,
      this.inactiveThumbColor,
      this.inactiveTrackColor,
      this.activeThumbColor,
      this.activeTrackColor})
      : super(key: key);

  @override
  _GCWSwitchState createState() => _GCWSwitchState();
}

class _GCWSwitchState extends State<GCWSwitch> {
  var _currentValue;

  @override
  Widget build(BuildContext context) {
    return Switch(
        value: widget.value ?? _currentValue,
        onChanged: (value) {
          setState(() {
            _currentValue = value;
            widget.onChanged(_currentValue);
          });
        },
        activeColor: widget.activeThumbColor,
        activeTrackColor: widget.activeTrackColor,
        inactiveTrackColor: widget.inactiveTrackColor,
        inactiveThumbColor: widget.inactiveThumbColor);
  }
}
