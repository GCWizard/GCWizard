import 'package:flutter/material.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/atbash/logic/atbash.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/general_codebreakers/multi_decoder/gcw_multi_decoder_tool/widget/gcw_multi_decoder_tool.dart';

const MDT_INTERNALNAMES_ATBASH = 'multidecoder_tool_atbash_title';

class MultiDecoderToolAtbash extends GCWMultiDecoderTool {
  MultiDecoderToolAtbash({Key key, int id, String name, Map<String, dynamic> options})
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
