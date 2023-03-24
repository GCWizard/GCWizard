part of 'package:gc_wizard/common_widgets/coordinates/gcw_coords/gcw_coords.dart';

class _GeoHexTextInputFormatter extends TextInputFormatter {
  final RegExp _exp = RegExp('^([A-Za-z]|[A-Za-z]{2}\\d*)?\$');

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (_exp.hasMatch(newValue.text.toLowerCase())) {
      return newValue;
    }

    return oldValue;
  }
}
