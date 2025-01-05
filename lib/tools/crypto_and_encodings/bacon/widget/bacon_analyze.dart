import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/application/theme/theme.dart';
import 'package:gc_wizard/common_widgets/dividers/gcw_text_divider.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_output.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_onoff_switch.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_twooptions_switch.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/bacon/logic/bacon.dart';

class BaconAnalyze extends StatefulWidget {
  const BaconAnalyze({Key? key}) : super(key: key);

  @override
  _BaconAnalyzeState createState() => _BaconAnalyzeState();
}

class _BaconAnalyzeState extends State<BaconAnalyze> {
  late TextEditingController _controller;

  var _currentInput = '';
  GCWSwitchPosition _currentIJUVVersion = GCWSwitchPosition.left;
  bool _inversMode = false;
  bool _analyzeText = false;

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
            });
          },
        ),
        GCWTwoOptionsSwitch(
          value: _currentIJUVVersion,
          leftValue: 'I=J, U=V',
          rightValue: 'I, J, U, V',
          onChanged: (value) {
            setState(() {
              _currentIJUVVersion = value;
            });
          },
        ),
        GCWOnOffSwitch(
          title: 'AAAAB → BBBBA',
          value: _inversMode,
          onChanged: (value) {
            setState(() {
              _inversMode = value;
            });
          },
        ),
        _buildOutput()
      ],
    );
  }

  Widget _buildOutput() {
    var type = _currentIJUVVersion == GCWSwitchPosition.left
        ? BaconType.ORIGINAL
        : BaconType.FULL;
    Widget outputWidget;

    _analyzeText = _testText(_currentInput);

    String _inputWordwiseUpperLower =
        analyzeBaconCodeWordwiseUpperLowerCase(_currentInput);
    String _inputWordwiseAlphabet =
        analyzeBaconCodeWordwiseAlphabet(_currentInput);
    String _inputLetterwiseUpperLower =
        analyzeBaconCodeLetterwiseUpperLowerCase(_currentInput);
    String _inputLetterwiseAlphabet =
        analyzeBaconCodeLetterwiseAlphabet(_currentInput);

    if (_analyzeText) {
      outputWidget = Column(
        children: [
          GCWTextDivider(
            text: i18n(context, 'bacon_analyze_wordwise'),
            suppressBottomSpace: true,
          ),
          GCWTextDivider(
            text: i18n(context, 'bacon_analyze_casesensitive'),
          ),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.only(right: DOUBLE_DEFAULT_MARGIN),
                  child: Text(i18n(context, 'bacon_bacon')),
                ),
              ),
              Expanded(
                flex: 5,
                child: Padding(
                  padding: const EdgeInsets.only(right: DOUBLE_DEFAULT_MARGIN),
                  child: GCWOutput(child: _inputWordwiseUpperLower),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.only(right: DOUBLE_DEFAULT_MARGIN),
                  child: Text(i18n(context, 'bacon_plain')),
                ),
              ),
              Expanded(
                flex: 5,
                child: Padding(
                  padding: const EdgeInsets.only(right: DOUBLE_DEFAULT_MARGIN),
                  child: GCWOutput(
                    child: decodeBacon(_inputWordwiseUpperLower,
                        inverse: _inversMode, binary: false, type: type),
                  ),
                ),
              ),
            ],
          ),
          GCWTextDivider(
            text: i18n(context, 'bacon_analyze_alphabet'),
          ),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.only(right: DOUBLE_DEFAULT_MARGIN),
                  child: Text(i18n(context, 'bacon_bacon')),
                ),
              ),
              Expanded(
                flex: 5,
                child: Padding(
                  padding: const EdgeInsets.only(right: DOUBLE_DEFAULT_MARGIN),
                  child: GCWOutput(child: _inputWordwiseAlphabet),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.only(right: DOUBLE_DEFAULT_MARGIN),
                  child: Text(i18n(context, 'bacon_plain')),
                ),
              ),
              Expanded(
                flex: 5,
                child: Padding(
                  padding: const EdgeInsets.only(right: DOUBLE_DEFAULT_MARGIN),
                  child: GCWOutput(
                    child: decodeBacon(_inputWordwiseAlphabet,
                        inverse: _inversMode, binary: false, type: type),
                  ),
                ),
              ),
            ],
          ),
          GCWTextDivider(
            text: i18n(context, 'bacon_analyze_letterwise'),
            suppressBottomSpace: true,
          ),
          GCWTextDivider(
            text: i18n(context, 'bacon_analyze_casesensitive'),
          ),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.only(right: DOUBLE_DEFAULT_MARGIN),
                  child: Text(i18n(context, 'bacon_bacon')),
                ),
              ),
              Expanded(
                flex: 5,
                child: Padding(
                  padding: const EdgeInsets.only(right: DOUBLE_DEFAULT_MARGIN),
                  child: GCWOutput(child: _inputLetterwiseUpperLower),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.only(right: DOUBLE_DEFAULT_MARGIN),
                  child: Text(i18n(context, 'bacon_plain')),
                ),
              ),
              Expanded(
                flex: 5,
                child: Padding(
                  padding: const EdgeInsets.only(right: DOUBLE_DEFAULT_MARGIN),
                  child: GCWOutput(
                    child: decodeBacon(_inputLetterwiseUpperLower,
                        inverse: _inversMode, binary: false, type: type),
                  ),
                ),
              ),
            ],
          ),
          GCWTextDivider(
            text: i18n(context, 'bacon_analyze_alphabet'),
          ),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.only(right: DOUBLE_DEFAULT_MARGIN),
                  child: Text(i18n(context, 'bacon_bacon')),
                ),
              ),
              Expanded(
                flex: 5,
                child: Padding(
                  padding: const EdgeInsets.only(right: DOUBLE_DEFAULT_MARGIN),
                  child: GCWOutput(child: _inputLetterwiseAlphabet),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.only(right: DOUBLE_DEFAULT_MARGIN),
                  child: Text(i18n(context, 'bacon_plain')),
                ),
              ),
              Expanded(
                flex: 5,
                child: Padding(
                  padding: const EdgeInsets.only(right: DOUBLE_DEFAULT_MARGIN),
                  child: GCWOutput(
                    child: decodeBacon(_inputLetterwiseAlphabet,
                        inverse: _inversMode, binary: false, type: type),
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    } else {
      _output = decodeBacon(_currentInput,
          inverse: _inversMode,
          binary: false,
          type: type);
      outputWidget = GCWDefaultOutput(child: _output);
    }

    return outputWidget;
  }

  bool _testText(String code) {
    if ((code.toUpperCase().replaceAll('A', '').replaceAll('B', '') == '') ||
        (code.toUpperCase().replaceAll('0', '').replaceAll('1', '') == '')) {
      return false;
    } else {
      return true;
    }
  }
}
