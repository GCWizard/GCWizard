import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:gc_wizard/i18n/app_localizations.dart';
import 'package:gc_wizard/logic/tools/images_and_files/magic_eye_solver.dart';
import 'package:gc_wizard/widgets/common/base/gcw_dropdownbutton.dart';
import 'package:gc_wizard/widgets/common/base/gcw_toast.dart';
import 'package:gc_wizard/widgets/common/gcw_async_executer.dart';
import 'package:gc_wizard/widgets/common/gcw_default_output.dart';
import 'package:gc_wizard/widgets/common/gcw_imageview.dart';
import 'package:gc_wizard/widgets/common/gcw_integer_spinner.dart';
import 'package:gc_wizard/widgets/common/gcw_openfile.dart';
import 'package:gc_wizard/widgets/common/gcw_text_divider.dart';
import 'package:gc_wizard/widgets/common/gcw_twooptions_switch.dart';
import 'package:gc_wizard/widgets/utils/file_picker.dart';
import 'package:gc_wizard/widgets/utils/gcw_file.dart';
import 'package:image/image.dart' as Image;
import 'package:intl/intl.dart';
import 'package:tuple/tuple.dart';

class MagicEyeSolver extends StatefulWidget {
  @override
  MagicEyeSolverState createState() => MagicEyeSolverState();
}

class MagicEyeSolverState extends State<MagicEyeSolver> {
  GCWSwitchPosition _currentMode = GCWSwitchPosition.right;

  GCWFile _decodeImage;
  Image.Image _decodeImageData;
  Uint8List _decodeOutData;
  int _displacement;
  GCWFile _encodeHiddenDataImage;
  GCWFile _encodeTextureImage;
  Uint8List _encodeOutData;
  TextureType _currentEncodeTextureType = TextureType.BITMAP;

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
      GCWOpenFile(
        supportedFileTypes: SUPPORTED_IMAGE_TYPES,
        file: _decodeImage,
        onLoaded: (_file) {
          if (_file == null) {
            showToast(i18n(context, 'common_loadfile_exception_notloaded'));
            return;
          }

          _decodeImage = _file;
          _decodeImageData = null;
          _decodeOutData = null;
          _displacement = null;

          decodeImageAsync(_buildJobDataDecode()).then((output) {
            _saveOutputDecode(output);
          });
        },
      ),
      Container(height: 25),
      GCWIntegerSpinner(
        title: i18n(context, 'magic_eye_offset'),
        value: _displacement,
        onChanged: (value) {
          setState(() {
            _displacement = value;
            _decodeOutData = null;

            decodeImageAsync(_buildJobDataDecode()).then((output) {
              _saveOutputDecode(output);
            });
          });
        },
      ),
      GCWDefaultOutput(child: _buildOutputDecode())
    ]);
  }

  Widget _buildOutputDecode() {
    if (_decodeOutData == null) return null;

    return Column(children: <Widget>[
      GCWImageView(
        imageData: GCWImageViewData(GCWFile(bytes: _decodeOutData)),
        toolBarRight: false,
        fileName: 'img_' + DateFormat('yyyyMMdd_HHmmss').format(DateTime.now()),
      ),
    ]);
  }

  GCWAsyncExecuterParameters _buildJobDataDecode() {
    return GCWAsyncExecuterParameters(
        Tuple3<Uint8List, Image.Image, int>(_decodeImage?.bytes, _decodeImageData, _displacement));
  }

  void _saveOutputDecode(Tuple3<Image.Image, Uint8List, int> output) {
    _decodeImageData = output.item1;
    _decodeOutData = output.item2;
    _displacement = output.item3;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {});
    });
  }

  Widget _encodeWidgets() {
    return Column(children: [
      Container(height: 20),
      GCWOpenFile(
        title: i18n(context, 'magic_eye_hidden_image'),
        supportedFileTypes: SUPPORTED_IMAGE_TYPES,
        file: _encodeHiddenDataImage,
        onLoaded: (_file) {
          if (_file == null) {
            showToast(i18n(context, 'common_loadfile_exception_notloaded'));
            return;
          }
          _encodeHiddenDataImage = _file;
          _generateEncodeImage();
        },
      ),
      Container(), // fixes strange behaviour: First GCWOpenFile widget from encode/decode affect each other
      _buildEncodeTextureSelection(),

      GCWDefaultOutput(child: _buildOutputEncode())
    ]);
  }

  Widget _buildEncodeTextureSelection() {
    return Column(children: [
      GCWTextDivider(text: i18n(context, 'magic_eye_texture_image')),
      GCWDropDownButton(
          value: _currentEncodeTextureType,
          onChanged: (value) {
            setState(() {
              _currentEncodeTextureType = value;
              _generateEncodeImage();
            });
          },
          items: [
            GCWDropDownMenuItem(
              value: TextureType.BITMAP,
              child: i18n(context, 'magic_eye_texture_bitmap'),
            ),
            GCWDropDownMenuItem(
              value: TextureType.COLORDOTS,
              child: i18n(context, 'magic_eye_texture_colordots'),
            ),
            GCWDropDownMenuItem(
              value: TextureType.GREYDOTS,
              child: i18n(context, 'magic_eye_texture_graydots'),
            )
          ]),
      _currentEncodeTextureType == TextureType.BITMAP
          ? GCWOpenFile(
              supportedFileTypes: SUPPORTED_IMAGE_TYPES,
              file: _encodeTextureImage,
              onLoaded: (_file) {
                if (_file == null) {
                  showToast(i18n(context, 'common_loadfile_exception_notloaded'));
                  return;
                }
                _encodeTextureImage = _file;
                _generateEncodeImage();
              },
            )
          : Container(),
    ]);
  }

  Widget _buildOutputEncode() {
    if (_encodeOutData == null) return null;

    return Column(children: <Widget>[
      GCWImageView(
        imageData: GCWImageViewData(GCWFile(bytes: _encodeOutData)),
        toolBarRight: false,
        fileName: 'img_' + DateFormat('yyyyMMdd_HHmmss').format(DateTime.now()),
      ),
    ]);
  }

  Future<GCWAsyncExecuterParameters> _buildJobDataEncode() async {
    return GCWAsyncExecuterParameters(Tuple3<Uint8List, Uint8List, TextureType>(
        _encodeHiddenDataImage?.bytes, _encodeTextureImage?.bytes, _currentEncodeTextureType));
  }

  void _saveOutputEncode(Tuple2<Uint8List, MagicEyeErrorCode> output) {
    if (output == null) {
      _encodeOutData = null;
      return;
    }

    _encodeOutData = output.item1;
    if (output.item2 == MagicEyeErrorCode.IMAGE_TOO_SMALL) showToast(i18n(context, 'magic_eye_image_too_small'));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {});
    });
  }

  void _generateEncodeImage() async {
    if (_encodeHiddenDataImage == null ||
        (_currentEncodeTextureType == TextureType.BITMAP && _encodeTextureImage == null)) return;

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Center(
          child: Container(
            child: GCWAsyncExecuter(
              isolatedFunction: generateImageAsync,
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
  }
}
