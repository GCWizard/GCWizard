import 'dart:typed_data';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/application/navigation/no_animation_material_page_route.dart';
import 'package:gc_wizard/application/theme/theme.dart';
import 'package:gc_wizard/application/theme/theme_colors.dart';
import 'package:gc_wizard/application/tools/widget/gcw_tool.dart';
import 'package:gc_wizard/common_widgets/async_executer/gcw_async_executer.dart';
import 'package:gc_wizard/common_widgets/async_executer/gcw_async_executer_parameters.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_iconbutton.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_submit_button.dart';
import 'package:gc_wizard/common_widgets/dialogs/gcw_exported_file_dialog.dart';
import 'package:gc_wizard/common_widgets/dividers/gcw_divider.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_dropdown.dart';
import 'package:gc_wizard/common_widgets/gcw_expandable.dart';
import 'package:gc_wizard/common_widgets/gcw_openfile.dart';
import 'package:gc_wizard/common_widgets/gcw_snackbar.dart';
import 'package:gc_wizard/common_widgets/gcw_text.dart';
import 'package:gc_wizard/common_widgets/image_viewers/gcw_gallery.dart';
import 'package:gc_wizard/common_widgets/image_viewers/gcw_imageview.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_columned_multiline_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_output.dart';
import 'package:gc_wizard/common_widgets/spinners/gcw_integer_spinner.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_twooptions_switch.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_integer_textfield.dart';
import 'package:gc_wizard/tools/images_and_files/animated_image/logic/animated_image.dart';
import 'package:gc_wizard/tools/images_and_files/animated_image/logic/animated_image_encode.dart';
import 'package:gc_wizard/tools/symbol_tables/_common/widget/gcw_symbol_container.dart';
import 'package:gc_wizard/utils/complex_return_types.dart';
import 'package:gc_wizard/utils/file_utils/file_utils.dart';
import 'package:gc_wizard/utils/file_utils/gcw_file.dart';
import 'package:gc_wizard/utils/ui_dependent_utils/file_widget_utils.dart';

final List<FileType> ANIMATED_IMAGE_ALLOWED_FILETYPES = [FileType.GIF, FileType.PNG, FileType.WEBP];

class AnimatedImage extends StatefulWidget {
  final GCWFile? file;

  const AnimatedImage({super.key, this.file});

  @override
  _AnimatedImageState createState() => _AnimatedImageState();
}

class _AnimatedImageState extends State<AnimatedImage> {
  AnimatedImageOutput? _outData;
  GCWFile? _file;
  bool _play = false;
  var _currentMode = GCWSwitchPosition.right;
  final List<MapEntry<int, int>> _encodeDurations = []; //image index, duration
  final List<TextEditingController?> _textEditingController = [];
  var _loopDuration = 0;
  var _loopCount = 0;
  Uint8List? _encodeOutputImage;
  final List<GCWImageViewData> _encodeImageData = [];
  var _modeEncode = EncodeMode.FORWARD;
  var _expandedEncodeOptions = false;
  int _encodeScale = 100;

