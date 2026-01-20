import 'package:flutter/material.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/echo/logic/echo.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/general_codebreakers/multi_decoder/widget/multi_decoder.dart';

const MDT_INTERNALNAMES_ECHO = 'multidecoder_tool_echo_title';

class MultiDecoderToolEcho extends AbstractMultiDecoderTool {
  MultiDecoderToolEcho({super.key, required super.id, required super.name, required super.options})
      : super(
            internalToolName: MDT_INTERNALNAMES_ECHO,
            onDecode: (String input, String key) {
              var out = decryptEcho(input, key);
              if (out.state != EchoState.OK) {
                return null;
              }
              return decryptEcho(input, key).output;
            },
            optionalKey: true);
  @override
  State<StatefulWidget> createState() => _MultiDecoderToolEchoState();
}

class _MultiDecoderToolEchoState extends State<MultiDecoderToolEcho> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
