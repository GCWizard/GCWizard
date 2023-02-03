import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/app_localizations.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_dropdown.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_stateful_dropdown.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/general_codebreakers/multi_decoder/widget/multi_decoder.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/roman_numbers/roman_numbers/logic/roman_numbers.dart';

const MDT_INTERNALNAMES_ROMANNUMBERS = 'multidecoder_tool_romannumbers_title';
const MDT_ROMANNUMBERS_OPTION_MODE = 'multidecoder_tool_romannumbers_option_mode';
const MDT_ROMANNUMBERS_OPTION_MODE_SUBTRACTION = 'multidecoder_tool_romannumbers_option_mode_usesubtraction';
const MDT_ROMANNUMBERS_OPTION_MODE_ADDITION = 'multidecoder_tool_romannumbers_option_mode_onlyaddition';

class MultiDecoderToolRomanNumbers extends AbstractMultiDecoderTool {
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
            configurationWidget: MultiDecoderToolConfiguration(widgets: {
              MDT_ROMANNUMBERS_OPTION_MODE: GCWStatefulDropDown(
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
