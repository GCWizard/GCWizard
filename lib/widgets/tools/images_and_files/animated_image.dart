import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:gc_wizard/i18n/app_localizations.dart';
import 'package:gc_wizard/logic/tools/images_and_files/animated_image.dart';
import 'package:gc_wizard/theme/theme_colors.dart';
import 'package:gc_wizard/widgets/common/base/gcw_divider.dart';
import 'package:gc_wizard/widgets/common/base/gcw_iconbutton.dart';
import 'package:gc_wizard/widgets/common/base/gcw_toast.dart';
import 'package:gc_wizard/widgets/common/gcw_async_executer.dart';
import 'package:gc_wizard/widgets/common/gcw_columned_multiline_output.dart';
import 'package:gc_wizard/widgets/common/gcw_default_output.dart';
import 'package:gc_wizard/widgets/common/gcw_exported_file_dialog.dart';
import 'package:gc_wizard/widgets/common/gcw_gallery.dart';
import 'package:gc_wizard/widgets/common/gcw_imageview.dart';
import 'package:gc_wizard/widgets/common/gcw_openfile.dart';
import 'package:gc_wizard/widgets/common/gcw_output.dart';
import 'package:gc_wizard/widgets/common/gcw_tool.dart';
import 'package:gc_wizard/widgets/utils/file_utils.dart';
import 'package:gc_wizard/widgets/utils/gcw_file.dart' as local;
import 'package:gc_wizard/widgets/utils/no_animation_material_page_route.dart';
import 'package:intl/intl.dart';

class AnimatedImage extends StatefulWidget {
  final local.GCWFile platformFile;

  const AnimatedImage({Key key, this.platformFile}) : super(key: key);

  @override
  AnimatedImageState createState() => AnimatedImageState();
}

class AnimatedImageState extends State<AnimatedImage> {
  Map<String, dynamic> _outData;
  local.GCWFile _platformFile;
  bool _play = false;
  static var allowedExtensions = [FileType.GIF, FileType.PNG, FileType.WEBP];

  @override
  Widget build(BuildContext context) {
    if (widget.platformFile != null) {
      _platformFile = widget.platformFile;
      _analysePlatformFileAsync();
    }

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
          child: _buildOutput(),
          trailing: Row(children: <Widget>[
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

  _buildOutput() {
    if (_outData == null) return null;

    var durations = <List<dynamic>>[];
    if (_outData["durations"] != null && _outData["durations"]?.length > 1) {
      var counter = 0;
      durations.addAll([
        [i18n(context, 'animated_image_table_index'), i18n(context, 'animated_image_table_duration')]
      ]);
      _outData["durations"].forEach((value) {
        counter++;
        durations.addAll([
          [counter, value]
        ]);
      });
    }

    return Column(children: <Widget>[
      _play
          ? Image.memory(_platformFile.bytes)
          : GCWGallery(imageData: _convertImageData(_outData["images"], _outData["durations"])),
      _buildDurationOutput(durations)
    ]);
  }

  Widget _buildDurationOutput(List<List<dynamic>> durations) {
    if (durations == null) return Container();

    return Column(children: <Widget>[
      GCWDivider(),
      GCWOutput(
        child: GCWColumnedMultilineOutput(
            data: durations,
            flexValues: [1, 2],
            hasHeader: true,
            copyAll: true
        )
      ),
    ]);
  }

  List<GCWImageViewData> _convertImageData(List<Uint8List> images, List<int> durations) {
    var list = <GCWImageViewData>[];

    if (images != null) {
      var imageCount = images.length;
      for (var i = 0; i < images.length; i++) {
        String description = (i + 1).toString() + '/$imageCount';
        if ((durations != null) && (i < durations.length)) {
          description += ': ' + durations[i].toString() + ' ms';
        }
        list.add(GCWImageViewData(local.GCWFile(bytes: images[i]), description: description));
      }
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
              isolatedFunction: analyseImageAsync,
              parameter: _buildJobData(),
              onReady: (data) => _showOutput(data),
              isOverlay: true,
            ),
            height: 220,
            width: 150,
          ),
        );
      },
    );
  }

  Future<GCWAsyncExecuterParameters> _buildJobData() async {
    return GCWAsyncExecuterParameters(_platformFile.bytes);
  }

  _showOutput(Map<String, dynamic> output) {
    _outData = output;

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

  _exportFiles(BuildContext context, String fileName, List<Uint8List> data) async {
    createZipFile(fileName, '.' + fileExtension(FileType.PNG), data).then((bytes) async {
      var fileType = FileType.ZIP;
      var value = await saveByteDataToFile(context, bytes,
          'anim_' + DateFormat('yyyyMMdd_HHmmss').format(DateTime.now()) + '.' + fileExtension(fileType));

      if (value != null) showExportedFileDialog(context, fileType: fileType);
    });
  }
}

openInAnimatedImage(BuildContext context, local.GCWFile file) {
  Navigator.push(
      context,
      NoAnimationMaterialPageRoute(
          builder: (context) => GCWTool(
              tool: AnimatedImage(platformFile: file),
              toolName: i18n(context, 'animated_image_title'),
              i18nPrefix: '')));
}
