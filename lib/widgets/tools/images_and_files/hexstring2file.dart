import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:archive/archive_io.dart';
import 'package:flutter/material.dart';
import 'package:gc_wizard/i18n/app_localizations.dart';
import 'package:gc_wizard/logic/tools/images_and_files/hexstring2file.dart';
import 'package:gc_wizard/widgets/common/base/gcw_iconbutton.dart';
import 'package:gc_wizard/widgets/common/base/gcw_output_text.dart';
import 'package:gc_wizard/widgets/common/base/gcw_textfield.dart';
import 'package:gc_wizard/widgets/common/gcw_default_output.dart';
import 'package:gc_wizard/widgets/common/gcw_exported_file_dialog.dart';
import 'package:gc_wizard/widgets/utils/file_utils.dart';
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
              iconData: Icons.save,
              size: IconButtonSize.SMALL,
              iconColor: _outData == null ? Colors.grey : null,
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

  var children = outData.map((_outData) {
    var _class = fileClass(getFileType(_outData));

    switch (_class) {
      case FileClass.IMAGE:
        try {
          return Image.memory(_outData);
        } catch (e) {}
        return _fileWidget(context, getFileType(_outData));

      case FileClass.TEXT:
        return GCWOutputText(text: String.fromCharCodes(_outData));

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
