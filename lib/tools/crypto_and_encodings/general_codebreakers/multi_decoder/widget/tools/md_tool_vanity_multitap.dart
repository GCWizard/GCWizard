import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_dropdown.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/general_codebreakers/multi_decoder/widget/multi_decoder.dart';
import 'package:gc_wizard/tools/science_and_technology/vanity/_common/logic/phone_models.dart';
import 'package:gc_wizard/tools/science_and_technology/vanity/_common/logic/vanity.dart';

const MDT_INTERNALNAMES_VANITY_MULTITAP = 'multidecoder_tool_vanity_multitap_title';
const MDT_VANITYMULTITAP_OPTION_PHONEMODEL = 'multidecoder_tool_vanity_multitap_option_phonemodel';

class MultiDecoderToolVanityMultitap extends AbstractMultiDecoderTool {
  MultiDecoderToolVanityMultitap(
      {Key? key,
      required int id,
      required String name,
      required Map<String, Object?> options})
      : super(
            key: key,
            id: id,
            name: name,
            internalToolName: MDT_INTERNALNAMES_VANITY_MULTITAP,
            onDecode: (String input, String key) {
              PhoneModel model;
              var modelName = _ensureBackwardsCompatibility(checkStringFormatOrDefaultOption(
                  MDT_INTERNALNAMES_VANITY_MULTITAP, options, MDT_VANITYMULTITAP_OPTION_PHONEMODEL));

              switch (modelName) {
                case NAME_PHONEMODEL_SIMPLE_SPACE_0:
                  model = PHONEMODEL_SIMPLE_SPACE_0;
                  break;
                case NAME_PHONEMODEL_SIMPLE_SPACE_1:
                  model = PHONEMODEL_SIMPLE_SPACE_1;
                  break;
                case NAME_PHONEMODEL_SIMPLE_SPACE_HASH:
                  model = PHONEMODEL_SIMPLE_SPACE_HASH;
                  break;
                case NAME_PHONEMODEL_SIMPLE_SPACE_ASTERISK:
                  model = PHONEMODEL_SIMPLE_SPACE_ASTERISK;
                  break;
                default:
                  model = PHONEMODEL_SIMPLE_SPACE_0;
                  break;
              }

              return decodeVanityMultitap(input, model, PhoneInputLanguage.UNSPECIFIED)?.item2;
            },
            options: options);
  @override
  State<StatefulWidget> createState() => _MultiDecoderToolVanityMultitapState();
}

class _MultiDecoderToolVanityMultitapState extends State<MultiDecoderToolVanityMultitap> {
  @override
  Widget build(BuildContext context) {
    return createMultiDecoderToolConfiguration(context, {
      MDT_VANITYMULTITAP_OPTION_PHONEMODEL: GCWDropDown<String>(
          value: _ensureBackwardsCompatibility(checkStringFormatOrDefaultOption(
              MDT_INTERNALNAMES_VANITY_MULTITAP, widget.options, MDT_VANITYMULTITAP_OPTION_PHONEMODEL)),
          onChanged: (newValue) {
            setState(() {
              widget.options[MDT_VANITYMULTITAP_OPTION_PHONEMODEL] = newValue;
            });
          },
          items: [
            NAME_PHONEMODEL_SIMPLE_SPACE_0,
            NAME_PHONEMODEL_SIMPLE_SPACE_1,
            NAME_PHONEMODEL_SIMPLE_SPACE_HASH,
            NAME_PHONEMODEL_SIMPLE_SPACE_ASTERISK,
          ].map((model) {
            return GCWDropDownMenuItem(value: model, child: i18n(context, model));
          }).toList()),
    });
  }
}

//artifact from 1.5.0
String _ensureBackwardsCompatibility(String modelName) {
  switch (modelName) {
    case 'Nokia':
    case 'Samsung':
      return NAME_PHONEMODEL_SIMPLE_SPACE_0;
    case 'Siemens':
      return NAME_PHONEMODEL_SIMPLE_SPACE_1;
    default:
      return modelName;
  }
}
