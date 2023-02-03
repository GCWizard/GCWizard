import 'package:flutter/material.dart';
import 'package:gc_wizard/application/theme/theme_colors.dart';
import 'package:gc_wizard/common_widgets/gcw_text.dart';

class GCWCheckBox extends StatefulWidget {
  final Function onChanged;
  final String title;
  final value;
  final bool notitle;
  final bool tristate;
  final TextStyle textStyle;
  final Color activeColor;
  final MaterialStateProperty<Color> fillColor;
  final Color checkColor;
  final Color focusColor;
  final Color hoverColor;
  final MaterialStateProperty<Color> overlayColor;

  const GCWCheckBox(
      {Key key,
      this.value,
      this.onChanged,
      this.title,
      this.notitle: false,
      this.tristate = false,
      this.textStyle,
      this.activeColor,
      this.fillColor,
      this.checkColor,
      this.focusColor,
      this.hoverColor,
      this.overlayColor})
      : super(key: key);

  @override
  GCWCheckBoxState createState() => GCWCheckBoxState();
}

class GCWCheckBoxState extends State<GCWCheckBox> {
  var _currentValue = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        if (!widget.notitle) Expanded(child: GCWText(text: (widget.title), style: widget.textStyle), flex: 3),
        Expanded(
            child: Container(
              child: Row(
                children: <Widget>[
                  Expanded(child: Container(), flex: 1),
                  Checkbox(
                    value: widget.value ?? _currentValue,
                    onChanged: widget.onChanged,
                    activeColor: widget.activeColor ?? themeColors().checkBoxActiveColor(),
                    fillColor: widget.fillColor ?? MaterialStateColor.resolveWith(themeColors().checkBoxFillColor),
                    checkColor: widget.checkColor ?? themeColors().checkBoxCheckColor(),
                    focusColor: widget.focusColor ?? themeColors().checkBoxFocusColor(),
                    hoverColor: widget.hoverColor ?? themeColors().checkBoxHoverColor(),
                    overlayColor:
                        widget.overlayColor ?? MaterialStateColor.resolveWith(themeColors().checkBoxOverlayColor),
                  )
                ],
              ),
            ),
            flex: 3),
      ],
    );
  }
}
