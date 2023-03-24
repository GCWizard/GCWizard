import 'package:flutter/material.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/beghilos/logic/beghilos.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/general_codebreakers/multi_decoder/widget/multi_decoder.dart';

const MDT_INTERNALNAMES_BEGHILOS = 'multidecoder_tool_beghilos_title';

class MultiDecoderToolBeghilos extends AbstractMultiDecoderTool {
  MultiDecoderToolBeghilos({
    Key? key,
    required int id,
    required String name,
    required Map<String, Object?> options})
      : super(
            key: key,
            id: id,
            name: name,
            internalToolName: MDT_INTERNALNAMES_BEGHILOS,
            onDecode: (String input, String key) {
              return decodeBeghilos(input);
            },
            options: options);
}
