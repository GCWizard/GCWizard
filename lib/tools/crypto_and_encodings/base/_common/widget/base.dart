import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/common_widgets/async_executer/gcw_async_executer.dart';
import 'package:gc_wizard/common_widgets/async_executer/gcw_async_executer_parameters.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_button.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_iconbutton.dart';
import 'package:gc_wizard/common_widgets/dialogs/gcw_exported_file_dialog.dart';
import 'package:gc_wizard/common_widgets/gcw_snackbar.dart';
import 'package:gc_wizard/common_widgets/gcw_web_statefulwidget.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_twooptions_switch.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/base/_common/logic/base.dart';
import 'package:gc_wizard/tools/images_and_files/hexstring2file/logic/hexstring2file.dart';
import 'package:gc_wizard/tools/images_and_files/hexstring2file/widget/hexstring2file.dart';
import 'package:gc_wizard/utils/file_utils/file_utils.dart';
import 'package:gc_wizard/utils/ui_dependent_utils/file_widget_utils.dart';

abstract class AbstractBase extends GCWWebStatefulWidget {
  final String Function(String) encode;
  final String Function(String) decode;
  final bool searchMultimedia;

  AbstractBase(
      {Key? key,
      required this.encode,
      required this.decode,
      required this.searchMultimedia,
      required super.apiSpecification})
      : super(key: key);

  @override
  _AbstractBaseState createState() => _AbstractBaseState();
}

class _AbstractBaseState extends State<AbstractBase> {
  final int _MAX_LENGTH_BASE_INPUT = 1000;

  late TextEditingController _inputController;

  String _currentInput = '';
  GCWSwitchPosition _currentMode = GCWSwitchPosition.right;

  _AsyncBaseDecodeReturn? _decodeAsyncBaseData;
  _AsyncBaseDecodeOutput? _outData;

  @override
  void initState() {
    super.initState();

    if (widget.hasWebParameter()) {
      if (widget.getWebParameter('mode') == 'encode') {
        _currentMode = GCWSwitchPosition.left;
      }

      _currentInput = widget.getWebParameter('input') ?? _currentInput;
      widget.webParameter = null;
    }

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
        GCWTextField(
          controller: _inputController,
          onChanged: (text) {
            setState(() {
              _currentInput = text;
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
        _calcAsync()
            ? Column(
                children: [
                  GCWButton(
                    text: i18n(context, 'common_start'),
                    onPressed: () {
                      setState(() {
                        _outData == null;
                        _decodeBaseAsync();
                      });
                    },
                  )
                ],
              )
            : Container(),
        _buildOutput(context)
      ],
    );
  }

  Widget _buildOutput(BuildContext context) {
    var output = '';

    late Widget outputWidget;

    if (_currentMode == GCWSwitchPosition.left) {
      output = widget.encode(_currentInput);
      outputWidget = GCWDefaultOutput(child: output);
    } else {
      if (_calcAsync()) {
        if (_outData == null) return Container();

        if (_outData!.fileData != null) {
          outputWidget = GCWDefaultOutput(
              trailing: GCWIconButton(
                icon: Icons.save,
                size: IconButtonSize.SMALL,
                onPressed: () {
                  _exportFile(context, _outData!.fileData!);
                },
              ),
              child: hexDataOutput(context, <Uint8List>[_outData!.fileData!]));
        } else if (_outData!.plainText != null) {
          outputWidget = GCWDefaultOutput(child: _outData!.plainText);
        } else {
          return Container();
        }
      } else {
        _outData = null;
        output = decodeBase(_currentInput, widget.decode);
        outputWidget = GCWDefaultOutput(child: output);
      }
    }

    return outputWidget;
  }

  bool _calcAsync() {
    return widget.searchMultimedia &&
        _currentMode == GCWSwitchPosition.right &&
        _currentInput.length > _MAX_LENGTH_BASE_INPUT;
  }

  Future<void> _exportFile(BuildContext context, Uint8List data) async {
    var fileType = getFileType(data);
    await saveByteDataToFile(context, data, buildFileNameWithDate('hex_', fileType)).then((value) {
      var content = fileClass(fileType) == FileClass.IMAGE ? imageContent(context, data) : null;
      if (value) showExportedFileDialog(context, contentWidget: content);
    });
  }

  Future<GCWAsyncExecuterParameters?> _buildJobData() async {
    if (_currentInput.isEmpty) return null;
    return GCWAsyncExecuterParameters(_AsyncBaseDecodeParameters(widget.decode, _currentInput));
  }

  void _showOutput(_AsyncBaseDecodeReturn? output) {
    _decodeAsyncBaseData = output;

    // restore image references (problem with sendPort, lose references)
    if (_decodeAsyncBaseData != null) {
      var fileData = hexstring2file(asciiToHexString(_decodeAsyncBaseData!.plainText));
      String? textData;
      if (fileData == null) {
        textData = _decodeAsyncBaseData!.plainText;
      }
      _outData = _AsyncBaseDecodeOutput(fileData, textData);
    } else {
      showSnackBar(i18n(context, 'common_loadfile_exception_notloaded'), context);
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {});
    });
  }

  void _decodeBaseAsync() async {
    await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Center(
          child: SizedBox(
            height: GCW_ASYNC_EXECUTER_INDICATOR_HEIGHT,
            width: GCW_ASYNC_EXECUTER_INDICATOR_WIDTH,
            child: GCWAsyncExecuter<_AsyncBaseDecodeReturn?>(
              isolatedFunction: _execAsyncBaseDecode,
              parameter: _buildJobData,
              onReady: (data) => _showOutput(data),
              isOverlay: true,
            ),
          ),
        );
      },
    );
  }
}

Future<_AsyncBaseDecodeReturn?> _execAsyncBaseDecode(GCWAsyncExecuterParameters? jobData) async {
  if (jobData?.parameters is! _AsyncBaseDecodeParameters) return null;

  var data = jobData!.parameters as _AsyncBaseDecodeParameters;
  var output = _AsyncBaseDecodeReturn(plainText: decodeBase(data.input, data.decode));

  jobData.sendAsyncPort?.send(output);

  return output;
}

class _AsyncBaseDecodeParameters {
  final String Function(String) decode;
  final String input;

  _AsyncBaseDecodeParameters(this.decode, this.input);
}

class _AsyncBaseDecodeReturn {
  final String plainText;
  _AsyncBaseDecodeReturn({required this.plainText});
}

class _AsyncBaseDecodeOutput {
  Uint8List? fileData;
  String? plainText;

  _AsyncBaseDecodeOutput(this.fileData, this.plainText);
}
