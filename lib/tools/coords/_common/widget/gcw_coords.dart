import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/application/permissions/user_location.dart';
import 'package:gc_wizard/application/theme/theme.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_iconbutton.dart';
import 'package:gc_wizard/common_widgets/clipboard/gcw_clipboard.dart';
import 'package:gc_wizard/common_widgets/dividers/gcw_text_divider.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_dropdown.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_sign_dropdown.dart';
import 'package:gc_wizard/common_widgets/gcw_distance.dart';
import 'package:gc_wizard/common_widgets/gcw_snackbar.dart';
import 'package:gc_wizard/common_widgets/gcw_text.dart';
import 'package:gc_wizard/common_widgets/spinners/gcw_integer_spinner.dart';
import 'package:gc_wizard/common_widgets/text_input_formatters/gcw_integer_textinputformatter.dart';
import 'package:gc_wizard/common_widgets/text_input_formatters/gcw_minutesseconds_textinputformatter.dart';
import 'package:gc_wizard/common_widgets/text_input_formatters/wrapper_for_masktextinputformatter.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_double_textfield.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_integer_textfield.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/tools/coords/_common/formats/bosch/logic/bosch.dart';
import 'package:gc_wizard/tools/coords/_common/formats/dec/logic/dec.dart';
import 'package:gc_wizard/tools/coords/_common/formats/dmm/logic/dmm.dart';
import 'package:gc_wizard/tools/coords/_common/formats/dms/logic/dms.dart';
import 'package:gc_wizard/tools/coords/_common/formats/dutchgrid/logic/dutchgrid.dart';
import 'package:gc_wizard/tools/coords/_common/formats/gars/logic/gars.dart';
import 'package:gc_wizard/tools/coords/_common/formats/gausskrueger/logic/gauss_krueger.dart';
import 'package:gc_wizard/tools/coords/_common/formats/geo3x3/logic/geo3x3.dart';
import 'package:gc_wizard/tools/coords/_common/formats/geohash/logic/geohash.dart';
import 'package:gc_wizard/tools/coords/_common/formats/geohex/logic/geohex.dart';
import 'package:gc_wizard/tools/coords/_common/formats/lambert/logic/lambert.dart';
import 'package:gc_wizard/tools/coords/_common/formats/maidenhead/logic/maidenhead.dart';
import 'package:gc_wizard/tools/coords/_common/formats/makaney/logic/makaney.dart';
import 'package:gc_wizard/tools/coords/_common/formats/mapcode/logic/external_libs/ctrynams_short.dart';
import 'package:gc_wizard/tools/coords/_common/formats/mapcode/logic/external_libs/mapcode.dart';
import 'package:gc_wizard/tools/coords/_common/formats/mapcode/logic/mapcode.dart';
import 'package:gc_wizard/tools/coords/_common/formats/mercator/logic/mercator.dart';
import 'package:gc_wizard/tools/coords/_common/formats/mgrs_utm/logic/mgrs.dart';
import 'package:gc_wizard/tools/coords/_common/formats/natural_area_code/logic/natural_area_code.dart';
import 'package:gc_wizard/tools/coords/_common/formats/openlocationcode/logic/open_location_code.dart';
import 'package:gc_wizard/tools/coords/_common/formats/quadtree/logic/quadtree.dart';
import 'package:gc_wizard/tools/coords/_common/formats/reversewherigo_day1976/logic/reverse_wherigo_day1976.dart';
import 'package:gc_wizard/tools/coords/_common/formats/reversewherigo_waldmeister/logic/reverse_wherigo_waldmeister.dart';
import 'package:gc_wizard/tools/coords/_common/formats/s2cells_hilbert/logic/s2cells_hilbert.dart';
import 'package:gc_wizard/tools/coords/_common/formats/slippymap/logic/slippy_map.dart';
import 'package:gc_wizard/tools/coords/_common/formats/swissgrid/logic/swissgrid.dart';
import 'package:gc_wizard/tools/coords/_common/formats/swissgridplus/logic/swissgridplus.dart';
import 'package:gc_wizard/tools/coords/_common/formats/utm/logic/utm.dart';
import 'package:gc_wizard/tools/coords/_common/formats/xyz/logic/xyz.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinate_format.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinate_format_constants.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinate_format_definition.dart';
import 'package:gc_wizard/tools/coords/_common/widget/coordinate_text_formatter.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinates.dart';
import 'package:gc_wizard/tools/coords/_common/logic/default_coord_getter.dart';
import 'package:gc_wizard/tools/coords/_common/widget/coord_format_inputs/degrees_lat_textinputformatter.dart';
import 'package:gc_wizard/tools/coords/_common/widget/coord_format_inputs/degrees_lon_textinputformatter.dart';
import 'package:gc_wizard/tools/coords/_common/widget/gcw_coords_formatselector.dart';
import 'package:gc_wizard/tools/coords/_common/widget/gcw_coords_paste_button.dart';
import 'package:gc_wizard/utils/collection_utils.dart';
import 'package:gc_wizard/utils/complex_return_types.dart';
import 'package:gc_wizard/utils/constants.dart';
import 'package:gc_wizard/utils/data_type_utils/double_type_utils.dart';
import 'package:gc_wizard/utils/string_utils.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';

