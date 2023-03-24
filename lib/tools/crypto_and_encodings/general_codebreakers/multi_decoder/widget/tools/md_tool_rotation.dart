import 'package:flutter/material.dart';
import 'package:gc_wizard/common_widgets/spinners/gcw_abc_spinner.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/general_codebreakers/multi_decoder/widget/multi_decoder.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/rotation/logic/rotator.dart';

const MDT_INTERNALNAMES_ROTATION = 'multidecoder_tool_rotation_title';
const MDT_ROTATION_OPTION_KEY = 'multidecoder_tool_rotation_option_key';

class MultiDecoderToolRotation extends AbstractMultiDecoderTool {
  MultiDecoderToolRotation({
    Key? key,
    required int id,
    required String name,
    required Map<String, Object?> options})
      : super(
            key: key,
            id: id,
            name: name,
            internalToolName: MDT_INTERNALNAMES_ROTATION,
            onDecode: (String input, String key) {
              return Rotator().rotate(input, checkIntFormatOrDefaultOption(MDT_INTERNALNAMES_ROTATION, options, MDT_ROTATION_OPTION_KEY));
            },
            options: options,
            configurationWidget: MultiDecoderToolConfiguration(widgets: {
              MDT_ROTATION_OPTION_KEY: GCWABCSpinner(
                value: checkIntFormatOrDefaultOption(MDT_INTERNALNAMES_ROTATION, options, MDT_ROTATION_OPTION_KEY),
                onChanged: (value) {
                  options[MDT_ROTATION_OPTION_KEY] = value;
                },
              )
            }));
}
