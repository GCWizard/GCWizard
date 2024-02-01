import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/common_widgets/dividers/gcw_text_divider.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_alphabetdropdown.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_twooptions_switch.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/chao/logic/chao.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/reverse/logic/reverse.dart';
import 'package:gc_wizard/utils/alphabets.dart';

class Chao extends StatefulWidget {
  const Chao({Key? key}) : super(key: key);

  @override
  _ChaoState createState() => _ChaoState();
}

class _ChaoState extends State<Chao> {
  late TextEditingController _inputController;
  late TextEditingController _alphabetControllerPlain;
  late TextEditingController _alphabetControllerChiffre;

  var _currentMode = GCWSwitchPosition.right;

  String _currentInput = '';
  String _currentOutput = '';
  String _currentAlphabetPlain = '';
  String _currentAlphabetChiffre = '';

  ChaoAlphabet _currentAlphabetTypePlain = ChaoAlphabet.AZ;
  ChaoAlphabet _currentAlphabetTypeChiffre = ChaoAlphabet.AZ;

  @override
  void initState() {
    super.initState();
    _inputController = TextEditingController(text: _currentInput);
    _alphabetControllerPlain = TextEditingController(text: _currentAlphabetPlain);
    _alphabetControllerChiffre = TextEditingController(text: _currentAlphabetChiffre);
  }

  @override
  void dispose() {
    _inputController.dispose();
    _alphabetControllerPlain.dispose();
    _alphabetControllerChiffre.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var ChaoPlainAlphabetItems = {
      ChaoAlphabet.AZ: i18n(context, 'chao_alphabet_az'),
      ChaoAlphabet.ZA: i18n(context, 'chao_alphabet_za'),
      ChaoAlphabet.CUSTOM: i18n(context, 'common_custom'),
    };
    var ChaoChiffreAlphabetItems = {
      ChaoAlphabet.AZ: i18n(context, 'chao_alphabet_az'),
      ChaoAlphabet.ZA: i18n(context, 'chao_alphabet_za'),
      ChaoAlphabet.CUSTOM: i18n(context, 'common_custom'),
    };

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
        GCWTwoOptionsSwitch(
          value: _currentMode,
          onChanged: (value) {
            setState(() {
              _currentMode = value;
            });
          },
        ),
        GCWTextDivider(text: i18n(context, 'chao_alphabet_cipher')),
        GCWAlphabetDropDown<ChaoAlphabet>(
          value: _currentAlphabetTypeChiffre,
          items: ChaoChiffreAlphabetItems,
          customModeKey: ChaoAlphabet.CUSTOM,
          textFieldController: _alphabetControllerChiffre,
          onChanged: (value) {
            setState(() {
              _currentAlphabetTypeChiffre = value;
            });
          },
          onCustomAlphabetChanged: (text) {
            setState(() {
              _currentAlphabetChiffre = text;
            });
          },
        ),
        GCWTextDivider(text: i18n(context, 'chao_alphabet_plain')),
        GCWAlphabetDropDown<ChaoAlphabet>(
          value: _currentAlphabetTypePlain,
          items: ChaoPlainAlphabetItems,
          customModeKey: ChaoAlphabet.CUSTOM,
          textFieldController: _alphabetControllerPlain,
          textFieldHintText: i18n(context, 'chao_alphabet_plain'),
          onChanged: (value) {
            setState(() {
              _currentAlphabetTypePlain = value;
            });
          },
          onCustomAlphabetChanged: (text) {
            setState(() {
              _currentAlphabetPlain = text;
            });
          },
        ),
        _buildOutput()
      ],
    );
  }

  Widget _buildOutput() {
    if (_currentInput.isEmpty) return const GCWDefaultOutput();

    var alphabetChiffre = '';
    var alphabetPlain = '';

    var alphabetAZ = alphabet_AZ.keys.join();
    var alphabetZA = reverse(alphabetAZ);

    switch (_currentAlphabetTypePlain) {
      case ChaoAlphabet.AZ:
        alphabetPlain = alphabetAZ;
        break;
      case ChaoAlphabet.ZA:
        alphabetPlain = alphabetZA;
        break;
      case ChaoAlphabet.CUSTOM:
        alphabetPlain = _currentAlphabetPlain.toUpperCase();
        break;
    }

    switch (_currentAlphabetTypeChiffre) {
      case ChaoAlphabet.AZ:
        alphabetChiffre = alphabetAZ;
        break;
      case ChaoAlphabet.ZA:
        alphabetChiffre = alphabetZA;
        break;
      case ChaoAlphabet.CUSTOM:
        alphabetChiffre = _currentAlphabetChiffre.toUpperCase();
        break;
    }

    if (_currentMode == GCWSwitchPosition.left) {
      _currentOutput = encryptChao(_currentInput, alphabetPlain, alphabetChiffre);
    } else {
      _currentOutput = decryptChao(_currentInput, alphabetPlain, alphabetChiffre);
    }

    return GCWDefaultOutput(
      child: _currentOutput,
    );
  }
}
