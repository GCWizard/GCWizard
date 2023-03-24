import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/app_localizations.dart';
import 'package:gc_wizard/application/theme/theme.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_iconbutton.dart';
import 'package:gc_wizard/common_widgets/dividers/gcw_text_divider.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_dropdown.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_output_text.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_twooptions_switch.dart';
import 'package:gc_wizard/common_widgets/text_input_formatters/wrapper_for_masktextinputformatter.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/tools/science_and_technology/dtmf/logic/dtmf.dart';
import 'package:gc_wizard/utils/ui_dependent_utils/text_widget_utils.dart';

class DTMF extends StatefulWidget {
  const DTMF({Key? key}) : super(key: key);

  @override
  DTMFState createState() => DTMFState();
}

class DTMFState extends State<DTMF> {
  late TextEditingController _encodeController;
  late TextEditingController _decodeController;

  var _currentEncodeInput = '';
  var _currentDecodeInput = '';

  var _currentDecryptLowFrequency = DTMF_FREQUENCIES_LOW[0];
  var _currentDecryptHighFrequency = DTMF_FREQUENCIES_HIGH[0];

  GCWSwitchPosition _currentMode = GCWSwitchPosition.right;

  final _maskInputFormatter =
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
                    padding: const EdgeInsets.only(right: DEFAULT_MARGIN),
                    child: GCWDropDown<int>(
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
                  )),
                  Expanded(
                      child: Container(
                    padding: const EdgeInsets.only(left: DEFAULT_MARGIN, right: DEFAULT_MARGIN),
                    child: GCWDropDown<int>(
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
    } else {
      output = decodeDTMF(_currentDecodeInput);
    }

    return GCWOutputText(
      text: output,
    );
  }
}
