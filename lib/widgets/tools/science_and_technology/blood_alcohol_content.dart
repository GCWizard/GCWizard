import 'package:flutter/material.dart';
import 'package:gc_wizard/i18n/app_localizations.dart';
import 'package:gc_wizard/logic/common/units/length.dart';
import 'package:gc_wizard/logic/common/units/mass.dart';
import 'package:gc_wizard/logic/common/units/unit_category.dart';
import 'package:gc_wizard/logic/common/units/volume.dart';
import 'package:gc_wizard/logic/tools/science_and_technology/alcohol.dart';
import 'package:gc_wizard/widgets/common/base/gcw_dropdownbutton.dart';
import 'package:gc_wizard/widgets/common/base/gcw_text.dart';
import 'package:gc_wizard/widgets/common/gcw_columned_multiline_output.dart';
import 'package:gc_wizard/widgets/common/gcw_default_output.dart';
import 'package:gc_wizard/widgets/common/gcw_double_spinner.dart';
import 'package:gc_wizard/widgets/common/gcw_integer_spinner.dart';
import 'package:gc_wizard/widgets/common/gcw_text_divider.dart';
import 'package:gc_wizard/widgets/common/units/gcw_unit_input.dart';
import 'package:intl/intl.dart';

class BloodAlcoholContent extends StatefulWidget {
  @override
  BloodAlcoholContentState createState() => BloodAlcoholContentState();
}

class BloodAlcoholContentState extends State<BloodAlcoholContent> {
  var _GENDERS = {
    BloodAlcoholGender.MEN: 'bloodalcoholcontent_person_male',
    BloodAlcoholGender.WOMEN: 'bloodalcoholcontent_person_female',
    BloodAlcoholGender.CHILDREN: 'bloodalcoholcontent_person_child',
  };

  var _currentVolume = 0.0;
  var _currentPercent = 0.0;

  var _currentGender = BloodAlcoholGender.MEN;

  var _currentMass = 0.0;
  var _currentHeight = 0.0;
  var _currentAge = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GCWTextDivider(text: i18n(context, 'bloodalcoholcontent_liquid')),
        GCWUnitInput(
          value: _currentVolume,
          title: i18n(context, 'bloodalcoholcontent_volume'),
          min: 0.0,
          unitCategory: UNITCATEGORY_VOLUME,
          initialUnit: VOLUME_MILLILITER,
          onChanged: (value) {
            setState(() {
              _currentVolume = value;
            });
          },
        ),
        Row(
          children: [
            Expanded(
                child: GCWText(
                  text: i18n(context, 'bloodalcoholcontent_abv'),
                ),
                flex: 3),
            Expanded(
                child: GCWDoubleSpinner(
                  value: _currentPercent,
                  onChanged: (value) {
                    setState(() {
                      _currentPercent = value;
                    });
                  },
                ),
                flex: 13)
          ],
        ),
        GCWTextDivider(text: i18n(context, 'bloodalcoholcontent_person')),
        GCWDropDownButton(
          title: i18n(context, 'bloodalcoholcontent_person_gender'),
          value: _currentGender,
          items: BloodAlcoholGender.values.map((mode) {
            return GCWDropDownMenuItem(value: mode, child: i18n(context, _GENDERS[mode]));
          }).toList(),
          onChanged: (value) {
            setState(() {
              _currentGender = value;
            });
          },
        ),
        GCWUnitInput(
          title: i18n(context, 'bloodalcoholcontent_person_weight'),
          unitList: allMasses(),
          initialUnit: MASS_KILOGRAM,
          min: 0.0,
          value: _currentMass,
          onChanged: (value) {
            setState(() {
              _currentMass = value;
            });
          },
        ),
        GCWUnitInput(
          title: i18n(context, 'bloodalcoholcontent_person_height'),
          unitList: allLengths(),
          initialUnit: LENGTH_CM,
          min: 0.0,
          value: _currentHeight,
          onChanged: (value) {
            setState(() {
              _currentHeight = value;
            });
          },
        ),
        GCWIntegerSpinner(
          title: i18n(context, 'bloodalcoholcontent_person_age'),
          value: _currentAge,
          min: 0,
          max: 999,
          // overflow: SpinnerOverflowType.ALLOW_OVERFLOW,
          onChanged: (value) {
            setState(() {
              _currentAge = value;
            });
          },
        ),
        GCWDefaultOutput(
          child: _buildOutput(),
        )
      ],
    );
  }

  Widget _buildOutput() {
    var alcMass = alcoholMassInG(VOLUME_MILLILITER.fromCubicMeter(_currentVolume), _currentPercent);
    var nf = NumberFormat('0.000');

    List<List<dynamic>> data = [];

    if ([BloodAlcoholGender.MEN, BloodAlcoholGender.WOMEN, BloodAlcoholGender.CHILDREN].contains(_currentGender)) {
      var widmark = bloodAlcoholInPermilleWidmark(_currentGender, alcMass, MASS_KILOGRAM.fromGram(_currentMass));
      data.add(['Widmark', nf.format(widmark['max']) + ' - ' + nf.format(widmark['min']) + ' ‰']);
    }

    if ([BloodAlcoholGender.MEN, BloodAlcoholGender.WOMEN].contains(_currentGender)) {
      var result = bloodAlcoholInPermilleWidmarkSeidl(
          _currentGender, alcMass, MASS_KILOGRAM.fromGram(_currentMass), LENGTH_CM.fromMeter(_currentHeight));
      data.add(['Widmark/Seidl', result == 0.0 ? '-' : (nf.format(result) + ' ‰')]);
    }

    if ([BloodAlcoholGender.MEN].contains(_currentGender)) {
      var result = bloodAlcoholInPermilleWidmarkUlrich(
          _currentGender, alcMass, MASS_KILOGRAM.fromGram(_currentMass), LENGTH_CM.fromMeter(_currentHeight));
      data.add(['Widmark/Ulrich', result == 0.0 ? '-' : (nf.format(result) + ' ‰')]);
    }

    if ([BloodAlcoholGender.MEN, BloodAlcoholGender.WOMEN].contains(_currentGender)) {
      var result = bloodAlcoholInPermilleWidmarkWatson(_currentGender, alcMass, MASS_KILOGRAM.fromGram(_currentMass),
          LENGTH_CM.fromMeter(_currentHeight), _currentAge);
      data.add(['Widmark/Watson', result == 0.0 ? '-' : (nf.format(result) + ' ‰')]);
    }

    if ([BloodAlcoholGender.WOMEN].contains(_currentGender)) {
      var result = bloodAlcoholInPermilleWidmarkWatsonEicker(_currentGender, alcMass,
          MASS_KILOGRAM.fromGram(_currentMass), LENGTH_CM.fromMeter(_currentHeight), _currentAge);
      data.add(['Widmark/Watson/Eicker', result == 0.0 ? '-' : (nf.format(result) + ' ‰')]);
    }

    return GCWColumnedMultilineOutput(data: data);
  }
}
