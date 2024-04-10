import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/application/theme/theme_colors.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_iconbutton.dart';
import 'package:gc_wizard/common_widgets/dialogs/gcw_exported_file_dialog.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_dropdown.dart';
import 'package:gc_wizard/common_widgets/gcw_expandable.dart';
import 'package:gc_wizard/common_widgets/gcw_openfile.dart';
import 'package:gc_wizard/common_widgets/gcw_snackbar.dart';
import 'package:gc_wizard/common_widgets/gcw_text.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/spinners/gcw_integer_spinner.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_twooptions_switch.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/tools/images_and_files/qr_code/logic/qr_code.dart';
import 'package:gc_wizard/utils/file_utils/file_utils.dart';
import 'package:gc_wizard/utils/file_utils/gcw_file.dart';
import 'package:gc_wizard/utils/ui_dependent_utils/file_widget_utils.dart';
import 'package:gc_wizard/utils/ui_dependent_utils/image_utils/image_utils.dart';

class QrCode extends StatefulWidget {
  final GCWFile? file;

  const QrCode({Key? key, this.file}) : super(key: key);

  @override
  _QrCodeState createState() => _QrCodeState();
}

class _QrCodeState extends State<QrCode> {
  var _currentInput = '';
  var _currentModulSize = 5;
  Uint8List? _outData;
  Uint8List? _outDataEncrypt;
  String? _outDataEncryptText;
  String? _outDataDecrypt;
  late TextEditingController _inputController;
  GCWSwitchPosition _currentMode = GCWSwitchPosition.right;
  static int maxLength = 2952;
  var lastCurrentInputLength = 0;
  var _currentExpanded = false;
  var _currentSize = 0;
  var _currentErrorCorrectLevel = defaultErrorCorrectLevel;

