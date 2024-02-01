import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/application/theme/theme.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_iconbutton.dart';
import 'package:gc_wizard/common_widgets/dividers/gcw_text_divider.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_output.dart';
import 'package:gc_wizard/common_widgets/units/gcw_unit_dropdown.dart';
import 'package:gc_wizard/common_widgets/units/gcw_unit_input.dart';
import 'package:gc_wizard/tools/science_and_technology/apparent_temperature/summer_simmer/logic/summer_simmer.dart';
import 'package:gc_wizard/tools/science_and_technology/unit_converter/logic/humidity.dart';
import 'package:gc_wizard/tools/science_and_technology/unit_converter/logic/temperature.dart';
import 'package:gc_wizard/tools/science_and_technology/unit_converter/logic/unit.dart';
import 'package:gc_wizard/tools/science_and_technology/unit_converter/logic/unit_category.dart';
import 'package:intl/intl.dart';

class SummerSimmerIndex extends StatefulWidget {
  const SummerSimmerIndex({Key? key}) : super(key: key);

  @override
  _SummerSimmerIndexState createState() => _SummerSimmerIndexState();
}

class _SummerSimmerIndexState extends State<SummerSimmerIndex> {
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
          min: 0.1,
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
    double summersimmer = calculateSummerSimmerIndex(_currentTemperature, _currentHumidity);

    String hintT = '';
    if (_currentTemperature < 18) {
      hintT = i18n(context, 'summersimmer_hint_temperature');
    }

    String hintH = '';
    if (_currentHumidity < 40) hintH = i18n(context, 'summersimmer_hint_humidity');

    var hint = [hintT, hintH].where((element) => element.isNotEmpty).join('\n');

    String hintSummerSimmer = _calculateHintSummerSimmer(summersimmer);

    return Column(
      children: [
        GCWDefaultOutput(
            child: Row(children: <Widget>[
          Container(
            width: 50,
            padding: const EdgeInsets.only(right: DOUBLE_DEFAULT_MARGIN),
            child: GCWIconButton(
              icon: Icons.wb_sunny,
              iconColor: _colorSummerSimmer(summersimmer),
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
                child: GCWOutput(child: NumberFormat('#.###').format(summersimmer))),
          ),
        ])),
        GCWTextDivider(text: i18n(context, 'heatindex_hint')),
        GCWOutput(
          child: hint != '' ? hint : i18n(context, hintSummerSimmer),
        ),
      ],
    );
  }

  String _calculateHintSummerSimmer(double summersimmer) {
    if (summersimmer > SUMMERSIMMER_HEAT_STRESS[SUMMERSIMMER_HEATSTRESS_CONDITION.LIGHT_BLUE]!) {
      if (summersimmer > SUMMERSIMMER_HEAT_STRESS[SUMMERSIMMER_HEATSTRESS_CONDITION.WHITE]!) {
        if (summersimmer > SUMMERSIMMER_HEAT_STRESS[SUMMERSIMMER_HEATSTRESS_CONDITION.LIGHT_YELLOW]!) {
          if (summersimmer > SUMMERSIMMER_HEAT_STRESS[SUMMERSIMMER_HEATSTRESS_CONDITION.YELLOW]!) {
            if (summersimmer > SUMMERSIMMER_HEAT_STRESS[SUMMERSIMMER_HEATSTRESS_CONDITION.ORANGE]!) {
              if (summersimmer > SUMMERSIMMER_HEAT_STRESS[SUMMERSIMMER_HEATSTRESS_CONDITION.RED]!) {
                return 'summersimmerindex_index_red';
              } else {
                return 'summersimmerindex_index_orange';
              }
            } else {
              return 'summersimmerindex_index_yellow';
            }
          } else {
            return 'summersimmerindex_index_light_yellow';
          }
        } else {
          return 'summersimmerindex_index_white';
        }
      } else {
        return 'summersimmerindex_index_light_blue';
      }
    } else {
      return 'summersimmerindex_index_blue';
    }
  }

  Color _colorSummerSimmer(double summersimmer) {
    if (summersimmer > SUMMERSIMMER_HEAT_STRESS[SUMMERSIMMER_HEATSTRESS_CONDITION.LIGHT_BLUE]!) {
      if (summersimmer > SUMMERSIMMER_HEAT_STRESS[SUMMERSIMMER_HEATSTRESS_CONDITION.WHITE]!) {
        if (summersimmer > SUMMERSIMMER_HEAT_STRESS[SUMMERSIMMER_HEATSTRESS_CONDITION.LIGHT_YELLOW]!) {
          if (summersimmer > SUMMERSIMMER_HEAT_STRESS[SUMMERSIMMER_HEATSTRESS_CONDITION.YELLOW]!) {
            if (summersimmer > SUMMERSIMMER_HEAT_STRESS[SUMMERSIMMER_HEATSTRESS_CONDITION.ORANGE]!) {
              if (summersimmer > SUMMERSIMMER_HEAT_STRESS[SUMMERSIMMER_HEATSTRESS_CONDITION.RED]!) {
                return Colors.red;
              } else {
                return Colors.orange;
              }
            } else {
              return Colors.yellow;
            }
          } else {
            return Colors.yellowAccent;
          }
        } else {
          return Colors.white;
        }
      } else {
        return Colors.lightBlueAccent;
      }
    } else {
      return Colors.blue;
    }
  }
}
