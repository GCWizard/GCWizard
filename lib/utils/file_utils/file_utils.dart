import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:archive/archive_io.dart';
import 'package:collection/collection.dart';
import 'package:gc_wizard/utils/collection_utils.dart';
import 'package:gc_wizard/utils/file_utils/gcw_file.dart';
import 'package:image/image.dart' as Image;
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:unrar_file/unrar_file.dart';

enum FileType {
  GCW, // GCWizard's own suffix. e.g. for settings
  ZIP,
  _7Z,
  RAR,
  TAR,
  SEVEN_ZIP,
  GZIP,
  BZIP2,
  JPEG,
  PNG,
  GIF,
  TIFF,
  WEBP,
  WMV,
  WAV,
  MP3,
  OGG,
  SND,
  FDL,
  MIDI,
  PDF,
  EXE,
  BMP,
  TXT,
  JSON,
  GPX,
  KML,
  KMZ,
  LUAC,
  GWC,
  LUA,
}

enum FileClass { IMAGE, ARCHIVE, SOUND, DATA, TEXT, BINARY }

class FileTypeInfo {
  final List<String> extensions;
  final List<List<int>>? magic_bytes;
  final List<int>? magic_bytes_detail;
  final int? magic_bytes_offset;
  final List<String>? mime_types;
  final FileClass file_class;
  final String? uniform_type_identifier;

  const FileTypeInfo(
      {required this.extensions,
      this.magic_bytes,
      this.magic_bytes_detail,
      this.magic_bytes_offset,
      this.mime_types,
      required this.file_class,
      this.uniform_type_identifier});
}

