import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/app_localizations.dart';
import 'package:gc_wizard/application/theme/theme.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_button.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_submit_button.dart';
import 'package:gc_wizard/common_widgets/dividers/gcw_divider.dart';
import 'package:gc_wizard/common_widgets/dividers/gcw_text_divider.dart';
import 'package:gc_wizard/common_widgets/async_executer/gcw_async_executer.dart';
import 'package:gc_wizard/common_widgets/gcw_openfile.dart';
import 'package:gc_wizard/common_widgets/gcw_text.dart';
import 'package:gc_wizard/common_widgets/gcw_toast.dart';
import 'package:gc_wizard/common_widgets/image_viewers/gcw_imageview.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/spinners/gcw_integer_spinner.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_onoff_switch.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_twooptions_switch.dart';
import 'package:gc_wizard/tools/images_and_files/visual_cryptography/logic/visual_cryptography.dart';
import 'package:gc_wizard/utils/file_utils/file_utils.dart';
import 'package:gc_wizard/utils/file_utils/gcw_file.dart';
import 'package:image/image.dart' as img;
import 'package:tuple/tuple.dart';
import 'package:gc_wizard/common_widgets/async_executer/gcw_async_executer_parameters.dart';

class VisualCryptography extends StatefulWidget {
  const VisualCryptography({Key? key}) : super(key: key);

  @override
  VisualCryptographyState createState() => VisualCryptographyState();
}

class VisualCryptographyState extends State<VisualCryptography> {
  GCWSwitchPosition _currentMode = GCWSwitchPosition.right;

  GCWFile? _decodeImage1;
  GCWFile? _decodeImage2;
  Uint8List? _outData;
  GCWFile? _encodeImage;
  GCWFile? _encodeKeyImage;
  int _encodeScale = 100;
  String? _encodeImageSize;
  var _decodeOffsetsX = 0;
  var _decodeOffsetsY = 0;
  var _encodeOffsetsX = 0;
  var _encodeOffsetsY = 0;

  Tuple2<Uint8List, Uint8List?>? _encodeOutputImages;

  int? _currentImageWidth;
  int? _currentImageHeight;

  var _currentEncryptionWithKeyMode = false;
  var _currentEncryptionAdvancedMode = GCWSwitchPosition.left;

  @override
  Widget build(BuildContext context) {
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
    return Column(children: [
      Container(), // fixes strange behaviour: First GCWOpenFile widget from encode/decode affect each other
      GCWOpenFile(
        title: i18n(context, 'visual_cryptography_image') + ' 1',
        supportedFileTypes: SUPPORTED_IMAGE_TYPES,
        file: _decodeImage1,
        onLoaded: (_file) {
          if (_file == null) {
            showToast(i18n(context, 'common_loadfile_exception_notloaded'));
            return;
          }

          setState(() {
            _decodeImage1 = _file;
          });
        },
      ),
      Container(height: 20),
      GCWOpenFile(
        title: i18n(context, 'visual_cryptography_image') + ' 2',
        supportedFileTypes: SUPPORTED_IMAGE_TYPES,
        file: _decodeImage2,
        onLoaded: (_file) {
          if (_file == null) {
            showToast(i18n(context, 'common_loadfile_exception_notloaded'));
            return;
          }

          setState(() {
            _decodeImage2 = _file;
          });
        },
      ),
      Container(height: 25),
      GCWIntegerSpinner(
        title: i18n(context, 'visual_cryptography_offset') + ' X',
        value: _decodeOffsetsX,
        onChanged: (value) {
          setState(() {
            _decodeOffsetsX = value;
          });
        },
      ),
      GCWIntegerSpinner(
        title: i18n(context, 'visual_cryptography_offset') + ' Y',
        value: _decodeOffsetsY,
        onChanged: (value) {
          setState(() {
            _decodeOffsetsY = value;
          });
        },
      ),
      _buildDecodeSubmitButton(),

      // Deactivate, too slow at the moment (Mark, 07/2021)
      // Row(children: [
      //   Expanded(child: Column(children: [_buildAutoOffsetXYButton()])),
      //   Expanded(child: Column(children: [_buildAutoOffsetXButton()])),
      // ]),

      GCWDefaultOutput(child: _buildOutputDecode())
    ]);
  }

  Widget _buildOutputDecode() {
    if (_outData == null) return Container();

    return Column(children: <Widget>[
      GCWImageView(
        imageData: GCWImageViewData(GCWFile(bytes: _outData!)),
        toolBarRight: false,
        fileName: buildFileNameWithDate('img_', null),
      ),
      GCWButton(
        text: i18n(context, 'visual_cryptography_clear'),
        onPressed: () {
          setState(() {
            if (_decodeImage1 != null && _decodeImage2 != null) {
              _outData = cleanImage(_decodeImage1!.bytes, _decodeImage2!.bytes, _decodeOffsetsX, _decodeOffsetsY);
            }
          });
        },
      ),
    ]);
  }

