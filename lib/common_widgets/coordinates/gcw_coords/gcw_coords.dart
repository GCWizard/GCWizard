import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gc_wizard/application/i18n/app_localizations.dart';
import 'package:gc_wizard/application/permissions/user_location.dart';
import 'package:gc_wizard/application/theme/theme.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_iconbutton.dart';
import 'package:gc_wizard/common_widgets/coordinates/gcw_coords/gcw_coords_formatselector.dart';
import 'package:gc_wizard/common_widgets/coordinates/gcw_coords/gcw_coords_paste_button.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinate_format.dart';
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
import 'package:gc_wizard/tools/coords/_common/logic/coordinate_format_constants.dart';
import 'package:gc_wizard/tools/coords/format_converter/logic/mgrs.dart';
import 'package:gc_wizard/tools/coords/format_converter/logic/utm.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinates.dart';
import 'package:gc_wizard/tools/coords/_common/logic/default_coord_getter.dart';
import 'package:gc_wizard/utils/collection_utils.dart';
import 'package:gc_wizard/utils/complex_return_types.dart';
import 'package:gc_wizard/utils/constants.dart';
import 'package:gc_wizard/utils/data_type_utils/double_type_utils.dart';
import 'package:gc_wizard/utils/string_utils.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:collection/collection.dart';
import 'package:latlong2/latlong.dart';

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

class _GCWCoordWidget{
  final CoordinateFormatKey coordinateFormatKey;
  final Widget widget;
  
  _GCWCoordWidget(this.coordinateFormatKey, this.widget);
}

class GCWCoords extends StatefulWidget {
  final void Function(BaseCoordinate) onChanged;
  final LatLng? coordinates;
  final CoordinateFormat coordsFormat;
  final String? title;
  final bool? notitle;
  final bool? restoreCoordinates;

  const GCWCoords(
      {Key? key,
      this.title,
      required this.onChanged,
      this.coordinates,
      required this.coordsFormat,
      this.notitle = false,
      this.restoreCoordinates = false})
      : super(key: key);

  @override
  GCWCoordsState createState() => GCWCoordsState();
}

class GCWCoordsState extends State<GCWCoords> {  
  BaseCoordinate _currentCoords = defaultBaseCoordinate;
  late BaseCoordinate _pastedCoords;

  Widget? _currentWidget;

  final _location = Location();
  bool _isOnLocationAccess = false;

  @override
  void initState() {
    super.initState();

    _currentCoords = buildCoordinatesByFormat(widget.coordsFormat, widget.coordinates ?? defaultCoordinate);
    _setPastedCoordsFormat();
    _pastedCoords = _currentCoords;
  }
  
