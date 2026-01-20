import 'package:flutter/services.dart';
import 'package:gc_wizard/utils/ui_dependent_utils/textinputformatter_utils.dart';

class GCWMinutesSecondsTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    var newSanitized = newValue.text.trim();

    if (newSanitized.isEmpty) return newValue;

    var _newInt = int.tryParse(newSanitized);
    if (_newInt == null) return oldValue;

    if (_newInt >= 0 && _newInt < 60) {
      return newValueEditingValue(newValue, newSanitized);
    }

    return oldValue;
  }
}
