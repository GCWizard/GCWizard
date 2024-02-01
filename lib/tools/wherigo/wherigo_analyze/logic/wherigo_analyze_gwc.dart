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

part of 'package:gc_wizard/tools/wherigo/wherigo_analyze/logic/wherigo_analyze.dart';

List<String> _GWCResultsGWC = [];
WHERIGO_ANALYSE_RESULT_STATUS _GWCStatus = WHERIGO_ANALYSE_RESULT_STATUS.OK;
WHERIGO_FILE_LOAD_STATE _checksToDo = WHERIGO_FILE_LOAD_STATE.NULL;
String _GWCSignature = '';
int _GWCNumberOfObjects = 0;
List<WherigoMediaFileHeader> _GWCMediaFilesHeaders = [];
List<WherigoMediaFileContent> _GWCMediaFilesContents = [];
int _GWCMediaFileID = 0;
int _GWCAddress = 0;
int _GWCHeaderLength = 0;
double _GWCLatitude = 0.0;
double _GWCLongitude = 0.0;
double _GWCAltitude = 0.0;
int _GWCSplashscreen = 0;
int _GWCSplashscreenIcon = 0;
int _GWCDateOfCreation = 0;
String _GWCTypeOfCartridge = '';
String _GWCPlayer = '';
int _GWCPlayerID = 0;
String _GWCCartridgeLUAName = '';
String _GWCCartridgeGUID = '';
String _GWCCartridgeDescription = '';
String _GWCStartingLocationDescription = '';
String _GWCVersion = '';
String _GWCAuthor = '';
String _GWCCompany = '';
String _GWCRecommendedDevice = '';
int _GWCLengthOfCompletionCode = 0;
String _GWCCompletionCode = '';
int _GWCoffset = 0;
WherigoStringOffset _GWCASCIIZ = WherigoStringOffset('', 0);
int _GWCMediaFileLength = 0;
int _GWCValidMediaFile = 0;
int _GWCMediaFileType = 0;

Future<WherigoCartridge> getCartridgeGWC(Uint8List byteListGWC, bool offline, {SendPort? sendAsyncPort}) async {
  if (byteListGWC.isNotEmpty) _checksToDo = WHERIGO_FILE_LOAD_STATE.GWC;

  if (_checksToDo == WHERIGO_FILE_LOAD_STATE.NULL) {
    _GWCResultsGWC.add('wherigo_error_runtime');
    _GWCResultsGWC.add('wherigo_error_empty_gwc');

    return WherigoCartridge(cartridgeGWC: _WHERIGO_EMPTYCARTRIDGE_GWC, cartridgeLUA: WHERIGO_EMPTYCARTRIDGE_LUA);
  }

  if (_checksToDo == WHERIGO_FILE_LOAD_STATE.GWC) {
    if (isInvalidCartridge(byteListGWC)) {
      _GWCResultsGWC.add('wherigo_error_runtime');
      _GWCResultsGWC.add('wherigo_error_invalid_gwc');
      _GWCStatus = WHERIGO_ANALYSE_RESULT_STATUS.ERROR_GWC;
    } else {
      // analyse GWC-File
      _getHeaderFromGWC(byteListGWC);
      _getLUAByteCodeFromGWC(byteListGWC);
      _getMediaFilesFromGWC(byteListGWC);
    }
  } // if checks to do GWC

  return WherigoCartridge(
      cartridgeGWC: WherigoCartridgeGWC(
        Signature: _GWCSignature,
        NumberOfObjects: _GWCNumberOfObjects,
        MediaFilesHeaders: _GWCMediaFilesHeaders,
        MediaFilesContents: _GWCMediaFilesContents,
        HeaderLength: _GWCHeaderLength,
        Latitude: _GWCLatitude,
        Longitude: _GWCLongitude,
        Altitude: _GWCAltitude,
        Splashscreen: _GWCSplashscreen,
        SplashscreenIcon: _GWCSplashscreenIcon,
        DateOfCreation: _GWCDateOfCreation,
        TypeOfCartridge: _GWCTypeOfCartridge,
        Player: _GWCPlayer,
        PlayerID: _GWCPlayerID,
        CartridgeLUAName: _GWCCartridgeLUAName,
        CartridgeGUID: _GWCCartridgeGUID,
        CartridgeDescription: _GWCCartridgeDescription,
        StartingLocationDescription: _GWCStartingLocationDescription,
        Version: _GWCVersion,
        Author: _GWCAuthor,
        Company: _GWCCompany,
        RecommendedDevice: _GWCRecommendedDevice,
        LengthOfCompletionCode: _GWCLengthOfCompletionCode,
        CompletionCode: _GWCCompletionCode,
        ResultStatus: _GWCStatus,
        ResultsGWC: _GWCResultsGWC,
      ),
      cartridgeLUA: WHERIGO_EMPTYCARTRIDGE_LUA);
}

