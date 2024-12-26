import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_dropdown.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/general_codebreakers/multi_decoder/widget/multi_decoder.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/ragbaby/logic/ragbaby.dart';

const MDT_INTERNALNAMES_RAGBABY = 'multidecoder_tool_ragbaby_title';
const MDT_RAGBABY_OPTION_MODE = 'multidecoder_tool_ragbaby_option_mode';

class MultiDecoderToolRagbaby extends AbstractMultiDecoderTool {
  MultiDecoderToolRagbaby({Key? key, required int id, required String name, required Map<String, Object?> options})
      : super(
      key: key,
      id: id,
      name: name,
      internalToolName: MDT_INTERNALNAMES_RAGBABY,
      onDecode: (String input, String key) {
        return decryptRagbaby(input, key,
            type: _parseStringToEnum(stringNullableTypeCheck(options[MDT_RAGBABY_OPTION_MODE], null)));
      },
      requiresKey: true,
      options: options);
  @override
  State<StatefulWidget> createState() => _MultiDecoderToolRagbabyState();
}

class _MultiDecoderToolRagbabyState extends State<MultiDecoderToolRagbaby> {
  @override
  Widget build(BuildContext context) {
    return createMultiDecoderToolConfiguration(context, {
      MDT_RAGBABY_OPTION_MODE: GCWDropDown<String>(
        value: checkStringFormatOrDefaultOption(
            MDT_INTERNALNAMES_RAGBABY, widget.options, MDT_RAGBABY_OPTION_MODE),
        onChanged: (newValue) {
          setState(() {
            widget.options[MDT_RAGBABY_OPTION_MODE] = newValue;
          });
        },
        items: RAGBABY_OPTIONS.entries.map((entry) {
          return GCWDropDownMenuItem(
            value: entry.value,
            child: i18n(context, entry.value)
          );
        }).toList(),
      )
    });
  }
}

RagbabyType _parseStringToEnum(String? item) {
  var result = RAGBABY_OPTIONS.entries.firstWhereOrNull((e) => e.value == item);
  if (result != null) return result.key;
  var value = _parseStringToEnum((getDefaultValue(MDT_INTERNALNAMES_RAGBABY, MDT_RAGBABY_OPTION_MODE) ?? '').toString());
  return value;
}