import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:gc_wizard/i18n/app_localizations.dart';
import 'package:gc_wizard/logic/tools/images_and_files/image_processing.dart';
import 'package:gc_wizard/theme/theme.dart';
import 'package:gc_wizard/theme/theme_colors.dart';
import 'package:gc_wizard/utils/settings/preferences.dart';
import 'package:gc_wizard/widgets/common/base/gcw_iconbutton.dart';
import 'package:gc_wizard/widgets/common/base/gcw_slider.dart';
import 'package:gc_wizard/widgets/common/base/gcw_toast.dart';
import 'package:gc_wizard/widgets/common/gcw_async_executer.dart';
import 'package:gc_wizard/widgets/common/gcw_imageview.dart';
import 'package:gc_wizard/widgets/common/gcw_onoff_switch.dart';
import 'package:gc_wizard/widgets/common/gcw_openfile.dart';
import 'package:gc_wizard/widgets/common/gcw_popup_menu.dart';
import 'package:gc_wizard/widgets/common/gcw_text_divider.dart';
import 'package:gc_wizard/widgets/common/gcw_tool.dart';
import 'package:gc_wizard/widgets/utils/file_picker.dart';
import 'package:gc_wizard/widgets/utils/file_utils.dart';
import 'package:gc_wizard/widgets/utils/gcw_file.dart';
import 'package:gc_wizard/widgets/utils/no_animation_material_page_route.dart';
import 'package:image/image.dart' as img;
import 'package:prefs/prefs.dart';

class ImageColorCorrections extends StatefulWidget {
  final GCWFile file;

  const ImageColorCorrections({this.file});

  @override
  ImageColorCorrectionsState createState() => ImageColorCorrectionsState();
}

class ImageColorCorrectionsState extends State<ImageColorCorrections> {
  GCWFile _originalData;
  Uint8List _convertedOutputImage;

  img.Image _currentPreview;
  img.Image _originalPreview;

  var _currentSaturation = 0.0;
  var _currentContrast = 0.0;
  var _currentBrightness = 0.0;
  var _currentExposure = 1.0;
  var _currentGamma = 1.0;
  var _currentHue = 0.0;
  var _currentRed = 0.0;
  var _currentGreen = 0.0;
  var _currentBlue = 0.0;

  var _currentInvert = false;
  var _currentGrayscale = false;
  var _currentEdgeDetection = 0.0;

  final PREVIEW_VALUES = {
    100: {
      'title': 'image_colorcorrections_previewsize_tiny_title',
      'description': 'image_colorcorrections_previewsize_tiny_description'
    },
    250: {
      'title': 'image_colorcorrections_previewsize_small_title',
      'description': 'image_colorcorrections_previewsize_small_description'
    },
    500: {
      'title': 'image_colorcorrections_previewsize_medium_title',
      'description': 'image_colorcorrections_previewsize_medium_description'
    },
    1000: {
      'title': 'image_colorcorrections_previewsize_big_title',
      'description': 'image_colorcorrections_previewsize_big_description'
    },
    50000: {
      'title': 'image_colorcorrections_previewsize_original_title',
      'description': 'image_colorcorrections_previewsize_original_description'
    },
  };

  _currentDataInit({int previewSize}) {
    var previewHeight = previewSize ?? Prefs.getInt(PREFERENCE_IMAGECOLORCORRECTIONS_MAXPREVIEWHEIGHT);

    img.Image image = img.decodeImage(_originalData.bytes);

    if (image.height > previewHeight) {
      img.Image resized = img.copyResize(image, height: previewHeight);
      return resized;
    } else {
      return image;
    }
  }

  @override
  void initState() {
    super.initState();

    if (widget.file != null && widget.file.bytes != null) {
      _originalData = widget.file;

      _originalPreview = _currentDataInit();
      _currentPreview = img.Image.from(_originalPreview);
    }
  }

