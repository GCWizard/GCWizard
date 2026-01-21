import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';

import 'package:gc_wizard/application/theme/theme.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_button.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_submit_button.dart';
import 'package:gc_wizard/common_widgets/dividers/gcw_text_divider.dart';
import 'package:gc_wizard/common_widgets/gcw_expandable.dart';
import 'package:gc_wizard/common_widgets/gcw_text.dart';
import 'package:gc_wizard/common_widgets/gcw_toolbar.dart';
import 'package:gc_wizard/common_widgets/image_viewers/gcw_imageview.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_columned_multiline_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_output_text.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_twooptions_switch.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinates.dart';
import 'package:gc_wizard/tools/coords/_common/logic/default_coord_getter.dart';
import 'package:gc_wizard/tools/coords/_common/widget/gcw_coords.dart';
import 'package:gc_wizard/tools/coords/map_view/logic/map_geometries.dart';
import 'package:gc_wizard/tools/coords/map_view/widget/gcw_mapview.dart';
import 'package:gc_wizard/utils/file_utils/gcw_file.dart';
import 'package:gc_wizard/tools/science_and_technology/triangle/logic/triangle.dart';
import 'package:latlong2/latlong.dart';

class Triangle extends StatefulWidget {
  const Triangle({super.key});

  @override
  TriangleState createState() => TriangleState();
}

class TriangleState extends State<Triangle> {
  GCWSwitchPosition _currentMode = GCWSwitchPosition.left;

  var _currentCoordsA = defaultBaseCoordinate;
  var _currentCoordsB = defaultBaseCoordinate;
  var _currentCoordsC = defaultBaseCoordinate;

  late TextEditingController _AxController;
  late TextEditingController _AyController;
  late TextEditingController _BxController;
  late TextEditingController _ByController;
  late TextEditingController _CxController;
  late TextEditingController _CyController;

  var _currentAxInput = '';
  var _currentAyInput = '';
  var _currentBxInput = '';
  var _currentByInput = '';
  var _currentCxInput = '';
  var _currentCyInput = '';

  late List<List<Object?>> _outputBasicData;
  late List<List<Object?>> _outputDataPointsSidesMidPoint;
  late List<List<Object?>> _outputDataPointsAltitudeBasePoints;
  late List<List<Object?>> _outputPoints;
  late List<List<Object?>> _outputCircles;

  late Angles _angles;
  late Sides _sides;
  late Sides _medians;
  late Sides _altitudes;
  late Sides _anglebisector;
  late XYPoint _A;
  late XYPoint _B;
  late XYPoint _C;
  late XYPoint _centroid;
  late XYPoint _orthocenter;
  late XYCircle _innercircle;
  late XYCircle _outercircle;
  late XYCircle _feuerbachcircle;
  late XYPoint _gergonne;
  late XYPoint _lemoine;
  late XYPoint _nagel;
  late XYPoint _napoleon1;
  late XYPoint _napoleon2;
  late XYPoint _spieker;
  late XYPoint _feuerbach;
  late XYPoint _mitten;
  late List<XYCircle> _exCircle;
  late List<XYPoint> _sidesMidPoint;
  late List<XYPoint> _altitudesBasePoint;

  late Angles _anglesMap;
  late Sides _sidesMap;
  late Sides _mediansMap;
  late Sides _altitudesMap;
  late Sides _anglebisectorMap;
  late LatLng _AMap;
  late LatLng _BMap;
  late LatLng _CMap;
  late LatLng _centroidMap;
  late LatLng _orthocenterMap;
  late XYCircle _innercircleMap;
  late XYCircle _outercircleMap;
  late XYCircle _feuerbachcircleMap;
  late LatLng _gergonneMap;
  late LatLng _lemoineMap;
  late LatLng _nagelMap;
  late LatLng _napoleon1Map;
  late LatLng _napoleon2Map;
  late LatLng _spiekerMap;
  late LatLng _feuerbachMap;
  late LatLng _mittenMap;
  late List<XYCircle> _exCircleMap;
  late List<LatLng> _sidesMidPointMap;
  late List<LatLng> _altitudesBasePointMap;

