part of 'package:gc_wizard/common_widgets/color_pickers/gcw_colors.dart';

class _GCWColorYUV extends StatefulWidget {
  final Function onChanged;
  final YUV color;

  const _GCWColorYUV({Key key, this.onChanged, this.color}) : super(key: key);

  @override
  _GCWColorYUVState createState() => _GCWColorYUVState();
}

class _GCWColorYUVState extends State<_GCWColorYUV> {
  double _currentY = 50.0;
  double _currentU = 0.0;
  double _currentV = 0.0;

  @override
  Widget build(BuildContext context) {
    if (widget.color != null) {
      _currentY = widget.color.y * 100.0;
      _currentU = widget.color.u * 100.0;
      _currentV = widget.color.v * 100.0;
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
          title: 'U',
          min: -YUV.U_MAX * 100.0,
          max: YUV.U_MAX * 100.0,
          value: _currentU,
          numberDecimalDigits: COLOR_DOUBLE_PRECISION,
          onChanged: (value) {
            _currentU = value;
            _emitOnChange();
          },
        ),
        GCWDoubleSpinner(
          title: 'V',
          min: -YUV.V_MAX * 100.0,
          max: YUV.V_MAX * 100.0,
          value: _currentV,
          numberDecimalDigits: COLOR_DOUBLE_PRECISION,
          onChanged: (value) {
            _currentV = value;
            _emitOnChange();
          },
        ),
      ],
    );
  }

  _emitOnChange() {
    widget.onChanged(YUV(_currentY / 100.0, _currentU / 100.0, _currentV / 100.0));
  }
}
