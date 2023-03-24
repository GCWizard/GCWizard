import 'package:flutter/services.dart';
import 'package:gc_wizard/common_widgets/text_input_formatters/gcw_double_textinputformatter.dart';

class GCWBearingTextInputFormatter extends GCWDoubleTextInputFormatter {
  GCWBearingTextInputFormatter();

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (['', '.', ',', '-'].contains(newValue.text)) return newValue;

    var _newDouble = double.tryParse(newValue.text.replaceFirst(',', '.'));
    if (_newDouble == null) return oldValue;

    return newValue;
  }
}
