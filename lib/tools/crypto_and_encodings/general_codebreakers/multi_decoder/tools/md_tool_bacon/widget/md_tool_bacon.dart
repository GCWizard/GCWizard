import 'package:flutter/material.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/bacon/logic/bacon.dart';
import 'package:gc_wizard/tools/common/base/gcw_dropdownbutton/widget/gcw_dropdownbutton.dart';
import 'package:gc_wizard/tools/common/gcw_stateful_dropdownbutton/widget/gcw_stateful_dropdownbutton.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/general_codebreakers/multi_decoder/gcw_multi_decoder_tool/widget/gcw_multi_decoder_tool.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/general_codebreakers/multi_decoder/gcw_multi_decoder_tool_configuration/widget/gcw_multi_decoder_tool_configuration.dart';

const MDT_INTERNALNAMES_BACON = 'multidecoder_tool_bacon_title';
const MDT_BACON_OPTION_MODE = 'multidecoder_tool_bacon_option_mode';
const MDT_BACON_OPTION_MODE_01 = '01';
const MDT_BACON_OPTION_MODE_AB = 'AB';

class MultiDecoderToolBacon extends GCWMultiDecoderTool {
  MultiDecoderToolBacon({Key key, int id, String name, Map<String, dynamic> options})
      : super(
            key: key,
            id: id,
            name: name,
            internalToolName: MDT_INTERNALNAMES_BACON,
            onDecode: (String input, String key) {
              return decodeBacon(input, false, options[MDT_BACON_OPTION_MODE] == MDT_BACON_OPTION_MODE_01);
            },
            options: options,
            configurationWidget: GCWMultiDecoderToolConfiguration(widgets: {
              MDT_BACON_OPTION_MODE: GCWStatefulDropDownButton(
                value: options[MDT_BACON_OPTION_MODE],
                onChanged: (newValue) {
                  options[MDT_BACON_OPTION_MODE] = newValue;
                },
                items: [MDT_BACON_OPTION_MODE_01, MDT_BACON_OPTION_MODE_AB].map((mode) {
                  return GCWDropDownMenuItem(
                    value: mode,
                    child: mode,
                  );
                }).toList(),
              )
            }));
}
