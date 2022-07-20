import 'package:flutter/material.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/logic/braille.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/general_codebreakers/multi_decoder/gcw_multi_decoder_tool/widget/gcw_multi_decoder_tool.dart';

const MDT_INTERNALNAMES_BRAILLE_DOT_NUMBERS = 'multidecoder_tool_braille_dot_numbers_title';

class MultiDecoderToolBrailleDotNumbers extends GCWMultiDecoderTool {
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
                var out1 = (out as String).replaceAll('<?>', '');
                out1 = (out as String).replaceAll(' ', '');
                if (out1 == null || (out1 as String).length == 0) return null;
              }
              return out;
            },
            options: options);
}
