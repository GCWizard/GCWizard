import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/common_widgets/dividers/gcw_text_divider.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_output_text.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_twooptions_switch.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/tools/science_and_technology/ieee754/logic/ieee754.dart';

class IEEE754 extends StatefulWidget {
  const IEEE754({Key? key}) : super(key: key);

  @override
  _IEEE754State createState() => _IEEE754State();
}

class _IEEE754State extends State<IEEE754> {
  late TextEditingController _encodeController;
  late TextEditingController _decodeController;

  String _currentEncodeInput = '';
  String _currentDecodeInput = '';

  GCWSwitchPosition _currentMode = GCWSwitchPosition.right;
  GCWSwitchPosition _currentBitMode = GCWSwitchPosition.right;

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
            ? GCWTwoOptionsSwitch(
          leftValue: '32',
          rightValue: '64',
          value: _currentBitMode,
          onChanged: (value) {
            setState(() {
              _currentBitMode = value;
            });
          },
        )
            : Container(),
        _currentMode == GCWSwitchPosition.left
            ? GCWTextField(
          controller: _encodeController,
          inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9-+.,]')),],
          onChanged: (text) {
            setState(() {
              _currentEncodeInput = text;
            });
          },
        )
            : GCWTextField(
          controller: _decodeController,
          inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[01]')),],
          onChanged: (text) {
            setState(() {
              _currentDecodeInput = text;
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

    if (_currentMode == GCWSwitchPosition.left) {
      output = encodeIEEE754(_currentEncodeInput, _currentBitMode == GCWSwitchPosition.left);
    } else {
      output = decodeIEEE754(_currentDecodeInput);
    }

    return GCWOutputText(
      text: output,
    );
  }
}
