import 'package:gc_wizard/logic/tools/crypto_and_encodings/esoteric_programming_languages/chef_language/chef_international.dart';

enum State { Dry, Liquid }

class Ingredient {
  String _name;
  int _amount;
  State _state;
  bool _error;
  List<String> _errorList;

  Ingredient(String ingredient) {
    _errorList = <String>[];

    //var tokens = ingredient.replaceAll('-', ' ').split(' ');
    var tokens = ingredient.trim().split(' ');
    int i = 0;
    _state = State.Dry;
    if (RegExp(r'^([0-9]+)[ a-z]*').hasMatch(tokens[i])) {
      _amount = int.parse(RegExp(r'^([0-9]+)[ a-zäöüß]*').firstMatch(tokens[i]).group(1));
      i++;
      if (i < tokens.length) {
        if (MeasureType.hasMatch(tokens[i])) {
          _state = State.Dry;
          i++;
        } else if (MeasureDry.hasMatch(tokens[i])) {
          _state = State.Dry;
          i++;
        } else if (MeasureLiquid.hasMatch(tokens[i])) {
          _state = State.Liquid;
          i++;
        } else if (MeasureElse.hasMatch(tokens[i])) {
          i++;
        }
      } else {
        _name = 'INVALID';
      }
    } else {
      // no amount
      _amount = 0;
      _state = State.Dry;
    }
    _name = '';
    while (i < tokens.length) {
      _name = _name + tokens[i] + (i == tokens.length - 1 ? '' : ' ');
      i++;
    }
    _name = _name
        .replaceAll('teaspoons', '')
        .replaceAll('teaspoon', '')
        .replaceAll('tablespoons', '')
        .replaceAll('tablespoon', '')
        .replaceAll('tassen', '')
        .replaceAll('tasse', '')
        .replaceAll('cups', '')
        .replaceAll('cup', '')
        .replaceAll('teelöffel', '')
        .replaceAll('esslöffel', '')
        .replaceAll('spritzer', '')
        .replaceAll('tropfen', '')
        .replaceAll('heaped', '')
        .replaceAll('level', '')
        .replaceAll('gestrichen', '')
        .replaceAll('gehäuft', '')
        .replaceAll('dashes', '')
        .replaceAll('dash', '')
        .replaceAll('drops', '')
        .replaceAll('drop', '')
        .replaceAll('pinches', '')
        .replaceAll('pinch', '')
        .replaceAll('prisen', '')
        .replaceAll('prise', '')
        .trim();
    if (_name == '') {
      _name = 'INVALID';
    }
  }

  int getAmount() {
    return _amount;
  }

  void setAmount(int n) {
    _amount = n;
  }

  State getState() {
    return _state;
  }

  void setState(State s) {
    _state = s;
  }

  void liquefy() {
    _state = State.Liquid;
  }

  void dry() {
    _state = State.Dry;
  }

  String getName() {
    return _name;
  }

  void setName(String n) {
    _name = n;
  }

  bool isValid() {
    return _error;
  }

  List<String> getError() {
    return _errorList;
  }
}
