import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/application/i18n/logic/supported_locales.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_dropdown.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_twooptions_switch.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/tools/science_and_technology/spelling_alphabets/_common/spelling_alphabets_data.dart';
import 'package:gc_wizard/tools/science_and_technology/spelling_alphabets/spelling_alphabets_crypt/logic/spelling_alphabets_crypt.dart';

class SpellingAlphabetsCrypt extends StatefulWidget {
  const SpellingAlphabetsCrypt({Key? key}) : super(key: key);

  @override
  SpellingAlphabetsCryptState createState() => SpellingAlphabetsCryptState();
}

class SpellingAlphabetsCryptState extends State<SpellingAlphabetsCrypt> {
  SPELLING _currentLanguage = SPELLING.DEU2022;
  bool _setDefaultLanguage = false;

  late TextEditingController _encodeController;
  late TextEditingController _decodeController;

  GCWSwitchPosition _currentMode = GCWSwitchPosition.right;

  String _currentEncode = '';
  String _currentDecode = '';

  @override
  void initState() {
    super.initState();
    _encodeController = TextEditingController(text: _currentEncode);
    _decodeController = TextEditingController(text: _currentDecode);
  }

  @override
  void dispose() {
    _encodeController.dispose();
    _decodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_setDefaultLanguage) {
      _currentLanguage = _defaultLanguage(context);
      _setDefaultLanguage = true;
    }

    return Column(
      children: <Widget>[
        GCWDropDown<SPELLING>(
          value: _currentLanguage,
          onChanged: (value) {
            setState(() {
              _currentLanguage = value;
            });
          },
          items: SplayTreeMap<SPELLING, String>.from(
                  SPELLING_LIST,
                  (keys1, keys2) =>
                      i18n(context, SPELLING_LIST[keys1]!).compareTo(i18n(context, SPELLING_LIST[keys2]!)))
              .entries
              .map((mode) {
            return GCWDropDownMenuItem(
              value: mode.key,
              child: i18n(context, mode.value),
            );
          }).toList(),
        ),
        GCWTwoOptionsSwitch(
          value: _currentMode,
          onChanged: (value) {
            setState(() {
              _currentMode = value;
            });
          },
        ),
        _currentMode == GCWSwitchPosition.right
            ? GCWTextField(
                controller: _decodeController,
                onChanged: (text) {
                  setState(() {
                    _currentDecode = text;
                  });
                },
              )
            : GCWTextField(
                controller: _encodeController,
                onChanged: (text) {
                  setState(() {
                    _currentEncode = text;
                  });
                },
              ),
        _buildOutput(context)
      ],
    );
  }

  Widget _buildOutput(BuildContext context) {
    return GCWDefaultOutput(
      child: _currentMode == GCWSwitchPosition.right
          ? decodeSpellingAlphabets(_currentDecode, _currentLanguage)
          : encodeSpellingAlphabets(_currentEncode, _currentLanguage),
    );
  }

  SPELLING _defaultLanguage(BuildContext context) {
    final Locale appLocale = Localizations.localeOf(context);
    if (isLocaleSupported(appLocale)) {
      return SUPPORTED_SPELLING_LOCALES[appLocale]!;
    } else {
      return SUPPORTED_SPELLING_LOCALES[DEFAULT_LOCALE]!;
    }
  }
}
