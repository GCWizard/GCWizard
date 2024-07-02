import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/application/theme/theme.dart';
import 'package:gc_wizard/application/theme/theme_colors.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_iconbutton.dart';
import 'package:gc_wizard/common_widgets/dialogs/gcw_exported_file_dialog.dart';
import 'package:gc_wizard/common_widgets/gcw_popup_menu.dart';
import 'package:gc_wizard/common_widgets/gcw_text.dart';
import 'package:gc_wizard/common_widgets/image_viewers/gcw_imageview_fullscreen.dart';
import 'package:gc_wizard/tools/images_and_files/exif_reader/widget/exif_reader.dart';
import 'package:gc_wizard/tools/images_and_files/hex_viewer/widget/hex_viewer.dart';
import 'package:gc_wizard/tools/images_and_files/hidden_data/widget/hidden_data.dart';
import 'package:gc_wizard/tools/images_and_files/image_colorcorrections/widget/image_colorcorrections.dart';
import 'package:gc_wizard/tools/images_and_files/image_flip_rotate/widget/image_flip_rotate.dart';
import 'package:gc_wizard/utils/file_utils/file_utils.dart';
import 'package:gc_wizard/utils/file_utils/gcw_file.dart';
import 'package:gc_wizard/utils/ui_dependent_utils/file_widget_utils.dart';
import 'package:image/image.dart' as img;
import 'package:photo_view/photo_view.dart';

enum GCWImageViewButtons { ALL, SAVE, VIEW_IN_TOOLS }

enum GCWImageViewOpenInTools { METADATA, HEXVIEW, COLORCORRECTIONS, HIDDENDATA, FLIPROTATE }

class GCWImageViewData {
  final GCWFile file;
  final String? description;
  final bool? marked;

  const GCWImageViewData(this.file, {this.description, this.marked});
}

class GCWImageView extends StatefulWidget {
  final GCWImageViewData? imageData;
  final bool toolBarRight;
  final String? extension;
  final String? fileName;
  final Set<GCWImageViewButtons>? suppressedButtons;
  final int? maxHeightInPreview;
  final Future<GCWFile?> Function()? onBeforeLoadBigImage;
  final Set<GCWImageViewOpenInTools>? suppressOpenInTool;

  const GCWImageView(
      {Key? key,
      required this.imageData,
      this.toolBarRight = true,
      this.extension,
      this.fileName,
      this.suppressedButtons,
      this.maxHeightInPreview,
      this.suppressOpenInTool,
      this.onBeforeLoadBigImage})
      : super(key: key);

  @override
  _GCWImageViewState createState() => _GCWImageViewState();
}

class _GCWImageViewState extends State<GCWImageView> {
  MemoryImage? _image;
  MemoryImage? _previewImage;
  Color _bgColor = Colors.black;

  late PhotoViewScaleStateController _scaleStateController;

  @override
  void initState() {
    super.initState();
    _scaleStateController = PhotoViewScaleStateController();
  }

  @override
  void dispose() {
    _scaleStateController.dispose();
    super.dispose();
  }

  MemoryImage? _resizeImage() {
    if (widget.imageData?.file.bytes == null) return null;
    img.Image? image = img.decodeImage(widget.imageData!.file.bytes);
    if (image != null && widget.maxHeightInPreview != null && image.height > widget.maxHeightInPreview!) {
      img.Image resized = img.copyResize(image, height: widget.maxHeightInPreview);

      return MemoryImage(encodeTrimmedPng(resized));
    } else {
      return MemoryImage(widget.imageData!.file.bytes);
    }
  }