const Map<FileType, FileTypeInfo> _FILE_TYPES = {
  // GCWizard's own suffix. e.g. for settings
  FileType.GCW: FileTypeInfo(
    extensions: ['gcw'],
    file_class: FileClass.DATA,
  ),

  // https://en.wikipedia.org/wiki/List_of_file_signatures
  // https://wiki.selfhtml.org/wiki/MIME-Type/%C3%9Cbersicht   oder   https://www.iana.org/assignments/media-types/media-types.xhtml
  FileType.JPEG: FileTypeInfo(extensions: [
    'jpg',
    'jpeg'
  ], magic_bytes: <List<int>>[
    [0xFF, 0xD8, 0xFF, 0xE0],
    [0xFF, 0xD8, 0xFF, 0xE1],
    [0xFF, 0xD8, 0xFF, 0xEE],
    [0xFF, 0xD8, 0xFF, 0xFE],
  ], mime_types: [
    'image/jpeg'
  ], file_class: FileClass.IMAGE),
  FileType.GIF: FileTypeInfo(extensions: [
    'gif'
  ], magic_bytes: <List<int>>[
    [0x47, 0x49, 0x46, 0x38, 0x39, 0x61],
    [0x47, 0x49, 0x46, 0x38, 0x37, 0x61]
  ], mime_types: [
    'image/gif'
  ], file_class: FileClass.IMAGE),
  FileType.PNG: FileTypeInfo(extensions: [
    'png'
  ], magic_bytes: <List<int>>[
    [0x89, 0x50, 0x4E, 0x47]
  ], mime_types: [
    'image/png'
  ], file_class: FileClass.IMAGE),
  FileType.BMP: FileTypeInfo(extensions: [
    'bmp'
  ], magic_bytes: <List<int>>[
    [0x42, 0x4D]
  ], mime_types: [
    'image/bmp',
    'image/x-bmp',
    'image/x-ms-bmp'
  ], file_class: FileClass.IMAGE),
  FileType.TIFF: FileTypeInfo(extensions: [
    'tiff',
    'tif'
  ], magic_bytes: <List<int>>[
    [0x49, 0x49, 0x2A, 0x00],
    [0x4D, 0x4D, 0x00, 0x2A]
  ], mime_types: [
    'image/tiff'
  ], file_class: FileClass.IMAGE),
  FileType.WEBP: FileTypeInfo(extensions: [
    'webp'
  ], magic_bytes: <List<int>>[
    [0x52, 0x49, 0x46, 0x46] // identically to WAV - check details
  ], magic_bytes_detail: <int>[
    0x57,
    0x45,
    0x42,
    0x50
  ], mime_types: [
    'image/webp'
  ], file_class: FileClass.IMAGE),
  FileType.ZIP: FileTypeInfo(extensions: [
    'zip'
  ], magic_bytes: <List<int>>[
    [0x50, 0x4B, 0x03, 0x04]
  ], mime_types: [
    'application/zip',
    'application/octet-stream',
    'application/x-zip-compressed'
  ], file_class: FileClass.ARCHIVE),
  FileType._7Z: FileTypeInfo(extensions: [
    '7z',
    '7zip'
  ], magic_bytes: <List<int>>[
    [0x37, 0x7A, 0xBC, 0xAF, 0x27, 0x1C],
    [0x30, 0x26, 0xB2, 0x75]
  ], mime_types: [
    'application/x-7z-compressed',
    'application/octet-stream'
  ], file_class: FileClass.ARCHIVE),
  FileType.TAR: FileTypeInfo(
      extensions: ['tar'],
      magic_bytes: <List<int>>[
        [0x75, 0x73, 0x74, 0x61, 0x72]
      ],
      magic_bytes_offset: 257,
      mime_types: ['application/x-tar', 'application/octet-stream', 'application/tar'],
      file_class: FileClass.ARCHIVE),
  FileType.RAR: FileTypeInfo(extensions: [
    'rar'
  ], magic_bytes: <List<int>>[
    [0x1F, 0x8B, 0x08, 0x00],
    [0x52, 0x61, 0x72, 0x21, 0x1A, 0x07, 0x00],
    [0x52, 0x61, 0x72, 0x21, 0x1A, 0x07, 0x01, 0x00]
  ], mime_types: [
    'application/x-rar-compressed',
    'application/octet-stream'
  ], file_class: FileClass.ARCHIVE),
  FileType.GZIP: FileTypeInfo(extensions: [
    'gz'
  ], magic_bytes: <List<int>>[
    [0x1F, 0x8B]
  ], mime_types: [
    'application/gzip'
  ], file_class: FileClass.ARCHIVE),
  FileType.BZIP2: FileTypeInfo(extensions: [
    'bz2'
  ], magic_bytes: <List<int>>[
    [0x42, 0x5A, 0x68]
  ], mime_types: [
    'application/x-bzip'
  ], file_class: FileClass.ARCHIVE),
  FileType.WMV: FileTypeInfo(extensions: [
    'wmv'
  ], mime_types: [
    'audio/x-ms-wmv',
    'audio/wmv'
  ], magic_bytes: <List<int>>[
    [0x30, 0x26, 0xB2, 0x75],
  ], magic_bytes_detail: <int>[
    0x57,
    0x41,
    0x56,
    0x45
  ], file_class: FileClass.SOUND),
  FileType.WAV: FileTypeInfo(extensions: [
    'wav'
  ], magic_bytes: <List<int>>[
    [0x52, 0x49, 0x46, 0x46],
    [0x57, 0x41, 0x56, 0x45]
  ], magic_bytes_detail: <int>[
    0x57,
    0x41,
    0x56,
    0x45
  ], mime_types: [
    'audio/wav',
    'audio/x-wav'
  ], file_class: FileClass.SOUND),
  FileType.MIDI: FileTypeInfo(extensions: [
    'mid',
    'midi'
  ], magic_bytes: <List<int>>[
    [0x4D, 0x54, 0x68, 0x64]
  ], mime_types: [
    'audio/midi',
    'audio/x-midi'
  ], file_class: FileClass.SOUND),
  FileType.MP3: FileTypeInfo(extensions: [
    'mp3'
  ], magic_bytes: <List<int>>[
    [0x49, 0x44, 0x33],
    [0xFF, 0xFA],
    [0xFF, 0xFB],
    [0xFF, 0xF3],
    [0xFF, 0xF2]
  ], mime_types: [
    'audio/mpeg',
    'audio/mp3',
    'audio/mpeg3',
    'audio/x-mpeg-3'
  ], file_class: FileClass.SOUND),
  FileType.OGG: FileTypeInfo(extensions: [
    'ogg',
    'oga'
  ], magic_bytes: <List<int>>[
    [0x4F, 0x67, 0x67, 0x53]
  ], mime_types: [
    'audio/ogg',
    'application/ogg'
  ], file_class: FileClass.SOUND),
  FileType.SND: FileTypeInfo(extensions: [
    'snd'
  ], magic_bytes: <List<int>>[
    [0x46, 0x4F, 0x52, 0x4D],
    [0x38, 0x53, 0x56, 0x58]
  ], mime_types: [
    'audio/snd'
  ], file_class: FileClass.SOUND),
  FileType.FDL: FileTypeInfo(extensions: [
    'fdl'
  ], magic_bytes: <List<int>>[
    [0x00, 0x00]
  ], mime_types: [
    'application/octet-stream'
  ], file_class: FileClass.SOUND),
  FileType.TXT: FileTypeInfo(
      extensions: ['txt'], magic_bytes: <List<int>>[], mime_types: ['text/plain'], file_class: FileClass.TEXT),
  FileType.JSON: FileTypeInfo(
      extensions: ['json'], magic_bytes: <List<int>>[], mime_types: ['text/plain'], file_class: FileClass.TEXT),
  FileType.PDF: FileTypeInfo(extensions: [
    'pdf'
  ], magic_bytes: <List<int>>[
    [0x25, 0x50, 0x44, 0x46]
  ], mime_types: [
    'application/pdf',
    'application/octet-stream'
  ], file_class: FileClass.DATA),
  FileType.EXE: FileTypeInfo(extensions: [
    'exe'
  ], magic_bytes: <List<int>>[
    [0x4D, 0x5A, 0x50, 0x00],
    [0x4D, 0x5A, 0x90, 0x00]
  ], mime_types: [
    'application/octet-stream'
  ], file_class: FileClass.DATA),
  FileType.GPX: FileTypeInfo(
      extensions: ['gpx'],
      magic_bytes: <List<int>>[],
      file_class: FileClass.DATA,
      mime_types: ['application/gpx', 'application/gpx+xml'],
      uniform_type_identifier: 'com.topografix.gpx'),
  FileType.KML: FileTypeInfo(
      extensions: ['kml'],
      magic_bytes: <List<int>>[],
      file_class: FileClass.DATA,
      mime_types: [
        'application/kml',
        'application/kml+xml',
        'application/xml',
        'application/vnd.google-earth.kml+xml',
        'application/vnd.google-earth.kml'
      ],
      uniform_type_identifier: 'com.google.earth.kml'),
  FileType.KMZ: FileTypeInfo(
      extensions: ['kmz'],
      magic_bytes: <List<int>>[],
      file_class: FileClass.DATA,
      mime_types: [
        'application/kmz',
        'application/kmz+xml',
        'application/xml',
        'application/vnd.google-earth.kmz+xml',
        'application/vnd.google-earth.kmz'
      ]),
  FileType.LUAC: FileTypeInfo(extensions: [
    'luac'
  ], magic_bytes: <List<int>>[
    [0x1B, 0x4C, 0x75, 0x61, 0x51, 0x00, 0x01, 0x04]
  ], mime_types: [
    'application/octet-stream'
  ], file_class: FileClass.BINARY),
  FileType.GWC: FileTypeInfo(extensions: [
    'gwc'
  ], magic_bytes: <List<int>>[
    [0x02, 0x0A, 0x43, 0x41, 0x52, 0x54, 0x00],
    [0x02, 0x0B, 0x43, 0x41, 0x52, 0x54, 0x00]
  ], mime_types: [
    'application/octet-stream'
  ], file_class: FileClass.BINARY),
  FileType.LUA: FileTypeInfo(extensions: [
    'lua'
  ], magic_bytes: <List<int>>[
    [0x72, 0x65, 0x71, 0x75, 0x69, 0x72, 0x65]
  ], mime_types: [
    'text/plain'
  ], file_class: FileClass.TEXT),
};

