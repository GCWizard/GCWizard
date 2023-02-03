import 'package:flutter/material.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/esoteric_programming_languages/karol_robot/logic/karol_robot.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/general_codebreakers/multi_decoder/widget/multi_decoder.dart';
import 'package:gc_wizard/tools/images_and_files/binary2image/logic/binary2image.dart';
import 'package:gc_wizard/utils/ui_dependent_utils/image_utils/image_utils.dart';

const MDT_INTERNALNAMES_ESOTERIC_LANGUAGE_KAROL_ROBOT = 'karol_robot_title';

class MultiDecoderToolEsotericLanguageKarolRobot extends AbstractMultiDecoderTool {
  MultiDecoderToolEsotericLanguageKarolRobot({Key key, int id, String name, Map<String, dynamic> options})
      : super(
            key: key,
            id: id,
            name: name,
            internalToolName: MDT_INTERNALNAMES_ESOTERIC_LANGUAGE_KAROL_ROBOT,
            optionalKey: true,
            onDecode: (String input, String key) {
              try {
                var output = KarolRobotOutputDecode(input);
                if ((output != null) && (output != "####\n#####\n#####\n#####"))
                  return input2Image(binary2Image(output));
              } catch (e) {}
              return null;
            },
            options: options);
}