part 'package:gc_wizard/tools/coords/_common/formats/bosch/widget/gcw_coords_bosch.dart';
part 'package:gc_wizard/tools/coords/_common/formats/dec/widget/gcw_coords_dec.dart';
part 'package:gc_wizard/tools/coords/_common/formats/dmm/widget/gcw_coords_dmm.dart';
part 'package:gc_wizard/tools/coords/_common/formats/dms/widget/gcw_coords_dms.dart';
part 'package:gc_wizard/tools/coords/_common/formats/dutchgrid/widget/gcw_coords_dutchgrid.dart';
part 'package:gc_wizard/tools/coords/_common/formats/gausskrueger/widget/gcw_coords_gausskrueger.dart';
part 'package:gc_wizard/tools/coords/_common/formats/gars/widget/gcw_coords_gars.dart';
part 'package:gc_wizard/tools/coords/_common/formats/geo3x3/widget/gcw_coords_geo3x3.dart';
part 'package:gc_wizard/tools/coords/_common/formats/geo3x3/widget/geo3x3_textinputformatter.dart';
part 'package:gc_wizard/tools/coords/_common/formats/geohash/widget/gcw_coords_geohash.dart';
part 'package:gc_wizard/tools/coords/_common/formats/geohash/widget/geohash_textinputformatter.dart';
part 'package:gc_wizard/tools/coords/_common/formats/geohex/widget/gcw_coords_geohex.dart';
part 'package:gc_wizard/tools/coords/_common/formats/geohex/widget/geohex_textinputformatter.dart';
part 'package:gc_wizard/tools/coords/_common/formats/lambert/widget/gcw_coords_lambert.dart';
part 'package:gc_wizard/tools/coords/_common/formats/maidenhead/widget/gcw_coords_maidenhead.dart';
part 'package:gc_wizard/tools/coords/_common/formats/maidenhead/widget/maidenhead_textinputformatter.dart';
part 'package:gc_wizard/tools/coords/_common/formats/makaney/widget/gcw_coords_makaney.dart';
part 'package:gc_wizard/tools/coords/_common/formats/makaney/widget/makaney_textinputformatter.dart';
part 'package:gc_wizard/tools/coords/_common/formats/mapcode/widget/gcw_coords_mapcode.dart';
part 'package:gc_wizard/tools/coords/_common/formats/mercator/widget/gcw_coords_mercator.dart';
part 'package:gc_wizard/tools/coords/_common/formats/mgrs_utm/widget/gcw_coords_mgrs.dart';
part 'package:gc_wizard/tools/coords/_common/formats/mgrs_utm/widget/utm_lonzone_textinputformatter.dart';
part 'package:gc_wizard/tools/coords/_common/formats/natural_area_code/widget/gcw_coords_naturalareacode.dart';
part 'package:gc_wizard/tools/coords/_common/formats/natural_area_code/widget/naturalareacode_textinputformatter.dart';
part 'package:gc_wizard/tools/coords/_common/formats/openlocationcode/widget/gcw_coords_openlocationcode.dart';
part 'package:gc_wizard/tools/coords/_common/formats/quadtree/widget/gcw_coords_quadtree.dart';
part 'package:gc_wizard/tools/coords/_common/formats/reversewherigo_day1976/widget/gcw_coords_reversewherigo_day1976.dart';
part 'package:gc_wizard/tools/coords/_common/formats/reversewherigo_waldmeister/widget/gcw_coords_reversewherigo_waldmeister.dart';
part 'package:gc_wizard/tools/coords/_common/formats/s2cells_hilbert/widget/gcw_coords_s2cells_hilbert.dart';
part 'package:gc_wizard/tools/coords/_common/formats/slippymap/widget/gcw_coords_slippymap.dart';
part 'package:gc_wizard/tools/coords/_common/formats/swissgrid/widget/gcw_coords_swissgrid.dart';
part 'package:gc_wizard/tools/coords/_common/formats/swissgridplus/widget/gcw_coords_swissgridplus.dart';
part 'package:gc_wizard/tools/coords/_common/formats/utm/widget/gcw_coords_utm.dart';
part 'package:gc_wizard/tools/coords/_common/formats/xyz/widget/gcw_coords_xyz.dart';

