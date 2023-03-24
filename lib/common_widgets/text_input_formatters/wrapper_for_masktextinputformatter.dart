import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

// Wrapper for external MaskTextInputFormatter
// (was buggy sometimes, so required work-arounds; still remains for potential future issues)
class WrapperForMaskTextInputFormatter extends TextInputFormatter {
  String? mask;
  Map<String, RegExp>? filter;

  late MaskTextInputFormatter _formatter;
  WrapperForMaskTextInputFormatter({this.mask, this.filter}) {
    _formatter = MaskTextInputFormatter(mask: mask, filter: filter);
  }

  String getMaskedText() {
    return _formatter.getMaskedText();
  }

  void clear() {
    _formatter.clear();
  }

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    return _formatter.formatEditUpdate(oldValue, newValue);
  }
}
