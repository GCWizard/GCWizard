import 'package:flutter/services.dart';
import 'package:gc_wizard/common_widgets/text_input_formatters/gcw_double_textinputformatter.dart';

class GCWBearingTextInputFormatter extends GCWDoubleTextInputFormatter {
  GCWBearingTextInputFormatter();

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    var newSanitized = newValue.text.trim();

    if (['', '.', ',', '-'].contains(newSanitized)) {
      return TextEditingValue(
          text: newSanitized, selection: newValue.selection, composing: newValue.composing
      );
    }

    var _newDouble = double.tryParse(newValue.text.replaceFirst(',', '.'));
    if (_newDouble == null) return oldValue;

    return TextEditingValue(
      text: newSanitized, selection: TextSelection.fromPosition(
        TextPosition(offset: newSanitized.length),
      ),
    );
  }
}
