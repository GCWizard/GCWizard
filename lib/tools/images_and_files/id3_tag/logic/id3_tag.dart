import 'dart:convert';
import 'dart:typed_data';

import 'package:id3_codec/id3_codec.dart';

class ID3TagList {
  final List<List<String>> tableTagsHeader;
  final List<List<String>> tableTagsFrames;
  final List<List<String>> tableTagsPadding;
  final List<List<String>> tableTagsMisc;
  final List<List<String>> tableTagsImages;

  const ID3TagList({
    required this.tableTagsHeader,
    required this.tableTagsFrames,
    required this.tableTagsPadding,
    required this.tableTagsMisc,
    required this.tableTagsImages, });
}


ID3TagList decodeID3MetaData(Uint8List bytes){
  final decoder = ID3Decoder(bytes);
  final metadata = decoder.decodeSync();

  List<List<String>> _tableTagsHeader = [];
  List<List<String>> _tableTagsFrames = [];
  List<List<String>> _tableTagsPadding = [];
  List<List<String>> _tableTagsImages = [];
  List<List<String>> _tableTagsMisc = [];

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

  return ID3TagList(
      tableTagsHeader: _tableTagsHeader,
      tableTagsFrames: _tableTagsFrames,
      tableTagsPadding: _tableTagsPadding,
      tableTagsMisc: _tableTagsMisc,
      tableTagsImages: _tableTagsImages);
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