  @override
  void initState() {
    super.initState();
    _inputController = TextEditingController(text: _currentInput);
    if (widget.file != null) {
      _currentMode = GCWSwitchPosition.right;
      _outData = widget.file?.bytes;
      _updateOutput();
    }
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
        _currentMode == GCWSwitchPosition.right
            ? GCWOpenFile(
                supportedFileTypes: SUPPORTED_IMAGE_TYPES,
                onLoaded: (GCWFile? value) {
                  if (value == null) {
                    showSnackBar(i18n(context, 'common_loadfile_exception_notloaded'), context);
                    return;
                  }

                  setState(() {
                    _outData = value.bytes;
                    _updateOutput();
                  });
                },
              )
            : GCWTextField(
                controller: _inputController,
                onChanged: (value) {
                  setState(() {
                    _currentInput = value;
                    _updateOutput();
                  });
                },
              ),
        _currentMode == GCWSwitchPosition.right
            ? Container()
            : _buildAdvancedWidget(),
        ((_currentMode == GCWSwitchPosition.right) && (_outData != null))
            ? Container(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Image.memory(_outData!),
              )
            : Container(),
        _currentMode == GCWSwitchPosition.right
            ? Container()
            : Column(children: [
                GCWIntegerSpinner(
                  title: i18n(context, 'qr_code_modulsize'),
                  flexValues: const [1, 1],
                  value: _currentModulSize,
                  min: 1,
                  max: 100,
                  onChanged: (value) {
                    _currentModulSize = value;
                    _updateOutput();
                  },
                ),
              ]),
        GCWTwoOptionsSwitch(
          value: _currentMode,
          onChanged: (value) {
            setState(() {
              _currentMode = value;
            });
          },
        ),
        GCWDefaultOutput(
            child: _buildOutput(),
            trailing: (_currentMode == GCWSwitchPosition.right)
                ? null
                : GCWIconButton(
                    icon: Icons.save,
                    size: IconButtonSize.SMALL,
                    iconColor: _outDataEncrypt == null ? themeColors().inActive() : null,
                    onPressed: () {
                      _outDataEncrypt == null ? null : _exportFile(context, _outDataEncrypt!);
                    },
                  ))
      ],
    );
  }

  Widget _buildAdvancedWidget() {
    return Column(
      children: [
        GCWExpandableTextDivider(
          text: i18n(context, 'common_mode_advanced'),
          expanded: _currentExpanded,
          onChanged: (value) {
            setState(() {
              _currentExpanded = value;
            });
          },
          child: Column (
            children: [
              Row(children: <Widget>[
                Expanded(child: GCWText(text: i18n(context, 'qr_code_size_version'))),
                Expanded(
                  child: GCWDropDown<int>(
                      value: _currentSize,
                      onChanged: (int value) {
                        setState(() {
                          _currentSize = value;
                          _updateOutput();
                        });
                      },
                      items: buildSizeList(),
                      ),
                  ),
              ]),
              Row(children: <Widget>[
                Expanded(child: GCWText(text: i18n(context, 'qr_code_error_correct_level'))),
                Expanded(
                  child: GCWDropDown<int>(
                      value: _currentErrorCorrectLevel,
                      onChanged: (int value) {
                        setState(() {
                          _currentErrorCorrectLevel = value;
                          _updateOutput();
                        });
                      },
                      items: errorCorrectLevel().entries.map((set) {
                          return GCWDropDownMenuItem(
                            value: set.key,
                            child: set.value,
                          );
                        }).toList(),
                      ),
                )
            ])
          ])
        ),
      ],
    );
  }

  List<GCWDropDownMenuItem<int>> buildSizeList() {
    List<GCWDropDownMenuItem<int>> list = [];
    list.add(GCWDropDownMenuItem(
      value: 0,
      child: i18n(context, 'common_automatic'),
    ));
    for (int i = 1; i <= 40; i++) {
      var size = (17 + i * 4).toString();
      list.add(GCWDropDownMenuItem(
        value: i,
        child: size + ' x ' + size + ' (v' + i.toString() + ')',
      ));
    }
    return list;
  }

  Object? _buildOutput() {
    if (_currentMode == GCWSwitchPosition.left) {
      if (_outDataEncrypt == null && _outDataEncryptText == null) return null;
      if (_outDataEncryptText != null) return  _outDataEncryptText;
      return Image.memory(_outDataEncrypt!);
    } else {
      if (_outDataDecrypt == null) return null;
      return _outDataDecrypt!;
    }
  }

  void _updateOutput() {
    try {
      if (_currentMode == GCWSwitchPosition.left) {
        var currentInput = _currentInput;
        if ((currentInput.length > maxLength) && (lastCurrentInputLength <= maxLength)) {
          currentInput = currentInput.substring(0, maxLength);
          showSnackBar(i18n(context, 'qr_code_length_limited', parameters: [maxLength.toString()]), context);
        }
        lastCurrentInputLength = _currentInput.length;

        _outDataEncrypt = null;
        _outDataEncryptText = null;
        var qrCode = generateBarCode(currentInput,
            moduleSize: _currentModulSize, border: 2 * _currentModulSize,
            errorCorrectLevel: _currentErrorCorrectLevel,
            version: _currentSize);
        if (qrCode == null) return;
        if (qrCode.lines.length == 2 && qrCode.lines.first == inputTooLongException) {
          _outDataEncryptText = i18n(context, 'qr_code_size_error') + ' (' + qrCode.lines[1] + ')';
          return;
        }
        input2Image(qrCode).then((qr_code) {
          setState(() {
            _outDataEncrypt = qr_code;
          });
        });
      } else {
        if (_outData == null) return;

        scanBytes(_outData).then((text) {
          setState(() {
            if (text == null || text!.isEmpty) text = i18n(context, 'qr_code_nothingfound');

            _outDataDecrypt = text!;
          });
        });
      }
    } catch (e) {
      setState(() {});
    }
  }

  Future<void> _exportFile(BuildContext context, Uint8List data) async {
    var fileType = getFileType(data);
    await saveByteDataToFile(context, data, buildFileNameWithDate('img_', fileType)).then((value) {
      var content = fileClass(fileType) == FileClass.IMAGE ? imageContent(context, data) : null;
      if (value) showExportedFileDialog(context, contentWidget: content);
    });
  }
}
