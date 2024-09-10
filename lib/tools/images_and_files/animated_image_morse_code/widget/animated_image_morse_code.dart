import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/application/theme/theme_colors.dart';
import 'package:gc_wizard/common_widgets/async_executer/gcw_async_executer.dart';
import 'package:gc_wizard/common_widgets/async_executer/gcw_async_executer_parameters.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_iconbutton.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_submit_button.dart';
import 'package:gc_wizard/common_widgets/dialogs/gcw_exported_file_dialog.dart';
import 'package:gc_wizard/common_widgets/dividers/gcw_text_divider.dart';
import 'package:gc_wizard/common_widgets/gcw_openfile.dart';
import 'package:gc_wizard/common_widgets/gcw_snackbar.dart';
import 'package:gc_wizard/common_widgets/gcw_text.dart';
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
import 'package:gc_wizard/utils/file_utils/gcw_file.dart';
import 'package:gc_wizard/utils/ui_dependent_utils/file_widget_utils.dart';
import 'package:tuple/tuple.dart';

class AnimatedImageMorseCode extends StatefulWidget {
  final GCWFile? file;

  const AnimatedImageMorseCode({Key? key, this.file}) : super(key: key);

  @override
  _AnimatedImageMorseCodeState createState() => _AnimatedImageMorseCodeState();
}

class _AnimatedImageMorseCodeState extends State<AnimatedImageMorseCode> {
  AnimatedImageMorseOutput? _outData;
  List<bool> _marked = [];
  MorseCodeOutput? _outText;
  GCWFile? _file;
  GCWSwitchPosition _currentMode = GCWSwitchPosition.right;
  bool _play = false;
  bool _filtered = true;

