part of 'package:gc_wizard/common_widgets/coordinates/gcw_coords/gcw_coords.dart';

class _MaidenheadTextInputFormatter extends TextInputFormatter {
  final RegExp _exp = RegExp('^([A-Za-z]{2}\\d{2})*([A-Za-z]?|[A-Za-z]{2}\\d{0,2})\$');

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (_exp.hasMatch(newValue.text)) {
      return newValue;
    }

    return oldValue;
  }
}
