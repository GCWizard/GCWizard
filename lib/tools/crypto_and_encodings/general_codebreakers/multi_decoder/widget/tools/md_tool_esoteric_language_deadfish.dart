import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/app_localizations.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_dropdown.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_stateful_dropdown.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/esoteric_programming_languages/deadfish/logic/deadfish.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/general_codebreakers/multi_decoder/widget/multi_decoder.dart';

const MDT_INTERNALNAMES_ESOTERIC_LANGUAGE_DEADFISH = 'deadfish_title';
const MDT_ESOTERIC_LANGUAGE_DEADFISH_OPTION_MODE = 'common_mode';

const MDT_ESOTERIC_LANGUAGES_DEADFISH_OPTION_IDSO = 'deadfish_mode_left';
const MDT_ESOTERIC_LANGUAGES_DEADFISH_OPTION_XKCD = 'deadfish_mode_right';

class MultiDecoderToolEsotericLanguageDeadfish extends AbstractMultiDecoderTool {
  MultiDecoderToolEsotericLanguageDeadfish({
    Key? key,
    required int id,
    required String name,
    required Map<String, Object?> options,
    required BuildContext context})
      : super(
            key: key,
            id: id,
            name: name,
            internalToolName: MDT_INTERNALNAMES_ESOTERIC_LANGUAGE_DEADFISH,
            optionalKey: true,
            onDecode: (String input, String key) {
              try {
                var decodeable = input;
                var option = checkStringFormatOrDefaultOption(MDT_INTERNALNAMES_ESOTERIC_LANGUAGE_DEADFISH, options, MDT_ESOTERIC_LANGUAGE_DEADFISH_OPTION_MODE);
                if (option == MDT_ESOTERIC_LANGUAGES_DEADFISH_OPTION_XKCD) {
                  decodeable = decodeable
                      .toLowerCase()
                      .replaceAll(RegExp(r'[iso]'), '')
                      .replaceAll('x', 'i')
                      .replaceAll('k', 's')
                      .replaceAll('c', 'o');
                }

                var output = decodeDeadfish(decodeable);
                return output.trim().isEmpty ? null : output;
              } catch (e) {}
              return null;
            },
            options: options,
            configurationWidget: MultiDecoderToolConfiguration(widgets: {
              MDT_ESOTERIC_LANGUAGE_DEADFISH_OPTION_MODE: GCWStatefulDropDown<String>(
                value: checkStringFormatOrDefaultOption(MDT_INTERNALNAMES_ESOTERIC_LANGUAGE_DEADFISH, options, MDT_ESOTERIC_LANGUAGE_DEADFISH_OPTION_MODE),
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
