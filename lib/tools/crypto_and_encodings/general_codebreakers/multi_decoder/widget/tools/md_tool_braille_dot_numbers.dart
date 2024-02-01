import 'package:flutter/material.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/braille/logic/braille.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/general_codebreakers/multi_decoder/widget/multi_decoder.dart';
import 'package:gc_wizard/utils/constants.dart';

const MDT_INTERNALNAMES_BRAILLE_DOT_NUMBERS = 'multidecoder_tool_braille_dot_numbers_title';

class MultiDecoderToolBrailleDotNumbers extends AbstractMultiDecoderTool {
  MultiDecoderToolBrailleDotNumbers(
      {Key? key, required int id, required String name, required Map<String, Object?> options})
      : super(
            key: key,
            id: id,
            name: name,
            internalToolName: MDT_INTERNALNAMES_BRAILLE_DOT_NUMBERS,
            onDecode: (String input, String key) {
              var segments = decodeBraille(input.split(RegExp(r'\s+')).toList(), BrailleLanguage.SIMPLE, true);
              var out = segments.chars.join();
              var out1 = out.replaceAll(UNKNOWN_ELEMENT, '');
              out1 = out.replaceAll(' ', '');
              if (out1.isEmpty) return null;
              return out;
            },
            options: options);
  @override
  State<StatefulWidget> createState() => _MultiDecoderToolBrailleDotNumbersState();
}

class _MultiDecoderToolBrailleDotNumbersState extends State<MultiDecoderToolBrailleDotNumbers> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
