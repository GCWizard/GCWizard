import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/application/theme/theme.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_iconbutton.dart';
import 'package:gc_wizard/common_widgets/dividers/gcw_text_divider.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_output.dart';
import 'package:gc_wizard/common_widgets/units/gcw_unit_dropdown.dart';
import 'package:gc_wizard/common_widgets/units/gcw_unit_input.dart';
import 'package:gc_wizard/tools/science_and_technology/apparent_temperature/_common/logic/common.dart';
import 'package:gc_wizard/tools/science_and_technology/apparent_temperature/humidex/logic/humidex.dart';
import 'package:gc_wizard/tools/science_and_technology/unit_converter/logic/humidity.dart';
import 'package:gc_wizard/tools/science_and_technology/unit_converter/logic/temperature.dart';
import 'package:gc_wizard/tools/science_and_technology/unit_converter/logic/unit.dart';
import 'package:gc_wizard/tools/science_and_technology/unit_converter/logic/unit_category.dart';
import 'package:intl/intl.dart';

class Humidex extends StatefulWidget {
  const Humidex({Key? key}) : super(key: key);

  @override
  _HumidexState createState() => _HumidexState();
}

class _HumidexState extends State<Humidex> {
  double _currentTemperature = 0.0;
  double _currentHumidity = 0.0;

  Unit _currentOutputUnit = TEMPERATURE_CELSIUS;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GCWUnitInput<Temperature>(
          value: _currentTemperature,
          title: i18n(context, 'common_measure_temperature'),
          initialUnit: TEMPERATURE_CELSIUS,
          min: 0.0,
          unitList: temperatures,
          onChanged: (value) {
            setState(() {
              _currentTemperature = TEMPERATURE_CELSIUS.fromKelvin(value);
            });
          },
        ),
        GCWUnitInput<Humidity>(
          value: _currentHumidity,
          title: i18n(context, 'common_measure_humidity'),
          initialUnit: HUMIDITY,
          min: 0.0,
          max: 100.0,
          unitList: humidity,
          onChanged: (value) {
            setState(() {
              _currentHumidity = value;
            });
          },
        ),
        _buildOutput(context)
      ],
    );
  }

  Widget _buildOutput(BuildContext context) {
    double humidex = calculateHumidex(_currentTemperature, _currentHumidity);

    double dewpoint = calculateDewPoint(_currentTemperature, _currentHumidity);
    dewpoint = TEMPERATURE_CELSIUS.toKelvin(dewpoint);
    dewpoint = _currentOutputUnit.fromReference(dewpoint);

    String hintT = '';
    if (_currentTemperature < 21) {
      hintT = i18n(context, 'humidex_hint_temperature');
    }

    String hintH = '';
    if (_currentHumidity < 20) hintH = i18n(context, 'humidex_hint_humidity');

    var hint = [hintT, hintH].where((element) => element.isNotEmpty).join('\n');

    String hintHumidex = _calculateHintHumidex(humidex);

    return Column(
      children: [
        dewpoint.toString() == 'NaN'
            ? Container()
            : Column(children: <Widget>[
                GCWTextDivider(text: i18n(context, 'common_measure_dewpoint')),
                GCWOutput(
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 2,
                        //child: Text(_currentOutputUnit.symbol),
                        child: Container(
                            margin: const EdgeInsets.only(left: DEFAULT_MARGIN, right: DEFAULT_MARGIN),
                            child: GCWUnitDropDown(
                              value: _currentOutputUnit,
                              onlyShowSymbols: true,
                              unitList: temperatures,
                              unitCategory: UNITCATEGORY_TEMPERATURE,
                              onChanged: (value) {
                                setState(() {
                                  _currentOutputUnit = value;
                                });
                              },
                            )),
                      ),
                      Expanded(
                        flex: 2,
                        child: Container(
                            margin: const EdgeInsets.only(left: DEFAULT_MARGIN),
                            child: GCWOutput(child: NumberFormat('#.###').format(dewpoint))),
                      ),
                    ],
                  ),
                ),
              ]),
        GCWDefaultOutput(
            child: Row(children: <Widget>[
          Container(
            width: 50,
            padding: const EdgeInsets.only(right: DOUBLE_DEFAULT_MARGIN),
            child: GCWIconButton(
              icon: Icons.wb_sunny,
              iconColor: _colorHumidex(humidex),
              backgroundColor: const Color(0xFF4d4d4d),
              onPressed: () {},
            ),
          ),
          Expanded(
            flex: 2,
            //child: Text(_currentOutputUnit.symbol),
            child: Container(
                margin: const EdgeInsets.only(left: DEFAULT_MARGIN, right: 2 * DEFAULT_MARGIN),
                child: GCWUnitDropDown(
                  value: _currentOutputUnit,
                  onlyShowSymbols: false,
                  unitList: temperatures,
                  unitCategory: UNITCATEGORY_TEMPERATURE,
                  onChanged: (value) {
                    setState(() {
                      _currentOutputUnit = value;
                    });
                  },
                )),
          ),
          Expanded(
            flex: 2,
            child: Container(
                margin: const EdgeInsets.only(left: 2 * DEFAULT_MARGIN),
                child: GCWOutput(child: NumberFormat('#.###').format(humidex))),
          ),
        ])),
        GCWTextDivider(text: i18n(context, 'heatindex_hint')),
        GCWOutput(
          child: hint != '' ? hint : i18n(context, hintHumidex),
        ),
      ],
    );
  }

  String _calculateHintHumidex(double humidex) {
    if (humidex > HUMIDEX_HEAT_STRESS[HUMIDEX_HEATSTRESS_CONDITION.GREEN]!) {
      if (humidex > HUMIDEX_HEAT_STRESS[HUMIDEX_HEATSTRESS_CONDITION.YELLOW]!) {
        if (humidex > HUMIDEX_HEAT_STRESS[HUMIDEX_HEATSTRESS_CONDITION.ORANGE]!) {
          if (humidex > HUMIDEX_HEAT_STRESS[HUMIDEX_HEATSTRESS_CONDITION.RED]!) {
            return 'humidex_index_red';
          } else {
            return 'humidex_index_orange';
          }
        } else {
          return 'humidex_index_yellow';
        }
      } else {
        return 'humidex_index_green';
      }
    } else {
      return 'humidex_index_white';
    }
  }

  Color _colorHumidex(double humidex) {
    if (humidex > HUMIDEX_HEAT_STRESS[HUMIDEX_HEATSTRESS_CONDITION.GREEN]!) {
      if (humidex > HUMIDEX_HEAT_STRESS[HUMIDEX_HEATSTRESS_CONDITION.YELLOW]!) {
        if (humidex > HUMIDEX_HEAT_STRESS[HUMIDEX_HEATSTRESS_CONDITION.ORANGE]!) {
          if (humidex > HUMIDEX_HEAT_STRESS[HUMIDEX_HEATSTRESS_CONDITION.RED]!) {
            return Colors.red;
          } else {
            return Colors.orange;
          }
        } else {
          return Colors.yellow;
        }
      } else {
        return Colors.green;
      }
    } else {
      return Colors.lightBlueAccent;
    }
  }
}
