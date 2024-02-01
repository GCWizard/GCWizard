import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/application/theme/theme.dart';
import 'package:gc_wizard/common_widgets/dividers/gcw_text_divider.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_output_text.dart';
import 'package:gc_wizard/common_widgets/spinners/gcw_dropdown_spinner.dart';
import 'package:gc_wizard/common_widgets/spinners/gcw_integer_spinner.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_twooptions_switch.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/affine/logic/affine.dart';

class Affine extends StatefulWidget {
  const Affine({Key? key}) : super(key: key);

  @override
  _AffineState createState() => _AffineState();
}

class _AffineState extends State<Affine> {
  late TextEditingController _encodeController;
  late TextEditingController _decodeController;

  var _currentEncodeInput = '';
  var _currentDecodeInput = '';

  GCWSwitchPosition _currentMode = GCWSwitchPosition.right;

  int _currentKeyAIndex = 0;
  int _currentKeyBIndex = 0;

  final aKeys = [1, 3, 5, 7, 9, 11, 15, 17, 19, 21, 25];
  final bKeys = List<int>.generate(26, (index) => index);

  @override
  void initState() {
    super.initState();
    _encodeController = TextEditingController(text: _currentEncodeInput);
    _decodeController = TextEditingController(text: _currentDecodeInput);
  }

  @override
  void dispose() {
    _encodeController.dispose();
    _decodeController.dispose();
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
        _currentMode == GCWSwitchPosition.left
            ? GCWTextField(
                controller: _encodeController,
                onChanged: (text) {
                  setState(() {
                    _currentEncodeInput = text;
                  });
                },
              )
            : GCWTextField(
                controller: _decodeController,
                onChanged: (text) {
                  setState(() {
                    _currentDecodeInput = text;
                  });
                },
              ),
        GCWDropDownSpinner(
          title: i18n(context, 'affine_key_a'),
          index: _currentKeyAIndex,
          items: aKeys.map((item) => Text(item.toString(), style: gcwTextStyle())).toList(),
          onChanged: (value) {
            setState(() {
              _currentKeyAIndex = value;
            });
          },
        ),
        GCWIntegerSpinner(
          title: i18n(context, 'affine_key_b'),
          min: 0,
          max: 25,
          value: _currentKeyBIndex,
          onChanged: (value) {
            setState(() {
              _currentKeyBIndex = value;
            });
          },
        ),
        GCWTextDivider(text: i18n(context, 'common_output')),
        _buildOutput(context)
      ],
    );
  }

  Widget _buildOutput(BuildContext context) {
    var output = '';
    var keyA = aKeys[_currentKeyAIndex];
    var keyB = bKeys[_currentKeyBIndex];

    if (_currentMode == GCWSwitchPosition.left) {
      output = encodeAffine(_currentEncodeInput, keyA, keyB);
    } else {
      output = decodeAffine(_currentDecodeInput, keyA, keyB);
    }

    return GCWOutputText(
      text: output,
    );
  }
}
