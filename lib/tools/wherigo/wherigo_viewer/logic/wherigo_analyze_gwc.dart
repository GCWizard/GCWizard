// https://pastebin.com/FmV8NHur
// https://github.com/driquet/gwcd
// https://github.com/HansWessels/unluac
// https://github.com/WFoundation/WF.Compiler
//
//
// File format of GWC files:
//
// @0000:                      ; Signature
//        BYTE     0x02               ; Version
//        BYTE     0x0a               ; 2.10 or 2.11
//        BYTE     "CART"
//        BYTE     0x00
//
// @0007:
//        USHORT   NumberOfObjects    ; Number of objects ("media files") in cartridge:
//
// @0009:
//    ; References to individual objects in cartridge.
//    ; Object 0 is always Lua bytecode for cartridge.
//    ; There is exactly [number_of_objects] blocks like this:
//    repeat <NumberOfObjects> times
//    {
//        USHORT   ObjectID           ; Distinct ID for each object, duplicates are forbidden
//        INT      Address            ; Address of object in GWC file
//    }
//
// @xxxx:                             ; 0009 + <NumberOfObjects> * 0006 bytes from begining
//    ; Header with all important informations for this cartridge
//        INT      HeaderLength       ; Length of information header (following block):
//
//        DOUBLE   Latitude           ; N+/S-
//        DOUBLE   Longitude          ; E+/W-
//        DOUBLE   Altitude           ; Meters
//
//        LONG     Date of creation   ; Seconds since 2004-02-10 01:00:00
//
//    ; MediaID of icon and splashscreen
//        SHORT    ObjectID of splashscreen    ; -1 = without splashscreen/poster
//        SHORT    ObjectID of icon            ; -1 = without icon
//
//        ASCIIZ   TypeOfCartridge             ; "Tour guide", "Wherigo cache", etc.
//        ASCIIZ   Player                      ; Name of player downloaded cartridge
//        LONG     PlayerID                    ; ID of player in the Groundspeak database
//
//        ASCIIZ   CartridgeName               ; "Name of this cartridge"
//        ASCIIZ   CartridgeGUID
//        ASCIIZ   CartridgeDescription        ; "This is a sample cartridge"
//        ASCIIZ   StartingLocationDescription ; "Nice parking"
//        ASCIIZ   Version                     ; "1.2"
//        ASCIIZ   Author                      ; Author of cartridge
//        ASCIIZ   Company                     ; Company of cartridge author
//        ASCIIZ   RecommendedDevice           ; "Garmin Colorado", "Windows PPC", etc.
//
//        INT      Length                      ; Length of CompletionCode
//        ASCIIZ   CompletionCode              ; Normally 15/16 characters
//
// @address_of_FIRST_object (with ObjectID = 0):
//    ; always Lua bytecode
//        INT      Length                      ; Length of Lua bytecode
//        BYTE[Length]    ContentOfObject      ; Lua bytecode
//
// @address_of_ALL_OTHER_objects (with ID > 0):
//        BYTE     ValidObject
//    if (ValidObject == 0)
//    {
//        ; when ValidObject == 0, it means that object is DELETED and does
//        ; not exist in cartridge. Nothing else follows.
//    }
//    else
//    {
//        ; Object type: 1=bmp, 2=png, 3=jpg, 4=gif, 17=wav, 18=mp3, 19=fdl,
//        ; 20=snd, 21=ogg, 33=swf, 49=txt, other values have unknown meaning
//        INT           ObjectType
//        INT           Length
//        BYTE[Length]  content_of_object
//    }
//
// @end
//
// Variables
//
// BYTE   = unsigned char (1 byte)
// SHORT  = signed short (2 bytes, little endian)
// INT    = signed long (4 bytes, little endian)
// LONG   = signed long (8 bytes, little endian)
// DOUBLE = double-precision floating point number (8 bytes)
// ASCIIZ = zero-terminated string ("hello world!", 0x00)

import 'dart:isolate';
import 'dart:typed_data';

import 'package:gc_wizard/tools/wherigo/wherigo_viewer/logic/wherigo_dataobjects.dart';

StringOffset readString(Uint8List byteList, int offset) {
  // zero-terminated string - 0x00
  String result = '';
  while (byteList[offset] != 0) {
    result = result + String.fromCharCode(byteList[offset]);
    offset++;
  }
  return StringOffset(result, offset + 1);
}

