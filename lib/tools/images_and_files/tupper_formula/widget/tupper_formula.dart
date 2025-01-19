import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/application/theme/theme_colors.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_iconbutton.dart';
import 'package:gc_wizard/common_widgets/dialogs/gcw_exported_file_dialog.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_output.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_twooptions_switch.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/tools/images_and_files/binary2image/logic/binary2image.dart';
import 'package:gc_wizard/tools/images_and_files/qr_code/logic/qr_code.dart';
import 'package:gc_wizard/tools/images_and_files/tupper_formula/logic/tupper_formula.dart';
import 'package:gc_wizard/utils/file_utils/file_utils.dart';
import 'package:gc_wizard/utils/file_utils/gcw_file.dart';
import 'package:gc_wizard/utils/ui_dependent_utils/file_widget_utils.dart';
import 'package:gc_wizard/utils/ui_dependent_utils/image_utils/image_utils.dart';

class TupperFormula extends StatefulWidget {
  final GCWFile? file;

  const TupperFormula({Key? key, this.file}) : super(key: key);

  @override
  _TupperFormulaState createState() => _TupperFormulaState();
}

class _TupperFormulaState extends State<TupperFormula> {
  var _currentInput = '';

  Uint8List? _outData;
  String? _codeData;

  late TextEditingController _inputController;
  GCWSwitchPosition _currentMode = GCWSwitchPosition.right;

  var lastCurrentInputLength = 0;

  @override
  void initState() {
    super.initState();
    _inputController = TextEditingController(text: _currentInput);
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _currentMode == GCWSwitchPosition.left
            ? _buildWidgetCreateImage()
            : GCWTextField(
          labelText: 'k',
          controller: _inputController,
          onChanged: (value) {
            setState(() {
              _currentInput = value;
              _createOutput();
            });
          },
        ),
        GCWTwoOptionsSwitch(
          value: _currentMode,
          onChanged: (value) {
            setState(() {
              _currentMode = value;
            });
          },
        ),
        GCWDefaultOutput(
            trailing: GCWIconButton(
              icon: Icons.save,
              size: IconButtonSize.SMALL,
              iconColor: _outData == null ? themeColors().inactive() : null,
              onPressed: () {
                _outData == null ? null : _exportFile(context, _outData!);
              },
            ),
            child: _buildOutput())
      ],
    );
  }

  Widget _buildWidgetCreateImage() {
    return Container();
  }

  void _createOutput() {
    _outData = null;
    _codeData = null;

    var image = binary2image(kToImage(_currentInput), false, false);
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
    var fileType = getFileType(data);
    await saveByteDataToFile(context, data, buildFileNameWithDate('img_', fileType)).then((value) {
      var content = fileClass(fileType) == FileClass.IMAGE ? imageContent(context, data) : null;
      if (value) showExportedFileDialog(context, contentWidget: content);
    });
  }
}
