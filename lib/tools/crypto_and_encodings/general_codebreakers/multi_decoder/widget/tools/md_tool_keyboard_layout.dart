import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_dropdown.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/general_codebreakers/multi_decoder/widget/multi_decoder.dart';
import 'package:gc_wizard/tools/science_and_technology/keyboard/_common/logic/keyboard.dart';
import 'package:gc_wizard/utils/data_type_utils/object_type_utils.dart';

const MDT_INTERNALNAMES_KEYBOARDLAYOUT = 'multidecoder_tool_keyboardlayout_title';
const MDT_KEYBOARDLAYOUT_OPTION_FROM = 'keyboard_from';
const MDT_KEYBOARDLAYOUT_OPTION_TO = 'keyboard_to';

class MultiDecoderToolKeyboardLayout extends AbstractMultiDecoderTool {
  MultiDecoderToolKeyboardLayout(
      {Key? key,
      required int id,
      required String name,
      required Map<String, Object?> options})
      : super(
            key: key,
            id: id,
            name: name,
            internalToolName: MDT_INTERNALNAMES_KEYBOARDLAYOUT,
            onDecode: (String input, String key) {
              var from = getKeyboardTypeByName(checkStringFormatOrDefaultOption(
                  MDT_INTERNALNAMES_KEYBOARDLAYOUT, options, MDT_KEYBOARDLAYOUT_OPTION_FROM));
              from ??= getKeyboardTypeByName(
                  toStringOrNull(getDefaultValue(MDT_INTERNALNAMES_KEYBOARDLAYOUT, MDT_KEYBOARDLAYOUT_OPTION_FROM)) ??
                      '');
              var to = getKeyboardTypeByName(checkStringFormatOrDefaultOption(
                  MDT_INTERNALNAMES_KEYBOARDLAYOUT, options, MDT_KEYBOARDLAYOUT_OPTION_TO));
              to ??= getKeyboardTypeByName(
                  toStringOrNull(getDefaultValue(MDT_INTERNALNAMES_KEYBOARDLAYOUT, MDT_KEYBOARDLAYOUT_OPTION_TO)) ??
                      '');
              if (from == null || to == null) return null;
              return encodeKeyboard(input, from, to);
            },
            options: options);
  @override
  State<StatefulWidget> createState() => _MultiDecoderToolKeyboardLayoutState();
}

class _MultiDecoderToolKeyboardLayoutState extends State<MultiDecoderToolKeyboardLayout> {
  @override
  Widget build(BuildContext context) {
    return createMultiDecoderToolConfiguration(context, {
      MDT_KEYBOARDLAYOUT_OPTION_FROM: GCWDropDown<String>(
        value: checkStringFormatOrDefaultOption(
            MDT_INTERNALNAMES_KEYBOARDLAYOUT, widget.options, MDT_KEYBOARDLAYOUT_OPTION_FROM),
        onChanged: (newValue) {
          setState(() {
            widget.options[MDT_KEYBOARDLAYOUT_OPTION_FROM] = newValue;
          });
        },
        items: allKeyboards.map((keyboard) {
          return GCWDropDownMenuItem(
              value: keyboard.name, child: i18n(context, keyboard.name), subtitle: keyboard.example);
        }).toList(),
      ),
      MDT_KEYBOARDLAYOUT_OPTION_TO: GCWDropDown<String>(
        value: checkStringFormatOrDefaultOption(
            MDT_INTERNALNAMES_KEYBOARDLAYOUT, widget.options, MDT_KEYBOARDLAYOUT_OPTION_TO),
        onChanged: (newValue) {
          setState(() {
            widget.options[MDT_KEYBOARDLAYOUT_OPTION_TO] = newValue;
          });
        },
        items: allKeyboards.map((keyboard) {
          return GCWDropDownMenuItem(
              value: keyboard.name, child: i18n(context, keyboard.name), subtitle: keyboard.example);
        }).toList(),
      ),
    });
  }
}
