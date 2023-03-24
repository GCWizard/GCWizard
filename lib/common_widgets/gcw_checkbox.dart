import 'package:flutter/material.dart';
import 'package:gc_wizard/application/theme/theme_colors.dart';
import 'package:gc_wizard/common_widgets/gcw_text.dart';

class GCWCheckBox extends StatefulWidget {
  final void Function(bool?) onChanged;
  final String title;
  final bool value;
  final bool notitle;
  final bool tristate;
  final TextStyle? textStyle;
  final Color? activeColor;
  final MaterialStateProperty<Color>? fillColor;
  final Color? checkColor;
  final Color? focusColor;
  final Color? hoverColor;
  final MaterialStateProperty<Color>? overlayColor;

  const GCWCheckBox(
      {Key? key,
      required this.value,
      required this.onChanged,
      required this.title,
      this.notitle = false,
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
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        if (!widget.notitle) Expanded(flex: 3, child: GCWText(text: (widget.title), style: widget.textStyle)),
        Expanded(
            flex: 3,
            child: Row(
              children: <Widget>[
                Expanded(flex: 1, child: Container()),
                Checkbox(
                  value: widget.value,
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
            )),
      ],
    );
  }
}
