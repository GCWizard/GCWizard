import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/app_localizations.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_dropdown.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_stateful_dropdown.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/general_codebreakers/multi_decoder/widget/multi_decoder.dart';
import 'package:gc_wizard/tools/science_and_technology/keyboard/_common/logic/keyboard.dart';

const MDT_INTERNALNAMES_KEYBOARDLAYOUT = 'multidecoder_tool_keyboardlayout_title';
const MDT_KEYBOARDLAYOUT_OPTION_FROM = 'keyboard_from';
const MDT_KEYBOARDLAYOUT_OPTION_TO = 'keyboard_to';

class MultiDecoderToolKeyboardLayout extends AbstractMultiDecoderTool {
  MultiDecoderToolKeyboardLayout({Key key, int id, String name, Map<String, dynamic> options, BuildContext context})
      : super(
            key: key,
            id: id,
            name: name,
            internalToolName: MDT_INTERNALNAMES_KEYBOARDLAYOUT,
            onDecode: (String input, String key) {
              if (input == null) return null;
              return encodeKeyboard(input, getKeyboardTypeByName(options[MDT_KEYBOARDLAYOUT_OPTION_FROM]),
                  getKeyboardTypeByName(options[MDT_KEYBOARDLAYOUT_OPTION_TO]));
            },
            options: options,
            configurationWidget: MultiDecoderToolConfiguration(widgets: {
              MDT_KEYBOARDLAYOUT_OPTION_FROM: GCWStatefulDropDown(
                value: options[MDT_KEYBOARDLAYOUT_OPTION_FROM],
                onChanged: (newValue) {
                  options[MDT_KEYBOARDLAYOUT_OPTION_FROM] = newValue;
                },
                items: allKeyboards.map((keyboard) {
                  return GCWDropDownMenuItem(
                      value: keyboard.name, child: i18n(context, keyboard.name), subtitle: keyboard.example);
                }).toList(),
              ),
              MDT_KEYBOARDLAYOUT_OPTION_TO: GCWStatefulDropDown(
                value: options[MDT_KEYBOARDLAYOUT_OPTION_TO],
                onChanged: (newValue) {
                  options[MDT_KEYBOARDLAYOUT_OPTION_TO] = newValue;
                },
                items: allKeyboards.map((keyboard) {
                  return GCWDropDownMenuItem(
                      value: keyboard.name, child: i18n(context, keyboard.name), subtitle: keyboard.example);
                }).toList(),
              ),
            }));
}
