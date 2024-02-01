part of 'package:gc_wizard/tools/coords/_common/widget/gcw_coords.dart';

class _UTMLonZoneTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) return newValue;

    var _newInt = int.tryParse(newValue.text);
    if (_newInt == null) return oldValue;

    if (_newInt >= 1 && _newInt <= 60) return newValue;

    return oldValue;
  }
}
