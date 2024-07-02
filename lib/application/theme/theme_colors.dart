import 'package:flutter/material.dart';
import 'package:gc_wizard/application/settings/logic/preferences.dart';
import 'package:prefs/prefs.dart';

part 'package:gc_wizard/application/theme/themes/theme_colors_dark.dart';
part 'package:gc_wizard/application/theme/themes/theme_colors_light.dart';

enum ThemeType { DARK, LIGHT }

ThemeColors? _themeColors;

abstract class ThemeColors {
  ThemeData base();

  Color mainFont();

  Color primaryBackground();
  Color inputBackground();
  Color secondary();
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
  Color checkBoxFillColor(Set<WidgetState> states);
  Color checkBoxCheckColor();
  Color checkBoxFocusColor();
  Color checkBoxHoverColor();
  Color checkBoxOverlayColor(Set<WidgetState> states);

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

void setThemeColorsByName(String themeColor) {
  if (themeColor == ThemeType.DARK.toString()) {
    setThemeColors(ThemeType.DARK);
  } else if (themeColor == ThemeType.LIGHT.toString()) {
    setThemeColors(ThemeType.LIGHT);
  }
}

void setThemeColors(ThemeType type) {
  switch (type) {
    case ThemeType.DARK:
      _themeColors = _ThemeColorsDark();
      break;
    case ThemeType.LIGHT:
      _themeColors = _ThemeColorsLight();
      break;
    default:
      return;
  }
}

ThemeColors themeColors() {
  if (_themeColors != null) return _themeColors!;

  var themeSetting = Prefs.getString(PREFERENCE_THEME_COLOR);
  var type = ThemeType.values.firstWhere((e) => e.toString() == themeSetting);

  setThemeColors(type);

  return _themeColors!;
}
