import 'package:flutter/services.dart';

class GCWDoubleTextInputFormatter extends TextInputFormatter {
  RegExp _exp;

  final double min;
  final double max;
  final int numberDecimalDigits;

  int _maxIntegerLength;
  int _minIntegerLength;

  GCWDoubleTextInputFormatter({this.min, this.max, this.numberDecimalDigits}) {
    _maxIntegerLength = max == null ? null : max.abs().floor().toString().length;
    _minIntegerLength = min == null ? null : min.abs().floor().toString().length;

    var _decimalRegex = '\$';
    if (numberDecimalDigits == null || numberDecimalDigits > 0)
      _decimalRegex = '(\\.[0-9]' + (numberDecimalDigits == null ? '*' : '{0,$numberDecimalDigits}') + ')?\$';

    _exp = new RegExp(_buildIntegerRegex() + _decimalRegex);
  }

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    var value = newValue.text.replaceAll(',', '.');

    if (!_exp.hasMatch(value)) {
      return oldValue;
    }

    return _checkBounds(value) ? newValue : oldValue;
  }

  String _buildIntegerRegex() {
    var regex = '';

    if (min == null) {
      if (max == null)
        regex = '^\-?[0-9]*';
      else if (max < 0) {
        regex = '^(\-[0-9]{0,$_maxIntegerLength})?';
      } else if (max >= 0) {
        regex = '^((-[0-9]*)|([0-9]{0,$_maxIntegerLength}))';
      }
    } else if (min < 0) {
      if (max == null)
        regex = '^((\-[0-9]{0,$_minIntegerLength})|([0-9]*))';
      else if (max < 0) {
        regex = '^(\-[0-9]{0,$_minIntegerLength})?';
      } else if (max >= 0) {
        regex = '^((\-[0-9]{0,$_minIntegerLength})|([0-9]{0,$_maxIntegerLength}))';
      }
    } else if (min >= 0) {
      if (max == null)
        regex = '^[0-9]*';
      else if (max >= 0) {
        regex = '^[0-9]{0,$_maxIntegerLength}';
      }
    }

    return regex;
  }

  bool _checkBounds(String value) {
    var integerPart = value.split('.')[0];
    var numberCurrentDecimals = value.contains('.') ? value.split('.')[1].length : 0;

    if (integerPart.startsWith('-')) {
      if (min == null) return true;

      if (_minIntegerLength > integerPart.substring(1).length) return true;
    } else {
      if (max == null) return true;

      if (_maxIntegerLength > integerPart.length) return true;
    }

    var _newDouble = double.tryParse(value);
    if (_newDouble == null) return false;

    _truncateDigits(min, numberCurrentDecimals);

    if (min != null && _newDouble < _truncateDigits(min, numberCurrentDecimals)) return false;

    if (max != null && _newDouble > _truncateDigits(max, numberCurrentDecimals)) return false;

    return true;
  }

  _truncateDigits(double value, numberDigits) {
    return double.parse(value.toStringAsFixed(numberDecimalDigits));
  }
}
