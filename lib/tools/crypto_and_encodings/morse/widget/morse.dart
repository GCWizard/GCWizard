import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/app_localizations.dart';
import 'package:gc_wizard/application/theme/theme.dart';
import 'package:gc_wizard/application/theme/theme_colors.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_iconbutton.dart';
import 'package:gc_wizard/common_widgets/dividers/gcw_text_divider.dart';
import 'package:gc_wizard/common_widgets/gcw_toolbar.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_output_text.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_twooptions_switch.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/morse/logic/morse.dart';
import 'package:gc_wizard/utils/ui_dependent_utils/text_widget_utils.dart';

class Morse extends StatefulWidget {
  const Morse({Key? key}) : super(key: key);

  @override
  MorseState createState() => MorseState();
}

class MorseState extends State<Morse> {
  late TextEditingController _encodeController;
  late TextEditingController _decodeController;

  var _currentEncodeInput = '';
  var _currentDecodeInput = '';
  GCWSwitchPosition _currentMode = GCWSwitchPosition.right;

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
        _buildMorseButtons(context),
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
        GCWTextDivider(text: i18n(context, 'common_output')),
        _buildOutput(context)
      ],
    );
  }

  Widget _buildMorseButtons(BuildContext context) {
    if (_currentMode == GCWSwitchPosition.left) return Container();

    return GCWToolBar(children: [
      Container(
        padding: const EdgeInsets.only(right: DOUBLE_DEFAULT_MARGIN),
        child: Row(
          children: [
            Expanded(
              child: GCWIconButton(
                customIcon: Icon(Icons.circle, size: 15, color: themeColors().mainFont()),
                onPressed: () {
                  setState(() {
                    _addCharacter('.');
                  });
                },
              ),
            ),
            Expanded(
              child: GCWIconButton(
                customIcon: Icon(Icons.remove, size: 35, color: themeColors().mainFont()),
                onPressed: () {
                  setState(() {
                    _addCharacter('-');
                  });
                },
              ),
            ),
          ],
        ),
      ),
      Container(
        padding: const EdgeInsets.only(right: DOUBLE_DEFAULT_MARGIN, left: DOUBLE_DEFAULT_MARGIN),
        child: Row(
          children: [
            Expanded(
              child: GCWIconButton(
                icon: Icons.double_arrow,
                onPressed: () {
                  setState(() {
                    _addCharacter(' ');
                  });
                },
              ),
            ),
            Expanded(
              child: GCWIconButton(
                icon: Icons.space_bar,
                onPressed: () {
                  setState(() {
                    _addCharacter(' | ');
                  });
                },
              ),
            ),
          ],
        ),
      ),
      Container(
        padding: const EdgeInsets.only(left: DOUBLE_DEFAULT_MARGIN),
        child: GCWIconButton(
          icon: Icons.backspace,
          onPressed: () {
            setState(() {
              _currentDecodeInput = textControllerDoBackSpace(_currentDecodeInput, _decodeController);
            });
          },
        ),
      )
    ]);
  }

  void _addCharacter(String input) {
    _currentDecodeInput = textControllerInsertText(input, _currentDecodeInput, _decodeController);
  }

  Widget _buildOutput(BuildContext context) {
    var output = '';

    var textStyle = gcwTextStyle();
    if (_currentMode == GCWSwitchPosition.left) {
      output = encodeMorse(_currentEncodeInput);
      textStyle =
          TextStyle(fontSize: textStyle.fontSize! + 15, fontFamily: textStyle.fontFamily, fontWeight: FontWeight.bold);
    } else {
      output = decodeMorse(_currentDecodeInput);
    }

    return GCWOutputText(text: output, style: textStyle);
  }
}
