import 'package:flutter/material.dart';
import 'package:gc_wizard/widgets/tools/crypto_and_encodings/general_codebreakers/multi_decoder/gcw_multi_decoder_tool.dart';

const MDT_INTERNALNAMES_ASCII = 'multidecoder_tool_ascii_title';

class MultiDecoderToolASCII extends GCWMultiDecoderTool {
  MultiDecoderToolASCII({Key key, int id, String name, Map<String, dynamic> options})
      : super(
            key: key,
            id: id,
            name: name,
            internalToolName: MDT_INTERNALNAMES_ASCII,
            onDecode: (String input) {
              return String.fromCharCodes(input.split(RegExp(r'[^0-9]')).map((value) => int.tryParse(value)).toList());
            },
            options: options);
}
