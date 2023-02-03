import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/app_localizations.dart';
import 'package:gc_wizard/common_widgets/gcw_text.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_multiple_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_output.dart';
import 'package:gc_wizard/common_widgets/spinners/gcw_double_spinner.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_twooptions_switch.dart';
import 'package:gc_wizard/tools/science_and_technology/apparent_temperature/heat_index/logic/heat_index.dart';
import 'package:gc_wizard/tools/science_and_technology/unit_converter/logic/temperature.dart';

class HeatIndex extends StatefulWidget {
  @override
  HeatIndexState createState() => HeatIndexState();
}

class HeatIndexState extends State<HeatIndex> {
  double _currentTemperature = 0.0;
  double _currentHumidity = 0.0;

  var _isMetric = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: [
            Expanded(child: GCWText(text: i18n(context, 'common_measure_temperature')), flex: 1),
            Expanded(
                child: Column(
                  children: [
                    GCWTwoOptionsSwitch(
                      notitle: true,
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
                  ],
                ),
                flex: 3)
          ],
        ),
        GCWDoubleSpinner(
            title: i18n(context, 'common_measure_humidity'),
            value: _currentHumidity,
            min: 0.0,
            max: 100.0,
            onChanged: (value) {
              setState(() {
                _currentHumidity = value;
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
      output = calculateHeatIndex(_currentTemperature, _currentHumidity, TEMPERATURE_CELSIUS);
      unit = TEMPERATURE_CELSIUS.symbol;
    } else {
      output = calculateHeatIndex(_currentTemperature, _currentHumidity, TEMPERATURE_FAHRENHEIT);
      unit = TEMPERATURE_FAHRENHEIT.symbol;
    }

    String hintT;
    if ((_isMetric && _currentTemperature < 27) || (!_isMetric && _currentTemperature < 80)) {
      hintT = i18n(context, 'heatindex_hint_temperature', parameters: ['${_isMetric ? 27 : 80} $unit']);
    }

    String hintH;
    if (_currentHumidity < 40) hintH = i18n(context, 'heatindex_hint_humidity');

    var hint = [hintT, hintH].where((element) => element != null && element.length > 0).join('\n');

    String hintM;
    if (output > 54)
      hintM = 'heatindex_index_54';
    else if (output > 40)
      hintM = 'heatindex_index_40';
    else if (output > 32)
      hintM = 'heatindex_index_32';
    else if (output > 27) hintM = 'heatindex_index_27';

    var outputs = [
      GCWOutput(
        title: i18n(context, 'heatindex_output'),
        child: output.toStringAsFixed(3) + ' ' + unit,
      )
    ];

    if (hint != null && hint.length > 0) outputs.add(GCWOutput(title: i18n(context, 'heatindex_hint'), child: hint));

    if (hintM != null && hintM.length > 0)
      outputs.add(GCWOutput(title: i18n(context, 'heatindex_meaning'), child: i18n(context, hintM)));

    return GCWMultipleOutput(
      children: outputs,
    );
  }
}
