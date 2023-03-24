import 'package:flutter/material.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/general_codebreakers/multi_decoder/widget/multi_decoder.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/tapir/logic/tapir.dart';

const MDT_INTERNALNAMES_TAPIR = 'multidecoder_tool_tapir_title';

class MultiDecoderToolTapir extends AbstractMultiDecoderTool {
  MultiDecoderToolTapir({
    Key? key,
    required int id,
    required String name,
    required Map<String, Object?> options})
      : super(
            key: key,
            id: id,
            name: name,
            internalToolName: MDT_INTERNALNAMES_TAPIR,
            onDecode: (String input, String key) {
              return decryptTapir(input, key);
            },
            requiresKey: true,
            options: options);
}
