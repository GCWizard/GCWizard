part of 'package:gc_wizard/tools/crypto_and_encodings/esoteric_programming_languages/chef_language/logic/chef_language.dart';

enum _State { Dry, Liquid }

class _Ingredient {
  String? _name;
  int? _amount;
  _State? _state;
  final bool _error = false;
  final _errorList = <String>[];

  _Ingredient(String ingredient) {
    //var tokens = ingredient.replaceAll('-', ' ').split(' ');
    var tokens = ingredient.trim().split(' ');
    int i = 0;
    _state = _State.Dry;
    if (RegExp(r'^(\d+)[ a-z]*').hasMatch(tokens[i])) {
      _amount = int.parse(RegExp(r'^(\d+)[ a-zäöüß]*').firstMatch(tokens[i])!.group(1)!);
      i++;
      if (i < tokens.length) {
        if (_CHEF_MeasureType.hasMatch(tokens[i])) {
          _state = _State.Dry;
          i++;
        } else if (_CHEF_MeasureDry.hasMatch(tokens[i])) {
          _state = _State.Dry;
          i++;
        } else if (_CHEF_MeasureLiquid.hasMatch(tokens[i])) {
          _state = _State.Liquid;
          i++;
        } else if (_CHEF_MeasureElse.hasMatch(tokens[i])) {
          i++;
        }
      } else {
        _name = 'INVALID';
      }
    } else {
      // no amount
      _amount = 0;
      _state = _State.Dry;
    }
    _name = '';
    while (i < tokens.length) {
      _name = _name! + tokens[i] + (i == tokens.length - 1 ? '' : ' ');
      i++;
    }
    _name = _name!
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
    if (_name!.isEmpty) {
      _name = 'INVALID';
    }
  }

  int? getAmount() {
    return _amount;
  }

  void setAmount(int? n) {
    if (n == null) throw const FormatException('setAmount');
    _amount = n;
  }

  _State? getState() {
    return _state;
  }

  void setState(_State s) {
    _state = s;
  }

  void liquefy() {
    _state = _State.Liquid;
  }

  void dry() {
    _state = _State.Dry;
  }

  String? getName() {
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
