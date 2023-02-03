import 'package:flutter/material.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_alphabetmodification_dropdown.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/general_codebreakers/multi_decoder/widget/multi_decoder.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/general_codebreakers/multi_decoder/widget/tools/md_tool_playfair.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/_common/logic/crypt_alphabet_modification.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/polybios/logic/polybios.dart';

const MDT_INTERNALNAMES_POLYBIOS = 'multidecoder_tool_polybios_title';
const MDT_POLYBIOS_OPTION_MODE = 'multidecoder_tool_polybios_option_mode';

class MultiDecoderToolPolybios extends AbstractMultiDecoderTool {
  MultiDecoderToolPolybios(
      {Key key, int id, String name, Map<String, dynamic> options})
      : super(
            key: key,
            id: id,
            name: name,
            internalToolName: MDT_INTERNALNAMES_POLYBIOS,
            onDecode: (String input, String key) {
              var polybiosOutput = decryptPolybios(input, key,
                  mode: PolybiosMode.AZ09,
                  modificationMode:
                      _parseStringToEnum(options[MDT_POLYBIOS_OPTION_MODE]));
              return polybiosOutput == null ? null : polybiosOutput.output;
            },
            requiresKey: true,
            options: options,
            configurationWidget: MultiDecoderToolConfiguration(widgets: {
              MDT_POLYBIOS_OPTION_MODE: GCWAlphabetModificationDropDown(
                suppressTitle: true,
                value: _parseStringToEnum(options[MDT_POLYBIOS_OPTION_MODE]),
                onChanged: (newValue) {
                  options[MDT_POLYBIOS_OPTION_MODE] =
                      alphabetModeName(newValue);
                },
              )
            }));
}

AlphabetModificationMode _parseStringToEnum(String item) {
  return AlphabetModificationMode.values
      .firstWhere((e) => alphabetModeName(e) == item);
}