  @override
  Widget build(BuildContext context) {
    final List<_GCWCoordWidget> _coordsWidgets = [
      _GCWCoordWidget(
        CoordinateFormatKey.DEC,
        _GCWCoordsDEC(
          coordinates: _pastedCoords is DEC
              ? _pastedCoords as DEC
              : buildCoordinatesByFormat(CoordinateFormat(CoordinateFormatKey.DEC), defaultCoordinate) as DEC,
          onChanged: (newValue) {
            setState(() {
              _setCurrentValueAndEmitOnChange(newValue);
            });
          },
        ),
      ),
      _GCWCoordWidget(
        CoordinateFormatKey.DMM,
        _GCWCoordsDMM(
          coordinates: _pastedCoords is DMM
              ? _pastedCoords as DMM
              : buildCoordinatesByFormat(CoordinateFormat(CoordinateFormatKey.DMM), defaultCoordinate) as DMM,
          onChanged: (newValue) {
            setState(() {
              _setCurrentValueAndEmitOnChange(newValue);
            });
          },
        ),
    ),
    _GCWCoordWidget(
        CoordinateFormatKey.DMS,
        _GCWCoordsDMS(
          coordinates: _pastedCoords is DMS
              ? _pastedCoords as DMS
              : buildCoordinatesByFormat(CoordinateFormat(CoordinateFormatKey.DMS), defaultCoordinate) as DMS,
          onChanged: (newValue) {
            setState(() {
              _setCurrentValueAndEmitOnChange(newValue);
            });
          },
        ),
    ),
    _GCWCoordWidget(
        CoordinateFormatKey.UTM,
        _GCWCoordsUTM(
          coordinates: _pastedCoords is UTMREF
              ? _pastedCoords as UTMREF
              : buildCoordinatesByFormat(CoordinateFormat(CoordinateFormatKey.UTM), defaultCoordinate) as UTMREF,
          onChanged: (newValue) {
            setState(() {
              _setCurrentValueAndEmitOnChange(newValue);
            });
          },
        ),
    ),
    _GCWCoordWidget(
        CoordinateFormatKey.MGRS,
        _GCWCoordsMGRS(
          coordinates: _pastedCoords is MGRS
              ? _pastedCoords as MGRS
              : buildCoordinatesByFormat(CoordinateFormat(CoordinateFormatKey.MGRS), defaultCoordinate) as MGRS,
          onChanged: (newValue) {
            setState(() {
              _setCurrentValueAndEmitOnChange(newValue);
            });
          },
        ),
    ),
    _GCWCoordWidget(
        CoordinateFormatKey.XYZ,
        _GCWCoordsXYZ(
          coordinates: _pastedCoords is XYZ
              ? _pastedCoords as XYZ
              : buildCoordinatesByFormat(CoordinateFormat(CoordinateFormatKey.XYZ), defaultCoordinate) as XYZ,
          onChanged: (newValue) {
            setState(() {
              _setCurrentValueAndEmitOnChange(newValue);
            });
          },
        ),
    ),
    _GCWCoordWidget(
        CoordinateFormatKey.SWISS_GRID,
        _GCWCoordsSwissGrid(
          coordinates: _pastedCoords is SwissGrid
              ? _pastedCoords as SwissGrid
              : buildCoordinatesByFormat(CoordinateFormat(CoordinateFormatKey.SWISS_GRID), defaultCoordinate) as SwissGrid,
          onChanged: (newValue) {
            setState(() {
              _setCurrentValueAndEmitOnChange(newValue);
            });
          },
        ),
    ),
    _GCWCoordWidget(
        CoordinateFormatKey.SWISS_GRID_PLUS,
        _GCWCoordsSwissGridPlus(
          coordinates: _pastedCoords is SwissGridPlus
              ? _pastedCoords as SwissGridPlus
              : buildCoordinatesByFormat(CoordinateFormat(CoordinateFormatKey.SWISS_GRID_PLUS), defaultCoordinate) as SwissGridPlus,
          onChanged: (newValue) {
            setState(() {
              _setCurrentValueAndEmitOnChange(newValue);
            });
          },
        ),
    ),
    _GCWCoordWidget(
        CoordinateFormatKey.GAUSS_KRUEGER,
        _GCWCoordsGaussKrueger(
          coordinates: _pastedCoords is GaussKrueger
              ? _pastedCoords as GaussKrueger
              : buildCoordinatesByFormat(CoordinateFormat(CoordinateFormatKey.GAUSS_KRUEGER), defaultCoordinate) as GaussKrueger,
          onChanged: (newValue) {
            setState(() {
              _setCurrentValueAndEmitOnChange(newValue);
            });
          },
        ),
    ),
    _GCWCoordWidget(
        CoordinateFormatKey.LAMBERT,
        _GCWCoordsLambert(
          coordinates: _pastedCoords is Lambert
              ? _pastedCoords as Lambert
              : buildCoordinatesByFormat(CoordinateFormat(CoordinateFormatKey.LAMBERT), defaultCoordinate) as Lambert,
          onChanged: (newValue) {
            setState(() {
              _setCurrentValueAndEmitOnChange(newValue);
            });
          },
        ),
    ),
    _GCWCoordWidget(
        CoordinateFormatKey.DUTCH_GRID,
        _GCWCoordsDutchGrid(
          coordinates: _pastedCoords is DutchGrid
              ? _pastedCoords as DutchGrid
              : buildCoordinatesByFormat(CoordinateFormat(CoordinateFormatKey.DUTCH_GRID), defaultCoordinate) as DutchGrid,
          onChanged: (newValue) {
            setState(() {
              _setCurrentValueAndEmitOnChange(newValue);
            });
          },
        ),
    ),
    _GCWCoordWidget(
        CoordinateFormatKey.MAIDENHEAD,
        _GCWCoordsMaidenhead(
          coordinates: _pastedCoords is Maidenhead
              ? _pastedCoords as Maidenhead
              : buildCoordinatesByFormat(CoordinateFormat(CoordinateFormatKey.MAIDENHEAD), defaultCoordinate) as Maidenhead,
          onChanged: (newValue) {
            setState(() {
              _setCurrentValueAndEmitOnChange(newValue);
            });
          },
        ),
    ),
    _GCWCoordWidget(
        CoordinateFormatKey.MERCATOR,
        _GCWCoordsMercator(
          coordinates: _pastedCoords is Mercator
              ? _pastedCoords as Mercator
              : buildCoordinatesByFormat(CoordinateFormat(CoordinateFormatKey.MERCATOR), defaultCoordinate) as Mercator,
          onChanged: (newValue) {
            setState(() {
              _setCurrentValueAndEmitOnChange(newValue);
            });
          },
        ),
    ),
    _GCWCoordWidget(
        CoordinateFormatKey.NATURAL_AREA_CODE,
        _GCWCoordsNaturalAreaCode(
          coordinates: _pastedCoords is NaturalAreaCode
              ? _pastedCoords as NaturalAreaCode
              : buildCoordinatesByFormat(CoordinateFormat(CoordinateFormatKey.NATURAL_AREA_CODE), defaultCoordinate) as NaturalAreaCode,
          onChanged: (newValue) {
            setState(() {
              _setCurrentValueAndEmitOnChange(newValue);
            });
          },
        ),
    ),
    _GCWCoordWidget(
        CoordinateFormatKey.SLIPPY_MAP,
        _GCWCoordsSlippyMap(
          coordinates: _pastedCoords is SlippyMap
              ? _pastedCoords as SlippyMap
              : buildCoordinatesByFormat(CoordinateFormat(CoordinateFormatKey.SLIPPY_MAP), defaultCoordinate) as SlippyMap,
          onChanged: (newValue) {
            setState(() {
              _setCurrentValueAndEmitOnChange(newValue);
            });
          },
        ),
    ),
    _GCWCoordWidget(
        CoordinateFormatKey.MAKANEY,
        _GCWCoordsMakaney(
          coordinates: _pastedCoords is Makaney
              ? _pastedCoords as Makaney
              : buildCoordinatesByFormat(CoordinateFormat(CoordinateFormatKey.MAKANEY), defaultCoordinate) as Makaney,
          onChanged: (newValue) {
            setState(() {
              _setCurrentValueAndEmitOnChange(newValue);
            });
          },
        ),
    ),
    _GCWCoordWidget(
        CoordinateFormatKey.GEOHASH,
        _GCWCoordsGeohash(
          coordinates: _pastedCoords is Geohash
              ? _pastedCoords as Geohash
              : buildCoordinatesByFormat(CoordinateFormat(CoordinateFormatKey.GEOHASH), defaultCoordinate) as Geohash,
          onChanged: (newValue) {
            setState(() {
              _setCurrentValueAndEmitOnChange(newValue);
            });
          },
        ),
    ),
    _GCWCoordWidget(
        CoordinateFormatKey.GEOHEX,
        _GCWCoordsGeoHex(
          coordinates: _pastedCoords is GeoHex
              ? _pastedCoords as GeoHex
              : buildCoordinatesByFormat(CoordinateFormat(CoordinateFormatKey.GEOHEX), defaultCoordinate) as GeoHex,
          onChanged: (newValue) {
            setState(() {
              _setCurrentValueAndEmitOnChange(newValue);
            });
          },
        ),
    ),
    _GCWCoordWidget(
        CoordinateFormatKey.GEO3X3,
        _GCWCoordsGeo3x3(
          coordinates: _pastedCoords is Geo3x3
              ? _pastedCoords as Geo3x3
              : buildCoordinatesByFormat(CoordinateFormat(CoordinateFormatKey.GEO3X3), defaultCoordinate) as Geo3x3,
          onChanged: (newValue) {
            setState(() {
              _setCurrentValueAndEmitOnChange(newValue);
            });
          },
        ),
    ),
    _GCWCoordWidget(
        CoordinateFormatKey.OPEN_LOCATION_CODE,
        _GCWCoordsOpenLocationCode(
          coordinates: _pastedCoords is OpenLocationCode
              ? _pastedCoords as OpenLocationCode
              : buildCoordinatesByFormat(CoordinateFormat(CoordinateFormatKey.OPEN_LOCATION_CODE), defaultCoordinate) as OpenLocationCode,
          onChanged: (newValue) {
            setState(() {
              _setCurrentValueAndEmitOnChange(newValue);
            });
          },
        ),
    ),
    _GCWCoordWidget(
        CoordinateFormatKey.QUADTREE,
        _GCWCoordsQuadtree(
          coordinates: _pastedCoords is Quadtree
              ? _pastedCoords as Quadtree
              : buildCoordinatesByFormat(CoordinateFormat(CoordinateFormatKey.QUADTREE), defaultCoordinate) as Quadtree,
          onChanged: (newValue) {
            setState(() {
              _setCurrentValueAndEmitOnChange(newValue);
            });
          },
        ),
    ),
    _GCWCoordWidget(
        CoordinateFormatKey.REVERSE_WIG_WALDMEISTER,
        _GCWCoordsReverseWherigoWaldmeister(
          coordinates: _pastedCoords is ReverseWherigoWaldmeister
              ? _pastedCoords as ReverseWherigoWaldmeister
              : buildCoordinatesByFormat(CoordinateFormat(CoordinateFormatKey.REVERSE_WIG_WALDMEISTER), defaultCoordinate) as ReverseWherigoWaldmeister,
          onChanged: (newValue) {
            setState(() {
              _setCurrentValueAndEmitOnChange(newValue);
            });
          },
        ),
    ),
    _GCWCoordWidget(
        CoordinateFormatKey.REVERSE_WIG_DAY1976,
        _GCWCoordsReverseWherigoDay1976(
          coordinates: _pastedCoords is ReverseWherigoDay1976
              ? _pastedCoords as ReverseWherigoDay1976
              : buildCoordinatesByFormat(CoordinateFormat(CoordinateFormatKey.REVERSE_WIG_DAY1976), defaultCoordinate) as ReverseWherigoDay1976,
          onChanged: (newValue) {
            setState(() {
              _setCurrentValueAndEmitOnChange(newValue);
            });
          },
        ),
      ),
    ];

    // TODO Mike: Please check if this is really nullable. If so, all coordinate specific _GCWCoords* widgets need to have nullable coordinates fields which yields even more nullable stuff...
    // _pastedCoords = null;

    Column _widget;
    if (widget.notitle != null && widget.notitle! && widget.title != null && widget.title!.isNotEmpty) {
      _widget = Column(
        children: <Widget>[
          Row(
            children: [
              Expanded(child: _buildInputFormatSelector()),
              Container(
                  padding: const EdgeInsets.only(left: 2 * DEFAULT_MARGIN),
                  child: _buildTrailingButtons(IconButtonSize.NORMAL))
            ],
          )
        ],
      );
    } else {
      _widget = Column(
        children: <Widget>[
          GCWTextDivider(text: widget.title!, trailing: _buildTrailingButtons(IconButtonSize.SMALL)),
          _buildInputFormatSelector()
        ],
      );
    }

    var rawWidget = _coordsWidgets.firstWhereOrNull((_GCWCoordWidget entry) => entry.coordinateFormatKey == _currentCoords.format.type);
    if (rawWidget == null) {
      _currentWidget = _coordsWidgets.first.widget;
    } else {
      _currentWidget = rawWidget.widget;
    }

    _widget.children.add(_currentWidget!);

    return _widget;
  }

