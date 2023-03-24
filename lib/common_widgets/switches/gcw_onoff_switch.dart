import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/app_localizations.dart';
import 'package:gc_wizard/application/theme/theme_colors.dart';
import 'package:gc_wizard/common_widgets/gcw_text.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_switch.dart';

class GCWOnOffSwitch extends StatefulWidget {
  final void Function(bool) onChanged;
  final String? title;
  final bool? value;
  final bool notitle;
  final List<int> flexValues;
  static const _flexValues = [1, 1, 1];

  const GCWOnOffSwitch(
      {Key? key, required this.value, required this.onChanged, this.title,
        this.notitle = false, this.flexValues = _flexValues})
      : super(key: key);

  @override
  GCWOnOffSwitchState createState() => GCWOnOffSwitchState();
}

class GCWOnOffSwitchState extends State<GCWOnOffSwitch> {
  final _currentValue = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        if (!widget.notitle)
          Expanded(
              flex: widget.flexValues[0],
              child: GCWText(text: (widget.title ?? i18n(context, 'common_mode')) + ':')),
        Expanded(
            flex: widget.flexValues[0] + widget.flexValues[1] + widget.flexValues[2],
            child: Row(
              children: <Widget>[
                Expanded(flex: widget.flexValues[1], child: Container()),
                GCWSwitch(
                  value: widget.value ?? _currentValue,
                  onChanged: widget.onChanged,
                  activeThumbColor: themeColors().switchThumb2(),
                  activeTrackColor: themeColors().switchTrack2(),
                  inactiveThumbColor: themeColors().switchThumb1(),
                  inactiveTrackColor: themeColors().switchTrack1(),
                ),
                Expanded(flex: widget.flexValues[2], child: Container()),
              ],
            ))
      ],
    );
  }
}
