import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/app_localizations.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_onoff_switch.dart';

class CrosstotalSwitch extends StatefulWidget {
  final Function onChanged;

  const CrosstotalSwitch({Key key, this.onChanged}) : super(key: key);

  @override
  _CrosstotalSwitchState createState() => _CrosstotalSwitchState();
}

class _CrosstotalSwitchState extends State<CrosstotalSwitch> {
  var _currentValue = true;

  @override
  Widget build(BuildContext context) {
    return GCWOnOffSwitch(
      title: i18n(context, 'crosstotal_title'),
      value: _currentValue,
      onChanged: (value) {
        setState(() {
          _currentValue = value;
          widget.onChanged(_currentValue);
        });
      },
    );
  }
}
