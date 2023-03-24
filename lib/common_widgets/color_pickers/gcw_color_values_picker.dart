part of 'package:gc_wizard/common_widgets/color_pickers/gcw_colors.dart';

class GCWColorValue {
  ColorSpaceKey colorSpace;
  GCWBaseColor color;

  GCWColorValue(this.colorSpace, this.color);
}

class _GCWColorValuesPicker extends StatefulWidget {
  final void Function(GCWColorValue) onChanged;
  final GCWColorValue colorsValue;

  const _GCWColorValuesPicker({Key? key, required this.onChanged, required this.colorsValue}) : super(key: key);

  @override
  _GCWColorValuesPickerState createState() => _GCWColorValuesPickerState();
}

class _GCWColorValuesPickerState extends State<_GCWColorValuesPicker> {
  var _currentColorsValue = GCWColorValue(defaultColorSpace, defaultColor);
  
  @override
  Widget build(BuildContext context) {
    _currentColorsValue = GCWColorValue(widget.colorsValue.colorSpace, widget.colorsValue.color);

    final Map<ColorSpaceKey, Widget> _colorWidgets =
      {
        ColorSpaceKey.RGB:
        _GCWColorRGB(
          color: _currentColorsValue.colorSpace == ColorSpaceKey.RGB ? _currentColorsValue.color as RGB : null,
          onChanged: (RGB newValue) {
            setState(() {
              _currentColorsValue.color = newValue;
              _setCurrentValueAndEmitOnChange();
            });
          },
        ),
        
        ColorSpaceKey.HEXCODE:
        _GCWColorHexCode(
          color: _currentColorsValue.colorSpace == ColorSpaceKey.HEXCODE ? _currentColorsValue.color as HexCode : null,
          onChanged: (HexCode newValue) {
            setState(() {
              _currentColorsValue.color = newValue;
              _setCurrentValueAndEmitOnChange();
            });
          },
        ),
      
        ColorSpaceKey.HSV:
        _ColorHSV(
          color: _currentColorsValue.colorSpace == ColorSpaceKey.HSV ? _currentColorsValue.color as HSV : null,
          onChanged: (HSV newValue) {
            setState(() {
              _currentColorsValue.color = newValue;
              _setCurrentValueAndEmitOnChange();
            });
          },
        ),
      
        ColorSpaceKey.HSL:
        _GCWColorHSL(
          color: _currentColorsValue.colorSpace == ColorSpaceKey.HSL ? _currentColorsValue.color as HSL : null,
          onChanged: (HSL newValue) {
            setState(() {
              _currentColorsValue.color = newValue;
              _setCurrentValueAndEmitOnChange();
            });
          },
        ),
     
        ColorSpaceKey.HSI:
        _GCWColorHSI(
          color: _currentColorsValue.colorSpace == ColorSpaceKey.HSI ? _currentColorsValue.color as HSI : null,
          onChanged: (HSI newValue) {
            setState(() {
              _currentColorsValue.color = newValue;
              _setCurrentValueAndEmitOnChange();
            });
          },
        ),
     
        ColorSpaceKey.CMYK:
        _GCWColorCMYK(
          color: _currentColorsValue.colorSpace == ColorSpaceKey.CMYK ? _currentColorsValue.color as CMYK : null,
          onChanged: (CMYK newValue) {
            setState(() {
              _currentColorsValue.color = newValue;
              _setCurrentValueAndEmitOnChange();
            });
          },
        ),
     
        ColorSpaceKey.CMY:
        _GCWColorCMY(
          color: _currentColorsValue.colorSpace == ColorSpaceKey.CMY ? _currentColorsValue.color as CMY : null,
          onChanged: (CMY newValue) {
            setState(() {
              _currentColorsValue.color = newValue;
              _setCurrentValueAndEmitOnChange();
            });
          },
        ),
      
        ColorSpaceKey.YUV:
        _GCWColorYUV(
          color: _currentColorsValue.colorSpace == ColorSpaceKey.YUV ? _currentColorsValue.color as YUV : null,
          onChanged: (YUV newValue) {
            setState(() {
              _currentColorsValue.color = newValue;
              _setCurrentValueAndEmitOnChange();
            });
          },
        ),
     
        ColorSpaceKey.YPBPR:
        _GCWColorYPbPr(
          color: _currentColorsValue.colorSpace == ColorSpaceKey.YPBPR ? _currentColorsValue.color as YPbPr : null,
          onChanged: (YPbPr newValue) {
            setState(() {
              _currentColorsValue.color = newValue;
              _setCurrentValueAndEmitOnChange();
            });
          },
        ),
     
        ColorSpaceKey.YCBCR:
        _GCWColorYCbCr(
          color: _currentColorsValue.colorSpace == ColorSpaceKey.YCBCR ? _currentColorsValue.color as YCbCr : null,
          onChanged: (YCbCr newValue) {
            setState(() {
              _currentColorsValue.color = newValue;
              _setCurrentValueAndEmitOnChange();
            });
          },
        ),
    
        ColorSpaceKey.YIQ:
        _GCWColorYIQ(
          color: _currentColorsValue.colorSpace == ColorSpaceKey.YIQ ? _currentColorsValue.color as YIQ: null,
          onChanged: (YIQ newValue) {
            setState(() {
              _currentColorsValue.color = newValue;
              _setCurrentValueAndEmitOnChange();
            });
          },
        ),
      };

    Column _widget = Column(
      children: <Widget>[
        GCWDropDown<ColorSpaceKey>(
          value: _currentColorsValue.colorSpace,
          onChanged: (ColorSpaceKey newValue) {
            setState(() {
              _currentColorsValue = GCWColorValue(newValue, convertColorSpace(_currentColorsValue, newValue));

              _setCurrentValueAndEmitOnChange();
            });
          },
          items: _colorWidgets.keys.map((ColorSpaceKey colorSpace) {
            return GCWDropDownMenuItem(
              value: colorSpace,
              child: i18n(context, getColorSpaceByKey(colorSpace).name),
            );
          }).toList(),
        ),
      ],
    );

    Widget _currentWidget = _colorWidgets[_currentColorsValue.colorSpace] ?? _colorWidgets[ColorSpaceKey.RGB]!;
    _widget.children.add(_currentWidget);

    return _widget;
  }

  void _setCurrentValueAndEmitOnChange() {
    widget.onChanged(_currentColorsValue);
  }
}
