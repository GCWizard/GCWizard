import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_dropdown.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/general_codebreakers/multi_decoder/widget/multi_decoder.dart';
import 'package:gc_wizard/tools/science_and_technology/numeral_bases/logic/numeral_bases.dart';
import 'package:gc_wizard/tools/science_and_technology/teletypewriter/_common/logic/teletypewriter.dart';
import 'package:gc_wizard/utils/collection_utils.dart';

const MDT_INTERNALNAMES_CCITT1 = 'multidecoder_tool_ccitt1_title';
const MDT_CCITT1_OPTION_MODE = 'common_mode';

const MDT_CCITT1_OPTION_MODE_DENARY = 'common_numeralbase_denary';
const MDT_CCITT1_OPTION_MODE_BINARY = 'common_numeralbase_binary';

class MultiDecoderToolCcitt1 extends AbstractMultiDecoderTool {
  MultiDecoderToolCcitt1(
      {Key? key,
      required int id,
      required String name,
      required Map<String, Object?> options,
      required BuildContext context})
      : super(
            key: key,
            id: id,
            name: name,
            internalToolName: MDT_INTERNALNAMES_CCITT1,
            onDecode: (String input, String key) {
              if (checkStringFormatOrDefaultOption(MDT_INTERNALNAMES_CCITT1, options, MDT_CCITT1_OPTION_MODE) ==
                  MDT_CCITT1_OPTION_MODE_BINARY) {
                var intValues = textToBinaryList(input).map((value) {
                  return int.tryParse(convertBase(value, 2, 10));
                }).toList();
                return decodeTeletypewriter(intValues.whereType<int>().toList(), TeletypewriterCodebook.BAUDOT_54123);
              } else {
                return decodeTeletypewriter(textToIntList(input), TeletypewriterCodebook.BAUDOT_54123);
              }
            },
            options: options);
  @override
  State<StatefulWidget> createState() => _MultiDecoderToolCcitt1State();
}

class _MultiDecoderToolCcitt1State extends State<MultiDecoderToolCcitt1> {
  @override
  Widget build(BuildContext context) {
    return createMultiDecoderToolConfiguration(context, {
      MDT_CCITT1_OPTION_MODE: GCWDropDown<String>(
        value: checkStringFormatOrDefaultOption(MDT_INTERNALNAMES_CCITT1, widget.options, MDT_CCITT1_OPTION_MODE),
        onChanged: (newValue) {
          setState(() {
            widget.options[MDT_CCITT1_OPTION_MODE] = newValue;
          });
        },
        items: [MDT_CCITT1_OPTION_MODE_DENARY, MDT_CCITT1_OPTION_MODE_BINARY].map((mode) {
          return GCWDropDownMenuItem(
            value: mode,
            child: i18n(context, mode),
          );
        }).toList(),
      )
    });
  }
}