  Widget _encodeWidgets() {
    return Column(children: <Widget>[
      GCWOpenFile(
        supportedFileTypes: SUPPORTED_IMAGE_TYPES,
        file: _encodeImage,
        onLoaded: (_file) {
          if (_file == null) {
            showToast(i18n(context, 'common_loadfile_exception_notloaded'));
            return;
          }

          setState(() {
            _encodeImage = _file;
            _encodeOutputImages = null;
            __encodeImageSize();
          });
        },
      ),
      Container(
          padding: const EdgeInsets.symmetric(vertical: 25),
          child:
              GCWImageView(imageData: _encodeImage == null ? null :GCWImageViewData(_encodeImage!),
                  suppressedButtons: const {GCWImageViewButtons.ALL}),
        ),

      GCWOnOffSwitch(
        value: _currentEncryptionWithKeyMode,
        title: i18n(context, 'visual_cryptography_keyimage'),
        onChanged: (value) {
          setState(() {
            _currentEncryptionWithKeyMode = value;
          });
        },
      ),
      _currentEncryptionWithKeyMode
          ? Column(
              children: [
                GCWOpenFile(
                  supportedFileTypes: SUPPORTED_IMAGE_TYPES,
                  suppressHeader: true,
                  file: _encodeKeyImage,
                  onLoaded: (_file) {
                    if (_file == null) {
                      showToast(i18n(context, 'common_loadfile_exception_notloaded'));
                      return;
                    }

                    setState(() {
                      _encodeKeyImage = _file;
                      _encodeOutputImages = null;
                    });
                  },
                ),
                const GCWDivider()
              ],
            )
          : Container(),
      GCWTwoOptionsSwitch(
        value: _currentEncryptionAdvancedMode,
        leftValue: i18n(context, 'visual_cryptography_simple'),
        rightValue: i18n(context, 'visual_cryptography_advanced'),
        onChanged: (value) {
          setState(() {
            _currentEncryptionAdvancedMode = value;
          });
        },
      ),
      _currentEncryptionAdvancedMode == GCWSwitchPosition.left
          ? Container()
          : Column(
              children: [
                GCWIntegerSpinner(
                  title: i18n(context, 'visual_cryptography_offset') + ' X',
                  value: _encodeOffsetsX,
                  onChanged: (value) {
                    setState(() {
                      _encodeOffsetsX = value;
                      _updateEncodeImageSize();
                    });
                  },
                ),
                GCWIntegerSpinner(
                  title: i18n(context, 'visual_cryptography_offset') + ' Y',
                  value: _encodeOffsetsY,
                  onChanged: (value) {
                    setState(() {
                      _encodeOffsetsY = value;
                      _updateEncodeImageSize();
                    });
                  },
                ),
                _currentEncryptionWithKeyMode
                    ? Container()
                    : Column(
                        children: [
                          GCWTextDivider(
                            text: i18n(context, 'visual_cryptography_outputsize'),
                          ),

                          GCWIntegerSpinner(
                            title: i18n(context, 'visual_cryptography_scale'),
                            value: _encodeScale,
                            min: 1,
                            max: 1000,
                            onChanged: (value) {
                              setState(() {
                                _encodeScale = value;
                                _updateEncodeImageSize();
                              });
                            },
                          ),

                          Container(), // For some reasons, this fixes a bug: Without this, the encode scale input affects the decode offset y input...

                          if (_encodeImageSize != null)
                            Row(
                              children: [
                                Expanded(flex: 1, child: Container()),
                                Expanded(
                                    flex: 3,
                                    child: GCWText(
                                      align: Alignment.bottomCenter,
                                      text: _encodeImageSize ?? '',
                                      style: gcwDescriptionTextStyle(),
                                    ))
                              ],
                            ),
                        ],
                      )
              ],
            ),
      _buildEncodeSubmitButton(),
      GCWDefaultOutput(child: _buildOutputEncode())
    ]);
  }

  void __encodeImageSize() {

    if (_encodeImage == null) return;
    var _image = img.decodeImage(_encodeImage!.bytes);
    if (_image == null) return;

    _currentImageWidth = _image.width;
    _currentImageHeight = _image.height;

    setState(() {
      _updateEncodeImageSize();
    });
  }

  void _updateEncodeImageSize() {
    if (_currentImageWidth == null || _currentImageHeight == null) {
      _encodeImageSize = null;
      return;
    }

    var encodeScale = _currentEncryptionWithKeyMode ? 100 : _encodeScale;

    var width = _currentImageWidth! * encodeScale ~/ 100 * 2 + _decodeOffsetsX.abs();
    var height = _currentImageHeight! * encodeScale ~/ 100 * 2 + _decodeOffsetsY.abs();
    _encodeImageSize = '$width × $height px';
  }