  late List<GCWMapPoint> _points;
  late List<GCWMapPolyline> _polylines;

  Uint8List _triangleImage = Uint8List.fromList([]);

  bool _isCalculatedDataXY = false;
  bool _isCalculatedDataMap = false;
  bool _isCalculatedImage = false;

  @override
  void initState() {
    super.initState();
    _AxController = TextEditingController(text: _currentAxInput);
    _AyController = TextEditingController(text: _currentAyInput);
    _BxController = TextEditingController(text: _currentBxInput);
    _ByController = TextEditingController(text: _currentByInput);
    _CxController = TextEditingController(text: _currentCxInput);
    _CyController = TextEditingController(text: _currentCyInput);
  }

  @override
  void dispose() {
    _AxController.dispose();
    _AyController.dispose();
    _BxController.dispose();
    _ByController.dispose();
    _CxController.dispose();
    _CyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      GCWTwoOptionsSwitch(
        leftValue: i18n(context, 'triangle_input_xy'),
        rightValue: i18n(context, 'triangle_input_coordinate'),
        value: _currentMode,
        onChanged: (value) {
          setState(() {
            _currentMode = value;
          });
        },
      ),
      _currentMode == GCWSwitchPosition.left
          ? _buildInputWidgetABC()
          : _buildInputWidgetMap(),
      GCWSubmitButton(
        onPressed: () {
          setState(() {
            if (_allBasicDataAvailable()) {
              _createAdditionalData();
              _isCalculatedImage = false;
            }
          });
        },
      ),
      GCWTextDivider(text: i18n(context, 'common_output')),
      _buildOutput(context)
    ]);
  }

  Widget _buildInputWidgetMap() {
    return Column(
      children: [
        GCWCoords(
          title: 'A',
          coordsFormat: _currentCoordsA.format,
          onChanged: (ret) {
            setState(() {
              if (ret != null) {
                _currentCoordsA = ret;
              }
            });
          },
        ),
        GCWCoords(
          title: 'B',
          coordsFormat: _currentCoordsB.format,
          onChanged: (ret) {
            setState(() {
              if (ret != null) {
                _currentCoordsB = ret;
              }
            });
          },
        ),
        GCWCoords(
          title: 'C',
          coordsFormat: _currentCoordsC.format,
          onChanged: (ret) {
            setState(() {
              if (ret != null) {
                _currentCoordsC = ret;
              }
            });
          },
        ),
      ],
    );
  }

  Widget _buildInputWidgetABC() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
                child: Container(
              padding: const EdgeInsets.only(right: DEFAULT_MARGIN),
              child: const GCWText(
                text: 'A',
              ),
            )),
            Expanded(
                child: Container(
              padding: const EdgeInsets.only(
                  left: DEFAULT_MARGIN, right: DEFAULT_MARGIN),
              child: GCWTextField(
                hintText: 'X',
                controller: _AxController,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp('[0-9.-]')),
                ],
                onChanged: (text) {
                  setState(() {
                    _currentAxInput = text;
                  });
                },
              ),
            )),
            Expanded(
                child: Container(
              padding: const EdgeInsets.only(left: DEFAULT_MARGIN),
              child: GCWTextField(
                hintText: 'Y',
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp('[0-9.-]')),
                ],
                controller: _AyController,
                onChanged: (text) {
                  setState(() {
                    _currentAyInput = text;
                  });
                },
              ),
            )),
          ],
        ),
        Row(
          children: [
            Expanded(
                child: Container(
              padding: const EdgeInsets.only(right: DEFAULT_MARGIN),
              child: const GCWText(
                text: 'B',
              ),
            )),
            Expanded(
                child: Container(
              padding: const EdgeInsets.only(
                  left: DEFAULT_MARGIN, right: DEFAULT_MARGIN),
              child: GCWTextField(
                hintText: 'X',
                controller: _BxController,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp('[0-9.-]')),
                ],
                onChanged: (text) {
                  setState(() {
                    _currentBxInput = text;
                  });
                },
              ),
            )),
            Expanded(
                child: Container(
              padding: const EdgeInsets.only(left: DEFAULT_MARGIN),
              child: GCWTextField(
                hintText: 'Y',
                controller: _ByController,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp('[0-9.-]')),
                ],
                onChanged: (text) {
                  setState(() {
                    _currentByInput = text;
                  });
                },
              ),
            )),
          ],
        ),
        Row(
          children: [
            Expanded(
                child: Container(
              padding: const EdgeInsets.only(right: DEFAULT_MARGIN),
              child: const GCWText(
                text: 'C',
              ),
            )),
            Expanded(
                child: Container(
              padding: const EdgeInsets.only(
                  left: DEFAULT_MARGIN, right: DEFAULT_MARGIN),
              child: GCWTextField(
                hintText: 'X',
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp('[0-9.-]')),
                ],
                controller: _CxController,
                onChanged: (text) {
                  setState(() {
                    _currentCxInput = text;
                  });
                },
              ),
            )),
            Expanded(
                child: Container(
              padding: const EdgeInsets.only(left: DEFAULT_MARGIN),
              child: GCWTextField(
                hintText: 'Y',
                controller: _CyController,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp('[0-9.-]')),
                ],
                onChanged: (text) {
                  setState(() {
                    _currentCyInput = text;
                  });
                },
              ),
            )),
          ],
        ),
      ],
    );
  }

  Widget _buildOutput(BuildContext context) {
    if (_currentMode == GCWSwitchPosition.left) {
      return _buildOutputXY(context);
    } else {
      return _buildOutputMap(context);
    }
  }

  Widget _buildOutputMap(BuildContext context) {
    if (_isCalculatedDataMap) {
      return Column(children: <Widget>[
        GCWColumnedMultilineOutput(
            data: [
              ['A', buildCoordinate(_currentCoordsA.format, _AMap, defaultEllipsoid).toString(6).replaceAll('\n', '   '),],
              ['B', buildCoordinate(_currentCoordsB.format, _BMap, defaultEllipsoid).toString(6).replaceAll('\n', '   '),],
              ['C', buildCoordinate(_currentCoordsC.format, _CMap, defaultEllipsoid).toString(6).replaceAll('\n', '   '),],
            ],
            flexValues: const [2, 6],
            copyAll: true),
        GCWColumnedMultilineOutput(
            data: _outputBasicData,
            flexValues: const [2, 1, 1, 1],
            copyAll: true),
        GCWTextDivider(
            suppressTopSpace: false,
            text: i18n(context, 'triangle_output_sidesmidpoint')),
        GCWColumnedMultilineOutput(
            data: _outputDataPointsSidesMidPoint,
            flexValues: const [4, 6],
            copyAll: true),
        GCWExpandableTextDivider(
          text: i18n(context, 'triangle_output_points'),
          suppressTopSpace: false,
          child: GCWColumnedMultilineOutput(
              data: _outputPoints,
              flexValues: const [4, 6],
              copyAll: true),
        ),
        GCWExpandableTextDivider(
          text: i18n(context, 'triangle_output_circles'),
          suppressTopSpace: false,
          child: GCWColumnedMultilineOutput(
              data: _outputCircles,
              flexValues: const [4, 6, 2],
              copyAll: true),
        ),
        GCWToolBar(
          children: [
            GCWButton(
              text: i18n(context, 'coords_show_on_map'),
              onPressed: () {
                openInMap(context, List<GCWMapPoint>.from(_points),
                    mapPolylines: List<GCWMapPolyline>.from(_polylines));
              },
            ),
            GCWButton(
              text: i18n(context, 'coords_show_on_openmap'),
              onPressed: () {
                openInMap(context, List<GCWMapPoint>.from(_points),
                    isCommonMap: true,
                    mapPolylines: List<GCWMapPolyline>.from(_polylines));
              },
            )
          ],
        )
      ]);
    } else {
      return GCWOutputText(
        text: i18n(context, 'triangle_hint_data_missing'),
      );
    }
  }

  Widget _buildOutputXY(BuildContext context) {
    if (_isCalculatedDataXY) {
      return Column(children: <Widget>[
        Column(
          children: <Widget>[
            GCWColumnedMultilineOutput(
                data: _outputBasicData,
                flexValues: const [2, 1, 1, 1],
                copyAll: true),
            GCWTextDivider(
                suppressTopSpace: false,
                text: i18n(context, 'triangle_output_sidesmidpoint')),
            GCWColumnedMultilineOutput(
                data: _outputDataPointsSidesMidPoint,
                flexValues: const [2, 1, 1, 1],
                copyAll: true),
            GCWTextDivider(
                suppressTopSpace: false,
                text: i18n(context, 'triangle_output_altitudesbasepoint')),
            GCWColumnedMultilineOutput(
                data: _outputDataPointsAltitudeBasePoints,
                flexValues: const [2, 1, 1, 1],
                copyAll: true),
          ],
        ),
        GCWExpandableTextDivider(
          text: i18n(context, 'triangle_output_points'),
          suppressTopSpace: false,
          child: GCWColumnedMultilineOutput(
              data: _outputPoints,
              flexValues: const [2, 1, 1, 1],
              copyAll: true),
        ),
        GCWExpandableTextDivider(
          text: i18n(context, 'triangle_output_circles'),
          suppressTopSpace: false,
          child: GCWColumnedMultilineOutput(
              data: _outputCircles,
              flexValues: const [2, 1, 1, 1],
              copyAll: true),
        ),
        _buildGraphicOutput(),
      ]);
    } else {
      return GCWOutputText(
        text: i18n(context, 'triangle_hint_data_missing'),
      );
    }
  }

  bool _allBasicDataAvailable() {
    if (_currentMode == GCWSwitchPosition.left) {
      return (double.tryParse(_currentAxInput) != null &&
          double.tryParse(_currentAyInput) != null &&
          double.tryParse(_currentBxInput) != null &&
          double.tryParse(_currentByInput) != null &&
          double.tryParse(_currentCxInput) != null &&
          double.tryParse(_currentCyInput) != null);
    } else {
      return (_currentCoordsA != defaultBaseCoordinate &&
          _currentCoordsB != defaultBaseCoordinate &&
          _currentCoordsC != defaultBaseCoordinate);
    }
  }

  void _createAdditionalData() {
    if (_currentMode == GCWSwitchPosition.left) {
      _createAdditionalDataXY();
    } else {
      _createAdditionalDataMap();
    }
  }

  void _createAdditionalDataXY() {
    _isCalculatedDataXY = true;

    _A = XYPoint(
      x: double.parse(_currentAxInput),
      y: double.parse(_currentAyInput),
    );
    _B = XYPoint(
      x: double.parse(_currentBxInput),
      y: double.parse(_currentByInput),
    );
    _C = XYPoint(
      x: double.parse(_currentCxInput),
      y: double.parse(_currentCyInput),
    );

    _angles = triangleAnglesXY(_A, _B, _C)!;
    _sides = triangleSidesXY(_A, _B, _C);
    _medians = triangleMediansXY(_A, _B, _C);
    _altitudes = triangleAltitudesXY(_A, _B, _C);
    _anglebisector = triangleAngleBiSectorsXY(_A, _B, _C);
    _centroid = triangleCentroidXY(_A, _B, _C);
    _orthocenter = triangleOrthocenterXY(_A, _B, _C);
    _innercircle = triangleInCircleXY(_A, _B, _C);
    _outercircle = triangleCircumCircleXY(_A, _B, _C);
    _feuerbachcircle = triangleFeuerbachCircleXY(_A, _B, _C);
    _gergonne = triangleGergonne(_A, _B, _C);
    _lemoine = triangleLemoine(_A, _B, _C);
    _nagel = triangleNagel(_A, _B, _C);
    _napoleon1 = triangleNapoleonOuter(_A, _B, _C);
    _napoleon2 = triangleNapoleonInner(_A, _B, _C);
    _spieker = triangleSpieker(_A, _B, _C);
    _feuerbach = triangleFeuerbach(_A, _B, _C);
    _mitten = triangleMitten(_A, _B, _C);
    _exCircle = triangleExCirclesXY(_A, _B, _C);
    _sidesMidPoint = triangleSidesMidPointsXY(_A, _B, _C);
    _altitudesBasePoint = triangleAltitudesBasePointsXY(_A, _B, _C);

    _outputBasicData = [
      [
        i18n(context, 'triangle_output_sides'),
        _sides.a.toStringAsFixed(3),
        _sides.b.toStringAsFixed(3),
        _sides.c.toStringAsFixed(3)
      ],
      [
        i18n(context, 'triangle_output_angles'),
        _angles.alpha.toStringAsFixed(3),
        _angles.beta.toStringAsFixed(3),
        _angles.gamma.toStringAsFixed(3)
      ],
      [
        i18n(context, 'triangle_output_altitudes'),
        _altitudes.a.toStringAsFixed(3),
        _altitudes.b.toStringAsFixed(3),
        _altitudes.c.toStringAsFixed(3)
      ],
      [
        i18n(context, 'triangle_output_medians'),
        _medians.a.toStringAsFixed(3),
        _medians.b.toStringAsFixed(3),
        _medians.c.toStringAsFixed(3)
      ],
      [
        i18n(context, 'triangle_output_anglebisector'),
        _anglebisector.a.toStringAsFixed(3),
        _anglebisector.b.toStringAsFixed(3),
        _anglebisector.c.toStringAsFixed(3)
      ],
      [
        i18n(context, 'triangle_output_circumference'),
        triangleCircumferenceXY(_A, _B, _C).toStringAsFixed(3),
        null,
        null
      ],
      [
        i18n(context, 'triangle_output_area'),
        triangleAreaXY(_A, _B, _C).toStringAsFixed(3),
        null,
        null
      ],
    ];
    _outputDataPointsSidesMidPoint = [
      [
        null,
        i18n(context, 'triangle_output_x'),
        i18n(context, 'triangle_output_y'),
        null
      ],
      [
        'a',
        _sidesMidPoint[0].x.toStringAsFixed(3),
        _sidesMidPoint[0].y.toStringAsFixed(3),
        null,
      ],
      [
        'b',
        _sidesMidPoint[1].x.toStringAsFixed(3),
        _sidesMidPoint[1].y.toStringAsFixed(3),
        null,
      ],
      [
        'c',
        _sidesMidPoint[2].x.toStringAsFixed(3),
        _sidesMidPoint[2].y.toStringAsFixed(3),
        null,
      ],
    ];
    _outputDataPointsAltitudeBasePoints = [
      [
        null,
        i18n(context, 'triangle_output_x'),
        i18n(context, 'triangle_output_y'),
        null
      ],
      [
        'a',
        _altitudesBasePoint[0].x.toStringAsFixed(3),
        _altitudesBasePoint[0].y.toStringAsFixed(3),
        null,
      ],
      [
        'b',
        _altitudesBasePoint[1].x.toStringAsFixed(3),
        _altitudesBasePoint[1].y.toStringAsFixed(3),
        null,
      ],
      [
        'c',
        _altitudesBasePoint[2].x.toStringAsFixed(3),
        _altitudesBasePoint[2].y.toStringAsFixed(3),
        null,
      ],
    ];
    _outputPoints = [
      [
        null,
        i18n(context, 'triangle_output_x'),
        i18n(context, 'triangle_output_y'),
        null
      ],
      [
        i18n(context, 'triangle_output_incenter'),
        _innercircle.x.toStringAsFixed(3),
        _innercircle.y.toStringAsFixed(3),
        null
      ],
      [
        i18n(context, 'triangle_output_centroid'),
        _centroid.x.toStringAsFixed(3),
        _centroid.y.toStringAsFixed(3),
        null
      ],
      [
        i18n(context, 'triangle_output_circumcenter'),
        _outercircle.x.toStringAsFixed(3),
        _outercircle.y.toStringAsFixed(3),
        null
      ],
      [
        i18n(context, 'triangle_output_altitude'),
        _orthocenter.x.toStringAsFixed(3),
        _orthocenter.y.toStringAsFixed(3),
        null
      ],
      [
        i18n(context, 'triangle_output_feuerbachcircle'),
        _feuerbachcircle.x.toStringAsFixed(3),
        _feuerbachcircle.y.toStringAsFixed(3),
        null,
      ],
      [
        i18n(context, 'triangle_output_lemoine'),
        _lemoine.x.toStringAsFixed(3),
        _lemoine.y.toStringAsFixed(3),
        null
      ],
      [
        i18n(context, 'triangle_output_gergonne'),
        _gergonne.x.toStringAsFixed(3),
        _gergonne.y.toStringAsFixed(3),
        null
      ],
      [
        i18n(context, 'triangle_output_nagel'),
        _nagel.x.toStringAsFixed(3),
        _nagel.y.toStringAsFixed(3),
        null
      ],
      [
        i18n(context, 'triangle_output_napoleon_outer'),
        _napoleon1.x.toStringAsFixed(3),
        _napoleon1.y.toStringAsFixed(3),
        null
      ],
      [
        i18n(context, 'triangle_output_napoleon_inner'),
        _napoleon2.x.toStringAsFixed(3),
        _napoleon2.y.toStringAsFixed(3),
        null
      ],
      [
        i18n(context, 'triangle_output_mitten'),
        _mitten.x.toStringAsFixed(3),
        _mitten.y.toStringAsFixed(3),
        null
      ],
      [
        i18n(context, 'triangle_output_spieker'),
        _spieker.x.toStringAsFixed(3),
        _spieker.y.toStringAsFixed(3),
        null
      ],
      [
        i18n(context, 'triangle_output_feuerbach'),
        _feuerbach.x.toStringAsFixed(3),
        _feuerbach.y.toStringAsFixed(3),
        null
      ],
    ];
    _outputCircles = [
      [
        null,
        i18n(context, 'triangle_output_x'),
        i18n(context, 'triangle_output_y'),
        i18n(context, 'triangle_output_r')
      ],
      [
        i18n(context, 'triangle_output_incircle'),
        _innercircle.x.toStringAsFixed(3),
        _innercircle.y.toStringAsFixed(3),
        _innercircle.r.toStringAsFixed(3),
      ],
      [
        i18n(context, 'triangle_output_circumscribedcircle'),
        _outercircle.x.toStringAsFixed(3),
        _outercircle.y.toStringAsFixed(3),
        _outercircle.r.toStringAsFixed(3),
      ],
      [
        i18n(context, 'triangle_output_feuerbachcircle'),
        _feuerbachcircle.x.toStringAsFixed(3),
        _feuerbachcircle.y.toStringAsFixed(3),
        _feuerbachcircle.r.toStringAsFixed(3),
      ],
      [
        i18n(context, 'triangle_output_excircle').replaceAll('\$1', 'a'),
        _exCircle[0].x.toStringAsFixed(3),
        _exCircle[0].y.toStringAsFixed(3),
        _exCircle[0].r.toStringAsFixed(3),
      ],
      [
        i18n(context, 'triangle_output_excircle').replaceAll('\$1', 'b'),
        _exCircle[1].x.toStringAsFixed(3),
        _exCircle[1].y.toStringAsFixed(3),
        _exCircle[1].r.toStringAsFixed(3),
      ],
      [
        i18n(context, 'triangle_output_excircle').replaceAll('\$1', 'c'),
        _exCircle[2].x.toStringAsFixed(3),
        _exCircle[2].y.toStringAsFixed(3),
        _exCircle[2].r.toStringAsFixed(3),
      ],
    ];
  }

  void _createAdditionalDataMap() {
    _isCalculatedDataMap = true;
    _points = [];
    _polylines = [];

    _AMap = _currentCoordsA.toLatLng()!;
    _BMap = _currentCoordsB.toLatLng()!;
    _CMap = _currentCoordsC.toLatLng()!;

    _points.add(GCWMapPoint(point: _AMap, markerText: 'A', color: Colors.red));
    _points.add(GCWMapPoint(point: _BMap, markerText: 'B', color: Colors.red));
    _points.add(GCWMapPoint(point: _CMap, markerText: 'C', color: Colors.red));

    _sidesMap = triangleSidesMap(_AMap, _BMap, _CMap)!;

    _polylines.add(GCWMapPolyline(points: [GCWMapPoint(point: _AMap), GCWMapPoint(point: _BMap)], color: Colors.blueAccent));
    _polylines.add(GCWMapPolyline(points: [GCWMapPoint(point: _AMap), GCWMapPoint(point: _CMap)], color: Colors.blueAccent));
    _polylines.add(GCWMapPolyline(points: [GCWMapPoint(point: _CMap), GCWMapPoint(point: _BMap)], color: Colors.blueAccent));

    _anglesMap = triangleAnglesMap(_AMap, _BMap, _CMap)!;

    _sidesMidPointMap = triangleSidesMidPointsMap(_AMap, _BMap, _CMap);

    _points.add(GCWMapPoint(point: _sidesMidPointMap[0], markerText: i18n(context, 'triangle_output_sidesmidpoint') + ' c', color: Colors.green));
    _points.add(GCWMapPoint(point: _sidesMidPointMap[1], markerText: i18n(context, 'triangle_output_sidesmidpoint') + ' a', color: Colors.green));
    _points.add(GCWMapPoint(point: _sidesMidPointMap[2], markerText: i18n(context, 'triangle_output_sidesmidpoint') + ' b', color: Colors.green));

    _centroidMap = triangleCentroidMap(_AMap, _BMap, _CMap)!;

    _points.add(GCWMapPoint(point: _centroidMap, markerText: i18n(context, 'triangle_output_centroid'), color: Colors.red));

    _outercircleMap = triangleCircumCircleMap(_AMap, _BMap, _CMap);

    _points.add(GCWMapPoint(point: LatLng(_outercircleMap.x, _outercircleMap.y), markerText: i18n(context, 'triangle_output_circumcenter'), color: Colors.lightBlue, circle: GCWMapCircle(centerPoint: LatLng(_outercircleMap.x, _outercircleMap.y), radius: _outercircleMap.r)));

    _innercircleMap = triangleInCircleMap(_AMap, _BMap, _CMap);

    _points.add(GCWMapPoint(point: LatLng(_innercircleMap.x, _innercircleMap.y), markerText: i18n(context, 'triangle_output_incenter'), color: Colors.lightBlue, circle: GCWMapCircle(centerPoint: LatLng(_innercircleMap.x, _innercircleMap.y), radius: _innercircleMap.r)));

    _outputBasicData = [
      [
        i18n(context, 'triangle_output_sides'),
        _sidesMap.a.toStringAsFixed(3),
        _sidesMap.b.toStringAsFixed(3),
        _sidesMap.c.toStringAsFixed(3)
      ],
      [
        i18n(context, 'triangle_output_angles'),
        _anglesMap.alpha.toStringAsFixed(3),
        _anglesMap.beta.toStringAsFixed(3),
        _anglesMap.gamma.toStringAsFixed(3)
      ],
      [
        i18n(context, 'triangle_output_circumference'),
        triangleCircumferenceMap(_AMap, _BMap, _CMap).toStringAsFixed(3), null, null, null
      ],
      [
        i18n(context, 'triangle_output_area'),
        triangleAreaMap(_AMap, _BMap, _CMap).toStringAsFixed(3), null, null, null
      ],
    ];

    _outputDataPointsSidesMidPoint = [
      ['a', buildCoordinate(_currentCoordsC.format, _sidesMidPointMap[1], defaultEllipsoid).toString(6).replaceAll('\n', '   '),],
      ['b', buildCoordinate(_currentCoordsC.format, _sidesMidPointMap[2], defaultEllipsoid).toString(6).replaceAll('\n', '   '),],
      ['c', buildCoordinate(_currentCoordsC.format, _sidesMidPointMap[0], defaultEllipsoid).toString(6).replaceAll('\n', '   '),]
    ];

    _outputPoints = [
      ['X01 ' + i18n(context, 'triangle_output_incenter'), buildCoordinate(_currentCoordsC.format, LatLng(_innercircleMap.x, _innercircleMap.y), defaultEllipsoid).toString(6).replaceAll('\n', '   '),],
      ['X02 ' + i18n(context, 'triangle_output_centroid'), buildCoordinate(_currentCoordsC.format, _centroidMap, defaultEllipsoid).toString(6).replaceAll('\n', '   '),],
      ['X03 ' + i18n(context, 'triangle_output_circumcenter'), buildCoordinate(_currentCoordsC.format, LatLng(_outercircleMap.x, _outercircleMap.y), defaultEllipsoid).toString(6).replaceAll('\n', '   '),],
    ];

    _outputCircles = [
      [i18n(context, 'triangle_output_circumscribedcircle'), buildCoordinate(_currentCoordsC.format, LatLng(_outercircleMap.x, _outercircleMap.y), defaultEllipsoid).toString(6).replaceAll('\n', '   '),_outercircleMap.r.toStringAsFixed(3)],
      [i18n(context, 'triangle_output_incircle'), buildCoordinate(_currentCoordsC.format, LatLng(_innercircleMap.x, _innercircleMap.y), defaultEllipsoid).toString(6).replaceAll('\n', '   '),_innercircleMap.r.toStringAsFixed(3)],

    ];
  }

  void _createGraphicOutput() {
    _triangleImage = Uint8List.fromList([]);
    triangleData2Image(
      A: _A,
      B: _B,
      C: _C,
      a: _sides.a,
      b: _sides.b,
      c: _sides.c,
      alpha: _angles.alpha,
      beta: _angles.beta,
      gamma: _angles.gamma,
      area: triangleAreaXY(_A, _B, _C),
      circumference: triangleCircumferenceXY(_A, _B, _C),
      CG: _centroid,
      F: _feuerbach,
      L: _lemoine,
      M: _mitten,
      N: _nagel,
      N1: _napoleon1,
      N2: _napoleon2,
      S: _spieker,
      O: _orthocenter,
      G: _gergonne,
      AA: _altitudesBasePoint[0],
      AB: _altitudesBasePoint[1],
      AC: _altitudesBasePoint[2],
      MSA: _sidesMidPoint[0],
      MSB: _sidesMidPoint[1],
      MSC: _sidesMidPoint[2],
      CC: _outercircle,
      IC: _innercircle,
      FC: _feuerbachcircle,
      EA: _exCircle[0],
      EB: _exCircle[1],
      EC: _exCircle[2],
      labels: [
        i18n(context, 'triangle_output_sides'), // 0
        i18n(context, 'triangle_output_angles'), // 1
        i18n(context, 'triangle_output_area'), // 2
        i18n(context, 'triangle_output_circumference'), // 3
        i18n(context, 'triangle_output_sidesmidpoint'), // 4
        i18n(context, 'triangle_output_altitudesbasepoint'), // 5
        i18n(context, 'triangle_output_centroid'), // 6
        i18n(context, 'triangle_output_altitude'), // 7
        i18n(context, 'triangle_output_lemoine'), // 8
        i18n(context, 'triangle_output_gergonne'), // 9
        i18n(context, 'triangle_output_nagel'), // 10
        i18n(context, 'triangle_output_napoleon_outer'), // 11
        i18n(context, 'triangle_output_napoleon_inner'), // 12
        i18n(context, 'triangle_output_mitten'), // 13
        i18n(context, 'triangle_output_spieker'), // 14
        i18n(context, 'triangle_output_feuerbach'), // 15
        i18n(context, 'triangle_output_incenter'), // 16
        i18n(context, 'triangle_output_circumcenter'), // 17
        i18n(context, 'triangle_output_incircle'), // 18
        i18n(context, 'triangle_output_excircle'), // 19
        i18n(context, 'triangle_output_circumscribedcircle'), // 20
        i18n(context, 'triangle_output_feuerbachcircle'), // 21
      ],
    ).then((value) {
      setState(() {
        _triangleImage = value;
      });
    });
  }

  Widget _buildGraphicOutput() {
    return GCWExpandableTextDivider(
      suppressTopSpace: false,
      text: i18n(context, 'common_image'),
      child: Column(
        children: [
          GCWSubmitButton(
            onPressed: () {
              setState(() {
                if (_isCalculatedDataXY) {
                  _createGraphicOutput();
                  _isCalculatedImage = true;
                }
              });
            },
          ),
          _isCalculatedImage
              ? GCWImageView(
                  imageData: GCWImageViewData(GCWFile(bytes: _triangleImage)),
                  suppressOpenInTool: const {GCWImageViewOpenInTools.METADATA},
                )
              : Container(),
        ],
      ),
    );
  }
}
