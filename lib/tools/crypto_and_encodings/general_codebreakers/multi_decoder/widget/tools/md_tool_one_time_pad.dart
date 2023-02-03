import 'package:flutter/material.dart';
import 'package:gc_wizard/common_widgets/spinners/gcw_integer_spinner.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/general_codebreakers/multi_decoder/widget/multi_decoder.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/one_time_pad/logic/one_time_pad.dart';

const MDT_INTERNALNAMES_ONETIMEPAD = 'multidecoder_tool_onetimepad_title';
const MDT_ONETIMEPAD_OPTION_KEY = 'onetimepad_keyoffset';

class MultiDecoderToolOneTimePad extends AbstractMultiDecoderTool {
  MultiDecoderToolOneTimePad({Key key, int id, String name, Map<String, dynamic> options})
      : super(
            key: key,
            id: id,
            name: name,
            internalToolName: MDT_INTERNALNAMES_ONETIMEPAD,
            onDecode: (String input, String key) {
              return decryptOneTimePad(input, key, keyOffset: options[MDT_ONETIMEPAD_OPTION_KEY] - 1);
            },
            requiresKey: true,
            options: options,
            configurationWidget: MultiDecoderToolConfiguration(widgets: {
              MDT_ONETIMEPAD_OPTION_KEY: GCWIntegerSpinner(
                  value: options[MDT_ONETIMEPAD_OPTION_KEY],
                  onChanged: (value) {
                    options[MDT_ONETIMEPAD_OPTION_KEY] = value;
                  }),
            }));
}