class GCWCoords extends StatefulWidget {
  final void Function(BaseCoordinate?) onChanged;
  final LatLng? coordinates;
  final CoordinateFormat coordsFormat;
  final String? title;
  final bool suppressTopSpace;

  const GCWCoords(
      {Key? key,
      this.title,
      required this.onChanged,
      this.coordinates,
      required this.coordsFormat,
      this.suppressTopSpace = false
      })
      : super(key: key);

  @override
  _GCWCoordsState createState() => _GCWCoordsState();
}

class _GCWCoordsState extends State<GCWCoords> {
  BaseCoordinate? _currentCoords = defaultBaseCoordinate;
  var _currentCoordinateFormat = defaultCoordinateFormat;
  bool _hasSetCoords = false;
  bool _resetCoords = false;

  Widget? _currentWidget;

  final _location = Location();
  bool _isOnLocationAccess = false;

  @override
  void initState() {
    super.initState();

    if (widget.coordinates != null) {
      _hasSetCoords = true;
      _resetCoords = true;
    }

    _currentCoords = buildCoordinate(widget.coordsFormat, widget.coordinates ?? defaultCoordinate);
    _currentCoordinateFormat = widget.coordsFormat;
  }

  BaseCoordinate _buildCoord(CoordinateFormat format) {
    if (_hasSetCoords && _currentCoords?.toLatLng() != null) {
      return buildCoordinate(format, _currentCoords!.toLatLng()!);
    } else {
      return buildUninitializedCoordinateByFormat(format);
    }
  }

  @override
  Widget build(BuildContext context) {
    Column _widget = Column(
      children: <Widget>[
        GCWTextDivider(
            text: widget.title ?? '',
            trailing: _buildTrailingButtons(IconButtonSize.SMALL),
            suppressBottomSpace: true,
            suppressTopSpace: widget.suppressTopSpace
        ),
        _buildInputFormatSelector()
      ],
    );

    var rawWidget = allCoordinateWidgetInfos
        .firstWhereOrNull((GCWCoordWidgetInfo entry) => entry.type == _currentCoordinateFormat.type);
    rawWidget ??= allCoordinateWidgetInfos.first;

    _currentWidget = rawWidget.mainWidget(
        initialize: _resetCoords,
        coordinates: _currentCoords,
        onChanged: (newValue) {
          setState(() {
            _setCurrentValueAndEmitOnChange(newValue);
          });
        });

    _resetCoords = false;
    _widget.children.add(_currentWidget!);

    return _widget;
  }

