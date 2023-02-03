import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/app_localizations.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_dropdown.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_twooptions_switch.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_integer_list_textfield.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/tools/science_and_technology/telegraphs/wigwag/logic/wigwag.dart';
import 'package:gc_wizard/utils/constants.dart';

class WigWagSemaphoreTelegraph extends StatefulWidget {
  @override
  WigWagSemaphoreTelegraphState createState() => WigWagSemaphoreTelegraphState();
}

class WigWagSemaphoreTelegraphState extends State<WigWagSemaphoreTelegraph> {
  var _encodeController;
  var _decodeController;

  var _currentEncodeInput = '';
  var _currentDecodeInput = defaultIntegerListText;

  GCWSwitchPosition _currentMode = GCWSwitchPosition.right;

  var _currentLanguage = WigWagCodebook.GENERALSERVICECODE1872;

  @override
  void initState() {
    super.initState();

    _encodeController = TextEditingController(text: _currentEncodeInput);
    _decodeController = TextEditingController(text: _currentDecodeInput['text']);
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
        GCWDropDown(
          value: _currentLanguage,
          onChanged: (value) {
            setState(() {
              _currentLanguage = value;
            });
          },
          items: CCITT_CODEBOOK.entries.map((mode) {
            return GCWDropDownMenuItem(
                value: mode.key,
                child: i18n(context, mode.value['title']),
                subtitle: mode.value['subtitle'] != null ? i18n(context, mode.value['subtitle']) : null);
          }).toList(),
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
            : GCWIntegerListTextField(
                controller: _decodeController,
                onChanged: (text) {
                  setState(() {
                    _currentDecodeInput = text;
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
        GCWDefaultOutput(child: _calculateOutput()),
      ],
    );
  }

  _calculateOutput() {
    if (_currentMode == GCWSwitchPosition.left) {
      return encodeWigWag(_currentEncodeInput.toUpperCase(), _currentLanguage);
    } else {
      return decodeWigWag(List<int>.from(_currentDecodeInput['values']), _currentLanguage);
    }
  }
}
