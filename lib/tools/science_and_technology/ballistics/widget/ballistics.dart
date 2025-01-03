import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/tools/science_and_technology/unit_converter/logic/drag.dart';
import 'package:intl/intl.dart';

import 'package:gc_wizard/application/theme/theme.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_dropdown.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_output_text.dart';
import 'package:gc_wizard/common_widgets/units/gcw_unit_input.dart';
import 'package:gc_wizard/common_widgets/units/gcw_units.dart';

import 'package:gc_wizard/tools/science_and_technology/unit_converter/logic/density.dart';
import 'package:gc_wizard/tools/science_and_technology/unit_converter/logic/mass.dart';
import 'package:gc_wizard/tools/science_and_technology/unit_converter/logic/acceleration.dart';
import 'package:gc_wizard/tools/science_and_technology/unit_converter/logic/angle.dart';
import 'package:gc_wizard/tools/science_and_technology/unit_converter/logic/length.dart';
import 'package:gc_wizard/tools/science_and_technology/unit_converter/logic/unit.dart';
import 'package:gc_wizard/tools/science_and_technology/unit_converter/logic/unit_category.dart';
import 'package:gc_wizard/tools/science_and_technology/unit_converter/logic/unit_prefix.dart';

import 'package:gc_wizard/tools/science_and_technology/ballistics/logic/ballistics.dart';

class Ballistics extends StatefulWidget {
  const Ballistics({Key? key}) : super(key: key);

  @override
  BallisticsState createState() => BallisticsState();
}

class BallisticsState extends State<Ballistics> {
  double _currentInputVelocity = 0.0;
  double _currentInputAngle = 0.0;
  double _currentInputAcceleration = 9.81;
  double _currentInputHeight = 0.0;
  double _currentInputDensity = 0.0;
  double _currentInputDiameter = 0.0;
  double _currentInputDrag = 0.0;
  double _currentInputMass = 0.0;

  GCWUnitsValue<Unit> _currentOutputDistanceUnit =
      GCWUnitsValue<Unit>(UNITCATEGORY_LENGTH.defaultUnit, UNITPREFIX_NONE);
  GCWUnitsValue<Unit> _currentOutputTimeUnit = GCWUnitsValue<Unit>(UNITCATEGORY_TIME.defaultUnit, UNITPREFIX_NONE);
  GCWUnitsValue<Unit> _currentOutputMaxSpeedUnit =
      GCWUnitsValue<Unit>(UNITCATEGORY_VELOCITY.defaultUnit, UNITPREFIX_NONE);
  GCWUnitsValue<Unit> _currentOutputHeightUnit = GCWUnitsValue<Unit>(UNITCATEGORY_LENGTH.defaultUnit, UNITPREFIX_NONE);

