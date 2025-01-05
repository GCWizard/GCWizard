import 'package:flutter/services.dart';

class GCWIntegerTextInputFormatter extends TextInputFormatter {
  late RegExp _exp;

  final int? min;
  final int? max;

  GCWIntegerTextInputFormatter({this.min, this.max}) {
    _exp = RegExp(_buildRegex());
  }

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    var newSanitized = newValue.text.trim();
    if (!_exp.hasMatch(newSanitized)) {
      return oldValue;
    }

    if (_checkBounds(newSanitized)) {
      return TextEditingValue(
        text: newSanitized, selection: TextSelection.fromPosition(
          TextPosition(offset: newSanitized.length),
        ),
      );
    } else {
      return oldValue;
    }
  }

  String _buildRegex() {
    var regex = '';

    if (min == null) {
      if (max == null) {
        regex = '^-?\\d*\$';
      } else if (max! < 0) {
        regex = '^(-\\d{0,${max!.abs().toString().length}})?\$';
      } else if (max! >= 0) {
        regex = '^((-\\d*)|(\\d{0,${max.toString().length}}))\$';
      }
    } else if (min! < 0) {
      if (max == null) {
        regex = '^((-\\d{0,${min!.abs().toString().length}})|(\\d*))\$';
      } else if (max! < 0) {
        regex = '^(-\\d{0,${min!.abs().toString().length}})?\$';
      } else if (max! >= 0) {
        regex = '^((-\\d{0,${min!.abs().toString().length}})|(\\d{0,${max.toString().length}}))\$';
      }
    } else if (min! >= 0) {
      if (max == null) {
        regex = '^\\d*\$';
      } else if (max! >= 0) {
        regex = '^\\d{0,${max.toString().length}}\$';
      }
    }

    return regex;
  }

  bool _checkBounds(String value) {
    if (value.startsWith('-')) {
      if (min == null) return true;

      if (min!.abs().toString().length > value.substring(1).length) return true;
    } else {
      if (max == null) return true;

      if (max.toString().length > value.length) return true;
    }

    var _newInt = int.tryParse(value);
    if (_newInt == null) return false;

    if (min != null && _newInt < min!) return false;

    if (max != null && _newInt > max!) return false;

    return true;
  }
}
