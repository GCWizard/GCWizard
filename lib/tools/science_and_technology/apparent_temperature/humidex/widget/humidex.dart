import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/app_localizations.dart';
import 'package:gc_wizard/common_widgets/dividers/gcw_divider.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_multiple_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_output.dart';
import 'package:gc_wizard/common_widgets/spinners/gcw_double_spinner.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_twooptions_switch.dart';
import 'package:gc_wizard/tools/science_and_technology/apparent_temperature/humidex/logic/humidex.dart';
import 'package:gc_wizard/tools/science_and_technology/unit_converter/logic/temperature.dart';

class Humidex extends StatefulWidget {
  @override
  HumidexState createState() => HumidexState();
}

class HumidexState extends State<Humidex> {
  double _currentTemperature = 0.0;
  double _currentDewPoint = 0.0;

  var _isMetric = true;
  var _isHumidity = true;
  var mode = '';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GCWTwoOptionsSwitch(
          title: i18n(context, 'common_measure_temperature'),
          leftValue: i18n(context, 'common_unit_temperature_degc_name'),
          rightValue: i18n(context, 'common_unit_temperature_degf_name'),
          value: _isMetric ? GCWSwitchPosition.left : GCWSwitchPosition.right,
          onChanged: (value) {
            setState(() {
              _isMetric = value == GCWSwitchPosition.left;
            });
          },
        ),
        GCWDoubleSpinner(
            value: _currentTemperature,
            onChanged: (value) {
              setState(() {
                _currentTemperature = value;
              });
            }),
        Container(
          child: GCWDivider(),
          padding: EdgeInsets.only(top: 10),
        ),
        GCWTwoOptionsSwitch(
          leftValue: i18n(context, 'common_measure_humidity'),
          rightValue: i18n(context, 'common_measure_dewpoint'),
          value: _isHumidity ? GCWSwitchPosition.left : GCWSwitchPosition.right,
          onChanged: (value) {
            setState(() {
              _isHumidity = value == GCWSwitchPosition.left;
              if (_isHumidity) {
                mode = 'common_measure_humidity';
              } else {
                mode = 'common_measure_dewpoint';
              }
            });
          },
        ),
        GCWDoubleSpinner(
            value: _currentDewPoint,
            min: 0.0,
            max: 100.0,
            onChanged: (value) {
              setState(() {
                _currentDewPoint = value;
              });
            }),
        _buildOutput(context)
      ],
    );
  }

  Widget _buildOutput(BuildContext context) {
    String unit = '';
    double output;
    if (_isMetric) {
      output = calculateHumidex(_currentTemperature, _currentDewPoint, TEMPERATURE_CELSIUS, _isHumidity);
      unit = TEMPERATURE_CELSIUS.symbol;
    } else {
      output = calculateHumidex(_currentTemperature, _currentDewPoint, TEMPERATURE_FAHRENHEIT, _isHumidity);
      unit = TEMPERATURE_FAHRENHEIT.symbol;
    }

    String hintT;
    if ((_isMetric && _currentTemperature < 27) || (!_isMetric && _currentTemperature < 80)) {
      hintT = i18n(context, 'heatindex_hint_temperature', parameters: ['${_isMetric ? 27 : 80} $unit']);
    }

    String hintH;
    if (_isHumidity) {
      if (_currentDewPoint < 40) hintH = i18n(context, 'heatindex_hint_humidity');
    } else
      hintH = '';

    var hint = [hintT, hintH].where((element) => element != null && element.length > 0).join('\n');

    String hintM = '';
    if (output > 45)
      hintM = 'humidex_index_45';
    else if (output > 39)
      hintM = 'humidex_index_40';
    else if (output > 29)
      hintM = 'humidex_index_30';
    else if (output > 19) hintM = 'humidex_index_20';

    var outputs = [
      GCWOutput(
        title: i18n(context, 'humidex_output'),
        child: output.toStringAsFixed(3),
      )
    ];

    if (hint != null && hint.length > 0) outputs.add(GCWOutput(title: i18n(context, 'heatindex_hint'), child: hint));

    if (hintM != null && hintM.length > 0)
      outputs.add(GCWOutput(
        title: i18n(context, 'humidex_meaning'),
        child: i18n(context, hintM),
      ));

    return GCWMultipleOutput(
      children: outputs,
    );
  }
}
