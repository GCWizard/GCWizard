import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/app_localizations.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_dropdown.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_stateful_dropdown.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/base/_common/logic/base.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/general_codebreakers/multi_decoder/widget/multi_decoder.dart';
import 'package:gc_wizard/utils/data_type_utils/object_type_utils.dart';

const MDT_INTERNALNAMES_BASE = 'multidecoder_tool_base_title';
const MDT_BASE_OPTION_BASEFUNCTION = 'multidecoder_tool_base_option_basefunction';

class MultiDecoderToolBase extends AbstractMultiDecoderTool {
  MultiDecoderToolBase({
    Key? key,
    required int id,
    required String name,
    required Map<String, Object?> options,
    required BuildContext context})
      : super(
            key: key,
            id: id,
            name: name,
            internalToolName: MDT_INTERNALNAMES_BASE,
            onDecode: (String input, String key) {
              var function =  BASE_FUNCTIONS[getBaseKey(options, MDT_BASE_OPTION_BASEFUNCTION)];
              return function == null ? null : function(input);
            },
            options: options,
            configurationWidget: MultiDecoderToolConfiguration(widgets: {
              MDT_BASE_OPTION_BASEFUNCTION: GCWStatefulDropDown<String>(
                value: getBaseKey(options, MDT_BASE_OPTION_BASEFUNCTION),
                onChanged: (newValue) {
                  options[MDT_BASE_OPTION_BASEFUNCTION] = newValue;
                },
                items: BASE_FUNCTIONS.entries.map((baseFunction) {
                  return GCWDropDownMenuItem(
                    value: baseFunction.key,
                    child: i18n(context, baseFunction.key + '_title'),
                  );
                }).toList(),
              ),
            }));
}

String getBaseKey(Map<String, Object?> options, String option) {
  var key = checkStringFormatOrDefaultOption(MDT_INTERNALNAMES_BASE, options, MDT_BASE_OPTION_BASEFUNCTION);
  if (BASE_FUNCTIONS.keys.contains(key)) {
    return key;
  }
  return toStringOrNull(getDefaultValue(MDT_INTERNALNAMES_BASE, MDT_BASE_OPTION_BASEFUNCTION)) ?? 'base_base16';
}