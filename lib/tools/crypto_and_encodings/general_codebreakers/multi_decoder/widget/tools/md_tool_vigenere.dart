import 'package:flutter/material.dart';
import 'package:gc_wizard/common_widgets/spinners/gcw_integer_spinner.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/general_codebreakers/multi_decoder/widget/multi_decoder.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/vigenere/logic/vigenere.dart';

const MDT_INTERNALNAMES_VIGENERE = 'multidecoder_tool_vigenere_title';
const MDT_VIGENERE_OPTION_KEY = 'onetimepad_keyoffset';

class MultiDecoderToolVigenere extends AbstractMultiDecoderTool {
  MultiDecoderToolVigenere({Key? key, required int id, required String name, required Map<String, Object?> options})
      : super(
            key: key,
            id: id,
            name: name,
            internalToolName: MDT_INTERNALNAMES_VIGENERE,
            onDecode: (String input, String key) {
              return decryptVigenere(input, key, false,
                  aValue:
                      checkIntFormatOrDefaultOption(MDT_INTERNALNAMES_VIGENERE, options, MDT_VIGENERE_OPTION_KEY) - 1);
            },
            requiresKey: true,
            options: options);

  @override
  State<StatefulWidget> createState() => _MultiDecoderToolVigenereState();
}

class _MultiDecoderToolVigenereState extends State<MultiDecoderToolVigenere> {
  @override
  Widget build(BuildContext context) {
    return createMultiDecoderToolConfiguration(context, {
      MDT_VIGENERE_OPTION_KEY: GCWIntegerSpinner(
          value: checkIntFormatOrDefaultOption(MDT_INTERNALNAMES_VIGENERE, widget.options, MDT_VIGENERE_OPTION_KEY),
          onChanged: (value) {
            setState(() {
              widget.options[MDT_VIGENERE_OPTION_KEY] = value;
            });
          })
    });
  }
}
