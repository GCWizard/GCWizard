import 'package:flutter/material.dart';
import 'package:gc_wizard/application/theme/theme.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_dropdown.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_output_text.dart';
import 'package:gc_wizard/common_widgets/spinners/gcw_integer_spinner.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_twooptions_switch.dart';
import 'package:gc_wizard/tools/science_and_technology/alphabet_number_systems/_common/logic/alphabet_number_systems.dart';

abstract class AbstractAlphabetNumberSystem extends StatefulWidget {
  final ALPHABET_NUMBER_SYSTEMS alphabetNumberSystem;

  const AbstractAlphabetNumberSystem({
    Key? key,
    required this.alphabetNumberSystem,
  }) : super(key: key);

  @override
  _AbstractAlphabetNumberSystemState createState() => _AbstractAlphabetNumberSystemState();
}

class _AbstractAlphabetNumberSystemState extends State<AbstractAlphabetNumberSystem> {
  int _currentNumber = 0;

  int _currentNumberHundred = 0;
  int _currentNumberTen = 0;
  int _currentNumberOne = 0;

  GCWSwitchPosition _currentMode = GCWSwitchPosition.right;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GCWTwoOptionsSwitch(
          value: _currentMode,
          onChanged: (value) {
            setState(() {
              _currentMode = value;
            });
          },
        ),
        if (_currentMode == GCWSwitchPosition.right) // decode
          Row(children: <Widget>[
            Expanded(
                flex: 1,
                child: Container(
                  padding: const EdgeInsets.only(right: DOUBLE_DEFAULT_MARGIN),
                  child: GCWDropDown<int>(
                    value: _currentNumberHundred,
                    onChanged: (value) {
                      setState(() {
                        _currentNumberHundred = value;
                      });
                    },
                    items: AlphabetNumberSystemsDropwdownList(widget.alphabetNumberSystem, 100),
                  ),
                )),
            Expanded(
              flex: 1,
              child: Container(
                padding: const EdgeInsets.only(left: DOUBLE_DEFAULT_MARGIN, right: DOUBLE_DEFAULT_MARGIN),
                child: GCWDropDown<int>(
                  value: _currentNumberTen,
                  onChanged: (value) {
                    setState(() {
                      _currentNumberTen = value;
                    });
                  },
                  items: AlphabetNumberSystemsDropwdownList(widget.alphabetNumberSystem, 10),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                padding: const EdgeInsets.only(left: DOUBLE_DEFAULT_MARGIN),
                child: GCWDropDown<int>(
                  value: _currentNumberOne,
                  onChanged: (value) {
                    setState(() {
                      _currentNumberOne = value;
                    });
                  },
                  items: AlphabetNumberSystemsDropwdownList(widget.alphabetNumberSystem, 1),
                ),
              ),
            ),
          ]),
        if (_currentMode == GCWSwitchPosition.left) // encode
          GCWIntegerSpinner(
            min: 1,
            max: 999,
            value: _currentNumber,
            onChanged: (value) {
              setState(() {
                _currentNumber = value;
              });
            },
          ),
        _buildOutput(context)
      ],
    );
  }

  Widget _buildOutputEncode(BuildContext context) {
    return GCWDefaultOutput(
        child: Column(children: <Widget>[
      Column(
        children: <Widget>[
          GCWOutputText(
            text: encodeNumberToNumeralWord(_currentNumber, widget.alphabetNumberSystem),
          ),
        ],
      ),
    ]));
  }

  Widget _buildOutputDecode(BuildContext context) {
    return GCWDefaultOutput(
        child: Column(children: <Widget>[
      GCWOutputText(
        text: decodeNumeralWordToNumber((_currentNumberHundred ~/ 100).toString() +
            (_currentNumberTen ~/ 10).toString() +
            _currentNumberOne.toString()),
      ),
    ]));
  }

  Widget _buildOutput(BuildContext context) {
    if (_currentMode == GCWSwitchPosition.right) {
      return _buildOutputDecode(context);
    } else {
      return _buildOutputEncode(context);
    }
  }
}
