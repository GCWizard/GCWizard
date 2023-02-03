import 'package:flutter/material.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_dropdown.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_stateful_dropdown.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/general_codebreakers/multi_decoder/widget/multi_decoder.dart';
import 'package:gc_wizard/tools/science_and_technology/segment_display/_common/logic/segment_display.dart';
import 'package:gc_wizard/utils/constants.dart';

const MDT_INTERNALNAMES_SEGMENTDISPLAY = 'multidecoder_tool_segmentdisplay_title';
const MDT_SEGMENTDISPLAY_OPTION_NUMBERSEGMENTS = 'multidecoder_tool_segmentdisplay_option_numbersegments';

class MultiDecoderToolSegmentDisplay extends AbstractMultiDecoderTool {
  MultiDecoderToolSegmentDisplay({Key key, int id, String name, Map<String, dynamic> options})
      : super(
            key: key,
            id: id,
            name: name,
            internalToolName: MDT_INTERNALNAMES_SEGMENTDISPLAY,
            onDecode: (String input, String key) {
              var segmentType;
              switch (options[MDT_SEGMENTDISPLAY_OPTION_NUMBERSEGMENTS]) {
                case 7:
                  segmentType = SegmentDisplayType.SEVEN;
                  break;
                case 14:
                  segmentType = SegmentDisplayType.FOURTEEN;
                  break;
                case 16:
                  segmentType = SegmentDisplayType.SIXTEEN;
                  break;
              }
              return decodeSegment(input, segmentType)['text'].replaceAll(UNKNOWN_ELEMENT, '');
            },
            options: options,
            configurationWidget: MultiDecoderToolConfiguration(widgets: {
              MDT_SEGMENTDISPLAY_OPTION_NUMBERSEGMENTS: GCWStatefulDropDown(
                value: options[MDT_SEGMENTDISPLAY_OPTION_NUMBERSEGMENTS],
                onChanged: (newValue) {
                  options[MDT_SEGMENTDISPLAY_OPTION_NUMBERSEGMENTS] = newValue;
                },
                items: [7, 14, 16].map((numberSegments) {
                  return GCWDropDownMenuItem(
                    value: numberSegments,
                    child: numberSegments,
                  );
                }).toList(),
              ),
            }));
}
