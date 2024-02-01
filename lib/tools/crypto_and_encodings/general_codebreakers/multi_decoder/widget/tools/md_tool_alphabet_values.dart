import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_dropdown.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/alphabet_values/logic/alphabet_values.dart' as logic;
import 'package:gc_wizard/tools/crypto_and_encodings/general_codebreakers/multi_decoder/widget/multi_decoder.dart';
import 'package:gc_wizard/utils/alphabets.dart';
import 'package:gc_wizard/utils/constants.dart';

const MDT_INTERNALNAMES_ALPHABETVALUES = 'multidecoder_tool_alphabetvalues_title';
const MDT_ALPHABETVALUES_OPTION_ALPHABET = 'multidecoder_tool_alphabetvalues_option_alphabet';

class MultiDecoderToolAlphabetValues extends AbstractMultiDecoderTool {
  MultiDecoderToolAlphabetValues(
      {Key? key,
      required int id,
      required String name,
      required Map<String, Object?> options,
      required BuildContext context})
      : super(
          key: key,
          id: id,
          name: name,
          internalToolName: MDT_INTERNALNAMES_ALPHABETVALUES,
          onDecode: (String input, String key) {
            var alphabet = ALL_ALPHABETS
                .firstWhere((alphabet) =>
                    alphabet.key ==
                    checkStringFormatOrDefaultOption(
                        MDT_INTERNALNAMES_ALPHABETVALUES, options, MDT_ALPHABETVALUES_OPTION_ALPHABET))
                .alphabet;

            return logic.AlphabetValues(alphabet: alphabet)
                .valuesToText(input.split(RegExp(r'\D')).map((value) => int.tryParse(value) ?? 0).toList())
                .replaceAll(UNKNOWN_ELEMENT, '');
          },
          options: options,
        );

  @override
  State<StatefulWidget> createState() => _MultiDecoderToolAlphabetValuesState();
}

class _MultiDecoderToolAlphabetValuesState extends State<MultiDecoderToolAlphabetValues> {
  @override
  Widget build(BuildContext context) {
    return createMultiDecoderToolConfiguration(context, {
      MDT_ALPHABETVALUES_OPTION_ALPHABET: GCWDropDown<String>(
        value: checkStringFormatOrDefaultOption(
            MDT_INTERNALNAMES_ALPHABETVALUES, widget.options, MDT_ALPHABETVALUES_OPTION_ALPHABET),
        items: ALL_ALPHABETS.map((alphabet) {
          return GCWDropDownMenuItem(
              value: alphabet.key,
              child: alphabet.type == AlphabetType.STANDARD ? i18n(context, alphabet.key) : alphabet.name ?? '');
        }).toList(),
        onChanged: (value) {
          setState(() {
            widget.options[MDT_ALPHABETVALUES_OPTION_ALPHABET] = value;
          });
        },
      )
    });
  }
}
