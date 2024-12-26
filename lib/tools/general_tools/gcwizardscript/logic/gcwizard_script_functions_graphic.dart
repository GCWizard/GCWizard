part of 'package:gc_wizard/tools/general_tools/gcwizardscript/logic/gcwizard_script.dart';

void _circle(Object x, Object y, Object r) {
  if (_isNotAInt(x) || _isNotAInt(y) || _isNotAInt(r)) {
    _handleError(_INVALIDTYPECAST);
    return;
  }
  _state.graphics.add('CIRCLE ' + (x as int).toString() + ' ' + (y as int).toString() + ' ' + (r as int).toString());
}

void _line(Object x1, Object y1, Object x2, Object y2) {
  if (_isNotAInt(x1) || _isNotAInt(x2) || _isNotAInt(x2) || _isNotAInt(y2)) {
    _handleError(_INVALIDTYPECAST);
    return;
  }
  _state.graphics.add('LINE ' +
      (x1 as int).toString() +
      ' ' +
      (y1 as int).toString() +
      ' ' +
      (x2 as int).toString() +
      ' ' +
      (y2 as int).toString());
}

void _dot(Object x, Object y) {
  if (_isNotAInt(x) || _isNotAInt(y)) {
    _handleError(_INVALIDTYPECAST);
    return;
  }
  _state.graphics.add('POINT ' + (x as int).toString() + ' ' + (y as int).toString());
}

void _arc(Object x, Object y, Object r, Object a1, Object a2) {
  if (_isNotAInt(x) || _isNotAInt(y) || _isNotAInt(r) || _isNotANumber(a1) || _isNotANumber(a2)) {
    _handleError(_INVALIDTYPECAST);
    return;
  }
  num A1;
  num A2;
  if (a1.runtimeType.toString() == 'int') {
    A1 = (a1 as int) * 1.0;
  } else {
    A1 = (a1 as double);
  }
  if (a2.runtimeType.toString() == 'int') {
    A2 = (a2 as int) * 1.0;
  } else {
    A2 = (a2 as double);
  }
  _state.graphics.add('ARC ' +
      (x as int).toString() +
      ' ' +
      (y as int).toString() +
      ' ' +
      (r as int).toString() +
      ' ' +
      A1.toString() +
      ' ' +
      A2.toString());
}

void _color(Object r, Object g, Object b) {
  if (_isNotAInt(r) || _isNotAInt(g) || _isNotAInt(b)) {
    _handleError(_INVALIDTYPECAST);
    return;
  }
  _state.graphics.add('COLOR ' + (r as int).toString() + ' ' + (g as int).toString() + ' ' + (b as int).toString());
}

void _fill(Object x) {
  if (_isNotAInt(x)) {
    _handleError(_INVALIDTYPECAST);
    return;
  }
  _state.graphics.add('FILL ' + (x as int).toString());
}

void _stroke(Object x) {
  if (_isNotAInt(x)) {
    _handleError(_INVALIDTYPECAST);
    return;
  }
  _state.graphics.add('STROKE ' + (x as num).toString());
}

void _antialias(Object x) {
  if (_isNotAInt(x)) {
    _handleError(_INVALIDTYPECAST);
    return;
  }
  _state.graphics.add('ANTIALIAS ' + (x as num).toString());
}

void _box(Object x1, Object y1, Object x2, Object y2) {
  if (_isNotAInt(x1) || _isNotAInt(y1) || _isNotAInt(x2) || _isNotAInt(y2)) {
    _handleError(_INVALIDTYPECAST);
    return;
  }
  _state.graphics.add('BOX ' +
      (x1 as int).toString() +
      ' ' +
      (y1 as int).toString() +
      ' ' +
      (x2 as int).toString() +
      ' ' +
      (y2 as int).toString());
}

void _text(Object t, Object x, Object y, Object s) {
  if (_isNotAInt(x) || _isNotAInt(y) || _isNotAInt(s)) {
    _handleError(_INVALIDTYPECAST);
    return;
  }
  t = (t as String).replaceAll(' ', '⟳');
  _state.graphics
      .add('TEXT ' + t + ' ' + (x as int).toString() + ' ' + (y as int).toString() + ' ' + (s as int).toString());
}

void _oval(Object x1, Object y1, Object x2, Object y2) {
  if (_isNotAInt(x1) || _isNotAInt(y1) || _isNotAInt(x2) || _isNotAInt(y2)) {
    _handleError(_INVALIDTYPECAST);
    return;
  }
  _state.graphics.add('OVAL ' +
      (x1 as int).toString() +
      ' ' +
      (y1 as int).toString() +
      ' ' +
      (x2 as int).toString() +
      ' ' +
      (y2 as int).toString());
}