  @override
  void dispose() {
    for(var y = 0; y < _textEditingController.length; y++) {
      _textEditingController[y]?.dispose();
    }
    _textEditingController.clear();
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
        _currentMode == GCWSwitchPosition.right ? _buildDecodeWidget(context) : buildEncodeWidget(context)
      ],
    );
  }

  Widget _buildDecodeWidget(BuildContext context) {
    if (widget.file != null) {
      _file = widget.file;
      _analysePlatformFileAsync();
    }

    return Column(children: <Widget>[
      GCWOpenFile(
        key: Key('decode'),
        supportedFileTypes: ANIMATED_IMAGE_ALLOWED_FILETYPES,
        suppressGallery: false,
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
              icon: Icons.play_arrow,
              size: IconButtonSize.SMALL,
              iconColor: _outData != null && !_play ? null : themeColors().inactive(),
              onPressed: () {
                setState(() {
                  _play = (_outData != null);
                });
              },
            ),
            GCWIconButton(
              icon: Icons.stop,
              size: IconButtonSize.SMALL,
              iconColor: _play ? null : themeColors().inactive(),
              onPressed: () {
                setState(() {
                  _play = false;
                });
              },
            ),
            GCWIconButton(
              icon: Icons.save,
              size: IconButtonSize.SMALL,
              iconColor: _outData == null ? themeColors().inactive() : null,
              onPressed: () {
                if (_outData != null && _file?.name != null) _exportFiles(context, _file!.name!, _outData!.images);
              },
            )
          ]),
          child: _buildOutput())
    ]);
  }

  Widget _buildOutput() {
    if (_outData == null) return Container();

    var durations = <List<Object>>[];
    if (_outData!.durations.length > 1) {
      var counter = 0;
      var total = 0;

      durations.addAll([
        [i18n(context, 'animated_image_table_index'), i18n(context, 'animated_image_table_duration')]
      ]);
      for (var value in _outData!.durations) {
        counter++;
        total += value;
        durations.addAll([
          [counter, value]
        ]);
      }
      durations.addAll([
        [i18n(context, 'common_total'), total]
      ]);
    }

    return Column(children: <Widget>[
      _play
          ? (_file?.bytes == null)
              ? Container()
              : Image.memory(_file!.bytes)
          : GCWGallery(imageData: _convertImageData(_outData!.images, _outData!.durations)),
      _buildDurationOutput(durations)
    ]);
  }

  Widget _buildDurationOutput(List<List<Object>> durations) {
    return Column(children: <Widget>[
      const GCWDivider(suppressTopSpace: true, suppressBottomSpace: true),
      GCWOutput(
          child: GCWColumnedMultilineOutput(data: durations, flexValues: const [1, 2], hasHeader: true, copyAll: true)),
    ]);
  }

  List<GCWImageViewData> _convertImageData(List<Uint8List> images, List<int> durations) {
    var list = <GCWImageViewData>[];

    var imageCount = images.length;
    for (var i = 0; i < images.length; i++) {
      String description = (i + 1).toString() + '/$imageCount';
      if (i < durations.length) {
        description += ': ' + durations[i].toString() + ' ms';
      }
      list.add(GCWImageViewData(GCWFile(bytes: images[i]), description: description));
    }
    return list;
  }

  Future<void> _analysePlatformFileAsync() async {
    await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Center(
          child: SizedBox(
            height: GCW_ASYNC_EXECUTER_INDICATOR_HEIGHT,
            width: GCW_ASYNC_EXECUTER_INDICATOR_WIDTH,
            child: GCWAsyncExecuter<AnimatedImageOutput?>(
              isolatedFunction: analyseImageAsync,
              parameter: _buildJobData,
              onReady: (data) => _showOutput(data),
              isOverlay: true,
            ),
          ),
        );
      },
    );
  }

  Future<GCWAsyncExecuterParameters?> _buildJobData() async {
    if (_file == null) return null;
    return GCWAsyncExecuterParameters(_file!.bytes);
  }

  void _showOutput(AnimatedImageOutput? output) {
    _outData = output;

    // restore image references (problem with sendPort, lose references)
    if (_outData != null) {
      var linkList = _outData!.linkList;
      for (int i = 0; i < _outData!.images.length; i++) {
        _outData!.images[i] = _outData!.images[linkList[i]];
      }
    } else {
      showSnackBar(i18n(context, 'common_loadfile_exception_notloaded'), context);
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {});
    });
  }

  Widget buildEncodeWidget(BuildContext context) {
    return Column(children: <Widget>[
      GCWOpenFile(
        key: Key('encode'),
        supportedFileTypes: SUPPORTED_IMAGE_TYPES,
        suppressGallery: false,
        onLoaded: (GCWFile? value) {
          if (value == null) {
            showSnackBar(i18n(context, 'common_loadfile_exception_notloaded'), context);
            return;
          }
          setState(() {
            updateEncodeImageData(_encodeImageData, addImage: value.bytes);
          });
        },
      ),
      GCWDivider(),
      buildEncodeGallery(_encodeImageData, setState),
      _buildEncodeOptions(),
      buildEncodeList(setState, _encodeDurations, _encodeImageData, _textEditingController, _loopDuration),
      _buildEncodeSubmitButton(),
      _buildOutputEncode()
    ]);
  }

  Widget _buildEncodeOptions() {
    return GCWExpandableTextDivider(
      text: i18n(context, 'common_options'),
      expanded: _expandedEncodeOptions,
      onChanged: (value) {
        _expandedEncodeOptions = value;
        },
      child: Column(
        children: [
          GCWTwoOptionsSwitch(
              leftValue: i18n(context, 'common_forward') + "/ " + i18n(context, 'common_reverse'),
              rightValue: i18n(context, 'common_forward'),
              value: _modeEncode == EncodeMode.FORWARD ? GCWSwitchPosition.right : GCWSwitchPosition.left,
              onChanged:  (value) {
                setState(() {
                  _modeEncode = value == GCWSwitchPosition.right ? EncodeMode.FORWARD : EncodeMode.FORWARDREVERSE;
                });
              }
          ),
          GCWIntegerSpinner(
            title: i18n(context, 'animated_image_loop_duration') + ' (ms)',
            flexValues: [1, 1],
            value: _loopDuration,
            min: 0,
            max: 999999,
            onChanged: (value) {
              setState(() {
                _loopDuration = value;
              });
            },
          ),
          GCWIntegerSpinner(
            title: i18n(context, 'animated_image_loop_count') + ' (0 → ∞)',
            flexValues: [1, 1],
            value: _loopCount,
            min: 0,
            max: 999999,
            onChanged: (value) {
              setState(() {
                _loopCount = value;
              });
            },
          ),
          GCWIntegerSpinner(
            title: i18n(context, 'visual_cryptography_scale'),
            flexValues: [1, 1],
            value: _encodeScale,
            min: 1,
            max: 1000,
            onChanged: (value) {
              setState(() {
                _encodeScale = value;
              });
            },
          ),
          Container(height: 10)
        ],
      ),
    );
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

  Future<GCWAsyncExecuterParameters?> _buildJobDataEncode() async {
    if (_encodeImageData.isEmpty) return null;
    return GCWAsyncExecuterParameters(
        AnimatedImageJobData(
            images: _encodeImageData.map((data) => data.file.bytes).toList(),
            durations: _encodeDurations,
            mode: _modeEncode,
            loopDisplayDuration: _loopDuration,
            loopCount: _loopCount,
            scale: _encodeScale
        )
    );
  }

  void _saveOutputEncode(Uint8List? output) {
    _encodeOutputImage = output;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {});
    });
  }

  Widget _buildOutputEncode() {
    if (_encodeOutputImage == null) return Container();

    return GCWDefaultOutput(
      trailing: Row(children: <Widget>[
        GCWIconButton(
          icon: Icons.save,
          size: IconButtonSize.SMALL,
          iconColor: _encodeOutputImage == null ? themeColors().inactive() : null,
          onPressed: () {
            if (_encodeOutputImage != null) exportFile(context, _encodeOutputImage!);
          },
        )
      ]),

      child: _encodeOutputImage == null
              ? Container()
              : Image.memory(_encodeOutputImage!)
      );
  }

  Future<void> _exportFiles(BuildContext context, String fileName, List<Uint8List> data) async {
    createZipFile(fileName, '.' + fileExtension(FileType.PNG), data).then((bytes) async {
      await saveByteDataToFile(context, bytes, buildFileNameWithDate('anim_', FileType.ZIP)).then((value) {
        if (value) showExportedFileDialog(context);
      });
    });
  }
}

