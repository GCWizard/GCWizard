import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/app_localizations.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_dropdown.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_stateful_dropdown.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/gc_code/logic/gc_code.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/general_codebreakers/multi_decoder/widget/multi_decoder.dart';

const MDT_INTERNALNAMES_GCCODE = 'multidecoder_tool_gccode_title';
const MDT_GCCODE_OPTION_MODE = 'multidecoder_tool_gccode_option_mode';
const MDT_GCCODE_OPTION_MODE_IDTOGCCODE = 'multidecoder_tool_gccode_option_mode_id.to.gccode';
const MDT_GCCODE_OPTION_MODE_GCCODETOID = 'multidecoder_tool_gccode_option_mode_gccode.to.id';

class MultiDecoderToolGCCode extends AbstractMultiDecoderTool {
  MultiDecoderToolGCCode({
    Key? key,
    required int id,
    required String name,
    required Map<String, Object?> options,
    required BuildContext context})
      : super(
            key: key,
            id: id,
            name: name,
            internalToolName: MDT_INTERNALNAMES_GCCODE,
            onDecode: (String input, String key) {
              if (options[MDT_GCCODE_OPTION_MODE] == MDT_GCCODE_OPTION_MODE_IDTOGCCODE) {
                return idToGCCode(int.tryParse(input) ?? -1);
              } else {
                return gcCodeToID(input);
              }
            },
            options: options,
            configurationWidget: MultiDecoderToolConfiguration(widgets: {
              MDT_GCCODE_OPTION_MODE: GCWStatefulDropDown<String>(
                value: checkStringFormatOrDefaultOption(MDT_INTERNALNAMES_GCCODE, options, MDT_GCCODE_OPTION_MODE),
                onChanged: (newValue) {
                  options[MDT_GCCODE_OPTION_MODE] = newValue;
                },
                items: [MDT_GCCODE_OPTION_MODE_IDTOGCCODE, MDT_GCCODE_OPTION_MODE_GCCODETOID].map((type) {
                  return GCWDropDownMenuItem(
                    value: type,
                    child: i18n(context, type),
                  );
                }).toList(),
              )
            }));
}
