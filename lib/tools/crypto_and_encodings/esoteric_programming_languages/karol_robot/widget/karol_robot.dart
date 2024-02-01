import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/application/theme/theme_colors.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_iconbutton.dart';
import 'package:gc_wizard/common_widgets/dialogs/gcw_exported_file_dialog.dart';
import 'package:gc_wizard/common_widgets/dividers/gcw_text_divider.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_dropdown.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_output_text.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_twooptions_switch.dart';
import 'package:gc_wizard/common_widgets/text_input_formatters/wrapper_for_masktextinputformatter.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/esoteric_programming_languages/karol_robot/logic/karol_robot.dart';
import 'package:gc_wizard/tools/images_and_files/binary2image/logic/binary2image.dart';
import 'package:gc_wizard/utils/file_utils/file_utils.dart';
import 'package:gc_wizard/utils/ui_dependent_utils/file_widget_utils.dart';
import 'package:gc_wizard/utils/ui_dependent_utils/image_utils/image_utils.dart';

class KarolRobot extends StatefulWidget {
  const KarolRobot({Key? key}) : super(key: key);

  @override
  _KarolRobotState createState() => _KarolRobotState();
}

class _KarolRobotState extends State<KarolRobot> {
  late TextEditingController _decodeController;
  late TextEditingController _encodeController;

  var _currentDecode = '';
  var _currentEncode = '';

  Uint8List? _outEncodeData;
  Uint8List? _outDecodeData;

  String _output = '';

  final _MASKINPUTFORMATTER_ENCODE =
      GCWMaskTextInputFormatter(mask: '@' * 100, filter: {"@": RegExp(r'[A-ZÄÖÜäöüa-z0-9 .°,\n\r]')});

  final _MASKINPUTFORMATTER_DECODE =
      GCWMaskTextInputFormatter(mask: "@" * 50000, filter: {"@": RegExp(r'[A-ZÄÖÜäöüa-z0-9() \n\r]')});

  GCWSwitchPosition _currentMode = GCWSwitchPosition.left;
  var _currentLanguage = KAREL_LANGUAGES.DEU;

  @override
  void initState() {
    super.initState();
    _decodeController = TextEditingController(text: _currentDecode);
    _encodeController = TextEditingController(text: _currentEncode);
  }

  @override
  void dispose() {
    _decodeController.dispose();
    _encodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GCWTwoOptionsSwitch(
          leftValue: i18n(context, 'karol_robot_interpret'),
          rightValue: i18n(context, 'karol_robot_generate'),
          value: _currentMode,
          onChanged: (value) {
            setState(() {
              _currentMode = value;
            });
          },
        ),
        _currentMode == GCWSwitchPosition.left //decode
            ? GCWTextField(
                controller: _decodeController,
                hintText: i18n(context, 'karol_robot_hint_decode'),
                inputFormatters: [_MASKINPUTFORMATTER_DECODE],
                onChanged: (text) {
                  setState(() {
                    _currentDecode = text;
                    _createDecodeOutput(KarolRobotOutputDecode(_currentDecode));
                  });
                },
              )
            : Column(children: <Widget>[
                GCWDropDown<KAREL_LANGUAGES>(
                  value: _currentLanguage,
                  onChanged: (value) {
                    setState(() {
                      _currentLanguage = value;
                    });
                  },
                  items: KAREL_LANGUAGES_LIST.entries.map((mode) {
                    return GCWDropDownMenuItem(
                      value: mode.key,
                      child: i18n(context, mode.value),
                    );
                  }).toList(),
                ),
                GCWTextField(
                  controller: _encodeController,
                  hintText: i18n(context, 'karol_robot_hint_encode'),
                  inputFormatters: [_MASKINPUTFORMATTER_ENCODE],
                  onChanged: (text) {
                    setState(() {
                      _currentEncode = text;
                      _createEncodeOutput(
                          KarolRobotOutputDecode(KarolRobotOutputEncode(_currentEncode, _currentLanguage)));
                    });
                  },
                ),
              ]),
        _buildOutput(context)
      ],
    );
  }

  Widget _buildOutput(BuildContext context) {
    double size = 6.0;
    if (_currentMode == GCWSwitchPosition.right) {
      //encode
      _output = KarolRobotOutputEncode(_currentEncode, _currentLanguage);
      size = 16.0;
    }
    return Column(children: <Widget>[
      _currentMode == GCWSwitchPosition.left //decode
          ? GCWDefaultOutput(
              trailing: GCWIconButton(
                icon: Icons.save,
                size: IconButtonSize.SMALL,
                iconColor: _outDecodeData == null ? themeColors().inActive() : null,
                onPressed: () {
                  _outDecodeData == null ? null : _exportFile(context, _outDecodeData!);
                },
              ),
              child: _buildGraphicDecodeOutput())
          : Column(children: <Widget>[
              GCWTextDivider(
                text: i18n(context, 'karol_robot_graphicaloutput'),
              ),
              GCWOutput(
                child: _buildGraphicEncodeOutput(),
              ),
              GCWDefaultOutput(
                  child: GCWOutputText(
                text: _output,
                style: TextStyle(
                  fontFamily: 'Courier',
                  fontSize: size,
                  fontWeight: FontWeight.bold,
                ),
              )),
            ])
    ]);
  }

  void _createDecodeOutput(String output) {
    _outDecodeData = null;
    var image = binary2Image(output);
    if (image == null) return;
    input2Image(image).then((value) {
      setState(() {
        _outDecodeData = value;
      });
    });
  }

  Widget _buildGraphicDecodeOutput() {
    if (_outDecodeData == null) return Container();

    return Column(children: <Widget>[
      Image.memory(_outDecodeData!),
    ]);
  }

  void _createEncodeOutput(String output) {
    _outEncodeData = null;
    var image = binary2Image(output);
    if (image == null) return;
    input2Image(image).then((value) {
      setState(() {
        _outEncodeData = value;
      });
    });
  }

  Widget _buildGraphicEncodeOutput() {
    if (_outEncodeData == null) return Container();

    return Column(children: <Widget>[
      Image.memory(_outEncodeData!),
    ]);
  }

  Future<void> _exportFile(BuildContext context, Uint8List data) async {
    await saveByteDataToFile(context, data, buildFileNameWithDate('img_', FileType.PNG)).then((value) {
      if (value) showExportedFileDialog(context, contentWidget: imageContent(context, data));
    });
  }
}
