import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/app_localizations.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_dropdown.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_stateful_dropdown.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/esoteric_programming_languages/beatnik_language/logic/beatnik_language.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/esoteric_programming_languages/beatnik_language/widget/beatnik_language.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/general_codebreakers/multi_decoder/widget/multi_decoder.dart';
import 'package:gc_wizard/tools/games/scrabble/logic/scrabble_sets.dart';

const MDT_INTERNALNAMES_ESOTERIC_LANGUAGE_BEATNIK = 'beatnik_title';
const MDT_ESOTERIC_LANGUAGE_BEATNIK_OPTION_MODE = 'beatnik_hint_scrabble';

class MultiDecoderToolEsotericLanguageBeatnik extends AbstractMultiDecoderTool {
  MultiDecoderToolEsotericLanguageBeatnik(
      {Key key, int id, String name, Map<String, dynamic> options, BuildContext context})
      : super(
            key: key,
            id: id,
            name: name,
            internalToolName: MDT_INTERNALNAMES_ESOTERIC_LANGUAGE_BEATNIK,
            optionalKey: true,
            onDecode: (String input, String key) {
              try {
                var _output = interpretBeatnik(options[MDT_ESOTERIC_LANGUAGE_BEATNIK_OPTION_MODE], input, key);
                return BeatnikState().buildOutputText(_output.output);
              } catch (e) {
                return null;
              }
            },
            options: options,
            configurationWidget: MultiDecoderToolConfiguration(widgets: {
              MDT_ESOTERIC_LANGUAGE_BEATNIK_OPTION_MODE: GCWStatefulDropDown(
                value: options[MDT_ESOTERIC_LANGUAGE_BEATNIK_OPTION_MODE],
                onChanged: (newValue) {
                  options[MDT_ESOTERIC_LANGUAGE_BEATNIK_OPTION_MODE] = newValue;
                },
                items: scrabbleSets.entries.map((set) {
                  return GCWDropDownMenuItem(
                    value: set.key,
                    child: i18n(context, set.value.i18nNameId),
                  );
                }).toList(),
              )
            }));
}
