import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/app_localizations.dart';
import 'package:gc_wizard/common_widgets/gcw_text.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/spinners/gcw_integer_spinner.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_twooptions_switch.dart';
import 'package:gc_wizard/common_widgets/text_input_formatters/wrapper_for_masktextinputformatter.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/rail_fence/logic/rail_fence.dart';

class RailFence extends StatefulWidget {
  const RailFence({Key? key}) : super(key: key);

  @override
  RailFenceState createState() => RailFenceState();
}

class RailFenceState extends State<RailFence> {
  String _currentInput = '';
  var _currentKey = 2;
  String _currentPassword = '';
  var _currentOffset = 0;

  var _currentMode = GCWSwitchPosition.right;

  final _maskInputFormatter = WrapperForMaskTextInputFormatter(mask: '#' * 10000, filter: {"#": RegExp(r'[A-Za-z]')});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GCWTextField(
          onChanged: (text) {
            setState(() {
              _currentInput = text;
            });
          },
        ),
        GCWIntegerSpinner(
          title: i18n(context, 'railfence_key'),
          value: _currentKey,
          min: 2,
          max: _currentInput.length,
          onChanged: (value) {
            setState(() {
              _currentKey = value;
            });
          },
        ),
        Row(
          children: [
            Expanded(flex: 1, child: GCWText(text: i18n(context, 'railfence_optionalpassword'))),
            Expanded(
                flex: 3,
                child: GCWTextField(
                  maxLength: _currentKey,
                  inputFormatters: [_maskInputFormatter],
                  onChanged: (text) {
                    setState(() {
                      _currentPassword = text;
                    });
                  },
                ))
          ],
        ),
        GCWIntegerSpinner(
          title: i18n(context, 'railfence_offset'),
          min: 0,
          max: _currentInput.length,
          value: _currentOffset,
          onChanged: (value) {
            setState(() {
              _currentOffset = value;
            });
          },
        ),
        GCWTwoOptionsSwitch(
            value: _currentMode,
            onChanged: (value) {
              setState(() {
                _currentMode = value;
              });
            }),
        GCWDefaultOutput(child: _calculateOutput())
      ],
    );
  }

  String _calculateOutput() {
    return _currentMode == GCWSwitchPosition.left
        ? encryptRailFence(_currentInput, _currentKey, offset: _currentOffset, password: _currentPassword)
        : decryptRailFence(_currentInput, _currentKey, offset: _currentOffset, password: _currentPassword);
  }
}