  Widget _buildOutputEncode() {
    if (_encodeOutputImages == null) return Container();

    return Column(children: <Widget>[
      GCWImageView(
        imageData: GCWImageViewData(GCWFile(bytes: _encodeOutputImages?.item1 ?? Uint8List(0))),
        toolBarRight: true,
        fileName: buildFileNameWithDate('img1_', null),
      ),
      _currentEncryptionWithKeyMode
          ? Container()
          : Column(
              children: [
                Container(height: 5),
                GCWImageView(
                  imageData: GCWImageViewData(GCWFile(bytes: _encodeOutputImages?.item2 ?? Uint8List(0))),
                  toolBarRight: true,
                  fileName: buildFileNameWithDate('img2_', null),
                ),
              ],
            )
    ]);
  }

  Widget _buildDecodeSubmitButton() {
    return GCWSubmitButton(onPressed: () async {
      await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return Center(
            child: SizedBox(
              height: 220,
              width: 150,
              child: GCWAsyncExecuter<Uint8List?>(
                isolatedFunction: decodeImagesAsync,
                parameter: _buildJobDataDecode,
                onReady: (data) => _saveOutputDecode(data),
                isOverlay: true,
              ),
            ),
          );
        },
      );
    });
  }

  Future<GCWAsyncExecuterParameters> _buildJobDataDecode() async {
    return GCWAsyncExecuterParameters(Tuple4<Uint8List, Uint8List, int, int>(
        _decodeImage1?.bytes ?? Uint8List(0), _decodeImage2?.bytes ?? Uint8List(0), _decodeOffsetsX, _decodeOffsetsY));
  }

  void _saveOutputDecode(Uint8List? output) {
    _outData = output;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {});
    });
  }

  // Widget _buildAutoOffsetXYButton() {
  //   return GCWButton(
  //     text: i18n(context, 'visual_cryptography_auto') + ' XY',
  //     onPressed: () async {
  //       await showDialog<bool>(
  //         context: context,
  //         barrierDismissible: false,
  //         builder: (context) {
  //           return Center(
  //             child: Container(
  //               child: GCWAsyncExecuter(
  //                 isolatedFunction: offsetAutoCalcAsync,
  //                 parameter: _buildJobDataOffsetAutoCalc(false),
  //                 onReady: (data) => _saveOutputOffsetAutoCalc(data),
  //                 isOverlay: true,
  //               ),
  //               height: 220,
  //               width: 150,
  //             ),
  //           );
  //         },
  //       );
  //   });
  // }
  //
  // Widget _buildAutoOffsetXButton() {
  //   return GCWButton(
  //       text: i18n(context, 'visual_cryptography_auto') + ' X',
  //       onPressed: () async {
  //         await showDialog<bool>(
  //           context: context,
  //           barrierDismissible: false,
  //           builder: (context) {
  //             return Center(
  //               child: Container(
  //                 child: GCWAsyncExecuter(
  //                   isolatedFunction: offsetAutoCalcAsync,
  //                   parameter: _buildJobDataOffsetAutoCalc(true),
  //                   onReady: (data) => _saveOutputOffsetAutoCalc(data),
  //                   isOverlay: true,
  //                 ),
  //                 height: 220,
  //                 width: 150,
  //               ),
  //             );
  //           },
  //         );
  //       });
  // }

  // Future<GCWAsyncExecuterParameters?> _buildJobDataOffsetAutoCalc(bool onlyX) async {
  //   return GCWAsyncExecuterParameters(Tuple4<Uint8List, Uint8List, int, int>(_decodeImage1?.bytes, _decodeImage2?.bytes, null, onlyX ? _decodeOffsetsX : null));
  // }

  // _saveOutputOffsetAutoCalc(Tuple2<int, int> output) {
  //   if (output != null) {
  //     WidgetsBinding.instance.addPostFrameCallback((_) {
  //       setState(() {
  //         _decodeOffsets = output;
  //         _decodeOffsetXController.text = _decodeOffsets.item1.toString();
  //         _decodeOffsetYController.text = _decodeOffsets.item2.toString();
  //       });
  //     });
  //   }
  // }

  Widget _buildEncodeSubmitButton() {
    return GCWSubmitButton(onPressed: () async {
      await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return Center(
            child: SizedBox(
              height: 220,
              width: 150,
              child: GCWAsyncExecuter<Tuple2<Uint8List, Uint8List?>?>(
                isolatedFunction: encodeImagesAsync,
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

  Future<GCWAsyncExecuterParameters> _buildJobDataEncode() async {
    return GCWAsyncExecuterParameters(Tuple5<Uint8List, Uint8List?, int, int, int>(_encodeImage?.bytes ?? Uint8List(0),
        _currentEncryptionWithKeyMode ? _encodeKeyImage?.bytes ?? Uint8List(0) : null,
        _encodeOffsetsX, _encodeOffsetsY, _encodeScale));
  }

  void _saveOutputEncode(Tuple2<Uint8List, Uint8List?>? output) {
    _encodeOutputImages = output;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {});
    });
  }
}
