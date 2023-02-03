import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/app_localizations.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/spinners/gcw_double_spinner.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_twooptions_switch.dart';
import 'package:gc_wizard/tools/science_and_technology/apparent_temperature/windchill/logic/windchill.dart';
import 'package:gc_wizard/tools/science_and_technology/unit_converter/logic/temperature.dart';
import 'package:gc_wizard/tools/science_and_technology/unit_converter/logic/velocity.dart';
import 'package:intl/intl.dart';

class Windchill extends StatefulWidget {
  @override
  WindchillState createState() => WindchillState();
}

class WindchillState extends State<Windchill> {
  double _currentTemperature = 0.0;
  double _currentWindSpeed = 0.0;
  GCWSwitchPosition _currentSpeedUnit = GCWSwitchPosition.left;
  var _isMetric = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GCWDoubleSpinner(
            title: i18n(context, 'windchill_temperature'),
            value: _currentTemperature,
            onChanged: (value) {
              setState(() {
                _currentTemperature = value;
              });
            }),
        GCWDoubleSpinner(
            title: i18n(context, 'windchill_windspeed'),
            value: _currentWindSpeed,
            min: 0.0,
            onChanged: (value) {
              setState(() {
                _currentWindSpeed = value;
              });
            }),
        GCWTwoOptionsSwitch(
          title: i18n(context, 'windchill_system'),
          leftValue: i18n(context, 'windchill_metric'),
          rightValue: i18n(context, 'windchill_imperial'),
          value: _isMetric ? GCWSwitchPosition.left : GCWSwitchPosition.right,
          onChanged: (value) {
            setState(() {
              _isMetric = value == GCWSwitchPosition.left;
            });
          },
        ),
        _isMetric
            ? GCWTwoOptionsSwitch(
                title: i18n(context, 'windchill_metricunit'),
                leftValue: VELOCITY_KMH.symbol,
                rightValue: VELOCITY_MS.symbol,
                value: _currentSpeedUnit,
                onChanged: (value) {
                  setState(() {
                    _currentSpeedUnit = value;
                  });
                },
              )
            : Container(),
        GCWDefaultOutput(child: _buildOutput())
      ],
    );
  }

  _buildOutput() {
    var windchill;
    var temperature;

    if (_isMetric) {
      windchill = _currentSpeedUnit == GCWSwitchPosition.left
          ? calcWindchillMetric(_currentTemperature, _currentWindSpeed)
          : calcWindchillMetricMS(_currentTemperature, _currentWindSpeed);

      temperature = TEMPERATURE_CELSIUS;
    } else {
      windchill = calcWindchillImperial(_currentTemperature, _currentWindSpeed);
      temperature = TEMPERATURE_FAHRENHEIT;
    }

    return '${NumberFormat('#.###').format(windchill)} ${temperature.symbol}';
  }
}
