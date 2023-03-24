import 'package:flutter/material.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_dropdown.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_stateful_dropdown.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/bacon/logic/bacon.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/general_codebreakers/multi_decoder/widget/multi_decoder.dart';

const MDT_INTERNALNAMES_BACON = 'multidecoder_tool_bacon_title';
const MDT_BACON_OPTION_MODE = 'multidecoder_tool_bacon_option_mode';
const MDT_BACON_OPTION_MODE_01 = '01';
const MDT_BACON_OPTION_MODE_AB = 'AB';

class MultiDecoderToolBacon extends AbstractMultiDecoderTool {
  MultiDecoderToolBacon({
    Key? key,
    required int id,
    required String name,
    required Map<String, Object?> options})
      : super(
            key: key,
            id: id,
            name: name,
            internalToolName: MDT_INTERNALNAMES_BACON,
            onDecode: (String input, String key) {
              return decodeBacon(input, false, checkStringFormatOrDefaultOption(MDT_INTERNALNAMES_BACON, options, MDT_BACON_OPTION_MODE) == MDT_BACON_OPTION_MODE_01);
            },
            options: options,
            configurationWidget: MultiDecoderToolConfiguration(widgets: {
              MDT_BACON_OPTION_MODE: GCWStatefulDropDown<String>(
                value: checkStringFormatOrDefaultOption(MDT_INTERNALNAMES_BACON, options, MDT_BACON_OPTION_MODE),
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
