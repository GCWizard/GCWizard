part of 'package:gc_wizard/application/theme/theme_colors.dart';

class _ThemeColorsDark extends ThemeColors {
  static const _lightGray = Color(0xFFD8D8D8);
  static const _gray = Color(0x40D8D8D8);
  static const _darkGray = Color(0xFF26282F);

  ThemeData _base;

  @override
  ThemeData base() {
    if (_base == null) _base = ThemeData.dark();

    return _base;
  }

  @override
  Color accent() {
    return Colors.orangeAccent;
  }

  @override
  Color focused() {
    return Colors.greenAccent;
  }

  @override
  Color inActive() {
    return Colors.grey;
  }

  @override
  Color inputBackground() {
    return _darkGray;
  }

  @override
  Color mainFont() {
    return Colors.white;
  }

  @override
  Color outputListOddRows() {
    return _gray;
  }

  @override
  Color dialog() {
    return Colors.orangeAccent;
  }

  @override
  Color dialogText() {
    return Colors.black;
  }

  @override
  Color primaryBackground() {
    return Color(0xFF33333D);
  }

  @override
  Color iconImageBackground() {
    return Colors.white;
  }

  @override
  Color textFieldHintText() {
    return Color.fromRGBO(150, 150, 150, 1.0);
  }

  @override
  Color messageBackground() {
    return _darkGray;
  }

  @override
  Color switchThumb1() {
    return _lightGray;
  }

  @override
  Color switchTrack1() {
    return _darkGray;
  }

  @override
  Color switchThumb2() {
    return accent();
  }

  @override
  Color switchTrack2() {
    return accent().withOpacity(0.5);
  }

  @override
  Color checkBoxActiveColor() {
    return _lightGray;
  }

  @override
  Color checkBoxFillColor(Set<MaterialState> states) {
    if (states.contains(MaterialState.disabled)) {
      return _darkGray;
    }
    return _darkGray;
  }

  @override
  Color checkBoxCheckColor() {
    return accent();
  }

  @override
  Color checkBoxFocusColor() {
    return accent().withOpacity(0.5);
  }

  @override
  Color checkBoxHoverColor() {
    return accent();
  }

  @override
  Color checkBoxOverlayColor(Set<MaterialState> states) {
    if (states.contains(MaterialState.disabled)) {
      return accent().withOpacity(0.5);
    }
    return accent().withOpacity(0.5);
  }

  @override
  Color listSubtitle() {
    return _lightGray;
  }

  @override
  Color gridBackground() {
    return Color.fromARGB(255, 85, 85, 85);
  }

  @override
  Color hyperLinkText() {
    return accent();
  }

  @override
  Color textFieldFill() {
    return Colors.black;
  }

  @override
  Color textFieldFillText() {
    return Colors.white;
  }

  @override
  Color formulaNumber() {
    return Colors.lightGreen;
  }

  @override
  Color formulaVariable() {
    return Colors.orange;
  }

  @override
  Color formulaMath() {
    return Colors.lightBlue;
  }

  @override
  Color formulaError() {
    return Colors.redAccent;
  }
}
