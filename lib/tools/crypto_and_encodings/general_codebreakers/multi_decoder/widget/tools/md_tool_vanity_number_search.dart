import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_dropdown.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/general_codebreakers/multi_decoder/widget/multi_decoder.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/numeral_words/_common/logic/numeral_words.dart';
import 'package:gc_wizard/tools/science_and_technology/vanity/_common/logic/vanity_words.dart';
import 'package:gc_wizard/tools/science_and_technology/vanity/vanity_words_search/widget/vanity_words_search.dart';

const MDT_INTERNALNAMES_VANITY_NUMBERSEARCH = 'multidecoder_tool_vanity_numbersearch_title';
const MDT_VANITY_NUMBERSEARCH_OPTION_LANGUAGE = 'multidecoder_tool_vanity_numbersearch_option_language';

class MultiDecoderToolVanityWordsTextSearch extends AbstractMultiDecoderTool {
  MultiDecoderToolVanityWordsTextSearch(
      {Key? key,
      required int id,
      required String name,
      required Map<String, Object?> options,
      required BuildContext context})
      : super(
            key: key,
            id: id,
            name: name,
            internalToolName: MDT_INTERNALNAMES_VANITY_NUMBERSEARCH,
            onDecode: (String input, String key) {
              var language = _parseStringToEnum(stringNullableTypeCheck(options[MDT_VANITY_NUMBERSEARCH_OPTION_LANGUAGE], null));

              var detailedOutput = decodeVanityWords(input.toLowerCase(), language);

              var output = buildVanityWordSearchOutputString(detailedOutput, context);
              if (output.replaceAll(' ', '').replaceAll('.', '').isEmpty) return null;
              return output;
            },
            options: options);

  @override
  State<StatefulWidget> createState() => _MultiDecoderToolVanityMultitapState();
}

class _MultiDecoderToolVanityMultitapState extends State<MultiDecoderToolVanityWordsTextSearch> {
  @override
  Widget build(BuildContext context) {
    return createMultiDecoderToolConfiguration(context, {
      MDT_VANITY_NUMBERSEARCH_OPTION_LANGUAGE: GCWDropDown<String>(
          value: checkStringFormatOrDefaultOption(
              MDT_INTERNALNAMES_VANITY_NUMBERSEARCH, widget.options, MDT_VANITY_NUMBERSEARCH_OPTION_LANGUAGE),
          onChanged: (newValue) {
            setState(() {
              widget.options[MDT_VANITY_NUMBERSEARCH_OPTION_LANGUAGE] = newValue;
            });
          },
          items: VANITYWORDS_LANGUAGES.entries.map((mode) {
            return GCWDropDownMenuItem(
              value: mode.value,
              child: i18n(context, mode.value),
            );
          }).toList(),
      )
    });
  }
}

NumeralWordsLanguage _parseStringToEnum(String? item) {
  var result = VANITYWORDS_LANGUAGES.entries.firstWhereOrNull((e) => e.value == item);
  if (result != null) return result.key;
  var value =
  _parseStringToEnum((getDefaultValue(MDT_INTERNALNAMES_VANITY_NUMBERSEARCH, MDT_VANITY_NUMBERSEARCH_OPTION_LANGUAGE) ?? '').toString());
  return value;
}

String numeralWordsLanguage(NumeralWordsLanguage? item) {
  if (item == null) return '';
  return item
      .toString()
      .replaceAll('NumeralWordsLanguage.', '');
}
