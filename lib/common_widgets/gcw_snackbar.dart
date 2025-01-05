import 'package:flutter/material.dart';
import 'package:gc_wizard/application/theme/theme.dart';
import 'package:gc_wizard/application/theme/theme_colors.dart';

void showSnackBar(String text, BuildContext context, {int duration = 3}) {
  const _MAX_LENGTH = 300;

  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(
      text.length > _MAX_LENGTH ? text.substring(0, _MAX_LENGTH) + '...' : text,
      style: gcwTextStyle().copyWith(color: themeColors().primaryBackground(), fontSize: defaultFontSize()),
    ),
    duration: Duration(seconds: duration),
    backgroundColor: themeColors().mainFont().withAlpha(235),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(2 * ROUNDED_BORDER_RADIUS),
    ),
    width: maxScreenWidth(context) * 0.70,
    behavior: SnackBarBehavior.floating,
  ));
}
