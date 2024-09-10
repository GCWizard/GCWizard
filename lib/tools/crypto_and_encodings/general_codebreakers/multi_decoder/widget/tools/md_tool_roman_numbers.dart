import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_dropdown.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/general_codebreakers/multi_decoder/widget/multi_decoder.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/roman_numbers/roman_numbers/logic/roman_numbers.dart';

const MDT_INTERNALNAMES_ROMANNUMBERS = 'multidecoder_tool_romannumbers_title';
const MDT_ROMANNUMBERS_OPTION_MODE = 'multidecoder_tool_romannumbers_option_mode';
const MDT_ROMANNUMBERS_OPTION_MODE_SUBTRACTION = 'multidecoder_tool_romannumbers_option_mode_usesubtraction';
const MDT_ROMANNUMBERS_OPTION_MODE_ADDITION = 'multidecoder_tool_romannumbers_option_mode_onlyaddition';

class MultiDecoderToolRomanNumbers extends AbstractMultiDecoderTool {
  MultiDecoderToolRomanNumbers(
      {Key? key,
      required int id,
      required String name,
      required Map<String, Object?> options})
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
            options: options);
  @override
  State<StatefulWidget> createState() => _MultiDecoderToolRomanNumbersState();
}

class _MultiDecoderToolRomanNumbersState extends State<MultiDecoderToolRomanNumbers> {
  @override
  Widget build(BuildContext context) {
    return createMultiDecoderToolConfiguration(context, {
      MDT_ROMANNUMBERS_OPTION_MODE: GCWDropDown<String>(
        value: checkStringFormatOrDefaultOption(
            MDT_INTERNALNAMES_ROMANNUMBERS, widget.options, MDT_ROMANNUMBERS_OPTION_MODE),
        onChanged: (newValue) {
          setState(() {
            widget.options[MDT_ROMANNUMBERS_OPTION_MODE] = newValue;
          });
        },
        items: RomanNumberType.values.map((type) {
          String key;
          switch (type) {
            case RomanNumberType.USE_SUBTRACTION_RULE:
              key = MDT_ROMANNUMBERS_OPTION_MODE_SUBTRACTION;
              break;
            case RomanNumberType.ONLY_ADDITION:
              key = MDT_ROMANNUMBERS_OPTION_MODE_ADDITION;
              break;
            default:
              key = MDT_ROMANNUMBERS_OPTION_MODE_ADDITION;
          }

          return GCWDropDownMenuItem(
            value: key,
            child: i18n(context, key),
          );
        }).toList(),
      ),
    });
  }
}
