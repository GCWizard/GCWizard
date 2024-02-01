import 'package:code_text_field/code_text_field.dart';
import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/application/theme/theme.dart';
import 'package:gc_wizard/application/theme/theme_colors.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_iconbutton.dart';
import 'package:gc_wizard/common_widgets/clipboard/gcw_clipboard.dart';
import 'package:gc_wizard/common_widgets/gcw_expandable.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_columned_multiline_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_twooptions_switch.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_code_textfield.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/esoteric_programming_languages/befunge/logic/befunge.dart';

class Befunge extends StatefulWidget {
  const Befunge({Key? key}) : super(key: key);

  @override
  _BefungeState createState() => _BefungeState();
}

class _BefungeState extends State<Befunge> {
  late TextEditingController _befungeGenerateController;
  late CodeController _befungeInterpretCodeController;
  late TextEditingController _inputController;
  late TextEditingController _codeGenerateController;

  String _currentGenerate = '';
  String _currentInterpret = '';
  String _currentInput = '';
  final _sourceCodeGenerated = '';

  GCWSwitchPosition _currentMode = GCWSwitchPosition.left;

  @override
  void initState() {
    super.initState();
    _befungeGenerateController = TextEditingController(text: _currentGenerate);
    _befungeInterpretCodeController = CodeController(
      text: _currentInterpret,
      //stringMap: BEFUNGE_SYNTAX,
    );
    _inputController = TextEditingController(text: _currentInput);
    _codeGenerateController = TextEditingController(text: _sourceCodeGenerated);
  }

  @override
  void dispose() {
    _befungeGenerateController.dispose();
    _befungeInterpretCodeController.dispose();
    _inputController.dispose();
    _codeGenerateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeColors colors = themeColors();
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
          ? CodeField(
              controller: _befungeInterpretCodeController,
              textStyle: gcwMonotypeTextStyle(),
              background: colors.primaryBackground(),
              lineNumbers: true,
              readOnly: false,
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
      if (output.Error.isEmpty) {
        outputText = output.Output;
      } else {
        outputText = output.Output +
            '\n' +
            i18n(context, output.Error) +
            '\n' +
            i18n(context, 'common_programming_iteration') +
            ': ' +
            output.Iteration +
            '\n' +
            i18n(context, 'common_programming_cursorposition') +
            ': (' +
            output.curPosX +
            '|' +
            output.curPosY +
            ')' +
            '\n';
      }

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
                flexValues: const [2, 2, 3, 5],
                suppressCopyButtons: true,
                hasHeader: true,
              ))
        ],
      );
    } else {
      return GCWDefaultOutput(
        trailing: Row(
          children: <Widget>[
            GCWIconButton(
              iconColor: themeColors().mainFont(),
              size: IconButtonSize.SMALL,
              icon: Icons.content_copy,
              onPressed: () {
                var copyText = _codeGenerateController.text;
                insertIntoGCWClipboard(context, copyText);
              },
            ),
          ],
        ),
        child: GCWCodeTextField(
          controller: _codeGenerateController,
        ),
      );
    }
  }
}
