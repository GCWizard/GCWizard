import 'package:flutter/services.dart';
import 'package:gc_wizard/utils/variable_string_expander.dart';

class VariableStringTextInputFormatter extends TextInputFormatter {
  late RegExp _exp;

  VariableStringTextInputFormatter() {
    _exp = VARIABLESTRING;
  }

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    var newSanitized = newValue.text.trim();

    if (_exp.hasMatch(newSanitized.toLowerCase())) {
      return TextEditingValue(
        text: newSanitized, selection: TextSelection.fromPosition(
          TextPosition(offset: newSanitized.length),
        ),
      );
    }

    return oldValue;
  }
}
