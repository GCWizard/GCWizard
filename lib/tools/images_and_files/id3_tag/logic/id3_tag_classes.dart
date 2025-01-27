part of 'package:gc_wizard/tools/images_and_files/id3_tag/logic/id3_tag.dart';

// https://id3.org/ID3v1
class ID3v10Tag {
  final String title;
  final String artist;
  final String album;
  final String year;
  final String comment;
  final int genre;

  ID3v10Tag(
      {required this.title,
      required this.artist,
      required this.album,
      required this.year,
      required this.comment,
      required this.genre});
}

class ID3v11Tag {
  final String title;
  final String artist;
  final String album;
  final String year;
  final String comment;
  final int track;
  final int genre;

  ID3v11Tag(
      {required this.title,
      required this.artist,
      required this.album,
      required this.year,
      required this.comment,
      required this.track,
      required this.genre});
}

// https://id3.org/d3v2.3.0
// https://id3.org/id3v2.4.0-structure
class ID3v2Tag {
  final ID3Header header;
  final ID3extendedHeader extendedHeader;
  final List<ID3Frame> frames;
  final ID3Padding padding;
  final ID3Footer footer;

  ID3v2Tag(
      {required this.header,
      required this.extendedHeader,
      required this.frames,
      required this.padding,
      required this.footer});
}

class ID3Header {}

class ID3extendedHeader {}

class ID3Frame {}

class ID3Padding {}

class ID3Footer {}

class ID3v23Tag {}

class ID3v24Tag {}

class ID3TagData {
  final ID3_VERSION? version;
  final ID3v10Tag? ID3v10data;
  final ID3v11Tag? ID3v11data;
  final ID3v23Tag? ID3v23data;
  final ID3v24Tag? ID3v24data;

  ID3TagData(
      {required this.version,
      required this.ID3v10data,
      required this.ID3v11data,
      required this.ID3v23data,
      required this.ID3v24data,});
}




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
    required this.tableTagsImages,
  });
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

  const ID3FrameTagList({
    required this.tableTagsFrames,
    required this.tableTagsImages,
  });
}

const EMPTY_ID3FRAMELIST =
    ID3FrameTagList(tableTagsFrames: [], tableTagsImages: []);
