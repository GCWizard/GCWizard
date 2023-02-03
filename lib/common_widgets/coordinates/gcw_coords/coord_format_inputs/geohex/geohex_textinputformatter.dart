part of 'package:gc_wizard/common_widgets/coordinates/gcw_coords/gcw_coords.dart';

class _GeoHexTextInputFormatter extends TextInputFormatter {
  RegExp _exp;

  _GeoHexTextInputFormatter() {
    _exp = new RegExp('^([A-Za-z]|[A-Za-z]{2}[0-9]*)?\$');
  }

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (_exp.hasMatch(newValue.text.toLowerCase())) {
      return newValue;
    }

    return oldValue;
  }
}
