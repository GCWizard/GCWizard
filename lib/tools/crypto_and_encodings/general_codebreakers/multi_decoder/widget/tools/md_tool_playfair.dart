import 'package:flutter/material.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_alphabetmodification_dropdown.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/general_codebreakers/multi_decoder/widget/multi_decoder.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/_common/logic/crypt_alphabet_modification.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/playfair/logic/playfair.dart';

const MDT_INTERNALNAMES_PLAYFAIR = 'multidecoder_tool_playfair_title';
const MDT_PLAYFAIR_OPTION_MODE = 'multidecoder_tool_playfair_option_mode';

class MultiDecoderToolPlayfair extends AbstractMultiDecoderTool {
  MultiDecoderToolPlayfair({Key key, int id, String name, Map<String, dynamic> options})
      : super(
            key: key,
            id: id,
            name: name,
            internalToolName: MDT_INTERNALNAMES_PLAYFAIR,
            onDecode: (String input, String key) {
              return decryptPlayfair(input, key, mode: _parseStringToEnum(options[MDT_PLAYFAIR_OPTION_MODE]));
            },
            requiresKey: true,
            options: options,
            configurationWidget: MultiDecoderToolConfiguration(widgets: {
              MDT_PLAYFAIR_OPTION_MODE: GCWAlphabetModificationDropDown(
                suppressTitle: true,
                value: _parseStringToEnum(options[MDT_PLAYFAIR_OPTION_MODE]),
                allowedModifications: [
                  AlphabetModificationMode.J_TO_I,
                  AlphabetModificationMode.W_TO_VV,
                  AlphabetModificationMode.C_TO_K
                ],
                onChanged: (newValue) {
                  options[MDT_PLAYFAIR_OPTION_MODE] = alphabetModeName(newValue);
                },
              )
            }));
}

AlphabetModificationMode _parseStringToEnum(String item) {
  return AlphabetModificationMode.values.firstWhere((e) => alphabetModeName(e) == item);
}

String alphabetModeName(AlphabetModificationMode item) {
  if (item == null) return null;
  return item
      .toString()
      .replaceAll('AlphabetModificationMode.', '')
      .replaceAll('_TO_', ' → ')
      .replaceAll('REMOVE_', 'Ignore ');
}
