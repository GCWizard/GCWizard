import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/app_localizations.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_dropdown.dart';
import 'package:gc_wizard/common_widgets/gcw_text.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_output_text.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_twooptions_switch.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/tools/science_and_technology/vanity/_common/logic/phone_models.dart';
import 'package:gc_wizard/tools/science_and_technology/vanity/_common/logic/vanity.dart';

class VanityMultitap extends StatefulWidget {
  @override
  VanityMultitapState createState() => VanityMultitapState();
}

class VanityMultitapState extends State<VanityMultitap> {
  var _encodeController;
  var _decodeController;

  var _currentDecodeInput = '';
  var _currentEncodeInput = '';
  GCWSwitchPosition _currentMode = GCWSwitchPosition.right;

  GCWSwitchPosition _currentSimpleMode = GCWSwitchPosition.left;

  PhoneModel _currentSimpleModel = PHONEMODEL_SIMPLE_SPACE_0;
  PhoneModel _currentModel = phoneModelByName(NAME_PHONEMODEL_NOKIA_3210);
  int _currentLanguageId = 0;

  @override
  void initState() {
    super.initState();
    _encodeController = TextEditingController(text: _currentEncodeInput);
  }

  @override
  void dispose() {
    _encodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
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
        GCWTwoOptionsSwitch(
          value: _currentSimpleMode,
          leftValue: i18n(context, 'common_mode_simple'),
          rightValue: i18n(context, 'common_mode_advanced'),
          onChanged: (value) {
            setState(() {
              _currentSimpleMode = value;
              _currentLanguageId = 0;
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
        if (_currentSimpleMode == GCWSwitchPosition.left)
          Column(
            children: [
              GCWDropDown(
                  value: _currentSimpleModel,
                  onChanged: (newValue) {
                    setState(() {
                      _currentSimpleModel = newValue;
                    });
                  },
                  items: [
                    PHONEMODEL_SIMPLE_SPACE_0,
                    PHONEMODEL_SIMPLE_SPACE_1,
                    PHONEMODEL_SIMPLE_SPACE_HASH,
                    PHONEMODEL_SIMPLE_SPACE_ASTERISK,
                  ].map((model) {
                    return GCWDropDownMenuItem(value: model, child: i18n(context, model.name));
                  }).toList())
            ],
          ),
        if (_currentSimpleMode == GCWSwitchPosition.right)
          Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: GCWText(
                      text: i18n(context, 'vanity_multitap_model'),
                    ),
                  ),
                  Expanded(
                      child: GCWDropDown(
                          value: _currentModel,
                          onChanged: (newValue) {
                            setState(() {
                              _currentModel = newValue;
                              _currentLanguageId = 0;
                            });
                          },
                          items: PHONE_MODELS.map((model) {
                            return GCWDropDownMenuItem(
                                value: model, child: model.name, subtitle: _buildSpaceDescription(model));
                          }).toList()),
                      flex: 3),
                ],
              ),
              if (_currentModel.languages[0][0] != PhoneInputLanguage.UNSPECIFIED)
                Row(
                  children: [
                    Expanded(
                        child: GCWText(
                      text: i18n(context, 'vanity_multitap_inputlanguage'),
                    )),
                    Expanded(
                        child: _currentModel.languages.length > 1
                            ? GCWDropDown(
                                value: _currentLanguageId,
                                onChanged: (newValue) {
                                  setState(() {
                                    _currentLanguageId = newValue;
                                  });
                                },
                                items: _currentModel.languages
                                    .asMap()
                                    .map((index, languages) {
                                      return MapEntry(
                                          index,
                                          GCWDropDownMenuItem(
                                              value: index,
                                              child: _getLanguageString(languages),
                                              subtitle: _buildLanguageExamples(index)));
                                    })
                                    .values
                                    .toList())
                            : GCWText(text: _getLanguageString(_currentModel.languages[0])),
                        flex: 3)
                  ],
                )
            ],
          ),
        _buildOutput()
      ],
    );
  }

  _buildSpaceDescription(PhoneModel model) {
    var charMap = model.characterMap[0][PhoneCaseMode.LOWER_CASE];
    if (charMap == null) charMap = model.characterMap[0][PhoneCaseMode.UPPER_CASE];

    var keys = '0123456789#*'.split('').toList();
    var key;
    for (key in keys) {
      if (charMap[key] != null && charMap[key].contains(' ')) break;
    }

    return i18n(context, 'vanity_multitap_spaceat') + key;
  }

  _buildLanguageExamples(int index) {
    var charMap = _currentModel.characterMap[index][PhoneCaseMode.LOWER_CASE];
    if (charMap == null) charMap = _currentModel.characterMap[index][PhoneCaseMode.UPPER_CASE];

    return [
      '2: ' + charMap['2'],
      '4: ' + charMap['4'],
      '7: ' + charMap['7'],
    ].join(', ');
  }

  _getLanguageString(List<PhoneInputLanguage> languages) {
    return languages.map((language) {
      switch (language) {
        case PhoneInputLanguage.EXTENDED:
          return i18n(context, 'vanity_language_extended');
        case PhoneInputLanguage.ENGLISH:
          return '🇬🇧';
        case PhoneInputLanguage.GERMAN:
          return '🇩🇪';
        case PhoneInputLanguage.PORTUGUESE:
          return '🇵🇹';
        case PhoneInputLanguage.FRENCH:
          return '🇫🇷';
        case PhoneInputLanguage.ITALIAN:
          return '🇮🇹';
        case PhoneInputLanguage.TURKISH:
          return '🇹🇷';
        case PhoneInputLanguage.BULGARIAN:
          return '🇧🇬';
        case PhoneInputLanguage.SERBIAN:
          return '🇷🇸';
        case PhoneInputLanguage.GREEK:
          return '🇬🇷';
        case PhoneInputLanguage.CROATIAN:
          return '🇭🇷';
        case PhoneInputLanguage.ROMANIAN:
          return '🇷🇴';
        case PhoneInputLanguage.DUTCH:
          return '🇳🇱';
        case PhoneInputLanguage.DANISH:
          return '🇩🇰';
        case PhoneInputLanguage.NORWEGIAN:
          return '🇳🇴';
        case PhoneInputLanguage.SWEDISH:
          return '🇸🇪';
        case PhoneInputLanguage.FINNISH:
          return '🇫🇮';
        case PhoneInputLanguage.SPANISH:
          return '🇪🇸';
        // case PhoneInputLanguage.CATALAN
        case PhoneInputLanguage.SLOVENIAN:
          return '🇸🇮';
      }
    }).join(' ');
  }

  _buildOutput() {
    var output;

    if (_currentSimpleMode == GCWSwitchPosition.left) {
      if (_currentMode == GCWSwitchPosition.left) {
        output = encodeVanityMultitap(
            _currentEncodeInput.toUpperCase(), _currentSimpleModel, PhoneInputLanguage.UNSPECIFIED);
      } else {
        output = decodeVanityMultitap(_currentDecodeInput, _currentSimpleModel, PhoneInputLanguage.UNSPECIFIED);
      }

      if (output == null) return GCWDefaultOutput();

      return GCWDefaultOutput(child: output['output']);
    } else {
      if (_currentMode == GCWSwitchPosition.left) {
        output =
            encodeVanityMultitap(_currentEncodeInput, _currentModel, _currentModel.languages[_currentLanguageId][0]);
      } else {
        output =
            decodeVanityMultitap(_currentDecodeInput, _currentModel, _currentModel.languages[_currentLanguageId][0]);
      }

      if (output == null) return GCWDefaultOutput();

      return GCWDefaultOutput(
        child: Column(children: [
          GCWOutputText(
            text: output['output'],
          ),
          GCWOutput(
            title: i18n(context, 'vanity_multitap_inputmode'),
            child: _getModeString(output['mode']),
          )
        ]),
      );
    }
  }

  _getModeString(PhoneCaseMode mode) {
    switch (mode) {
      case PhoneCaseMode.UPPER_CASE:
        return 'ABC';
      case PhoneCaseMode.LOWER_CASE:
        return 'abc';
      case PhoneCaseMode.CAMEL_CASE:
        return 'Abc';
      case PhoneCaseMode.NUMBERS:
        return '123';
      case PhoneCaseMode.SPECIAL_CHARACTERS:
        return i18n(context, 'vanity_multitap_specialchars');
    }
  }
}
