import 'package:flutter/services.dart';

class GCWOnlyHexDigitsAndSpaceInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.length != newValue.text.replaceAll(RegExp(r'[^A-Fa-ef0-9 ]'), '').length) return oldValue;

    return newValue;
  }
}
