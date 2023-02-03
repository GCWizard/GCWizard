import 'package:flutter/material.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/general_codebreakers/multi_decoder/widget/multi_decoder.dart';

const MDT_INTERNALNAMES_ASCII = 'multidecoder_tool_ascii_title';

class MultiDecoderToolASCII extends AbstractMultiDecoderTool {
  MultiDecoderToolASCII({Key key, int id, String name, Map<String, dynamic> options})
      : super(
            key: key,
            id: id,
            name: name,
            internalToolName: MDT_INTERNALNAMES_ASCII,
            onDecode: (String input, String key) {
              return String.fromCharCodes(input.split(RegExp(r'[^0-9]')).map((value) => int.tryParse(value)).toList());
            },
            options: options);
}
