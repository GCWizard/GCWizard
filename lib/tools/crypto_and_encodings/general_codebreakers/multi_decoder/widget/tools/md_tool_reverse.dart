import 'package:flutter/material.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/general_codebreakers/multi_decoder/widget/multi_decoder.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/reverse/logic/reverse.dart';

const MDT_INTERNALNAMES_REVERSE = 'multidecoder_tool_reverse_title';

class MultiDecoderToolReverse extends AbstractMultiDecoderTool {
  MultiDecoderToolReverse({super.key, required super.id, required super.name, required super.options})
      : super(
            internalToolName: MDT_INTERNALNAMES_REVERSE,
            onDecode: (String input, String key) {
              return reverseAll(input);
            });
  @override
  State<StatefulWidget> createState() => _MultiDecoderToolReverseState();
}

class _MultiDecoderToolReverseState extends State<MultiDecoderToolReverse> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
