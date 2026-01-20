import 'package:flutter/material.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/general_codebreakers/multi_decoder/widget/multi_decoder.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/roman_numbers/chronogram/logic/chronogram.dart';

const MDT_INTERNALNAMES_CHRONOGRAM = 'multidecoder_tool_chronogram_title';

class MultiDecoderToolChronogram extends AbstractMultiDecoderTool {
  MultiDecoderToolChronogram({super.key, required super.id, required super.name, required super.options})
      : super(
            internalToolName: MDT_INTERNALNAMES_CHRONOGRAM,
            onDecode: (String input, String key) {
              return decodeChronogram(input);
            });
  @override
  State<StatefulWidget> createState() => _MultiDecoderToolChronogramState();
}

class _MultiDecoderToolChronogramState extends State<MultiDecoderToolChronogram> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
