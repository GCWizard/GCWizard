import 'package:flutter/material.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/general_codebreakers/multi_decoder/widget/multi_decoder.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/rotation/logic/rotation.dart';

const MDT_INTERNALNAMES_ROT5 = 'multidecoder_tool_rot5_title';

class MultiDecoderToolROT5 extends AbstractMultiDecoderTool {
  MultiDecoderToolROT5({super.key, required super.id, required super.name, required super.options})
      : super(
            internalToolName: MDT_INTERNALNAMES_ROT5,
            onDecode: (String input, String key) {
              return Rotator().rot5(input);
            });
  @override
  State<StatefulWidget> createState() => _MultiDecoderToolROT5State();
}

class _MultiDecoderToolROT5State extends State<MultiDecoderToolROT5> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