  GCWCoordsFormatSelector _buildInputFormatSelector() {
    return GCWCoordsFormatSelector(
      format: _currentCoordinateFormat,
      input: true,
      onChanged: (CoordinateFormat newFormat) {
        setState(() {
          if (equalsCoordinateFormats(_currentCoordinateFormat, newFormat)) {
            return;
          }

          _currentCoordinateFormat = newFormat;
          if (_currentCoords?.format.type != newFormat.type) {
            _currentCoords = _buildCoord(newFormat);
          } else if (_currentCoords != null && _currentCoords?.format.subtype != newFormat.subtype) {
            _currentCoords!.format.subtype = newFormat.subtype;
          }

          _resetCoords = true;
          _setCurrentValueAndEmitOnChange(_currentCoords);

          FocusScope.of(context).requestFocus(FocusNode()); //Release focus from previously edited field
        });
      },
    );
  }

  Row _buildTrailingButtons(IconButtonSize size) {
    return Row(
      children: [
        GCWIconButton(
            icon: Icons.copy,
            size: IconButtonSize.SMALL,
            onPressed: () {
              var _currentCoordsLatLng = _currentCoords?.toLatLng();
              insertIntoGCWClipboard(
                  context,
                  _currentCoordsLatLng != null
                      ? formatCoordOutput(_currentCoordsLatLng, _currentCoordinateFormat, defaultEllipsoid, false)
                      : '');
            }),
        Container(width: DEFAULT_MARGIN),
        GCWIconButton(
          icon: _isOnLocationAccess ? Icons.refresh : Icons.location_on,
          size: size,
          onPressed: () {
            _setUserLocationCoords();
          },
        ),
        Container(width: DEFAULT_MARGIN),
        GCWCoordsPasteButton(size: size, onPasted: _setCoords),
      ],
    );
  }

  void _setCurrentValueAndEmitOnChange(BaseCoordinate? newValue) {
    _currentCoords = newValue;

    widget.onChanged(_currentCoords);
  }

  void _setCoords(List<BaseCoordinate> pastedCoords) {
    if (pastedCoords.isEmpty) return;

    var _coordsForCurrentFormat =
        pastedCoords.firstWhereOrNull((BaseCoordinate coords) => coords.format.type == _currentCoordinateFormat.type);
    _coordsForCurrentFormat ??= pastedCoords.first;
    if (isCoordinateFormatWithSubtype(_coordsForCurrentFormat.format.type)) {
      _coordsForCurrentFormat.format.subtype =
          defaultCoordinateFormatSubtypeForFormat(_coordsForCurrentFormat.format.type);
    }

    _currentCoords = _coordsForCurrentFormat;
    _currentCoordinateFormat = _coordsForCurrentFormat.format;
    _hasSetCoords = true;
    _resetCoords = true;

    _setCurrentValueAndEmitOnChange(_currentCoords);
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
        showSnackBar(i18n(context, 'coords_common_location_permissiondenied'), context);

        return;
      }

      _location.getLocation().then((LocationData locationData) {
        if (locationData.accuracy == null || locationData.accuracy! > LOW_LOCATION_ACCURACY) {
          showSnackBar(
              i18n(context, 'coords_common_location_lowaccuracy',
                  parameters: [NumberFormat('0.0').format(locationData.accuracy)]),
              context);
        }

        LatLng _coords;
        if (locationData.latitude == null || locationData.longitude == null) {
          _coords = defaultCoordinate;
        } else {
          _coords = LatLng(locationData.latitude!, locationData.longitude!);
        }
        _currentCoords = buildCoordinate(_currentCoordinateFormat, _coords);
        _hasSetCoords = true;
        _resetCoords = true;

        _isOnLocationAccess = false;
        _setCurrentValueAndEmitOnChange(_currentCoords);
      });
    });
  }
}

abstract class _GCWCoordWidget extends StatefulWidget {
  final bool initialize;
  final BaseCoordinate? coordinates;
  final void Function(BaseCoordinate?) onChanged;

  const _GCWCoordWidget({super.key, this.initialize = false, required this.coordinates, required this.onChanged});
}

