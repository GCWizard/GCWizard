import 'package:flutter/services.dart';

class GCWDoubleTextInputFormatter extends TextInputFormatter {
  late RegExp _exp;

  final double? min;
  final double? max;
  final int? numberDecimalDigits;

  late int? _maxIntegerLength;
  late int? _minIntegerLength;

  GCWDoubleTextInputFormatter({this.min, this.max, this.numberDecimalDigits}) {
    _maxIntegerLength = max?.abs().floor().toString().length;
    _minIntegerLength = min?.abs().floor().toString().length;

    var _decimalRegex = '\$';
    if (numberDecimalDigits == null || numberDecimalDigits! > 0) {
      _decimalRegex = '(\\.\\d' + (numberDecimalDigits == null ? '*' : '{0,$numberDecimalDigits}') + ')?\$';
    }

    _exp = RegExp(_buildIntegerRegex() + _decimalRegex);
  }

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    var newSanitized = newValue.text.trim();
    if (!_exp.hasMatch(newSanitized.replaceAll(',', '.'))) {
      return oldValue;
    }

    if (_checkBounds(newSanitized.replaceAll(',', '.'))) {
      return TextEditingValue(
        text: newSanitized, selection: TextSelection.fromPosition(
          TextPosition(offset: newSanitized.length),
        ),
      );
    } else {
      return oldValue;
    }
  }

  String _buildIntegerRegex() {
    var regex = '';

    if (min == null) {
      if (max == null) {
        regex = '^-?\\d*';
      } else if (max! < 0) {
        regex = '^(-\\d{0,$_maxIntegerLength})?';
      } else if (max! >= 0) {
        regex = '^((-\\d*)|(\\d{0,$_maxIntegerLength}))';
      }
    } else if (min! < 0) {
      if (max == null) {
        regex = '^((-\\d{0,$_minIntegerLength})|(\\d*))';
      } else if (max! < 0) {
        regex = '^(-\\d{0,$_minIntegerLength})?';
      } else if (max! >= 0) {
        regex = '^((-\\d{0,$_minIntegerLength})|(\\d{0,$_maxIntegerLength}))';
      }
    } else if (min! >= 0) {
      if (max == null) {
        regex = '^\\d*';
      } else if (max! >= 0) {
        regex = '^\\d{0,$_maxIntegerLength}';
      }
    }

    return regex;
  }

  bool _checkBounds(String value) {
    var integerPart = value.split('.')[0];
    int numberCurrentDecimals = value.contains('.') ? value.split('.')[1].length : 0;

    if (integerPart.startsWith('-')) {
      if (min == null) return true;

      if (_minIntegerLength != null && _minIntegerLength! > integerPart.substring(1).length) return true;
    } else {
      if (max == null) return true;

      if (_maxIntegerLength != null && _maxIntegerLength! > integerPart.length) return true;
    }

    var _newDouble = double.tryParse(value);
    if (_newDouble == null) return false;

    if (min != null && _newDouble < _truncateDigits(min!, numberCurrentDecimals)) return false;

    if (max != null && _newDouble > _truncateDigits(max!, numberCurrentDecimals)) return false;

    return true;
  }

  double _truncateDigits(double value, int numberDigits) {
    return double.parse(value.toStringAsFixed(numberDigits));
  }
}
