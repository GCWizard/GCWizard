part of 'package:gc_wizard/common_widgets/coordinates/gcw_coords/gcw_coords.dart';

class _Geo3x3TextInputFormatter extends TextInputFormatter {
  RegExp _exp;

  _Geo3x3TextInputFormatter() {
    _exp = new RegExp('^([EeWw]|[EeWw][1-9]*)?\$');
  }

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (_exp.hasMatch(newValue.text.toLowerCase())) {
      return newValue;
    }

    return oldValue;
  }
}
