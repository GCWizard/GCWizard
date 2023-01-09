import 'package:flutter/material.dart';
import 'package:gc_wizard/i18n/app_localizations.dart';
import 'package:gc_wizard/logic/tools/crypto_and_encodings/esoteric_programming_languages/befunge.dart';
import 'package:gc_wizard/theme/theme.dart';
import 'package:gc_wizard/theme/theme_colors.dart';
import 'package:gc_wizard/widgets/common/base/gcw_iconbutton.dart';
import 'package:gc_wizard/widgets/common/base/gcw_textfield.dart';
import 'package:gc_wizard/widgets/common/gcw_code_textfield.dart';
import 'package:gc_wizard/widgets/common/gcw_columned_multiline_output.dart';
import 'package:gc_wizard/widgets/common/gcw_default_output.dart';
import 'package:gc_wizard/widgets/common/gcw_expandable.dart';
import 'package:gc_wizard/widgets/common/gcw_twooptions_switch.dart';
import 'package:gc_wizard/widgets/utils/common_widget_utils.dart';

class Befunge extends StatefulWidget {
  @override
  BefungeState createState() => BefungeState();
}

class BefungeState extends State<Befunge> {
  var _befungeGenerateController;
  var _befungeInterpretController;
  var _inputController;

  var _currentGenerate = '';
  var _currentInterpret = '';
  var _currentInput = '';

  GCWSwitchPosition _currentMode = GCWSwitchPosition.left;
  var _codeGenerateController;
  var _sourceCodeGenerated = '';

  @override
  void initState() {
    super.initState();
    _befungeGenerateController = TextEditingController(text: _currentGenerate);
    _befungeInterpretController = TextEditingController(text: _currentInterpret);
    _inputController = TextEditingController(text: _currentInput);
    _codeGenerateController = TextEditingController(text: _sourceCodeGenerated);
  }

  @override
  void dispose() {
    _befungeGenerateController.dispose();
    _befungeInterpretController.dispose();
    _inputController.dispose();
    _codeGenerateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _codeGenerateController.text = generateBefunge(_currentGenerate);
    return Column(children: <Widget>[
      GCWTwoOptionsSwitch(
        leftValue: i18n(context, 'common_programming_mode_interpret'),
        rightValue: i18n(context, 'common_programming_mode_generate'),
        value: _currentMode,
        onChanged: (value) {
          setState(() {
            _currentMode = value;
          });
        },
      ),
      _currentMode == GCWSwitchPosition.left
          ? GCWTextField(
              controller: _befungeInterpretController,
              style: gcwMonotypeTextStyle(),
              hintText: i18n(context, 'common_programming_hint_sourcecode'),
              maxLines: 5,
              maxLength: MAX_LENGTH_PROGRAM,
              onChanged: (text) {
                setState(() {
                  _currentInterpret = text;
                });
              },
            )
          : GCWTextField(
              controller: _befungeGenerateController,
              hintText: i18n(context, 'common_programming_hint_output'),
              onChanged: (text) {
                setState(() {
                  _currentGenerate = text;
                });
              },
            ),
      _currentMode == GCWSwitchPosition.left
          ? GCWTextField(
              controller: _inputController,
              hintText: i18n(context, 'common_programming_hint_input'),
              onChanged: (text) {
                setState(() {
                  _currentInput = text;
                });
              },
            )
          : Container(),
      _buildOutput(),
    ]);
  }

  Widget _buildOutput() {
    if (_currentMode == GCWSwitchPosition.left) {
      BefungeOutput output = interpretBefunge(_currentInterpret, input: _currentInput);
      String outputText = '';
      if (output.Error == '')
        outputText = output.Output;
      else
        outputText = output.Output + '\n' + i18n(context, output.Error);

      List<List<String>> columnData = <List<String>>[];
      columnData.add(['PC', 'Cmd', 'Mnemonic', 'Stack']);
      for (int i = 0; i < output.PC.length; i++) {
        columnData.add([
          output.PC[i],
          i < output.Command.length ? output.Command[i] : '',
          i < output.Mnemonic.length ? output.Mnemonic[i] : '',
          i < output.BefungeStack.length ? output.BefungeStack[i] : ''
        ]);
      }

      return Column(
        children: <Widget>[
          GCWDefaultOutput(
            child: outputText,
          ),
          GCWExpandableTextDivider(
            expanded: false,
            text: i18n(context, 'common_programming_debug'),
            child: GCWColumnedMultilineOutput(
                data: columnData,
                flexValues: [2, 2, 3, 5],
                suppressCopyButtons: true,
                hasHeader: true,
            )
          )
        ],
      );
    } else
      return GCWDefaultOutput(
        child: GCWCodeTextField(
          controller: _codeGenerateController,
          textStyle: gcwMonotypeTextStyle(),
        ),
        trailing: Row(
          children: <Widget>[
            GCWIconButton(
              iconColor: themeColors().mainFont(),
              size: IconButtonSize.SMALL,
              icon: Icons.content_copy,
              onPressed: () {
                var copyText = _codeGenerateController.text != null ? _codeGenerateController.text : '';
                insertIntoGCWClipboard(context, copyText);
              },
            ),
          ],
        ),
      );
  }
}
