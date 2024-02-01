import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/application/permissions/user_location.dart';
import 'package:gc_wizard/application/theme/theme.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_iconbutton.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_paste_button.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_submit_button.dart';
import 'package:gc_wizard/tools/coords/_common/widget/gcw_coords_output/gcw_coords_output.dart';
import 'package:gc_wizard/tools/coords/_common/widget/gcw_coords_output/gcw_coords_outputformat.dart';
import 'package:gc_wizard/common_widgets/dialogs/gcw_dialog.dart';
import 'package:gc_wizard/common_widgets/dividers/gcw_text_divider.dart';
import 'package:gc_wizard/common_widgets/gcw_date_picker.dart';
import 'package:gc_wizard/common_widgets/gcw_snackbar.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_columned_multiline_output.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_twooptions_switch.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_double_textfield.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_integer_textfield.dart';
import 'package:gc_wizard/tools/coords/_common/widget/coord_format_inputs/degrees_lat_textinputformatter.dart';
import 'package:gc_wizard/tools/coords/_common/widget/coord_format_inputs/degrees_lon_textinputformatter.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinate_text_formatter.dart';
import 'package:gc_wizard/tools/coords/_common/logic/default_coord_getter.dart';
import 'package:gc_wizard/tools/coords/geohashing/logic/geohashing.dart' as geohashing;
import 'package:gc_wizard/tools/coords/map_view/logic/map_geometries.dart';
import 'package:gc_wizard/utils/constants.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';

class Geohashing extends StatefulWidget {
  const Geohashing({Key? key}) : super(key: key);

  @override
  _GeohashingState createState() => _GeohashingState();
}

class _GeohashingState extends State<Geohashing> {
  late TextEditingController _LongitudeController;
  late TextEditingController _LatitudeController;
  late TextEditingController _DowJonesIndexController;
  late TextEditingController _yearController;
  late TextEditingController _monthController;
  late TextEditingController _dayController;
  late DateTime _currentDate;

  final _location = Location();
  bool _isOnLocationAccess = false;

  var _currentLatitude = defaultIntegerText;
  var _currentLongitude = defaultIntegerText;
  var _currentOnline = GCWSwitchPosition.left;
  var _currentDowJonesIndex = 0.0;

  var _currentOutputFormat = defaultCoordinateFormat;
  final _currentMapPoints = <GCWMapPoint>[];
  var _currentOutput = <String>[];
  geohashing.Geohashing? _geohashing;

  @override
  void initState() {
    super.initState();

    DateTime now = DateTime.now();
    _currentDate = DateTime(now.year, now.month, now.day);

    _LatitudeController = TextEditingController(text: _currentLatitude.text);
    _LongitudeController = TextEditingController(text: _currentLongitude.text);
    _DowJonesIndexController = TextEditingController();

    _yearController = TextEditingController(text: _currentDate.year.toString());
    _monthController = TextEditingController(text: _currentDate.month.toString());
    _dayController = TextEditingController(text: _currentDate.day.toString());
  }

