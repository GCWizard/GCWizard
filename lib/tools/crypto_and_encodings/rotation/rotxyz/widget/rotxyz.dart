import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_languages_alphabetdropdown.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_output.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/vigenere/logic/vigenere.dart';
import 'package:gc_wizard/utils/alphabets.dart';

class RotXYZ extends StatefulWidget {
  const RotXYZ({super.key});

  @override
  _RotationGeneralState createState() => _RotationGeneralState();
}

class _RotationGeneralState extends State<RotXYZ> {
  late TextEditingController _controller;
  late TextEditingController _keyController;

  String _currentInput = '';
  String _currentKey = '';

  Alphabet _currentAlphabet = alphabetAZ;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: _currentInput);
    _keyController = TextEditingController(text: _currentKey);
  }

  @override
  void dispose() {
    _controller.dispose();
    _keyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GCWTextField(
          controller: _controller,
          onChanged: (text) {
            setState(() {
              _currentInput = text;
            });
          },
        ),
        GCWLanguagesAlphabetDropDown(
          value: _currentAlphabet,
          onChanged: (Alphabet value) {
            setState(() {
              _currentAlphabet = value;
            });
          }
        ),
        GCWTextField(
          controller: _keyController,
          onChanged: (text) {
            setState(() {
              _currentKey = text;
            });
          },
        ),
        _buildOutput()
      ],
    );
  }

  Widget _buildOutput() {
    if (_currentInput.isEmpty) return const GCWDefaultOutput();

    var encrypt = encryptVigenere(
          _currentInput,
          _currentKey,
          false,
          aValue: 1,
          ignoreNonLetters: true,
          alphabet: _currentAlphabet
      );

    var decrypt = decryptVigenere(
          _currentInput,
          _currentKey,
          false,
          aValue: 1,
          ignoreNonLetters: true,
          alphabet: _currentAlphabet
      );

    return Column(
      children: [
        GCWDefaultOutput(
          child: encrypt,
        ),
        GCWOutput(
          title: i18n(context, 'rotation_general_reverse'),
          child: decrypt,
        ),
      ],
    );
  }
}