void openInAnimatedImage(BuildContext context, GCWFile file) {
  Navigator.push(
      context,
      NoAnimationMaterialPageRoute<GCWTool>(
          builder: (context) => GCWTool(
              tool: AnimatedImage(file: file), toolName: i18n(context, 'animated_image_title'), id: 'animated_image')));
}

Widget buildEncodeGallery(List<GCWImageViewData> list, Function setState) {
  return GCWGallery(
      imageData: list,
      onDoubleTap: (index) {
        updateEncodeImageData(list, inversMarked: list[index]);
        setState(() {});
      }
  );
}

void updateEncodeImageData(List<GCWImageViewData> list, {Uint8List? addImage, GCWImageViewData? inversMarked}) {

  if (inversMarked != null) {
    var i = list.indexOf(inversMarked);
    if (i >= 0) {
      list[i] = GCWImageViewData(list[i].file,
          description: list[i].description,
          marked: !(list[i].marked ?? false));
    }
    return;
  } else if (addImage != null) {
    list.add(GCWImageViewData(GCWFile(bytes: addImage), description: ''));
  }

  var imageCount = list.length;
  for (var i = 0; i < imageCount; i++) {
    String description = (i + 1).toString() + '/$imageCount';
    list[i] = (GCWImageViewData(list[i].file,
        description: description,
        marked: list[i].marked));
  }
}