  AIR_RESISTANCE _currentAirResistanceMode = AIR_RESISTANCE.NONE;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GCWUnitInput(
          value: _currentInputVelocity,
          title: i18n(context, 'unitconverter_category_velocity'),
          unitCategory: UNITCATEGORY_VELOCITY,
          onChanged: (value) {
            setState(() {
              _currentInputVelocity = value;
            });
          },
        ),
        GCWUnitInput<Angle>(
          value: _currentInputAngle,
          title: i18n(context, 'unitconverter_category_angle'),
          unitCategory: UNITCATEGORY_ANGLE,
          onChanged: (value) {
            setState(() {
              _currentInputAngle = value;
            });
          },
        ),
        GCWUnitInput<Length>(
          value: _currentInputHeight,
          title: i18n(context, 'ballistics_height'),
          unitCategory: UNITCATEGORY_LENGTH,
          onChanged: (value) {
            setState(() {
              _currentInputHeight = value;
            });
          },
        ),
        GCWUnitInput<Acceleration>(
          value: _currentInputAcceleration,
          title: i18n(context, 'unitconverter_category_acceleration'),
          unitCategory: UNITCATEGORY_ACCELERATION,
          onChanged: (value) {
            setState(() {
              _currentInputAcceleration = value;
            });
          },
        ),
        GCWDropDown(
          title: i18n(context, 'ballistics_drag'),
          value: _currentAirResistanceMode,
          onChanged: (value) {
            setState(() {
              _currentAirResistanceMode = value;
            });
          },
          items: AIR_RESISTANCE_LIST.entries.map((mode) {
            return GCWDropDownMenuItem(
              value: mode.key,
              child: i18n(context, mode.value),
            );
          }).toList(),
        ),
        _currentAirResistanceMode != AIR_RESISTANCE.NONE
            ? Column(
                children: <Widget>[
                  GCWUnitInput<Mass>(
                    value: _currentInputMass,
                    title: i18n(context, 'unitconverter_category_mass'),
                    unitCategory: UNITCATEGORY_MASS,
                    unitList: allMasses(),
                    onChanged: (value) {
                      setState(() {
                        _currentInputMass = MASS_KILOGRAM.fromGram(value);
                      });
                    },
                  ),
                  GCWUnitInput<Length>(
                    value: _currentInputDiameter,
                    title: i18n(context, 'ballistics_diameter'),
                    unitCategory: UNITCATEGORY_LENGTH,
                    onChanged: (value) {
                      setState(() {
                        _currentInputDiameter = value;
                      });
                    },
                  ),
                  GCWUnitInput<Density>(
                    value: _currentInputDensity,
                    title: i18n(context, 'unitconverter_category_density'),
                    unitCategory: UNITCATEGORY_DENSITY,
                    onChanged: (value) {
                      setState(() {
                        _currentInputDensity = DENSITY_KILOGRAMPERCUBICMETER.fromGramPerCubicMeter(value);
                      });
                    },
                  ),
                  GCWUnitInput<Drag>(
                    value: _currentInputDrag,
                    title: i18n(context, 'ballistics_cw'),
                    unitCategory: UNITCATEGORY_DRAG,
                    onChanged: (value) {
                      setState(() {
                        _currentInputDrag = value;
                      });
                    },
                  ),
                ],
              )
            : Container(),
        GCWDefaultOutput(child: _calculateOutput())
      ],
    );
  }

  Widget _calculateOutput() {
    OutputBallistics output;

    switch (_currentAirResistanceMode) {
      case AIR_RESISTANCE.NONE:
        output = calculateBallisticsNoDrag(
            _currentInputVelocity, _currentInputAngle, _currentInputAcceleration, _currentInputHeight);
        break;
      case AIR_RESISTANCE.STOKES:
        output = calculateBallisticsStokes(_currentInputVelocity, _currentInputAngle, _currentInputAcceleration,
            _currentInputHeight, _currentInputMass, _currentInputDiameter, _currentInputDrag, _currentInputDensity);
        break;
      case AIR_RESISTANCE.NEWTON:
        output = calculateBallisticsNewton(_currentInputVelocity, _currentInputAngle, _currentInputAcceleration,
            _currentInputHeight, _currentInputMass, _currentInputDiameter, _currentInputDrag, _currentInputDensity);
    }

    double outputDistanceValue =
        _currentOutputDistanceUnit.value.fromReference(output.Distance) / _currentOutputDistanceUnit.prefix.value;
    double outputTimeValue =
        _currentOutputTimeUnit.value.fromReference(output.Time) / _currentOutputTimeUnit.prefix.value;
    double outputMaxSpeedValue =
        _currentOutputMaxSpeedUnit.value.fromReference(output.maxSpeed) / _currentOutputMaxSpeedUnit.prefix.value;
    double outputHeightValue =
        _currentOutputHeightUnit.value.fromReference(output.Height) / _currentOutputHeightUnit.prefix.value;

    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              flex: 2,
              child: GCWOutputText(
                text: i18n(context, 'ballistics_distance'),
                suppressCopyButton: true,
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.only(right: DOUBLE_DEFAULT_MARGIN, left: DOUBLE_DEFAULT_MARGIN),
                child: GCWOutputText(
                  text: NumberFormat('0.0' + '#####').format(outputDistanceValue),
                ),
              ),
            ),
            Expanded(
                flex: 4,
                child: GCWUnits(
                  value: _currentOutputDistanceUnit,
                  unitCategory: UNITCATEGORY_LENGTH,
                  onlyShowPrefixSymbols: true,
                  onlyShowUnitSymbols: true,
                  onChanged: (GCWUnitsValue value) {
                    setState(() {
                      _currentOutputDistanceUnit = value;
                      outputDistanceValue = _currentOutputDistanceUnit.value.fromReference(output.Distance) /
                          _currentOutputDistanceUnit.prefix.value;
                    });
                  },
                )),
          ],
        ),
        Row(
          children: <Widget>[
            Expanded(
              flex: 2,
              child: GCWOutputText(
                text: i18n(context, 'ballistics_time'),
                suppressCopyButton: true,
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.only(right: DOUBLE_DEFAULT_MARGIN, left: DOUBLE_DEFAULT_MARGIN),
                child: GCWOutputText(
                  text: NumberFormat('0.0' + '#####').format(outputTimeValue),
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: GCWUnits(
                value: _currentOutputTimeUnit,
                unitCategory: UNITCATEGORY_TIME,
                onlyShowPrefixSymbols: true,
                onlyShowUnitSymbols: true,
                onChanged: (GCWUnitsValue value) {
                  setState(() {
                    _currentOutputTimeUnit = value;
                    outputDistanceValue =
                        _currentOutputTimeUnit.value.fromReference(output.Time) / _currentOutputTimeUnit.prefix.value;
                  });
                },
              ),
            ),
          ],
        ),
        Row(
          children: <Widget>[
            Expanded(
              flex: 2,
              child: GCWOutputText(
                text: i18n(context, 'ballistics_height'),
                suppressCopyButton: true,
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.only(right: DOUBLE_DEFAULT_MARGIN, left: DOUBLE_DEFAULT_MARGIN),
                child: GCWOutputText(
                  text: NumberFormat('0.0' + '#####').format(outputHeightValue),
                ),
              ),
            ),
            Expanded(
                flex: 4,
                child: GCWUnits(
                  value: _currentOutputHeightUnit,
                  unitCategory: UNITCATEGORY_LENGTH,
                  onlyShowPrefixSymbols: true,
                  onlyShowUnitSymbols: true,
                  onChanged: (GCWUnitsValue value) {
                    setState(() {
                      _currentOutputHeightUnit = value;
                      outputHeightValue = _currentOutputHeightUnit.value.fromReference(output.Height) /
                          _currentOutputHeightUnit.prefix.value;
                    });
                  },
                )),
          ],
        ),
        Row(
          children: <Widget>[
            Expanded(
              flex: 2,
              child: GCWOutputText(
                text: i18n(context, 'ballistics_maxspeed'),
                suppressCopyButton: true,
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.only(right: DOUBLE_DEFAULT_MARGIN, left: DOUBLE_DEFAULT_MARGIN),
                child: GCWOutputText(
                  text: (outputMaxSpeedValue > 0)
                      ? NumberFormat('0.0' + '#####').format(outputMaxSpeedValue)
                      : NumberFormat('0.0' + '#####').format(_currentInputVelocity),
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: GCWUnits(
                value: _currentOutputMaxSpeedUnit,
                unitCategory: UNITCATEGORY_VELOCITY,
                onlyShowPrefixSymbols: true,
                onlyShowUnitSymbols: true,
                onChanged: (GCWUnitsValue value) {
                  setState(() {
                    _currentOutputMaxSpeedUnit = value;
                    outputMaxSpeedValue = _currentOutputMaxSpeedUnit.value.fromReference(output.maxSpeed) /
                        _currentOutputMaxSpeedUnit.prefix.value;
                  });
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
