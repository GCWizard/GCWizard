import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/app_localizations.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_dropdown.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_stateful_dropdown.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/general_codebreakers/multi_decoder/widget/multi_decoder.dart';
import 'package:gc_wizard/tools/science_and_technology/keyboard/_common/logic/keyboard.dart';

const MDT_INTERNALNAMES_KEYBOARDNUMBERS = 'multidecoder_tool_keyboardnumbers_title';
const MDT_KEYBOARDNUMBERS_OPTION_TYPE = 'multidecoder_tool_keyboardnumbers_type';

class MultiDecoderToolKeyboardNumbers extends AbstractMultiDecoderTool {
  MultiDecoderToolKeyboardNumbers({
    Key? key,
    required int id,
    required String name,
    required Map<String, Object?> options,
    required BuildContext context})
      : super(
            key: key,
            id: id,
            name: name,
            internalToolName: MDT_INTERNALNAMES_KEYBOARDNUMBERS,
            onDecode: (String input, String key) {
              return keyboardNumbersByName[
                    checkStringFormatOrDefaultOption(MDT_INTERNALNAMES_KEYBOARDNUMBERS, options, MDT_KEYBOARDNUMBERS_OPTION_TYPE)
                    ]!(input).trim();
            },
            options: options,
            configurationWidget: MultiDecoderToolConfiguration(widgets: {
              MDT_KEYBOARDNUMBERS_OPTION_TYPE: GCWStatefulDropDown<String>(
                value: checkStringFormatOrDefaultOption(MDT_INTERNALNAMES_KEYBOARDNUMBERS, options, MDT_KEYBOARDNUMBERS_OPTION_TYPE),
                onChanged: (newValue) {
                  options[MDT_KEYBOARDNUMBERS_OPTION_TYPE] = newValue;
                },
                items: keyboardNumbersByName
                    .map((name, function) {
                      return MapEntry(name, GCWDropDownMenuItem(value: name, child: i18n(context, name)));
                    })
                    .values
                    .toList(),
              )
            }));
}
