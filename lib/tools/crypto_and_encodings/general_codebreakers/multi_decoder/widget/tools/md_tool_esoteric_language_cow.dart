import 'package:flutter/material.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/esoteric_programming_languages/cow/logic/cow.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/general_codebreakers/multi_decoder/widget/multi_decoder.dart';

const MDT_INTERNALNAMES_ESOTERIC_LANGUAGE_COW = 'cow_title';

class MultiDecoderToolEsotericLanguageCow extends AbstractMultiDecoderTool {
  MultiDecoderToolEsotericLanguageCow(
      {super.key, required super.id, required super.name, required super.options})
      : super(
            internalToolName: MDT_INTERNALNAMES_ESOTERIC_LANGUAGE_COW,
            optionalKey: true,
            onDecode: (String input, String key) {
              try {
                CowOutput output = interpretCow(input, STDIN: key);
                if (output.error.isEmpty) return output.output.isEmpty ? null : output.output;
              } catch (e) {}
              return null;
            });
  @override
  State<StatefulWidget> createState() => _MultiDecoderToolEsotericLanguageCowState();
}

class _MultiDecoderToolEsotericLanguageCowState extends State<MultiDecoderToolEsotericLanguageCow> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
