import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gc_wizard/application/i18n/app_localizations.dart';
import 'package:gc_wizard/application/permissions/user_location.dart';
import 'package:gc_wizard/application/theme/theme.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_iconbutton.dart';
import 'package:gc_wizard/common_widgets/coordinates/gcw_coords/gcw_coords_formatselector.dart';
import 'package:gc_wizard/common_widgets/coordinates/gcw_coords/gcw_coords_paste_button.dart';
import 'package:gc_wizard/common_widgets/dividers/gcw_text_divider.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_dropdown.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_sign_dropdown.dart';
import 'package:gc_wizard/common_widgets/gcw_distance.dart';
import 'package:gc_wizard/common_widgets/gcw_text.dart';
import 'package:gc_wizard/common_widgets/gcw_toast.dart';
import 'package:gc_wizard/common_widgets/text_input_formatters/gcw_integer_textinputformatter.dart';
import 'package:gc_wizard/common_widgets/text_input_formatters/gcw_minutesseconds_textinputformatter.dart';
import 'package:gc_wizard/common_widgets/text_input_formatters/wrapper_for_masktextinputformatter.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_double_textfield.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_integer_textfield.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/tools/coords/format_converter/logic/mgrs.dart';
import 'package:gc_wizard/tools/coords/format_converter/logic/utm.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coord_format_getter.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinates.dart';
import 'package:gc_wizard/tools/coords/_common/logic/default_coord_getter.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';

part 'package:gc_wizard/common_widgets/coordinates/gcw_coords/coord_format_inputs/degrees_latlon/degrees_lat_textinputformatter.dart';
part 'package:gc_wizard/common_widgets/coordinates/gcw_coords/coord_format_inputs/degrees_latlon/degrees_lon_textinputformatter.dart';
part 'package:gc_wizard/common_widgets/coordinates/gcw_coords/coord_format_inputs/degrees_latlon/gcw_coords_dec.dart';
part 'package:gc_wizard/common_widgets/coordinates/gcw_coords/coord_format_inputs/degrees_latlon/gcw_coords_dmm.dart';
part 'package:gc_wizard/common_widgets/coordinates/gcw_coords/coord_format_inputs/degrees_latlon/gcw_coords_dms.dart';
part 'package:gc_wizard/common_widgets/coordinates/gcw_coords/coord_format_inputs/gcw_coords_dutchgrid.dart';
part 'package:gc_wizard/common_widgets/coordinates/gcw_coords/coord_format_inputs/gcw_coords_gausskrueger.dart';
part 'package:gc_wizard/common_widgets/coordinates/gcw_coords/coord_format_inputs/gcw_coords_lambert.dart';
part 'package:gc_wizard/common_widgets/coordinates/gcw_coords/coord_format_inputs/gcw_coords_mercator.dart';
part 'package:gc_wizard/common_widgets/coordinates/gcw_coords/coord_format_inputs/gcw_coords_openlocationcode.dart';
part 'package:gc_wizard/common_widgets/coordinates/gcw_coords/coord_format_inputs/gcw_coords_quadtree.dart';
part 'package:gc_wizard/common_widgets/coordinates/gcw_coords/coord_format_inputs/gcw_coords_reversewherigo_day1976.dart';
part 'package:gc_wizard/common_widgets/coordinates/gcw_coords/coord_format_inputs/gcw_coords_reversewherigo_waldmeister.dart';
part 'package:gc_wizard/common_widgets/coordinates/gcw_coords/coord_format_inputs/gcw_coords_slippymap.dart';
part 'package:gc_wizard/common_widgets/coordinates/gcw_coords/coord_format_inputs/gcw_coords_swissgrid.dart';
part 'package:gc_wizard/common_widgets/coordinates/gcw_coords/coord_format_inputs/gcw_coords_swissgridplus.dart';
part 'package:gc_wizard/common_widgets/coordinates/gcw_coords/coord_format_inputs/gcw_coords_xyz.dart';
part 'package:gc_wizard/common_widgets/coordinates/gcw_coords/coord_format_inputs/geo3x3/gcw_coords_geo3x3.dart';
part 'package:gc_wizard/common_widgets/coordinates/gcw_coords/coord_format_inputs/geo3x3/geo3x3_textinputformatter.dart';
part 'package:gc_wizard/common_widgets/coordinates/gcw_coords/coord_format_inputs/geohash/gcw_coords_geohash.dart';
part 'package:gc_wizard/common_widgets/coordinates/gcw_coords/coord_format_inputs/geohash/geohash_textinputformatter.dart';
part 'package:gc_wizard/common_widgets/coordinates/gcw_coords/coord_format_inputs/geohex/gcw_coords_geohex.dart';
part 'package:gc_wizard/common_widgets/coordinates/gcw_coords/coord_format_inputs/geohex/geohex_textinputformatter.dart';
part 'package:gc_wizard/common_widgets/coordinates/gcw_coords/coord_format_inputs/maidenhead/gcw_coords_maidenhead.dart';
part 'package:gc_wizard/common_widgets/coordinates/gcw_coords/coord_format_inputs/maidenhead/maidenhead_textinputformatter.dart';
part 'package:gc_wizard/common_widgets/coordinates/gcw_coords/coord_format_inputs/makaney/gcw_coords_makaney.dart';
part 'package:gc_wizard/common_widgets/coordinates/gcw_coords/coord_format_inputs/makaney/makaney_textinputformatter.dart';
part 'package:gc_wizard/common_widgets/coordinates/gcw_coords/coord_format_inputs/mgrs_utm/gcw_coords_mgrs.dart';
part 'package:gc_wizard/common_widgets/coordinates/gcw_coords/coord_format_inputs/mgrs_utm/gcw_coords_utm.dart';
part 'package:gc_wizard/common_widgets/coordinates/gcw_coords/coord_format_inputs/mgrs_utm/utm_lonzone_textinputformatter.dart';
part 'package:gc_wizard/common_widgets/coordinates/gcw_coords/coord_format_inputs/natural_area_code/gcw_coords_naturalareacode.dart';
part 'package:gc_wizard/common_widgets/coordinates/gcw_coords/coord_format_inputs/natural_area_code/naturalareacode_textinputformatter.dart';

