import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_alphabetdropdown.dart';
import 'package:gc_wizard/common_widgets/gcw_web_statefulwidget.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_output.dart';
import 'package:gc_wizard/common_widgets/spinners/gcw_integer_spinner.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/rotation/logic/rotation.dart';
import 'package:gc_wizard/utils/alphabets.dart';
import 'package:gc_wizard/utils/math_utils.dart';
import 'package:gc_wizard/utils/ui_dependent_utils/common_widget_utils.dart';

const String _apiSpecification = '''
{
  "/rotation_general" : {
    "alternative_paths": ["rotation", "rot", "rotx"],
    "get": {
      "summary": "Rotation Tool",
      "responses": {
        "204": {
          "description": "Tool loaded. No response data."
        }
      },
      "parameters" : [
        {
          "in": "query",
          "name": "input",
          "required": true,
          "description": "Input data for rotate text",
          "schema": {
            "type": "string"
          }
        },
        {
          "in": "query",
          "name": "key",
          "description": "Shifts the input for n alphabet places",
          "schema": {
            "type": "integer",
            "default": 13
          }
        }
      ]
    }
  }
}
''';

class RotationGeneral extends GCWWebStatefulWidget {
  RotationGeneral({super.key}) : super(apiSpecification: _apiSpecification);

  @override
  _RotationGeneralState createState() => _RotationGeneralState();
}

class _RotationGeneralState extends State<RotationGeneral> {
  final _CUSTOM_MODE_KEY = 'alphabet_custom';

  late TextEditingController _controller;
  late TextEditingController _customAlphabetController;

  String _currentInput = '';
  int _currentKey = 13;

  Alphabet _currentAlphabet = alphabetAZ;
  String _currentCustomAlphabet = '';
  final Map<Alphabet, String> _alphabets = {};
  final Map<Alphabet, String> _subtitles = {};

  @override
  void initState() {
    super.initState();

    if (widget.hasWebParameter()) {
      _currentInput = widget.getWebParameter('input') ?? _currentInput;

      var key = widget.getWebParameter('key');
      if (key != null) _currentKey = int.tryParse(key) ?? _currentKey;

      widget.webParameter = null;
    }

    _controller = TextEditingController(text: _currentInput);
    _customAlphabetController = TextEditingController(text: _currentCustomAlphabet);
  }

  @override
  void dispose() {
    _controller.dispose();
    _customAlphabetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_alphabets.isEmpty) {
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
          Alphabet(
            key: _CUSTOM_MODE_KEY,
            name: i18n(context, 'common_custom'),
            type: AlphabetType.CUSTOM,
            alphabet: {}
          ), () => i18n(context, 'common_custom')
      );

      for (Alphabet alphabet in _alphabets.keys.toList()) {
        _subtitles.putIfAbsent(alphabet, () => alphabet.alphabet.keys.join());
      }
      _subtitles.putIfAbsent(
          Alphabet(
              key: _CUSTOM_MODE_KEY,
              name: i18n(context, 'common_custom'),
              type: AlphabetType.CUSTOM,
              alphabet: {}
          ), () => ''
      );
    }

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
        GCWAlphabetDropDown<Alphabet>(
          value: _currentAlphabet,
          items: _alphabets,
          subtitles: _subtitles,
          textFieldController: _customAlphabetController,
          onChanged: (Alphabet value) {
            setState(() {
              _currentAlphabet = value;
            });
          },
        ),
        _currentAlphabet.key == _CUSTOM_MODE_KEY ?
          GCWTextField(
            controller: _customAlphabetController,
            onChanged: (text) {
              setState(() {
                _currentCustomAlphabet = text;
              });
            },
          ) : Container(),
        GCWIntegerSpinner(
          title: i18n(context, 'common_key'),
          value: _currentKey,
          onChanged: (value) {
            setState(() {
              _currentKey = value;
            });
          },
        ),
        _buildOutput()
      ],
    );
  }

  Widget _buildOutput() {
    if (_currentInput.isEmpty) return const GCWDefaultOutput();

    var _alphabet = _currentAlphabet.key == _CUSTOM_MODE_KEY ? _currentCustomAlphabet : _currentAlphabet.alphabet.keys.join();
    var reverseKey = _alphabet.isNotEmpty ? modulo(_alphabet.length - _currentKey, _alphabet.length).toInt() : 0;

    return Column(
      children: [
        GCWDefaultOutput(
          child: Rotator(alphabet: _alphabet).rotate(_currentInput, _currentKey),
        ),
        GCWOutput(
          title: i18n(context, 'rotation_general_reverse') +
              ' (' +
              i18n(context, 'common_key') +
              ': ' +
              reverseKey.toString() +
              ')',
          child: Rotator(alphabet: _alphabet).rotate(_currentInput, reverseKey),
        ),
      ],
    );
  }
}
