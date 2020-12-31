import 'package:flutter/material.dart';
import 'package:gc_wizard/i18n/app_localizations.dart';
import 'package:gc_wizard/logic/tools/crypto_and_encodings/alphabet_values.dart' as logic;
import 'package:gc_wizard/utils/alphabets.dart';
import 'package:gc_wizard/utils/constants.dart';
import 'package:gc_wizard/widgets/common/base/gcw_dropdownbutton.dart';
import 'package:gc_wizard/widgets/common/gcw_stateful_dropdownbutton.dart';
import 'package:gc_wizard/widgets/tools/crypto_and_encodings/general_codebreakers/multi_decoder/gcw_multi_decoder_tool.dart';
import 'package:gc_wizard/widgets/tools/crypto_and_encodings/general_codebreakers/multi_decoder/gcw_multi_decoder_tool_configuration.dart';

const MDT_INTERNALNAMES_ALPHABETVALUES = 'multidecoder_tool_alphabetvalues_title';
const MDT_ALPHABETVALUES_OPTION_ALPHABET = 'multidecoder_tool_alphabetvalues_option_alphabet';

class MultiDecoderToolAlphabetValues extends GCWMultiDecoderTool {

  MultiDecoderToolAlphabetValues({Key key, int id, String name, Map<String, dynamic> options, BuildContext context}) :
    super(
      key: key,
      id: id,
      name: name,
      internalToolName: MDT_INTERNALNAMES_ALPHABETVALUES,
      onDecode: (String input) {
        var alphabet = ALL_ALPHABETS.firstWhere((alphabet) => alphabet.key == options[MDT_ALPHABETVALUES_OPTION_ALPHABET]).alphabet;

        return logic.AlphabetValues(alphabet: alphabet).valuesToText(
          input.split(RegExp(r'[^0-9]')).map((value) => int.tryParse(value)).toList()
        ).replaceAll(UNKNOWN_ELEMENT, '');
      },
      options: options,
      configurationWidget: GCWMultiDecoderToolConfiguration(
        widgets: {
          MDT_ALPHABETVALUES_OPTION_ALPHABET: GCWStatefulDropDownButton(
            value: options[MDT_ALPHABETVALUES_OPTION_ALPHABET],
            items: ALL_ALPHABETS.map((alphabet) {
              return GCWDropDownMenuItem(
                value: alphabet.key,
                child: alphabet.type == AlphabetType.STANDARD ? i18n(context, alphabet.key) : alphabet.name
              );
            }).toList(),
            onChanged: (value) {
              options[MDT_ALPHABETVALUES_OPTION_ALPHABET] = value;
            },
          )
        }
      )
    );
}