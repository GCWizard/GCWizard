import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_alphabetdropdown.dart';
import 'package:gc_wizard/utils/alphabets.dart';
import 'package:gc_wizard/utils/string_utils.dart';
import 'package:gc_wizard/utils/ui_dependent_utils/common_widget_utils.dart';

class GCWLanguagesAlphabetDropDown extends StatefulWidget {
  final void Function(Alphabet) onChanged;
  final Alphabet value;
  final TextEditingController? textFieldController;

  const GCWLanguagesAlphabetDropDown({
    super.key,
    required this.value,
    required this.onChanged,
    this.textFieldController,
  });

  @override
  _GCWLanguagesAlphabetDropDownState createState() => _GCWLanguagesAlphabetDropDownState();
}

class _GCWLanguagesAlphabetDropDownState extends State<GCWLanguagesAlphabetDropDown> {
  final _CUSTOM_MODE_KEY = 'alphabet_custom';

  Alphabet _currentAlphabet = alphabetAZ;
  final Map<Alphabet, String> _alphabets = {};
  final Map<Alphabet, String> _subtitles = {};

  late TextEditingController _customAlphabetController;

  late Alphabet _CUSTOM_ALPHABET;

  @override
  void initState() {
    super.initState();
    _customAlphabetController = TextEditingController(text: '');
  }

  @override
  void dispose() {
    _customAlphabetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_alphabets.isEmpty) {
      _CUSTOM_ALPHABET = Alphabet(
        key: _CUSTOM_MODE_KEY,
        name: i18n(context, 'common_custom'),
        type: AlphabetType.CUSTOM,
        alphabet: {}
      );

      var _tempAlphabets = List<Alphabet>.from(ALL_ALPHABETS);
      _tempAlphabets.removeWhere((alphabet) => [
        'alphabet_name_german2',
        'alphabet_name_german3',
        'alphabet_name_french2',
        'alphabet_name_spanish1',
      ].contains(alphabet.key));
      for (Alphabet alphabet in _tempAlphabets) {
        var _name = '';

        if (alphabet == alphabetAZ) {
          _name = getAlphabetName(context, alphabet);
        } else {
          _name = alphabet.key.split('_').last;
          _name = i18n(context, 'common_language_' + _name.replaceAll(RegExp(r'\d'), ''));
        }
        _alphabets.putIfAbsent(alphabet, () => _name);
      }
      _alphabets.putIfAbsent(
          _CUSTOM_ALPHABET, () => i18n(context, 'common_custom')
      );

      for (Alphabet alphabet in _alphabets.keys.toList()) {
        _subtitles.putIfAbsent(alphabet, () => alphabet.alphabet.keys.join());
      }
      _subtitles.putIfAbsent(
          _CUSTOM_ALPHABET, () => ''
      );
    }

    return GCWAlphabetDropDown<Alphabet>(
      value: _currentAlphabet,
      items: _alphabets,
      subtitles: _subtitles,
      customModeKey: _CUSTOM_ALPHABET,
      textFieldController: _customAlphabetController,
      onChanged: (Alphabet value) {
        setState(() {
          _currentAlphabet = value;
          widget.onChanged(_currentAlphabet);
        });
      },
      onCustomAlphabetChanged: (String text) {
        _CUSTOM_ALPHABET.alphabet.clear();
        for (int i = 0; i < text.length; i++) {
          _CUSTOM_ALPHABET.alphabet.putIfAbsent(toUpperCaseWithSZ(text[i]), () => (i + 1).toString());
        }
        _currentAlphabet = _CUSTOM_ALPHABET;
        _subtitles[_CUSTOM_ALPHABET] = _CUSTOM_ALPHABET.alphabet.keys.join();
        widget.onChanged(_currentAlphabet);
      },
    );
  }
}
