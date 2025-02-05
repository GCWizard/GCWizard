import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_dropdown.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/general_codebreakers/multi_decoder/widget/multi_decoder.dart';
import 'package:gc_wizard/tools/science_and_technology/periodic_table/_common/logic/periodic_table.dart';
import 'package:gc_wizard/utils/collection_utils.dart';

const MDT_INTERNALNAMES_ATOMICNUMBERS = 'multidecoder_tool_atomicnumbers_title';
const MDT_ATOMICNUMBERS_OPTION_MODE = 'multidecoder_tool_atomicnumbers_option_mode';
const MDT_ATOMICNUMBERS_OPTION_MODE_SYMBOLSTONUMBERS = 'multidecoder_tool_atomicnumbers_option_mode_symbolstonumbers';
const MDT_ATOMICNUMBERS_OPTION_MODE_NUMBERSTOSYMBOLS = 'multidecoder_tool_atomicnumbers_option_mode_numberstosymbols';

class MultiDecoderToolAtomicNumbers extends AbstractMultiDecoderTool {
  MultiDecoderToolAtomicNumbers(
      {Key? key,
      required int id,
      required String name,
      required Map<String, Object?> options})
      : super(
            key: key,
            id: id,
            name: name,
            internalToolName: MDT_INTERNALNAMES_ATOMICNUMBERS,
            onDecode: (String input, String key) {
              var symbolsToNumbers = options[MDT_ATOMICNUMBERS_OPTION_MODE] == MDT_ATOMICNUMBERS_OPTION_MODE_SYMBOLSTONUMBERS;

              if (symbolsToNumbers) {
                return textToAtomicNumbers(input).join(' ');
              } else {
                var numbers = textToIntList(input);
                return atomicNumbersToText(numbers);
              }
            },
            options: options);
  @override
  State<StatefulWidget> createState() => _MultiDecoderToolAtomicNumbersState();
}

class _MultiDecoderToolAtomicNumbersState extends State<MultiDecoderToolAtomicNumbers> {
  @override
  Widget build(BuildContext context) {
    return createMultiDecoderToolConfiguration(context, {
      MDT_ATOMICNUMBERS_OPTION_MODE: GCWDropDown<String>(
        value: checkStringFormatOrDefaultOption(
            MDT_INTERNALNAMES_ATOMICNUMBERS, widget.options, MDT_ATOMICNUMBERS_OPTION_MODE),
        onChanged: (newValue) {
          setState(() {
            widget.options[MDT_ATOMICNUMBERS_OPTION_MODE] = newValue;
          });
        },
        items: [MDT_ATOMICNUMBERS_OPTION_MODE_SYMBOLSTONUMBERS, MDT_ATOMICNUMBERS_OPTION_MODE_NUMBERSTOSYMBOLS].map((type) {
          return GCWDropDownMenuItem(
            value: type,
            child: i18n(context, type),
          );
        }).toList(),
      ),
    });
  }
}
