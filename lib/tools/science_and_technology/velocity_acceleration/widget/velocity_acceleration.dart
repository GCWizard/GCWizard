import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/common_widgets/dividers/gcw_text_divider.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_dropdown.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_onoff_switch.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_twooptions_switch.dart';
import 'package:gc_wizard/common_widgets/units/gcw_unit_input.dart';
import 'package:gc_wizard/common_widgets/units/gcw_units.dart';
import 'package:gc_wizard/tools/science_and_technology/unit_converter/logic/acceleration.dart';
import 'package:gc_wizard/tools/science_and_technology/unit_converter/logic/length.dart';
import 'package:gc_wizard/tools/science_and_technology/unit_converter/logic/time.dart';
import 'package:gc_wizard/tools/science_and_technology/unit_converter/logic/unit.dart';
import 'package:gc_wizard/tools/science_and_technology/unit_converter/logic/unit_category.dart';
import 'package:gc_wizard/tools/science_and_technology/unit_converter/logic/unit_prefix.dart';
import 'package:gc_wizard/tools/science_and_technology/unit_converter/logic/velocity.dart' as v;
import 'package:gc_wizard/tools/science_and_technology/velocity_acceleration/logic/velocity_acceleration.dart';
import 'package:intl/intl.dart';

class VelocityAcceleration extends StatefulWidget {
  const VelocityAcceleration({Key? key}) : super(key: key);

  @override
  _VelocityAccelerationState createState() => _VelocityAccelerationState();
}

class _VelocityAccelerationState extends State<VelocityAcceleration> {
  UnitCategory _currentMode = UNITCATEGORY_LENGTH;

  var _currentDistance = 0.0;
  var _currentTime = 0.0;
  var _currentVelocity = 0.0;
  var _currentAcceleration = 0.0;

  var _currentAccelerationMode = false;
  var _currentAccelerationCalcMode = GCWSwitchPosition.left;

  GCWUnitsValue<Unit> _currentOutputUnit = GCWUnitsValue<Length>(UNITCATEGORY_LENGTH.defaultUnit, UNITPREFIX_NONE);
  late Map<UnitCategory, String> _modes;

  @override
  void initState() {
    super.initState();

    _modes = {
      UNITCATEGORY_LENGTH: 'velocity_acceleration_distance',
      UNITCATEGORY_VELOCITY: 'unitconverter_category_velocity',
      UNITCATEGORY_ACCELERATION: 'unitconverter_category_acceleration',
      UNITCATEGORY_TIME: 'unitconverter_category_time',
    };
  }

