import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/application/theme/theme.dart';
import 'package:gc_wizard/common_widgets/gcw_openfile.dart';
import 'package:gc_wizard/common_widgets/gcw_slider.dart';
import 'package:gc_wizard/common_widgets/gcw_snackbar.dart';
import 'package:gc_wizard/common_widgets/image_viewers/gcw_imageview.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_columned_multiline_output.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_twooptions_switch.dart';
import 'package:gc_wizard/utils/file_utils/file_utils.dart';
import 'package:gc_wizard/utils/file_utils/gcw_file.dart';
import 'package:gc_wizard/utils/math_utils.dart';
import 'package:image/image.dart' as Image;

class ImageStretchShrink extends StatefulWidget {
  final GCWFile? file;

  const ImageStretchShrink({Key? key, this.file}) : super(key: key);

  @override
  _ImageStretchShrinkState createState() => _ImageStretchShrinkState();
}

class _ImageStretchShrinkState extends State<ImageStretchShrink> {
  GCWFile? _originalData;

  Image.Image? _currentImage;
  int? _currentWidth;
  int? _currentHeight;

  GCWSwitchPosition _currentStretch = GCWSwitchPosition.left;
  double _currentStretchValue = 0.0;

  @override
  void initState() {
    super.initState();

    if (widget.file?.bytes != null) {
      _originalData = widget.file;
      _currentImage = Image.decodeImage(_originalData!.bytes);
    }
  }

  void _resetInputs() {
    setState(() {
      _currentStretchValue = 0.0;
    });
  }

  bool _validateData(Uint8List bytes) {
    return isImage(bytes);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GCWOpenFile(
          supportedFileTypes: SUPPORTED_IMAGE_TYPES,
          onLoaded: (GCWFile? value) {
            if (value == null || !_validateData(value.bytes)) {
              showSnackBar(i18n(context, 'common_loadfile_exception_notloaded'), context);
              return;
            }

            setState(() {
              _originalData = value;
              _currentImage = _originalData?.bytes == null ? null : Image.decodeImage(_originalData!.bytes);
              _resetInputs();
            });
          },
        ), // Fixes a display issue

        if (_currentImage != null)
          GCWImageView(
            imageData: _originalData == null
                ? null
                : GCWImageViewData(GCWFile(bytes: _imageBytes(_currentImage) ?? Uint8List(0))),
            suppressOpenInTool: const {GCWImageViewOpenInTools.FLIPROTATE},
          ),
        if (_currentImage != null)
          Column(
            children: [
              Container(height: 30),
              GCWTwoOptionsSwitch(
                notitle: true,
                leftValue: i18n(context, 'image_stretchshrink_shrink'),
                rightValue: i18n(context, 'image_stretchshrink_stretch'),
                value: _currentStretch,
                onChanged: (value) {
                  setState(() {
                    _currentStretch = value;
                    _resetInputs();
                  });
                }
              ),
              Row(
                children: [
                  Expanded(
                    child: GCWSlider(
                      leftValue: Transform.rotate(
                        angle: degreesToRadian(45),
                        child: _currentStretch == GCWSwitchPosition.left ? const Icon(Icons.close_fullscreen) : const Icon(Icons.open_in_full)
                      ),
                      rightValue: Transform.rotate(
                        angle: degreesToRadian(-45),
                        child: _currentStretch == GCWSwitchPosition.left ? const Icon(Icons.close_fullscreen) : const Icon(Icons.open_in_full)
                      ),
                      title: '',
                      value: _currentStretchValue,
                      onChanged: (value) {
                        setState(() {
                          _currentStretchValue = value;
                        });
                      },
                      min: -1.0,
                      max: 1.0,
                    ),
                  ),
                ],
              ),
              Container(height: 2 * DOUBLE_DEFAULT_MARGIN),
              GCWColumnedMultilineOutput(
                data: [
                  [i18n(context, 'common_width'), _currentWidth == null ? '-' : _currentWidth.toString() + ' px'],
                  [i18n(context, 'common_height'), _currentHeight == null ? '-' : _currentHeight.toString() + ' px'],
                ]
              )
            ],
          )
      ],
    );
  }

  Image.Image? _stretch(Image.Image? image) {
    if (image == null) return null;

    if (_currentStretchValue == 0.0) {
      return image;
    }

    if (_currentStretch == GCWSwitchPosition.left) {
      // Shrink
      if (_currentStretchValue < 0.0) {
        var width = max<int>((image.width * (_currentStretchValue + 1)).toInt(), 1);
        return Image.copyResize(image, width: width, height: image.height, maintainAspect: false);
      } else {
        var height = max<int>((image.height * (1 - _currentStretchValue)).toInt(), 1);
        return Image.copyResize(image, width: image.width, height: height, maintainAspect: false);
      }
    } else {
      // Stretch
      if (_currentStretchValue < 0.0) {
        var width = (image.width * (_currentStretchValue * -9 + 1)).toInt();
        return Image.copyResize(image, width: width, height: image.height, maintainAspect: false);
      } else {
        var height = (image.height * (_currentStretchValue * 9 + 1)).toInt();
        return Image.copyResize(image, height: height, width: image.width, maintainAspect: false);
      }
    }
  }

  Uint8List? _imageBytes(Image.Image? image) {
    var _image = _stretch(image);
    _currentHeight = _image?.height;
    _currentWidth = _image?.width;
    return _image == null ? null : encodeTrimmedPng(_image);
  }
}
