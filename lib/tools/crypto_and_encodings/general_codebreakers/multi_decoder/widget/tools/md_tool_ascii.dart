import 'package:flutter/material.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/general_codebreakers/multi_decoder/widget/multi_decoder.dart';

const MDT_INTERNALNAMES_ASCII = 'multidecoder_tool_ascii_title';

class MultiDecoderToolASCII extends AbstractMultiDecoderTool {
  MultiDecoderToolASCII({super.key, required super.id, required super.name, required super.options})
      : super(
            internalToolName: MDT_INTERNALNAMES_ASCII,
            onDecode: (String input, String key) {
              return String.fromCharCodes(input.split(RegExp(r'\D')).map((value) => int.tryParse(value) ?? 0).toList());
            });

  @override
  State<StatefulWidget> createState() => _MultiDecoderToolASCIIState();
}

class _MultiDecoderToolASCIIState extends State<MultiDecoderToolASCII> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
