import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/spinners/gcw_integer_spinner.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_twooptions_switch.dart';
import 'package:gc_wizard/common_widgets/text_input_formatters/gcw_only01andspace_textinputformatter.dart';
import 'package:gc_wizard/common_widgets/text_input_formatters/gcw_onlydigitsandspace_textinputformatter.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/tools/science_and_technology/numeral_bases/logic/numeral_bases.dart';

class Binary extends StatefulWidget {
  const Binary({Key? key}) : super(key: key);

  @override
  _BinaryState createState() => _BinaryState();
}

class _BinaryState extends State<Binary> {
  var _currentDecimalValue = '';
  var _currentBinaryValue = '';
  late TextEditingController _binaryController;
  late TextEditingController _decimalController;

  int _lengthBinary = 8;

  GCWSwitchPosition _currentMode = GCWSwitchPosition.right;

  @override
  void initState() {
    super.initState();
    _binaryController = TextEditingController(text: _currentBinaryValue);
    _decimalController = TextEditingController(text: _currentDecimalValue);
  }

  @override
  void dispose() {
    _binaryController.dispose();
    _decimalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _currentMode == GCWSwitchPosition.left
            ? GCWTextField(
                inputFormatters: [GCWOnlyDigitsAndSpaceInputFormatter()],
                controller: _decimalController,
                onChanged: (value) {
                  setState(() {
                    _currentDecimalValue = value;
                  });
                },
              )
            : GCWTextField(
                inputFormatters: [GCWOnly01AndSpaceInputFormatter()],
                controller: _binaryController,
                onChanged: (value) {
                  setState(() {
                    _currentBinaryValue = value;
                  });
                },
              ),
        GCWTwoOptionsSwitch(
          value: _currentMode,
          onChanged: (value) {
            setState(() {
              _currentMode = value;
            });
          },
        ),
        _currentMode == GCWSwitchPosition.left
            ? GCWIntegerSpinner(
                title: i18n(context, 'binary_length'),
                onChanged: (int value) {
                  setState(() {
                    _lengthBinary = value;
                  });
                },
                value: _lengthBinary)
            : Container(),
        GCWDefaultOutput(child: _buildOutput())
      ],
    );
  }

  String _buildOutput() {
    if (_currentMode == GCWSwitchPosition.left) {
      return _currentDecimalValue
          .split(' ')
          .map((value) => _padLeftZero(_lengthBinary, convertBase(value, 10, 2)))
          .join(' ');
    } else {
      return _currentBinaryValue.split(' ').map((value) => convertBase(value, 2, 10)).join(' ');
    }
  }

  String _padLeftZero(int length, String text) {
    return text.padLeft(length, '0');
  }
}
