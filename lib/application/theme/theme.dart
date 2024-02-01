import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gc_wizard/application/_common/gcw_package_info.dart';
import 'package:gc_wizard/application/settings/logic/preferences.dart';
import 'package:gc_wizard/application/theme/theme_colors.dart';
import 'package:prefs/prefs.dart';

const FONT_SIZE_MIN = 10;
const FONT_SIZE_MAX = 30;
const AUTO_FONT_SIZE_MIN = 6.0;

const DEFAULT_MARGIN = 2.0;
const DOUBLE_DEFAULT_MARGIN = 2 * DEFAULT_MARGIN;
const DEFAULT_DESCRIPTION_MARGIN = 10.0;

const DEFAULT_LISTITEM_SIZE = 42.0;

double fontSizeSmall() {
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
  return TextStyle(fontSize: defaultFontSize(), fontFamily: 'Courier');
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

TextStyle gcwBoldTextStyle() {
  return gcwTextStyle().copyWith(fontWeight: FontWeight.bold);
}

TextStyle gcwDialogTextStyle() {
  return gcwTextStyle().copyWith(color: themeColors().dialogText());
}

const ROUNDED_BORDER_RADIUS = 4.0;

ThemeData buildTheme() {
  final ThemeColors colors = themeColors();
  final ThemeData base = colors.base();
  return ThemeData(
      useMaterial3: false,
      fontFamily: 'Roboto',
      scaffoldBackgroundColor: colors.primaryBackground(),
      textTheme: base.textTheme,
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: colors.secondary(),
        selectionColor: colors.secondary().withOpacity(0.5),
        selectionHandleColor: colors.secondary(),
      ),
      buttonTheme: base.buttonTheme.copyWith(
          buttonColor: colors.secondary(),
          textTheme: ButtonTextTheme.primary,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(ROUNDED_BORDER_RADIUS)),
          )),
      canvasColor: colors.inputBackground(), //background of DropDown
      inputDecorationTheme: base.inputDecorationTheme.copyWith(
        hintStyle: TextStyle(color: colors.textFieldHintText()),
        fillColor: colors.inputBackground(),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: colors.focused(), width: 2.0),
            borderRadius: const BorderRadius.all(Radius.circular(ROUNDED_BORDER_RADIUS))),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: colors.secondary(), width: 1.0),
            borderRadius: const BorderRadius.all(Radius.circular(ROUNDED_BORDER_RADIUS))),
        contentPadding: const EdgeInsets.all(10.0),
      ),
      unselectedWidgetColor: colors.secondary(),
      indicatorColor: themeColors().secondary(),
      tabBarTheme: TabBarTheme(indicatorColor: themeColors().secondary(),
          labelColor: colors.mainFont(),
          unselectedLabelColor: colors.mainFont().withOpacity(0.7),
          dividerHeight: 0,
          indicatorSize: TabBarIndicatorSize.tab),
      appBarTheme: AppBarTheme(backgroundColor: colors.primaryBackground(), foregroundColor: colors.mainFont()),
      cardColor: colors.messageBackground(),
      colorScheme: ColorScheme.fromSwatch(primarySwatch: _generateMaterialColor(colors.primaryBackground()))
          .copyWith(secondary: colors.secondary(), brightness: base.brightness,
                    surfaceVariant: colors.gridBackground(), onSurface: colors.mainFont()),
      dividerTheme: const DividerThemeData().copyWith(thickness: 0, color: colors.gridBackground()),
      drawerTheme: const DrawerThemeData().copyWith(backgroundColor: base.scaffoldBackgroundColor)
  );
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

double defaultFontSize() {
  var fontSize = Prefs.getDouble(PREFERENCE_THEME_FONT_SIZE);

  if (fontSize < FONT_SIZE_MIN) {
    Prefs.setDouble(PREFERENCE_THEME_FONT_SIZE, FONT_SIZE_MIN.toDouble());
    return FONT_SIZE_MIN.toDouble();
  }

  if (fontSize > FONT_SIZE_MAX) {
    Prefs.setDouble(PREFERENCE_THEME_FONT_SIZE, FONT_SIZE_MAX.toDouble());
    return FONT_SIZE_MAX.toDouble();
  }

  return fontSize;
}

double maxScreenHeight(BuildContext context) {
  return MediaQuery.of(context).size.height - 100;
}

double maxScreenWidth(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

String applogoFilename() {
  const resolution = 128;
  var logoId = '';

  var pkgInfo = GCWPackageInfo.getInstance();
  switch (pkgInfo.packageName.split('.')[2]) {
    case 'gc_wizard_alpha': logoId += '_nightly'; break;
    case 'gc_wizard_gold': logoId += '_gold'; break;
    default: break;
  }

  return 'assets/logo/circle_border_$resolution$logoId.png';
}
