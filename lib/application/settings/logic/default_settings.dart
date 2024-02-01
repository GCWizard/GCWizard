import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gc_wizard/application/app_builder.dart';
import 'package:gc_wizard/application/settings/logic/preferences.dart';
import 'package:gc_wizard/application/theme/theme_colors.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinate_format_constants.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinate_format_definition.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinates.dart';
import 'package:gc_wizard/tools/coords/_common/logic/ellipsoid.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/general_codebreakers/multi_decoder/persistence/json_provider.dart';
import 'package:gc_wizard/tools/formula_solver/persistence/json_provider.dart';
import 'package:gc_wizard/tools/science_and_technology/maya_calendar/logic/maya_calendar.dart';
import 'package:gc_wizard/utils/alphabets.dart';
import 'package:prefs/prefs.dart';

enum PreferencesInitMode { STARTUP, REINIT_ALL, REINIT_SINGLE }

void restoreAllDefaultPreferencesAndRebuild(BuildContext context) {
  _initDefaultSettings(PreferencesInitMode.REINIT_ALL, context: context);
}

void restoreAllDefaultPreferences() {
  _initDefaultSettings(PreferencesInitMode.REINIT_ALL);
}

void restoreSingleDefaultPreferenceAndRebuild(String preferenceKey, BuildContext context) {
  _initDefaultSettings(PreferencesInitMode.REINIT_SINGLE, reinitSinglePreference: preferenceKey, context: context);
}

void restoreSingleDefaultPreference(String preferenceKey) {
  _initDefaultSettings(PreferencesInitMode.REINIT_SINGLE, reinitSinglePreference: preferenceKey);
}

void initializePreferences() {
  _initDefaultSettings(PreferencesInitMode.STARTUP);
}

