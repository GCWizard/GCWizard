import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/app_localizations.dart';
import 'package:gc_wizard/common_widgets/dividers/gcw_text_divider.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/spinners/gcw_dropdown_spinner.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_twooptions_switch.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/prime_alphabet/logic/prime_alphabet.dart';
import 'package:gc_wizard/tools/science_and_technology/primes/_common/logic/primes_list.dart';
import 'package:gc_wizard/utils/constants.dart';

class PrimeAlphabet extends StatefulWidget {
  @override
  PrimeAlphabetState createState() => PrimeAlphabetState();
}

final _MAX_PRIME_INDEX = 26 * 10;
final _PRIMES_LIST = primes.sublist(0, _MAX_PRIME_INDEX);

class PrimeAlphabetState extends State<PrimeAlphabet> {
  TextEditingController _encryptInputController;
  TextEditingController _decryptInputController;
  var _currentEncryptInput = '';
  var _currentDecryptInput = '';

  GCWSwitchPosition _currentMode = GCWSwitchPosition.right;
  var _currentStartIndex = 0;
  var _currentEndIndex = 25;

  @override
  void initState() {
    super.initState();

    _decryptInputController = TextEditingController(text: _currentDecryptInput);
    _encryptInputController = TextEditingController(text: _currentEncryptInput);
  }

  @override
  void dispose() {
    _encryptInputController.dispose();
    _decryptInputController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _currentMode == GCWSwitchPosition.left
            ? GCWTextField(
                controller: _encryptInputController,
                onChanged: (text) {
                  setState(() {
                    _currentEncryptInput = text;
                  });
                },
              )
            : GCWTextField(
                controller: _decryptInputController,
                onChanged: (text) {
                  setState(() {
                    _currentDecryptInput = text;
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
        GCWTextDivider(text: i18n(context, 'primealphabet_recognizedprimes')),
        GCWDropDownSpinner(
            title: i18n(context, 'primealphabet_firstprime'),
            index: _currentStartIndex,
            onChanged: (value) {
              setState(() {
                _currentStartIndex = value;
                if (_currentEndIndex > _MAX_PRIME_INDEX - _currentStartIndex - 1)
                  _currentEndIndex = _MAX_PRIME_INDEX - _currentStartIndex - 1;
              });
            },
            items: _getItemEntries(0)),
        _currentMode == GCWSwitchPosition.right
            ? Container()
            : GCWDropDownSpinner(
                title: i18n(context, 'primealphabet_lastprime'),
                index: _currentEndIndex,
                onChanged: (value) {
                  setState(() {
                    _currentEndIndex = value;
                  });
                },
                items: _getItemEntries(_currentStartIndex)),
        GCWDefaultOutput(child: _buildOutput())
      ],
    );
  }

  List<String> _getItemEntries(int minimumIndex) {
    return _PRIMES_LIST.sublist(minimumIndex).map((number) {
      return '$number (${_PRIMES_LIST.indexOf(number) + 1}. ' + i18n(context, 'primealphabet_prime') + ')';
    }).toList();
  }

  _buildOutput() {
    if (_currentMode == GCWSwitchPosition.right) {
      return decryptPrimeAlphabet(
          RegExp(r'[0-9]+').allMatches(_currentDecryptInput).map((number) => int.tryParse(number.group(0))).toList(),
          firstRecognizedPrime: _PRIMES_LIST[_currentStartIndex]);
    } else {
      return encryptPrimeAlphabet(
        _currentEncryptInput,
        firstRecognizedPrime: _PRIMES_LIST[_currentStartIndex],
        lastRecognizedPrime: _PRIMES_LIST[_currentStartIndex + _currentEndIndex],
      ).map((element) => element ?? UNKNOWN_ELEMENT).join(' ');
    }
  }
}
