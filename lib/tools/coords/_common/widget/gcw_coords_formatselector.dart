import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_dropdown.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinate_format.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinate_format_constants.dart';
import 'package:gc_wizard/tools/coords/_common/logic/default_coord_getter.dart';
import 'package:gc_wizard/tools/coords/_common/widget/gcw_coords.dart';

class GCWCoordsFormatSelector extends StatefulWidget {
  final void Function(CoordinateFormat) onChanged;
  final CoordinateFormat format;
  final bool input;

  const GCWCoordsFormatSelector({Key? key,
    required this.onChanged,
    required this.format,
    required this.input,
  }) : super(key: key);

  @override
  _GCWCoordsFormatSelectorState createState() => _GCWCoordsFormatSelectorState();

  List<GCWDropDownMenuItem<CoordinateFormatKey>> getDropDownItems(BuildContext context) {
    return allCoordinateWidgetInfos.map((entry) {
      return GCWDropDownMenuItem<CoordinateFormatKey>(
          value: entry.type,
          child: i18n(context, entry.name, ifTranslationNotExists: entry.name),
          subtitle: entry.example);
    }).toList();
  }
}

class _GCWCoordsFormatSelectorState extends State<GCWCoordsFormatSelector> {
  var _currentFormat = defaultCoordinateFormat.type;
  var _currentSubtype = defaultCoordinateFormat.subtype;

  @override
  Widget build(BuildContext context) {
    _currentFormat = widget.format.type;
    _currentSubtype = widget.format.subtype;

    return Column(
      children: <Widget>[
        GCWDropDown<CoordinateFormatKey>(
          value: _currentFormat,
          onChanged: (CoordinateFormatKey newValue) {
            setState(() {
              _currentFormat = newValue;
              _currentSubtype = getDefaultSubtypeForFormat(_currentFormat);

              _emitOnChange();
            });
          },
          items: widget.getDropDownItems(context),
        ),
        _buildSubtype()
      ],
    );
  }

  Widget _buildSubtype() {
    var format = _currentFormat;

    if (_currentSubtype == null) {
      _currentSubtype = defaultCoordinateFormatSubtypeForFormat(format);
      if (_currentSubtype == null) {
        return Container();
      }
    }

    var widgetInfo = coordinateWidgetInfoByType(format);
    if (widgetInfo is GCWCoordWidgetWithSubtypeInfo) {
      return widget.input
          ? widgetInfo.inputWidget(
            context: context,
            value: _currentSubtype!,
            onChanged: (value) {
              setState(() {
                _currentSubtype = value;
                _emitOnChange();
              });
            })
          : widgetInfo.outputWidget(
            context: context,
            value: _currentSubtype!,
            onChanged: (value) {
              setState(() {
                _currentSubtype = value;
                _emitOnChange();
              });
          });
    } else {
      return Container();
    }
  }

  void _emitOnChange() {
    var output = CoordinateFormat(_currentFormat, _currentSubtype);
    widget.onChanged(output);
  }
}
