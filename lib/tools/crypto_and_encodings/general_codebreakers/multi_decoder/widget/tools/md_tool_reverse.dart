import 'package:flutter/material.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/general_codebreakers/multi_decoder/widget/multi_decoder.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/reverse/logic/reverse.dart';

const MDT_INTERNALNAMES_REVERSE = 'multidecoder_tool_reverse_title';

class MultiDecoderToolReverse extends AbstractMultiDecoderTool {
  MultiDecoderToolReverse({
    Key? key,
    required int id,
    required String name,
    required Map<String, Object?> options})
      : super(
            key: key,
            id: id,
            name: name,
            internalToolName: MDT_INTERNALNAMES_REVERSE,
            onDecode: (String input, String key) {
              return reverse(input);
            },
            options: options);
}
