import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/application/navigation/no_animation_material_page_route.dart';
import 'package:gc_wizard/application/theme/theme_colors.dart';
import 'package:gc_wizard/common_widgets/async_executer/gcw_async_executer.dart';
import 'package:gc_wizard/common_widgets/async_executer/gcw_async_executer_parameters.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_iconbutton.dart';
import 'package:gc_wizard/common_widgets/dialogs/gcw_exported_file_dialog.dart';
import 'package:gc_wizard/common_widgets/dividers/gcw_divider.dart';
import 'package:gc_wizard/common_widgets/gcw_openfile.dart';
import 'package:gc_wizard/common_widgets/gcw_snackbar.dart';
import 'package:gc_wizard/common_widgets/gcw_tool.dart';
import 'package:gc_wizard/common_widgets/image_viewers/gcw_gallery.dart';
import 'package:gc_wizard/common_widgets/image_viewers/gcw_imageview.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_columned_multiline_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_output.dart';
import 'package:gc_wizard/tools/images_and_files/animated_image/logic/animated_image.dart';
import 'package:gc_wizard/utils/file_utils/file_utils.dart';
import 'package:gc_wizard/utils/file_utils/gcw_file.dart';
import 'package:gc_wizard/utils/ui_dependent_utils/file_widget_utils.dart';

final List<FileType> ANIMATED_IMAGE_ALLOWED_FILETYPES = [FileType.GIF, FileType.PNG, FileType.WEBP];

class AnimatedImage extends StatefulWidget {
  final GCWFile? file;

  const AnimatedImage({Key? key, this.file}) : super(key: key);

  @override
  _AnimatedImageState createState() => _AnimatedImageState();
}

class _AnimatedImageState extends State<AnimatedImage> {
  AnimatedImageOutput? _outData;
  GCWFile? _file;
  bool _play = false;

  @override
  Widget build(BuildContext context) {
    if (widget.file != null) {
      _file = widget.file;
      _analysePlatformFileAsync();
    }

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
      const GCWDivider(),
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

  void _analysePlatformFileAsync() async {
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
