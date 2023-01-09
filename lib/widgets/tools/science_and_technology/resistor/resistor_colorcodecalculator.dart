import 'package:flutter/material.dart';
import 'package:gc_wizard/i18n/app_localizations.dart';
import 'package:gc_wizard/logic/tools/science_and_technology/resistor.dart';
import 'package:gc_wizard/theme/theme.dart';
import 'package:gc_wizard/widgets/common/gcw_columned_multiline_output.dart';
import 'package:gc_wizard/widgets/common/gcw_integer_spinner.dart';
import 'package:gc_wizard/widgets/common/gcw_text_divider.dart';
import 'package:gc_wizard/widgets/tools/science_and_technology/resistor/gcw_resistor_band_dropdownbutton.dart';
import 'package:gc_wizard/widgets/tools/science_and_technology/resistor/resistor_formatter.dart';

class ResistorColorCodeCalculator extends StatefulWidget {
  @override
  ResistorColorCodeCalculatorState createState() => ResistorColorCodeCalculatorState();
}

// TODO:
// Avoid hard-coding all 8 different band dropdown menus.
// Why was it done here?
// Problem: Switching from 4 band to 5 band (and vice-versa). If current state is 4 bands,
// including the 3 band (in that case the multiplier) has special colors (pink, silver, gold)
// Now switching to 5 bands: The new third band is a regular band, which cannot get the special color
// So, the new dropdown gives error: NO SUCH VALUE.
// Tried to rebuild all bands regarding the number of bands. But it came out, that Flutter
// hasn't rebuild all dropdownbuttons but only added/removed one from the end of the list.
// So it was not possible to completely remove all dropdowns and their internal states and add all new
// which kept an old state somewhere internally - no matter what I tried.
class ResistorColorCodeCalculatorState extends State<ResistorColorCodeCalculator> {
  var _currentNumberBands = 3;
  var _changed = false;

  var _resistorBandDropDownButton_fourBands_first;
  var _resistorBandDropDownButton_fourBands_second;
  var _resistorBandDropDownButton_fourBands_multiplier;
  var _resistorBandDropDownButton_fourBands_tolerance;
  var _resistorBandDropDownButton_sixBands_first;
  var _resistorBandDropDownButton_sixBands_second;
  var _resistorBandDropDownButton_sixBands_third;
  var _resistorBandDropDownButton_sixBands_multiplier;
  var _resistorBandDropDownButton_sixBands_tolerance;
  var _resistorBandDropDownButton_sixBands_temperatureCoefficient;

  ResistorBandColor _currentResistorColor_fourBands_first = defaultResistorBandColor;
  ResistorBandColor _currentResistorColor_fourBands_second = defaultResistorBandColor;
  ResistorBandColor _currentResistorColor_fourBands_multiplier = defaultResistorBandColor;
  ResistorBandColor _currentResistorColor_fourBands_tolerance = defaultResistorBandColor;
  ResistorBandColor _currentResistorColor_sixBands_first = defaultResistorBandColor;
  ResistorBandColor _currentResistorColor_sixBands_second = defaultResistorBandColor;
  ResistorBandColor _currentResistorColor_sixBands_third = defaultResistorBandColor;
  ResistorBandColor _currentResistorColor_sixBands_multiplier = defaultResistorBandColor;
  ResistorBandColor _currentResistorColor_sixBands_tolerance = defaultResistorBandColor;
  ResistorBandColor _currentResistorColor_sixBands_temperatureCoefficient = defaultResistorBandColor;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _buildResistors();

