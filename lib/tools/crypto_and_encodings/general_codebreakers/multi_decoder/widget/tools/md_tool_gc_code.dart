import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_dropdown.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/gc_code/logic/gc_code.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/general_codebreakers/multi_decoder/widget/multi_decoder.dart';

const MDT_INTERNALNAMES_GCCODE = 'multidecoder_tool_gccode_title';
const MDT_GCCODE_OPTION_MODE = 'multidecoder_tool_gccode_option_mode';
const MDT_GCCODE_OPTION_MODE_IDTOGCCODE = 'multidecoder_tool_gccode_option_mode_id.to.gccode';
const MDT_GCCODE_OPTION_MODE_GCCODETOID = 'multidecoder_tool_gccode_option_mode_gccode.to.id';

class MultiDecoderToolGCCode extends AbstractMultiDecoderTool {
  MultiDecoderToolGCCode(
      {super.key,
      required super.id,
      required super.name,
      required super.options,
      required BuildContext context})
      : super(
            internalToolName: MDT_INTERNALNAMES_GCCODE,
            onDecode: (String input, String key) {
              if (options[MDT_GCCODE_OPTION_MODE] == MDT_GCCODE_OPTION_MODE_IDTOGCCODE) {
                return idToGCCode(int.tryParse(input) ?? -1);
              } else {
                return gcCodeToID(input);
              }
            });
  @override
  State<StatefulWidget> createState() => _MultiDecoderToolGCCodeState();
}

class _MultiDecoderToolGCCodeState extends State<MultiDecoderToolGCCode> {
  @override
  Widget build(BuildContext context) {
    return createMultiDecoderToolConfiguration(context, {
      MDT_GCCODE_OPTION_MODE: GCWDropDown<String>(
        value: checkStringFormatOrDefaultOption(MDT_INTERNALNAMES_GCCODE, widget.options, MDT_GCCODE_OPTION_MODE),
        onChanged: (newValue) {
          setState(() {
            widget.options[MDT_GCCODE_OPTION_MODE] = newValue;
          });
        },
        items: [MDT_GCCODE_OPTION_MODE_IDTOGCCODE, MDT_GCCODE_OPTION_MODE_GCCODETOID].map((type) {
          return GCWDropDownMenuItem(
            value: type,
            child: i18n(context, type),
          );
        }).toList(),
      )
    });
  }
}
