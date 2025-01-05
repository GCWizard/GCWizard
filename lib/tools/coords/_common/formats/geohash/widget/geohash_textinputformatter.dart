part of 'package:gc_wizard/tools/coords/_common/widget/gcw_coords.dart';

class _GeohashTextInputFormatter extends TextInputFormatter {
  final RegExp _exp = RegExp('^[0-9bcdefghjkmnpqrstuvwxyz]*\$');

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (_exp.hasMatch(newValue.text.toLowerCase())) {
      return newValue;
    }

    return oldValue;
  }
}
