import 'package:flutter/services.dart';

class GCWOnlyHexDigitsAndSpaceInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    var newSanitized = newValue.text.replaceAll(RegExp(r'[\n\r\t]'), '');

    if (newSanitized.length != newSanitized.replaceAll(RegExp(r'[^A-Fa-ef0-9 ]'), '').length) return oldValue;

    return TextEditingValue(
      text: newSanitized, selection: TextSelection.fromPosition(
        TextPosition(offset: newSanitized.length),
      ),
    );
  }
}
