import 'package:flutter/material.dart';
import 'package:gc_wizard/i18n/app_localizations.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/esoteric_programming_languages/deadfish/logic/deadfish.dart';
import 'package:gc_wizard/tools/common/base/gcw_dropdownbutton/widget/gcw_dropdownbutton.dart';
import 'package:gc_wizard/tools/common/gcw_stateful_dropdownbutton/widget/gcw_stateful_dropdownbutton.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/general_codebreakers/multi_decoder/gcw_multi_decoder_tool/widget/gcw_multi_decoder_tool.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/general_codebreakers/multi_decoder/gcw_multi_decoder_tool_configuration/widget/gcw_multi_decoder_tool_configuration.dart';

const MDT_INTERNALNAMES_ESOTERIC_LANGUAGE_DEADFISH = 'deadfish_title';
const MDT_ESOTERIC_LANGUAGE_DEADFISH_OPTION_MODE = 'common_mode';

const MDT_ESOTERIC_LANGUAGES_DEADFISH_OPTION_IDSO = 'deadfish_mode_left';
const MDT_ESOTERIC_LANGUAGES_DEADFISH_OPTION_XKCD = 'deadfish_mode_right';

class MultiDecoderToolEsotericLanguageDeadfish extends GCWMultiDecoderTool {
  MultiDecoderToolEsotericLanguageDeadfish(
      {Key key, int id, String name, Map<String, dynamic> options, BuildContext context})
      : super(
            key: key,
            id: id,
            name: name,
            internalToolName: MDT_INTERNALNAMES_ESOTERIC_LANGUAGE_DEADFISH,
            optionalKey: true,
            onDecode: (String input, String key) {
              try {
                var decodeable = input;
                if (options[MDT_ESOTERIC_LANGUAGE_DEADFISH_OPTION_MODE] ==
                    MDT_ESOTERIC_LANGUAGES_DEADFISH_OPTION_XKCD) //XKCD
                  decodeable = decodeable
                      .toLowerCase()
                      .replaceAll(RegExp(r'[iso]'), '')
                      .replaceAll('x', 'i')
                      .replaceAll('k', 's')
                      .replaceAll('c', 'o');

                var output = decodeDeadfish(decodeable);
                return output?.trim().isEmpty ? null : output;
              } catch (e) {}
              return null;
            },
            options: options,
            configurationWidget: GCWMultiDecoderToolConfiguration(widgets: {
              MDT_ESOTERIC_LANGUAGE_DEADFISH_OPTION_MODE: GCWStatefulDropDownButton(
                value: options[MDT_ESOTERIC_LANGUAGE_DEADFISH_OPTION_MODE],
                onChanged: (newValue) {
                  options[MDT_ESOTERIC_LANGUAGE_DEADFISH_OPTION_MODE] = newValue;
                },
                items: [MDT_ESOTERIC_LANGUAGES_DEADFISH_OPTION_IDSO, MDT_ESOTERIC_LANGUAGES_DEADFISH_OPTION_XKCD]
                    .map((mode) {
                  return GCWDropDownMenuItem(
                    value: mode,
                    child: i18n(context, mode),
                  );
                }).toList(),
              )
            }));
}
