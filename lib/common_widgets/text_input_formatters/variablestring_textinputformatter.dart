import 'package:flutter/services.dart';
import 'package:gc_wizard/utils/variable_string_expander.dart';

class VariableStringTextInputFormatter extends TextInputFormatter {
  RegExp _exp;

  VariableStringTextInputFormatter() {
    _exp = VARIABLESTRING;
  }

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (_exp.hasMatch(newValue.text.toLowerCase())) {
      return newValue;
    }

    return oldValue;
  }
}