class GCWCoords extends StatefulWidget {
  final Function onChanged;
  final Map<String, String> coordsFormat;
  final LatLng coordinates;
  final String title;
  final bool notitle;
  final bool restoreCoordinates;

  const GCWCoords(
      {Key key,
      this.title,
      this.coordinates,
      this.onChanged,
      this.coordsFormat,
      this.notitle: false,
      this.restoreCoordinates: false})
      : super(key: key);

  @override
  GCWCoordsState createState() => GCWCoordsState();
}

class GCWCoordsState extends State<GCWCoords> {
  Map<String, String> _currentCoordsFormat;
  BaseCoordinates _currentValue;

  BaseCoordinates _pastedCoords;

  var _currentWidget;

  var _location = Location();
  bool _isOnLocationAccess = false;

  @override
  void initState() {
    super.initState();

    _currentCoordsFormat = widget.coordsFormat ?? defaultCoordFormat();
    _setPastedCoordsFormat();
    _currentValue = (widget.coordinates ?? defaultCoordinate) == null
        ? null
        : DEC.fromLatLon(widget.coordinates ?? defaultCoordinate);
    _pastedCoords = _currentValue;
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> _coordsWidgets = [
      {
        'coordFormat': getCoordinateFormatByKey(keyCoordsDEC),
        'widget': _GCWCoordsDEC(
          coordinates: _pastedCoords,
          onChanged: (newValue) {
            setState(() {
              _setCurrentValueAndEmitOnChange(newValue);
            });
          },
        ),
      },
      {
        'coordFormat': getCoordinateFormatByKey(keyCoordsDMM),
        'widget': _GCWCoordsDMM(
          coordinates: _pastedCoords,
          onChanged: (newValue) {
            setState(() {
              _setCurrentValueAndEmitOnChange(newValue);
            });
          },
        ),
      },
      {
        'coordFormat': getCoordinateFormatByKey(keyCoordsDMS),
        'widget': _GCWCoordsDMS(
          coordinates: _pastedCoords,
          onChanged: (newValue) {
            setState(() {
              _setCurrentValueAndEmitOnChange(newValue);
            });
          },
        ),
      },
      {
        'coordFormat': getCoordinateFormatByKey(keyCoordsUTM),
        'widget': _GCWCoordsUTM(
          coordinates: _pastedCoords,
          onChanged: (newValue) {
            setState(() {
              _setCurrentValueAndEmitOnChange(newValue);
            });
          },
        ),
      },
      {
        'coordFormat': getCoordinateFormatByKey(keyCoordsMGRS),
        'widget': GCWCoordsMGRS(
          coordinates: _pastedCoords,
          onChanged: (newValue) {
            setState(() {
              _setCurrentValueAndEmitOnChange(newValue);
            });
          },
        ),
      },
      {
        'coordFormat': getCoordinateFormatByKey(keyCoordsXYZ),
        'widget': _GCWCoordsXYZ(
          coordinates: _pastedCoords,
          onChanged: (newValue) {
            setState(() {
              _setCurrentValueAndEmitOnChange(newValue);
            });
          },
        ),
      },
      {
        'coordFormat': getCoordinateFormatByKey(keyCoordsSwissGrid),
        'widget': _GCWCoordsSwissGrid(
          coordinates: _pastedCoords,
          onChanged: (newValue) {
            setState(() {
              _setCurrentValueAndEmitOnChange(newValue);
            });
          },
        ),
      },
      {
        'coordFormat': getCoordinateFormatByKey(keyCoordsSwissGridPlus),
        'widget': _GCWCoordsSwissGridPlus(
          coordinates: _pastedCoords,
          onChanged: (newValue) {
            setState(() {
              _setCurrentValueAndEmitOnChange(newValue);
            });
          },
        ),
      },
      {
        'coordFormat': getCoordinateFormatByKey(keyCoordsGaussKrueger),
        'widget': _GCWCoordsGaussKrueger(
          coordinates: _pastedCoords,
          subtype: _currentCoordsFormat['subtype'],
          onChanged: (newValue) {
            setState(() {
              _setCurrentValueAndEmitOnChange(newValue);
            });
          },
        ),
      },
      {
        'coordFormat': getCoordinateFormatByKey(keyCoordsLambert),
        'widget': _GCWCoordsLambert(
          coordinates: _pastedCoords,
          subtype: _currentCoordsFormat['subtype'],
          onChanged: (newValue) {
            setState(() {
              _setCurrentValueAndEmitOnChange(newValue);
            });
          },
        ),
      },
      {
        'coordFormat': getCoordinateFormatByKey(keyCoordsDutchGrid),
        'widget': _GCWCoordsDutchGrid(
          coordinates: _pastedCoords,
          onChanged: (newValue) {
            setState(() {
              _setCurrentValueAndEmitOnChange(newValue);
            });
          },
        ),
      },
      {
        'coordFormat': getCoordinateFormatByKey(keyCoordsMaidenhead),
        'widget': _GCWCoordsMaidenhead(
          coordinates: _pastedCoords,
          onChanged: (newValue) {
            setState(() {
              _setCurrentValueAndEmitOnChange(newValue);
            });
          },
        ),
      },
      {
        'coordFormat': getCoordinateFormatByKey(keyCoordsMercator),
        'widget': _GCWCoordsMercator(
          coordinates: _pastedCoords,
          onChanged: (newValue) {
            setState(() {
              _setCurrentValueAndEmitOnChange(newValue);
            });
          },
        ),
      },
      {
        'coordFormat': getCoordinateFormatByKey(keyCoordsNaturalAreaCode),
        'widget': _GCWCoordsNaturalAreaCode(
          coordinates: _pastedCoords,
          onChanged: (newValue) {
            setState(() {
              _setCurrentValueAndEmitOnChange(newValue);
            });
          },
        ),
      },
      {
        'coordFormat': getCoordinateFormatByKey(keyCoordsSlippyMap),
        'widget': _GCWCoordsSlippyMap(
          coordinates: _pastedCoords,
          zoom: double.tryParse(_currentCoordsFormat['subtype'] ?? DefaultSlippyZoom.toString()),
          onChanged: (newValue) {
            setState(() {
              _setCurrentValueAndEmitOnChange(newValue);
            });
          },
        ),
      },
      {
        'coordFormat': getCoordinateFormatByKey(keyCoordsMakaney),
        'widget': _GCWCoordsMakaney(
          coordinates: _pastedCoords,
          onChanged: (newValue) {
            setState(() {
              _setCurrentValueAndEmitOnChange(newValue);
            });
          },
        ),
      },
      {
        'coordFormat': getCoordinateFormatByKey(keyCoordsGeohash),
        'widget': _GCWCoordsGeohash(
          coordinates: _pastedCoords,
          onChanged: (newValue) {
            setState(() {
              _setCurrentValueAndEmitOnChange(newValue);
            });
          },
        ),
      },
      {
        'coordFormat': getCoordinateFormatByKey(keyCoordsGeoHex),
        'widget': _GCWCoordsGeoHex(
          coordinates: _pastedCoords,
          onChanged: (newValue) {
            setState(() {
              _setCurrentValueAndEmitOnChange(newValue);
            });
          },
        ),
      },
      {
        'coordFormat': getCoordinateFormatByKey(keyCoordsGeo3x3),
        'widget': _GCWCoordsGeo3x3(
          coordinates: _pastedCoords,
          onChanged: (newValue) {
            setState(() {
              _setCurrentValueAndEmitOnChange(newValue);
            });
          },
        ),
      },
      {
        'coordFormat': getCoordinateFormatByKey(keyCoordsOpenLocationCode),
        'widget': _GCWCoordsOpenLocationCode(
          coordinates: _pastedCoords,
          onChanged: (newValue) {
            setState(() {
              _setCurrentValueAndEmitOnChange(newValue);
            });
          },
        ),
      },
      {
        'coordFormat': getCoordinateFormatByKey(keyCoordsQuadtree),
        'widget': _GCWCoordsQuadtree(
          coordinates: _pastedCoords,
          onChanged: (newValue) {
            setState(() {
              _setCurrentValueAndEmitOnChange(newValue);
            });
          },
        ),
      },
      {
        'coordFormat': getCoordinateFormatByKey(keyCoordsReverseWherigoWaldmeister),
        'widget': _GCWCoordsReverseWherigoWaldmeister(
          coordinates: _pastedCoords,
          onChanged: (newValue) {
            setState(() {
              _setCurrentValueAndEmitOnChange(newValue);
            });
          },
        ),
      },
      {
        'coordFormat': getCoordinateFormatByKey(keyCoordsReverseWherigoDay1976),
        'widget': _GCWCoordsReverseWherigoDay1976(
          coordinates: _pastedCoords,
          onChanged: (newValue) {
            setState(() {
              _setCurrentValueAndEmitOnChange(newValue);
            });
          },
        ),
      },
    ];

    _pastedCoords = null;

    Column _widget;
    if (widget.notitle) {
      _widget = Column(
        children: <Widget>[
          Row(
            children: [
              Expanded(child: _buildInputFormatSelector()),
              Container(
                  child: _buildTrailingButtons(IconButtonSize.NORMAL),
                  padding: EdgeInsets.only(left: 2 * DEFAULT_MARGIN))
            ],
          )
        ],
      );
    } else {
      _widget = Column(
        children: <Widget>[
          GCWTextDivider(text: widget.title, bottom: 0.0, trailing: _buildTrailingButtons(IconButtonSize.SMALL)),
          _buildInputFormatSelector()
        ],
      );
    }

    _currentWidget =
        _coordsWidgets.firstWhere((entry) => entry['coordFormat'].key == _currentCoordsFormat['format'])['widget'];

    _widget.children.add(_currentWidget);

    return _widget;
  }