  @override
  Widget build(BuildContext context) {
    var modes = [UNITCATEGORY_LENGTH, UNITCATEGORY_VELOCITY, UNITCATEGORY_TIME];
    if (_currentAccelerationMode) {
      modes.add(UNITCATEGORY_ACCELERATION);
    } else {
      if (_currentMode == UNITCATEGORY_ACCELERATION) {
        _currentMode = UNITCATEGORY_LENGTH;
      }
    }

    return Column(
      children: [
        GCWOnOffSwitch(
            title: i18n(context, 'unitconverter_category_acceleration'),
            onChanged: (value) {
              setState(() {
                _currentAccelerationMode = value;
              });
            },
            value: _currentAccelerationMode),
        GCWDropDown<UnitCategory>(
          value: _currentMode,
          items: modes.map((mode) {
            return GCWDropDownMenuItem(value: mode, child: i18n(context, _modes[mode]!));
          }).toList(),
          onChanged: (value) {
            setState(() {
              _currentMode = value;

              if (_currentMode == UNITCATEGORY_LENGTH) {
                _currentOutputUnit = GCWUnitsValue<Length>(UNITCATEGORY_LENGTH.defaultUnit, UNITPREFIX_NONE);
              } else if (_currentMode == UNITCATEGORY_ACCELERATION) {
                _currentOutputUnit =
                    GCWUnitsValue<Acceleration>(UNITCATEGORY_ACCELERATION.defaultUnit, UNITPREFIX_NONE);
              } else if (_currentMode == UNITCATEGORY_VELOCITY) {
                _currentOutputUnit = GCWUnitsValue<v.Velocity>(UNITCATEGORY_VELOCITY.defaultUnit, UNITPREFIX_NONE);
              } else if (_currentMode == UNITCATEGORY_TIME) {
                _currentOutputUnit = GCWUnitsValue<Time>(UNITCATEGORY_TIME.defaultUnit, UNITPREFIX_NONE);
              }
            });
          },
        ),
        _currentMode == UNITCATEGORY_ACCELERATION
            ? GCWTwoOptionsSwitch(
                leftValue: i18n(context, 'unitconverter_category_velocity'),
                rightValue: i18n(context, 'velocity_acceleration_distance'),
                onChanged: (value) {
                  setState(() {
                    _currentAccelerationCalcMode = value;
                  });
                },
                value: _currentAccelerationCalcMode)
            : Container(),
        _currentMode != UNITCATEGORY_TIME
            ? GCWUnitInput<Time>(
                value: _currentTime,
                title: i18n(context, 'unitconverter_category_time'),
                min: 0.0,
                suppressOverflow: true,
                unitCategory: UNITCATEGORY_TIME,
                initialUnit: TIME_SECOND,
                onChanged: (value) {
                  setState(() {
                    _currentTime = value;
                  });
                },
              )
            : Container(),
        _currentMode != UNITCATEGORY_ACCELERATION && _currentAccelerationMode
            ? GCWUnitInput<Acceleration>(
                value: _currentAcceleration,
                title: i18n(context, 'unitconverter_category_acceleration'),
                min: 0.0,
                suppressOverflow: true,
                unitList: accelerations,
                onChanged: (value) {
                  setState(() {
                    _currentAcceleration = value;
                  });
                },
              )
            : Container(),
        ((_currentAccelerationMode &&
                    _currentMode == UNITCATEGORY_ACCELERATION &&
                    _currentAccelerationCalcMode == GCWSwitchPosition.left) ||
                (!_currentAccelerationMode && _currentMode == UNITCATEGORY_LENGTH) ||
                (!_currentAccelerationMode && _currentMode == UNITCATEGORY_TIME))
            ? GCWUnitInput<v.Velocity>(
                value: _currentVelocity,
                title: i18n(context, 'unitconverter_category_velocity'),
                min: 0.0,
                suppressOverflow: true,
                unitList: v.velocities,
                onChanged: (value) {
                  setState(() {
                    _currentVelocity = value;
                  });
                },
              )
            : Container(),
        ((_currentAccelerationMode &&
                    _currentMode == UNITCATEGORY_ACCELERATION &&
                    _currentAccelerationCalcMode == GCWSwitchPosition.right) ||
                (!_currentAccelerationMode && _currentMode != UNITCATEGORY_LENGTH) ||
                _currentMode == UNITCATEGORY_TIME)
            ? GCWUnitInput<Length>(
                value: _currentDistance,
                title: i18n(context, 'velocity_acceleration_distance'),
                min: 0.0,
                suppressOverflow: true,
                unitList: allLengths(),
                onChanged: (value) {
                  setState(() {
                    _currentDistance = value;
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
        _buildOutput()
      ],
    );
  }

  Widget _buildOutput() {
    double value = double.nan;

    if (_currentMode == UNITCATEGORY_LENGTH) {
      if (_currentAccelerationMode) {
        value = distance(time: _currentTime, acceleration: _currentAcceleration);
      } else {
        value = distance(time: _currentTime, velocity: _currentVelocity);
      }
    } else if (_currentMode == UNITCATEGORY_ACCELERATION) {
      if (_currentAccelerationMode) {
        if (_currentAccelerationCalcMode == GCWSwitchPosition.right) {
          value = acceleration(time: _currentTime, distance: _currentDistance);
        } else {
          value = acceleration(time: _currentTime, velocity: _currentVelocity);
        }
      }
    } else if (_currentMode == UNITCATEGORY_VELOCITY) {
      if (_currentAccelerationMode) {
        value = velocity(time: _currentTime, acceleration: _currentAcceleration);
      } else {
        value = velocity(time: _currentTime, distance: _currentDistance);
      }
    } else if (_currentMode == UNITCATEGORY_TIME) {
      if (_currentAccelerationMode) {
        value = time(distance: _currentDistance, acceleration: _currentAcceleration);
      } else {
        value = time(distance: _currentDistance, velocity: _currentAcceleration);
      }
    }

    if (value.isNaN) {
      return const GCWDefaultOutput();
    }

    value = _currentOutputUnit.value.fromReference(value) / _currentOutputUnit.prefix.value;
    var out = NumberFormat('0.0' + '#' * 6).format(value) +
        ' ' +
        (_currentOutputUnit.prefix.symbol) +
        _currentOutputUnit.value.symbol;

    return GCWDefaultOutput(
      child: out,
      copyText: value.toString(),
    );
  }
}
