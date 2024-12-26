import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_dropdown.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/base/_common/logic/base.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/general_codebreakers/multi_decoder/widget/multi_decoder.dart';
import 'package:gc_wizard/utils/constants.dart';
import 'package:gc_wizard/utils/data_type_utils/object_type_utils.dart';

const MDT_INTERNALNAMES_BASE = 'multidecoder_tool_base_title';
const MDT_BASE_OPTION_BASEFUNCTION = 'multidecoder_tool_base_option_basefunction';

class MultiDecoderToolBase extends AbstractMultiDecoderTool {
  MultiDecoderToolBase(
      {Key? key,
      required int id,
      required String name,
      required Map<String, Object?> options})
      : super(
            key: key,
            id: id,
            name: name,
            internalToolName: MDT_INTERNALNAMES_BASE,
            onDecode: (String input, String key) {
              var function = BASE_FUNCTIONS[_getBaseKey(options, MDT_BASE_OPTION_BASEFUNCTION)];
              if (function == null) return null;
              var output = function(input);
              var _output = output.replaceAll(UNKNOWN_ELEMENT, '');
              return _output.trim().isEmpty ? null : output;
            },
            options: options);
  @override
  State<StatefulWidget> createState() => _MultiDecoderToolBaseState();
}

class _MultiDecoderToolBaseState extends State<MultiDecoderToolBase> {
  @override
  Widget build(BuildContext context) {
    return createMultiDecoderToolConfiguration(context, {
      MDT_BASE_OPTION_BASEFUNCTION: GCWDropDown<String>(
        value: _getBaseKey(widget.options, MDT_BASE_OPTION_BASEFUNCTION),
        onChanged: (newValue) {
          setState(() {
            widget.options[MDT_BASE_OPTION_BASEFUNCTION] = newValue;
          });
        },
        items: BASE_FUNCTIONS.entries.map((baseFunction) {
          return GCWDropDownMenuItem(
            value: baseFunction.key,
            child: i18n(context, baseFunction.key + '_title'),
          );
        }).toList(),
      ),
    });
  }
}

String _getBaseKey(Map<String, Object?> options, String option) {
  var key = checkStringFormatOrDefaultOption(MDT_INTERNALNAMES_BASE, options, MDT_BASE_OPTION_BASEFUNCTION);
  if (BASE_FUNCTIONS.keys.contains(key)) {
    return key;
  }
  return toStringOrNull(getDefaultValue(MDT_INTERNALNAMES_BASE, MDT_BASE_OPTION_BASEFUNCTION)) ?? 'base_base16';
}