void _getHeaderFromGWC(Uint8List byteListGWC) {
  try {
    // get Header
    _getSignatureFromGWC(byteListGWC);
    _GWCNumberOfObjects = readUShort(byteListGWC, START_NUMBEROFOBJECTS);
    _GWCoffset = START_OBJCETADRESS; // File Header LUA File

    _getMediaFileAddressesFromGWC(byteListGWC);

    START_HEADER = START_OBJCETADRESS + _GWCNumberOfObjects * 6;
    _getHeaderDetailsFromGWC(byteListGWC);

    // sendAsyncPort?.send(DoubleText(PROGRESS, 5));
  } catch (exception) {
    _GWCStatus = WHERIGO_ANALYSE_RESULT_STATUS.ERROR_GWC;
    _GWCResultsGWC.add('wherigo_error_runtime');
    _GWCResultsGWC.add('wherigo_error_runtime_exception');
    _GWCResultsGWC.add('wherigo_error_gwc_header');
    _GWCResultsGWC.add(exception.toString());
  }
}

void _getHeaderDetailsFromGWC(Uint8List byteListGWC) {
  _GWCoffset = START_HEADER;

  _GWCHeaderLength = readLong(byteListGWC, _GWCoffset);
  _GWCoffset = _GWCoffset + LENGTH_LONG;
  START_FILES = START_HEADER + _GWCHeaderLength;

  _GWCLatitude = readDouble(byteListGWC, _GWCoffset);
  if (_GWCLatitude < -90.0 || _GWCLatitude > 90.0) _GWCLatitude = 0.0;
  _GWCoffset = _GWCoffset + LENGTH_DOUBLE;
  _GWCLongitude = readDouble(byteListGWC, _GWCoffset);
  if (_GWCLongitude < -180.0 || _GWCLongitude > 180.0) _GWCLongitude = 0.0;
  _GWCoffset = _GWCoffset + LENGTH_DOUBLE;
  _GWCAltitude = readDouble(byteListGWC, _GWCoffset);
  _GWCoffset = _GWCoffset + LENGTH_DOUBLE;

  _GWCDateOfCreation = readLong(byteListGWC, _GWCoffset);
  _GWCoffset = _GWCoffset + LENGTH_LONG;

  // no idea what the meaning of this long is
  readLong(byteListGWC, _GWCoffset);

  _GWCoffset = _GWCoffset + LENGTH_LONG;
  _GWCSplashscreen = readShort(byteListGWC, _GWCoffset);
  _GWCoffset = _GWCoffset + LENGTH_SHORT;

  _GWCSplashscreenIcon = readShort(byteListGWC, _GWCoffset);
  _GWCoffset = _GWCoffset + LENGTH_SHORT;

  _GWCASCIIZ = readString(byteListGWC, _GWCoffset);
  _GWCTypeOfCartridge = _GWCASCIIZ.ASCIIZ;
  _GWCoffset = _GWCASCIIZ.offset;

  _GWCASCIIZ = readString(byteListGWC, _GWCoffset);
  _GWCPlayer = _GWCASCIIZ.ASCIIZ;
  _GWCoffset = _GWCASCIIZ.offset;

  _GWCPlayerID = readLong(byteListGWC, _GWCoffset);
  _GWCoffset = _GWCoffset + LENGTH_LONG;

  _GWCPlayerID = readLong(byteListGWC, _GWCoffset);
  _GWCoffset = _GWCoffset + LENGTH_LONG;

  _GWCASCIIZ = readString(byteListGWC, _GWCoffset);
  _GWCCartridgeLUAName = _GWCASCIIZ.ASCIIZ;
  _GWCoffset = _GWCASCIIZ.offset;

  _GWCASCIIZ = readString(byteListGWC, _GWCoffset);
  _GWCCartridgeGUID = _GWCASCIIZ.ASCIIZ;
  _GWCoffset = _GWCASCIIZ.offset;

  _GWCASCIIZ = readString(byteListGWC, _GWCoffset);
  _GWCCartridgeDescription = _GWCASCIIZ.ASCIIZ.replaceAll('<BR>', '\n');
  _GWCoffset = _GWCASCIIZ.offset;

  _GWCASCIIZ = readString(byteListGWC, _GWCoffset);
  _GWCStartingLocationDescription = _GWCASCIIZ.ASCIIZ.replaceAll('<BR>', '\n');
  _GWCoffset = _GWCASCIIZ.offset;

  _GWCASCIIZ = readString(byteListGWC, _GWCoffset);
  _GWCVersion = _GWCASCIIZ.ASCIIZ;
  _GWCoffset = _GWCASCIIZ.offset;

  _GWCASCIIZ = readString(byteListGWC, _GWCoffset);
  _GWCAuthor = _GWCASCIIZ.ASCIIZ;
  _GWCoffset = _GWCASCIIZ.offset;

  _GWCASCIIZ = readString(byteListGWC, _GWCoffset);
  _GWCCompany = _GWCASCIIZ.ASCIIZ;
  _GWCoffset = _GWCASCIIZ.offset;

  _GWCASCIIZ = readString(byteListGWC, _GWCoffset);
  _GWCRecommendedDevice = _GWCASCIIZ.ASCIIZ;
  _GWCoffset = _GWCASCIIZ.offset;

  _GWCLengthOfCompletionCode = readInt(byteListGWC, _GWCoffset);
  _GWCoffset = _GWCoffset + LENGTH_INT;

  _GWCASCIIZ = readString(byteListGWC, _GWCoffset);
  _GWCCompletionCode = _GWCASCIIZ.ASCIIZ;
  _GWCoffset = _GWCASCIIZ.offset;
}

