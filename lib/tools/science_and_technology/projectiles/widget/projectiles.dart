import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/app_localizations.dart';
import 'package:gc_wizard/common_widgets/dividers/gcw_text_divider.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_dropdown.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/units/gcw_unit_input.dart';
import 'package:gc_wizard/common_widgets/units/gcw_units.dart';
import 'package:gc_wizard/tools/science_and_technology/projectiles/logic/projectiles.dart';
import 'package:gc_wizard/tools/science_and_technology/unit_converter/logic/mass.dart';
import 'package:gc_wizard/tools/science_and_technology/unit_converter/logic/unit.dart';
import 'package:gc_wizard/tools/science_and_technology/unit_converter/logic/unit_category.dart';
import 'package:gc_wizard/tools/science_and_technology/unit_converter/logic/unit_prefix.dart';
import 'package:intl/intl.dart';

class Projectiles extends StatefulWidget {
  const Projectiles({Key? key}) : super(key: key);

  @override
  ProjectilesState createState() => ProjectilesState();
}

class ProjectilesState extends State<Projectiles> {
  UnitCategory _currentMode = UNITCATEGORY_ENERGY;

  GCWUnitsValue<Unit> _currentOutputUnit = GCWUnitsValue<Unit>(UNITCATEGORY_ENERGY.defaultUnit, UNITPREFIX_NONE);

  double _currentInputMass = 0.0;
  double _currentInputVelocity = 0.0;
  double _currentInputEnergy = 0.0;

  late Map<UnitCategory, String> _calculateProjectilesModeItems;

  @override
  void initState() {
    super.initState();

    _calculateProjectilesModeItems = {
      UNITCATEGORY_ENERGY: 'projectiles_energy',
      UNITCATEGORY_MASS: 'projectiles_mass',
      UNITCATEGORY_VELOCITY: 'projectiles_velocity',
    };
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GCWDropDown<UnitCategory>(
          value: _currentMode,
          onChanged: (value) {
            setState(() {
              _currentMode = value;

              if (_currentMode == UNITCATEGORY_ENERGY) {
                _currentOutputUnit = GCWUnitsValue<Unit>(UNITCATEGORY_ENERGY.defaultUnit, UNITPREFIX_NONE);
              } else if (_currentMode == UNITCATEGORY_MASS) {
                _currentOutputUnit = GCWUnitsValue<Unit>(UNITCATEGORY_MASS.defaultUnit, UNITPREFIX_NONE);
              } else if (_currentMode == UNITCATEGORY_VELOCITY) {
                _currentOutputUnit = GCWUnitsValue<Unit>(UNITCATEGORY_VELOCITY.defaultUnit, UNITPREFIX_NONE);
              }
            });
          },
          items: _calculateProjectilesModeItems.entries.map((mode) {
            return GCWDropDownMenuItem(value: mode.key, child: i18n(context, mode.value));
          }).toList(),
        ),
        _currentMode != UNITCATEGORY_MASS
            ? GCWUnitInput(
                value: _currentInputMass,
                title: i18n(context, 'projectiles_mass'),
                unitList: allMasses(),
                onChanged: (value) {
                  setState(() {
                    _currentInputMass = value;
                  });
                },
              )
            : Container(),
        _currentMode != UNITCATEGORY_ENERGY
            ? GCWUnitInput(
                value: _currentInputEnergy,
                title: i18n(context, 'projectiles_energy'),
                unitCategory: UNITCATEGORY_ENERGY,
                onChanged: (value) {
                  setState(() {
                    _currentInputEnergy = value;
                  });
                },
              )
            : Container(),
        _currentMode != UNITCATEGORY_VELOCITY
            ? GCWUnitInput(
                value: _currentInputVelocity,
                title: i18n(context, 'projectiles_velocity'),
                unitCategory: UNITCATEGORY_VELOCITY,
                onChanged: (value) {
                  setState(() {
                    _currentInputVelocity = value;
                  });
                },
              )
            : Container(),
        GCWTextDivider(text: i18n(context, 'common_outputunit')),
        GCWUnits(
          value: _currentOutputUnit,
          unitCategory: _currentMode,
          onlyShowPrefixSymbols: false,
          onChanged: (GCWUnitsValue value) {
            setState(() {
              _currentOutputUnit = value;
            });
          },
        ),
        GCWDefaultOutput(child: _calculateOutput())
      ],
    );
  }

  String _calculateOutput() {
    double? outputValue;

    if (_currentMode == UNITCATEGORY_ENERGY) {
      outputValue = calculateEnergy(_currentInputMass, _currentInputVelocity);
    } else if (_currentMode == UNITCATEGORY_MASS) {
      outputValue = calculateMass(_currentInputEnergy, _currentInputVelocity);
    } else if (_currentMode == UNITCATEGORY_VELOCITY) {
      outputValue = calculateVelocity(_currentInputEnergy, _currentInputMass);
    }

    if (outputValue == null) return '';

    outputValue = _currentOutputUnit.value.fromReference(outputValue) / _currentOutputUnit.prefix.value;
    return NumberFormat('0.0' + '#' * 6).format(outputValue) +
        ' ' +
        (_currentOutputUnit.prefix.symbol) +
        _currentOutputUnit.value.symbol;
  }
}