double readDouble(Uint8List byteList, int offset) {
  // 8 Byte
  Uint8List bytes = Uint8List(8);
  bytes[7] = byteList[offset];
  bytes[6] = byteList[offset + 1];
  bytes[5] = byteList[offset + 2];
  bytes[4] = byteList[offset + 3];
  bytes[3] = byteList[offset + 4];
  bytes[2] = byteList[offset + 5];
  bytes[1] = byteList[offset + 6];
  bytes[0] = byteList[offset + 7];
  return ByteData.sublistView(bytes).getFloat64(0);
}

int readLong(Uint8List byteList, int offset) {
  // 8 Byte
  return (byteList[offset]) +
      byteList[offset + 1] * 256 +
      byteList[offset + 2] * 256 * 256 +
      byteList[offset + 3] * 256 * 256 * 256;
}

int readInt(Uint8List byteList, int offset) {
  // 4 Byte
  return (byteList[offset]) +
      byteList[offset + 1] * 256 +
      byteList[offset + 2] * 256 * 256 +
      byteList[offset + 3] * 256 * 256 * 256;
}

int readShort(Uint8List byteList, int offset) {
  // 2 Byte
  return byteList[offset] + 256 * byteList[offset + 1];
}

int readUShort(Uint8List byteList, int offset) {
  // 2 Byte Little Endian
  return byteList[offset] + 256 * byteList[offset + 1];
}

int readByte(Uint8List byteList, int offset) {
  // 1 Byte
  return byteList[offset];
}

int START_NUMBEROFOBJECTS = 7;
int START_OBJCETADRESS = 9;
int START_HEADER = 0;
int START_FILES = 0;

const LENGTH_BYTE = 1;
const LENGTH_SHORT = 2;
const LENGTH_USHORT = 2;
const LENGTH_INT = 4;
const LENGTH_LONG = 4;
const LENGTH_DOUBLE = 8;

bool isInvalidCartridge(Uint8List byteList) {
  if (byteList == [] || byteList == null) return true;
  // @0000:                      ; Signature
  //        BYTE     0x02        ; Version Major 2
  //        BYTE     0x0a        ;         Minor 10 11
  //        BYTE     "CART"
  //        BYTE     0x00
  String Signature = '';
  Signature = Signature + byteList[0].toString(); // 2
  Signature = Signature + byteList[1].toString(); // 10 or 11
  Signature = Signature + String.fromCharCode(byteList[2]); // C
  Signature = Signature + String.fromCharCode(byteList[3]); // A
  Signature = Signature + String.fromCharCode(byteList[4]); // R
  Signature = Signature + String.fromCharCode(byteList[5]); // T
  if (Signature == '210CART' || Signature == '211CART') {
    return false;
  } else {
    return true;
  }
}