abstract class GCWCoordWidgetInfo {
  CoordinateFormatKey get type;
  String get i18nKey;
  String get name;
  String get example;

  _GCWCoordWidget mainWidget(
      {Key? key,
      required void Function(BaseCoordinate?) onChanged,
      required BaseCoordinate? coordinates,
      bool? initialize});
}

abstract class GCWCoordWidgetWithSubtypeInfo extends GCWCoordWidgetInfo {
  CoordinateFormatKey get subtype;
  List<_GCWCoordWidgetSubtypeInfo> get subtypes;

  Widget inputWidget(
      {required BuildContext context,
      required CoordinateFormatKey value,
      required void Function(CoordinateFormatKey) onChanged}) {
    return _buildSubtypeWidget(context: context, value: value, onChanged: onChanged);
  }

  Widget outputWidget(
      {required BuildContext context,
      required CoordinateFormatKey value,
      required void Function(CoordinateFormatKey) onChanged}) {
    return _buildSubtypeWidget(context: context, value: value, onChanged: onChanged);
  }

  Widget _buildSubtypeWidget(
      {required BuildContext context,
      required CoordinateFormatKey value,
      required void Function(CoordinateFormatKey) onChanged});
}

class _GCWCoordWidgetSubtypeInfo {
  final CoordinateFormatKey type;
  final String name;

  const _GCWCoordWidgetSubtypeInfo(this.type, this.name);
}

GCWCoordWidgetInfo? coordinateWidgetInfoByType(CoordinateFormatKey type) {
  return allCoordinateWidgetInfos.firstWhereOrNull((format) => format.type == type);
}

GCWCoordWidgetInfo? coordinateWidgetInfoByByPersistenceKey(String key) {
  var type = coordinateFormatDefinitionByPersistenceKey(key)?.type;
  if (type != null) {
    return coordinateWidgetInfoByType(type);
  }
  return null;
}

_GCWCoordWidgetSubtypeInfo? coordinateWidgetSubtypeInfoByType(
    GCWCoordWidgetInfo widgetInfo, CoordinateFormatKey subtype) {
  if (widgetInfo is GCWCoordWidgetWithSubtypeInfo) {
    return widgetInfo.subtypes.firstWhere((subtypeInfo) => subtypeInfo.type == subtype);
  } else {
    return null;
  }
}

var allCoordinateWidgetInfos = [
  _GCWCoordWidgetInfoDMS(),
  _GCWCoordWidgetInfoDMM(),
  _GCWCoordWidgetInfoDEC(),
  _GCWCoordWidgetInfoUTM(),
  _GCWCoordWidgetInfoMGRS(),
  _GCWCoordWidgetInfoXYZ(),
  _GCWCoordWidgetInfoSwissGrid(),
  _GCWCoordWidgetInfoSwissGridPlus(),
  _GCWCoordWidgetInfoGaussKrueger(),
  _GCWCoordWidgetInfoLambert(),
  _GCWCoordWidgetInfoDutchGrid(),
  _GCWCoordWidgetInfoMaidenhead(),
  _GCWCoordWidgetInfoMercator(),
  _GCWCoordWidgetInfoQuadtree(),
  _GCWCoordWidgetInfoNaturalAreaCode(),
  _GCWCoordWidgetInfoOpenLocationCode(),
  _GCWCoordWidgetInfoSlippyMap(),
  _GCWCoordWidgetInfoReverseWherigoWaldmeister(),
  _GCWCoordWidgetInfoReverseWherigoDay1976(),
  _GCWCoordWidgetInfoGeohash(),
  _GCWCoordWidgetInfoBosch(),
  _GCWCoordWidgetInfoMakaney(),
  _GCWCoordWidgetInfoGeoHex(),
  _GCWCoordWidgetInfoGeo3x3(),
  _GCWCoordWidgetInfoMapCode(),
  _GCWCoordWidgetInfoGARS(),
  _GCWCoordWidgetInfoS2CellsHilbert()
];
