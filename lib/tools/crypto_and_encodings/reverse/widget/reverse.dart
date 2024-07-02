import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_dropdown.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/reverse/logic/reverse.dart';
import 'package:gc_wizard/utils/string_utils.dart';

enum _ReverseMode { ALL, BLOCK, KEEP_BLOCK_ORDER }

class Reverse extends StatefulWidget {
  const Reverse({Key? key}) : super(key: key);

  @override
  _ReverseState createState() => _ReverseState();
}

class _ReverseState extends State<Reverse> {
  var _currentMode = _ReverseMode.ALL;

  late TextEditingController _inputController;
  var _currentInput = '';

  @override
  void initState() {
    super.initState();

    _inputController = TextEditingController(text: _currentInput);
  }

  @override
  void dispose() {
    _inputController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GCWTextField(
          controller: _inputController,
          onChanged: (text) {
            setState(() {
              _currentInput = text;
            });
          },
        ),
        GCWDropDown<_ReverseMode>(
            value: _currentMode,
            items: _ReverseMode.values.map((_ReverseMode mode) {
              String example = '';
              switch (mode) {
                case _ReverseMode.ALL:
                  example = '123 4567 → 7654 321';
                  break;
                case _ReverseMode.BLOCK:
                  example = '123 4567 → 4567 123';
                  break;
                case _ReverseMode.KEEP_BLOCK_ORDER:
                  example = '123 4567 → 321 7654';
                  break;
                default:
                  break;
              }

              return GCWDropDownMenuItem<_ReverseMode>(
                  value: mode,
                  child: i18n(context, 'reverse_mode_' + enumName(mode.toString()).toLowerCase()),
                  subtitle: example);
            }).toList(),
            onChanged: (value) {
              setState(() {
                _currentMode = value;
              });
            }),
        GCWDefaultOutput(child: _calcOutput())
      ],
    );
  }

  String _calcOutput() {
    switch (_currentMode) {
      case _ReverseMode.ALL:
        return reverseAll(_currentInput);
      case _ReverseMode.BLOCK:
        return reverseBlocks(_currentInput);
      case _ReverseMode.KEEP_BLOCK_ORDER:
        return reverseKeepBlockOrder(_currentInput);
      default:
        return _currentInput;
    }
  }
}