  _resetInputs() {
    setState(() {
      _currentSaturation = 0.0;
      _currentContrast = 0.0;
      _currentBrightness = 0.0;
      _currentExposure = 1.0;
      _currentGamma = 1.0;
      _currentHue = 0.0;
      _currentRed = 0.0;
      _currentGreen = 0.0;
      _currentBlue = 0.0;

      _currentInvert = false;
      _currentGrayscale = false;
      _currentEdgeDetection = 0.0;
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
          onLoaded: (GCWFile value) {
            if (value == null || !_validateData(value.bytes)) {
              showToast(i18n(context, 'common_loadfile_exception_notloaded'));
              return;
            }

            setState(() {
              _originalData = value;

              _originalPreview = _currentDataInit();
              _currentPreview = img.Image.from(_originalPreview);

              _resetInputs();
            });
          },
        ),
        Container(), // Fixes a display issue
        if (_currentPreview != null)
          GCWTextDivider(
              suppressTopSpace: true,
              text: i18n(context, 'image_colorcorrections_previewsize_title', parameters: [
                i18n(context, PREVIEW_VALUES[Prefs.get(PREFERENCE_IMAGECOLORCORRECTIONS_MAXPREVIEWHEIGHT)]['title'])
              ]),
              trailing: GCWPopupMenu(
                  iconData: Icons.settings,
                  size: IconButtonSize.SMALL,
                  menuItemBuilder: (context) => PREVIEW_VALUES
                      .map((key, value) {
                        return MapEntry(
                            key,
                            GCWPopupMenuItem(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(i18n(context, value['title']), style: gcwDialogTextStyle()),
                                    Container(
                                        child: Text(
                                          i18n(context, value['description']),
                                          style: gcwDescriptionTextStyle().copyWith(color: themeColors().dialogText()),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        padding: EdgeInsets.only(left: DEFAULT_DESCRIPTION_MARGIN)),
                                  ],
                                ),
                                action: (index) {
                                  setState(() {
                                    Prefs.setInt(PREFERENCE_IMAGECOLORCORRECTIONS_MAXPREVIEWHEIGHT, key);

                                    _originalPreview = _currentDataInit(previewSize: key);
                                    _currentPreview = img.Image.from(_originalPreview);
                                  });
                                }));
                      })
                      .values
                      .toList())),
        if (_currentPreview != null)
          GCWImageView(
            imageData: _originalData == null ? null : GCWImageViewData(GCWFile(bytes: _imageBytes())),
            onBeforeLoadBigImage: _adjustToFullPicture,
            suppressOpenInTool: {GCWImageViewOpenInTools.COLORCORRECTIONS},
          ),
        if (_currentPreview != null)
          GCWTextDivider(
            suppressTopSpace: true,
            text: i18n(context, 'image_colorcorrections_options'),
            trailing: GCWIconButton(
              icon: Icons.refresh,
              size: IconButtonSize.SMALL,
              onPressed: () {
                _resetInputs();
              },
            ),
          ),
        if (_currentPreview != null)
          Expanded(
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                primary: true,
                child: Column(
                  children: [
                  GCWOnOffSwitch(
                      title: i18n(context, 'image_colorcorrections_invert'),
                      value: _currentInvert,
                      onChanged: (value) {
                        setState(() {
                          _currentInvert = value;
                        });
                      }),
                  GCWOnOffSwitch(
                      title: i18n(context, 'image_colorcorrections_grayscale'),
                      value: _currentGrayscale,
                      onChanged: (value) {
                        setState(() {
                          _currentGrayscale = value;
                        });
                      }),
                  GCWSlider(
                      title: i18n(context, 'image_colorcorrections_brightness'),
                      value: _currentBrightness,
                      min: -255,
                      max: 255,
                      onChanged: (value) {
                        setState(() {
                          _currentBrightness = value;
                        });
                      }),
                  GCWSlider(
                      title: i18n(context, 'image_colorcorrections_exposure'),
                      value: _currentExposure,
                      min: 0.0,
                      max: 2.0,
                      onChanged: (value) {
                        setState(() {
                          _currentExposure = value;
                        });
                      }),
                  GCWSlider(
                      title: i18n(context, 'image_colorcorrections_saturation'),
                      value: _currentSaturation,
                      min: -1.0,
                      max: 1.0,
                      onChanged: (value) {
                        setState(() {
                          _currentSaturation = value;
                        });
                      }),
                  GCWSlider(
                      title: i18n(context, 'image_colorcorrections_contrast'),
                      value: _currentContrast,
                      min: -255,
                      max: 255,
                      onChanged: (value) {
                        setState(() {
                          _currentContrast = value;
                        });
                      }),
                  GCWSlider(
                      title: i18n(context, 'image_colorcorrections_gamma'),
                      value: _currentGamma,
                      min: 0.01,
                      max: 6.99,
                      onChanged: (value) {
                        setState(() {
                          _currentGamma = value;
                        });
                      }),
                  GCWSlider(
                      title: i18n(context, 'image_colorcorrections_hue'),
                      value: _currentHue,
                      min: -180.0,
                      max: 180.0,
                      onChanged: (value) {
                        setState(() {
                          _currentHue = value;
                        });
                      }),
                  GCWSlider(
                      title: i18n(context, 'image_colorcorrections_red'),
                      value: _currentRed,
                      min: -255.0,
                      max: 255.0,
                      onChanged: (value) {
                        setState(() {
                          _currentRed = value;
                        });
                      }),
                  GCWSlider(
                      title: i18n(context, 'image_colorcorrections_green'),
                      value: _currentGreen,
                      min: -255.0,
                      max: 255.0,
                      onChanged: (value) {
                        setState(() {
                          _currentGreen = value;
                        });
                      }),
                  GCWSlider(
                      title: i18n(context, 'image_colorcorrections_blue'),
                      value: _currentBlue,
                      min: -255.0,
                      max: 255.0,
                      onChanged: (value) {
                        setState(() {
                          _currentBlue = value;
                        });
                      }),
                  GCWSlider(
                      title: i18n(context, 'image_colorcorrections_edges'),
                      value: _currentEdgeDetection,
                      min: 0.0,
                      max: 1.0,
                      onChanged: (value) {
                        setState(() {
                          _currentEdgeDetection = value;
                        });
                      })
                ],
            ),
          ))
      ],
    );
  }

  _adjustToFullPicture() async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Center(
          child: Container(
            child: GCWAsyncExecuter(
              isolatedFunction: _adjustColorAsync,
              parameter: _buildJobDataAdjustColor(),
              onReady: (data) => _saveOutputAdjustColor(data),
              isOverlay: true,
            ),
            height: 220,
            width: 150,
          ),
        );
      },
    );

    return GCWFile(bytes: _convertedOutputImage);
  }

  Future<GCWAsyncExecuterParameters> _buildJobDataAdjustColor() async {
    return GCWAsyncExecuterParameters(_AdjustColorInput(
        image: img.decodeImage(_originalData.bytes),
        invert: _currentInvert,
        grayscale: _currentGrayscale,
        edgeDetection: _currentEdgeDetection,
        red: _currentRed,
        green: _currentGreen,
        blue: _currentBlue,
        saturation: _currentSaturation,
        contrast: _currentContrast,
        gamma: _currentGamma,
        exposure: _currentExposure,
        hue: _currentHue,
        brightness: _currentBrightness));
  }

  _saveOutputAdjustColor(img.Image output) {
    if (output != null) _convertedOutputImage = encodeTrimmedPng(output);
  }

  img.Image _adjustColor(img.Image image) {
    return _doAdjustColor(_AdjustColorInput(
        image: _originalPreview,
        invert: _currentInvert,
        grayscale: _currentGrayscale,
        edgeDetection: _currentEdgeDetection,
        red: _currentRed,
        green: _currentGreen,
        blue: _currentBlue,
        saturation: _currentSaturation,
        contrast: _currentContrast,
        gamma: _currentGamma,
        exposure: _currentExposure,
        hue: _currentHue,
        brightness: _currentBrightness));
  }

  Uint8List _imageBytes() {
    _currentPreview = _adjustColor(_originalPreview);
    return encodeTrimmedPng(_currentPreview);
  }
}

