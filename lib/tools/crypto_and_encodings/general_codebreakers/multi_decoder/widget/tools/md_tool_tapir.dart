import 'package:flutter/material.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/general_codebreakers/multi_decoder/widget/multi_decoder.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/tapir/logic/tapir.dart';

const MDT_INTERNALNAMES_TAPIR = 'multidecoder_tool_tapir_title';

class MultiDecoderToolTapir extends AbstractMultiDecoderTool {
  MultiDecoderToolTapir({super.key, required super.id, required super.name, required super.options})
      : super(
            internalToolName: MDT_INTERNALNAMES_TAPIR,
            onDecode: (String input, String key) {
              return decryptTapir(input, key);
            });
  @override
  State<StatefulWidget> createState() => _MultiDecoderToolTapirState();
}

class _MultiDecoderToolTapirState extends State<MultiDecoderToolTapir> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
