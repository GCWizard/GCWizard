import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/app_localizations.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_dropdown.dart';
import 'package:gc_wizard/common_widgets/spinners/gcw_double_spinner.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coord_format_getter.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinates.dart';
import 'package:gc_wizard/tools/coords/_common/logic/default_coord_getter.dart';
import 'package:intl/intl.dart';

class GCWCoordsFormatSelector extends StatefulWidget {
  final Function onChanged;
  final Map<String, String> format;

  const GCWCoordsFormatSelector({Key key, this.onChanged, this.format}) : super(key: key);

  @override
  GCWCoordsFormatSelectorState createState() => GCWCoordsFormatSelectorState();

  List<GCWDropDownMenuItem> getDropDownItems(BuildContext context) {
    return allCoordFormats.map((entry) {
      return GCWDropDownMenuItem(
          value: entry.key, child: i18n(context, entry.name) ?? entry.name, subtitle: entry.example);
    }).toList();
  }
}

class GCWCoordsFormatSelectorState extends State<GCWCoordsFormatSelector> {
  var _currentFormat = defaultCoordFormat()['format'];
  var _currentSubtype = defaultCoordFormat()['subtype'];

  @override
  Widget build(BuildContext context) {
    if (widget.format != null) {
      _currentFormat = widget.format['format'];

      if (widget.format['subtype'] != null) _currentSubtype = widget.format['subtype'];
    }

    return Column(
      children: <Widget>[
        GCWDropDown(
          value: widget.format['format'] ?? _currentFormat,
          onChanged: (newValue) {
            setState(() {
              _currentFormat = newValue;

              switch (_currentFormat) {
                case keyCoordsGaussKrueger:
                  _currentSubtype = getGaussKruegerTypKey();
                  break;
                case keyCoordsLambert:
                  _currentSubtype = getLambertKey();
                  break;
                case keyCoordsSlippyMap:
                  _currentSubtype = DefaultSlippyZoom.toInt().toString();
                  break;
                default:
                  _currentSubtype = null;
              }

              _emitOnChange();
            });
          },
          items: widget.getDropDownItems(context),
        ),
        _buildSubtype()
      ],
    );
  }

  _buildSubtype() {
    var format = widget.format['format'] ?? _currentFormat;

    switch (format) {
      case keyCoordsGaussKrueger:
      case keyCoordsLambert:
        return GCWDropDown(
          value: _currentSubtype,
          items: getCoordinateFormatByKey(format).subtypes.map((subtype) {
            return GCWDropDownMenuItem(
              value: subtype.key,
              child: i18n(context, subtype.name),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _currentSubtype = value;
              _emitOnChange();
            });
          },
        );
      case keyCoordsSlippyMap:
        return GCWDoubleSpinner(
          min: 0.0,
          max: 30.0,
          title: i18n(context, 'coords_formatconverter_slippymap_zoom') + ' (Z)',
          value: double.tryParse(_currentSubtype == null ? DefaultSlippyZoom : _currentSubtype),
          onChanged: (value) {
            setState(() {
              _currentSubtype = NumberFormat('0.00000').format(value);
              _emitOnChange();
            });
          },
        );
      default:
        return Container();
    }
  }

  _emitOnChange() {
    Map<String, String> output = {'format': _currentFormat, 'subtype': _currentSubtype};
    widget.onChanged(output);
  }
}
