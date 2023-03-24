import 'package:flutter/material.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_twooptions_switch.dart';
import 'package:gc_wizard/common_widgets/text_input_formatters/gcw_onlydigitsandspace_textinputformatter.dart';
import 'package:gc_wizard/common_widgets/text_input_formatters/gcw_onlyhexdigitsandspace_textinputformatter.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/tools/science_and_technology/numeral_bases/logic/numeral_bases.dart';

class Hexadecimal extends StatefulWidget {
  const Hexadecimal({Key? key}) : super(key: key);

  @override
  HexadecimalState createState() => HexadecimalState();
}

class HexadecimalState extends State<Hexadecimal> {
  var _currentDecimalValue = '';
  var _currentHexValue = '';
  late TextEditingController _hexController;
  late TextEditingController _decimalController;

  GCWSwitchPosition _currentMode = GCWSwitchPosition.right;

  @override
  void initState() {
    super.initState();
    _hexController = TextEditingController(text: _currentHexValue);
    _decimalController = TextEditingController(text: _currentDecimalValue);
  }

  @override
  void dispose() {
    _hexController.dispose();
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
                inputFormatters: [GCWOnlyHexDigitsAndSpaceInputFormatter()],
                controller: _hexController,
                onChanged: (value) {
                  setState(() {
                    _currentHexValue = value;
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
        GCWDefaultOutput(child: _buildOutput())
      ],
    );
  }

  String _buildOutput() {
    if (_currentMode == GCWSwitchPosition.left) {
      return _currentDecimalValue.split(' ').map((value) => convertBase(value, 10, 16)).join(' ');
    } else {
      return _currentHexValue.split(' ').map((value) => convertBase(value, 16, 10)).join(' ');
    }
  }
}