  _buildInputFormatSelector() {
    return GCWCoordsFormatSelector(
      format: _currentCoordsFormat,
      onChanged: (newValue) {
        setState(() {
          if (_currentCoordsFormat != newValue) {
            if (widget.restoreCoordinates)
              _pastedCoords = _currentValue;
            else if (subtypeChanged(_currentCoordsFormat, newValue))
              ;
            else
              _currentValue = DEC(defaultCoordinate.latitude, defaultCoordinate.longitude);

            _currentCoordsFormat = newValue;
            _setCurrentValueAndEmitOnChange();
          }
          FocusScope.of(context).requestFocus(FocusNode()); //Release focus from previous edited field
        });
      },
    );
  }

  bool subtypeChanged(Map<String, String> currentValue, Map<String, String> newValue) {
    return currentValue["subtype"] != newValue["subtype"];
  }

  _buildTrailingButtons(IconButtonSize size) {
    return Row(
      children: [
        Container(
          child: GCWIconButton(
            icon: _isOnLocationAccess ? Icons.refresh : Icons.location_on,
            size: size,
            onPressed: () {
              _setUserLocationCoords();
            },
          ),
          padding: EdgeInsets.only(right: DEFAULT_MARGIN),
        ),
        GCWCoordsPasteButton(size: size, onPasted: _setCoords)
      ],
    );
  }

