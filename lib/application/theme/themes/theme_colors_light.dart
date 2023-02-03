part of 'package:gc_wizard/application/theme/theme_colors.dart';

class _ThemeColorsLight extends ThemeColors {
  ThemeData _base;

  static const _creme = Color(0xFFF5F3ED);
  static const _darkGray = Color(0xFF404040);
  static const _gray = Color(0xFF919191);
  static const _lightGray = Color(0xFFD1D1D1);

  @override
  ThemeData base() {
    if (_base == null) _base = ThemeData.light();

    return _base;
  }

  @override
  Color accent() {
    return Colors.orange;
  }

  @override
  Color focused() {
    return Colors.cyan;
  }

  @override
  Color inActive() {
    return Colors.grey;
  }

  @override
  Color inputBackground() {
    return Colors.white;
  }

  @override
  Color mainFont() {
    return Colors.black;
  }

  @override
  Color outputListOddRows() {
    return _lightGray;
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
    return _creme;
  }

  @override
  Color iconImageBackground() {
    return Colors.white;
  }

  @override
  Color textFieldHintText() {
    return _gray;
  }

  @override
  Color messageBackground() {
    return Colors.white;
  }

  @override
  Color switchThumb1() {
    return _gray;
  }

  @override
  Color switchTrack1() {
    return _lightGray.withOpacity(0.5);
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
    return _gray;
  }

  @override
  Color checkBoxFillColor(Set<MaterialState> states) {
    if (states.contains(MaterialState.disabled)) {
      return _lightGray.withOpacity(0.5);
    }
    return _lightGray.withOpacity(0.5);
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
    return _darkGray;
  }

  @override
  Color gridBackground() {
    return Colors.white;
  }

  @override
  Color hyperLinkText() {
    return Colors.deepOrange;
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
    return Color.fromRGBO(48, 145, 0, 1);
  }

  @override
  Color formulaVariable() {
    return Color.fromRGBO(255, 135, 0, 1);
  }

  @override
  Color formulaMath() {
    return Colors.indigoAccent;
  }

  @override
  Color formulaError() {
    return Colors.red;
  }
}
