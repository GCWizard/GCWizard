part of 'package:gc_wizard/tools/miscellaneous/gcwizardscript/logic/gcwizard_script.dart';

int _isNumber(Object? x) {
  if (_isANumber(x)) {
    return 1;
  } else {
    return 0;
  }
}

int _isInt(Object? x) {
  if (_isAInt(x)) {
    return 1;
  } else {
    return 0;
  }
}

int _isDouble(Object? x) {
  if (_isADouble(x)) {
    return 1;
  } else {
    return 0;
  }
}

int _isChar(Object? x) {
  if (_isAString(x) && (x as String).length == 1) {
    return 1;
  } else {
    return 0;
  }
}

int _isString(Object? x) {
  if (_isAString(x)) {
    return 1;
  } else {
    return 0;
  }
}

int _isList(Object? x) {
  if (_isAList(x)) {
    return 1;
  } else {
    return 0;
  }
}
