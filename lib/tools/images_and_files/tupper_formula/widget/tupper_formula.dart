import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/application/theme/theme_colors.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_iconbutton.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_submit_button.dart';
import 'package:gc_wizard/common_widgets/gcw_painter_container.dart';
import 'package:gc_wizard/common_widgets/image_viewers/gcw_imageview.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_output.dart';
import 'package:gc_wizard/common_widgets/spinners/gcw_dropdown_spinner.dart';
import 'package:gc_wizard/common_widgets/spinners/gcw_integer_spinner.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_twooptions_switch.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/tools/images_and_files/binary2image/logic/binary2image.dart';
import 'package:gc_wizard/tools/images_and_files/qr_code/logic/qr_code.dart';
import 'package:gc_wizard/tools/images_and_files/tupper_formula/logic/tupper_formula.dart';
import 'package:gc_wizard/tools/images_and_files/tupper_formula/widget/tupper_formula_board.dart';
import 'package:gc_wizard/utils/file_utils/gcw_file.dart';
import 'package:gc_wizard/utils/ui_dependent_utils/image_utils/image_utils.dart';

class TupperFormula extends StatefulWidget {
  final GCWFile? file;

  const TupperFormula({super.key, this.file});

  @override
  _TupperFormulaState createState() => _TupperFormulaState();
}

class _TupperFormulaState extends State<TupperFormula> {
  String _currentInput = '';
  int _currentWidth = 106;
  int _currentHeight = 17;
  int _currentColorIndex = 0;
  int _currentColors = 2;
  GCWSwitchPosition _currentFormulaMode = GCWSwitchPosition.left;

  late TupperData _board;

  Uint8List? _outData;
  String? _codeData;

  BigInt _currentK = BigInt.zero;

  late TextEditingController _inputController;
  GCWSwitchPosition _currentMode = GCWSwitchPosition.right;

  @override
  void initState() {
    super.initState();
    _inputController = TextEditingController(text: _currentInput);

    _board = TupperData(width: _currentWidth, height: _currentHeight);
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
        GCWTwoOptionsSwitch(
          value: _currentMode,
          onChanged: (value) {
            setState(() {
              _currentMode = value;
            });
          },
        ),
        GCWTwoOptionsSwitch(
          leftValue: i18n(context, 'common_original'),
          rightValue: i18n(context, 'common_custom'),
          value: _currentFormulaMode,
          onChanged: (value) {
            setState(() {
              _currentFormulaMode = value;
              if (_currentFormulaMode == GCWSwitchPosition.left) {
                _currentHeight = 17;
                _currentWidth = 106;
                _currentColorIndex = 0;
              }
            });
          },
        ),
        (_currentFormulaMode == GCWSwitchPosition.right) // custom
            ? Column(children: [
                Row(
                  children: [
                    Expanded(
                      child: GCWIntegerSpinner(
                          title: i18n(context, 'common_width'),
                          min: 1,
                          max: 640,
                          onChanged: (value) {
                            setState(() {
                              _currentWidth = value;
                              _board = TupperData(
                                  width: _currentWidth, height: _currentHeight);
                            });
                          },
                          value: _currentWidth),
                    ),
                    Expanded(
                      child: GCWIntegerSpinner(
                          title: i18n(context, 'common_height'),
                          min: 1,
                          max: 480,
                          onChanged: (value) {
                            setState(() {
                              _currentHeight = value;
                              _board = TupperData(
                                  width: _currentWidth, height: _currentHeight);
                            });
                          },
                          value: _currentHeight),
                    ),
                  ],
                ),
                _currentMode == GCWSwitchPosition.left // encrypt
                    ? GCWDropDownSpinner(
                        onChanged: (value) {
                          setState(() {
                            _currentColorIndex = value;
                          });
                        },
                        index: _currentColorIndex,
                        items: const ['2', '4', '8', '16'])
                    : GCWIntegerSpinner(
                        min: 2,
                        max: 24,
                        onChanged: (value) {
                          setState(() {
                            _currentColors = value;
                          });
                        },
                        value: _currentColors),
              ])
            : Container(),
        _currentMode == GCWSwitchPosition.left // encrypt
            ? Column(
                children: [
                  GCWPainterContainer(
                    child: TupperFormulaBoard(
                      width: _currentWidth,
                      height: _currentHeight,
                      colors: TUPPER_COLOR_NUMBERS[_currentColorIndex]!,
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
                            _currentK = _board.getK(
                                _currentFormulaMode == GCWSwitchPosition.left,);
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
            : Column(
          children: [
            GCWTextField(
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp('[0-9]')),
              ],
              labelText: 'k',
              controller: _inputController,
              onChanged: (value) {
                setState(() {
                  _currentInput = value;
                });
              },
            ),
            GCWSubmitButton(
                onPressed: () {
                  setState(() {
                    _createImageOutput();
                  });
                },
                ),
          ],
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

    var image = binary2Image(
        kToImage(_currentInput, _currentFormulaMode == GCWSwitchPosition.left,
            _currentWidth, _currentHeight, _currentColors),
    );
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

}
