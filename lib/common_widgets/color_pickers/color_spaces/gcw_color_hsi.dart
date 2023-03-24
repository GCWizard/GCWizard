part of 'package:gc_wizard/common_widgets/color_pickers/gcw_colors.dart';

class _GCWColorHSI extends StatefulWidget {
  final void Function(HSI) onChanged;
  final HSI? color;

  const _GCWColorHSI({Key? key, required this.onChanged, this.color}) : super(key: key);

  @override
  _GCWColorHSIState createState() => _GCWColorHSIState();
}

class _GCWColorHSIState extends State<_GCWColorHSI> {
  double _currentHue = 0.0;
  double _currentSaturation = 0.0;
  double _currentIntensity = 50.0;

  @override
  Widget build(BuildContext context) {
    if (widget.color != null) {
      _currentHue = widget.color!.hue;
      _currentSaturation = widget.color!.saturation * 100.0;
      _currentIntensity = widget.color!.intensity * 100.0;
    }

    return Column(
      children: [
        GCWDoubleSpinner(
          title: 'H',
          min: 0.0,
          max: 360.0,
          value: _currentHue,
          numberDecimalDigits: COLOR_DOUBLE_PRECISION,
          onChanged: (value) {
            _currentHue = value;
            _emitOnChange();
          },
        ),
        GCWDoubleSpinner(
          title: 'S',
          min: 0.0,
          max: 100.0,
          value: _currentSaturation,
          numberDecimalDigits: COLOR_DOUBLE_PRECISION,
          onChanged: (value) {
            _currentSaturation = value;
            _emitOnChange();
          },
        ),
        GCWDoubleSpinner(
          title: 'I',
          min: 0.0,
          max: 100.0,
          value: _currentIntensity,
          numberDecimalDigits: COLOR_DOUBLE_PRECISION,
          onChanged: (value) {
            _currentIntensity = value;
            _emitOnChange();
          },
        ),
      ],
    );
  }

  void _emitOnChange() {
    widget.onChanged(HSI(_currentHue, _currentSaturation / 100.0, _currentIntensity / 100.0));
  }
}
