import 'package:flutter/material.dart';
import 'package:gc_wizard/i18n/app_localizations.dart';
import 'package:gc_wizard/logic/tools/crypto_and_encodings/base.dart';
import 'package:gc_wizard/widgets/common/base/gcw_dropdownbutton.dart';
import 'package:gc_wizard/widgets/common/gcw_stateful_dropdownbutton.dart';
import 'package:gc_wizard/widgets/tools/crypto_and_encodings/general_codebreakers/multi_decoder/gcw_multi_decoder_tool.dart';
import 'package:gc_wizard/widgets/tools/crypto_and_encodings/general_codebreakers/multi_decoder/gcw_multi_decoder_tool_configuration.dart';

const MDT_INTERNALNAMES_BASE = 'multidecoder_tool_base_title';
const MDT_BASE_OPTION_BASEFUNCTION = 'multidecoder_tool_base_option_basefunction';

class MultiDecoderToolBase extends GCWMultiDecoderTool {
  MultiDecoderToolBase({Key key, int id, String name, Map<String, dynamic> options, BuildContext context})
      : super(
            key: key,
            id: id,
            name: name,
            internalToolName: MDT_INTERNALNAMES_BASE,
            onDecode: (input) {
              return BASE_FUNCTIONS[options[MDT_BASE_OPTION_BASEFUNCTION]](input);
            },
            options: options,
            configurationWidget: GCWMultiDecoderToolConfiguration(widgets: {
              MDT_BASE_OPTION_BASEFUNCTION: GCWStatefulDropDownButton(
                value: options[MDT_BASE_OPTION_BASEFUNCTION],
                onChanged: (newValue) {
                  options[MDT_BASE_OPTION_BASEFUNCTION] = newValue;
                },
                items: BASE_FUNCTIONS.entries.map((baseFunction) {
                  return GCWDropDownMenuItem(
                    value: baseFunction.key + '_title',
                    child: i18n(context, baseFunction.key + '_title'),
                  );
                }).toList(),
              ),
            }));
}
