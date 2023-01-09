import 'package:gc_wizard/logic/tools/crypto_and_encodings/esoteric_programming_languages/chef_language/component.dart';
import 'package:gc_wizard/logic/tools/crypto_and_encodings/esoteric_programming_languages/chef_language/ingredient.dart';

class Container {
  List<Component> _contents;

  Container(Container container) {
    _contents = new List<Component>();
    if (container != null) _contents.addAll(container._contents);
  }

  void push(Component c) {
    if (c != null) _contents.add(c);
  }

  Component peek() {
    var c = _contents[_contents.length - 1];
    return c;
  }

  Component pop() {
    if (_contents.length != 0) {
      var c = _contents.removeAt(_contents.length - 1);
      return c;
    }
  }

  int size() {
    return _contents.length;
  }

  void combine(Container c) {
    if (c != null) if (c._contents != null) _contents.addAll(c._contents);
  }

  void liquefy() {
    _contents.forEach((c) {
      c.liquefy();
    });
  }

  void clean() {
    _contents = new List<Component>();
  }

  String serve() {
    String result = "";
    for (int i = _contents.length; i > 0; i--) {
      if (_contents[i - 1].getState() == State.Dry) {
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
