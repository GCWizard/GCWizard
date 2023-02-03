part of 'package:gc_wizard/common_widgets/color_pickers/gcw_colors.dart';

class _GCWColorYCbCr extends StatefulWidget {
  final Function onChanged;
  final YCbCr color;

  const _GCWColorYCbCr({Key key, this.onChanged, this.color}) : super(key: key);

  @override
  _GCWColorYCbCrState createState() => _GCWColorYCbCrState();
}

class _GCWColorYCbCrState extends State<_GCWColorYCbCr> {
  double _currentY = 50.0;
  double _currentCb = 0.0;
  double _currentCr = 0.0;

  @override
  Widget build(BuildContext context) {
    if (widget.color != null) {
      _currentY = widget.color.y;
      _currentCb = widget.color.cb;
      _currentCr = widget.color.cr;
    }

    return Column(
      children: [
        GCWDoubleSpinner(
          title: 'Y',
          min: 16.0,
          max: 235.0,
          value: _currentY,
          numberDecimalDigits: COLOR_DOUBLE_PRECISION,
          onChanged: (value) {
            _currentY = value;
            _emitOnChange();
          },
        ),
        GCWDoubleSpinner(
          title: 'Cb',
          min: 16.0,
          max: 240.0,
          value: _currentCb,
          numberDecimalDigits: COLOR_DOUBLE_PRECISION,
          onChanged: (value) {
            _currentCb = value;
            _emitOnChange();
          },
        ),
        GCWDoubleSpinner(
          title: 'Cr',
          min: 16.0,
          max: 240.0,
          value: _currentCr,
          numberDecimalDigits: COLOR_DOUBLE_PRECISION,
          onChanged: (value) {
            _currentCr = value;
            _emitOnChange();
          },
        ),
      ],
    );
  }

  _emitOnChange() {
    widget.onChanged(YCbCr(_currentY, _currentCb, _currentCr));
  }
}
