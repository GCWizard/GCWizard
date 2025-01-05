part of 'package:gc_wizard/tools/coords/_common/widget/gcw_coords.dart';

class _NaturalAreaCodeTextInputFormatter extends TextInputFormatter {
  final RegExp _exp = RegExp('^[0-9BCDFGHJKLMNPQRSTVWXZ]*\$');

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (_exp.hasMatch(newValue.text.toUpperCase())) {
      return newValue;
    }

    return oldValue;
  }
}
