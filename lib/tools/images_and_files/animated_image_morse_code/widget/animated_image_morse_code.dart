import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/app_localizations.dart';
import 'package:gc_wizard/application/theme/theme_colors.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_iconbutton.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_submit_button.dart';
import 'package:gc_wizard/common_widgets/dialogs/gcw_exported_file_dialog.dart';
import 'package:gc_wizard/common_widgets/dividers/gcw_text_divider.dart';
import 'package:gc_wizard/common_widgets/gcw_async_executer.dart';
import 'package:gc_wizard/common_widgets/gcw_openfile.dart';
import 'package:gc_wizard/common_widgets/gcw_text.dart';
import 'package:gc_wizard/common_widgets/gcw_toast.dart';
import 'package:gc_wizard/common_widgets/image_viewers/gcw_gallery.dart';
import 'package:gc_wizard/common_widgets/image_viewers/gcw_imageview.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_output_text.dart';
import 'package:gc_wizard/common_widgets/spinners/gcw_integer_spinner.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_twooptions_switch.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/tools/images_and_files/animated_image/widget/animated_image.dart';
import 'package:gc_wizard/tools/images_and_files/animated_image_morse_code/logic/animated_image_morse_code.dart';
import 'package:gc_wizard/utils/file_utils/file_utils.dart';
import 'package:gc_wizard/utils/file_utils/gcw_file.dart' as local;
import 'package:gc_wizard/utils/ui_dependent_utils/file_widget_utils.dart';
import 'package:intl/intl.dart';
import 'package:tuple/tuple.dart';

class AnimatedImageMorseCode extends StatefulWidget {
  final local.GCWFile platformFile;

  const AnimatedImageMorseCode({Key key, this.platformFile}) : super(key: key);

  @override
  AnimatedImageMorseCodeState createState() => AnimatedImageMorseCodeState();
}

class AnimatedImageMorseCodeState extends State<AnimatedImageMorseCode> {
  Map<String, dynamic> _outData;
  var _marked = <bool>[];
  Map<String, dynamic> _outText;
  local.GCWFile _platformFile;
  GCWSwitchPosition _currentMode = GCWSwitchPosition.right;
  bool _play = false;
  bool _filtered = true;

  Uint8List _highImage;
  Uint8List _lowImage;
  String _currentInput = '';
  int _currentDotDuration = 400;
  TextEditingController _currentDotDurationController;
  TextEditingController _currentInputController;
  Uint8List _encodeOutputImage;

  @override
  void initState() {
    super.initState();

    _currentInputController = TextEditingController(text: _currentInput);
    _currentDotDurationController = TextEditingController(text: _currentDotDuration.toString());
  }

  @override
  void dispose() {
    _currentInputController.dispose();
    _currentDotDurationController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.platformFile != null) {
      _platformFile = widget.platformFile;
      _analysePlatformFileAsync();
    }

