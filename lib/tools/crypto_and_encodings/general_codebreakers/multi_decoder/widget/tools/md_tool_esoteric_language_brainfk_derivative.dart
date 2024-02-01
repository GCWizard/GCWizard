import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_dropdown.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/esoteric_programming_languages/brainfk/logic/brainfk.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/esoteric_programming_languages/brainfk/logic/brainfk_derivative.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/general_codebreakers/multi_decoder/widget/multi_decoder.dart';
import 'package:gc_wizard/utils/collection_utils.dart';
import 'package:gc_wizard/utils/data_type_utils/object_type_utils.dart';

const MDT_INTERNALNAMES_ESOTERIC_LANGUAGE_BRAINFK_DERIVATIVE =
    'multidecoder_tool_esotericlanguage_brainfk_derivate_title';
const MDT_ESOTERIC_LANGUAGE_BRAINFK_DERIVATIVE_OPTION_MODE = 'common_language';

const MDT_ESOTERIC_LANGUAGE_BRAINFK_DERIVATIVE_OPTION_BRAINFK = 'brainfk_title';

class MultiDecoderToolEsotericLanguageBrainfkDerivative extends AbstractMultiDecoderTool {
  MultiDecoderToolEsotericLanguageBrainfkDerivative(
      {Key? key,
      required int id,
      required String name,
      required Map<String, Object?> options,
      required BuildContext context})
      : super(
            key: key,
            id: id,
            name: name,
            internalToolName: MDT_INTERNALNAMES_ESOTERIC_LANGUAGE_BRAINFK_DERIVATIVE,
            optionalKey: true,
            onDecode: (String input, String key) {
              var option = checkStringFormatOrDefaultOption(MDT_INTERNALNAMES_ESOTERIC_LANGUAGE_BRAINFK_DERIVATIVE,
                  options, MDT_ESOTERIC_LANGUAGE_BRAINFK_DERIVATIVE_OPTION_MODE);

              if (option == MDT_ESOTERIC_LANGUAGE_BRAINFK_DERIVATIVE_OPTION_BRAINFK) {
                try {
                  return interpretBrainfk(input, input: key);
                } catch (e) {
                  return null;
                }
              } else {
                var bfDerivatives = switchMapKeyValue(BRAINFK_DERIVATIVES)[checkStringFormatOrDefaultOption(
                    MDT_INTERNALNAMES_ESOTERIC_LANGUAGE_BRAINFK_DERIVATIVE,
                    options,
                    MDT_ESOTERIC_LANGUAGE_BRAINFK_DERIVATIVE_OPTION_MODE)];
                if (bfDerivatives == null) return null;

                try {
                  return bfDerivatives.interpretBrainfkDerivatives(input, input: key);
                } catch (e) {
                  return null;
                }
              }
            },
            options: options);
  @override
  State<StatefulWidget> createState() => _MultiDecoderToolEsotericLanguageBrainfkDerivateState();
}

class _MultiDecoderToolEsotericLanguageBrainfkDerivateState
    extends State<MultiDecoderToolEsotericLanguageBrainfkDerivative> {
  @override
  Widget build(BuildContext context) {
    return createMultiDecoderToolConfiguration(context, {
      MDT_ESOTERIC_LANGUAGE_BRAINFK_DERIVATIVE_OPTION_MODE: GCWDropDown<String>(
        value: toStringOrDefault(widget.options[MDT_ESOTERIC_LANGUAGE_BRAINFK_DERIVATIVE_OPTION_MODE], ''),
        onChanged: (newValue) {
          setState(() {
            widget.options[MDT_ESOTERIC_LANGUAGE_BRAINFK_DERIVATIVE_OPTION_MODE] = newValue;
          });
        },
        items: ([MDT_ESOTERIC_LANGUAGE_BRAINFK_DERIVATIVE_OPTION_BRAINFK] + BRAINFK_DERIVATIVES.values.toList())
            .map((language) {
          return GCWDropDownMenuItem(
            value: language,
            child: i18n(context, language, ifTranslationNotExists: language),
          );
        }).toList(),
      )
    });
  }
}
