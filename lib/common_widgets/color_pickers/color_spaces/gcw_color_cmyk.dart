part of 'package:gc_wizard/common_widgets/color_pickers/gcw_colors.dart';

class _GCWColorCMYK extends StatefulWidget {
  final void Function(CMYK) onChanged;
  final CMYK? color;

  const _GCWColorCMYK({required this.onChanged, this.color});

  @override
  _GCWColorCMYKState createState() => _GCWColorCMYKState();
}

class _GCWColorCMYKState extends State<_GCWColorCMYK> {
  double _currentCyan = 50.0;
  double _currentMagenta = 50.0;
  double _currentYellow = 50.0;
  double _currentKey = 50.0;

  @override
  Widget build(BuildContext context) {
    if (widget.color != null) {
      _currentCyan = widget.color!.cyan * 100.0;
      _currentMagenta = widget.color!.magenta * 100.0;
      _currentYellow = widget.color!.yellow * 100.0;
      _currentKey = widget.color!.key * 100.0;
    }

    return Column(
      children: [
        GCWDoubleSpinner(
          title: 'C',
          min: 0.0,
          max: 100.0,
          value: _currentCyan,
          numberDecimalDigits: COLOR_DOUBLE_PRECISION,
          onChanged: (value) {
            _currentCyan = value;
            _emitOnChange();
          },
        ),
        GCWDoubleSpinner(
          title: 'M',
          min: 0.0,
          max: 100.0,
          value: _currentMagenta,
          numberDecimalDigits: COLOR_DOUBLE_PRECISION,
          onChanged: (value) {
            _currentMagenta = value;
            _emitOnChange();
          },
        ),
        GCWDoubleSpinner(
          title: 'Y',
          min: 0.0,
          max: 100.0,
          value: _currentYellow,
          numberDecimalDigits: COLOR_DOUBLE_PRECISION,
          onChanged: (value) {
            _currentYellow = value;
            _emitOnChange();
          },
        ),
        GCWDoubleSpinner(
          title: 'K',
          min: 0.0,
          max: 100.0,
          value: _currentKey,
          numberDecimalDigits: COLOR_DOUBLE_PRECISION,
          onChanged: (value) {
            _currentKey = value;
            _emitOnChange();
          },
        ),
      ],
    );
  }

  void _emitOnChange() {
    widget.onChanged(CMYK(_currentCyan / 100.0, _currentMagenta / 100.0, _currentYellow / 100.0, _currentKey / 100.0));
  }
}