  GCWCoordsFormatSelector _buildInputFormatSelector() {
    return GCWCoordsFormatSelector(
      format: _currentCoords.format,
      onChanged: (CoordinateFormat newFormat) {
        setState(() {
          // TODO Mike Please check against previous code. The change made here is not quite simple and clear if logic still does the same here for changing Coords Format and Subtypes
          if (_currentCoords.format.type != newFormat.type) {
            if (widget.restoreCoordinates != null && widget.restoreCoordinates!) {
              _pastedCoords = _currentCoords;
            } else if (_currentCoords.format.subtype == newFormat.subtype) {
              _currentCoords = defaultBaseCoordinate;
            }

            _currentCoords.format = newFormat;
            _setCurrentValueAndEmitOnChange();
          }
          FocusScope.of(context).requestFocus(FocusNode()); //Release focus from previously edited field
        });
      },
    );
  }

  Row _buildTrailingButtons(IconButtonSize size) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.only(right: DEFAULT_MARGIN),
          child: GCWIconButton(
            icon: _isOnLocationAccess ? Icons.refresh : Icons.location_on,
            size: size,
            onPressed: () {
              _setUserLocationCoords();
            },
          ),
        ),
        GCWCoordsPasteButton(size: size, onPasted: _setCoords)
      ],
    );
  }

  void _setCurrentValueAndEmitOnChange([BaseCoordinate? newValue]) {
    if (newValue != null) {
      _currentCoords = newValue;
    }

    if (_currentCoords.toLatLng() != null) {
      widget.onChanged(_currentCoords);
    }
  }

  void _setCoords(List<BaseCoordinate> pastedCoords) {
    if (pastedCoords.isEmpty) return;

    var _coordsForCurrentFormat = pastedCoords.firstWhereOrNull((BaseCoordinate coords) => coords.format.type == _currentCoords.format.type);
    if (_coordsForCurrentFormat == null) {
      _coordsForCurrentFormat = pastedCoords.first;
      _currentCoords.format = pastedCoords.first.format;
    }

    _setPastedCoordsFormat();
    _currentCoords = _coordsForCurrentFormat;

    _setCurrentValueAndEmitOnChange();
  }

  void _setPastedCoordsFormat() {
    switch (_currentCoords.format.type) {
      case CoordinateFormatKey.DEC:
      case CoordinateFormatKey.DMM:
      case CoordinateFormatKey.DMS:
      case CoordinateFormatKey.UTM:
      case CoordinateFormatKey.MGRS:
      case CoordinateFormatKey.XYZ:
      case CoordinateFormatKey.SWISS_GRID:
      case CoordinateFormatKey.SWISS_GRID_PLUS:
        break;
      case CoordinateFormatKey.GAUSS_KRUEGER:
        _currentCoords.format.subtype = defaultGaussKruegerType;
        break;
      case CoordinateFormatKey.LAMBERT:
        _currentCoords.format.subtype = defaultLambertType;
        break;
      case CoordinateFormatKey.DUTCH_GRID:
      case CoordinateFormatKey.MAIDENHEAD:
      case CoordinateFormatKey.MERCATOR:
      case CoordinateFormatKey.NATURAL_AREA_CODE:
        break;
      case CoordinateFormatKey.SLIPPY_MAP:
        _currentCoords.format.subtype = defaultSlippyMapType;
        break;
      case CoordinateFormatKey.GEOHASH:
      case CoordinateFormatKey.GEOHEX:
      case CoordinateFormatKey.GEO3X3:
      case CoordinateFormatKey.OPEN_LOCATION_CODE:
      case CoordinateFormatKey.QUADTREE:
      case CoordinateFormatKey.MAKANEY:
      case CoordinateFormatKey.REVERSE_WIG_WALDMEISTER:
      case CoordinateFormatKey.REVERSE_WIG_DAY1976:
        break;
      default:
        _currentCoords.format = defaultCoordinateFormat;
    }
  }

  void _setUserLocationCoords() {
    if (_isOnLocationAccess) return;

    setState(() {
      _isOnLocationAccess = true;
    });

    checkLocationPermission(_location).then((bool value) {
      if (value == false) {
        setState(() {
          _isOnLocationAccess = false;
        });
        showToast(i18n(context, 'coords_common_location_permissiondenied'));

        return;
      }

      _location.getLocation().then((LocationData locationData) {
        if (locationData.accuracy == null || locationData.accuracy! > LOW_LOCATION_ACCURACY) {
          showToast(i18n(context, 'coords_common_location_lowaccuracy',
              parameters: [NumberFormat('0.0').format(locationData.accuracy)]));
        }

        LatLng _coords;
        if (locationData.latitude == null || locationData.longitude == null) {
          _coords = defaultCoordinate;
        } else {
          _coords = LatLng(locationData.latitude!, locationData.longitude!);
        }
        _pastedCoords = buildDefaultCoordinatesByFormat(_coords);
        _currentCoords = _pastedCoords;
        _setPastedCoordsFormat();

        _isOnLocationAccess = false;
        _setCurrentValueAndEmitOnChange();
      });
    });
  }
}
