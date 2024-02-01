import 'package:flutter/material.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/esoteric_programming_languages/hohoho/logic/hohoho.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/general_codebreakers/multi_decoder/widget/multi_decoder.dart';

const MDT_INTERNALNAMES_ESOTERIC_LANGUAGE_HOHOHO = 'hohoho_title';

class MultiDecoderToolEsotericLanguageHohoho extends AbstractMultiDecoderTool {
  MultiDecoderToolEsotericLanguageHohoho(
      {Key? key, required int id, required String name, required Map<String, Object?> options})
      : super(
            key: key,
            id: id,
            name: name,
            internalToolName: MDT_INTERNALNAMES_ESOTERIC_LANGUAGE_HOHOHO,
            optionalKey: true,
            onDecode: (String input, String key) {
              try {
                var output = interpretHohoho(input, STDIN: key);
                return output.output;
              } catch (e) {}
              return null;
            },
            options: options);
  @override
  State<StatefulWidget> createState() => _MultiDecoderToolEsotericLanguageHohohoState();
}

class _MultiDecoderToolEsotericLanguageHohohoState extends State<MultiDecoderToolEsotericLanguageHohoho> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
