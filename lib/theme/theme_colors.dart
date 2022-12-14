import 'package:flutter/material.dart';
import 'package:gc_wizard/theme/theme_colors_dark.dart';
import 'package:gc_wizard/theme/theme_colors_light.dart';
import 'package:gc_wizard/utils/settings/preferences.dart';
import 'package:prefs/prefs.dart';

enum ThemeType { DARK, LIGHT }

ThemeColors _themeColors;

abstract class ThemeColors {
  ThemeData base();

  Color mainFont();

  Color primaryBackground();
  Color inputBackground();
  Color accent();
  Color focused();
  Color inActive();

  Color textFieldHintText();
  Color textFieldFill();
  Color textFieldFillText();

  Color hyperLinkText();

  Color switchThumb1();
  Color switchTrack1();
  Color switchThumb2();
  Color switchTrack2();

  Color checkBoxActiveColor();
  Color checkBoxFillColor(Set<MaterialState> states);
  Color checkBoxCheckColor();
  Color checkBoxFocusColor();
  Color checkBoxHoverColor();
  Color checkBoxOverlayColor(Set<MaterialState> states);

  Color outputListOddRows();

  Color listSubtitle();

  Color iconImageBackground();

  Color dialog();
  Color dialogText();

  Color messageBackground();

  Color gridBackground();

  Color formulaNumber();
  Color formulaMath();
  Color formulaVariable();
  Color formulaError();
}

setThemeColorsByName(String themeColor) {
  if (themeColor == ThemeType.DARK.toString())
    setThemeColors(ThemeType.DARK);
  else if (themeColor == ThemeType.LIGHT.toString()) {
    setThemeColors(ThemeType.LIGHT);
  }
}

setThemeColors(ThemeType type) {
  switch (type) {
    case ThemeType.DARK:
      _themeColors = ThemeColorsDark();
      break;
    case ThemeType.LIGHT:
      _themeColors = ThemeColorsLight();
      break;
    default:
      return null;
  }
}

ThemeColors themeColors() {
  if (_themeColors != null) return _themeColors;

  var themeSetting = Prefs.getString(PREFERENCE_THEME_COLOR);
  var type = ThemeType.values.firstWhere((e) => e.toString() == themeSetting);

  setThemeColors(type);

  return _themeColors;
}
