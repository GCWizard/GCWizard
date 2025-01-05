part of 'package:gc_wizard/tools/general_tools/gcwizardscript/logic/gcwizard_script.dart';

Object? _readFromFile(Object mode, Object index) {
  Object? result;
  if (_isNotAInt(mode) || _isNotAInt(index)) {
    _handleError(_INVALIDTYPECAST);
    return '';
  }
  int start = 0;
  if (index as int < 0) {
    start = _state.FILEINDEX;
  } else {
    start = index;
  }

  switch (mode as int) {
    case 0: // x byte String 0-terminated
      int byte = _state.FILE[start];
      String value = '';
      while (byte != 0 && start < _state.FILE.length - 1) {
        value = value + String.fromCharCode(byte);
        start++;
        byte = _state.FILE[start];
      }
      result = value;
      _state.FILEINDEX = start + 1;
      break;
    case 1: // 1 byte
      if (start < _state.FILE.length - 1) {
        result = _state.FILE[start];
        _state.FILEINDEX = start + 1;
      } else {
        _handleError(_RUNTIMEERROREOFEXCEEDED);
        return null;
      }
      break;
  }
  return result;
}

void _writeToFile(Object? value) {
  if (_isAList(value)) {
    _writeFileList(value as _GCWList);
  } else {
    _writeFileString(value.toString());
  }
  _state.fileSaved = false;
}

void _writeFileList(_GCWList value) {
  value.getContent().forEach((element) {
    if (_isAList(element)) {
      _writeFileList(element as _GCWList);
    } else {
      _writeFileString(element.toString());
    }
  });
}

void _writeFileString(String value) {
  value.split('').forEach((letter) {
    _state.FILE.add(letter.codeUnitAt(0));
  });
  _state.FILE.add(0);
}

int _eof() {
  if (_state.FILEINDEX < _state.FILE.length - 1) {
    return 0;
  }
  return 1;
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
          if (byte == 0) {
            dump.add(' ');
          } else {
            dump.add(_byteToString(byte));
          }
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
