import 'package:flutter/material.dart';
import 'package:gc_wizard/i18n/app_localizations.dart';
import 'package:gc_wizard/logic/tools/science_and_technology/numeral_bases.dart';
import 'package:gc_wizard/widgets/common/base/gcw_textfield.dart';
import 'package:gc_wizard/widgets/common/gcw_default_output.dart';
import 'package:gc_wizard/widgets/common/gcw_numeralbase_spinner.dart';
import 'package:gc_wizard/widgets/common/gcw_text_divider.dart';
import 'package:gc_wizard/widgets/common/gcw_twooptions_switch.dart';
import 'package:gc_wizard/widgets/utils/common_widget_utils.dart';

List<int> _COMMON_BASES = [2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,60];

class NumeralBases extends StatefulWidget {
  @override
  NumeralBasesState createState() => NumeralBasesState();
}

class NumeralBasesState extends State<NumeralBases> {
  var _controller;

  String _currentInput = '';
  int _currentFromKey = 16;
  int _currentToKey = 10;

  var _currentToMode = GCWSwitchPosition.left;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
        text: _currentInput
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GCWTextField(
          controller: _controller,
          onChanged: (text) {
            setState(() {
              _currentInput = text;
            });
          },
        ),
        GCWTextDivider(
          text: i18n(context, 'numeralbases_from')
        ),
        GCWNumeralBaseSpinner(
          value: _currentFromKey,
          onChanged: (value) {
            setState(() {
              _currentFromKey = value;
            });
          },
        ),GCWTextDivider(
          text: i18n(context, 'numeralbases_to')
        ),
        GCWTwoOptionsSwitch(
          leftValue: i18n(context, 'numeralbases_showfrequent'),
          rightValue: i18n(context, 'numeralbases_chooseoutput'),
          value: _currentToMode,
          onChanged: (value) {
            setState(() {
              _currentToMode = value;
            });
          },
        ),
        _currentToMode == GCWSwitchPosition.right
          ? GCWNumeralBaseSpinner(
              value: _currentToKey,
              onChanged: (value) {
                setState(() {
                  _currentToKey = value;
                });
              },
            )
          : Container(),
        _buildOutput(context)
      ],
    );
  }

  _buildOutput(BuildContext context) {

    if (_currentInput == null || _currentInput.length == 0) {
      return GCWDefaultOutput();
    }

    var calculateableToBases = _currentToMode == GCWSwitchPosition.left ? _COMMON_BASES : [_currentToKey];
    List<String> values = calculateableToBases.map((toBase) {
      return _currentInput
        .split(' ')
        .where((element) => element.length > 0)
        .map((value) {
          if (value.startsWith('-') && _currentFromKey < 0) {
            return i18n(context, 'common_notdefined');
          }

          //TODO: React on exceptions
          var testValidInput = convertBase(value, _currentFromKey, 2);
          if (testValidInput == null || testValidInput.length == 0) {
            return i18n(context, 'common_notdefined');
          }

          return convertBase(value, _currentFromKey, toBase);
        })
        .join(' ');
    }).toList();

    if (_currentToMode == GCWSwitchPosition.right) {
      return GCWDefaultOutput(
        child: values.join('')
      );
    } else {
      List<List<dynamic>> outputValues = [];
      for (int i = 0; i < values.length; i++) {
        outputValues.add([calculateableToBases[i], values[i]]);
      }

      var rows = columnedMultiLineOutput(context, outputValues, flexValues: [1,3]);
      rows.insert(0,
        GCWTextDivider(
          text: i18n(context, 'common_output')
        )
      );

      return Column(
        children: rows
      );
    }
  }
}