  @override
  void dispose() {
    _LongitudeController.dispose();
    _LatitudeController.dispose();

    _yearController.dispose();
    _monthController.dispose();
    _dayController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      GCWTextDivider(text: i18n(context, 'common_date_format_ymd')),
      GCWDatePicker(
        date: _currentDate,
        yearController: _yearController,
        monthController: _monthController,
        dayController: _dayController,
        onChanged: (value) {
          setState(() {
            _currentDate = value;
          });
        },
      ),
      GCWTextDivider(text: i18n(context, 'common_location'), trailing: _buildTrailingButtons(IconButtonSize.SMALL)),
      Row(children: [
        Expanded(
          child: GCWIntegerTextField(
              hintText: i18n(context, 'coords_common_latitude'),
              textInputFormatter: DegreesLatTextInputFormatter(allowNegativeValues: true),
              controller: _LatitudeController,
              onChanged: (ret) {
                setState(() {
                  _currentLatitude = ret;
                });
              }),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: GCWIntegerTextField(
              hintText: i18n(context, 'coords_common_longitude'),
              textInputFormatter: DegreesLonTextInputFormatter(allowNegativeValues: true),
              controller: _LongitudeController,
              onChanged: (ret) {
                setState(() {
                  _currentLongitude = ret;
                });
              }),
        )
      ]),
      GCWTextDivider(text: i18n(context, 'geohashing_dow_jones_index')),
      GCWTwoOptionsSwitch(
          leftValue: i18n(context, 'geohashing_loaddata_manual'),
          rightValue: i18n(context, 'geohashing_loaddata_internet'),
          title: i18n(context, 'geohashing_loaddata'),
          value: _currentOnline,
          onChanged: (value) {
            if (value == GCWSwitchPosition.right) {
              showGCWDialog(context, i18n(context, 'geohashing_dow_jones_index'),
                  SizedBox(width: 300, height: 130, child: Text(i18n(context, 'geohashing_dow_jones_index_online'))), [
                GCWDialogButton(
                  text: i18n(context, 'common_ok'),
                  onPressed: () {
                    setState(() {
                      _currentOnline = value;
                    });
                  },
                )
              ]);
            } else {
              setState(() {
                _currentOnline = value;
              });
            }
          }),
      if (_currentOnline == GCWSwitchPosition.left)
        GCWDoubleTextField(
            min: 0,
            controller: _DowJonesIndexController,
            hintText: i18n(context, 'geohashing_dow_jones_index') +
                (_W30RuleNecessary() ? ' (' + i18n(context, 'geohashing_dow_jones_index_w30_rule') + ')' : ''),
            onChanged: (value) {
              setState(() {
                _currentDowJonesIndex = value.value;
              });
            }),
      GCWCoordsOutputFormat(
        coordFormat: _currentOutputFormat,
        onChanged: (value) {
          setState(() {
            _currentOutputFormat = value;
          });
        },
      ),
      GCWSubmitButton(
        onPressed: () {
          setState(() {
            _calculateOutput();
          });
        },
      ),
      _buildOutput()
    ]);
  }

  Widget _buildOutput() {
    var outputLocation = GCWCoordsOutput(
      outputs: _currentOutput,
      points: _currentMapPoints,
    );
    Widget? extendedOutput;

    if (_geohashing != null) {
      var rows = [
        [
          i18n(context, 'geohashing_dow_jones_index'),
          (_geohashing!.dowJonesIndex > 0) ? _geohashing!.dowJonesIndex.toString() : ''
        ],
        [i18n(context, 'geohashing_title'), _geohashing.toString()],
      ];

      extendedOutput = GCWColumnedMultilineOutput(data: rows);
    }
    return Column(children: [outputLocation, extendedOutput ?? Container()]);
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
        GCWPasteButton(iconSize: size, onSelected: _setCoords)
      ],
    );
  }

  void _setCoords(String pastedValue) {
    if (pastedValue.isEmpty) return;

    var _coords = geohashing.Geohashing.parse(pastedValue);
    if (_coords == null) return;

    setState(() {
      _currentDate = _coords.date;
      _LongitudeController.text = _coords.longitude.toString();
      _LatitudeController.text = _coords.latitude.toString();

      _yearController.text = _currentDate.year.toString();
      _monthController.text = _currentDate.month.toString();
      _dayController.text = _currentDate.day.toString();
    });
  }

  void _calculateOutput() {
    _currentMapPoints.clear();
    _currentOutput.clear();

    _geohashing = _buildGeohashing();
    if (_geohashing!.errorCode == geohashing.ErrorCode.futureDate) {
      showSnackBar(i18n(context, 'geohashing_future_date'), context);
    }

    _geohashing!.toLatLng().then((value) {
      if (value != null) {
        var point = GCWMapPoint(
            point: value,
            markerText: i18n(context, 'coords_common_coordinate'),
            coordinateFormat: _currentOutputFormat);

        _currentMapPoints.add(point);

        _currentOutput = [value].map((LatLng coord) {
          return formatCoordOutput(coord, _currentOutputFormat, defaultEllipsoid);
        }).toList();

        if (_currentOnline == GCWSwitchPosition.right) {
          _currentDowJonesIndex = _geohashing!.dowJonesIndex;
          _DowJonesIndexController.text = _currentDowJonesIndex.toString();
        }
        setState(() {});
      }
    });
  }

  bool _W30RuleNecessary() {
    return geohashing.w30RuleNecessary(_buildGeohashing());
  }

  geohashing.Geohashing _buildGeohashing() {
    return geohashing.Geohashing(_currentDate, _currentLatitude.value, _currentLongitude.value,
        dowJonesIndex: _currentOnline == GCWSwitchPosition.right ? 0 : _currentDowJonesIndex);
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
        if (locationData.latitude == null || locationData.longitude == null) {
          _currentLatitude.value = defaultCoordinate.latitude.truncate();
          _currentLongitude.value = defaultCoordinate.longitude.truncate();
        }
        _currentLatitude.value = locationData.latitude!.truncate();
        _currentLongitude.value = locationData.longitude!.truncate();

        _LongitudeController = TextEditingController(text: _currentLongitude.value.toString());
        _LatitudeController = TextEditingController(text: _currentLatitude.value.toString());

        _isOnLocationAccess = false;
      });
    });
  }
}
