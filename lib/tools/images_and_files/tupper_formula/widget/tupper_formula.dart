import 'dart:collection';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/application/theme/theme.dart';
import 'package:gc_wizard/application/theme/theme_colors.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_iconbutton.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_submit_button.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_dropdown.dart';
import 'package:gc_wizard/common_widgets/gcw_painter_container.dart';
import 'package:gc_wizard/common_widgets/image_viewers/gcw_imageview.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_output.dart';
import 'package:gc_wizard/common_widgets/spinners/gcw_integer_spinner.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_twooptions_switch.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/tools/images_and_files/binary2image/logic/binary2image.dart';
import 'package:gc_wizard/tools/images_and_files/qr_code/logic/qr_code.dart';
import 'package:gc_wizard/tools/images_and_files/tupper_formula/logic/tupper_formula.dart';
import 'package:gc_wizard/utils/file_utils/gcw_file.dart';
import 'package:gc_wizard/utils/ui_dependent_utils/image_utils/image_utils.dart';
import 'package:touchable/touchable.dart';

part 'package:gc_wizard/tools/images_and_files/tupper_formula/widget/tupper_formula_board.dart';
part 'package:gc_wizard/tools/images_and_files/tupper_formula/widget/tupper_formula_color_painter.dart';

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
  int _currentColorIndex = 1;
  int _currentColors = 2;
  GCWSwitchPosition _currentFormulaMode = GCWSwitchPosition.left;

  var _currentColor = _GridPaintColor.BLACK;

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
        _buildWidgetModeEncryptDecryt(),
        _buildWidgetModeOriginalCustomFormula(),
        (_currentFormulaMode == GCWSwitchPosition.right) // custom
            ? _buildWidgetCustomSettings()
            : Container(),
        _currentMode == GCWSwitchPosition.left // encrypt
            ? _buildWidgetEncrypt()
            : _buildWidgetDecrypt(),
        _buildOutput(),
      ],
    );
  }

  Widget _buildWidgetModeEncryptDecryt(){
    return GCWTwoOptionsSwitch(
      value: _currentMode,
      onChanged: (value) {
        setState(() {
          _currentMode = value;
        });
      },
    );
  }

  Widget _buildWidgetModeOriginalCustomFormula(){
    return GCWTwoOptionsSwitch(
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
    );
  }

  Widget _buildWidgetCustomSettings(){
    return Column(children: [
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
          ? GCWDropDown(
        title: i18n(context, 'common_color'),
        value: _currentColorIndex,
        onChanged: (value) {
          setState(() {
            _currentColorIndex = value;
          });
        },
        items: SplayTreeMap<int, int>.from(
          TUPPER_COLOR_NUMBERS,
        ).entries.map((mode) {
          return GCWDropDownMenuItem(
            value: mode.key,
            child: mode.value,
          );
        }).toList(),
      )
          : GCWIntegerSpinner(
          min: 2,
          max: 24,
          onChanged: (value) {
            setState(() {
              _currentColors = value;
            });
          },
          value: _currentColors),
    ]);
  }

  Widget _buildWidgetEncrypt(){
    return Column(
      children: [
        GCWPainterContainer(
          child: TupperFormulaBoard(
            width: _currentWidth,
            height: _currentHeight,
            colors: TUPPER_COLOR_NUMBERS[_currentColorIndex]!,
            currentColor: _currentColor,
            state: _board.currentBoard,
            onChanged: (newBoard) {
              setState(() {
                _board.reset(board: newBoard);
              });
            },
          ),
        ),
        (_currentFormulaMode == GCWSwitchPosition.right) // custom
            ? _buildWidgetColorSet()
            : Container(),
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
                    _currentFormulaMode == GCWSwitchPosition.left,
                  );
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
                  _board = TupperData(
                      width: _currentWidth, height: _currentHeight);
                  //_board.reset();
                });
              },
            ),
          )
        ]),
      ],
    );
  }

  Widget _buildWidgetColorSet(){
    List<Widget> colorFields = [];
    List<_GridPaintColor> colors = [];
    Map<_GridPaintColor, Color> colorMap = _GRID_COLORS[TUPPER_COLOR_NUMBERS[_currentColorIndex]]!;
    for (var col in colorMap.keys) {
      colors.add(col);
    }
    for (int i = 0; i < TUPPER_COLOR_NUMBERS[_currentColorIndex]!; i++) {
      colorFields.add(_buildColorField(colors[i]));
    }
    return Row(children: colorFields);
  }

  Expanded _buildColorField(_GridPaintColor color) {
    return Expanded(
        child: InkWell(
          child: Container(
            height: 25,
            decoration: _getColorDecoration(color),
            margin: EdgeInsets.only(
              left: _GridPaintColor.values.indexOf(color) == 0 ? 0.0 : DEFAULT_MARGIN,
              right: _GridPaintColor.values.indexOf(color) == _GridPaintColor.values.length - 1 ? 0.0 : DEFAULT_MARGIN,
            ),
          ),
          onTap: () {
            setState(() {
              _currentColor = color;
            });
          },
        ));
  }

  BoxDecoration _getColorDecoration(_GridPaintColor color) {
    return _currentColor == color
        ? BoxDecoration(
        color: (_GRID_COLORS[TUPPER_COLOR_NUMBERS[_currentColorIndex]]![color] ?? Colors.black),
        border: Border.all(color: themeColors().secondary(), width: 5))
        : BoxDecoration(
        color: (_GRID_COLORS[TUPPER_COLOR_NUMBERS[_currentColorIndex]]![color] ?? Colors.black),
        border: Border.all(color: themeColors().mainFont(), width: 1.0));
  }

  Widget _buildWidgetDecrypt(){
    return Column(
      children: [
        GCWTextField(
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp('[0-9]')),
          ],
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
      colors: _colorMapTupper
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
