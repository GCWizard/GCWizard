part of 'package:gc_wizard/tools/general_tools/gcwizardscript/logic/gcwizard_script.dart';

String _char(Object x) {
  if (_isAString(x)) {
    _handleError(_INVALIDTYPECAST);
    return '';
  }
  return String.fromCharCode(x as int);
}

int _asc(Object x) {
  if (_isNotAString(x)) {
    _handleError(_INVALIDTYPECAST);
    return -1;
  }
  return (x as String).codeUnitAt(0);
}

String _left(Object x, Object count) {
  if (_isNotAString(x) || _isNotAInt(count)) {
    _handleError(_INVALIDTYPECAST);
    return '';
  } else {
    return (x as String).substring(0, (count as int));
  }
}

String _right(Object x, Object count) {
  if (_isNotAString(x) || _isNotAInt(count)) {
    _handleError(_INVALIDTYPECAST);
    return '';
  } else {
    return (x as String).substring(x.length - (count as int));
  }
}

String _mid(Object x, Object start, Object len) {
  if (_isNotAString(x) || _isNotAInt(start) || _isNotAInt(len)) {
    _handleError(_INVALIDTYPECAST);
    return '';
  } else {
    return (x as String).substring((start as int) - 1, start - 1 + (len as int));
  }
}

int _len(Object x) {
  if (_isNotAString(x)) {
    _handleError(_INVALIDTYPECAST);
    return 0;
  }
  return x.toString().length;
}

String _str(Object x) {
  if (_isNotANumber(x)) {
    _handleError(_INVALIDTYPECAST);
    return '';
  }
  if ((x as num).floor() == x) return x.toStringAsFixed(0);

  return x.toStringAsFixed(3);
}

Object _val(Object x) {
  if (_isAList(x)) {
    _handleError(_INVALIDTYPECAST);
    return '';
  } else if (_isANumber(x)) {
    return x;
  } else if (int.tryParse(x as String) != null) {
    return int.parse(x).toDouble();
  } else {
    if (double.tryParse(x) != null) {
      return double.parse(x);
    }
  }

  _handleError(_INVALIDTYPECAST);
  return 0.0;
}

String _subst(Object text, Object x, Object y, Object caseSensitive) {
  if (_isNotAString(text) || _isNotAString(x) || _isNotAString(y) || _isNotAInt(caseSensitive)) {
    _handleError(_INVALIDTYPECAST);
    return '';
  }
  Map<String, String> substitutions = {};
  substitutions[x as String] = y as String;
  return substitution(text as String, substitutions, caseSensitive: ((caseSensitive as int) == 1));
}

String _padleft(Object text, Object char, Object width,){
  if (_isNotAString(text) || _isNotAString(char) || _isNotAInt(width)) {
    _handleError(_INVALIDTYPECAST);
    return '';
  }
  String result = (text as String).padLeft(width as int, char as String);
  return result;
}

String _padright(Object text, Object char, Object width,){
  if (_isNotAString(text) || _isNotAString(char) || _isNotAInt(width)) {
    _handleError(_INVALIDTYPECAST);
    return '';
  }
  return (text as String).padRight(width as int, char as String);
}

String _padcenter(Object text, Object char, Object width,){
  if (_isNotAString(text) || _isNotAString(char) || _isNotAInt(width)) {
    _handleError(_INVALIDTYPECAST);
    return '';
  }

  int charToAdd = ((width as int) - (text as String).length) ~/ 2;
  text = text.padLeft(text.length + charToAdd, char as String);
  text = text.padRight(text.length + charToAdd, char);

  if (text.length < width) {
    return char + text;
  } else {
    return text;
  }
}
