part of 'package:gc_wizard/common_widgets/color_pickers/gcw_colors.dart';

class _GCWColorValuesPicker extends StatefulWidget {
  final Function onChanged;
  final dynamic color;
  final String colorSpace;

  const _GCWColorValuesPicker({Key key, this.onChanged, this.colorSpace, this.color}) : super(key: key);

  @override
  _GCWColorValuesPickerState createState() => _GCWColorValuesPickerState();
}

class _GCWColorValuesPickerState extends State<_GCWColorValuesPicker> {
  String _currentColorSpace;
  dynamic _currentColor = defaultColor;

  @override
  Widget build(BuildContext context) {
    _currentColorSpace = widget.colorSpace ?? defaultColorSpace;
    _currentColor = widget.color ?? defaultColor;

    List<Map<String, dynamic>> _colorWidgets = [
      {
        'colorSpace': getColorSpaceByKey(keyColorSpaceRGB),
        'widget': _GCWColorRGB(
          color: _currentColorSpace == keyColorSpaceRGB ? _currentColor : null,
          onChanged: (newValue) {
            setState(() {
              _currentColor = newValue;
              _setCurrentValueAndEmitOnChange();
            });
          },
        ),
      },
      {
        'colorSpace': getColorSpaceByKey(keyColorSpaceHex),
        'widget': _GCWColorHexCode(
          color: _currentColorSpace == keyColorSpaceHex ? _currentColor : null,
          onChanged: (newValue) {
            setState(() {
              _currentColor = newValue;
              _setCurrentValueAndEmitOnChange();
            });
          },
        ),
      },
      {
        'colorSpace': getColorSpaceByKey(keyColorSpaceHSV),
        'widget': _ColorHSV(
          color: _currentColorSpace == keyColorSpaceHSV ? _currentColor : null,
          onChanged: (newValue) {
            setState(() {
              _currentColor = newValue;
              _setCurrentValueAndEmitOnChange();
            });
          },
        ),
      },
      {
        'colorSpace': getColorSpaceByKey(keyColorSpaceHSL),
        'widget': _GCWColorHSL(
          color: _currentColorSpace == keyColorSpaceHSL ? _currentColor : null,
          onChanged: (newValue) {
            setState(() {
              _currentColor = newValue;
              _setCurrentValueAndEmitOnChange();
            });
          },
        ),
      },
      {
        'colorSpace': getColorSpaceByKey(keyColorSpaceHSI),
        'widget': _GCWColorHSI(
          color: _currentColorSpace == keyColorSpaceHSI ? _currentColor : null,
          onChanged: (newValue) {
            setState(() {
              _currentColor = newValue;
              _setCurrentValueAndEmitOnChange();
            });
          },
        ),
      },
      {
        'colorSpace': getColorSpaceByKey(keyColorSpaceCMYK),
        'widget': _GCWColorCMYK(
          color: _currentColorSpace == keyColorSpaceCMYK ? _currentColor : null,
          onChanged: (newValue) {
            setState(() {
              _currentColor = newValue;
              _setCurrentValueAndEmitOnChange();
            });
          },
        ),
      },
      {
        'colorSpace': getColorSpaceByKey(keyColorSpaceCMY),
        'widget': _GCWColorCMY(
          color: _currentColorSpace == keyColorSpaceCMY ? _currentColor : null,
          onChanged: (newValue) {
            setState(() {
              _currentColor = newValue;
              _setCurrentValueAndEmitOnChange();
            });
          },
        ),
      },
      {
        'colorSpace': getColorSpaceByKey(keyColorSpaceYUV),
        'widget': _GCWColorYUV(
          color: _currentColorSpace == keyColorSpaceYUV ? _currentColor : null,
          onChanged: (newValue) {
            setState(() {
              _currentColor = newValue;
              _setCurrentValueAndEmitOnChange();
            });
          },
        ),
      },
      {
        'colorSpace': getColorSpaceByKey(keyColorSpaceYPbPr),
        'widget': _GCWColorYPbPr(
          color: _currentColorSpace == keyColorSpaceYPbPr ? _currentColor : null,
          onChanged: (newValue) {
            setState(() {
              _currentColor = newValue;
              _setCurrentValueAndEmitOnChange();
            });
          },
        ),
      },
      {
        'colorSpace': getColorSpaceByKey(keyColorSpaceYCbCr),
        'widget': _GCWColorYCbCr(
          color: _currentColorSpace == keyColorSpaceYCbCr ? _currentColor : null,
          onChanged: (newValue) {
            setState(() {
              _currentColor = newValue;
              _setCurrentValueAndEmitOnChange();
            });
          },
        ),
      },
      {
        'colorSpace': getColorSpaceByKey(keyColorSpaceYIQ),
        'widget': _GCWColorYIQ(
          color: _currentColorSpace == keyColorSpaceYIQ ? _currentColor : null,
          onChanged: (newValue) {
            setState(() {
              _currentColor = newValue;
              _setCurrentValueAndEmitOnChange();
            });
          },
        ),
      },
    ];

    List<ColorSpace> _onlyColorSpaces = _colorWidgets.map((entry) => entry['colorSpace'] as ColorSpace).toList();

    Column _widget = Column(
      children: <Widget>[
        GCWDropDown(
          value: _currentColorSpace,
          onChanged: (newValue) {
            setState(() {
              _currentColor = convertColorSpace(_currentColor, _currentColorSpace, newValue);
              _currentColorSpace = newValue;

              _setCurrentValueAndEmitOnChange();
            });
          },
          items: _onlyColorSpaces.map((colorSpace) {
            return GCWDropDownMenuItem(
              value: colorSpace.key,
              child: i18n(context, colorSpace.name),
            );
          }).toList(),
        ),
      ],
    );

    var _currentWidget = _colorWidgets.firstWhere((entry) => entry['colorSpace'].key == _currentColorSpace)['widget'];

    _widget.children.add(_currentWidget);

    return _widget;
  }

  _setCurrentValueAndEmitOnChange() {
    widget.onChanged({'colorSpace': _currentColorSpace, 'color': _currentColor});
  }
}
