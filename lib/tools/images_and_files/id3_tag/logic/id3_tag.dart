import 'dart:convert';
import 'dart:typed_data';

import 'package:id3_codec/id3_codec.dart';

enum ID3_VERSION {V1, V11, V23, V24}

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

const EMPTY_ID3TAGLIST = ID3TagList(
tableTagsHeader: [],
tableTagsFrames: [],
tableTagsPadding: [],
tableTagsImages: [],
tableTagsMisc: []);

class ID3FrameTagList {
  final List<List<String>> tableTagsFrames;
  final List<List<String>> tableTagsImages;

  const ID3FrameTagList({required this.tableTagsFrames, required this.tableTagsImages, });
}

const EMPTY_ID3FRAMELIST = ID3FrameTagList(tableTagsFrames: [], tableTagsImages: []);

ID3TagList decodeID3MetaData(Uint8List bytes){
  final decoder = ID3Decoder(bytes);
  final metadata = decoder.decodeSync();

  List<List<String>> _tableTagsHeader = [];
  ID3FrameTagList _tableTagsFrames = EMPTY_ID3FRAMELIST;
  List<List<String>> _tableTagsPadding = [];
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
      tableTagsFrames: _tableTagsFrames.tableTagsFrames,
      tableTagsPadding: _tableTagsPadding,
      tableTagsMisc: _tableTagsMisc,
      tableTagsImages: _tableTagsFrames.tableTagsImages);
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

ID3FrameTagList _buildTableTagsFrames(List<dynamic> data) {
  List<List<String>> resultFrames = [];
  List<List<String>> resultImages = [];

  for (var dataSet in data) {
    if (dataSet.runtimeType.toString() == 'LinkedMap<dynamic, dynamic>') {
      final dataMap = json.decode(json.encode(dataSet)) as Map<String, dynamic>;
      dataMap.forEach((key, value) {
        switch (key) {
          case 'Content':
            final valueMap = json.decode(json.encode(value)) as Map<String, dynamic>;
            valueMap.forEach((subKey, value){
              switch (subKey) {
                case 'Base64':
                  resultImages.add([key, subKey, value.toString()]);
                  resultFrames.add([key, subKey, '<Image Data>']);
                  break;
                default: resultFrames.add([key, subKey, value.toString()]);
              }
            });
            break;
          default: resultFrames.add([key, value.toString(), '']);
        }
      });
    }
  }

  return ID3FrameTagList(tableTagsFrames: resultFrames, tableTagsImages: resultImages, );
}

List<List<String>> _buildTableTagsMisc(Map<dynamic, dynamic> data) {
  List<List<String>> result = [];
  data.forEach((key, value) {
    result.add([key.toString(), value.toString()]);
  });
  return result;
}