FileType? fileTypeByFilename(String fileName) {
  fileName = fileName.split('.').last;
  if (fileName.isEmpty) {
    return null;
  }

  return _FILE_TYPES.keys.firstWhereOrNull((type) {
    return _FILE_TYPES[type]!.extensions.contains(fileName);
  });
}

void _checkFileType(FileType type) {
  if (_FILE_TYPES[type] == null) {
    throw Exception('No file type extension');
  }
}

String fileExtension(FileType type) {
  _checkFileType(type);
  if (_FILE_TYPES[type]!.extensions.contains(null)) {
    throw Exception('No file type extension');
  }

  return _FILE_TYPES[type]!.extensions.first;
}

List<String> fileExtensions(List<FileType> types) {
  return types
      .map((type) {
        _checkFileType(type);
        if (_FILE_TYPES[type]!.extensions.contains(null)) {
          throw Exception('No file type extension');
        }

        return _FILE_TYPES[type]!.extensions;
      })
      .expand((List<String> extensions) => extensions)
      .toList();
}

List<String> fileExtensionsByFileClass(FileClass _fileClass) {
  return fileExtensions(fileTypesByFileClass(_fileClass));
}

List<FileType> fileTypesByFileClass(FileClass _fileClass) {
  return _FILE_TYPES.keys.where((type) => fileClass(type) == _fileClass).toList();
}

