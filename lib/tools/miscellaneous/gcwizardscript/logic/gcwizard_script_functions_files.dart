part of 'package:gc_wizard/tools/miscellaneous/gcwizardscript/logic/gcwizard_script.dart';

Object? _readFromFile(Object mode, Object index) {
  Object? result;
  if (_isNotAInt(mode) || _isNotAInt(index)) {
    _handleError(_INVALIDTYPECAST);
    return '';
  }
  int start = _state.FILEINDEX;
  if (index as int == -1) start = index;

  switch (mode as int) {
    case -1: // 8 byte double
      result = _readDouble(_state.FILE, start);
      break;
    case 0: // x byte String 0-terminated
      int byte = _state.FILE[start];
      String value = '';
      while (result != 0 && start < _state.FILE.length - 1) {
        value = value + String.fromCharCode(byte);
        start++;
        byte = _state.FILE[start];
      }
      result = value;
      _state.FILEINDEX = start;
      break;
    case 1: // 1 byte
      if (start < _state.FILE.length - 1) {
        result = _state.FILE[start];
        if (index != -1) {
          _state.FILEINDEX = _state.FILEINDEX + 1;
        }
      } else {
        _handleError(_RUNTIMEERROREOFEXCEEDED);
        return null;
      }
      break;
    case 2: // 2 byte int
      if (start < _state.FILE.length - 2) {
        result = _readInt16(_state.FILE, start);
        result = _state.FILE[_state.FILEINDEX];
        if (index != -1) {
          _state.FILEINDEX = _state.FILEINDEX + 2;
        }
      } else {
        _handleError(_RUNTIMEERROREOFEXCEEDED);
        return null;
      }
      break;
    case 4: // 4 byte int
      if (start < _state.FILE.length - 4) {
        result = _readInt32(_state.FILE, start);
        if (index != -1) {
          _state.FILEINDEX = _state.FILEINDEX + 4;
        }
      } else {
        _handleError(_RUNTIMEERROREOFEXCEEDED);
        return null;
      }
      break;
    case 8: // 8 byte int
      if (start < _state.FILE.length - 8) {
        result = _readInt64(_state.FILE, start);
        result = _state.FILE[_state.FILEINDEX];
        if (index != -1) {
          _state.FILEINDEX = _state.FILEINDEX + 8;
        }
      } else {
        _handleError(_RUNTIMEERROREOFEXCEEDED);
        return null;
      }
      break;
  }
  return result;
}

double _readDouble(List<int> byteList, int offset) {
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

int _readInt64(List<int> byteList, int offset) {
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
  return ByteData.sublistView(bytes).getInt64(0);
}

int _readInt32(List<int> byteList, int offset) {
  // 8 Byte
  Uint8List bytes = Uint8List(8);
  bytes[7] = byteList[offset];
  bytes[6] = byteList[offset + 1];
  bytes[5] = byteList[offset + 2];
  bytes[4] = byteList[offset + 3];
  return ByteData.sublistView(bytes).getInt32(0);
}

int _readInt16(List<int> byteList, int offset) {
  // 8 Byte
  Uint8List bytes = Uint8List(8);
  bytes[7] = byteList[offset];
  bytes[6] = byteList[offset + 1];
  return ByteData.sublistView(bytes).getInt16(0);
}

void _writeToFile(Object? value) {
  if (_isAList(value)) {
    _writeFileList(value as _GCWList);
  } else if (_isAString(value)) {
    _writeFileString(value as String);
  } else if (_isAInt(value)) {
    _writeFileInt(value as int);
  } else {
    _writeFileDouble(value as double);
  }
  _state.fileSaved = false;
}

void _writeFileList(_GCWList value) {
  value.getContent().forEach((element) {
    if (_isAList(element)) {
      _writeFileList(element as _GCWList);
    } else if (_isAString(element)) {
      _writeFileString(element as String);
    } else if (_isAInt(element)) {
      _writeFileInt(element as int);
    } else {
      _writeFileDouble(element as double);
    }
  });
}

void _writeFileString(String value) {
  value.split('').forEach((letter) {
    _state.FILE.add(letter.codeUnitAt(0));
  });
  _state.FILE.add(0);
}

void _writeFileInt(int value) {
  ByteData bytes = ByteData(8);
  bytes.setInt64(0, value);
  bytes.buffer.asInt8List().toList().forEach((byte) {
    _state.FILE.add(byte);
  });
}

void _writeFileDouble(double value) {
  ByteData bytes = ByteData(8);
  bytes.setFloat64(0, value);

  bytes.buffer.asInt8List().toList().forEach((byte) {
    _state.FILE.add(byte);
  });
}

bool _eof() {
  return _state.FILEINDEX < _state.FILE.length;
}

String _dumpFile(Object? mode) {
  String _byteToString(int byte) {
    return String.fromCharCode(byte);
  }

  String _byteToHex(int byte) {
    return convertBase(byte.toString(), 10, 16);
  }

  String result = '';
  if (_isNotAInt(mode)) {
    _handleError(_INVALIDTYPECAST);
  } else {
    List<String> dump = [];
    switch (mode as int) {
      case 0: // integer
        for (int byte in _state.FILE) {
          dump.add(byte.toString().padLeft(3, ' '));
        }
        result = dump.join(' ');
        break;
      case 2: // string
        for (int byte in _state.FILE) {
          dump.add(_byteToString(byte));
        }
        result = dump.join('');
        break;
      default: // hex
        for (int byte in _state.FILE) {
          dump.add(_byteToHex(byte));
        }
        result = dump.join(' ');
    }
  }
  return result;
}
