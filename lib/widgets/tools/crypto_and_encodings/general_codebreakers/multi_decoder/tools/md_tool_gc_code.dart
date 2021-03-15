import 'package:flutter/material.dart';
import 'package:gc_wizard/i18n/app_localizations.dart';
import 'package:gc_wizard/logic/tools/crypto_and_encodings/gc_code.dart';
import 'package:gc_wizard/widgets/common/gcw_twooptions_switch.dart';
import 'package:gc_wizard/widgets/tools/crypto_and_encodings/general_codebreakers/multi_decoder/gcw_multi_decoder_tool.dart';
import 'package:gc_wizard/widgets/tools/crypto_and_encodings/general_codebreakers/multi_decoder/gcw_multi_decoder_tool_configuration.dart';

const MDT_INTERNALNAMES_GCCODE = 'multidecoder_tool_gccode_title';
const MDT_GCCODE_OPTION_MODE = 'multidecoder_tool_gccode_option_mode';
const MDT_GCCODE_OPTION_MODE_IDTOGCCODE = 'multidecoder_tool_gccode_option_mode_id.to.gccode';
const MDT_GCCODE_OPTION_MODE_GCCODETOID = 'multidecoder_tool_gccode_option_mode_gccode.to.id';

class MultiDecoderToolGCCode extends GCWMultiDecoderTool {
  MultiDecoderToolGCCode({Key key, int id, String name, Map<String, dynamic> options, BuildContext context})
      : super(
            key: key,
            id: id,
            name: name,
            internalToolName: MDT_INTERNALNAMES_GCCODE,
            onDecode: (input) {
              if (options[MDT_GCCODE_OPTION_MODE] == MDT_GCCODE_OPTION_MODE_IDTOGCCODE)
                return idToGCCode(int.tryParse(input));
              else
                return gcCodeToID(input);
            },
            options: options,
            configurationWidget: GCWMultiDecoderToolConfiguration(widgets: {
              MDT_GCCODE_OPTION_MODE: GCWTwoOptionsSwitch(
                value: options[MDT_GCCODE_OPTION_MODE] == MDT_GCCODE_OPTION_MODE_IDTOGCCODE
                    ? GCWSwitchPosition.left
                    : GCWSwitchPosition.right,
                notitle: true,
                leftValue: i18n(context, MDT_GCCODE_OPTION_MODE_IDTOGCCODE),
                rightValue: i18n(context, MDT_GCCODE_OPTION_MODE_GCCODETOID),
                onChanged: (value) {
                  options[MDT_GCCODE_OPTION_MODE] = value == GCWSwitchPosition.left
                      ? MDT_GCCODE_OPTION_MODE_IDTOGCCODE
                      : MDT_GCCODE_OPTION_MODE_GCCODETOID;
                },
              )
            }));
}
