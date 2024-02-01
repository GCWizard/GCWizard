part of 'package:gc_wizard/tools/crypto_and_encodings/esoteric_programming_languages/chef_language/logic/chef_language.dart';

class _Container {
  late List<_Component> _contents;

  _Container(_Container? container) {
    _contents = <_Component>[];
    if (container != null) _contents.addAll(container._contents);
  }

  void push(_Component? c) {
    if (c != null) _contents.add(c);
  }

  _Component peek() {
    var c = _contents[_contents.length - 1];
    return c;
  }

  _Component? pop() {
    if (_contents.isNotEmpty) {
      var c = _contents.removeAt(_contents.length - 1);
      return c;
    }
    return null;
  }

  int size() {
    return _contents.length;
  }

  void combine(_Container? c) {
    if (c != null) _contents.addAll(c._contents);
  }

  void liquefy() {
    for (var c in _contents) {
      c.liquefy();
    }
  }

  void clean() {
    _contents = [];
  }

  String serve() {
    String result = '';
    for (int i = _contents.length; i > 0; i--) {
      if (_contents[i - 1].getState() == _State.Dry) {
        result = result + _contents[i - 1].getValue().toString() + '';
      } else {
        // return charCodes
        result = result + String.fromCharCode(_contents[i - 1].getValue());
      }
    }
    return result;
  }

  List<String> getContent() {
    List<String> out = <String>[];
    for (int i = _contents.length - 1; i >= 0; i--) {
      out.add(_contents[i].getValue().toString());
    }
    return out;
  }

  List<String> getContentAsList() {
    List<String> out = <String>[];
    for (int i = 0; i < _contents.length; i++) {
      out.add(_contents[i].getValue().toString());
    }
    return out;
  }

  void shuffle() {
    _contents.shuffle();
  }

  void stir(int time) {
    for (int i = 0; i < time && i + 1 < _contents.length; i++) {
      var tmp = _contents[_contents.length - i - 1];
      _contents[_contents.length - i - 1] = _contents[_contents.length - i - 2];
      _contents[_contents.length - i - 2] = tmp;
    }
  }
}
