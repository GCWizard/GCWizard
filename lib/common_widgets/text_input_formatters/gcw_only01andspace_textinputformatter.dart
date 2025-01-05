import 'package:flutter/services.dart';

class GCWOnly01AndSpaceInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    var newSanitized = newValue.text.replaceAll(RegExp(r'[\n\r\t]'), '');

    if (newSanitized.length != newSanitized.replaceAll(RegExp(r'[^01 ]'), '').length) return oldValue;

    return TextEditingValue(
      text: newSanitized, selection: TextSelection.fromPosition(
        TextPosition(offset: newSanitized.length),
      ),
    );
  }
}
