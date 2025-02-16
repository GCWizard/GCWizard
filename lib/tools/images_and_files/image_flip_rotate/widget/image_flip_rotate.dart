import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/application/navigation/no_animation_material_page_route.dart';
import 'package:gc_wizard/application/theme/theme.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_button.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_iconbutton.dart';
import 'package:gc_wizard/common_widgets/gcw_openfile.dart';
import 'package:gc_wizard/common_widgets/gcw_snackbar.dart';
import 'package:gc_wizard/application/tools/widget/gcw_tool.dart';
import 'package:gc_wizard/common_widgets/gcw_toolbar.dart';
import 'package:gc_wizard/common_widgets/image_viewers/gcw_imageview.dart';
import 'package:gc_wizard/utils/file_utils/file_utils.dart';
import 'package:gc_wizard/utils/file_utils/gcw_file.dart';
import 'package:gc_wizard/utils/math_utils.dart';
import 'package:image/image.dart' as Image;

class ImageFlipRotate extends StatefulWidget {
  final GCWFile? file;

  const ImageFlipRotate({Key? key, this.file}) : super(key: key);

  @override
  _ImageFlipRotateState createState() => _ImageFlipRotateState();
}

class _ImageFlipRotateState extends State<ImageFlipRotate> {
  GCWFile? _originalData;

  Image.Image? _currentImage;

  var _currentFlipHorizontally = false;
  var _currentFlipVertically = false;
  int _currentRotate = 0;

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
      _currentFlipHorizontally = false;
      _currentFlipVertically = false;
      _currentRotate = 0;
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
          suppressGallery: false,
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
          Container(
            padding: const EdgeInsets.only(top: 2 * DOUBLE_DEFAULT_MARGIN),
            child: GCWToolBar(
              children: [
                GCWIconButton(
                  icon: Icons.flip,
                  onPressed: () {
                    setState(() {
                      if (_currentRotate == 0 || _currentRotate == 180) {
                        _currentFlipHorizontally = !_currentFlipHorizontally;
                      } else {
                        _currentFlipVertically = !_currentFlipVertically;
                      }
                    });
                  },
                ),
                GCWIconButton(
                  icon: Icons.flip,
                  rotateDegrees: 90.0,
                  onPressed: () {
                    setState(() {
                      if (_currentRotate == 0 || _currentRotate == 180) {
                        _currentFlipVertically = !_currentFlipVertically;
                      } else {
                        _currentFlipHorizontally = !_currentFlipHorizontally;
                      }
                    });
                  },
                ),
                GCWIconButton(
                  icon: Icons.rotate_left,
                  onPressed: () {
                    setState(() {
                      _currentRotate = modulo360(_currentRotate - 90).toInt();
                    });
                  },
                ),
                GCWIconButton(
                  icon: Icons.rotate_right,
                  onPressed: () {
                    setState(() {
                      _currentRotate = modulo360(_currentRotate + 90).toInt();
                    });
                  },
                ),
              ],
            ),
          ),
        if (_currentImage != null)
          GCWButton(
            text: i18n(context, 'common_reset'),
            onPressed: () {
              _resetInputs();
            },
          ),
      ],
    );
  }

  Image.Image? _flipRotate(Image.Image? image) {
    if (image == null) return null;
    return _doFlipRotate(_FlipRotateInput(
      image: image,
      flipHorizontally: _currentFlipHorizontally,
      flipVertically: _currentFlipVertically,
      rotate: _currentRotate.toDouble(),
    ));
  }

  Uint8List? _imageBytes(Image.Image? image) {
    var _image = _flipRotate(image);
    return _image == null ? null : encodeTrimmedPng(_image);
  }
}

class _FlipRotateInput {
  final Image.Image? image;
  final bool flipHorizontally;
  final bool flipVertically;
  final double rotate;

  _FlipRotateInput({this.image, this.flipHorizontally = false, this.flipVertically = false, this.rotate = 0.0});
}

Image.Image? _doFlipRotate(_FlipRotateInput input) {
  if (input.image == null) return null;
  Image.Image image = Image.Image.from(input.image!);
  if (input.flipHorizontally) image = Image.flipHorizontal(image);
  if (input.flipVertically) image = Image.flipVertical(image);

  var rotate = modulo360(input.rotate);
  if (rotate > 0) {
    image = Image.copyRotate(image, angle: rotate, interpolation: Image.Interpolation.cubic);
  }

  return image;
}

void openInFlipRotate(BuildContext context, GCWFile file) {
  Navigator.push(
      context,
      NoAnimationMaterialPageRoute<GCWTool>(
          builder: (BuildContext context) => GCWTool(
              tool: ImageFlipRotate(file: file),
              toolName: i18n(context, 'image_fliprotate_title'),
              id: 'image_fliprotate')));
}
