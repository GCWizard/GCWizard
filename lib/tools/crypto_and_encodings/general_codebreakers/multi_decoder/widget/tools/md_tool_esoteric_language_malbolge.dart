import 'package:flutter/material.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/esoteric_programming_languages/malbolge/logic/malbolge.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/general_codebreakers/multi_decoder/widget/multi_decoder.dart';

const MDT_INTERNALNAMES_ESOTERIC_LANGUAGE_MALBOLGE = 'malbolge_title';

class MultiDecoderToolEsotericLanguageMalbolge extends AbstractMultiDecoderTool {
  MultiDecoderToolEsotericLanguageMalbolge(
      {super.key, required super.id, required super.name, required super.options})
      : super(
            internalToolName: MDT_INTERNALNAMES_ESOTERIC_LANGUAGE_MALBOLGE,
            optionalKey: true,
            onDecode: (String input, String key) {
              try {
                var outputList = interpretMalbolge(input, key, false);
                String output = '';
                for (var element in outputList.output) {
                  if (element == 'common_programming_error_invalid_program') {
                    return null;
                  } else if (!element.startsWith('malbolge_')) {
                    output = output + element + '\n';
                  }

                  output = output.trim();
                  return output.isEmpty ? null : output;
                }
              } catch (e) {}
              return null;
            });
  @override
  State<StatefulWidget> createState() => _MultiDecoderToolEsotericLanguageMalbolgeState();
}

class _MultiDecoderToolEsotericLanguageMalbolgeState extends State<MultiDecoderToolEsotericLanguageMalbolge> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
