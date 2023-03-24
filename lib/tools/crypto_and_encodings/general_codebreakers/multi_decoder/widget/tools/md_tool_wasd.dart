import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/app_localizations.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_dropdown.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_stateful_dropdown.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/general_codebreakers/multi_decoder/widget/multi_decoder.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/wasd/logic/wasd.dart';
import 'package:gc_wizard/tools/images_and_files/binary2image/logic/binary2image.dart';
import 'package:gc_wizard/utils/collection_utils.dart';
import 'package:gc_wizard/utils/ui_dependent_utils/image_utils/image_utils.dart';

const MDT_INTERNALNAMES_WASD = 'multidecoder_tool_wasd_title';
const MDT_WASD_OPTION_SET = 'wasd_control_set';

class MultiDecoderToolWasd extends AbstractMultiDecoderTool {
  MultiDecoderToolWasd({
    Key? key,
    required int id,
    required String name,
    required Map<String, Object?> options,
    required BuildContext context})
      : super(
            key: key,
            id: id,
            name: name,
            internalToolName: MDT_INTERNALNAMES_WASD,
            onDecode: (String input, String key) {
              var value = checkStringFormatOrDefaultOption(MDT_INTERNALNAMES_WASD, options, MDT_WASD_OPTION_SET);
              var output = binary2image(
                  decodeWASDGraphic(input, (value.characters.toList())), false, false);
              if (output == null) return null;
              return input2Image(output);
            },
            options: options,
            configurationWidget: MultiDecoderToolConfiguration(widgets: {
              MDT_WASD_OPTION_SET: GCWStatefulDropDown<WASD_TYPE>(
                value: getWASD_Type(options[MDT_WASD_OPTION_SET], options),
                onChanged: (newValue) {
                  options[MDT_WASD_OPTION_SET] = KEYBOARD_CONTROLS[newValue];
                },
                items: KEYBOARD_CONTROLS.entries.where((element) => element.key != WASD_TYPE.CUSTOM).map((mode) {
                  return GCWDropDownMenuItem(
                    value: mode.key,
                    child: i18n(context, mode.value, ifTranslationNotExists: mode.value),
                  );
                }).toList(),
              ),
            }));
}

WASD_TYPE getWASD_Type(Object? value, Map<String, Object?> options) {
  if (value is String && KEYBOARD_CONTROLS.values.contains(value)) {
    return switchMapKeyValue(KEYBOARD_CONTROLS)[value]!;
  }
  value = checkStringFormatOrDefaultOption(MDT_INTERNALNAMES_WASD, options, MDT_WASD_OPTION_SET);
  return switchMapKeyValue(KEYBOARD_CONTROLS)[value]!;
}
