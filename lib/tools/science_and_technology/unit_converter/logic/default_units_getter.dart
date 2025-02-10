import 'package:gc_wizard/application/settings/logic/preferences.dart';
import 'package:gc_wizard/tools/science_and_technology/unit_converter/logic/length.dart';
import 'package:gc_wizard/tools/science_and_technology/unit_converter/logic/unit.dart';
import 'package:gc_wizard/tools/science_and_technology/unit_converter/logic/unit_category.dart';
import 'package:prefs/prefs.dart';

Length get defaultLengthUnit {
  var pref = Prefs.getString(PREFERENCE_DEFAULT_LENGTH_UNIT);
  if (pref.isEmpty) {
    return UNITCATEGORY_LENGTH.defaultUnit;
  }

  var prefLength = getUnitBySymbol<Length>(allLengths(), Prefs.getString(PREFERENCE_DEFAULT_LENGTH_UNIT));
  if (prefLength == null) {
    return UNITCATEGORY_LENGTH.defaultUnit;
  }

  return prefLength;
}
