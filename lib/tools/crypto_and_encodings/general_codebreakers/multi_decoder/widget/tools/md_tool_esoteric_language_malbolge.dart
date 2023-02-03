import 'package:flutter/material.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/esoteric_programming_languages/malbolge/logic/malbolge.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/general_codebreakers/multi_decoder/widget/multi_decoder.dart';

const MDT_INTERNALNAMES_ESOTERIC_LANGUAGE_MALBOLGE = 'malbolge_title';

class MultiDecoderToolEsotericLanguageMalbolge extends AbstractMultiDecoderTool {
  MultiDecoderToolEsotericLanguageMalbolge({Key key, int id, String name, Map<String, dynamic> options})
      : super(
            key: key,
            id: id,
            name: name,
            internalToolName: MDT_INTERNALNAMES_ESOTERIC_LANGUAGE_MALBOLGE,
            optionalKey: true,
            onDecode: (String input, String key) {
              try {
                var outputList = interpretMalbolge(input, key, false);
                if (outputList != null) {
                  String output = '';
                  for (var element in outputList.output) {
                    if (element != null) if (element == 'common_programming_error_invalid_program')
                      return null;
                    else if (!element.startsWith('malbolge_')) output = output + element + '\n';
                  }

                  output = output.trim();
                  return output?.isEmpty ? null : output;
                }
              } catch (e) {}
              return null;
            },
            options: options);
}
