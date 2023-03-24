import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/app_localizations.dart';
import 'package:gc_wizard/application/navigation/no_animation_material_page_route.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_button.dart';
import 'package:gc_wizard/common_widgets/coordinates/gcw_coords_output/gcw_coords_output.dart';
import 'package:gc_wizard/common_widgets/gcw_openfile.dart';
import 'package:gc_wizard/common_widgets/gcw_toast.dart';
import 'package:gc_wizard/common_widgets/gcw_tool.dart';
import 'package:gc_wizard/common_widgets/image_viewers/gcw_imageview.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_columned_multiline_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_output.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinates.dart';
import 'package:gc_wizard/tools/coords/_common/logic/default_coord_getter.dart';
import 'package:gc_wizard/tools/coords/map_view/logic/map_geometries.dart';
import 'package:gc_wizard/tools/images_and_files/exif_reader/logic/exif_reader.dart';
import 'package:gc_wizard/tools/images_and_files/hidden_data/logic/hidden_data.dart';
import 'package:gc_wizard/tools/images_and_files/hidden_data/widget/hidden_data.dart';
import 'package:gc_wizard/utils/file_utils/file_utils.dart';
import 'package:gc_wizard/utils/file_utils/gcw_file.dart';
import 'package:image/image.dart' as Image;
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';

class ExifReader extends StatefulWidget {
  final GCWFile? file;

  const ExifReader({Key? key, this.file}) : super(key: key);

  @override
  _ExifReaderState createState() => _ExifReaderState();
}

class _ExifReaderState extends State<ExifReader> {
  Map<String, List<List<dynamic>>>? tableTags;
  GCWFile? file;
  LatLng? point;
  GCWImageViewData? thumbnail;
  Image.Image? image;

  var _fileLoaded = false;