void _getMediaFileAddressesFromGWC(Uint8List byteListGWC) {
  for (int i = 0; i < _GWCNumberOfObjects; i++) {
    _GWCMediaFileID = readUShort(byteListGWC, _GWCoffset);
    _GWCoffset = _GWCoffset + LENGTH_USHORT;
    _GWCAddress = readInt(byteListGWC, _GWCoffset);
    _GWCoffset = _GWCoffset + LENGTH_INT;
    _GWCMediaFilesHeaders.add(WherigoMediaFileHeader(_GWCMediaFileID, _GWCAddress));
  }
}

void _getSignatureFromGWC(Uint8List byteListGWC) {
  _GWCSignature = _GWCSignature + byteListGWC[0].toString();
  _GWCSignature = _GWCSignature + byteListGWC[1].toString();
  _GWCSignature = _GWCSignature + String.fromCharCode(byteListGWC[2]);
  _GWCSignature = _GWCSignature + String.fromCharCode(byteListGWC[3]);
  _GWCSignature = _GWCSignature + String.fromCharCode(byteListGWC[4]);
  _GWCSignature = _GWCSignature + String.fromCharCode(byteListGWC[5]);
}

void _getMediaFilesFromGWC(Uint8List byteListGWC) {
  try {
    // analysing GWC - reading Media-Files
    for (int i = 1; i < _GWCMediaFilesHeaders.length; i++) {
      _GWCoffset = _GWCMediaFilesHeaders[i].MediaFileAddress;
      _GWCValidMediaFile = readByte(byteListGWC, _GWCoffset);
      if (_GWCValidMediaFile != 0) {
        // read Filetype
        _GWCoffset = _GWCoffset + LENGTH_BYTE;
        _GWCMediaFileType = readInt(byteListGWC, _GWCoffset);

        // read Length
        _GWCoffset = _GWCoffset + LENGTH_INT;
        _GWCMediaFileLength = readInt(byteListGWC, _GWCoffset);

        // read bytes
        _GWCoffset = _GWCoffset + LENGTH_INT;
        _GWCMediaFilesContents.add(WherigoMediaFileContent(_GWCMediaFilesHeaders[i].MediaFileID, _GWCMediaFileType,
            Uint8List.sublistView(byteListGWC, _GWCoffset, _GWCoffset + _GWCMediaFileLength), _GWCMediaFileLength));
      } else {
        // despite the medioObject exists in the LUA Sourcecode, the file is not part of the cartridge
        _GWCMediaFilesContents.add(WherigoMediaFileContent(
            _GWCMediaFilesHeaders[i].MediaFileID, _WHERIGO_MEDIATYPE_UNK, Uint8List.fromList([]), 0));
      }
    }
  } catch (exception) {
    _GWCStatus = WHERIGO_ANALYSE_RESULT_STATUS.ERROR_GWC;
    _GWCResultsGWC.add('wherigo_error_runtime');
    _GWCResultsGWC.add('wherigo_error_runtime_exception');
    _GWCResultsGWC.add('wherigo_error_invalid_gwc');
    _GWCResultsGWC.add('wherigo_error_gwc_luabytecode');
    _GWCResultsGWC.add('wherigo_error_gwc_mediafiles');
    _GWCResultsGWC.add(exception.toString());
  }
}

void _getLUAByteCodeFromGWC(Uint8List byteListGWC) {
  try {
    // analysing GWC - LUA Byte-Code
    // read LUA Byte-Code Object(this.ObjectID, this.Address, this.Type, this.Bytes);
    _GWCMediaFileLength = readInt(byteListGWC, _GWCoffset);
    _GWCoffset = _GWCoffset + LENGTH_INT;
    _GWCMediaFilesContents.add(WherigoMediaFileContent(
        0, 0, Uint8List.sublistView(byteListGWC, _GWCoffset, _GWCoffset + _GWCMediaFileLength), _GWCMediaFileLength));
    _GWCoffset = _GWCoffset + _GWCMediaFileLength;

    //sendAsyncPort?.send(DoubleText(PROGRESS, 7));
  } catch (exception) {
    _GWCStatus = WHERIGO_ANALYSE_RESULT_STATUS.ERROR_GWC;
    _GWCResultsGWC.add('wherigo_error_runtime');
    _GWCResultsGWC.add('wherigo_error_runtime_exception');
    _GWCResultsGWC.add('wherigo_error_gwc_luabytecode');
    _GWCResultsGWC.add(exception.toString());
  }
}
