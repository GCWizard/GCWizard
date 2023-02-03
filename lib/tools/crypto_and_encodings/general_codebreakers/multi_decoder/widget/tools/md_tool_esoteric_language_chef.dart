import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/app_localizations.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_dropdown.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_stateful_dropdown.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/esoteric_programming_languages/chef_language/logic/chef_language.dart'
    as chef;
import 'package:gc_wizard/tools/crypto_and_encodings/esoteric_programming_languages/chef_language/widget/chef_language.dart'
    as chefWidget;
import 'package:gc_wizard/tools/crypto_and_encodings/general_codebreakers/multi_decoder/widget/multi_decoder.dart';

const MDT_INTERNALNAMES_ESOTERIC_LANGUAGE_CHEF = 'chef_title';
const MDT_ESOTERIC_LANGUAGE_CHEF_OPTION_MODE = 'settings_general_i18n_language';

const MDT_ESOTERIC_LANGUAGES_CHEF_OPTION_ENGLISH = 'common_language_english';
const MDT_ESOTERIC_LANGUAGES_CHEF_OPTION_GERMAN = 'common_language_german';

class MultiDecoderToolEsotericLanguageChef extends AbstractMultiDecoderTool {
  MultiDecoderToolEsotericLanguageChef(
      {Key key, int id, String name, Map<String, dynamic> options, BuildContext context})
      : super(
            key: key,
            id: id,
            name: name,
            internalToolName: MDT_INTERNALNAMES_ESOTERIC_LANGUAGE_CHEF,
            optionalKey: true,
            onDecode: (String input, String key) {
              try {
                if (chef.isValid(input))
                  return chefWidget.ChefState().buildOutputText(chef.interpretChef(
                      options[MDT_ESOTERIC_LANGUAGE_CHEF_OPTION_MODE], input.toLowerCase().replaceAll('  ', ' '), key));
              } catch (e) {}
              return null;
            },
            options: options,
            configurationWidget: MultiDecoderToolConfiguration(widgets: {
              MDT_ESOTERIC_LANGUAGE_CHEF_OPTION_MODE: GCWStatefulDropDown(
                value: options[MDT_ESOTERIC_LANGUAGE_CHEF_OPTION_MODE],
                onChanged: (newValue) {
                  options[MDT_ESOTERIC_LANGUAGE_CHEF_OPTION_MODE] = newValue;
                },
                items:
                    [MDT_ESOTERIC_LANGUAGES_CHEF_OPTION_ENGLISH, MDT_ESOTERIC_LANGUAGES_CHEF_OPTION_GERMAN].map((mode) {
                  return GCWDropDownMenuItem(
                    value: mode,
                    child: i18n(context, mode),
                  );
                }).toList(),
              )
            }));
}