void _initDefaultSettings(PreferencesInitMode mode, {String reinitSinglePreference = '', BuildContext? context}) {
  switch (mode) {
    case PreferencesInitMode.REINIT_ALL:
      Prefs.clear();
      break;
    case PreferencesInitMode.REINIT_SINGLE:
      if (reinitSinglePreference.isEmpty) {
        return;
      } else {
        break;
      }
    default:
      break;
  }

  var _reinitAll = mode == PreferencesInitMode.REINIT_ALL;

  if (reinitSinglePreference == PREFERENCE_ALPHABET_CUSTOM_ALPHABETS ||
      _reinitAll ||
      Prefs.get(PREFERENCE_ALPHABET_CUSTOM_ALPHABETS) == null) {
    Prefs.setStringList(PREFERENCE_ALPHABET_CUSTOM_ALPHABETS, []);
  }

  if (reinitSinglePreference == PREFERENCE_ALPHABET_DEFAULT_ALPHABET ||
      _reinitAll ||
      Prefs.get(PREFERENCE_ALPHABET_DEFAULT_ALPHABET) == null) {
    Prefs.setString(PREFERENCE_ALPHABET_DEFAULT_ALPHABET, alphabetAZ.key);
  }

  if (reinitSinglePreference == PREFERENCE_APP_COUNT_OPENED ||
      _reinitAll ||
      Prefs.get(PREFERENCE_APP_COUNT_OPENED) == null) {
    Prefs.setInt(PREFERENCE_APP_COUNT_OPENED, 0);
  } else {
    Prefs.setInt(PREFERENCE_APP_COUNT_OPENED, Prefs.getInt(PREFERENCE_APP_COUNT_OPENED) + 1);
  }

  if (reinitSinglePreference == PREFERENCE_CLIPBOARD_MAX_ITEMS ||
      _reinitAll ||
      Prefs.get(PREFERENCE_CLIPBOARD_MAX_ITEMS) == null) {
    Prefs.setInt(PREFERENCE_CLIPBOARD_MAX_ITEMS, 10);
  }

  if (reinitSinglePreference == PREFERENCE_CLIPBOARD_KEEP_ENTRIES_IN_DAYS ||
      _reinitAll ||
      Prefs.get(PREFERENCE_CLIPBOARD_KEEP_ENTRIES_IN_DAYS) == null) {
    Prefs.setInt(PREFERENCE_CLIPBOARD_KEEP_ENTRIES_IN_DAYS, 7);
  }

  var clipboardData = Prefs.getStringList(PREFERENCE_CLIPBOARD_ITEMS);
  if (reinitSinglePreference == PREFERENCE_CLIPBOARD_ITEMS || _reinitAll) {
    Prefs.setStringList(PREFERENCE_CLIPBOARD_ITEMS, []);
  } else {
    clipboardData.removeWhere((item) {
      try {
        var decoded = jsonDecode(item)['created'];
        if (decoded == null || decoded is! String) {
          return true;
        }

        var createdMS = int.tryParse(decoded);
        if (createdMS == null) {
          return true;
        }

        var created = DateTime.fromMillisecondsSinceEpoch(createdMS);
        return created
            .isBefore(DateTime.now().subtract(Duration(days: Prefs.getInt(PREFERENCE_CLIPBOARD_KEEP_ENTRIES_IN_DAYS))));
      } catch (e) {
        return true;
      }
    });
    Prefs.setStringList(PREFERENCE_CLIPBOARD_ITEMS, clipboardData);
  }

  if (reinitSinglePreference == PREFERENCE_COORD_DEFAULT_ELLIPSOID_A ||
      _reinitAll ||
      Prefs.get(PREFERENCE_COORD_DEFAULT_ELLIPSOID_A) == null) {
    Prefs.setDouble(PREFERENCE_COORD_DEFAULT_ELLIPSOID_A, 0.0);
  }

  if (reinitSinglePreference == PREFERENCE_COORD_DEFAULT_ELLIPSOID_INVF ||
      _reinitAll ||
      Prefs.get(PREFERENCE_COORD_DEFAULT_ELLIPSOID_INVF) == null) {
    Prefs.setDouble(PREFERENCE_COORD_DEFAULT_ELLIPSOID_INVF, 0.0);
  }

  if (reinitSinglePreference == PREFERENCE_COORD_DEFAULT_ELLIPSOID_NAME ||
      _reinitAll ||
      Prefs.get(PREFERENCE_COORD_DEFAULT_ELLIPSOID_NAME) == null) {
    Prefs.setString(PREFERENCE_COORD_DEFAULT_ELLIPSOID_NAME, ELLIPSOID_NAME_WGS84);
  }

  if (reinitSinglePreference == PREFERENCE_COORD_DEFAULT_ELLIPSOID_TYPE ||
      _reinitAll ||
      Prefs.get(PREFERENCE_COORD_DEFAULT_ELLIPSOID_TYPE) == null) {
    Prefs.setString(PREFERENCE_COORD_DEFAULT_ELLIPSOID_TYPE, EllipsoidType.STANDARD.toString());
  }

  if (reinitSinglePreference == PREFERENCE_COORD_DEFAULT_FORMAT ||
          _reinitAll ||
          Prefs.get(PREFERENCE_COORD_DEFAULT_FORMAT) == null ||
          Prefs.getString(PREFERENCE_COORD_DEFAULT_FORMAT) ==
              'coords_deg' //backward compatibility: old name for DMM until v1.1.0
      ) {
    Prefs.setString(
        PREFERENCE_COORD_DEFAULT_FORMAT, coordinateFormatDefinitionByKey(CoordinateFormatKey.DMM).persistenceKey);
  }

  if (reinitSinglePreference == PREFERENCE_COORD_DEFAULT_FORMAT_SUBTYPE ||
      _reinitAll ||
      Prefs.get(PREFERENCE_COORD_DEFAULT_FORMAT_SUBTYPE) == null) {
    Prefs.setString(PREFERENCE_COORD_DEFAULT_FORMAT_SUBTYPE, '');
  }

  if (reinitSinglePreference == PREFERENCE_COORD_DEFAULT_HEMISPHERE_LATITUDE ||
      _reinitAll ||
      Prefs.get(PREFERENCE_COORD_DEFAULT_HEMISPHERE_LATITUDE) == null) {
    Prefs.setString(PREFERENCE_COORD_DEFAULT_HEMISPHERE_LATITUDE, HemisphereLatitude.North.toString());
  }

  if (reinitSinglePreference == PREFERENCE_COORD_DEFAULT_HEMISPHERE_LONGITUDE ||
      _reinitAll ||
      Prefs.get(PREFERENCE_COORD_DEFAULT_HEMISPHERE_LONGITUDE) == null) {
    Prefs.setString(PREFERENCE_COORD_DEFAULT_HEMISPHERE_LONGITUDE, HemisphereLongitude.East.toString());
  }

  if (reinitSinglePreference == PREFERENCE_COORD_PRECISION_DMM ||
      _reinitAll ||
      Prefs.get(PREFERENCE_COORD_PRECISION_DMM) == null) {
    Prefs.setInt(PREFERENCE_COORD_PRECISION_DMM, 3);
  }

  if (reinitSinglePreference == PREFERENCE_COORD_VARIABLECOORDINATE_FORMULAS ||
      _reinitAll ||
      Prefs.get(PREFERENCE_COORD_VARIABLECOORDINATE_FORMULAS) == null) {
    Prefs.setStringList(PREFERENCE_COORD_VARIABLECOORDINATE_FORMULAS, []);
  }

  if (reinitSinglePreference == PREFERENCE_DEFAULT_LENGTH_UNIT ||
      _reinitAll ||
      Prefs.get(PREFERENCE_DEFAULT_LENGTH_UNIT) == null) {
    Prefs.setString(PREFERENCE_DEFAULT_LENGTH_UNIT, 'm');
  }

  var _favorites = Prefs.getStringList(PREFERENCE_FAVORITES);
  if (reinitSinglePreference == PREFERENCE_FAVORITES ||
      _reinitAll ||
      _favorites.where((element) => element.isNotEmpty).isEmpty) {
    Prefs.setStringList(PREFERENCE_FAVORITES, [
      'AlphabetValues_alphabetvalues',
      'Morse_morse',
      'RomanNumbers_romannumbers',
      'Rot13_rotation_rot13',
      'SymbolTableSelection_symboltables_selection',
      'WaypointProjection_coords_waypointprojection',
    ]);
  }

  if (reinitSinglePreference == PREFERENCE_FORMULASOLVER_FORMULAS ||
      _reinitAll ||
      Prefs.get(PREFERENCE_FORMULASOLVER_FORMULAS) == null) {
    Prefs.setStringList(PREFERENCE_FORMULASOLVER_FORMULAS, []);
  }

  if (reinitSinglePreference == PREFERENCE_FORMULASOLVER_COLOREDFORMULAS ||
      _reinitAll ||
      Prefs.get(PREFERENCE_FORMULASOLVER_COLOREDFORMULAS) == null) {
    Prefs.setBool(PREFERENCE_FORMULASOLVER_COLOREDFORMULAS, true);
  }

  if (reinitSinglePreference == PREFERENCE_IMAGECOLORCORRECTIONS_MAXPREVIEWHEIGHT ||
      _reinitAll ||
      Prefs.get(PREFERENCE_IMAGECOLORCORRECTIONS_MAXPREVIEWHEIGHT) == null) {
    Prefs.setInt(PREFERENCE_IMAGECOLORCORRECTIONS_MAXPREVIEWHEIGHT, 250);
  }

  if (reinitSinglePreference == PREFERENCE_MAPVIEW_CIRCLE_COLORFILLED ||
      _reinitAll ||
      Prefs.get(PREFERENCE_MAPVIEW_CIRCLE_COLORFILLED) == null) {
    Prefs.setBool(PREFERENCE_MAPVIEW_CIRCLE_COLORFILLED, false);
  }

  if (reinitSinglePreference == PREFERENCE_MAPVIEW_MAPVIEWS ||
      _reinitAll ||
      Prefs.get(PREFERENCE_MAPVIEW_MAPVIEWS) == null) {
    Prefs.setStringList(PREFERENCE_MAPVIEW_MAPVIEWS, []);
  }

  if (reinitSinglePreference == PREFERENCE_MAYACALENDAR_CORRELATION ||
      _reinitAll ||
      Prefs.get(PREFERENCE_MAYACALENDAR_CORRELATION) == null) {
    Prefs.setString(PREFERENCE_MAYACALENDAR_CORRELATION, THOMPSON);
  }

  if (reinitSinglePreference == PREFERENCE_MULTIDECODER_TOOLS ||
      _reinitAll ||
      Prefs.get(PREFERENCE_MULTIDECODER_TOOLS) == null) {
    Prefs.setStringList(PREFERENCE_MULTIDECODER_TOOLS, []);
  } else {
    refreshMultiDecoderTools();
  }

  if (reinitSinglePreference == PREFERENCE_SYMBOLTABLES_COUNTCOLUMNS_PORTRAIT ||
      _reinitAll ||
      Prefs.get(PREFERENCE_SYMBOLTABLES_COUNTCOLUMNS_PORTRAIT) == null) {
    Prefs.setInt(PREFERENCE_SYMBOLTABLES_COUNTCOLUMNS_PORTRAIT, 6);
  }

  if (reinitSinglePreference == PREFERENCE_SYMBOLTABLES_COUNTCOLUMNS_LANDSCAPE ||
      _reinitAll ||
      Prefs.get(PREFERENCE_SYMBOLTABLES_COUNTCOLUMNS_LANDSCAPE) == null) {
    Prefs.setInt(PREFERENCE_SYMBOLTABLES_COUNTCOLUMNS_LANDSCAPE, 10);
  }

  if (reinitSinglePreference == PREFERENCE_TABS_USE_DEFAULT_TAB ||
      _reinitAll ||
      Prefs.get(PREFERENCE_TABS_USE_DEFAULT_TAB) == null) {
    Prefs.setBool(PREFERENCE_TABS_USE_DEFAULT_TAB, false);
  }

  if (reinitSinglePreference == PREFERENCE_TABS_DEFAULT_TAB ||
      _reinitAll ||
      Prefs.get(PREFERENCE_TABS_DEFAULT_TAB) == null) {
    Prefs.setInt(PREFERENCE_TABS_DEFAULT_TAB, 2);
  }

  if (reinitSinglePreference == PREFERENCE_TABS_LAST_VIEWED_TAB ||
      _reinitAll ||
      Prefs.get(PREFERENCE_TABS_LAST_VIEWED_TAB) == null) {
    Prefs.setInt(PREFERENCE_TABS_LAST_VIEWED_TAB, 2);
  }

  if (reinitSinglePreference == PREFERENCE_THEME_COLOR || _reinitAll || Prefs.get(PREFERENCE_THEME_COLOR) == null) {
    Prefs.setString(PREFERENCE_THEME_COLOR, ThemeType.DARK.toString());
  }

  if (reinitSinglePreference == PREFERENCE_THEME_FONT_SIZE ||
      _reinitAll ||
      Prefs.get(PREFERENCE_THEME_FONT_SIZE) == null) {
    var loadedFontSize = Prefs.getDouble('font_size'); //backward compatibility: font_size == pre version 1.2.0
    if (loadedFontSize == 0.0) {
      loadedFontSize = 16.0;
    }

    Prefs.setDouble(PREFERENCE_THEME_FONT_SIZE, loadedFontSize);
  }

  if (reinitSinglePreference == PREFERENCE_TOOL_COUNT || _reinitAll || Prefs.get(PREFERENCE_TOOL_COUNT) == null) {
    Prefs.setString(PREFERENCE_TOOL_COUNT, '{}');
  }

  if (reinitSinglePreference == PREFERENCE_TOOL_COUNT_SORT ||
      _reinitAll ||
      Prefs.get(PREFERENCE_TOOL_COUNT_SORT) == null) {
    Prefs.setBool(PREFERENCE_TOOL_COUNT_SORT, false);
  }

  if (reinitSinglePreference == PREFERENCE_TOOLLIST_SHOW_DESCRIPTIONS ||
      _reinitAll ||
      Prefs.get(PREFERENCE_TOOLLIST_SHOW_DESCRIPTIONS) == null) {
    Prefs.setBool(PREFERENCE_TOOLLIST_SHOW_DESCRIPTIONS, true);
  }

  if (reinitSinglePreference == PREFERENCE_TOOLLIST_SHOW_EXAMPLES ||
      _reinitAll ||
      Prefs.get(PREFERENCE_TOOLLIST_SHOW_EXAMPLES) == null) {
    Prefs.setBool(PREFERENCE_TOOLLIST_SHOW_EXAMPLES, true);
  }

  if (reinitSinglePreference == PREFERENCE_WHERIGOANALYZER_EXPERTMODE ||
      _reinitAll ||
      Prefs.get(PREFERENCE_WHERIGOANALYZER_EXPERTMODE) == null) {
    Prefs.setBool(PREFERENCE_WHERIGOANALYZER_EXPERTMODE, false);
  }

  // AFTER /////////////////////////////////////////////////////////////

  switch (mode) {
    case PreferencesInitMode.REINIT_ALL:
    case PreferencesInitMode.REINIT_SINGLE:
      if (context != null) {
        afterRestorePreferences(context);
      }
      break;
    default:
      break;
  }
}

void afterRestorePreferences(BuildContext context) {
  setThemeColorsByName(Prefs.getString(PREFERENCE_THEME_COLOR));
  refreshFormulas();
  AppBuilder.of(context).rebuild();
}
