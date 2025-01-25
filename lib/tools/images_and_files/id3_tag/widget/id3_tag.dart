import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/common_widgets/gcw_expandable.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_columned_multiline_output.dart';
import 'package:id3_codec/id3_codec.dart';
import 'package:gc_wizard/common_widgets/gcw_openfile.dart';
import 'package:gc_wizard/common_widgets/gcw_snackbar.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/utils/file_utils/gcw_file.dart';
import 'package:intl/intl.dart';

class ID3Tag extends StatefulWidget {
  final GCWFile? file;

  const ID3Tag({Key? key, this.file}) : super(key: key);

  @override
  _ID3TagState createState() => _ID3TagState();
}

class _ID3TagState extends State<ID3Tag> {
  List<List<String>> _tableTagsHeader = [];
  List<List<String>> _tableTagsFrames = [];
  List<List<String>> _tableTagsPadding = [];
  List<List<String>> _tableTagsMisc = [];

  GCWFile? _file;
  Uint8List _bytes = Uint8List.fromList([]);

  var _fileLoaded = false;

  @override
  initState() {
    super.initState();

    if (widget.file != null) {
      _file = widget.file;
      _bytes = _file!.bytes;
      _fileLoaded = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        GCWOpenFile(
          supportedFileTypes: SUPPORTED_SOUND_TYPES,
          suppressGallery: false,
          onLoaded: (_file) {
            if (_file == null) {
              showSnackBar(i18n(context, 'common_loadfile_exception_notloaded'), context);
              return;
            }
            _bytes = _file.bytes;
            _fileLoaded = true;
            _tableTagsHeader = [];
            _tableTagsFrames = [];
            _tableTagsPadding = [];
            _tableTagsMisc = [];
            final decoder = ID3Decoder(_bytes);
            final metadata = decoder.decodeSync();
            for (var data in metadata) {
              Map<String, dynamic> dataJSON = data.toTagMap();
              dataJSON.forEach((key, value) {
                switch (key) {
                  case "Header": _tableTagsHeader = _buildTableTagsHeader(value as Map<dynamic, dynamic>); break;
                  case "Frames": _tableTagsFrames = _buildTableTagsFrames(value as List<dynamic>); break;
                  case "Padding": _tableTagsPadding = _buildTableTagsPadding(value as Map<dynamic, dynamic>); break;
                  default: _tableTagsMisc = _buildTableTagsMisc(value as Map<dynamic, dynamic>); break;
                }
              });
            }
            setState(() {

            });
          },
        ),
        _buildOutput()
      ],
    );
  }

  Widget _buildOutput() {
    if (!_fileLoaded) {
      return Container();
    }

    return GCWDefaultOutput(
      child: Column(
        children: [
          GCWExpandableTextDivider(
            text: 'Header',
            child: GCWColumnedMultilineOutput(data: _tableTagsHeader),
          ),
          GCWExpandableTextDivider(
            text: 'Frames',
            child: GCWColumnedMultilineOutput(data: _tableTagsFrames),
          ),
          GCWExpandableTextDivider(
            text: 'Padding',
            child: GCWColumnedMultilineOutput(data: _tableTagsPadding),
          ),
          _tableTagsMisc.isNotEmpty ? GCWExpandableTextDivider(
            text: '?',
            child: GCWColumnedMultilineOutput(data: _tableTagsMisc),
          ) : Container(),
        ],
      ),
    );
  }

List<List<String>> _buildTableTagsHeader(Map<dynamic, dynamic> data) {
  List<List<String>> result = [];
  data.forEach((key, value) {
    result.add([key.toString(), value.toString()]);
  });
  return result;
}

  List<List<String>> _buildTableTagsPadding(Map<dynamic, dynamic> data) {
    List<List<String>> result = [];
    data.forEach((key, value) {
      result.add([key.toString(), value.toString()]);
    });
    return result;
  }

  List<List<String>> _buildTableTagsFrames(List<dynamic> data) {
    List<List<String>> result = [];
    data.forEach((dataSet) {
      if (dataSet.runtimeType.toString() == 'LinkedMap<dynamic, dynamic>') {
        final dataMap = json.decode(json.encode(dataSet)) as Map<String, dynamic>;
        dataMap.forEach((key, value) {
          switch (key) {
            case 'Content':
              final valueMap = json.decode(json.encode(value)) as Map<String, dynamic>;
              valueMap.forEach((subKey, value){
                switch (subKey) {
                  case 'Base64': result.add([key, subKey, value.toString()]);break;
                  default: result.add([key, subKey, value.toString()]);
                }

              });
              break;
            default: result.add([key, value.toString(), '']);
          }
        });
      }
    });

    return result;
  }

  List<List<String>> _buildTableTagsMisc(Map<dynamic, dynamic> data) {
    List<List<String>> result = [];
    data.forEach((key, value) {
      result.add([key.toString(), value.toString()]);
    });
    return result;
  }
}


