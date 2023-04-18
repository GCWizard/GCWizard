import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/app_localizations.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_dropdown.dart';
import 'package:gc_wizard/common_widgets/spinners/gcw_integer_spinner.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinate_format_constants.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinate_format_metadata.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinate_format.dart';
import 'package:gc_wizard/tools/coords/_common/logic/default_coord_getter.dart';
import 'package:gc_wizard/utils/collection_utils.dart';

class GCWCoordsFormatSelector extends StatefulWidget {
  final void Function(CoordinateFormat) onChanged;
  final CoordinateFormat format;

  const GCWCoordsFormatSelector({Key? key, required this.onChanged, required this.format}) : super(key: key);

  @override
  GCWCoordsFormatSelectorState createState() => GCWCoordsFormatSelectorState();

  List<GCWDropDownMenuItem<CoordinateFormatKey>> getDropDownItems(BuildContext context) {
    return allCoordinateFormatMetadata.map((entry) {
      return GCWDropDownMenuItem<CoordinateFormatKey>(
          value: entry.type, child: i18n(context, entry.name, ifTranslationNotExists: entry.name), subtitle: entry.example);
    }).toList();
  }
}

class GCWCoordsFormatSelectorState extends State<GCWCoordsFormatSelector> {
    var _currentFormat = defaultCoordinateFormat.type;
    var _currentSubtype = defaultCoordinateFormat.subtype;

    @override
    void initState() {
      super.initState();

      _currentFormat = widget.format.type;
      _currentSubtype = widget.format.subtype;
    }

  @override
  Widget build(BuildContext context) {

    return Column(
      children: <Widget>[
        GCWDropDown<CoordinateFormatKey>(
          value: _currentFormat,
          onChanged: (CoordinateFormatKey newValue) {
            setState(() {
              _currentFormat = newValue;

              switch (_currentFormat) {
                case CoordinateFormatKey.GAUSS_KRUEGER:
                  _currentSubtype = defaultGaussKruegerType;
                  break;
                case CoordinateFormatKey.LAMBERT:
                  _currentSubtype = defaultLambertType;
                  break;
                case CoordinateFormatKey.SLIPPY_MAP:
                  _currentSubtype = defaultSlippyMapType;
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

  Widget _buildSubtype() {
    var format = _currentFormat;

    if (_currentSubtype == null) {
      _currentSubtype = defaultCoordinateFormatSubtypeForFormat(format);
      if (_currentSubtype == null) {
        return Container();
      }
    }

    switch (format) {
      case CoordinateFormatKey.GAUSS_KRUEGER:
      case CoordinateFormatKey.LAMBERT:
        return GCWDropDown<CoordinateFormatKey>(
          value: _currentSubtype!,
          items: coordinateFormatMetadataByKey(format).subtypes!.map((subtype) {
            return GCWDropDownMenuItem(
              value: subtype.type,
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
      case CoordinateFormatKey.SLIPPY_MAP:
        return GCWIntegerSpinner(
          min: 0,
          max: 30,
          title: i18n(context, 'coords_formatconverter_slippymap_zoom') + ' (Z)',
          value: switchMapKeyValue(SLIPPY_MAP_ZOOM)[_currentSubtype]!,
          onChanged: (int value) {
            setState(() {
              _currentSubtype = SLIPPY_MAP_ZOOM[value];
              _emitOnChange();
            });
          },
        );
      default:
        return Container();
    }
  }

  void _emitOnChange() {
    var output = CoordinateFormat(_currentFormat, _currentSubtype);
    widget.onChanged(output);
  }
}