Widget buildEncodeList(Function setState, List<MapEntry<int, int>> encodeDurations,
    List<GCWImageViewData> encodeImageData, List<TextEditingController?> textEditingController,
    int loopDuration, [bool singleEntry = false]) {

  bool _showEncodeLoopDuration() {
    return loopDuration <= 0;
  }

  bool _newEncodeEntry(int index) {
    return index < 0 || index >= encodeDurations.length;
  }

  TextEditingController _getTextEditingController(int rowIndex, String? text) {
    if (_newEncodeEntry(rowIndex)) {
      rowIndex = encodeDurations.length;
    }
    while (textEditingController.length <= rowIndex) {
      textEditingController.add(TextEditingController());
    }

    if (text != null) {
      textEditingController[rowIndex]!.text = text;
    }

    return textEditingController[rowIndex]!;
  }

  List<GCWDropDownMenuItem<int>> _buildDropDownMenuItems(int index) {
    GCWDropDownMenuItem<int> _buildDropDownMenuItem(int index) {
      Widget imageWidget = Container();
      if (index >= 0 && index < encodeImageData.length) {
        var image = Image.memory(encodeImageData[index].file.bytes);
        imageWidget = GCWSymbolContainer(symbol: image);
        imageWidget = SizedBox(height: 80, child: imageWidget);
      } else {
        imageWidget = SizedBox(height: 80, width: 80, child: imageWidget);
      }

      return GCWDropDownMenuItem(
          value: index,
          child: Row(children: [
            imageWidget
          ]));
    }

    var list = encodeImageData.mapIndexed((index, data) => _buildDropDownMenuItem(index)).toList();
    if (_newEncodeEntry(index)) {
      list.insert(0, _buildDropDownMenuItem(-1));
    }
    return list;
  }

  Widget _buildEncodeRowEntry(int index) {
    return Row(
      children: [
        Expanded(child: Container()),
        SizedBox(
          width: 140,
          child: Column(
            children: [
              GCWDropDown<int>(
                value: _newEncodeEntry(index) ? index : encodeDurations[index].key,
                onChanged: (value) {
                  setState(() {
                    if (!_newEncodeEntry(index)) {
                      var entry = MapEntry<int, int>(value, encodeDurations[index].value);
                      encodeDurations[index] = entry;
                    } else if (value >= 0) {
                      var duration = _getTextEditingController(index, null).value;
                      var durationValue = int.tryParse(duration.text) ?? 0;
                      var entry = MapEntry<int, int>(value, durationValue);
                      encodeDurations.add(entry);
                    }
                  });
                },
                items: _buildDropDownMenuItems(index),
              ),
            ],
          ),
        ),
        SizedBox(width: 5),
        _showEncodeLoopDuration()
            ? SizedBox(
            width: 130,
            child: Column(
                children: [
                  GCWIntegerTextField(
                    min: 0,
                    controller:  _newEncodeEntry(index)
                        ? _getTextEditingController(index, null)
                        : _getTextEditingController(index, encodeDurations[index].value.toString()),
                    onChanged: (IntegerText ret) {
                      setState(() {
                        if (!_newEncodeEntry(index)) {
                          var entry = MapEntry<int, int>(encodeDurations[index].key, ret.value);
                          encodeDurations[index] = entry;
                        }
                      });
                    },
                  ),
                ]
            )
        )
            : Container(),
        _showEncodeLoopDuration()
            ? SizedBox(width: 5)
            : Container(),
        singleEntry
          ? Container()
          : Column(
            children: [
              GCWIconButton(
                icon: Icons.remove,
                onPressed: () {
                  setState(() {
                    if (index >= 0 && index < encodeDurations.length) {
                      encodeDurations.removeAt(index);
                      textEditingController.removeAt(index);
                    }
                  });
                },
              ),
            ],
          ),
        singleEntry
            ? Container()
            : Column(
              children: [
                GCWIconButton(
                  icon: Icons.arrow_drop_up,
                  onPressed: () {
                    setState(() {
                      if (index > 0) {
                        var entry = encodeDurations.removeAt(index);
                        encodeDurations.insert(index - 1, entry);
                      }
                    });
                  },
                ),
                GCWIconButton(
                  icon: Icons.arrow_drop_down,
                  onPressed: () {
                    setState(() {
                      if (index>= 0 && index < encodeDurations.length - 1) {
                        var entry = encodeDurations.removeAt(index);
                        encodeDurations.insert(index + 1, entry);
                      }
                    });
                  },
                )
              ],
            ),
        Expanded(child: Container()),
      ],
    );
  }

  var rows = encodeDurations.mapIndexed((index, data) => _buildEncodeRowEntry(index)).toList();
  if (!singleEntry || encodeDurations.isEmpty ) {
    rows.add(Container(child: _buildEncodeRowEntry(-1)));
  }

  var headerStyle = gcwTextStyle().copyWith(fontWeight: FontWeight.bold);
  Widget header = Row(
      children: [
        Expanded(child: Container()),
        SizedBox(width: 140, child: Container()),
        SizedBox(width: 5),
        _showEncodeLoopDuration()
            ? SizedBox(width: 130, child: GCWText(text: 'Duration' + ' (ms)', style: headerStyle))
            : Container(),
        _showEncodeLoopDuration()
            ? SizedBox(width: 5)
            : Container(),
        singleEntry ? Container() : SizedBox(width: 40, child: Container()),
        singleEntry ? Container() : SizedBox(width: 40, child: Container()),
        Expanded(child: Container()),
      ]
  );
  rows.insert(0, Container(child: header));

  var odd = true;
  return Column(
      children: rows.map((row) {
        odd = !odd;
        if (odd) {
          return Container(color: themeColors().outputListOddRows(), child: row);
        } else {
          return Container(child: row);
        }
      }).toList()
  );
}

Future<void> exportFiles(BuildContext context, String fileName, List<Uint8List> data) async {
  createZipFile(fileName, '.' + fileExtension(FileType.PNG), data).then((bytes) async {
    await saveByteDataToFile(context, bytes, buildFileNameWithDate('anim_', FileType.ZIP)).then((value) {
      if (value) showExportedFileDialog(context);
    });
  });
}

Future<void> exportFile(BuildContext context, Uint8List data) async {
  var fileType = getFileType(data);
  await saveByteDataToFile(context, data, buildFileNameWithDate('anim_export_', fileType)).then((value) {
    var content = fileClass(fileType) == FileClass.IMAGE ? imageContent(context, data) : null;
    if (value) showExportedFileDialog(context, contentWidget: content);
  });
}
