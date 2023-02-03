import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gc_wizard/application/settings/logic/preferences.dart';
import 'package:gc_wizard/application/theme/theme_colors.dart';
import 'package:prefs/prefs.dart';

final FONT_SIZE_MIN = 10;
final FONT_SIZE_MAX = 30;
final AUTO_FONT_SIZE_MIN = 6.0;

final DEFAULT_MARGIN = 2.0;
final DOUBLE_DEFAULT_MARGIN = 2 * DEFAULT_MARGIN;
final DEFAULT_DESCRIPTION_MARGIN = 10.0;

final DEFAULT_LISTITEM_SIZE = 42.0;

dynamic fontSizeSmall() {
  return defaultFontSize() - 4;
}

TextStyle gcwTextStyle({double fontSize = 0}) {
  return TextStyle(
      color: themeColors().mainFont(), fontSize: fontSize == 0 ? defaultFontSize() : fontSize, fontFamily: 'Roboto');
}

TextStyle gcwBetaStyle() {
  return TextStyle(
      // backgroundColor: themeColors().accent(),
      color: themeColors().dialogText(),
      fontSize: fontSizeSmall(),
      fontWeight: FontWeight.bold,
      letterSpacing: 1.7);
}

TextStyle gcwMonotypeTextStyle() {
  return TextStyle(fontSize: defaultFontSize(), fontFamily: 'Courier', fontWeight: FontWeight.bold);
}

TextStyle gcwHyperlinkTextStyle() {
  return TextStyle(
      fontSize: defaultFontSize(), color: themeColors().hyperLinkText(), decoration: TextDecoration.underline);
}

TextStyle gcwDescriptionTextStyle() {
  return gcwTextStyle().copyWith(
    color: themeColors().listSubtitle(),
    fontSize: defaultFontSize() - 2,
  );
}

TextStyle gcwDialogTextStyle() {
  return gcwTextStyle().copyWith(color: themeColors().dialogText());
}

const ROUNDED_BORDER_RADIUS = 4.0;

ThemeData buildTheme() {
  final ThemeColors colors = themeColors();
  final ThemeData base = colors.base();
  return ThemeData(
      fontFamily: 'Roboto',
      brightness: base.brightness,
      scaffoldBackgroundColor: colors.primaryBackground(),
      primarySwatch: _generateMaterialColor(colors.primaryBackground()),
      primaryColor: colors.primaryBackground(),
      accentColor: colors.accent(),
      textTheme: base.textTheme,
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: colors.accent(),
        selectionColor: colors.accent().withOpacity(0.5),
        selectionHandleColor: colors.accent(),
      ),
      buttonTheme: base.buttonTheme.copyWith(
          buttonColor: colors.accent(),
          textTheme: ButtonTextTheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(ROUNDED_BORDER_RADIUS)),
          )),
      canvasColor: colors.inputBackground(), //background of DropDown
      inputDecorationTheme: base.inputDecorationTheme.copyWith(
        hintStyle: TextStyle(color: colors.textFieldHintText()),
        fillColor: colors.inputBackground(),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: colors.focused(), width: 2.0),
            borderRadius: BorderRadius.all(Radius.circular(ROUNDED_BORDER_RADIUS))),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: colors.accent(), width: 1.0),
            borderRadius: BorderRadius.all(Radius.circular(ROUNDED_BORDER_RADIUS))),
        contentPadding: EdgeInsets.all(10.0),
      ),
      unselectedWidgetColor: colors.accent(),
      cardColor: colors.messageBackground());
}

// https://medium.com/@morgenroth/using-flutters-primary-swatch-with-a-custom-materialcolor-c5e0f18b95b0

MaterialColor _generateMaterialColor(Color color) {
  return MaterialColor(color.value, {
    50: _tintColor(color, 0.9),
    100: _tintColor(color, 0.8),
    200: _tintColor(color, 0.6),
    300: _tintColor(color, 0.4),
    400: _tintColor(color, 0.2),
    500: color,
    600: _shadeColor(color, 0.1),
    700: _shadeColor(color, 0.2),
    800: _shadeColor(color, 0.3),
    900: _shadeColor(color, 0.4),
  });
}

int _tintValue(int value, double factor) => max(0, min((value + ((255 - value) * factor)).round(), 255));

Color _tintColor(Color color, double factor) =>
    Color.fromRGBO(_tintValue(color.red, factor), _tintValue(color.green, factor), _tintValue(color.blue, factor), 1);

int _shadeValue(int value, double factor) => max(0, min(value - (value * factor).round(), 255));

Color _shadeColor(Color color, double factor) => Color.fromRGBO(
    _shadeValue(color.red, factor), _shadeValue(color.green, factor), _shadeValue(color.blue, factor), 1);

defaultFontSize() {
  var fontSize = Prefs.get(PREFERENCE_THEME_FONT_SIZE);

  if (fontSize < FONT_SIZE_MIN) {
    Prefs.setDouble(PREFERENCE_THEME_FONT_SIZE, FONT_SIZE_MIN.toDouble());
    return FONT_SIZE_MIN;
  }

  if (fontSize > FONT_SIZE_MAX) {
    Prefs.setDouble(PREFERENCE_THEME_FONT_SIZE, FONT_SIZE_MAX.toDouble());
    return FONT_SIZE_MAX;
  }

  return fontSize;
}

double maxScreenHeight(BuildContext context) {
  return MediaQuery.of(context).size.height - 100;
}