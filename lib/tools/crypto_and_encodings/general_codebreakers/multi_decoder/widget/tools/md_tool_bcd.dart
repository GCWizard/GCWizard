import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/app_localizations.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_dropdown.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_stateful_dropdown.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/bcd/_common/logic/bcd.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/general_codebreakers/multi_decoder/widget/multi_decoder.dart';

const MDT_INTERNALNAMES_BCD = 'multidecoder_tool_bcd_title';
const MDT_BCD_OPTION_BCDFUNCTION = 'multidecoder_tool_bcd_option_bcdfunction';

final Map<String, BCDType> _BCD_TYPES = {
  'bcd_original': BCDType.ORIGINAL,
  'bcd_1of10': BCDType.ONEOFTEN,
  'bcd_2of5': BCDType.TWOOFFIVE,
  'bcd_2of5planet': BCDType.PLANET,
  'bcd_2of5postnet': BCDType.POSTNET,
  'bcd_aiken': BCDType.AIKEN,
  'bcd_biquinary': BCDType.BIQUINARY,
  'bcd_glixon': BCDType.GLIXON,
  'bcd_gray': BCDType.GRAY,
  'bcd_grayexcess': BCDType.GRAYEXCESS,
  'bcd_hamming': BCDType.HAMMING,
  'bcd_libawcraig': BCDType.LIBAWCRAIG,
  'bcd_obrien': BCDType.OBRIEN,
  'bcd_petherick': BCDType.PETHERICK,
  'bcd_stibitz': BCDType.STIBITZ,
  'bcd_tompkins': BCDType.TOMPKINS,
};

class MultiDecoderToolBCD extends AbstractMultiDecoderTool {
  MultiDecoderToolBCD({Key key, int id, String name, Map<String, dynamic> options, BuildContext context})
      : super(
            key: key,
            id: id,
            name: name,
            internalToolName: MDT_INTERNALNAMES_BCD,
            onDecode: (String input, String key) {
              return decodeBCD(input, _BCD_TYPES[options[MDT_BCD_OPTION_BCDFUNCTION]]);
            },
            options: options,
            configurationWidget: MultiDecoderToolConfiguration(widgets: {
              MDT_BCD_OPTION_BCDFUNCTION: GCWStatefulDropDown(
                value: options[MDT_BCD_OPTION_BCDFUNCTION],
                onChanged: (newValue) {
                  options[MDT_BCD_OPTION_BCDFUNCTION] = newValue;
                },
                items: _BCD_TYPES.entries.map((baseFunction) {
                  return GCWDropDownMenuItem(
                    value: baseFunction.key,
                    child: i18n(context, baseFunction.key + '_title'),
                  );
                }).toList(),
              ),
            }));
}
