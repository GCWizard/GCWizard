part of 'package:gc_wizard/common_widgets/coordinates/gcw_coords/gcw_coords.dart';

class _DegreesLatTextInputFormatter extends TextInputFormatter {
  final bool allowNegativeValues;

  _DegreesLatTextInputFormatter({this.allowNegativeValues = false});

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (!allowNegativeValues && newValue.text == '-') return oldValue;

    if (newValue.text == '' || newValue.text == '-') return newValue;

    var _newInt = int.tryParse(newValue.text);
    if (_newInt == null) return oldValue;

    if (!allowNegativeValues && _newInt < 0) return oldValue;

    if (_newInt >= -90 && _newInt <= 90) return newValue;

    return oldValue;
  }
}
