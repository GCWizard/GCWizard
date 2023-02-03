import 'package:flutter/material.dart';
import 'package:gc_wizard/application/theme/theme.dart';
import 'package:gc_wizard/application/theme/theme_colors.dart';
import 'package:gc_wizard/utils/math_utils.dart';

enum IconButtonSize { NORMAL, SMALL, TINY }

class GCWIconButton extends StatelessWidget {
  final Function onPressed;
  final IconData icon;
  final Widget customIcon;
  IconButtonSize size;
  final double iconSize;
  final Color iconColor;
  final Color backgroundColor;
  final double rotateDegrees;

  GCWIconButton(
      {Key key,
      this.onPressed,
      this.icon,
      this.customIcon,
      this.size,
      this.iconSize,
      this.iconColor,
      this.backgroundColor,
      this.rotateDegrees})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var containerWidth;
    var buttonHeight;
    var iconSize;

    // moved to here instead of default value in constructur because
    // some tools explicitly hand over a NULL value
    if (this.size == null) this.size = IconButtonSize.NORMAL;

    switch (this.size) {
      case IconButtonSize.NORMAL:
        containerWidth = 40.0;
        buttonHeight = 38.0;
        iconSize = this.iconSize ?? null;
        break;
      case IconButtonSize.SMALL:
        containerWidth = 32.0;
        buttonHeight = 28.0;
        iconSize = this.iconSize ?? 20.0;
        break;
      case IconButtonSize.TINY:
        containerWidth = 21.0;
        buttonHeight = 18.0;
        iconSize = this.iconSize ?? 17.0;
        break;
    }

    return Container(
      width: containerWidth,
      height: buttonHeight,
      child: TextButton(
        style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
                side: BorderSide(color: themeColors().accent(), width: 1, style: BorderStyle.solid),
                borderRadius: BorderRadius.circular(ROUNDED_BORDER_RADIUS)),
            backgroundColor: backgroundColor),
        child: Transform.rotate(
          child: this.customIcon ?? Icon(this.icon, size: iconSize, color: this.iconColor ?? themeColors().mainFont()),
          angle: degreesToRadian(this.rotateDegrees ?? 0.0),
        ),
        onPressed: this.onPressed,
      ),
      padding: EdgeInsets.only(left: 2, right: 2),
      margin: EdgeInsets.only(top: 4, bottom: 4),
    );
  }
}
