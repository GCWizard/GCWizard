import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/application/theme/theme.dart';
import 'package:gc_wizard/common_widgets/gcw_expandable.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_output_text.dart';
import 'package:gc_wizard/common_widgets/spinners/gcw_integer_spinner.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_twooptions_switch.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/hill/logic/hill.dart';
import 'package:gc_wizard/utils/complex_return_types.dart';

class Hill extends StatefulWidget {
  const Hill({Key? key}) : super(key: key);

  @override
  HillState createState() => HillState();
}

class HillState extends State<Hill> {
  late TextEditingController _encodeController;
  late TextEditingController _encodeKeyController;
  late TextEditingController _decodeController;
  late TextEditingController _decodeKeyController;
  late TextEditingController _alphabetController;
  late TextEditingController _fillCharacterController;

  var _currentEncodeInput = '';
  var _currentEncodeKey = '';
  var _currentDecodeInput = '';
  var _currentDecodeKey = '';
  var _currentAlphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  var _currentFillCharacter = 'X';
  var _currentMatrixSize = 2;

  GCWSwitchPosition _currentMode = GCWSwitchPosition.right;


  @override
  void initState() {
    super.initState();
    _encodeController = TextEditingController(text: _currentEncodeInput);
    _encodeKeyController = TextEditingController(text: _currentEncodeKey);
    _decodeController = TextEditingController(text: _currentDecodeInput);
    _decodeKeyController = TextEditingController(text: _currentDecodeKey);
    _alphabetController = TextEditingController(text: _currentAlphabet);
    _fillCharacterController = TextEditingController(text: _currentFillCharacter);
  }

  @override
  void dispose() {
    _encodeController.dispose();
    _encodeKeyController.dispose();
    _decodeController.dispose();
    _decodeKeyController.dispose();
    _alphabetController.dispose();
    _fillCharacterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _currentMode == GCWSwitchPosition.right
            ? _buildDecodeInput()
            : _buildEncodeInput() ,
        GCWTwoOptionsSwitch(
          value: _currentMode,
          onChanged: (value) {
            setState(() {
              _currentMode = value;
            });
          },
        ),
        _buildOptions(),
        _buildOutput()
      ],
    );
  }

  Widget _buildDecodeInput() {
    return Column(
      children: <Widget>[
        GCWTextField(
          controller: _decodeController,
          onChanged: (text) {
            setState(() {
              _currentDecodeInput = text;
            });
          },
        ),
        GCWTextField(
          controller: _decodeKeyController,
          hintText: i18n(context, 'common_key'),
          onChanged: (text) {
            setState(() {
              _currentDecodeKey = text;
            });
          },
        ),
    ]);
  }

  Widget _buildEncodeInput() {
    return Column(
      children: <Widget>[
        GCWTextField(
          controller: _encodeController,
          onChanged: (text) {
            setState(() {
              _currentEncodeInput = text;
            });
          },
        ),
        GCWTextField(
          controller: _encodeKeyController,
          hintText: i18n(context, 'common_key'),
          onChanged: (text) {
            setState(() {
              _currentEncodeKey = text;
            });
          },
        ),

        ]);
  }

  Widget _buildOptions() {
    return GCWExpandableTextDivider(
      text: i18n(context, 'common_options'),
      expanded: false,
      child: Column(
        children: [
          GCWTextField(
            title: i18n(context, 'common_alphabet'),
            controller: _alphabetController,
            flexValues: const [2, 3],
            onChanged: (value) {
              setState(() {
                _currentAlphabet = value;
              });
            },
          ),
          GCWIntegerSpinner(
            title: i18n(context, 'hill_matrix_size'),
            value: _currentMatrixSize,
            flexValues: const [2, 3],
            overflow: SpinnerOverflowType.SUPPRESS_OVERFLOW,
            min: 2,
            max: 10,
            onChanged: (value) {
              setState(() {
                _currentMatrixSize = value;
               });
            },
          ),
          GCWTextField(
            title: i18n(context, 'hill_fill_character'),
            controller: _fillCharacterController,
            flexValues: const [2, 3],
            maxLength: 1,
            onChanged: (value) {
              setState(() {
                _currentFillCharacter = value;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildOutput() {
    StringText result;
    String matrix;
    var _alphabet = buildAlphabet(_currentAlphabet);

    if (_currentMode == GCWSwitchPosition.right) {
      result = decryptText(_currentDecodeInput, _currentDecodeKey, _currentMatrixSize, _alphabet, _currentFillCharacter);
      matrix = getViewKeyMatrix(_currentDecodeKey, _currentMatrixSize, _alphabet);
    } else {
      result = encryptText(_currentEncodeInput, _currentEncodeKey, _currentMatrixSize, _alphabet, _currentFillCharacter);
      matrix = getViewKeyMatrix(_currentEncodeKey, _currentMatrixSize, _alphabet);
    }

    var errorText = result.text;
    if (errorText.isNotEmpty) {
      errorText = i18n(context, 'hill_' + errorText.toLowerCase(), ifTranslationNotExists: errorText);
      if (_currentMode == GCWSwitchPosition.left && errorText == 'invalidkeymatrix') {
        errorText = '\n' + i18n(context, 'hill_invalidkeymatrix_hint');
      }
    }

    var __alphabet = getViewAlphabet(_alphabet);

    final textSpan = TextSpan(
      text: __alphabet,
      style: gcwMonotypeTextStyle(),
    );
    final tp = TextPainter(text: textSpan, textDirection: TextDirection.ltr);
    tp.layout();

    return Column(
        children: <Widget>[
          GCWDefaultOutput(child: result.value),
          errorText.isEmpty ? Container() : GCWOutput(child: errorText),
          GCWOutput(
            title: 'Matrix',
            child: GCWOutputText(
              text: matrix,
              isMonotype: true)
          ),
          GCWOutput(
            title: i18n(context, 'common_alphabet'),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width: tp.width + 45,
                  child: GCWOutputText(
                    text: __alphabet,
                    isMonotype: true)
                ),
              )
            ),
        ]
    );
  }
}
