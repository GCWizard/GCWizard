part of 'package:gc_wizard/common_widgets/coordinates/gcw_coords/gcw_coords.dart';

class _GeohashTextInputFormatter extends TextInputFormatter {
  RegExp _exp;

  _GeohashTextInputFormatter() {
    _exp = new RegExp('^[0-9bcdefghjkmnpqrstuvwxyz]*\$');
  }

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (_exp.hasMatch(newValue.text.toLowerCase())) {
      return newValue;
    }

    return oldValue;
  }
}