  Uint8List? _highImage;
  Uint8List? _lowImage;
  String _currentInput = '';
  int _currentDotDuration = 400;
  late TextEditingController _currentDotDurationController;
  late TextEditingController _currentInputController;
  Uint8List? _encodeOutputImage;

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
    if (widget.file != null) {
      _file = widget.file;
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
        supportedFileTypes: ANIMATED_IMAGE_ALLOWED_FILETYPES,
        onLoaded: (GCWFile? value) {
          if (value == null) {
            showSnackBar(i18n(context, 'common_loadfile_exception_notloaded'), context);
            return;
          }

          setState(() {
            _file = value;
            _analysePlatformFileAsync();
          });
        },
      ),
      GCWDefaultOutput(
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
                if (_outData != null && _file?.name != null) _exportFiles(context, _file!.name!, _outData!.images);
              },
            )
          ]),
          child: _buildOutputDecode())
    ]);
  }

  Widget _buildOutputDecode() {
    if (_outData == null) return Container();

    return Column(children: <Widget>[
      _play
          ? _file?.bytes == null
              ? Container()
              : Image.memory(_file!.bytes)
          : _filtered
              ? GCWGallery(
                  imageData: _convertImageDataFiltered(_outData!.images, _outData!.durations, _outData!.imagesFiltered),
                  onDoubleTap: (index) {
                    setState(() {
                      List<List<int>> imagesFiltered = _outData!.imagesFiltered;

                      if (_marked.isNotEmpty) {
                        _marked[imagesFiltered[index].first] = !_marked[imagesFiltered[index].first];
                        _markedListSetColumn(imagesFiltered[index], _marked[imagesFiltered[index].first]);
                        _outText = decodeMorseCode(_outData!.durations, _marked);
                      }
                    });
                  },
                )
              : GCWGallery(
                  imageData: _convertImageData(_outData!.images, _outData!.durations, _outData!.imagesFiltered),
                  onDoubleTap: (index) {
                    setState(() {
                      if (index < _marked.length) _marked[index] = !_marked[index];
                      _outText = decodeMorseCode(_outData!.durations, _marked);
                    });
                  },
                ),
      _buildDecodeOutput(),
    ]);
  }

  Widget _buildDecodeOutput() {
    var output = _outText?.text;
    if (output == null || output.isEmpty) output = i18n(context, 'animated_image_select_on_image');
    return Column(children: <Widget>[
      GCWDefaultOutput(child: GCWOutputText(text: output)),
      GCWOutput(
          title: i18n(context, 'animated_image_morse_code_morse_code'),
          child: GCWOutputText(text: _outText == null ? '' : _outText!.morseCode)),
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
              supportedFileTypes: ANIMATED_IMAGE_ALLOWED_FILETYPES,
              onLoaded: (GCWFile? value) {
                if (value != null) {
                  setState(() {
                    _highImage = value.bytes;
                  });
                }
              },
            ),
          ]),
        ),
        Expanded(
          child: Column(children: [
            GCWOpenFile(
              supportedFileTypes: ANIMATED_IMAGE_ALLOWED_FILETYPES,
              onLoaded: (GCWFile? value) {
                if (value != null) {
                  setState(() {
                    _lowImage = value.bytes;
                  });
                }
              },
            ),
          ]),
        ),
      ]),
      Row(children: [
        Expanded(child: _highImage != null ? Image.memory(_highImage!) : Container()),
        Expanded(child: _lowImage != null ? Image.memory(_lowImage!) : Container()),
      ]),
      Row(children: <Widget>[
        Expanded(flex: 1, child: GCWText(text: i18n(context, 'animated_image_morse_code_dot_duration') + ':')),
        Expanded(
            flex: 2,
            child: GCWIntegerSpinner(
              value: _currentDotDuration,
              controller: _currentDotDurationController,
              min: 0,
              max: 999999,
              onChanged: (value) {
                setState(() {
                  _currentDotDuration = value;
                });
              },
            )),
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
          trailing: Row(children: <Widget>[
            GCWIconButton(
              icon: Icons.save,
              size: IconButtonSize.SMALL,
              iconColor: _encodeOutputImage == null ? themeColors().inActive() : null,
              onPressed: () {
                if (_encodeOutputImage != null) _exportFile(context, _encodeOutputImage!);
              },
            )
          ]),
          child: _buildOutputEncode())
    ]);
  }

  Widget _buildEncodeSubmitButton() {
    return GCWSubmitButton(onPressed: () async {
      await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return Center(
            child: SizedBox(
              height: GCW_ASYNC_EXECUTER_INDICATOR_HEIGHT,
              width: GCW_ASYNC_EXECUTER_INDICATOR_WIDTH,
              child: GCWAsyncExecuter<Uint8List?>(
                isolatedFunction: createImageAsync,
                parameter: _buildJobDataEncode,
                onReady: (data) => _saveOutputEncode(data),
                isOverlay: true,
              ),
            ),
          );
        },
      );
    });
  }

  Widget _buildOutputEncode() {
    if (_encodeOutputImage == null) return Container();

    return Column(children: <Widget>[Image.memory(_encodeOutputImage!)]);
  }

  void _initMarkedList(List<Uint8List> images, List<List<int>> imagesFiltered) {
    if (_marked.length != images.length) {
      _marked = List.filled(images.length, false);

      // first image default as high signal
      if (imagesFiltered.length == 2) {
        _markedListSetColumn(imagesFiltered[0], true);
      }
    }
  }

  void _markedListSetColumn(List<int> imagesFiltered, bool value) {
    for (var idx in imagesFiltered) {
      _marked[idx] = value;
    }
  }

  List<GCWImageViewData> _convertImageDataFiltered(
      List<Uint8List>? images, List<int> durations, List<List<int>> imagesFiltered) {
    var list = <GCWImageViewData>[];

    if (images != null) {
      var imageCount = images.length;
      _initMarkedList(images, imagesFiltered);

      for (var i = 0; i < imagesFiltered.length; i++) {
        String description = imagesFiltered[i].length.toString() + '/$imageCount';

        var image = images[imagesFiltered[i].first];
        list.add(GCWImageViewData(GCWFile(bytes: image),
            description: description, marked: _marked[imagesFiltered[i].first]));
      }
      _outText = decodeMorseCode(durations, _marked);
    }
    return list;
  }

  List<GCWImageViewData> _convertImageData(
      List<Uint8List>? images, List<int> durations, List<List<int>> imagesFiltered) {
    var list = <GCWImageViewData>[];

    if (images != null) {
      var imageCount = images.length;
      _initMarkedList(images, imagesFiltered);

      for (var i = 0; i < images.length; i++) {
        String description = (i + 1).toString() + '/$imageCount';
        if (i < durations.length) {
          description += ': ' + durations[i].toString() + ' ms';
        }

        list.add(GCWImageViewData(GCWFile(bytes: images[i]), description: description, marked: _marked[i]));
      }
      _outText = decodeMorseCode(durations, _marked);
    }
    return list;
  }

  void _analysePlatformFileAsync() async {
    await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Center(
          child: SizedBox(
            height: GCW_ASYNC_EXECUTER_INDICATOR_HEIGHT,
            width: GCW_ASYNC_EXECUTER_INDICATOR_WIDTH,
            child: GCWAsyncExecuter<AnimatedImageMorseOutput?>(
              isolatedFunction: analyseImageMorseCodeAsync,
              parameter: _buildJobDataDecode,
              onReady: (data) => _saveOutputDecode(data),
              isOverlay: true,
            ),
          ),
        );
      },
    );
  }

  Future<GCWAsyncExecuterParameters?> _buildJobDataDecode() async {
    if (_file?.bytes == null) return null;
    return GCWAsyncExecuterParameters(_file!.bytes);
  }

  Future<GCWAsyncExecuterParameters?> _buildJobDataEncode() async {
    if (_highImage == null || _lowImage == null) return null;
    return GCWAsyncExecuterParameters(
        Tuple4<Uint8List, Uint8List, String, int>(_highImage!, _lowImage!, _currentInput, _currentDotDuration));
  }

  void _saveOutputDecode(AnimatedImageMorseOutput? output) {
    _outData = output;
    _marked = [];

    // restore image references (problem with sendPort, lose references)
    if (_outData != null) {
      var linkList = _outData!.linkList;
      for (int i = 0; i < _outData!.images.length; i++) {
        _outData!.images[i] = _outData!.images[linkList[i]];
      }
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          showSnackBar(i18n(context, 'animated_image_select_on_image'), context);
        });
      });
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          showSnackBar(i18n(context, 'common_loadfile_exception_notloaded'), context);
        });
      });
    }
  }

  void _saveOutputEncode(Uint8List? output) {
    _encodeOutputImage = output;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {});
    });
  }

  Future<void> _exportFiles(BuildContext context, String fileName, List<Uint8List> data) async {
    createZipFile(fileName, '.' + fileExtension(FileType.PNG), data).then((bytes) async {
      await saveByteDataToFile(context, bytes, buildFileNameWithDate('anim_', FileType.ZIP)).then((value) {
        if (value) showExportedFileDialog(context);
      });
    });
  }

  Future<void> _exportFile(BuildContext context, Uint8List data) async {
    var fileType = getFileType(data);
    await saveByteDataToFile(context, data, buildFileNameWithDate('anim_export_', fileType)).then((value) {
      var content = fileClass(fileType) == FileClass.IMAGE ? imageContent(context, data) : null;
      if (value) showExportedFileDialog(context, contentWidget: content);
    });
  }
}