FileClass fileClass(FileType type) {
  _checkFileType(type);
  return _FILE_TYPES[type]!.file_class;
}

List<List<int>>? magicBytes(FileType type) {
  _checkFileType(type);
  return _FILE_TYPES[type]!.magic_bytes;
}

List<int>? magicBytesDetail(FileType type) {
  _checkFileType(type);
  return _FILE_TYPES[type]!.magic_bytes_detail;
}

int? magicBytesOffset(FileType type) {
  _checkFileType(type);
  return _FILE_TYPES[type]!.magic_bytes_offset;
}

List<String>? mimeTypes(FileType type) {
  _checkFileType(type);
  return _FILE_TYPES[type]!.mime_types;
}

String? uniformTypeIdentifier(FileType type) {
  _checkFileType(type);
  return _FILE_TYPES[type]!.uniform_type_identifier;
}

Future<Uint8List> readByteDataFromFile(String fileName) async {
  var fileIn = File(fileName);
  return fileIn.readAsBytes();
}

Future<String> readStringFromFile(String fileName) async {
  var fileIn = File(fileName);
  return fileIn.readAsString();
}

bool isImage(Uint8List blobBytes) {
  try {
    FileType fileType = getFileType(blobBytes);
    return fileClass(fileType) == FileClass.IMAGE;
  } catch (e) {
    return false;
  }
}

FileType getFileType(Uint8List blobBytes, {FileType defaultType = FileType.TXT}) {
  Uint8List RIFF = Uint8List.fromList([0x52, 0x49, 0x46, 0x46]);
  for (var fileType in _FILE_TYPES.keys) {
    var _magicBytes = magicBytes(fileType);
    var offset = magicBytesOffset(fileType) ?? 0;
    if (_magicBytes == null) continue;

    for (var bytes in _magicBytes) {
      if (blobBytes.length >= (bytes.length + offset) &&
          const ListEquality<int>().equals(blobBytes.sublist(offset, offset + bytes.length), bytes)) {
        // test if RIFF then test for details
        if (const ListEquality<int>().equals(bytes, RIFF)) {
          for (var fileTypeContainer in _FILE_TYPES.keys) {
            var _magicBytesDetails = magicBytesDetail(fileTypeContainer);
            if (const ListEquality<int>().equals(blobBytes.sublist(8, 12), _magicBytesDetails)) {
              return fileTypeContainer;
            }
          }
        } else {
          return fileType;
        }
      }
    }
  }

  return defaultType;
}

String getFileExtension(String fileName) {
  return extension(fileName);
}

String getFileBaseNameWithoutExtension(String fileName) {
  return basenameWithoutExtension(fileName);
}

String getFileBaseNameWithExtension(String fileName) {
  return basename(fileName);
}

String changeExtension(String fileName, String extension) {
  return setExtension(fileName, extension);
}

String normalizePath(String path) {
  return normalize(path);
}

String buildFileNameWithDate(String name, FileType? type) {
  return name + DateFormat('yyyyMMdd_HHmmss').format(DateTime.now()) + (type == null ? '' : '.' + fileExtension(type));
}

Future<File> _createTmpFile(String extension, Uint8List bytes) async {
  String tmpDir = (await getTemporaryDirectory()).path;
  var random = Random();
  String randomFileName = String.fromCharCodes(List.generate(20, (index) => random.nextInt(26) + 97));
  var filePath = '$tmpDir/$randomFileName.$extension';

  return File(filePath).writeAsBytes(bytes);
}

Future<bool> _createDirectory(String directory) async {
  try {
    await Directory(directory).create(recursive: true);
    return true;
  } on Exception {
    return false;
  }
}

