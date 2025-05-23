import 'package:flutter/material.dart';
import 'package:gc_wizard/application/theme/theme.dart';
import 'package:gc_wizard/application/theme/theme_colors.dart';

class GCWButton extends StatefulWidget {
  final String text;
  final void Function() onPressed;
  final TextStyle? textStyle;
  final EdgeInsetsGeometry? margin;
  final bool enabled;

  const GCWButton({super.key, required this.text, required this.onPressed,
  this.textStyle, this.margin, this.enabled = true});

  @override
  _GCWButtonState createState() => _GCWButtonState();
}

class _GCWButtonState extends State<GCWButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.margin ?? const EdgeInsets.only(top: 10.0, bottom: 10.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: widget.enabled ? themeColors().secondary() : themeColors().inactive()),
        onPressed: widget.enabled ? widget.onPressed : () => {},
        child: Text(
          widget.text,
          textAlign: TextAlign.center,
          style: widget.textStyle ?? gcwTextStyle().copyWith(color: themeColors().dialogText()),
        ),
      ),
    );
  }
}
