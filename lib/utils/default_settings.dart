import 'dart:convert';

import 'package:gc_wizard/logic/tools/coords/data/coordinates.dart';
import 'package:gc_wizard/logic/tools/coords/data/ellipsoid.dart';
import 'package:gc_wizard/logic/tools/science_and_technology/maya_calendar.dart';
import 'package:gc_wizard/persistence/multi_decoder/json_provider.dart';
import 'package:gc_wizard/persistence/multi_decoder/model.dart';
import 'package:gc_wizard/theme/theme_colors.dart';
import 'package:gc_wizard/utils/alphabets.dart';
import 'package:gc_wizard/widgets/tools/crypto_and_encodings/general_codebreakers/multi_decoder/tools/md_tool_base.dart';
import 'package:gc_wizard/widgets/tools/crypto_and_encodings/general_codebreakers/multi_decoder/tools/md_tool_bcd.dart';
import 'package:gc_wizard/widgets/tools/crypto_and_encodings/general_codebreakers/multi_decoder/tools/md_tool_ccitt1.dart';
import 'package:gc_wizard/widgets/tools/crypto_and_encodings/general_codebreakers/multi_decoder/tools/md_tool_ccitt2.dart';
import 'package:prefs/prefs.dart';


void initDefaultSettings() {
  if (Prefs.get('alphabetvalues_custom_alphabets') == null) {
    Prefs.setStringList('alphabetvalues_custom_alphabets', []);
  }

  if (Prefs.get('alphabetvalues_default_alphabet') == null) {
    Prefs.setString('alphabetvalues_default_alphabet', alphabetAZ.key);
  }

  if (Prefs.get('app_count_opened') == null) {
    Prefs.setInt('app_count_opened', 1);
  } else {
    Prefs.setInt('app_count_opened', Prefs.getInt('app_count_opened') + 1);
  }

  if (Prefs.get('clipboard_max_items') == null) {
    Prefs.setInt('clipboard_max_items', 10);
  }

  if (Prefs.get('clipboard_keep_entries_in_days') == null) {
    Prefs.setInt('clipboard_keep_entries_in_days', 7);
  }

  var clipboardData = Prefs.getStringList('clipboard_items');
  if (clipboardData == null) {
    Prefs.setStringList('clipboard_items', []);
  } else {
    clipboardData.removeWhere((item) {
      try {
        var created = DateTime.fromMillisecondsSinceEpoch(int.tryParse(jsonDecode(item)['created']));
        return created.isBefore(DateTime.now().subtract(Duration(days: Prefs.get('clipboard_keep_entries_in_days'))));
      } catch (e) {
        return true;
      }
    });
    Prefs.setStringList('clipboard_items', clipboardData);
  }

  if (Prefs.get('coord_default_ellipsoid_type') == null) {
    Prefs.setString('coord_default_ellipsoid_type', EllipsoidType.STANDARD.toString());
    Prefs.setString('coord_default_ellipsoid_name', ELLIPSOID_NAME_WGS84);
  }

  if (Prefs.get('coord_default_format') == null ||
          Prefs.get('coord_default_format') == 'coords_deg' //old name for DMM until v1.1.0
      ) {
    Prefs.setString('coord_default_format', keyCoordsDMM);
  }

  if (Prefs.get('coord_default_hemisphere_latitude') == null) {
    Prefs.setString('coord_default_hemisphere_latitude', HemisphereLatitude.North.toString());
  }

  if (Prefs.get('coord_default_hemisphere_longitude') == null) {
    Prefs.setString('coord_default_hemisphere_longitude', HemisphereLongitude.East.toString());
  }

  if (Prefs.get('coord_variablecoordinate_formulas') == null) {
    Prefs.setStringList('coord_variablecoordinate_formulas', []);
  }

  if (Prefs.get('default_length_unit') == null) {
    Prefs.setString('default_length_unit', 'm');
  }

  var _favorites = Prefs.getStringList('favorites');
  if (_favorites == null || _favorites.where((element) => element != null && element.isNotEmpty).isEmpty) {
    Prefs.setStringList('favorites', [
      'AlphabetValues_alphabetvalues',
      'Morse_morse',
      'RomanNumbers_romannumbers',
      'Rot13_rotation_rot13',
      'SymbolTableSelection_symboltables_selection',
      'WaypointProjection_coords_waypointprojection',
    ]);
  }

  if (Prefs.get('formulasolver_formulas') == null) {
    Prefs.setStringList('formulasolver_formulas', []);
  }

  if (Prefs.get('formulasolver_coloredformulas') == null) {
    Prefs.setBool('formulasolver_coloredformulas', true);
  }

  if (Prefs.get('imagecolorcorrections_maxpreviewheight') == null) {
    Prefs.setInt('imagecolorcorrections_maxpreviewheight', 250);
  }

  if (Prefs.get('mapview_circle_colorfilled') == null) {
    Prefs.setBool('mapview_circle_colorfilled', false);
  }

  if (Prefs.get('mapview_mapviews') == null) {
    Prefs.setStringList('mapview_mapviews', []);
  }

  if (Prefs.get('mayacalendar_correlation') == null) {
    Prefs.setString('mayacalendar_correlation', THOMPSON);
  }

  if (Prefs.get('multidecoder_tools') == null) {
    Prefs.setStringList('multidecoder_tools', []);
  } else {
    // ensure backward compatibility; breaking change in 2.0.1 due to a bug fix
    refreshMultiDecoderTools();
    for (var tool in multiDecoderTools) {
      if ([MDT_INTERNALNAMES_BCD, MDT_INTERNALNAMES_BASE].contains(tool.internalToolName)) {
        var options = <MultiDecoderToolOption>[];
        tool.options.forEach((option) {
          options.add(MultiDecoderToolOption(option.name, option.value.split('_title')[0]));
        });
        tool.options = options;
        updateMultiDecoderTool(tool);
      } else if ([MDT_INTERNALNAMES_CCITT1, MDT_INTERNALNAMES_BASE].contains(tool.internalToolName)) {
        var options = <MultiDecoderToolOption>[];
        tool.options.where((element) => element.name == 'ccitt1_numeralbase').forEach((option) {
          options.add(MultiDecoderToolOption(MDT_CCITT1_OPTION_MODE, option.value));
        });
        tool.options = options;
        updateMultiDecoderTool(tool);
      } else if ([MDT_INTERNALNAMES_CCITT2, MDT_INTERNALNAMES_BASE].contains(tool.internalToolName)) {
        var options = <MultiDecoderToolOption>[];
        tool.options.where((element) => element.name == 'ccitt2_numeralbase').forEach((option) {
          options.add(MultiDecoderToolOption(MDT_CCITT2_OPTION_MODE, option.value));
        });
        tool.options = options;
        updateMultiDecoderTool(tool);
      }
    }
  }

  if (Prefs.get('symboltables_countcolumns_portrait') == null) {
    Prefs.setInt('symboltables_countcolumns_portrait', 6);
  }

  if (Prefs.get('symboltables_countcolumns_landscape') == null) {
    Prefs.setInt('symboltables_countcolumns_landscape', 10);
  }

  if (Prefs.get('tabs_use_default_tab') == null) {
    Prefs.setBool('tabs_use_default_tab', false);
  }

  if (Prefs.get('tabs_default_tab') == null) {
    Prefs.setInt('tabs_default_tab', 2);
  }

  if (Prefs.get('tabs_last_viewed_tab') == null) {
    Prefs.setInt('tabs_last_viewed_tab', 2);
  }

  if (Prefs.get('theme_color') == null) {
    Prefs.setString('theme_color', ThemeType.DARK.toString());
  }

  if (Prefs.get('theme_font_size') == null) {
    Prefs.setDouble('theme_font_size', Prefs.get('font_size') ?? 16.0); //font_size == pre version 1.2.0
  }

  if (Prefs.get('toollist_show_descriptions') == null) {
    Prefs.setBool('toollist_show_descriptions', true);
  }

  if (Prefs.get('toollist_show_examples') == null) {
    Prefs.setBool('toollist_show_examples', true);
  }
}
