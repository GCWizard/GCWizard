import 'package:flutter/material.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/atbash/logic/atbash.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/general_codebreakers/multi_decoder/widget/multi_decoder.dart';

const MDT_INTERNALNAMES_ATBASH = 'multidecoder_tool_atbash_title';

class MultiDecoderToolAtbash extends AbstractMultiDecoderTool {
  MultiDecoderToolAtbash({
    Key? key,
    required int id,
    required String name,
    required Map<String, Object?> options})
      : super(
            key: key,
            id: id,
            name: name,
            internalToolName: MDT_INTERNALNAMES_ATBASH,
            onDecode: (String input, String key) {
              return atbash(input);
            },
            options: options);
}
