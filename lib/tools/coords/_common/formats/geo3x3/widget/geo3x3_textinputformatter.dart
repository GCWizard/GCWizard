part of 'package:gc_wizard/tools/coords/_common/widget/gcw_coords.dart';

class _Geo3x3TextInputFormatter extends TextInputFormatter {
  final RegExp _exp = RegExp('^([EeWw]|[EeWw][1-9]*)?\$');

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (_exp.hasMatch(newValue.text.toLowerCase())) {
      return newValue;
    }

    return oldValue;
  }
}
