import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/app_localizations.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_dropdown.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_stateful_dropdown.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/general_codebreakers/multi_decoder/widget/multi_decoder.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/wasd/logic/wasd.dart';
import 'package:gc_wizard/tools/images_and_files/binary2image/logic/binary2image.dart';
import 'package:gc_wizard/utils/collection_utils.dart';

const MDT_INTERNALNAMES_WASD = 'multidecoder_tool_wasd_title';
const MDT_WASD_OPTION_SET = 'wasd_control_set';

class MultiDecoderToolWasd extends AbstractMultiDecoderTool {
  MultiDecoderToolWasd({Key key, int id, String name, Map<String, dynamic> options, BuildContext context})
      : super(
            key: key,
            id: id,
            name: name,
            internalToolName: MDT_INTERNALNAMES_WASD,
            onDecode: (String input, String key) {
              if (input == null) return null;
              return binary2image(
                  decodeWASDGraphic(input, (options[MDT_WASD_OPTION_SET] as String).characters.toList()), false, false);
            },
            options: options,
            configurationWidget: MultiDecoderToolConfiguration(widgets: {
              MDT_WASD_OPTION_SET: GCWStatefulDropDown(
                value: switchMapKeyValue(KEYBOARD_CONTROLS)[options[MDT_WASD_OPTION_SET]],
                onChanged: (newValue) {
                  options[MDT_WASD_OPTION_SET] = KEYBOARD_CONTROLS[newValue];
                },
                items: KEYBOARD_CONTROLS.entries.where((element) => element.key != WASD_TYPE.CUSTOM).map((mode) {
                  return GCWDropDownMenuItem(
                    value: mode.key,
                    child: i18n(context, mode.value) ?? mode.value,
                  );
                }).toList(),
              ),
            }));
}
