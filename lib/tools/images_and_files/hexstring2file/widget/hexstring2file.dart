import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:archive/archive_io.dart';
import 'package:flutter/material.dart';
import 'package:gc_wizard/i18n/app_localizations.dart';
import 'package:gc_wizard/tools/images_and_files/hexstring2file/logic/hexstring2file.dart';
import 'package:gc_wizard/theme/theme_colors.dart';
import 'package:gc_wizard/tools/common/base/gcw_iconbutton/widget/gcw_iconbutton.dart';
import 'package:gc_wizard/tools/common/base/gcw_output_text/widget/gcw_output_text.dart';
import 'package:gc_wizard/tools/common/base/gcw_textfield/widget/gcw_textfield.dart';
import 'package:gc_wizard/tools/common/gcw_default_output/widget/gcw_default_output.dart';
import 'package:gc_wizard/tools/common/gcw_exported_file_dialog/widget/gcw_exported_file_dialog.dart';
import 'package:gc_wizard/tools/common/gcw_imageview/widget/gcw_imageview.dart';
import 'package:gc_wizard/tools/common/gcw_soundplayer/widget/gcw_soundplayer.dart';
import 'package:gc_wizard/tools/utils/file_utils/widget/file_utils.dart';
import 'package:gc_wizard/tools/utils/gcw_file/widget/gcw_file.dart';
import 'package:intl/intl.dart';

class HexString2File extends StatefulWidget {
  const HexString2File({Key key}) : super(key: key);

  @override
  HexString2FileState createState() => HexString2FileState();
}

class HexString2FileState extends State<HexString2File> {
  var _currentInput = '';
  Uint8List _outData;

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
            child: _buildOutput(),
            trailing: GCWIconButton(
              icon: Icons.save,
              size: IconButtonSize.SMALL,
              iconColor: _outData == null ? themeColors().inActive() : null,
              onPressed: () {
                _outData == null ? null : _exportFile(context, _outData);
              },
            ))
      ],
    );
  }

  _buildOutput() {
    _outData = hexstring2file(_currentInput);

    if (_outData == null) return null;

    return hexDataOutput(context, <Uint8List>[_outData]);
  }

  _exportFile(BuildContext context, Uint8List data) async {
    var fileType = getFileType(data);
    var value = await saveByteDataToFile(
        context, data, "hex_" + DateFormat('yyyyMMdd_HHmmss').format(DateTime.now()) + '.' + fileExtension(fileType));

    if (value != null) showExportedFileDialog(context, fileType: fileType);
  }
}

Widget hexDataOutput(BuildContext context, List<Uint8List> outData) {
  if (outData == null) return Container();

  var children = outData.map((Uint8List _outData) {
    var _class = fileClass(getFileType(_outData));
    var file = GCWFile(bytes: _outData);

    switch (_class) {
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
        FileType fileType = getFileType(_outData);
        if (fileType == FileType.ZIP) {
          try {
            InputStream input = new InputStream(_outData.buffer.asByteData());
            return (_archiveWidget(context, ZipDecoder().decodeBuffer(input), fileType));
          } catch (e) {}
        } else if (fileType == FileType.TAR) {
          try {
            InputStream input = new InputStream(_outData.buffer.asByteData());
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
