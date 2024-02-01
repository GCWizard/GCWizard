import 'package:flutter/material.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/general_codebreakers/multi_decoder/widget/multi_decoder.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/rotation/logic/rotation.dart';

const MDT_INTERNALNAMES_ROT18 = 'multidecoder_tool_rot18_title';

class MultiDecoderToolROT18 extends AbstractMultiDecoderTool {
  MultiDecoderToolROT18({Key? key, required int id, required String name, required Map<String, Object?> options})
      : super(
            key: key,
            id: id,
            name: name,
            internalToolName: MDT_INTERNALNAMES_ROT18,
            onDecode: (String input, String key) {
              return Rotator().rot18(input);
            },
            options: options);
  @override
  State<StatefulWidget> createState() => _MultiDecoderToolROT18State();
}

class _MultiDecoderToolROT18State extends State<MultiDecoderToolROT18> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
