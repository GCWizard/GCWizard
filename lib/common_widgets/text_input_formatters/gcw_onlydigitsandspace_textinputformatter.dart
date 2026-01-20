import 'package:flutter/services.dart';
import 'package:gc_wizard/utils/ui_dependent_utils/textinputformatter_utils.dart';

class GCWOnlyDigitsAndSpaceInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    var newSanitized = newValue.text.replaceAll(RegExp(r'[\n\r\t]'), '');

    if (newSanitized.length != newSanitized.replaceAll(RegExp(r'[^0-9 ]'), '').length) return oldValue;

    return newValueEditingValue(newValue, newSanitized);
  }
}
