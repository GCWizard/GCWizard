import 'package:flutter/material.dart';
import 'package:gc_wizard/i18n/app_localizations.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/logic/teletypewriter.dart';
import 'package:gc_wizard/tools/science_and_technology/logic/numeral_bases.dart';
import 'package:gc_wizard/utils/common_utils.dart';
import 'package:gc_wizard/tools/common/base/gcw_dropdownbutton/widget/gcw_dropdownbutton.dart';
import 'package:gc_wizard/tools/common/gcw_stateful_dropdownbutton/widget/gcw_stateful_dropdownbutton.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/general_codebreakers/multi_decoder/gcw_multi_decoder_tool/widget/gcw_multi_decoder_tool.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/general_codebreakers/multi_decoder/gcw_multi_decoder_tool_configuration/widget/gcw_multi_decoder_tool_configuration.dart';

const MDT_INTERNALNAMES_CCITT2 = 'multidecoder_tool_ccitt2_title';
const MDT_CCITT2_OPTION_MODE = 'common_mode';

const MDT_CCITT2_OPTION_MODE_DENARY = 'common_numeralbase_denary';
const MDT_CCITT2_OPTION_MODE_BINARY = 'common_numeralbase_binary';

class MultiDecoderToolCcitt2 extends GCWMultiDecoderTool {
  MultiDecoderToolCcitt2({Key key, int id, String name, Map<String, dynamic> options, BuildContext context})
      : super(
            key: key,
            id: id,
            name: name,
            internalToolName: MDT_INTERNALNAMES_CCITT2,
            onDecode: (String input, String key) {
              if (options[MDT_CCITT2_OPTION_MODE] == MDT_CCITT2_OPTION_MODE_BINARY) {
                return decodeTeletypewriter(
                    textToBinaryList(input).map((value) {
                      return int.tryParse(convertBase(value, 2, 10));
                    }).toList(),
                    TeletypewriterCodebook.CCITT_ITA2_1931);
              } else
                return decodeTeletypewriter(textToIntList(input), TeletypewriterCodebook.CCITT_ITA2_1931);
            },
            options: options,
            configurationWidget: GCWMultiDecoderToolConfiguration(widgets: {
              MDT_CCITT2_OPTION_MODE: GCWStatefulDropDownButton(
                value: options[MDT_CCITT2_OPTION_MODE],
                onChanged: (newValue) {
                  options[MDT_CCITT2_OPTION_MODE] = newValue;
                },
                items: [MDT_CCITT2_OPTION_MODE_DENARY, MDT_CCITT2_OPTION_MODE_BINARY].map((mode) {
                  return GCWDropDownMenuItem(
                    value: mode,
                    child: i18n(context, mode),
                  );
                }).toList(),
              )
            }));
}
