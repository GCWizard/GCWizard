import 'package:flutter/material.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/atbash/logic/atbash.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/general_codebreakers/multi_decoder/widget/multi_decoder.dart';

const MDT_INTERNALNAMES_ATBASH = 'multidecoder_tool_atbash_title';

class MultiDecoderToolAtbash extends AbstractMultiDecoderTool {
  MultiDecoderToolAtbash({super.key, required super.id, required super.name, required super.options})
      : super(
            internalToolName: MDT_INTERNALNAMES_ATBASH,
            onDecode: (String input, String key) {
              return atbash(input);
            });

  @override
  State<StatefulWidget> createState() => _MultiDecoderToolAtbashState();
}

class _MultiDecoderToolAtbashState extends State<MultiDecoderToolAtbash> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