  _setCurrentValueAndEmitOnChange([BaseCoordinates newValue]) {
    widget.onChanged({'coordsFormat': _currentCoordsFormat, 'value': (newValue ?? _currentValue)?.toLatLng()});
  }

  _setCoords(List<BaseCoordinates> pastedCoords) {
    if (pastedCoords == null || pastedCoords.length == 0) return;

    if (pastedCoords.any((coords) => coords.key == _currentCoordsFormat['format'].toString())) {
      _pastedCoords = pastedCoords.where((coords) => coords.key == _currentCoordsFormat['format'].toString()).first;
    } else {
      _pastedCoords = pastedCoords.elementAt(0);
      _currentCoordsFormat = {'format': pastedCoords.elementAt(0).key};
    }

    _setPastedCoordsFormat();
    _currentValue = _pastedCoords;

    _setCurrentValueAndEmitOnChange();
  }

  _setPastedCoordsFormat() {
    switch (_currentCoordsFormat['format']) {
      case keyCoordsDEC:
      case keyCoordsDMM:
      case keyCoordsDMS:
      case keyCoordsUTM:
      case keyCoordsMGRS:
      case keyCoordsXYZ:
      case keyCoordsSwissGrid:
      case keyCoordsSwissGridPlus:
        break;
      case keyCoordsGaussKrueger:
        _currentCoordsFormat.addAll({'subtype': getGaussKruegerTypKey()});
        break;
      case keyCoordsLambert:
        _currentCoordsFormat.addAll({'subtype': getLambertKey()});
        break;
      case keyCoordsDutchGrid:
      case keyCoordsMaidenhead:
      case keyCoordsMercator:
      case keyCoordsNaturalAreaCode:
        break;
      case keyCoordsSlippyMap:
        _currentCoordsFormat.addAll({'subtype': DefaultSlippyZoom.toString()});
        break;
      case keyCoordsGeohash:
      case keyCoordsGeoHex:
      case keyCoordsGeo3x3:
      case keyCoordsOpenLocationCode:
      case keyCoordsQuadtree:
      case keyCoordsMakaney:
      case keyCoordsReverseWherigoWaldmeister:
      case keyCoordsReverseWherigoDay1976:
        break;
      default:
        _currentCoordsFormat = {'format': keyCoordsDMM};
    }
  }

  _setUserLocationCoords() {
    if (_isOnLocationAccess) return;

    setState(() {
      _isOnLocationAccess = true;
    });

    checkLocationPermission(_location).then((value) {
      if (value == null || value == false) {
        setState(() {
          _isOnLocationAccess = false;
        });
        showToast(i18n(context, 'coords_common_location_permissiondenied'));

        return;
      }

      _location.getLocation().then((locationData) {
        if (locationData.accuracy > 20)
          showToast(i18n(context, 'coords_common_location_lowaccuracy',
              parameters: [NumberFormat('0.0').format(locationData.accuracy)]));

        _pastedCoords = DEC(locationData.latitude, locationData.longitude);
        _currentValue = _pastedCoords;
        _setPastedCoordsFormat();

        _isOnLocationAccess = false;
        _setCurrentValueAndEmitOnChange();
      });
    });
  }
}