Future<Map<String, dynamic>> getCartridgeGWC(Uint8List byteListGWC, bool offline, {SendPort sendAsyncPort}) async {
  var out = Map<String, dynamic>();
  List<String> _ResultsGWC = [];
  ANALYSE_RESULT_STATUS _Status = ANALYSE_RESULT_STATUS.OK;

  FILE_LOAD_STATE checksToDo = FILE_LOAD_STATE.NULL;

  if ((byteListGWC != [] || byteListGWC != null)) checksToDo = FILE_LOAD_STATE.GWC;

  if (checksToDo == FILE_LOAD_STATE.NULL) {
    _ResultsGWC.add('wherigo_error_runtime');
    _ResultsGWC.add('wherigo_error_empty_gwc');
    out.addAll({'WherigoCartridgeGWC': WherigoCartridgeGWC()});
    return out;
  }

  String _Signature = '';
  int _NumberOfObjects = 0;
  List<MediaFileHeader> _MediaFilesHeaders = [];
  List<MediaFileContent> _MediaFilesContents = [];
  int _MediaFileID = 0;
  int _Address = 0;
  int _HeaderLength = 0;
  double _Latitude = 0.0;
  double _Longitude = 0.0;
  double _Altitude = 0.0;
  int _Splashscreen = 0;
  int _SplashscreenIcon = 0;
  int _DateOfCreation;
  String _TypeOfCartridge = '';
  String _Player = '';
  int _PlayerID = 0;
  String _CartridgeLUAName = '';
  String _CartridgeGUID = '';
  String _CartridgeDescription = '';
  String _StartingLocationDescription = '';
  String _Version = '';
  String _Author = '';
  String _Company = '';
  String _RecommendedDevice = '';
  int _LengthOfCompletionCode = 0;
  String _CompletionCode = '';

  int _Unknown3 = 0;

  int _offset = 0;
  StringOffset _ASCIIZ;
  int _MediaFileLength = 0;
  int _ValidMediaFile = 0;
  int _MediaFileType = 0;

  if (checksToDo == FILE_LOAD_STATE.GWC) {
    if (isInvalidCartridge(byteListGWC)) {
      _ResultsGWC.add('wherigo_error_runtime');
      _ResultsGWC.add('wherigo_error_invalid_gwc');
      _Status = ANALYSE_RESULT_STATUS.ERROR_GWC;
    } else {
      // analyse GWC-File
      try {
        // analysing GWC Header
        _Signature = _Signature + byteListGWC[0].toString();
        _Signature = _Signature + byteListGWC[1].toString();
        _Signature = _Signature + String.fromCharCode(byteListGWC[2]);
        _Signature = _Signature + String.fromCharCode(byteListGWC[3]);
        _Signature = _Signature + String.fromCharCode(byteListGWC[4]);
        _Signature = _Signature + String.fromCharCode(byteListGWC[5]);
        _NumberOfObjects = readUShort(byteListGWC, START_NUMBEROFOBJECTS);
        _offset = START_OBJCETADRESS; // File Header LUA File
        for (int i = 0; i < _NumberOfObjects; i++) {
          _MediaFileID = readUShort(byteListGWC, _offset);
          _offset = _offset + LENGTH_USHORT;
          _Address = readInt(byteListGWC, _offset);
          _offset = _offset + LENGTH_INT;
          _MediaFilesHeaders.add(MediaFileHeader(_MediaFileID, _Address));
        }

        START_HEADER = START_OBJCETADRESS + _NumberOfObjects * 6;
        _offset = START_HEADER;

        _HeaderLength = readLong(byteListGWC, _offset);
        _offset = _offset + LENGTH_LONG;
        START_FILES = START_HEADER + _HeaderLength;

        _Latitude = readDouble(byteListGWC, _offset);
        if (_Latitude < -90.0 || _Latitude > 90.0) _Latitude = 0.0;
        _offset = _offset + LENGTH_DOUBLE;
        _Longitude = readDouble(byteListGWC, _offset);
        if (_Longitude < -180.0 || _Longitude > 180.0) _Longitude = 0.0;
        _offset = _offset + LENGTH_DOUBLE;
        _Altitude = readDouble(byteListGWC, _offset);
        _offset = _offset + LENGTH_DOUBLE;

        _DateOfCreation = readLong(byteListGWC, _offset);
        _offset = _offset + LENGTH_LONG;

        _Unknown3 = readLong(byteListGWC, _offset);
        _offset = _offset + LENGTH_LONG;
        _Splashscreen = readShort(byteListGWC, _offset);
        _offset = _offset + LENGTH_SHORT;

        _SplashscreenIcon = readShort(byteListGWC, _offset);
        _offset = _offset + LENGTH_SHORT;

        _ASCIIZ = readString(byteListGWC, _offset);
        _TypeOfCartridge = _ASCIIZ.ASCIIZ;
        _offset = _ASCIIZ.offset;

        _ASCIIZ = readString(byteListGWC, _offset);
        _Player = _ASCIIZ.ASCIIZ;
        _offset = _ASCIIZ.offset;

        _PlayerID = readLong(byteListGWC, _offset);
        _offset = _offset + LENGTH_LONG;

        _PlayerID = readLong(byteListGWC, _offset);
        _offset = _offset + LENGTH_LONG;

        _ASCIIZ = readString(byteListGWC, _offset);
        _CartridgeLUAName = _ASCIIZ.ASCIIZ;
        _offset = _ASCIIZ.offset;

        _ASCIIZ = readString(byteListGWC, _offset);
        _CartridgeGUID = _ASCIIZ.ASCIIZ;
        _offset = _ASCIIZ.offset;

        _ASCIIZ = readString(byteListGWC, _offset);
        _CartridgeDescription = _ASCIIZ.ASCIIZ.replaceAll('<BR>', '\n');
        _offset = _ASCIIZ.offset;

        _ASCIIZ = readString(byteListGWC, _offset);
        _StartingLocationDescription = _ASCIIZ.ASCIIZ.replaceAll('<BR>', '\n');
        _offset = _ASCIIZ.offset;

        _ASCIIZ = readString(byteListGWC, _offset);
        _Version = _ASCIIZ.ASCIIZ;
        _offset = _ASCIIZ.offset;

        _ASCIIZ = readString(byteListGWC, _offset);
        _Author = _ASCIIZ.ASCIIZ;
        _offset = _ASCIIZ.offset;

        _ASCIIZ = readString(byteListGWC, _offset);
        _Company = _ASCIIZ.ASCIIZ;
        _offset = _ASCIIZ.offset;

        _ASCIIZ = readString(byteListGWC, _offset);
        _RecommendedDevice = _ASCIIZ.ASCIIZ;
        _offset = _ASCIIZ.offset;

        _LengthOfCompletionCode = readInt(byteListGWC, _offset);
        _offset = _offset + LENGTH_INT;

        _ASCIIZ = readString(byteListGWC, _offset);
        _CompletionCode = _ASCIIZ.ASCIIZ;
        _offset = _ASCIIZ.offset;

        //if (sendAsyncPort != null) { sendAsyncPort.send({'progress': 5}); }

      } catch (exception) {
        _Status = ANALYSE_RESULT_STATUS.ERROR_GWC;
        _ResultsGWC.add('wherigo_error_runtime');
        _ResultsGWC.add('wherigo_error_runtime_exception');
        _ResultsGWC.add('wherigo_error_gwc_header');
        _ResultsGWC.add(exception);
      }

      try {
        // analysing GWC - LUA Byte-Code
        // read LUA Byte-Code Object(this.ObjectID, this.Address, this.Type, this.Bytes);
        _MediaFileLength = readInt(byteListGWC, _offset);
        _offset = _offset + LENGTH_INT;
        _MediaFilesContents.add(MediaFileContent(
            0, 0, Uint8List.sublistView(byteListGWC, _offset, _offset + _MediaFileLength), _MediaFileLength));
        _offset = _offset + _MediaFileLength;

        //if (sendAsyncPort != null) { sendAsyncPort.send({'progress': 7}); }
      } catch (exception) {
        _Status = ANALYSE_RESULT_STATUS.ERROR_GWC;
        _ResultsGWC.add('wherigo_error_runtime');
        _ResultsGWC.add('wherigo_error_runtime_exception');
        _ResultsGWC.add('wherigo_error_gwc_luabytecode');
        _ResultsGWC.add(exception);
      }

      try {
        // analysing GWC - reading Media-Files
        for (int i = 1; i < _MediaFilesHeaders.length; i++) {
          _offset = _MediaFilesHeaders[i].MediaFileAddress;
          _ValidMediaFile = readByte(byteListGWC, _offset);
          if (_ValidMediaFile != 0) {
            // read Filetype
            _offset = _offset + LENGTH_BYTE;
            _MediaFileType = readInt(byteListGWC, _offset);

            // read Length
            _offset = _offset + LENGTH_INT;
            _MediaFileLength = readInt(byteListGWC, _offset);

            // read bytes
            _offset = _offset + LENGTH_INT;
            _MediaFilesContents.add(MediaFileContent(_MediaFilesHeaders[i].MediaFileID, _MediaFileType,
                Uint8List.sublistView(byteListGWC, _offset, _offset + _MediaFileLength), _MediaFileLength));
          } else {
            // despite the medioObject exists in the LUA Sourcecode, the file is not part of the cartridge
            _MediaFilesContents.add(
                MediaFileContent(_MediaFilesHeaders[i].MediaFileID, MEDIATYPE_UNK, Uint8List.fromList([]), 0));
          }
        }
      } catch (exception) {
        _Status = ANALYSE_RESULT_STATUS.ERROR_GWC;
        _ResultsGWC.add('wherigo_error_runtime');
        _ResultsGWC.add('wherigo_error_runtime_exception');
        _ResultsGWC.add('wherigo_error_invalid_gwc');
        _ResultsGWC.add('wherigo_error_gwc_luabytecode');
        _ResultsGWC.add('wherigo_error_gwc_mediafiles');
        _ResultsGWC.add(exception.toString());
      } // catxh exception
    }
  } // if checks to do GWC
  out.addAll({
    'WherigoCartridgeGWC': WherigoCartridgeGWC(
      Signature: _Signature,
      NumberOfObjects: _NumberOfObjects,
      MediaFilesHeaders: _MediaFilesHeaders,
      MediaFilesContents: _MediaFilesContents,
      HeaderLength: _HeaderLength,
      Latitude: _Latitude,
      Longitude: _Longitude,
      Altitude: _Altitude,
      Splashscreen: _Splashscreen,
      SplashscreenIcon: _SplashscreenIcon,
      DateOfCreation: _DateOfCreation,
      TypeOfCartridge: _TypeOfCartridge,
      Player: _Player,
      PlayerID: _PlayerID,
      CartridgeLUAName: _CartridgeLUAName,
      CartridgeGUID: _CartridgeGUID,
      CartridgeDescription: _CartridgeDescription,
      StartingLocationDescription: _StartingLocationDescription,
      Version: _Version,
      Author: _Author,
      Company: _Company,
      RecommendedDevice: _RecommendedDevice,
      LengthOfCompletionCode: _LengthOfCompletionCode,
      CompletionCode: _CompletionCode,
      ResultStatus: _Status,
      ResultsGWC: _ResultsGWC,
    )
  });
  return out;
}
