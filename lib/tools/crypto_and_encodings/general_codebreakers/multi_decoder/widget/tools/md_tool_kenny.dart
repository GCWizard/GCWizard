import 'package:flutter/material.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/general_codebreakers/multi_decoder/widget/multi_decoder.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/kenny/logic/kenny.dart';

const MDT_INTERNALNAMES_KENNY = 'multidecoder_tool_kenny_title';

class MultiDecoderToolKenny extends AbstractMultiDecoderTool {
  MultiDecoderToolKenny({super.key, required super.id, required super.name, required super.options})
      : super(
            internalToolName: MDT_INTERNALNAMES_KENNY,
            onDecode: (String input, String key) {
              return decryptKenny(input, ['m', 'p', 'f'], true);
            });
  @override
  State<StatefulWidget> createState() => _MultiDecoderToolKennyState();
}

class _MultiDecoderToolKennyState extends State<MultiDecoderToolKenny> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
