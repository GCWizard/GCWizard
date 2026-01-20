import 'package:flutter/material.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/beghilos/logic/beghilos.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/general_codebreakers/multi_decoder/widget/multi_decoder.dart';

const MDT_INTERNALNAMES_BEGHILOS = 'multidecoder_tool_beghilos_title';

class MultiDecoderToolBeghilos extends AbstractMultiDecoderTool {
  MultiDecoderToolBeghilos({super.key, required super.id, required super.name, required super.options})
      : super(
            internalToolName: MDT_INTERNALNAMES_BEGHILOS,
            onDecode: (String input, String key) {
              return decodeBeghilos(input, BeghilosType.LOWER_G_TO_SIX);
            });
  @override
  State<StatefulWidget> createState() => _MultiDecoderToolBeghilosState();
}

class _MultiDecoderToolBeghilosState extends State<MultiDecoderToolBeghilos> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
