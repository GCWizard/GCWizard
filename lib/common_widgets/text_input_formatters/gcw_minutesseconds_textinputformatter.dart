import 'package:flutter/services.dart';

class GCWMinutesSecondsTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    var newSanitized = newValue.text.trim();

    if (newSanitized.isEmpty) return newValue;

    var _newInt = int.tryParse(newSanitized);
    if (_newInt == null) return oldValue;

    if (_newInt >= 0 && _newInt < 60) {
      return TextEditingValue(
        text: newSanitized, selection: TextSelection.fromPosition(
          TextPosition(offset: newSanitized.length),
        ),
      );
    }

    return oldValue;
  }
}
