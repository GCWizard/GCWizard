import 'package:flutter/material.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/general_codebreakers/multi_decoder/widget/multi_decoder.dart';
import 'package:gc_wizard/tools/images_and_files/binary2image/logic/binary2image.dart';

const MDT_INTERNALNAMES_BINARY2IMAGE = 'multidecoder_tool_binary2image_title';

class MultiDecoderBinary2Image extends AbstractMultiDecoderTool {
  MultiDecoderBinary2Image({Key key, int id, String name, Map<String, dynamic> options})
      : super(
            key: key,
            id: id,
            name: name,
            internalToolName: MDT_INTERNALNAMES_BINARY2IMAGE,
            onDecode: (String input, String key) async {
              return await binary2image(input, false, false);
            },
            options: options);
}
