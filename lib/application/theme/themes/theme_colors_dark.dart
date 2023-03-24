part of 'package:gc_wizard/application/theme/theme_colors.dart';

class _ThemeColorsDark extends ThemeColors {
  static const _lightGray = Color(0xFFD8D8D8);
  static const _gray = Color(0x40D8D8D8);
  static const _darkGray = Color(0xFF26282F);

  @override
  ThemeData base() {
    return ThemeData.dark();
  }

  @override
  Color secondary() {
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
    return const Color(0xFF33333D);
  }

  @override
  Color iconImageBackground() {
    return Colors.white;
  }

  @override
  Color textFieldHintText() {
    return const Color.fromRGBO(150, 150, 150, 1.0);
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
    return secondary();
  }

  @override
  Color switchTrack2() {
    return secondary().withOpacity(0.5);
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
    return secondary();
  }

  @override
  Color checkBoxFocusColor() {
    return secondary().withOpacity(0.5);
  }

  @override
  Color checkBoxHoverColor() {
    return secondary();
  }

  @override
  Color checkBoxOverlayColor(Set<MaterialState> states) {
    if (states.contains(MaterialState.disabled)) {
      return secondary().withOpacity(0.5);
    }
    return secondary().withOpacity(0.5);
  }

  @override
  Color listSubtitle() {
    return _lightGray;
  }

  @override
  Color gridBackground() {
    return const Color.fromARGB(255, 85, 85, 85);
  }

  @override
  Color hyperLinkText() {
    return secondary();
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
