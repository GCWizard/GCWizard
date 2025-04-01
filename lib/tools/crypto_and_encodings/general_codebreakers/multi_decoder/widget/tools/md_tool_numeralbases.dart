import 'package:flutter/material.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/general_codebreakers/multi_decoder/widget/multi_decoder.dart';
import 'package:gc_wizard/tools/science_and_technology/numeral_bases/logic/numeral_bases.dart';
import 'package:gc_wizard/tools/science_and_technology/numeral_bases/widget/numeralbase_spinner.dart';

const MDT_INTERNALNAMES_NUMERALBASES = 'multidecoder_tool_numeralbases_title';
const MDT_NUMERALBASES_OPTION_FROM = 'multidecoder_tool_numeralbases_option_from';

class MultiDecoderToolNumeralBases extends AbstractMultiDecoderTool {
  MultiDecoderToolNumeralBases({super.key, required super.id, required super.name, required super.options})
      : super(
            internalToolName: MDT_INTERNALNAMES_NUMERALBASES,
            onDecode: (String input, String key) {
              return input
                  .split(RegExp(r'\s+'))
                  .where((element) => element.isNotEmpty)
                  .map((element) => convertBase(
                      element,
                      checkIntFormatOrDefaultOption(
                          MDT_INTERNALNAMES_NUMERALBASES, options, MDT_NUMERALBASES_OPTION_FROM),
                      10))
                  .join(' ')
                  .trim();
            });
  @override
  State<StatefulWidget> createState() => _MultiDecoderToolNumeralBasesState();
}

class _MultiDecoderToolNumeralBasesState extends State<MultiDecoderToolNumeralBases> {
  @override
  Widget build(BuildContext context) {
    return createMultiDecoderToolConfiguration(context, {
      MDT_NUMERALBASES_OPTION_FROM: NumeralBaseSpinner(
        value:
            checkIntFormatOrDefaultOption(MDT_INTERNALNAMES_NUMERALBASES, widget.options, MDT_NUMERALBASES_OPTION_FROM),
        onChanged: (value) {
          setState(() {
            widget.options[MDT_NUMERALBASES_OPTION_FROM] = value;
          });
        },
      )
    });
  }
}
