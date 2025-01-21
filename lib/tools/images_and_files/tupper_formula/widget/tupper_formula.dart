import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/application/theme/theme_colors.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_iconbutton.dart';
import 'package:gc_wizard/common_widgets/dialogs/gcw_exported_file_dialog.dart';
import 'package:gc_wizard/common_widgets/gcw_painter_container.dart';
import 'package:gc_wizard/common_widgets/image_viewers/gcw_imageview.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_output.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_twooptions_switch.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/tools/images_and_files/binary2image/logic/binary2image.dart';
import 'package:gc_wizard/tools/images_and_files/qr_code/logic/qr_code.dart';
import 'package:gc_wizard/tools/images_and_files/tupper_formula/logic/tupper_formula.dart';
import 'package:gc_wizard/tools/images_and_files/tupper_formula/widget/tupper_formula_board.dart';
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

  TupperData _board = TupperData();

  Uint8List? _outData;
  String? _codeData;

  BigInt _currentK = BigInt.zero;

  late TextEditingController _inputController;
  GCWSwitchPosition _currentMode = GCWSwitchPosition.right;

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
            ? Column(
                children: [
                  GCWPainterContainer(
                    child: TupperFormulaBoard(
                      state: _board.currentBoard,
                      onChanged: (newBoard) {
                        setState(() {
                          _board.reset(board: newBoard);
                        });
                      },
                    ),
                  ),
                  Row(children: [
                    Expanded(
                      child: GCWIconButton(
                        iconColor: themeColors().dialogText(),
                        backgroundColor: themeColors().dialog(),
                        size: IconButtonSize.SMALL,
                        icon: Icons.calculate_outlined,
                        onPressed: () {
                          setState(() {
                            _currentK = _board.getK();
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: GCWIconButton(
                        iconColor: themeColors().dialogText(),
                        backgroundColor: themeColors().dialog(),
                        size: IconButtonSize.SMALL,
                        icon: Icons.clear,
                        onPressed: () {
                          setState(() {
                            _board.reset();
                          });
                        },
                      ),
                    )
                  ]),
                ],
              )
            : GCWTextField(
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                ],
                labelText: 'k',
                controller: _inputController,
                onChanged: (value) {
                  setState(() {
                    _currentInput = value;
                    _createImageOutput();
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
        _buildOutput(),
      ],
    );
  }

  Widget _buildOutput() {
    if (_currentMode == GCWSwitchPosition.right) {
      return GCWDefaultOutput(child: _buildImageOutput());
    } else {
      return GCWDefaultOutput(
        child: _currentK.toString(),
      );
    }
  }

  void _createImageOutput() {
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

  Widget _buildImageOutput() {
    if (_outData == null) return Container();

    return Column(children: <Widget>[
      GCWImageView(imageData: GCWImageViewData(GCWFile(bytes: _outData!))),
      _codeData != null
          ? GCWOutput(
              title: i18n(context, 'binary2image_code_data'), child: _codeData)
          : Container(),
    ]);
  }

  Future<void> _exportFile(BuildContext context, Uint8List data) async {
    var fileType = getFileType(data);
    await saveByteDataToFile(
            context, data, buildFileNameWithDate('img_', fileType))
        .then((value) {
      var content = fileClass(fileType) == FileClass.IMAGE
          ? imageContent(context, data)
          : null;
      if (value) showExportedFileDialog(context, contentWidget: content);
    });
  }
}
