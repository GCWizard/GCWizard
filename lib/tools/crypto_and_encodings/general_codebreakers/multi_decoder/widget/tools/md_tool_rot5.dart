import 'package:flutter/material.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/general_codebreakers/multi_decoder/widget/multi_decoder.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/rotation/logic/rotator.dart';

const MDT_INTERNALNAMES_ROT5 = 'multidecoder_tool_rot5_title';

class MultiDecoderToolROT5 extends AbstractMultiDecoderTool {
  MultiDecoderToolROT5({
    Key? key,
    required int id,
    required String name,
    required Map<String, Object?> options})
      : super(
            key: key,
            id: id,
            name: name,
            internalToolName: MDT_INTERNALNAMES_ROT5,
            onDecode: (String input, String key) {
              return Rotator().rot5(input);
            },
            options: options);
}
