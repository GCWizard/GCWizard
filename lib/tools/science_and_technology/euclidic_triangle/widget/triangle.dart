import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/application/theme/theme.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_submit_button.dart';
import 'package:gc_wizard/common_widgets/dividers/gcw_text_divider.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_dropdown.dart';
import 'package:gc_wizard/common_widgets/gcw_expandable.dart';
import 'package:gc_wizard/common_widgets/gcw_text.dart';
import 'package:gc_wizard/common_widgets/image_viewers/gcw_imageview.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_columned_multiline_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_output_text.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_twooptions_switch.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/utils/file_utils/gcw_file.dart';
import 'package:gc_wizard/tools/science_and_technology/euclidic_triangle/logic/triangle.dart';
import 'package:gc_wizard/utils/math_utils.dart';

class EuclidicTriangle extends StatefulWidget {
  const EuclidicTriangle({super.key});

  @override
  EuclidicTriangleState createState() => EuclidicTriangleState();
}

class EuclidicTriangleState extends State<EuclidicTriangle> {
  late TextEditingController _AxController;
  late TextEditingController _AyController;
  late TextEditingController _BxController;
  late TextEditingController _ByController;
  late TextEditingController _CxController;
  late TextEditingController _CyController;

  late TextEditingController _SWController1;
  late TextEditingController _SWController2;
  late TextEditingController _SWController3;

  var _currentAxInput = '';
  var _currentAyInput = '';
  var _currentBxInput = '';
  var _currentByInput = '';
  var _currentCxInput = '';
  var _currentCyInput = '';

  var _currentSWInput1 = '';
  var _currentSWInput2 = '';
  var _currentSWInput3 = '';

  late List<List<Object?>> _outputPointData;
  late List<List<Object?>> _outputBasicData;
  late List<List<Object?>> _outputDataPointsSidesMidPoint;
  late List<List<Object?>> _outputDataPointsAltitudeBasePoints;
  late List<List<Object?>> _outputPoints;
  late List<List<Object?>> _outputTouchPoints;
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
  late List<XYPoint> _exCircleTouchpoints;

  Uint8List _triangleImage = Uint8List.fromList([]);

  bool _isCalculatedDataXY = false;
  bool _isCalculatedImage = false;

  GCWSwitchPosition _currentMode = GCWSwitchPosition.left;
  int _currentSWMode = 0;

  @override
  void initState() {
    super.initState();
    _AxController = TextEditingController(text: _currentAxInput);
    _AyController = TextEditingController(text: _currentAyInput);
    _BxController = TextEditingController(text: _currentBxInput);
    _ByController = TextEditingController(text: _currentByInput);
    _CxController = TextEditingController(text: _currentCxInput);
    _CyController = TextEditingController(text: _currentCyInput);

    _SWController1 = TextEditingController(text: _currentSWInput1);
    _SWController2 = TextEditingController(text: _currentSWInput2);
    _SWController3 = TextEditingController(text: _currentSWInput3);
  }

