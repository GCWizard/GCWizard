import 'package:flutter/services.dart';

class GCWOnly01AndSpaceInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.length != newValue.text.replaceAll(RegExp(r'[^01 ]'), '').length) return oldValue;

    return newValue;
  }
}
