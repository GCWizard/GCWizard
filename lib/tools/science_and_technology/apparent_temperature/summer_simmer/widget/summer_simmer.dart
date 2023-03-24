import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/app_localizations.dart';
import 'package:gc_wizard/common_widgets/gcw_text.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_multiple_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_output.dart';
import 'package:gc_wizard/common_widgets/spinners/gcw_double_spinner.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_twooptions_switch.dart';
import 'package:gc_wizard/tools/science_and_technology/apparent_temperature/summer_simmer/logic/summer_simmer.dart';
import 'package:gc_wizard/tools/science_and_technology/unit_converter/logic/temperature.dart';

class SummerSimmerIndex extends StatefulWidget {
  const SummerSimmerIndex({Key? key}) : super(key: key);

  @override
  SummerSimmerIndexState createState() => SummerSimmerIndexState();
}

class SummerSimmerIndexState extends State<SummerSimmerIndex> {
  double _currentTemperature = 0.0;
  double _currentHumidity = 0.0;

  var _isMetric = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: [
            Expanded(
              flex: 1,
              child: GCWText(text: i18n(context, 'common_measure_temperature')),
            ),
            Expanded(
                flex: 3,
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
                ))
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
      output = calculateSummerSimmerIndex(_currentTemperature, _currentHumidity, TEMPERATURE_CELSIUS);
      unit = TEMPERATURE_CELSIUS.symbol;
    } else {
      output = calculateSummerSimmerIndex(_currentTemperature, _currentHumidity, TEMPERATURE_FAHRENHEIT);
      unit = TEMPERATURE_FAHRENHEIT.symbol;
    }

    String? hintT;
    if ((_isMetric && _currentTemperature < 18) || (!_isMetric && _currentTemperature < 64)) {
      hintT = i18n(context, 'heatindex_hint_temperature', parameters: ['${_isMetric ? 18 : 64} $unit']);
    }

    String? hintH;
    if (_currentHumidity < 40) hintH = i18n(context, 'heatindex_hint_humidity');

    var hint = [hintT, hintH].where((element) => element != null && element.isNotEmpty).join('\n');

    String? hintM;
    if (output > 51.7) {
      hintM = 'summersimmerindex_index_51.7';
    } else if (output > 44.4) {
      hintM = 'summersimmerindex_index_44.4';
    } else if (output > 37.8) {
      hintM = 'summersimmerindex_index_37.8';
    } else if (output > 32.8) {
      hintM = 'summersimmerindex_index_32.8';
    } else if (output > 28.3) {
      hintM = 'summersimmerindex_index_28.3';
    } else if (output > 25.0) {
      hintM = 'summersimmerindex_index_25.0';
    } else if (output > 21.3) {
      hintM = 'summersimmerindex_index_21.3';
    }

    var outputs = [
      GCWOutput(
        title: i18n(context, 'heatindex_output'),
        child: output.toStringAsFixed(3) + ' ' + unit,
      )
    ];

    if (hint.isNotEmpty) outputs.add(GCWOutput(title: i18n(context, 'heatindex_hint'), child: hint));

    if (hintM != null && hintM.isNotEmpty) {
      outputs.add(GCWOutput(title: i18n(context, 'heatindex_meaning'), child: i18n(context, hintM)));
    }

    return GCWMultipleOutput(
      children: outputs,
    );
  }
}
