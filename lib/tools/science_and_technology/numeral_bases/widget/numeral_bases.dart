import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/common_widgets/dividers/gcw_text_divider.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_columned_multiline_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_twooptions_switch.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/tools/science_and_technology/numeral_bases/logic/numeral_bases.dart';
import 'package:gc_wizard/tools/science_and_technology/numeral_bases/widget/numeralbase_spinner.dart';

List<int> _COMMON_BASES = [2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 60];

class NumeralBases extends StatefulWidget {
  const NumeralBases({Key? key}) : super(key: key);

  @override
  _NumeralBasesState createState() => _NumeralBasesState();
}

class _NumeralBasesState extends State<NumeralBases> {
  late TextEditingController _controller;

  String _currentInput = '';
  int _currentFromKey = 16;
  int _currentToKey = 10;

  var _currentToMode = GCWSwitchPosition.left;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: _currentInput);
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
        GCWTextDivider(text: i18n(context, 'numeralbases_from')),
        NumeralBaseSpinner(
          value: _currentFromKey,
          onChanged: (value) {
            setState(() {
              _currentFromKey = value;
            });
          },
        ),
        GCWTextDivider(text: i18n(context, 'numeralbases_to')),
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
            ? NumeralBaseSpinner(
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

  Widget _buildOutput(BuildContext context) {
    if (_currentInput.isEmpty) {
      return const GCWDefaultOutput();
    }

    var calculateableToBases = _currentToMode == GCWSwitchPosition.left ? _COMMON_BASES : [_currentToKey];
    List<String> values = calculateableToBases.map((toBase) {
      return _currentInput.split(RegExp(r'[.,\-;\s]+')).where((element) => element.isNotEmpty).map((value) {
        if (value.startsWith('-') && _currentFromKey < 0) {
          return i18n(context, 'common_notdefined');
        }

        //TODO: React on exceptions
        var testValidInput = convertBase(value, _currentFromKey, 2);
        if (testValidInput.isEmpty) {
          return i18n(context, 'common_notdefined');
        }

        return convertBase(value, _currentFromKey, toBase);
      }).join(' ');
    }).toList();

    if (_currentToMode == GCWSwitchPosition.right) {
      return GCWDefaultOutput(child: values.join(''));
    } else {
      List<List<dynamic>> outputValues = [];
      for (int i = 0; i < values.length; i++) {
        outputValues.add([calculateableToBases[i], values[i]]);
      }

      return GCWColumnedMultilineOutput(
          firstRows: [GCWTextDivider(text: i18n(context, 'common_output'))],
          data: outputValues,
          flexValues: const [1, 3]);
    }
  }
}
