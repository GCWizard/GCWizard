import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/application/theme/theme.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_iconbutton.dart';
import 'package:gc_wizard/common_widgets/dividers/gcw_text_divider.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_output.dart';
import 'package:gc_wizard/common_widgets/units/gcw_unit_dropdown.dart';
import 'package:gc_wizard/common_widgets/units/gcw_unit_input.dart';
import 'package:gc_wizard/tools/science_and_technology/apparent_temperature/heat_index/logic/heat_index.dart';
import 'package:gc_wizard/tools/science_and_technology/unit_converter/logic/humidity.dart';
import 'package:gc_wizard/tools/science_and_technology/unit_converter/logic/temperature.dart';
import 'package:gc_wizard/tools/science_and_technology/unit_converter/logic/unit.dart';
import 'package:gc_wizard/tools/science_and_technology/unit_converter/logic/unit_category.dart';
import 'package:intl/intl.dart';

class HeatIndex extends StatefulWidget {
  const HeatIndex({Key? key}) : super(key: key);

  @override
  _HeatIndexState createState() => _HeatIndexState();
}

class _HeatIndexState extends State<HeatIndex> {
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
    String hintHeatIndex = '';
    double HeatIndex_C = 0.0;
    double HeatIndex = 0.0;

    HeatIndex_C = calculateHeatIndex(_currentTemperature, _currentHumidity);
    hintHeatIndex = _calculateHintHeatIndex(HeatIndex_C);

    HeatIndex = TEMPERATURE_CELSIUS.toKelvin(HeatIndex_C);
    HeatIndex = _currentOutputUnit.fromReference(HeatIndex);

    String hintT = '';
    if (_currentTemperature < 27) {
      hintT = i18n(context, 'heatindex_hint_temperature');
    }

    String hintH = '';

    if (_currentHumidity < 40) hintH = i18n(context, 'heatindex_hint_humidity');

    var hint = [hintT, hintH].where((element) => element.isNotEmpty).join('\n');

    return Column(
      children: [
        GCWDefaultOutput(
            child: Row(children: <Widget>[
          Container(
            width: 50,
            padding: const EdgeInsets.only(right: DOUBLE_DEFAULT_MARGIN),
            child: GCWIconButton(
              icon: Icons.wb_sunny,
              iconColor: _colorHeatIndex(HeatIndex_C),
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
                child: GCWOutput(child: NumberFormat('#.###').format(HeatIndex))),
          ),
        ])),
        GCWTextDivider(text: i18n(context, 'heatindex_hint')),
        GCWOutput(
          child: hint != '' ? hint : i18n(context, hintHeatIndex),
        ),
      ],
    );
  }

  String _calculateHintHeatIndex(double HeatIndex) {
    if (HeatIndex > HEATINDEX_HEAT_STRESS[HEATINDEX_HEATSTRESS_CONDITION.LIGHT_YELLOW]!) {
      if (HeatIndex > HEATINDEX_HEAT_STRESS[HEATINDEX_HEATSTRESS_CONDITION.YELLOW]!) {
        if (HeatIndex > HEATINDEX_HEAT_STRESS[HEATINDEX_HEATSTRESS_CONDITION.ORANGE]!) {
          if (HeatIndex > HEATINDEX_HEAT_STRESS[HEATINDEX_HEATSTRESS_CONDITION.RED]!) {
            return 'heatindex_index_red';
          } else {
            return 'heatindex_index_orange';
          }
        } else {
          return 'heatindex_index_yellow';
        }
      } else {
        return 'heatindex_index_light_yellow';
      }
    } else {
      return 'heatindex_index_white';
    }
  }

  Color _colorHeatIndex(double HeatIndex) {
    if (HeatIndex > HEATINDEX_HEAT_STRESS[HEATINDEX_HEATSTRESS_CONDITION.LIGHT_YELLOW]!) {
      if (HeatIndex > HEATINDEX_HEAT_STRESS[HEATINDEX_HEATSTRESS_CONDITION.YELLOW]!) {
        if (HeatIndex > HEATINDEX_HEAT_STRESS[HEATINDEX_HEATSTRESS_CONDITION.ORANGE]!) {
          if (HeatIndex > HEATINDEX_HEAT_STRESS[HEATINDEX_HEATSTRESS_CONDITION.RED]!) {
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
  }
}
