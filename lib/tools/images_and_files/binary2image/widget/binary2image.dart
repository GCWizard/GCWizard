import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/application/theme/theme_colors.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_iconbutton.dart';
import 'package:gc_wizard/common_widgets/dialogs/gcw_exported_file_dialog.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_output.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_onoff_switch.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/tools/images_and_files/binary2image/logic/binary2image.dart';
import 'package:gc_wizard/tools/images_and_files/qr_code/logic/qr_code.dart';
import 'package:gc_wizard/utils/file_utils/file_utils.dart';
import 'package:gc_wizard/utils/ui_dependent_utils/file_widget_utils.dart';
import 'package:gc_wizard/utils/ui_dependent_utils/image_utils/image_utils.dart';

class Binary2Image extends StatefulWidget {
  const Binary2Image({Key? key}) : super(key: key);

  @override
  _Binary2ImageState createState() => _Binary2ImageState();
}

class _Binary2ImageState extends State<Binary2Image> {
  var _currentInput = '';
  Uint8List? _outData;
  String? _codeData;
  var _squareFormat = false;
  var _invers = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GCWTextField(
          onChanged: (value) {
            _currentInput = value;
            _createOutput();
          },
        ),
        GCWOnOffSwitch(
          title: i18n(context, 'binary2image_squareFormat'),
          value: _squareFormat,
          onChanged: (value) {
            _squareFormat = value;
            _createOutput();
          },
        ),
        GCWOnOffSwitch(
          title: i18n(context, 'binary2image_invers'),
          value: _invers,
          onChanged: (value) {
            _invers = value;
            _createOutput();
          },
        ),
        GCWDefaultOutput(
            trailing: GCWIconButton(
              icon: Icons.save,
              size: IconButtonSize.SMALL,
              iconColor: _outData == null ? themeColors().inActive() : null,
              onPressed: () {
                _outData == null ? null : _exportFile(context, _outData!);
              },
            ),
            child: _buildOutput())
      ],
    );
  }

  void _createOutput() {
    _outData = null;
    _codeData = null;
    var image = binary2image(_currentInput, _squareFormat, _invers);
    if (image == null) return;
    input2Image(image).then((value) {
      setState(() {
        _outData = value;
        scanBytes(_outData).then((value) {
          setState(() {
            _codeData = value;
          });
        });
      });
    });
  }

  Widget _buildOutput() {
    if (_outData == null) return Container();

    return Column(children: <Widget>[
      Image.memory(_outData!),
      _codeData != null ? GCWOutput(title: i18n(context, 'binary2image_code_data'), child: _codeData) : Container(),
    ]);
  }

  Future<void> _exportFile(BuildContext context, Uint8List data) async {
    await saveByteDataToFile(context, data, buildFileNameWithDate('img_', FileType.PNG)).then((value) {
      if (value) showExportedFileDialog(context, contentWidget: imageContent(context, data));
    });
  }
}
