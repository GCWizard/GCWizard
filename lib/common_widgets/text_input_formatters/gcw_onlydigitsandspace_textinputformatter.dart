import 'package:flutter/services.dart';

class GCWOnlyDigitsAndSpaceInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.length != newValue.text.replaceAll(RegExp(r'[^0-9 ]'), '').length) return oldValue;

    return newValue;
  }
}
