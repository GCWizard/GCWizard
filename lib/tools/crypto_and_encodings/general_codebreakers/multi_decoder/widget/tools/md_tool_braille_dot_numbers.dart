import 'package:flutter/material.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/braille/logic/braille.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/general_codebreakers/multi_decoder/widget/multi_decoder.dart';

const MDT_INTERNALNAMES_BRAILLE_DOT_NUMBERS = 'multidecoder_tool_braille_dot_numbers_title';

class MultiDecoderToolBrailleDotNumbers extends AbstractMultiDecoderTool {
  MultiDecoderToolBrailleDotNumbers({Key key, int id, String name, Map<String, dynamic> options})
      : super(
            key: key,
            id: id,
            name: name,
            internalToolName: MDT_INTERNALNAMES_BRAILLE_DOT_NUMBERS,
            onDecode: (String input, String key) {
              var segments = decodeBraille(input.split(RegExp(r'\s+')).toList(), BrailleLanguage.SIMPLE, true);
              var out = segments['chars'].join();
              if (out is String) {
                var out1 = out.replaceAll('<?>', '');
                out1 = out.replaceAll(' ', '');
                if (out1 == null || out1.length == 0) return null;
              }
              return out;
            },
            options: options);
}
