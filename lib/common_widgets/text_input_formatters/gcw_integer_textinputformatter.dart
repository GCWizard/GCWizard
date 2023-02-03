import 'package:flutter/services.dart';

class GCWIntegerTextInputFormatter extends TextInputFormatter {
  RegExp _exp;

  final int min;
  final int max;

  GCWIntegerTextInputFormatter({this.min, this.max}) {
    _exp = new RegExp(_buildRegex());
  }

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (!_exp.hasMatch(newValue.text)) {
      return oldValue;
    }

    return _checkBounds(newValue.text) ? newValue : oldValue;
  }

  String _buildRegex() {
    var regex = '';

    if (min == null) {
      if (max == null)
        regex = '^\-?[0-9]*\$';
      else if (max < 0) {
        regex = '^(\-[0-9]{0,${max.abs().toString().length}})?\$';
      } else if (max >= 0) {
        regex = '^((-[0-9]*)|([0-9]{0,${max.toString().length}}))\$';
      }
    } else if (min < 0) {
      if (max == null)
        regex = '^((\-[0-9]{0,${min.abs().toString().length}})|([0-9]*))\$';
      else if (max < 0) {
        regex = '^(\-[0-9]{0,${min.abs().toString().length}})?\$';
      } else if (max >= 0) {
        regex = '^((\-[0-9]{0,${min.abs().toString().length}})|([0-9]{0,${max.toString().length}}))\$';
      }
    } else if (min >= 0) {
      if (max == null)
        regex = '^[0-9]*\$';
      else if (max >= 0) {
        regex = '^[0-9]{0,${max.toString().length}}\$';
      }
    }

    return regex;
  }

  bool _checkBounds(String value) {
    if (value.startsWith('-')) {
      if (min == null) return true;

      if (min.abs().toString().length > value.substring(1).length) return true;
    } else {
      if (max == null) return true;

      if (max.toString().length > value.length) return true;
    }

    var _newInt = int.tryParse(value);
    if (_newInt == null) return false;

    if (min != null && _newInt < min) return false;

    if (max != null && _newInt > max) return false;

    return true;
  }
}
