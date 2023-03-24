import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/app_localizations.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_button.dart';
import 'package:gc_wizard/common_widgets/dialogs/gcw_dialog.dart';
import 'package:gc_wizard/common_widgets/gcw_openfile.dart';
import 'package:gc_wizard/common_widgets/gcw_toast.dart';
import 'package:gc_wizard/common_widgets/image_viewers/gcw_imageview.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_twooptions_switch.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/esoteric_programming_languages/piet/logic/piet_image_reader.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/esoteric_programming_languages/piet/logic/piet_language.dart';
import 'package:gc_wizard/utils/file_utils/file_utils.dart';
import 'package:gc_wizard/utils/file_utils/gcw_file.dart';
import 'package:gc_wizard/utils/ui_dependent_utils/image_utils/image_utils.dart';

class Piet extends StatefulWidget {
  final GCWFile? file;

  const Piet({Key? key, this.file}) : super(key: key);

  @override
  PietState createState() => PietState();
}

class PietState extends State<Piet> {
  GCWFile? _originalData;
  String? _currentInterpreterInput;
  String? _currentGeneratorInput;
  PietResult? _currentInterpreterOutput;
  Uint8List? _currentGeneratorOutput;
  var _isStarted = false;
  var _currentMode = GCWSwitchPosition.left;
  late TextEditingController _inputGeneratorController;

  @override
  void initState() {
    super.initState();

    _inputGeneratorController = TextEditingController(text: _currentGeneratorInput);
    if (widget.file?.bytes != null) {
      _originalData = widget.file;
    }
  }

  @override
  void dispose() {
    _inputGeneratorController.dispose();
    super.dispose();
  }

  bool _validateData(Uint8List bytes) {
    return isImage(bytes);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GCWTwoOptionsSwitch(
          leftValue: i18n(context, 'common_programming_mode_interpret'),
          rightValue: i18n(context, 'common_programming_mode_generate'),
          value: _currentMode,
          onChanged: (value) {
            setState(() {
              _currentMode = value;
            });
          },
        ),
        _currentMode == GCWSwitchPosition.left ? _buildInterpreter() : _buildGenerator(),
      ],
    );
  }

  Widget _buildInterpreter() {
    return Column(
      children: <Widget>[
        GCWOpenFile(
          supportedFileTypes: SUPPORTED_IMAGE_TYPES,
          onLoaded: (GCWFile? value) {
            if (value == null || !_validateData(value.bytes)) {
              showToast(i18n(context, 'common_loadfile_exception_notloaded'));
              return;
            }
            setState(() {
              _originalData = value;
              _currentInterpreterInput = null;
              _currentInterpreterOutput = null;
              WidgetsBinding.instance.addPostFrameCallback((_) {
                setState(() {});
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _calcInterpreterOutput();
                });
              });
            });
          },
        ), // Fixes a display issue

        GCWImageView(
          imageData: _originalData?.bytes == null
              ? GCWImageViewData(GCWFile(bytes: Uint8List(0)))
              : GCWImageViewData(GCWFile(bytes: _originalData!.bytes)),
        ),
        _buildInterpreterOutput(context)
      ],
    );
  }

  Widget _buildInterpreterOutput(BuildContext context) {
    if (_originalData?.bytes == null) return const GCWDefaultOutput();
    if (_currentInterpreterOutput == null) return GCWDefaultOutput(child: i18n(context, 'common_please_wait'));

    return GCWDefaultOutput(
      child: (_currentInterpreterOutput?.output ?? '') +
          (_currentInterpreterOutput?.error == true && (_currentInterpreterOutput?.errorText != null)
              ? '\n' + (i18n(context, _currentInterpreterOutput!.errorText, ifTranslationNotExists: _currentInterpreterOutput!.errorText))
              : ''),
    );
  }

  void _calcInterpreterOutput() async {
    if (_isStarted) return;

    _isStarted = true;

    var imageReader = PietImageReader();
    var _pietPixels = _currentInterpreterOutput?.state?.data
        ?? ((_originalData?.bytes == null)
        ? null
        : imageReader.readImage(_originalData!.bytes));

    if (_pietPixels != null) {
      var currentOutputFuture =
      interpretPiet(_pietPixels, _currentInterpreterInput, continueState: _currentInterpreterOutput?.state);

      currentOutputFuture.then((output) {
        if (output.finished) {
          _currentInterpreterOutput = output;
          _isStarted = false;
          setState(() {});
        } else {
          _currentInterpreterOutput = output;
          _currentInterpreterInput = null;
          _showDialogBox(context, output.output);
        }
      });
    }
  }

  Widget _buildGenerator() {
    return Column(
      children: <Widget>[
        GCWTextField(
          controller: _inputGeneratorController,
          onChanged: (text) {
            setState(() {
              _currentGeneratorInput = text;
            });
          },
        ),
        GCWButton(
          text: i18n(context, 'common_start'),
          onPressed: () {
            setState(() {
              _calcGeneratorOutput();
            });
          },
        ),
        _buildGeneratorOutput(context)
      ],
    );
  }

  Widget _buildGeneratorOutput(BuildContext context) {
    if (_currentGeneratorOutput == null) return const GCWDefaultOutput();

    return GCWDefaultOutput(child: GCWImageView(imageData: GCWImageViewData(GCWFile(bytes: _currentGeneratorOutput!))));
  }

  void _calcGeneratorOutput() async {
    _currentGeneratorOutput = null;
    if (_currentGeneratorInput == null) return;
    var generatorOutput = generatePiet(_currentGeneratorInput!);
    input2Image(generatorOutput).then((output) {
      setState(() {
        _currentGeneratorOutput = output;
      });
    });
  }

  void _showDialogBox(BuildContext context, String text) {
    _isStarted = false;
    showGCWDialog(
        context,
        text,
        SizedBox(
          width: 300,
          height: 100,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GCWTextField(
                autofocus: true,
                filled: true,
                onChanged: (text) {
                  _currentInterpreterInput = text;
                },
              ),
            ],
          ),
        ),
        [
          GCWDialogButton(
            text: i18n(context, 'common_ok'),
            onPressed: () {
              _calcInterpreterOutput();
            },
          )
        ],
        cancelButton: false);
  }
}
