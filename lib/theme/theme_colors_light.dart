import 'package:flutter/material.dart';
import 'package:gc_wizard/theme/theme_colors.dart';

class ThemeColorsLight extends ThemeColors {
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
  Color inputBackground() {
    return Colors.white; //TODO
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
  Color listSubtitle() {
    return _darkGray;
  }

  @override
  Color sudokuBackground() {
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
}
