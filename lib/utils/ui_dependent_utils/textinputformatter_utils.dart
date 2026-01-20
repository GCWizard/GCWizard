import 'package:flutter/services.dart';

TextEditingValue newValueEditingValue(TextEditingValue newValue, String sanitized) {
  if (sanitized == newValue.text) {
    return newValue;
  }

  return TextEditingValue(
    text: sanitized, selection: TextSelection.fromPosition(
      TextPosition(offset: sanitized.length),
    ),
  );
}

