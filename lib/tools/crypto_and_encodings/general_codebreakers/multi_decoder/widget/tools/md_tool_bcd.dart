import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_dropdown.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/bcd/_common/logic/bcd.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/general_codebreakers/multi_decoder/widget/multi_decoder.dart';
import 'package:gc_wizard/utils/data_type_utils/object_type_utils.dart';

const MDT_INTERNALNAMES_BCD = 'multidecoder_tool_bcd_title';
const MDT_BCD_OPTION_BCDFUNCTION = 'multidecoder_tool_bcd_option_bcdfunction';

const Map<String, BCDType> _BCD_TYPES = {
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
  MultiDecoderToolBCD(
      {Key? key,
      required int id,
      required String name,
      required Map<String, Object?> options,
      required BuildContext context})
      : super(
            key: key,
            id: id,
            name: name,
            internalToolName: MDT_INTERNALNAMES_BCD,
            onDecode: (String input, String key) {
              return decodeBCD(input, _BCD_TYPES[_getBCDTypeKey(options, MDT_BCD_OPTION_BCDFUNCTION)]!);
            },
            options: options);
  @override
  State<StatefulWidget> createState() => _MultiDecoderToolBCDState();
}

class _MultiDecoderToolBCDState extends State<MultiDecoderToolBCD> {
  @override
  Widget build(BuildContext context) {
    return createMultiDecoderToolConfiguration(context, {
      MDT_BCD_OPTION_BCDFUNCTION: GCWDropDown<String>(
        value: _getBCDTypeKey(widget.options, MDT_BCD_OPTION_BCDFUNCTION),
        onChanged: (newValue) {
          setState(() {
            widget.options[MDT_BCD_OPTION_BCDFUNCTION] = newValue;
          });
        },
        items: _BCD_TYPES.entries.map((baseFunction) {
          return GCWDropDownMenuItem(
            value: baseFunction.key,
            child: i18n(context, baseFunction.key + '_title'),
          );
        }).toList(),
      )
    });
  }
}

String _getBCDTypeKey(Map<String, Object?> options, String option) {
  var key = checkStringFormatOrDefaultOption(MDT_INTERNALNAMES_BCD, options, MDT_BCD_OPTION_BCDFUNCTION);
  if (_BCD_TYPES.keys.contains(key)) {
    return key;
  }
  return toStringOrNull(getDefaultValue(MDT_INTERNALNAMES_BCD, MDT_BCD_OPTION_BCDFUNCTION)) ?? 'bcd_original';
}
