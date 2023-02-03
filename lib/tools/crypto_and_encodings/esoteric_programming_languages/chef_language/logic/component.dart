part of 'package:gc_wizard/tools/crypto_and_encodings/esoteric_programming_languages/chef_language/logic/chef_language.dart';

class _Component {
  _State _state;
  int _value;
  String _name;

  _Component(int n, _State s, String name) {
    _value = n;
    _state = s;
    _name = name;
  }

  _Component.Contructor1(_Ingredient ingredient) {
    _value = ingredient.getAmount();
    _state = ingredient.getState();
    _name = ingredient.getName();
  }

  int getValue() {
    return _value;
  }

  void setValue(int n) {
    _value = n;
  }

  _State getState() {
    return _state;
  }

  void setState(_State s) {
    _state = s;
  }

  String getName() {
    return _name;
  }

  void setName(String n) {
    _name = n;
  }

  //@Override
  _Component clone() {
    return _Component(_value, _state, _name);
  }

  void liquefy() {
    _state = _State.Liquid;
  }
}