Future<bool> _deleteDirectory(String directory) async {
  try {
    await Directory(directory).delete(recursive: true);
    return true;
  } on Exception {
    return false;
  }
}

Future<bool> _deleteFile(String path) async {
  try {
    File(path).delete();
    return true;
  } on Exception {
    return false;
  }
}

Future<Uint8List> createZipFile(String fileName, String extension, List<Uint8List> imageList) async {
  try {
    String tmpDir = (await getTemporaryDirectory()).path;
    var counter = 0;
    var zipPath = '$tmpDir/gcwizardtmp.zip';
    var pointIndex = fileName.lastIndexOf('.');
    // FileType extension = getFileType(imageList[0]);
    if (pointIndex > 0) fileName = fileName.substring(0, pointIndex);

    var encoder = ZipFileEncoder();
    encoder.create(zipPath);

    for (Uint8List imageBytes in imageList) {
      counter++;
      var fileNameZip = '$fileName' '_$counter$extension';
      var tmpPath = '$tmpDir/$fileNameZip';
      if (File(tmpPath).existsSync()) File(tmpPath).delete();

      File imageFileTmp = File(tmpPath);
      imageFileTmp = await imageFileTmp.create();
      imageFileTmp = await imageFileTmp.writeAsBytes(imageBytes);

      encoder.addFile(imageFileTmp, fileNameZip);
      imageFileTmp.delete();
    }

    encoder.close();

    var bytes = File(encoder.zipPath).readAsBytesSync();
    await File(encoder.zipPath).delete();

    return bytes;
  } catch (e) {
    throw Exception('ZIP file not created');
  }
}

List<GCWFile> _archiveToPlatformFileList(Archive archive) {
  return archive.files
      .map((ArchiveFile file) {
        if (!file.isFile) return null;

        Uint8List content = Uint8List(0);
        try {
          content = file.content as Uint8List;
        } catch (e) {}

        return GCWFile(name: file.name, bytes: content);
      })
      .whereType<GCWFile>()
      .toList();
}

Future<List<GCWFile>> extractArchive(GCWFile file) async {
  if (fileClass(file.fileType) != FileClass.ARCHIVE) return [];

  try {
    InputStream input = InputStream(file.bytes.buffer.asByteData());
    switch (file.fileType) {
      case FileType.ZIP:
        return _archiveToPlatformFileList(ZipDecoder().decodeBuffer(input));
      case FileType.TAR:
        return _archiveToPlatformFileList(TarDecoder().decodeBuffer(input));
      case FileType.BZIP2:
        var output = BZip2Decoder().decodeBuffer(input);
        var fileName = file.name ?? 'xxx';
        fileName = changeExtension(fileName, '');
        if (extension(fileName) != '.tar') fileName += '.tar';
        return {GCWFile(name: fileName, bytes: Uint8List.fromList(output))}.toList();
      case FileType.GZIP:
        var output = OutputStream();
        GZipDecoder().decodeStream(input, output);
        return {
          GCWFile(name: changeExtension(file.name ?? 'xxx', '.gzip'), bytes: Uint8List.fromList(output.getBytes()))
        }.toList();
      case FileType.RAR:
        return await _extractRarArchive(file);
      default:
        return [];
    }
  } catch (e) {
    return [];
  }
}

Future<List<GCWFile>> _extractRarArchive(GCWFile file, {String? password}) async {
  var fileList = <GCWFile>[];
  var tmpFile = await _createTmpFile('rar', file.bytes);
  var directory = changeExtension(tmpFile.path, '');

  try {
    await _createDirectory(directory);
    await UnrarFile.extract_rar(tmpFile.path, directory + '/', password: password);

    Directory(directory).listSync(recursive: true).whereType<File>().map((entity) async {
      fileList.add(
          GCWFile(name: getFileBaseNameWithExtension(entity.path), bytes: await readByteDataFromFile(entity.path)));
    }).toList();
  } catch (e) {}

  _deleteFile(tmpFile.path);
  _deleteDirectory(directory);

  return fileList;
}

Uint8List encodeTrimmedPng(Image.Image image) {
  var out = Image.encodePng(image);
  return trimNullBytes(Uint8List.fromList(out));
}

Uint8List convertStringToBytes(String text) {
  return Uint8List.fromList(utf8.encode(text));
}

String convertBytesToString(Uint8List data) {
  return utf8.decode(data);
}
