import 'package:flutter/material.dart';
import 'package:gc_wizard/i18n/app_localizations.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/logic/bcd.dart';
import 'package:gc_wizard/tools/common/base/gcw_dropdownbutton/widget/gcw_dropdownbutton.dart';
import 'package:gc_wizard/tools/common/gcw_stateful_dropdownbutton/widget/gcw_stateful_dropdownbutton.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/general_codebreakers/multi_decoder/gcw_multi_decoder_tool/widget/gcw_multi_decoder_tool.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/general_codebreakers/multi_decoder/gcw_multi_decoder_tool_configuration/widget/gcw_multi_decoder_tool_configuration.dart';

const MDT_INTERNALNAMES_BCD = 'multidecoder_tool_bcd_title';
const MDT_BCD_OPTION_BCDFUNCTION = 'multidecoder_tool_bcd_option_bcdfunction';

class MultiDecoderToolBCD extends GCWMultiDecoderTool {
  MultiDecoderToolBCD({Key key, int id, String name, Map<String, dynamic> options, BuildContext context})
      : super(
            key: key,
            id: id,
            name: name,
            internalToolName: MDT_INTERNALNAMES_BCD,
            onDecode: (String input, String key) {
              return decodeBCD(input, BCD_TYPES[options[MDT_BCD_OPTION_BCDFUNCTION]]);
            },
            options: options,
            configurationWidget: GCWMultiDecoderToolConfiguration(widgets: {
              MDT_BCD_OPTION_BCDFUNCTION: GCWStatefulDropDownButton(
                value: options[MDT_BCD_OPTION_BCDFUNCTION],
                onChanged: (newValue) {
                  options[MDT_BCD_OPTION_BCDFUNCTION] = newValue;
                },
                items: BCD_TYPES.entries.map((baseFunction) {
                  return GCWDropDownMenuItem(
                    value: baseFunction.key,
                    child: i18n(context, baseFunction.key + '_title'),
                  );
                }).toList(),
              ),
            }));
}
