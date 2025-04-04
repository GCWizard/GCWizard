import 'package:flutter/material.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/esoteric_programming_languages/whitespace_language/logic/whitespace_language.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/general_codebreakers/multi_decoder/widget/multi_decoder.dart';

const MDT_INTERNALNAMES_ESOTERIC_LANGUAGE_WHITESPACE = 'whitespace_language_title';

class MultiDecoderToolEsotericLanguageWhitespace extends AbstractMultiDecoderTool {
  MultiDecoderToolEsotericLanguageWhitespace(
      {super.key, required super.id, required super.name, required super.options})
      : super(
            internalToolName: MDT_INTERNALNAMES_ESOTERIC_LANGUAGE_WHITESPACE,
            optionalKey: true,
            onDecode: (String input, String key) {
              try {
                var outputFuture = interpreterWhitespace(input, key, timeOut: 1000);
                return outputFuture.then((output) => (output.error || output.output.isEmpty) ? null : output.output);
              } catch (e) {}
              return null;
            });
  @override
  State<StatefulWidget> createState() => _MultiDecoderToolEsotericLanguageWhitespaceState();
}

class _MultiDecoderToolEsotericLanguageWhitespaceState extends State<MultiDecoderToolEsotericLanguageWhitespace> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
