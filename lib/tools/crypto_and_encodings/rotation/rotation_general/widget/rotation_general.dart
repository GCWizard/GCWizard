import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/app_localizations.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_output.dart';
import 'package:gc_wizard/common_widgets/spinners/gcw_integer_spinner.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/rotation/logic/rotator.dart';
import 'package:gc_wizard/utils/math_utils.dart';

class RotationGeneral extends StatefulWidget {
  const RotationGeneral({Key? key}) : super(key: key);

  @override
  RotationGeneralState createState() => RotationGeneralState();
}

class RotationGeneralState extends State<RotationGeneral> {
  late TextEditingController _controller;

  String _currentInput = '';
  int _currentKey = 0;

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
        GCWIntegerSpinner(
          title: i18n(context, 'common_key'),
          value: _currentKey,
          onChanged: (value) {
            setState(() {
              _currentKey = value;
            });
          },
        ),
        _buildOutput()
      ],
    );
  }

  Widget _buildOutput() {
    if (_currentInput.isEmpty) return const GCWDefaultOutput();

    var reverseKey = modulo(26 - _currentKey, 26).toInt();

    return Column(
      children: [
        GCWDefaultOutput(
          child: Rotator().rotate(_currentInput, _currentKey),
        ),
        GCWOutput(
          title: i18n(context, 'rotation_general_reverse') +
              ' (' +
              i18n(context, 'common_key') +
              ': ' +
              reverseKey.toString() +
              ')',
          child: Rotator().rotate(_currentInput, reverseKey),
        ),
      ],
    );
  }
}
