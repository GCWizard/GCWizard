import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:archive/archive_io.dart';
import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/app_localizations.dart';
import 'package:gc_wizard/application/theme/theme_colors.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_iconbutton.dart';
import 'package:gc_wizard/common_widgets/dialogs/gcw_exported_file_dialog.dart';
import 'package:gc_wizard/common_widgets/gcw_soundplayer.dart';
import 'package:gc_wizard/common_widgets/image_viewers/gcw_imageview.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_output_text.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/tools/images_and_files/hexstring2file/logic/hexstring2file.dart';
import 'package:gc_wizard/utils/file_utils/file_utils.dart';
import 'package:gc_wizard/utils/file_utils/gcw_file.dart';
import 'package:gc_wizard/utils/ui_dependent_utils/file_widget_utils.dart';

class HexString2File extends StatefulWidget {
  const HexString2File({Key? key}) : super(key: key);

  @override
  HexString2FileState createState() => HexString2FileState();
}

class HexString2FileState extends State<HexString2File> {
  var _currentInput = '';
  Uint8List? _outData;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GCWTextField(
          onChanged: (value) {
            setState(() {
              _currentInput = value;
            });
          },
        ),
        GCWDefaultOutput(
            trailing: GCWIconButton(
              icon: Icons.save,
              size: IconButtonSize.SMALL,
              iconColor: _outData == null ? themeColors().inActive() : null,
              onPressed: () {
                _outData == null ? null : _exportFile(context, _outData!);
              },
            ),
            child: _buildOutput())
      ],
    );
  }

  Widget _buildOutput() {
    _outData = hexstring2file(_currentInput);

    if (_outData == null) return Container();

    return hexDataOutput(context, <Uint8List>[_outData!]);
  }

  Future<void> _exportFile(BuildContext context, Uint8List data) async {
    var fileType = getFileType(data);
    await saveByteDataToFile(context, data, buildFileNameWithDate('hex_', fileType)).then((value) {
      var content = fileClass(fileType) == FileClass.IMAGE ? imageContent(context, data) : null;
      if (value) showExportedFileDialog(context, contentWidget: content);
    });
  }
}

Widget hexDataOutput(BuildContext context, List<Uint8List> outData) {

  var children = outData.map((Uint8List _outData) {
    var file = GCWFile(bytes: _outData);

    switch (file.fileClass) {
      case FileClass.IMAGE:
        try {
          return GCWImageView(imageData: GCWImageViewData(file));
        } catch (e) {}
        return _fileWidget(context, getFileType(_outData));

      case FileClass.TEXT:
        return GCWOutputText(text: String.fromCharCodes(_outData));

      case FileClass.SOUND:
        return GCWSoundPlayer(file: file);

      case FileClass.ARCHIVE:
        var fileType = file.fileType;
        if (fileType == FileType.ZIP) {
          try {
            InputStream input = InputStream(_outData.buffer.asByteData());
            return (_archiveWidget(context, ZipDecoder().decodeBuffer(input), fileType));
          } catch (e) {}
        } else if (fileType == FileType.TAR) {
          try {
            InputStream input = InputStream(_outData.buffer.asByteData());
            return (_archiveWidget(context, TarDecoder().decodeBuffer(input), fileType));
          } catch (e) {}
        } else {
          return _fileWidget(context, fileType);
        }
        break;
      default:
        return _fileWidget(context, getFileType(_outData));
    }
    return Container();
  }).toList();

  return Column(children: children);
}

Widget _archiveWidget(BuildContext context, Archive archive, FileType fileType) {
  var type = fileType.toString().split('.')[1];

  var text =
      type + '-' + i18n(context, 'hexstring2file_file') + ' -> ' + i18n(context, 'hexstring2file_content') + '\n';

  text += archive.where((element) => element.isFile).map((file) {
    return ('-> ' + file.name);
  }).join('\n');

  return GCWOutputText(text: text);
}

Widget _fileWidget(BuildContext context, FileType fileType) {
  var extension = fileExtension(fileType);

  return GCWOutputText(text: extension + '-' + i18n(context, 'hexstring2file_file'));
}