    return Column(
      children: <Widget>[
        Container(
          child: GCWIntegerSpinner(
            title: i18n(context, 'resistor_colorcodecalculator_numberbands'),
            min: 3,
            max: 6,
            value: _currentNumberBands,
            onChanged: (value) {
              setState(() {
                _currentNumberBands = value;

                _changed = !_changed;
              });
            },
          ),
          padding: EdgeInsets.only(bottom: 10.0),
        ),
        [3, 4].contains(_currentNumberBands) ? _resistorBandDropDownButton_fourBands_first : Container(),
        [3, 4].contains(_currentNumberBands) ? _resistorBandDropDownButton_fourBands_second : Container(),
        [3, 4].contains(_currentNumberBands) ? _resistorBandDropDownButton_fourBands_multiplier : Container(),
        [4].contains(_currentNumberBands) ? _resistorBandDropDownButton_fourBands_tolerance : Container(),
        [5, 6].contains(_currentNumberBands) ? _resistorBandDropDownButton_sixBands_first : Container(),
        [5, 6].contains(_currentNumberBands) ? _resistorBandDropDownButton_sixBands_second : Container(),
        [5, 6].contains(_currentNumberBands) ? _resistorBandDropDownButton_sixBands_third : Container(),
        [5, 6].contains(_currentNumberBands) ? _resistorBandDropDownButton_sixBands_multiplier : Container(),
        [5, 6].contains(_currentNumberBands) ? _resistorBandDropDownButton_sixBands_tolerance : Container(),
        [6].contains(_currentNumberBands) ? _resistorBandDropDownButton_sixBands_temperatureCoefficient : Container(),
        _buildOutput()
      ],
    );
  }

  _buildResistors() {
    _resistorBandDropDownButton_fourBands_first = GCWResistorBandDropDownButton(
      color: _currentResistorColor_fourBands_first,
      type: ResistorBandType.FIRST,
      numberBands: 4,
      onChanged: (color) {
        setState(() {
          _currentResistorColor_fourBands_first = color;
        });
      },
    );

    _resistorBandDropDownButton_fourBands_second = GCWResistorBandDropDownButton(
      color: _currentResistorColor_fourBands_second,
      type: ResistorBandType.SECOND,
      numberBands: 4,
      onChanged: (color) {
        setState(() {
          _currentResistorColor_fourBands_second = color;
        });
      },
    );

    _resistorBandDropDownButton_fourBands_multiplier = GCWResistorBandDropDownButton(
      color: _currentResistorColor_fourBands_multiplier,
      type: ResistorBandType.MULTIPLIER,
      numberBands: 4,
      onChanged: (color) {
        setState(() {
          _currentResistorColor_fourBands_multiplier = color;
        });
      },
    );

    _resistorBandDropDownButton_fourBands_tolerance = GCWResistorBandDropDownButton(
      color: _currentResistorColor_fourBands_tolerance,
      type: ResistorBandType.TOLERANCE,
      numberBands: 4,
      onChanged: (color) {
        setState(() {
          _currentResistorColor_fourBands_tolerance = color;
        });
      },
    );

    _resistorBandDropDownButton_sixBands_first = GCWResistorBandDropDownButton(
      color: _currentResistorColor_sixBands_first,
      type: ResistorBandType.FIRST,
      numberBands: 6,
      onChanged: (color) {
        setState(() {
          _currentResistorColor_sixBands_first = color;
        });
      },
    );

    _resistorBandDropDownButton_sixBands_second = GCWResistorBandDropDownButton(
      color: _currentResistorColor_sixBands_second,
      type: ResistorBandType.SECOND,
      numberBands: 6,
      onChanged: (color) {
        setState(() {
          _currentResistorColor_sixBands_second = color;
        });
      },
    );

    _resistorBandDropDownButton_sixBands_third = GCWResistorBandDropDownButton(
      color: _currentResistorColor_sixBands_third,
      type: ResistorBandType.THIRD,
      numberBands: 6,
      onChanged: (color) {
        setState(() {
          _currentResistorColor_sixBands_third = color;
        });
      },
    );

    _resistorBandDropDownButton_sixBands_multiplier = GCWResistorBandDropDownButton(
      color: _currentResistorColor_sixBands_multiplier,
      type: ResistorBandType.MULTIPLIER,
      numberBands: 6,
      onChanged: (color) {
        setState(() {
          _currentResistorColor_sixBands_multiplier = color;
        });
      },
    );

    _resistorBandDropDownButton_sixBands_tolerance = GCWResistorBandDropDownButton(
      color: _currentResistorColor_sixBands_tolerance,
      type: ResistorBandType.TOLERANCE,
      numberBands: 6,
      onChanged: (color) {
        setState(() {
          _currentResistorColor_sixBands_tolerance = color;
        });
      },
    );

    _resistorBandDropDownButton_sixBands_temperatureCoefficient = GCWResistorBandDropDownButton(
      color: _currentResistorColor_sixBands_temperatureCoefficient,
      type: ResistorBandType.TEMPERATURE_COEFFICIENT,
      numberBands: 6,
      onChanged: (color) {
        setState(() {
          _currentResistorColor_sixBands_temperatureCoefficient = color;
        });
      },
    );
  }

  Widget _buildOutput() {
    var outputs = [[]];

    ResistorValue resistorValue;

    List<ResistorBandColor> colors;
    switch (_currentNumberBands) {
      case 3:
        colors = [
          _currentResistorColor_fourBands_first,
          _currentResistorColor_fourBands_second,
          _currentResistorColor_fourBands_multiplier
        ];
        break;
      case 4:
        colors = [
          _currentResistorColor_fourBands_first,
          _currentResistorColor_fourBands_second,
          _currentResistorColor_fourBands_multiplier,
          _currentResistorColor_fourBands_tolerance
        ];
        break;
      case 5:
        colors = [
          _currentResistorColor_sixBands_first,
          _currentResistorColor_sixBands_second,
          _currentResistorColor_sixBands_third,
          _currentResistorColor_sixBands_multiplier,
          _currentResistorColor_sixBands_tolerance
        ];
        break;
      case 6:
        colors = [
          _currentResistorColor_sixBands_first,
          _currentResistorColor_sixBands_second,
          _currentResistorColor_sixBands_third,
          _currentResistorColor_sixBands_multiplier,
          _currentResistorColor_sixBands_tolerance,
          _currentResistorColor_sixBands_temperatureCoefficient,
        ];
        break;
    }

    resistorValue = getResistorValue(colors);
    if (resistorValue.value != null) {
      outputs = [
        [
          i18n(context, 'resistor_value'),
          formatResistorValue(resistorValue.value) + ' ' + formatResistorTolerance(resistorValue.tolerance)
        ],
        [
          i18n(context, 'resistor_value_range'),
          formatResistorTolerancedValueInterval(resistorValue.tolerancedValueInterval)
        ],
        resistorValue.temperatureCoefficient != null
            ? [
                i18n(context, 'resistor_temperaturecoefficient'),
                formatResistorTemperatureCoefficient(resistorValue.temperatureCoefficient, gcwTextStyle())
              ]
            : null
      ];
    }

    return GCWColumnedMultilineOutput(
        firstRows: [GCWTextDivider(text: i18n(context, 'common_output'))],
        data: outputs,
        flexValues: [2, 3]
    );
  }
}