  @override
  initState() {
    super.initState();

    if (widget.file != null) {
      file = widget.file;
      _readFile(file);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        GCWOpenFile(
          supportedFileTypes: SUPPORTED_IMAGE_TYPES,
          onLoaded: (_file) {
            if (_file == null) {
              showToast(i18n(context, 'common_loadfile_exception_notloaded'));
              return;
            }

            _readFile(_file);
          },
        ),
        Container(),
        ..._buildOutput(tableTags)
      ],
    );
  }

  Future<void> _readFile(GCWFile? _file) async {
    Image.Image? _image;

    if (_file != null) _image = await _completeImageMetadata(_file);

    if (_file == null) {
      showToast(i18n(context, 'common_loadfile_exception_notloaded'));
      _fileLoaded = false;
      return;
    }

    var tags = await parseExif(_file);

    GCWImageViewData? _thumbnail;
    LatLng? _point;
    Map<String, List<List<dynamic>>>? _tableTags;
    try {
      if (tags != null) {
        _thumbnail = completeThumbnail(tags);
        _tableTags = buildTablesExif(tags);
        var xmpTags = buildXmpTags(_file, _tableTags);
        _point = completeGPSData(tags);
        if (_point == null && xmpTags != null) {
          _point = completeGPSDataFromXmp(xmpTags);
        }
      }

      _fileLoaded = true;

      setState(() {
        file = _file;
        tableTags = _tableTags;
        point = _point; // GPS Point
        thumbnail = _thumbnail; // Thumbnail
        image = _image;
      });
    } catch (e) {
      // An error occured, but keep it silently to not pollute UI
    }
  }

  List<Widget> _buildOutput(Map<String, List<List<dynamic>>>? _tableTags) {
    if (!_fileLoaded) {
      return [const GCWDefaultOutput()];
    }

    List<Widget> widgets = [];
    widgets.add(Container(
      padding: const EdgeInsets.only(top: 10),
      child: GCWImageView(
        imageData: GCWImageViewData(file!),
        suppressOpenInTool: const {GCWImageViewOpenInTools.METADATA},
      ),
    ));
    _decorateFile(widgets, file);
    if (image != null) _decorateImage(widgets, image!);
    _decorateFileTypeSpecific(widgets, file);
    _decorateThumbnail(widgets);
    if (_tableTags != null) _decorateExifSections(widgets, _tableTags);
    _decorateGps(widgets);
    _decorateHiddenData(widgets);
    return widgets;
  }

  ///
  /// Add Thumbnail section
  ///
  void _decorateThumbnail(List<Widget> widgets) {
    if (thumbnail?.file.bytes != null && thumbnail!.file.bytes.isNotEmpty) {
      widgets.add(GCWOutput(
        title: i18n(context, 'exif_section_thumbnail'),
        child: GCWImageView(imageData: thumbnail),
        //suppressCopyButton: false,
      ));
    }
  }

  ///
  /// Add GPS section
  ///
  void _decorateGps(List<Widget> widgets) {
    if (point == null) return;

    var _currentCoordsFormat = defaultCoordinateFormat;
    List<BaseCoordinate> _currentOutput = [
      buildCoordinatesByFormat(defaultCoordinateFormat, point!, defaultEllipsoid),
    ];

    widgets.add(
      GCWCoordsOutput(
        title: i18n(context, 'exif_gpscoordinates'),
        outputs: _currentOutput,
        points: [
          GCWMapPoint(point: point!, coordinateFormat: _currentCoordsFormat),
        ],
      ),
    );
  }

  ///
  /// EXIF tags grouped by section
  ///
  void _decorateExifSections(List<Widget> widgets, Map<String, List<List<dynamic>>> _tableTags) {
    _tableTags.forEach((section, tags) {
      widgets.add(GCWOutput(
          title: i18n(context, "exif_section_" + section, ifTranslationNotExists: section),
          child: GCWColumnedMultilineOutput(
              data: tags
          ),
        )
      );
    });
  }

  ///
  /// Section file type specific
  ///
  void _decorateFileTypeSpecific(List<Widget> widgets, GCWFile? file) {
    if (file == null) return;

    var data = <List<dynamic>>[];
    var fileType = getFileType(file.bytes);

    switch (fileType) {
      case FileType.JPEG:
        var jpegData = Image.JpegData();
        jpegData.read(file.bytes);

        if (jpegData.comment != null && jpegData.comment!.isNotEmpty) {
          data.add([i18n(context, 'exif_comment'), jpegData.comment]);
        }
        if (jpegData.adobe != null) {
          var adobe = jpegData.adobe!;
          if (adobe.version != null) data.add(['Adobe Version', adobe.version]);
          if (adobe.transformCode != null) data.add(['Adobe TransformCode', adobe.transformCode]);
          if (adobe.flags0 != null) data.add(['Adobe Flags 0', adobe.flags0]);
          if (adobe.flags1 != null) data.add(['Adobe Flags 1', adobe.flags1]);
        }
        break;
      default:
        return;
    }

    if (data.isNotEmpty) {
      widgets.add(GCWOutput(
          title: fileType.toString().split('.').last,
          child: GCWColumnedMultilineOutput(
              data: data),
          )
      );
    }
  }

  ///
  /// Section file
  ///
  void _decorateFile(List<Widget> widgets, GCWFile? file) {
    if (file != null) {
      File? _file;
      if (file.path != null) {
        _file = File(file.path!);
      }

      widgets.add(GCWOutput(
          title: i18n(context, "exif_section_file"),
          child: GCWColumnedMultilineOutput(
            data: [
                    [i18n(context, 'exif_filename'), file.name ?? ''],
                    [i18n(context, 'exif_filesize_bytes'), file.bytes.length],
                    [i18n(context, 'exif_filesize_kb'), (file.bytes.length / 1024).ceil()],
                    ['lastModified', formatDate(_file?.lastModifiedSync())],
                    ['lastAccessed', formatDate(_file?.lastAccessedSync())],
                    [i18n(context, 'exif_extension'), file.extension]
                  ],
          )
      ));
    }
  }

  void _decorateImage(List<Widget> widgets, Image.Image image) {
    String channels = 'RGB';
    if (image.numChannels == 4) {
      channels = 'ARGB';
    }

    widgets.add(GCWOutput(
        title: i18n(context, 'exif_section_image'),
        child: GCWColumnedMultilineOutput(
            data: [
                    [i18n(context, 'exif_width'), image.width ],
                    [i18n(context, 'exif_height'), image.height],
                    ['Color Channels', channels ],
                    ['ICC Color Profile', image.iccProfile],
                    // Only for frames within an animation
                    // [i18n(context, 'exif_duration'), image.duration ?? ''],
                    // ['Offset X', image.xOffset ?? ''],
                    // ['Offset Y', image.yOffset ?? ''],
                    // image.exif
                  ],
        )
    ));

  }

  Future<Image.Image?> _completeImageMetadata(GCWFile file) async {
    Uint8List data = file.bytes;
    Image.Image? image;
    try {
      image = Image.decodeImage(data);
    } catch (e) {
      // Silent error
    }
    return Future.value(image);
  }

  String formatDate(DateTime? datetime) {
    String loc = Localizations.localeOf(context).toString();
    return (datetime == null) ? '' : DateFormat.yMd(loc).add_jms().format(datetime);
  }

  ///
  /// Section extra data
  ///
  Future<void> _decorateHiddenData(List<Widget> widgets) async {
    if (file == null) return;
    var _hiddenData = await hiddenData(file!);

    if (_hiddenData.length <= 1) return;

    widgets.add(GCWOutput(
        title: i18n(context, 'hiddendata_title'),
        child: GCWButton(
          text: i18n(context, 'exif_showhiddendata'),
          onPressed: () {
            openInHiddenData(context, file!);
          },
        )));
  }
}

void openInMetadataViewer(BuildContext context, GCWFile file) {
  Navigator.push(
      context,
      NoAnimationMaterialPageRoute<GCWTool>(
          builder: (context) =>
              GCWTool(tool: ExifReader(file: file), toolName: i18n(context, 'exif_title'), id: 'exif')));
}
