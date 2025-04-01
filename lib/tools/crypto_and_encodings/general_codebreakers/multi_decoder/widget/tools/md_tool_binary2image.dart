import 'package:flutter/material.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/general_codebreakers/multi_decoder/widget/multi_decoder.dart';
import 'package:gc_wizard/tools/images_and_files/binary2image/logic/binary2image.dart';
import 'package:gc_wizard/utils/ui_dependent_utils/image_utils/image_utils.dart';

const MDT_INTERNALNAMES_BINARY2IMAGE = 'multidecoder_tool_binary2image_title';

class MultiDecoderBinary2Image extends AbstractMultiDecoderTool {
  MultiDecoderBinary2Image({super.key, required super.id, required super.name, required super.options})
      : super(
            internalToolName: MDT_INTERNALNAMES_BINARY2IMAGE,
            onDecode: (String input, String key) async {
              var output = binary2image(input, false, false);
              if (output == null) return null;
              return input2Image(output);
            });
  @override
  State<StatefulWidget> createState() => _MultiDecoderBinary2ImageState();
}

class _MultiDecoderBinary2ImageState extends State<MultiDecoderBinary2Image> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