  @override
  Widget build(BuildContext context) {
    try {
      if (widget.imageData?.file.bytes != null) {
        _image = MemoryImage(widget.imageData!.file.bytes);

        if (widget.maxHeightInPreview == null) {
          _previewImage = MemoryImage(widget.imageData!.file.bytes);
        } else {
          _previewImage = _resizeImage();
        }
      }
    } catch (e) {
      _image = null;
    }

    return Column(children: <Widget>[
      if (_image != null)
        widget.toolBarRight
            ? Row(
                children: [
                  Expanded(child: _createPhotoView()),
                  if (_hasToolButtons())
                    Column(
                      children: _createToolbar(),
                    )
                ],
              )
            : Column(
                children: [
                  if (_hasToolButtons())
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: _createToolbar(),
                    ),
                  _createPhotoView(),
                ],
              )
    ]);
  }

  Column _createPhotoView() {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(
            left: widget.toolBarRight ? DEFAULT_MARGIN : DOUBLE_DEFAULT_MARGIN,
            right: widget.toolBarRight
                ? (_hasToolButtons() ? 5 * DEFAULT_MARGIN : DOUBLE_DEFAULT_MARGIN)
                : DOUBLE_DEFAULT_MARGIN,
          ),
          height: 250.0,
          child: Stack(
            alignment: Alignment.bottomRight,
            children: [
              ClipRect(
                child: PhotoView(
                  scaleStateController: _scaleStateController,
                  imageProvider: _previewImage,
                  minScale: PhotoViewComputedScale.contained * 0.25,
                  initialScale: PhotoViewComputedScale.contained,
                  backgroundDecoration: BoxDecoration(color: _bgColor),
                ),
              ),
              GCWPopupMenu(
                icon: Icons.color_lens,
                size: IconButtonSize.TINY,
                backgroundColor: themeColors().dialog(),
                iconColor: themeColors().dialogText(),
                menuItemBuilder: (context) => [
                  GCWPopupMenuItem(
                    child: iconedGCWPopupMenuItem(
                      context,
                      Icons.square,
                      i18n(context, 'common_color_black'),
                      color: Colors.black
                    ),
                    action: (index) => setState(() {
                      _bgColor = Colors.black;
                    })
                  ),
                  GCWPopupMenuItem(
                      child: iconedGCWPopupMenuItem(
                          context,
                          Icons.square,
                          i18n(context, 'common_color_white'),
                          color: Colors.white
                      ),
                      action: (index) => setState(() {
                        _bgColor = Colors.white;
                      })
                  ),
                  GCWPopupMenuItem(
                      child: iconedGCWPopupMenuItem(
                        context,
                        Icons.square,
                        i18n(context, 'common_color_pink'),
                        color: Colors.purpleAccent
                      ),
                      action: (index) => setState(() {
                        _bgColor = Colors.purpleAccent;
                      })
                  ),
                  GCWPopupMenuItem(
                      child: iconedGCWPopupMenuItem(
                          context,
                          Icons.square,
                          i18n(context, 'common_color_blue'),
                          color: Colors.indigo
                      ),
                      action: (index) => setState(() {
                        _bgColor = Colors.indigo;
                      })
                  ),
                  GCWPopupMenuItem(
                      child: iconedGCWPopupMenuItem(
                          context,
                          Icons.square,
                          i18n(context, 'common_color_green'),
                          color: Colors.lightGreen
                      ),
                      action: (index) => setState(() {
                        _bgColor = Colors.lightGreen;
                      })
                  ),
                ]
              )
            ],
          )
        ),
        if ((widget.imageData?.description ?? '').trim().isNotEmpty)
          Container(
              padding: const EdgeInsets.only(top: 10),
              child: GCWText(
                text: (widget.imageData?.description ?? '').trim(),
                align: Alignment.center,
              ))
      ],
    );
  }

  bool _hasToolButtons() {
    return widget.suppressedButtons == null || !widget.suppressedButtons!.contains(GCWImageViewButtons.ALL);
  }

  List<Widget> _createToolbar() {
    var iconSize = widget.toolBarRight ? IconButtonSize.NORMAL : IconButtonSize.SMALL;

    return [
      GCWIconButton(
          icon: Icons.zoom_out_map,
          size: iconSize,
          onPressed: () {
            if (widget.imageData?.file.bytes != null) {
              if (widget.onBeforeLoadBigImage != null) {
                widget.onBeforeLoadBigImage!().then((imgData) {
                  if (imgData != null) openInFullScreen(context, imgData.bytes, _bgColor);
                });
              } else {
                openInFullScreen(context, widget.imageData!.file.bytes, _bgColor);
              }
            }
          }),
      GCWIconButton(
          icon: Icons.fit_screen,
          size: iconSize,
          onPressed: () {
            _scaleStateController.scaleState = PhotoViewScaleState.initial;
          }),
      if (widget.suppressedButtons == null || widget.suppressedButtons!.length == 1)
        widget.toolBarRight
            ? Container(height: widget.suppressedButtons != null && widget.suppressedButtons!.length == 1 ? 108 : 60)
            : Expanded(
                child: Container(),
              ),
      if (widget.suppressedButtons == null || !widget.suppressedButtons!.contains(GCWImageViewButtons.SAVE))
        GCWIconButton(
            icon: Icons.save,
            size: iconSize,
            onPressed: () {
              Uint8List? imgData;
              if (widget.onBeforeLoadBigImage != null) {
                widget.onBeforeLoadBigImage!().then((imgData) {
                  if (imgData != null) _exportFile(context, imgData.bytes);
                });
              } else {
                imgData = widget.imageData?.file.bytes;
                if (imgData != null) _exportFile(context, imgData);
              }
            }),
      if (widget.suppressedButtons == null || !widget.suppressedButtons!.contains(GCWImageViewButtons.VIEW_IN_TOOLS))
        GCWPopupMenu(
            icon: Icons.open_in_new,
            size: iconSize,
            menuItemBuilder: (context) => [
                  if (widget.suppressOpenInTool == null ||
                      !widget.suppressOpenInTool!.contains(GCWImageViewOpenInTools.METADATA))
                    GCWPopupMenuItem(
                      child: iconedGCWPopupMenuItem(context, Icons.info_outline, 'exif_openinmetadata'),
                      action: (index) => setState(() {
                        if (widget.onBeforeLoadBigImage != null) {
                          widget.onBeforeLoadBigImage!().then((imgData) {
                            if (imgData != null) openInMetadataViewer(context, imgData);
                          });
                        } else if (widget.imageData?.file != null) {
                          openInMetadataViewer(context, widget.imageData!.file);
                        }
                      }),
                    ),
                  if (widget.suppressOpenInTool == null ||
                      !widget.suppressOpenInTool!.contains(GCWImageViewOpenInTools.HEXVIEW))
                    GCWPopupMenuItem(
                      child: iconedGCWPopupMenuItem(context, Icons.text_snippet_outlined, 'hexviewer_openinhexviewer'),
                      action: (index) => setState(() {
                        if (widget.onBeforeLoadBigImage != null) {
                          widget.onBeforeLoadBigImage!().then((imgData) {
                            if (imgData != null) openInHexViewer(context, imgData);
                          });
                        } else if (widget.imageData?.file != null) {
                          openInHexViewer(context, widget.imageData!.file);
                        }
                      }),
                    ),
                  if (widget.suppressOpenInTool == null ||
                      !widget.suppressOpenInTool!.contains(GCWImageViewOpenInTools.HIDDENDATA))
                    GCWPopupMenuItem(
                      child: iconedGCWPopupMenuItem(context, Icons.search, 'hiddendata_openinhiddendata'),
                      action: (index) => setState(() {
                        if (widget.onBeforeLoadBigImage != null) {
                          widget.onBeforeLoadBigImage!().then((imgData) {
                            if (imgData != null) openInHiddenData(context, imgData);
                          });
                        } else if (widget.imageData?.file != null) {
                          openInHiddenData(context, widget.imageData!.file);
                        }
                      }),
                    ),
                  if (widget.suppressOpenInTool == null ||
                      !widget.suppressOpenInTool!.contains(GCWImageViewOpenInTools.COLORCORRECTIONS))
                    GCWPopupMenuItem(
                        child: iconedGCWPopupMenuItem(
                            context, Icons.brush, 'image_colorcorrections_openincolorcorrection'),
                        action: (index) => setState(() {
                              if (widget.onBeforeLoadBigImage != null) {
                                widget.onBeforeLoadBigImage!().then((imgData) {
                                  if (imgData != null) openInColorCorrections(context, imgData);
                                });
                              } else if (widget.imageData?.file != null) {
                                openInColorCorrections(context, widget.imageData!.file);
                              }
                            })),
                  if (widget.suppressOpenInTool == null ||
                      !widget.suppressOpenInTool!.contains(GCWImageViewOpenInTools.FLIPROTATE))
                    GCWPopupMenuItem(
                        child: iconedGCWPopupMenuItem(context, Icons.brush, 'image_fliprotate_openinfliprotate'),
                        action: (index) => setState(() {
                              if (widget.onBeforeLoadBigImage != null) {
                                widget.onBeforeLoadBigImage!().then((imgData) {
                                  if (imgData != null) openInFlipRotate(context, imgData);
                                });
                              } else if (widget.imageData?.file != null) {
                                openInFlipRotate(context, widget.imageData!.file);
                              }
                            })),
                ])
    ];
  }

  Future<void> _exportFile(BuildContext context, Uint8List data) async {
    var fileType = getFileType(data);
    await saveByteDataToFile(context, data, buildFileNameWithDate('img_', fileType)).then((value) {
      if (value) showExportedFileDialog(context, contentWidget: imageContent(context, data));
    });
  }
}
