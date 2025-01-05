part of 'package:gc_wizard/tools/coords/_common/widget/gcw_coords.dart';

class _MakaneyTextInputFormatter extends TextInputFormatter {
  final RegExp _exp = RegExp('^[-+abo2zptscjkwmgnxqfd984ery3h5l76ui]*\$');

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (_exp.hasMatch(newValue.text.toLowerCase())) {
      return newValue;
    }

    return oldValue;
  }
}