    return Column(children: <Widget>[
      GCWTwoOptionsSwitch(
        value: _currentMode,
        onChanged: (value) {
          setState(() {
            _currentMode = value;
          });
        },
      ),
      _currentMode == GCWSwitchPosition.right ? _decodeWidgets() : _encodeWidgets()
    ]);
  }

  Widget _decodeWidgets() {
    return Column(children: <Widget>[
      GCWOpenFile(
        supportedFileTypes: AnimatedImageState.allowedExtensions,
        onLoaded: (_file) {
          if (_file == null) {
            showToast(i18n(context, 'common_loadfile_exception_notloaded'));
            return;
          }

          if (_file != null) {
            setState(() {
              _platformFile = _file;
              _analysePlatformFileAsync();
            });
          }
        },
      ),
      GCWDefaultOutput(
          child: _buildOutputDecode(),
          trailing: Row(children: <Widget>[
            GCWIconButton(
              icon: _filtered ? Icons.filter_alt : Icons.filter_alt_outlined,
              size: IconButtonSize.SMALL,
              iconColor: _outData != null ? null : themeColors().inActive(),
              onPressed: () {
                setState(() {
                  _filtered = !_filtered;
                });
              },
            ),
            GCWIconButton(
              icon: Icons.play_arrow,
              size: IconButtonSize.SMALL,
              iconColor: _outData != null && !_play ? null : themeColors().inActive(),
              onPressed: () {
                setState(() {
                  _play = (_outData != null);
                });
              },
            ),
            GCWIconButton(
              icon: Icons.stop,
              size: IconButtonSize.SMALL,
              iconColor: _play ? null : themeColors().inActive(),
              onPressed: () {
                setState(() {
                  _play = false;
                });
              },
            ),
            GCWIconButton(
              icon: Icons.save,
              size: IconButtonSize.SMALL,
              iconColor: _outData == null ? themeColors().inActive() : null,
              onPressed: () {
                _outData == null ? null : _exportFiles(context, _platformFile.name, _outData["images"]);
              },
            )
          ]))
    ]);
  }

  Widget _buildOutputDecode() {
    if (_outData == null) return null;

    return Column(children: <Widget>[
      _play
          ? Image.memory(_platformFile.bytes)
          : _filtered
              ? GCWGallery(
                  imageData:
                      _convertImageDataFiltered(_outData["images"], _outData["durations"], _outData["imagesFiltered"]),
                  onDoubleTap: (index) {
                    setState(() {
                      List<List<int>> imagesFiltered = _outData["imagesFiltered"];

                      _marked[imagesFiltered[index].first] = !_marked[imagesFiltered[index].first];
                      _markedListSetColumn(imagesFiltered[index], _marked[imagesFiltered[index].first]);
                      _outText = decodeMorseCode(_outData["durations"], _marked);
                    });
                  },
                )
              : GCWGallery(
                  imageData: _convertImageData(_outData["images"], _outData["durations"], _outData["imagesFiltered"]),
                  onDoubleTap: (index) {
                    setState(() {
                      if (_marked != null && index < _marked.length) _marked[index] = !_marked[index];
                      _outText = decodeMorseCode(_outData["durations"], _marked);
                    });
                  },
                ),
      _buildDecodeOutput(),
    ]);
  }

  Widget _buildDecodeOutput() {
    return Column(children: <Widget>[
      GCWDefaultOutput(child: GCWOutputText(text: _outText == null ? "" : _outText["text"])),
      GCWOutput(
          title: i18n(context, 'animated_image_morse_code_morse_code'),
          child: GCWOutputText(text: _outText == null ? "" : _outText["morse"])),
    ]);
  }

  Widget _encodeWidgets() {
    return Column(children: [
      Row(children: [
        Expanded(child: GCWTextDivider(text: i18n(context, 'animated_image_morse_code_high_signal'))),
        Expanded(child: GCWTextDivider(text: i18n(context, 'animated_image_morse_code_low_signal'))),
      ]),
      Row(children: [
        Expanded(
          child: Column(children: [
            GCWOpenFile(
              supportedFileTypes: AnimatedImageState.allowedExtensions,
              onLoaded: (_file) {
                if (_file != null)
                  setState(() {
                    _highImage = _file.bytes;
                  });
              },
            ),
          ]),
        ),
        Expanded(
          child: Column(children: [
            GCWOpenFile(
              supportedFileTypes: AnimatedImageState.allowedExtensions,
              onLoaded: (_file) {
                if (_file != null)
                  setState(() {
                    _lowImage = _file.bytes;
                  });
              },
            ),
          ]),
        ),
      ]),
      Row(children: [
        Expanded(child: _highImage != null ? Image.memory(_highImage) : Container()),
        Expanded(child: _lowImage != null ? Image.memory(_lowImage) : Container()),
      ]),
      Row(children: <Widget>[
        Expanded(child: GCWText(text: i18n(context, 'animated_image_morse_code_dot_duration') + ':'), flex: 1),
        Expanded(
            child: GCWIntegerSpinner(
              controller: _currentDotDurationController,
              min: 0,
              max: 999999,
              onChanged: (value) {
                setState(() {
                  _currentDotDuration = value;
                });
              },
            ),
            flex: 2),
      ]),
      GCWTextField(
        controller: _currentInputController,
        onChanged: (text) {
          setState(() {
            _currentInput = text;
          });
        },
      ),
      _buildEncodeSubmitButton(),
      GCWDefaultOutput(
          child: _buildOutputEncode(),
          trailing: Row(children: <Widget>[
            GCWIconButton(
              icon: Icons.save,
              size: IconButtonSize.SMALL,
              iconColor: _encodeOutputImage == null ? themeColors().inActive() : null,
              onPressed: () {
                _encodeOutputImage == null ? null : _exportFile(context, _encodeOutputImage);
              },
            )
          ]))
    ]);
  }

  Widget _buildEncodeSubmitButton() {
    return GCWSubmitButton(onPressed: () async {
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return Center(
            child: Container(
              child: GCWAsyncExecuter(
                isolatedFunction: createImageAsync,
                parameter: _buildJobDataEncode(),
                onReady: (data) => _saveOutputEncode(data),
                isOverlay: true,
              ),
              height: 220,
              width: 150,
            ),
          );
        },
      );
    });
  }

  Widget _buildOutputEncode() {
    if (_encodeOutputImage == null) return null;

    return Column(children: <Widget>[Image.memory(_encodeOutputImage)]);
  }

  _initMarkedList(List<Uint8List> images, List<List<int>> imagesFiltered) {
    if (_marked == null || _marked.length != images.length) {
      _marked = List.filled(images.length, false);

      // first image default as high signal
      if (imagesFiltered.length == 2) {
        _markedListSetColumn(imagesFiltered[0], true);
      }
    }
  }

  _markedListSetColumn(List<int> imagesFiltered, bool value) {
    imagesFiltered.forEach((idx) {
      _marked[idx] = value;
    });
  }

  List<GCWImageViewData> _convertImageDataFiltered(
      List<Uint8List> images, List<int> durations, List<List<int>> imagesFiltered) {
    var list = <GCWImageViewData>[];

    if (images != null) {
      var imageCount = images.length;
      _initMarkedList(images, imagesFiltered);

      for (var i = 0; i < imagesFiltered.length; i++) {
        String description = imagesFiltered[i].length.toString() + '/$imageCount';

        var image = images[imagesFiltered[i].first];
        list.add(GCWImageViewData(local.GCWFile(bytes: image),
            description: description, marked: _marked[imagesFiltered[i].first]));
      }
      _outText = decodeMorseCode(durations, _marked);
    }
    return list;
  }

  List<GCWImageViewData> _convertImageData(
      List<Uint8List> images, List<int> durations, List<List<int>> imagesFiltered) {
    var list = <GCWImageViewData>[];

    if (images != null) {
      var imageCount = images.length;
      _initMarkedList(images, imagesFiltered);

      for (var i = 0; i < images.length; i++) {
        String description = (i + 1).toString() + '/$imageCount';
        if ((durations != null) && (i < durations.length)) {
          description += ': ' + durations[i].toString() + ' ms';
        }
        list.add(GCWImageViewData(local.GCWFile(bytes: images[i]), description: description, marked: _marked[i]));
      }
      _outText = decodeMorseCode(durations, _marked);
    }
    return list;
  }

  _analysePlatformFileAsync() async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Center(
          child: Container(
            child: GCWAsyncExecuter(
              isolatedFunction: analyseImageMorseCodeAsync,
              parameter: _buildJobDataDecode(),
              onReady: (data) => _saveOutputDecode(data),
              isOverlay: true,
            ),
            height: 220,
            width: 150,
          ),
        );
      },
    );
  }

  Future<GCWAsyncExecuterParameters> _buildJobDataDecode() async {
    return GCWAsyncExecuterParameters(_platformFile.bytes);
  }

  Future<GCWAsyncExecuterParameters> _buildJobDataEncode() async {
    return GCWAsyncExecuterParameters(
        Tuple4<Uint8List, Uint8List, String, int>(_highImage, _lowImage, _currentInput, _currentDotDuration));
  }

  _saveOutputDecode(Map<String, dynamic> output) {
    _outData = output;
    _marked = null;

    // restore image references (problem with sendPort, lose references)
    if (_outData != null) {
      List<Uint8List> images = _outData["images"];
      List<int> linkList = _outData["linkList"];
      for (int i = 0; i < images.length; i++) {
        images[i] = images[linkList[i]];
      }
    } else {
      showToast(i18n(context, 'common_loadfile_exception_notloaded'));
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {});
    });
  }

  _saveOutputEncode(Uint8List output) {
    _encodeOutputImage = output;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {});
    });
  }

  _exportFiles(BuildContext context, String fileName, List<Uint8List> data) async {
    createZipFile(fileName, '.' + fileExtension(FileType.PNG), data).then((bytes) async {
      var fileType = FileType.ZIP;
      var value = await saveByteDataToFile(context, bytes,
          'anim_' + DateFormat('yyyyMMdd_HHmmss').format(DateTime.now()) + '.' + fileExtension(fileType));

      if (value != null) showExportedFileDialog(context, fileType: fileType);
    });
  }

  _exportFile(BuildContext context, Uint8List data) async {
    var fileType = getFileType(data);
    var value = await saveByteDataToFile(context, data,
        'anim_export_' + DateFormat('yyyyMMdd_HHmmss').format(DateTime.now()) + '.' + fileExtension(fileType));

    if (value != null) showExportedFileDialog(context, fileType: fileType);
  }
}