Future<img.Image> _adjustColorAsync(dynamic jobData) async {
  if (jobData == null) return null;

  var output = _doAdjustColor(jobData.parameters);

  if (jobData.sendAsyncPort != null) jobData.sendAsyncPort.send(output);

  return Future.value(output);
}

class _AdjustColorInput {
  final img.Image image;
  final bool invert;
  final bool grayscale;
  final double edgeDetection;
  final double red;
  final double green;
  final double blue;
  final double saturation;
  final double contrast;
  final double gamma;
  final double exposure;
  final double hue;
  final double brightness;

  _AdjustColorInput(
      {this.image,
      this.invert: false,
      this.grayscale: false,
      this.edgeDetection: 0.0,
      this.red: 0.0,
      this.green: 0.0,
      this.blue: 0.0,
      this.saturation: 0.0,
      this.contrast: 0.0,
      this.gamma: 1.0,
      this.exposure: 1.0,
      this.hue: 0.0,
      this.brightness: 0.0});
}

img.Image _doAdjustColor(_AdjustColorInput input) {
  img.Image image = img.Image.from(input.image);

  if (input.edgeDetection > 0.0) image = img.sobel(image, amount: input.edgeDetection);

  final pixels = image.getBytes();
  for (var i = 0, len = pixels.length; i < len; i += 4) {
    var pixel = RGBPixel.getPixel(pixels, i);

    if (input.red != 0.0 || input.green != 0.0 || input.blue != 0.0)
      pixel = colorOffset(pixel, input.red, input.green, input.blue);

    if (input.brightness != 0.0) pixel = brightness(pixel, input.brightness);

    if (input.exposure != 1.0)
      pixel = exposure(pixel, input.exposure > 1.0 ? 3 * (input.exposure - 1) + 1 : input.exposure);

    if (input.saturation != 0.0 || input.hue != 0.0) pixel = saturation(pixel, input.saturation, input.hue);

    if (input.contrast != 0.0) pixel = contrast(pixel, input.contrast);

    if (input.gamma != 1.0) pixel = gamma(pixel, input.gamma);

    if (input.invert) pixel = invert(pixel);

    if (input.grayscale) pixel = grayscale(pixel);

    pixel.setPixel(pixels, i);
  }

  return image;
}

openInColorCorrections(BuildContext context, GCWFile file) {
  Navigator.push(
      context,
      NoAnimationMaterialPageRoute(
          builder: (context) => GCWTool(
              tool: ImageColorCorrections(file: file),
              toolName: i18n(context, 'image_colorcorrections_title'),
              i18nPrefix: '',
              autoScroll: false)));
}