  @override
  void dispose() {
    _AxController.dispose();
    _AyController.dispose();
    _BxController.dispose();
    _ByController.dispose();
    _CxController.dispose();
    _CyController.dispose();

    _SWController1.dispose();
    _SWController2.dispose();
    _SWController3.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      GCWTwoOptionsSwitch(
        leftValue: i18n(context, 'triangle_euclidic_mode_poi'),
        rightValue: i18n(context, 'triangle_euclidic_mode_ssw'),
        value: _currentMode,
        onChanged: (value) {
          setState(() {
            _currentMode = value;
          });
        },
      ),
      _currentMode == GCWSwitchPosition.left
          ? _buildInputWidgetABC()
          : _buildInputWidgetSW(),
      GCWSubmitButton(
        onPressed: () {
          setState(() {
            if (_allBasicDataAvailable()) {
              if (_currentMode == GCWSwitchPosition.right) {
                _calculateABC();
              }
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

  Widget _buildInputWidgetSW() {
    return Column(
      children: [
        GCWDropDown<int>(
          value: _currentSWMode,
          items: SIDE_ANGLE_TYPES.entries.map((entry) {
            return GCWDropDownMenuItem(
              value: entry.key,
              child: i18n(context, entry.value),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _currentSWMode = value;
            });
          },
        ),
        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(right: DEFAULT_MARGIN),
                child: Column(
                  children: [
                    GCWText(
                      text: i18n(context, triangleSWText[_currentSWMode]![0]),
                    ),
                    GCWTextField(
                      controller: _SWController1,
                      onChanged: (text) {
                        setState(() {
                          _currentSWInput1 = text;
                        });
                      },
                    )
                  ],
                )),
            ),
            Expanded(
              child: Container(
                  padding: const EdgeInsets.only(left: DEFAULT_MARGIN, right: DEFAULT_MARGIN),
                  child: Column(
                    children: [
                      GCWText(
                        text: i18n(context, triangleSWText[_currentSWMode]![1]),
                      ),
                      GCWTextField(
                        controller: _SWController2,
                        onChanged: (text) {
                          setState(() {
                            _currentSWInput2 = text;
                          });
                        },
                      )
                    ],
                  )),
            ),
            Expanded(
              child: Container(
                  padding: const EdgeInsets.only(left: DEFAULT_MARGIN),
                  child: Column(
                    children: [
                      GCWText(
                        text: i18n(context, triangleSWText[_currentSWMode]![2]),
                      ),
                      GCWTextField(
                        controller: _SWController3,
                        onChanged: (text) {
                          setState(() {
                            _currentSWInput3 = text;
                          });
                        },
                      )
                    ],
                  )),
            ),
          ],
        ),
      ],
    );
    return Container();
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
    if (_isCalculatedDataXY) {
      return Column(children: <Widget>[
        Column(
          children: <Widget>[
            _currentMode == GCWSwitchPosition.right
            ? GCWColumnedMultilineOutput(
                data: _outputPointData,
                flexValues: const [2, 1, 1, 1],
                copyAll: true)
            : Container(),
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
            GCWTextDivider(
                suppressTopSpace: false,
                text: i18n(context, 'triangle_output_touchpoint')),
            GCWColumnedMultilineOutput(
                data: _outputTouchPoints,
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
    bool result = false;
    if (_currentMode == GCWSwitchPosition.left) {
      result = (double.tryParse(_currentAxInput) != null &&
          double.tryParse(_currentAyInput) != null &&
          double.tryParse(_currentBxInput) != null &&
          double.tryParse(_currentByInput) != null &&
          double.tryParse(_currentCxInput) != null &&
          double.tryParse(_currentCyInput) != null);
    } else {
      result = (double.tryParse(_currentSWInput1) != null &&
          double.tryParse(_currentSWInput2) != null &&
          double.tryParse(_currentSWInput3) != null);
    }
    return result;
  }

  void _calculateABC() {
    // https://www.arndt-bruenner.de/mathe/scripts/Dreiecksberechnung.htm
    double a = 0.0;
    double b = 0.0;
    double c = 0.0;
    double alpha = 0.0;
    double beta = 0.0;
    double gamma = 0.0;

    switch (_currentSWMode) {
      case 0: // sss => calculate www
        a = double.parse(_currentSWInput1);
        b = double.parse(_currentSWInput2);
        c = double.parse(_currentSWInput3);

        alpha = radianToDegrees(acos((b * b + c * c - a * a) / (2 * b * c)));
        beta = radianToDegrees(acos((a * a + c * c - b * b) / (2 * c * a)));
        gamma = radianToDegrees(acos((b * b + a * a - c * c) / (2 * a * b)));
        break;
      case 1: // ssw => calculate wws
        a = double.parse(_currentSWInput1);
        b = double.parse(_currentSWInput2);
        gamma = double.parse(_currentSWInput3);

        break;
      case 2: // sws => calculate wsw
        a = double.parse(_currentSWInput1);
        beta = double.parse(_currentSWInput2);
        c = double.parse(_currentSWInput3);

        b = b = sqrt(a * a + c * c - 2 * a * c * cos(degreesToRadian(beta)));
        alpha = radianToDegrees(acos((b * b + c * c - a * a) / (2 * b * c)));
        gamma = radianToDegrees(acos((b * b + a * a - c * c) / (2 * a * b)));
        break;
      case 3: // wss => calculate wsw
        a = double.parse(_currentSWInput1);
        beta = double.parse(_currentSWInput2);
        c = double.parse(_currentSWInput3);

        break;
      case 4: // wws => calculate ssw
        alpha = double.parse(_currentSWInput1);
        beta = double.parse(_currentSWInput2);
        c = double.parse(_currentSWInput3);

        gamma = 180 - alpha - beta;
        a = c * sin(degreesToRadian(alpha)) / sin(degreesToRadian(gamma));
        b = c * sin(degreesToRadian(beta)) / sin(degreesToRadian(gamma));
        break;
      case 5: // wsw => calculate sws
        alpha = double.parse(_currentSWInput1);
        b = double.parse(_currentSWInput2);
        gamma = double.parse(_currentSWInput3);

        beta = 180 - alpha - gamma;
        a = b * sin(degreesToRadian(alpha)) / sin(degreesToRadian(beta));
        c = b * sin(degreesToRadian(gamma)) / sin(degreesToRadian(beta));
        break;
      case 6: // sww => calculate sws
        a = double.parse(_currentSWInput1);
        beta = double.parse(_currentSWInput2);
        gamma = double.parse(_currentSWInput3);

        alpha = 180 - beta - gamma;
        b = a * sin(degreesToRadian(beta)) / sin(degreesToRadian(alpha));
        c = a * sin(degreesToRadian(gamma)) / sin(degreesToRadian(alpha));
        break;
    }

    double hc = a * sin(degreesToRadian(beta));

    _A = XYPoint(x: 0.0, y: 0.0);
    _B = XYPoint(x: c, y: 0.0);
    _C = XYPoint(x: sqrt(b * b - hc * hc), y: hc);

    _angles = Angles(alpha: alpha, beta: beta, gamma: gamma);
    _sides = Sides(a: a, b: b, c: c);

    _outputPointData = [
      [
        null,
        i18n(context, 'triangle_output_x'),
        i18n(context, 'triangle_output_y'),
        null
      ],
      [
        'A',
        _A.x.toStringAsFixed(3),
        _A.y.toStringAsFixed(3),
        null,
      ],
      [
        'B',
        _B.x.toStringAsFixed(3),
        _B.y.toStringAsFixed(3),
        null,
      ],
      [
        'C',
        _C.x.toStringAsFixed(3),
        _C.y.toStringAsFixed(3),
        null,
      ],
    ];
  }

  void _createAdditionalData() {
    _isCalculatedDataXY = true;

    if (_currentMode == GCWSwitchPosition.left) {
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
    }
    _altitudes = triangleAltitudesXY(_A, _B, _C);
    _medians = triangleMediansXY(_A, _B, _C);
    _anglebisector = triangleAngleBiSectorsXY(_A, _B, _C);
    _centroid = triangleCentroidXY(_A, _B, _C);
    _orthocenter = triangleOrthocenterXY(_A, _B, _C);
    _innercircle = triangleInCircleXY(_A, _B, _C);
    _outercircle = triangleCircumCircleXY(_A, _B, _C);
    _feuerbachcircle = triangleFeuerbachCircleXY(_A, _B, _C);
    _gergonne = triangleGergonne(_A, _B, _C);
    _lemoine = triangleLemoine(_A, _B, _C);
    _nagel = triangleNagel(_A, _B, _C);
    _napoleon1 = triangleNapoleonOuterXY(_A, _B, _C);
    _napoleon2 = triangleNapoleonInnerXY(_A, _B, _C);
    _spieker = triangleSpieker(_A, _B, _C);
    _feuerbach = triangleFeuerbach(_A, _B, _C);
    _mitten = triangleMitten(_A, _B, _C);
    _exCircle = triangleExCirclesXY(_A, _B, _C);
    _sidesMidPoint = triangleSidesMidPointsXY(_A, _B, _C);
    _altitudesBasePoint = triangleAltitudesBasePointsXY(_A, _B, _C);
    _exCircleTouchpoints = triangleTouchPointsExcircleXY(_A, _B, _C);

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
    _outputTouchPoints = [
      [
        null,
        i18n(context, 'triangle_output_x'),
        i18n(context, 'triangle_output_y'),
        null
      ],
      [
        i18n(context, 'triangle_output_excircle').replaceAll('\$1', 'a'),
        _exCircleTouchpoints[0].x.toStringAsFixed(3),
        _exCircleTouchpoints[0].y.toStringAsFixed(3),
        null
      ],
      [
        i18n(context, 'triangle_output_excircle').replaceAll('\$1', 'b'),
        _exCircleTouchpoints[1].x.toStringAsFixed(3),
        _exCircleTouchpoints[1].y.toStringAsFixed(3),
        null
      ],
      [
        i18n(context, 'triangle_output_excircle').replaceAll('\$1', 'c'),
        _exCircleTouchpoints[2].x.toStringAsFixed(3),
        _exCircleTouchpoints[2].y.toStringAsFixed(3),
        null
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
      ETA: _exCircleTouchpoints[0],
      ETB: _exCircleTouchpoints[1],
      ETC: _exCircleTouchpoints[2],
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
        i18n(context, 'triangle_output_circles'), // 18
        i18n(context, 'triangle_output_incircle'), // 19
        i18n(context, 'triangle_output_excircle'), // 20
        i18n(context, 'triangle_output_circumscribedcircle'), // 21
        i18n(context, 'triangle_output_feuerbachcircle'), // 22
        i18n(context, 'gcwizard_script_help_coordinates'), // 23
        i18n(context, 'triangle_output_touchpoint'), // 24
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
