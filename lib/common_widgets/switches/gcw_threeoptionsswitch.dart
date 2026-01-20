import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/application/theme/theme.dart';
import 'package:gc_wizard/application/theme/theme_colors.dart';
import 'package:gc_wizard/common_widgets/gcw_text.dart';

class GCWThreeOptionsSwitch extends StatefulWidget {
  final void Function(int) onChanged;
  final String? title;
  final List<String> labels;
  final int? position;
  final bool alternativeColor;
  final bool notitle;

  const GCWThreeOptionsSwitch(
      {super.key,
        this.title,
        required this.labels,
        required this.position,
        required this.onChanged,
        this.alternativeColor = false,
        this.notitle = false});

  @override
  _GCWThreeOptionsSwitchState createState() => _GCWThreeOptionsSwitchState();
}

class _GCWThreeOptionsSwitchState extends State<GCWThreeOptionsSwitch> {
  var _currentValue = 0;
  List<bool> _currentStatus = [true, false, false];

  ButtonStyle _inActiveStyle() {
    return ElevatedButton.styleFrom(
      foregroundColor: Colors.white,
      backgroundColor: themeColors().inputBackground(),
      side: BorderSide(width: 2, color: themeColors().inputBackground()),
      textStyle: TextStyle(
        fontSize: defaultFontSize(),
      ),
    );
  }

  ButtonStyle _activeStyle() {
    return ElevatedButton.styleFrom(
      foregroundColor: Colors.black,
      backgroundColor: themeColors().checkBoxHoverColor(),
      side: BorderSide(width: 2, color: themeColors().checkBoxHoverColor()),
      shadowColor: Colors.orange,
      elevation: DEFAULT_MARGIN,
      textStyle: TextStyle(
        fontSize: defaultFontSize(),
      ),
    );
  }

  Widget _buildButtonSet() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.only(right: DEFAULT_MARGIN),
            child: ElevatedButton(
              onPressed: () {
                _currentStatus = [true, false, false];
                _currentValue = 0;
                widget.onChanged(_currentValue);
              },
              style: _currentStatus[0] ? _activeStyle() : _inActiveStyle(),
              child: Text(
                widget.labels[0],
                textAlign: TextAlign.center,
                style:
                gcwTextStyle().copyWith(color: themeColors().dialogText()),
              ),
            ),
          ),
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.only(left: DEFAULT_MARGIN, right: DEFAULT_MARGIN),
            child: ElevatedButton(
              onPressed: () {
                _currentStatus = [false, true, false];
                _currentValue = 1;
                widget.onChanged(_currentValue);
              },
              style: _currentStatus[1] ? _activeStyle() : _inActiveStyle(),
              child: Text(
                widget.labels[1],
                textAlign: TextAlign.center,
                style:
                gcwTextStyle().copyWith(color: themeColors().dialogText()),
              ),
            ),
          ),
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.only(left: DEFAULT_MARGIN),
            child: ElevatedButton(
              onPressed: () {
                _currentStatus = [false, false, true];
                _currentValue = 2;
                widget.onChanged(_currentValue);
              },
              style: _currentStatus[2] ? _activeStyle() : _inActiveStyle(),
              child: Text(
                widget.labels[2],
                textAlign: TextAlign.center,
                style:
                gcwTextStyle().copyWith(color: themeColors().dialogText()),
              ),
            ),
          ),
        ),

      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeColors colors = themeColors();

    _currentValue = widget.position ?? 0;

    var textStyle = gcwTextStyle();
    if (widget.alternativeColor) {
      textStyle = textStyle.copyWith(color: colors.dialogText());
    }

    return Column(children: <Widget>[
      widget.notitle
          ? Container()
          : GCWText(
        text: (widget.title ?? i18n(context, 'common_mode')) + ':',
        style: textStyle,
      ),
      Container(
          padding: const EdgeInsets.symmetric(vertical: DOUBLE_DEFAULT_MARGIN),
          child: Row(children: <Widget>[
            Expanded(
              flex: 3,
              child: _buildButtonSet(),
            )
          ]))
    ]);
  }
}