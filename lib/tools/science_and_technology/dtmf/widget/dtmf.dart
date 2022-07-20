import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gc_wizard/i18n/app_localizations.dart';
import 'package:gc_wizard/tools/science_and_technology/dtmf/logic/dtmf.dart';
import 'package:gc_wizard/theme/theme.dart';
import 'package:gc_wizard/tools/common/base/gcw_dropdownbutton/widget/gcw_dropdownbutton.dart';
import 'package:gc_wizard/tools/common/base/gcw_iconbutton/widget/gcw_iconbutton.dart';
import 'package:gc_wizard/tools/common/base/gcw_output_text/widget/gcw_output_text.dart';
import 'package:gc_wizard/tools/common/base/gcw_textfield/widget/gcw_textfield.dart';
import 'package:gc_wizard/tools/common/gcw_text_divider/widget/gcw_text_divider.dart';
import 'package:gc_wizard/tools/common/gcw_twooptions_switch/widget/gcw_twooptions_switch.dart';
import 'package:gc_wizard/tools/utils/textinputformatter/wrapper_for_masktextinputformatter/widget/wrapper_for_masktextinputformatter.dart';
import 'package:gc_wizard/tools/utils/common_widget_utils/widget/common_widget_utils.dart';

class DTMF extends StatefulWidget {
  @override
  DTMFState createState() => DTMFState();
}

class DTMFState extends State<DTMF> {
  TextEditingController _encodeController;
  TextEditingController _decodeController;

  var _currentEncodeInput = '';
  var _currentDecodeInput = '';

  var _currentDecryptLowFrequency = DTMF_FREQUENCIES_LOW[0];
  var _currentDecryptHighFrequency = DTMF_FREQUENCIES_HIGH[0];

  GCWSwitchPosition _currentMode = GCWSwitchPosition.right;

  var _maskInputFormatter =
      WrapperForMaskTextInputFormatter(mask: '#' * 10000, filter: {"#": RegExp(r'[0-9\*\#a-dA-D]')});

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
                inputFormatters: [_maskInputFormatter],
                onChanged: (text) {
                  setState(() {
                    _currentEncodeInput = text;
                  });
                },
              )
            : Container(),
        _currentMode == GCWSwitchPosition.right
            ? Row(
                children: [
                  Expanded(
                      child: Container(
                    child: GCWDropDownButton(
                      value: _currentDecryptLowFrequency,
                      items: DTMF_FREQUENCIES_LOW.map((frequency) {
                        return GCWDropDownMenuItem(
                          value: frequency,
                          child: frequency.toString(),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _currentDecryptLowFrequency = value;
                        });
                      },
                    ),
                    padding: EdgeInsets.only(right: DEFAULT_MARGIN),
                  )),
                  Expanded(
                      child: Container(
                    child: GCWDropDownButton(
                      value: _currentDecryptHighFrequency,
                      items: DTMF_FREQUENCIES_HIGH.map((frequency) {
                        return GCWDropDownMenuItem(
                          value: frequency,
                          child: frequency.toString(),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _currentDecryptHighFrequency = value;
                        });
                      },
                    ),
                    padding: EdgeInsets.only(left: DEFAULT_MARGIN, right: DEFAULT_MARGIN),
                  )),
                  GCWIconButton(
                    icon: Icons.add,
                    onPressed: () {
                      setState(() {
                        var input = ' [$_currentDecryptLowFrequency, $_currentDecryptHighFrequency] ';
                        _currentDecodeInput = textControllerInsertText(input, _currentDecodeInput, _decodeController);
                      });
                    },
                  )
                ],
              )
            : Container(),
        _currentMode == GCWSwitchPosition.right
            ? GCWTextField(
                controller: _decodeController,
                onChanged: (text) {
                  setState(() {
                    _currentDecodeInput = text;
                  });
                },
              )
            : Container(),
        GCWTextDivider(text: i18n(context, 'common_output')),
        _buildOutput(context)
      ],
    );
  }

  Widget _buildOutput(BuildContext context) {
    var output = '';

    if (_currentMode == GCWSwitchPosition.left) {
      output = encodeDTMF(_currentEncodeInput);
    } else
      output = decodeDTMF(_currentDecodeInput);

    return GCWOutputText(
      text: output,
    );
  }
}
