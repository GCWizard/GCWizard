import 'package:flutter/material.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/general_codebreakers/multi_decoder/widget/multi_decoder.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/roman_numbers/chronogram/logic/chronogram.dart';

const MDT_INTERNALNAMES_CHRONOGRAM = 'multidecoder_tool_chronogram_title';

class MultiDecoderToolChronogram extends AbstractMultiDecoderTool {
  MultiDecoderToolChronogram({Key key, int id, String name, Map<String, dynamic> options})
      : super(
            key: key,
            id: id,
            name: name,
            internalToolName: MDT_INTERNALNAMES_CHRONOGRAM,
            onDecode: (String input, String key) {
              return decodeChronogram(input);
            },
            options: options);
}
