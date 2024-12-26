import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_button.dart';
import 'package:gc_wizard/common_widgets/clipboard/gcw_clipboard.dart';
import 'package:gc_wizard/common_widgets/dialogs/gcw_exported_file_dialog.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_twooptions_switch.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/tools/images_and_files/qr_code/logic/qr_code.dart';
import 'package:gc_wizard/utils/file_utils/file_utils.dart';
import 'package:gc_wizard/utils/ui_dependent_utils/file_widget_utils.dart';
import 'package:gc_wizard/utils/ui_dependent_utils/image_utils/image_utils.dart';

enum TextExportMode { TEXT, QR }

enum PossibleExportMode { TEXTONLY, QRONLY, BOTH }

const MAX_QR_TEXT_LENGTH_FOR_EXPORT = 1000;

class GCWTextExport extends StatefulWidget {
  final String text;
  final void Function(TextExportMode)? onModeChanged;
  late PossibleExportMode possibleExportMode;
  late TextExportMode initMode;
  final FileType? saveFileTypeText;
  final String? saveFilenamePrefix;

  GCWTextExport(
      {Key? key,
      required this.text,
      this.onModeChanged,
      this.possibleExportMode = PossibleExportMode.BOTH,
      this.initMode = TextExportMode.QR,
      this.saveFileTypeText,
      this.saveFilenamePrefix})
      : super(key: key) {
    if (text.length > MAX_QR_TEXT_LENGTH_FOR_EXPORT) {
      possibleExportMode = PossibleExportMode.TEXTONLY;
      initMode = TextExportMode.TEXT;
    }
  }

  @override
  _GCWTextExportState createState() => _GCWTextExportState();
}

class _GCWTextExportState extends State<GCWTextExport> {
  var _currentMode = TextExportMode.QR;

  late TextEditingController _textExportController;
  String? _currentExportText;

  Uint8List? _qrImageData;

  late PossibleExportMode _currentPossibleMode;

  @override
  void initState() {
    super.initState();

    _currentExportText = widget.text;
    _currentMode = widget.initMode;
    _textExportController = TextEditingController(text: _currentExportText);

    _currentPossibleMode = widget.possibleExportMode;
    if ([PossibleExportMode.QRONLY, PossibleExportMode.BOTH].contains(widget.possibleExportMode)) {
      if (widget.text.length > MAX_QR_TEXT_LENGTH_FOR_EXPORT) {
        _currentPossibleMode = PossibleExportMode.TEXTONLY;
        _currentMode = TextExportMode.TEXT;
      }
    }
  }

  @override
  void dispose() {
    _textExportController.dispose();

    super.dispose();
  }

  void _buildQRCode() {
    _qrImageData = null;
    if (_currentExportText == null) return;
    var qrCode = generateBarCode(_currentExportText!);
    if (qrCode == null) return;
    input2Image(qrCode).then((qr_code) {
      setState(() {
        _qrImageData = qr_code;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_currentMode == TextExportMode.QR && _qrImageData == null) _buildQRCode();

    return SizedBox(
        width: 300,
        height: 420,
        child: Column(
          children: <Widget>[
            _currentPossibleMode == PossibleExportMode.BOTH
                ? GCWTwoOptionsSwitch(
                    leftValue: 'QR',
                    rightValue: i18n(context, 'common_text'),
                    alternativeColor: true,
                    value: _currentMode == TextExportMode.QR ? GCWSwitchPosition.left : GCWSwitchPosition.right,
                    onChanged: (value) {
                      setState(() {
                        _currentMode = value == GCWSwitchPosition.left ? TextExportMode.QR : TextExportMode.TEXT;
                        if (widget.onModeChanged != null) widget.onModeChanged!(_currentMode);

                        if (_currentMode == TextExportMode.QR) _buildQRCode();
                      });
                    },
                  )
                : Container(),
            _currentMode == TextExportMode.QR
                ? (
                    _qrImageData == null ? Container() : Column(
                      children: [
                        Image.memory(_qrImageData!),
                        GCWButton(
                          text: i18n(context, 'common_save'),
                          onPressed: () {
                            var fileName = buildFileNameWithDate((widget.saveFilenamePrefix ?? 'export') + '_', FileType.PNG);
                            saveByteDataToFile(context, _qrImageData!, fileName).then((value) {
                              if (value) showExportedFileDialog(context, contentWidget: imageContent(context, _qrImageData!));
                            });
                          },
                        )
                      ]
                    )
                  )
                : Column(
                    children: <Widget>[
                      GCWTextField(
                        controller: _textExportController,
                        filled: true,
                        maxLines: 10,
                        fontSize: 10.0,
                        onChanged: (value) {
                          setState(() {
                            _currentExportText = value;
                          });
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          GCWButton(
                            text: i18n(context, 'common_copy'),
                            onPressed: () {
                              if (_currentExportText != null) insertIntoGCWClipboard(context, _currentExportText!);
                            },
                          ),
                          Container(width: 50),
                          GCWButton(
                            text: i18n(context, 'common_save'),
                            onPressed: () {
                              if (_currentExportText != null) {
                                try {
                                  var fileName = buildFileNameWithDate((widget.saveFilenamePrefix ?? 'export') + '_', widget.saveFileTypeText ?? FileType.TXT);
                                  saveStringToFile(context, _currentExportText!, fileName).whenComplete(() => Navigator.pop(context));
                                } on Exception {}
                              }
                            },
                          ) ,
                        ]
                      )
                    ],
                  ),
          ],
        ));
  }
}
