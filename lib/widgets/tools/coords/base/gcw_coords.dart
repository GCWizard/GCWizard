import 'package:flutter/material.dart';
import 'package:gc_wizard/i18n/app_localizations.dart';
import 'package:gc_wizard/logic/tools/coords/data/coordinates.dart';
import 'package:gc_wizard/logic/tools/coords/utils.dart';
import 'package:gc_wizard/theme/theme.dart';
import 'package:gc_wizard/widgets/common/base/gcw_iconbutton.dart';
import 'package:gc_wizard/widgets/common/base/gcw_toast.dart';
import 'package:gc_wizard/widgets/common/gcw_text_divider.dart';
import 'package:gc_wizard/widgets/tools/coords/base/gcw_coords_dec.dart';
import 'package:gc_wizard/widgets/tools/coords/base/gcw_coords_dmm.dart';
import 'package:gc_wizard/widgets/tools/coords/base/gcw_coords_dms.dart';
import 'package:gc_wizard/widgets/tools/coords/base/gcw_coords_dutchgrid.dart';
import 'package:gc_wizard/widgets/tools/coords/base/gcw_coords_formatselector.dart';
import 'package:gc_wizard/widgets/tools/coords/base/gcw_coords_gausskrueger.dart';
import 'package:gc_wizard/widgets/tools/coords/base/gcw_coords_geo3x3.dart';
import 'package:gc_wizard/widgets/tools/coords/base/gcw_coords_geohash.dart';
import 'package:gc_wizard/widgets/tools/coords/base/gcw_coords_geohex.dart';
import 'package:gc_wizard/widgets/tools/coords/base/gcw_coords_maidenhead.dart';
import 'package:gc_wizard/widgets/tools/coords/base/gcw_coords_makaney.dart';
import 'package:gc_wizard/widgets/tools/coords/base/gcw_coords_mercator.dart';
import 'package:gc_wizard/widgets/tools/coords/base/gcw_coords_lambert.dart';
import 'package:gc_wizard/widgets/tools/coords/base/gcw_coords_mgrs.dart';
import 'package:gc_wizard/widgets/tools/coords/base/gcw_coords_naturalareacode.dart';
import 'package:gc_wizard/widgets/tools/coords/base/gcw_coords_openlocationcode.dart';
import 'package:gc_wizard/widgets/tools/coords/base/gcw_coords_paste_button.dart';
import 'package:gc_wizard/widgets/tools/coords/base/gcw_coords_quadtree.dart';
import 'package:gc_wizard/widgets/tools/coords/base/gcw_coords_reversewherigo_day1976.dart';
import 'package:gc_wizard/widgets/tools/coords/base/gcw_coords_reversewherigo_waldmeister.dart';
import 'package:gc_wizard/widgets/tools/coords/base/gcw_coords_slippymap.dart';
import 'package:gc_wizard/widgets/tools/coords/base/gcw_coords_swissgrid.dart';
import 'package:gc_wizard/widgets/tools/coords/base/gcw_coords_swissgridplus.dart';
import 'package:gc_wizard/widgets/tools/coords/base/gcw_coords_utm.dart';
import 'package:gc_wizard/widgets/tools/coords/base/gcw_coords_xyz.dart';
import 'package:gc_wizard/widgets/tools/coords/base/utils.dart';
import 'package:gc_wizard/widgets/tools/coords/utils/user_location.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';

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
        'widget': GCWCoordsDEC(
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
        'widget': GCWCoordsDMM(
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
        'widget': GCWCoordsDMS(
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
        'widget': GCWCoordsUTM(
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
        'widget': GCWCoordsXYZ(
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
        'widget': GCWCoordsSwissGrid(
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
        'widget': GCWCoordsSwissGridPlus(
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
        'widget': GCWCoordsGaussKrueger(
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
        'widget': GCWCoordsLambert(
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
        'widget': GCWCoordsDutchGrid(
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
        'widget': GCWCoordsMaidenhead(
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
        'widget': GCWCoordsMercator(
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
        'widget': GCWCoordsNaturalAreaCode(
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
        'widget': GCWCoordsSlippyMap(
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
        'widget': GCWCoordsMakaney(
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
        'widget': GCWCoordsGeohash(
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
        'widget': GCWCoordsGeoHex(
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
        'widget': GCWCoordsGeo3x3(
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
        'widget': GCWCoordsOpenLocationCode(
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
        'widget': GCWCoordsQuadtree(
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
        'widget': GCWCoordsReverseWherigoWaldmeister(
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
        'widget': GCWCoordsReverseWherigoDay1976(
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
