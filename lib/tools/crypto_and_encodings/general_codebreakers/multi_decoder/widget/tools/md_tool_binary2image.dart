import 'package:flutter/material.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/general_codebreakers/multi_decoder/widget/multi_decoder.dart';
import 'package:gc_wizard/tools/images_and_files/binary2image/logic/binary2image.dart';
import 'package:gc_wizard/utils/ui_dependent_utils/image_utils/image_utils.dart';

const MDT_INTERNALNAMES_BINARY2IMAGE = 'multidecoder_tool_binary2image_title';

class MultiDecoderBinary2Image extends AbstractMultiDecoderTool {
  MultiDecoderBinary2Image({Key? key, required int id, required String name, required Map<String, Object?> options})
      : super(
            key: key,
            id: id,
            name: name,
            internalToolName: MDT_INTERNALNAMES_BINARY2IMAGE,
            onDecode: (String input, String key) async {
              var output = binary2image(input, false, false);
              if (output == null) return null;
              return input2Image(output);
            },
            options: options);
  @override
  State<StatefulWidget> createState() => _MultiDecoderBinary2ImageState();
}

class _MultiDecoderBinary2ImageState extends State<MultiDecoderBinary2Image> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
