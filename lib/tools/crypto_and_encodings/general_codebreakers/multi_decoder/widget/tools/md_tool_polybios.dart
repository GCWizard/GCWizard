import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_alphabetmodification_dropdown.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/_common/logic/crypt_alphabet_modification.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/general_codebreakers/multi_decoder/widget/multi_decoder.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/general_codebreakers/multi_decoder/widget/tools/md_tool_playfair.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/polybios/logic/polybios.dart';

const MDT_INTERNALNAMES_POLYBIOS = 'multidecoder_tool_polybios_title';
const MDT_POLYBIOS_OPTION_MODE = 'multidecoder_tool_polybios_option_mode';

class MultiDecoderToolPolybios extends AbstractMultiDecoderTool {
  MultiDecoderToolPolybios({super.key, required super.id, required super.name, required super.options})
      : super(
            internalToolName: MDT_INTERNALNAMES_POLYBIOS,
            onDecode: (String input, String key) {
              var polybiosOutput = decryptPolybios(input, key, /* standard 5x5 */
                  mode: PolybiosMode.AZ09,
                  modificationMode:
                      _parseStringToEnum(stringNullableTypeCheck(options[MDT_POLYBIOS_OPTION_MODE], null)));
              return polybiosOutput?.output;
            },
            optionalKey: true);
  @override
  State<StatefulWidget> createState() => _MultiDecoderToolPolybiosState();
}

class _MultiDecoderToolPolybiosState extends State<MultiDecoderToolPolybios> {
  @override
  Widget build(BuildContext context) {
    return createMultiDecoderToolConfiguration(context, {
      MDT_POLYBIOS_OPTION_MODE: GCWAlphabetModificationDropDown(
        suppressTitle: true,
        value: _parseStringToEnum(stringNullableTypeCheck(widget.options[MDT_POLYBIOS_OPTION_MODE], null)),
        onChanged: (newValue) {
          setState(() {
            widget.options[MDT_POLYBIOS_OPTION_MODE] = alphabetModeName(newValue);
          });
        },
      )
    });
  }
}

AlphabetModificationMode _parseStringToEnum(String? item) {
  var result = AlphabetModificationMode.values.firstWhereOrNull((e) => alphabetModeName(e) == item);
  if (result != null) return result;
  var value =
      _parseStringToEnum((getDefaultValue(MDT_INTERNALNAMES_POLYBIOS, MDT_POLYBIOS_OPTION_MODE) ?? '').toString());
  return value;
}
