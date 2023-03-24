part of 'package:gc_wizard/common_widgets/color_pickers/gcw_colors.dart';

class _GCWColorHSL extends StatefulWidget {
  final void Function(HSL) onChanged;
  final HSL? color;

  const _GCWColorHSL({Key? key, required this.onChanged, this.color}) : super(key: key);

  @override
  _GCWColorHSLState createState() => _GCWColorHSLState();
}

class _GCWColorHSLState extends State<_GCWColorHSL> {
  double _currentHue = 0.0;
  double _currentSaturation = 0.0;
  double _currentLightness = 50.0;

  @override
  Widget build(BuildContext context) {
    if (widget.color != null) {
      _currentHue = widget.color!.hue;
      _currentSaturation = widget.color!.saturation * 100.0;
      _currentLightness = widget.color!.lightness * 100.0;
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
          title: 'L',
          min: 0.0,
          max: 100.0,
          value: _currentLightness,
          numberDecimalDigits: COLOR_DOUBLE_PRECISION,
          onChanged: (value) {
            _currentLightness = value;
            _emitOnChange();
          },
        ),
      ],
    );
  }

  void _emitOnChange() {
    widget.onChanged(HSL(_currentHue, _currentSaturation / 100.0, _currentLightness / 100.0));
  }
}
