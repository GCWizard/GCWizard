import 'package:flutter/material.dart';
import 'package:gc_wizard/i18n/app_localizations.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/roman_numbers/roman_numbers/logic/roman_numbers.dart';
import 'package:gc_wizard/tools/common/base/gcw_dropdownbutton/widget/gcw_dropdownbutton.dart';
import 'package:gc_wizard/tools/common/gcw_stateful_dropdownbutton/widget/gcw_stateful_dropdownbutton.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/general_codebreakers/multi_decoder/gcw_multi_decoder_tool/widget/gcw_multi_decoder_tool.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/general_codebreakers/multi_decoder/gcw_multi_decoder_tool_configuration/widget/gcw_multi_decoder_tool_configuration.dart';

const MDT_INTERNALNAMES_ROMANNUMBERS = 'multidecoder_tool_romannumbers_title';
const MDT_ROMANNUMBERS_OPTION_MODE = 'multidecoder_tool_romannumbers_option_mode';
const MDT_ROMANNUMBERS_OPTION_MODE_SUBTRACTION = 'multidecoder_tool_romannumbers_option_mode_usesubtraction';
const MDT_ROMANNUMBERS_OPTION_MODE_ADDITION = 'multidecoder_tool_romannumbers_option_mode_onlyaddition';

class MultiDecoderToolRomanNumbers extends GCWMultiDecoderTool {
  MultiDecoderToolRomanNumbers({Key key, int id, String name, Map<String, dynamic> options, BuildContext context})
      : super(
            key: key,
            id: id,
            name: name,
            internalToolName: MDT_INTERNALNAMES_ROMANNUMBERS,
            onDecode: (String input, String key) {
              var type = options[MDT_ROMANNUMBERS_OPTION_MODE] == MDT_ROMANNUMBERS_OPTION_MODE_SUBTRACTION
                  ? RomanNumberType.USE_SUBTRACTION_RULE
                  : RomanNumberType.ONLY_ADDITION;

              return decodeRomanNumbers(input, type: type);
            },
            options: options,
            configurationWidget: GCWMultiDecoderToolConfiguration(widgets: {
              MDT_ROMANNUMBERS_OPTION_MODE: GCWStatefulDropDownButton(
                value: options[MDT_ROMANNUMBERS_OPTION_MODE],
                onChanged: (newValue) {
                  options[MDT_ROMANNUMBERS_OPTION_MODE] = newValue;
                },
                items: RomanNumberType.values.map((type) {
                  var key;
                  switch (type) {
                    case RomanNumberType.USE_SUBTRACTION_RULE:
                      key = MDT_ROMANNUMBERS_OPTION_MODE_SUBTRACTION;
                      break;
                    case RomanNumberType.ONLY_ADDITION:
                      key = MDT_ROMANNUMBERS_OPTION_MODE_ADDITION;
                      break;
                  }

                  return GCWDropDownMenuItem(
                    value: key,
                    child: i18n(context, key),
                  );
                }).toList(),
              ),
            }));
}
