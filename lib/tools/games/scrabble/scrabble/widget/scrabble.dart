import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/app_localizations.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_dropdown.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_twooptions_switch.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/tools/games/scrabble/logic/scrabble_sets.dart';
import 'package:gc_wizard/tools/games/scrabble/scrabble/logic/scrabble.dart';
import 'package:gc_wizard/tools/science_and_technology/cross_sums/widget/crosstotal_output.dart';
import 'package:gc_wizard/tools/science_and_technology/cross_sums/widget/crosstotal_switch.dart';
import 'package:gc_wizard/utils/collection_utils.dart';

class Scrabble extends StatefulWidget {
  const Scrabble({Key? key}) : super(key: key);

  @override
  ScrabbleState createState() => ScrabbleState();
}

class ScrabbleState extends State<Scrabble> {
  late TextEditingController _controller;

  var _currentInput = '';
  var _currentValues = <int>[];
  var _currentScrabbleVersion = scrabbleID_EN;
  GCWSwitchPosition _currentMode = GCWSwitchPosition.left;
  bool _currentCrosstotalMode = true;

  String _output = '';

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
              _calculateOutput();
            });
          },
        ),
        GCWDropDown<String>(
          value: _currentScrabbleVersion,
          onChanged: (String value) {
            setState(() {
              _currentScrabbleVersion = value;
              _calculateOutput();
            });
          },
          items: scrabbleSets.entries.map((set) {
            return GCWDropDownMenuItem(
              value: set.key,
              child: i18n(context, set.value.i18nNameId),
            );
          }).toList(),
        ),
        GCWTwoOptionsSwitch(
          title: i18n(context, 'scrabble_mode'),
          leftValue: i18n(context, 'scrabble_mode_values'),
          rightValue: i18n(context, 'scrabble_mode_frequency'),
          value: _currentMode,
          onChanged: (value) {
            setState(() {
              _currentMode = value;
              _calculateOutput();
            });
          },
        ),
        CrosstotalSwitch(
          onChanged: (value) {
            setState(() {
              _currentCrosstotalMode = value;
              _calculateOutput();
            });
          },
        ),
        GCWDefaultOutput(child: _output),
        _currentCrosstotalMode
            ? CrosstotalOutput(text: _currentInput, values: List<int>.from(_currentValues))
            : Container()
      ],
    );
  }

  void _calculateOutput() {
    if (_currentMode == GCWSwitchPosition.left) {
      _currentValues = scrabbleTextToLetterValues(_currentInput, _currentScrabbleVersion);
    } else {
      _currentValues = scrabbleTextToLetterFrequencies(_currentInput, _currentScrabbleVersion);
    }

    _output = intListToString(_currentValues, delimiter: ' ');
  }
}
