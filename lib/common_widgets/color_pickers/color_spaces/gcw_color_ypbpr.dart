part of 'package:gc_wizard/common_widgets/color_pickers/gcw_colors.dart';

class _GCWColorYPbPr extends StatefulWidget {
  final void Function(YPbPr) onChanged;
  final YPbPr? color;

  const _GCWColorYPbPr({Key? key, required this.onChanged, this.color}) : super(key: key);

  @override
  _GCWColorYPbPrState createState() => _GCWColorYPbPrState();
}

class _GCWColorYPbPrState extends State<_GCWColorYPbPr> {
  double _currentY = 50.0;
  double _currentPb = 0.0;
  double _currentPr = 0.0;

  @override
  Widget build(BuildContext context) {
    if (widget.color != null) {
      _currentY = widget.color!.y * 100.0;
      _currentPb = widget.color!.pb * 100.0;
      _currentPr = widget.color!.pr * 100.0;
    }

    return Column(
      children: [
        GCWDoubleSpinner(
          title: 'Y',
          min: 0.0,
          max: 100.0,
          value: _currentY,
          numberDecimalDigits: COLOR_DOUBLE_PRECISION,
          onChanged: (value) {
            _currentY = value;
            _emitOnChange();
          },
        ),
        GCWDoubleSpinner(
          title: 'Pb',
          min: -0.5 * 100.0,
          max: 0.5 * 100.0,
          value: _currentPb,
          numberDecimalDigits: COLOR_DOUBLE_PRECISION,
          onChanged: (value) {
            _currentPb = value;
            _emitOnChange();
          },
        ),
        GCWDoubleSpinner(
          title: 'Pr',
          min: -0.5 * 100.0,
          max: 0.5 * 100.0,
          value: _currentPr,
          numberDecimalDigits: COLOR_DOUBLE_PRECISION,
          onChanged: (value) {
            _currentPr = value;
            _emitOnChange();
          },
        ),
      ],
    );
  }

  void _emitOnChange() {
    widget.onChanged(YPbPr(_currentY / 100.0, _currentPb / 100.0, _currentPr / 100.0));
  }
}
