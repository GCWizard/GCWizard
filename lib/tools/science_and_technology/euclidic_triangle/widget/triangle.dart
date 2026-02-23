import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/application/theme/theme.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_submit_button.dart';
import 'package:gc_wizard/common_widgets/dividers/gcw_text_divider.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_dropdown.dart';
import 'package:gc_wizard/common_widgets/gcw_expandable.dart';
import 'package:gc_wizard/common_widgets/gcw_snackbar.dart';
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

  var _currentTriangle = Triangle(XYPoint(x: 0.0, y: 0.0), XYPoint(x: 0.0, y: 0.0), XYPoint(x: 0.0, y: 0.0));

  late List<List<Object?>> _outputPointData;
  late List<List<Object?>> _outputBasicData;
  late List<List<Object?>> _outputDataPointsSidesMidPoint;
  late List<List<Object?>> _outputDataPointsAltitudeBasePoints;
  late List<List<Object?>> _outputPoints;
  late List<List<Object?>> _outputTouchPoints;
  late List<List<Object?>> _outputCircles;

  late XYPoint _A;
  late XYPoint _B;
  late XYPoint _C;

  late Map<String, String> _currentLabels;

  Uint8List _triangleImage = Uint8List.fromList([]);

  bool _isCalculatedDataXY = false;
  bool _isCalculatedImage = false;
  bool _isTranslated = false;

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
    if (!_isTranslated) {
      _currentLabels = _translateLabels(TRIANGLE_LABLES);
      _isTranslated = true;
    }
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
              } else {
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
              }
              if (_degeneratedTriangle(_A, _B, _C)) {
                showSnackBar(i18n(context, 'triangle_error_invalid'), context);
              } else {
                _currentTriangle = Triangle(_A, _B, _C);
                _createAdditionalData();
                TRIANGLE_LABLES['DESCRIPTION'] = _currentTriangle.description;
                _currentLabels = _translateLabels(TRIANGLE_LABLES);
                _isCalculatedImage = false;
              }
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
                        text: i18n(context, TRIANGLES_SW_TEXT[_currentSWMode]![0]),
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
                  padding: const EdgeInsets.only(
                      left: DEFAULT_MARGIN, right: DEFAULT_MARGIN),
                  child: Column(
                    children: [
                      GCWText(
                        text: i18n(context, TRIANGLES_SW_TEXT[_currentSWMode]![1]),
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
                        text: i18n(context, TRIANGLES_SW_TEXT[_currentSWMode]![2]),
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
        b = double.parse(_currentSWInput1);
        c = double.parse(_currentSWInput2);
        beta = double.parse(_currentSWInput3);

        gamma = radianToDegrees(asin(c * sin(degreesToRadian(beta)) / b));
        alpha = 180 - beta - gamma;
        a = sqrt(b * b + c * c - 2 * b * c * cos(degreesToRadian(alpha)));
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
        alpha = double.parse(_currentSWInput1);
        b = double.parse(_currentSWInput2);
        a = double.parse(_currentSWInput3);

        beta = radianToDegrees(asin(b * sin(degreesToRadian(alpha)) / a));
        gamma = 180 - alpha - beta;
        c = sqrt(a * a + b * b - 2 * a * b * cos(degreesToRadian(gamma)));
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

    _outputBasicData = [
      [
        i18n(context, 'triangle_output_sides'),
        _currentTriangle.sides.a.toStringAsFixed(3),
        _currentTriangle.sides.b.toStringAsFixed(3),
        _currentTriangle.sides.c.toStringAsFixed(3)
      ],
      [
        i18n(context, 'triangle_output_angles'),
        _currentTriangle.angles.alpha.toStringAsFixed(3),
        _currentTriangle.angles.beta.toStringAsFixed(3),
        _currentTriangle.angles.gamma.toStringAsFixed(3)
      ],
      [
        i18n(context, 'triangle_output_altitudes'),
        _currentTriangle.altitudes.a.toStringAsFixed(3),
        _currentTriangle.altitudes.b.toStringAsFixed(3),
        _currentTriangle.altitudes.c.toStringAsFixed(3)
      ],
      [
        i18n(context, 'triangle_output_medians'),
        _currentTriangle.medians.a.toStringAsFixed(3),
        _currentTriangle.medians.b.toStringAsFixed(3),
        _currentTriangle.medians.c.toStringAsFixed(3)
      ],
      [
        i18n(context, 'triangle_output_anglebisector'),
        _currentTriangle.anglebisector.a.toStringAsFixed(3),
        _currentTriangle.anglebisector.b.toStringAsFixed(3),
        _currentTriangle.anglebisector.c.toStringAsFixed(3)
      ],
      [
        i18n(context, 'triangle_output_circumference'),
        _currentTriangle.circumference.toStringAsFixed(3),
        null,
        null
      ],
      [
        i18n(context, 'common_type'),
        i18n(context, _currentTriangle.description),
        null,
        null
      ],
      [
        i18n(context, 'triangle_output_area'),
        _currentTriangle.area.toStringAsFixed(3),
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
        _currentTriangle.sidesMidPoint[0].x.toStringAsFixed(3),
        _currentTriangle.sidesMidPoint[0].y.toStringAsFixed(3),
        null,
      ],
      [
        'b',
        _currentTriangle.sidesMidPoint[1].x.toStringAsFixed(3),
        _currentTriangle.sidesMidPoint[1].y.toStringAsFixed(3),
        null,
      ],
      [
        'c',
        _currentTriangle.sidesMidPoint[2].x.toStringAsFixed(3),
        _currentTriangle.sidesMidPoint[2].y.toStringAsFixed(3),
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
        _currentTriangle.altitudesBasePoint[0].x.toStringAsFixed(3),
        _currentTriangle.altitudesBasePoint[0].y.toStringAsFixed(3),
        null,
      ],
      [
        'b',
        _currentTriangle.altitudesBasePoint[1].x.toStringAsFixed(3),
        _currentTriangle.altitudesBasePoint[1].y.toStringAsFixed(3),
        null,
      ],
      [
        'c',
        _currentTriangle.altitudesBasePoint[2].x.toStringAsFixed(3),
        _currentTriangle.altitudesBasePoint[2].y.toStringAsFixed(3),
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
        i18n(context, 'triangle_output_excircle') + ' a',
        _currentTriangle.exCirclesTouchPoints[0].x.toStringAsFixed(3),
        _currentTriangle.exCirclesTouchPoints[0].y.toStringAsFixed(3),
        null
      ],
      [
        i18n(context, 'triangle_output_excircle') + ' b',
        _currentTriangle.exCirclesTouchPoints[1].x.toStringAsFixed(3),
        _currentTriangle.exCirclesTouchPoints[1].y.toStringAsFixed(3),
        null
      ],
      [
        i18n(context, 'triangle_output_excircle') + ' c',
        _currentTriangle.exCirclesTouchPoints[2].x.toStringAsFixed(3),
        _currentTriangle.exCirclesTouchPoints[2].y.toStringAsFixed(3),
        null
      ],
      [
        i18n(context, 'triangle_output_incircle') + ' a',
        _currentTriangle.inCirclesTouchPoints[0].x.toStringAsFixed(3),
        _currentTriangle.inCirclesTouchPoints[0].y.toStringAsFixed(3),
        null
      ],
      [
        i18n(context, 'triangle_output_incircle') + ' b',
        _currentTriangle.inCirclesTouchPoints[1].x.toStringAsFixed(3),
        _currentTriangle.inCirclesTouchPoints[1].y.toStringAsFixed(3),
        null
      ],
      [
        i18n(context, 'triangle_output_incircle') + ' c',
        _currentTriangle.inCirclesTouchPoints[2].x.toStringAsFixed(3),
        _currentTriangle.inCirclesTouchPoints[2].y.toStringAsFixed(3),
        null
      ],
      [
        i18n(context, 'triangle_output_feuerbachcircle') + ' a',
        _currentTriangle.inFeuerbachCircleTouchPoints[0].x.toStringAsFixed(3),
        _currentTriangle.inFeuerbachCircleTouchPoints[0].y.toStringAsFixed(3),
        null
      ],
      [
        i18n(context, 'triangle_output_feuerbachcircle') + ' b',
        _currentTriangle.inFeuerbachCircleTouchPoints[1].x.toStringAsFixed(3),
        _currentTriangle.inFeuerbachCircleTouchPoints[1].y.toStringAsFixed(3),
        null
      ],
      [
        i18n(context, 'triangle_output_feuerbachcircle') + ' c',
        _currentTriangle.inFeuerbachCircleTouchPoints[2].x.toStringAsFixed(3),
        _currentTriangle.inFeuerbachCircleTouchPoints[2].y.toStringAsFixed(3),
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
        'X1  ' + i18n(context, 'triangle_output_incenter'),
        _currentTriangle.X1.x.toStringAsFixed(3),
        _currentTriangle.X1.y.toStringAsFixed(3),
        null
      ],
      [
        'X2  ' + i18n(context, 'triangle_output_centroid'),
        _currentTriangle.X2.x.toStringAsFixed(3),
        _currentTriangle.X2.y.toStringAsFixed(3),
        null
      ],
      [
        'X3  ' + i18n(context, 'triangle_output_circumcenter'),
        _currentTriangle.X3.x.toStringAsFixed(3),
        _currentTriangle.X3.y.toStringAsFixed(3),
        null
      ],
      [
        'X4  ' + i18n(context, 'triangle_output_altitude'),
        _currentTriangle.X4.x.toStringAsFixed(3),
        _currentTriangle.X4.y.toStringAsFixed(3),
        null
      ],
      [
        'X5  ' + i18n(context, 'triangle_output_ninepointcenter'),
        _currentTriangle.X5.x.toStringAsFixed(3),
        _currentTriangle.X5.y.toStringAsFixed(3),
        null
      ],
      [
        'X6  ' + i18n(context, 'triangle_output_lemoine'),
        _currentTriangle.X6.x.toStringAsFixed(3),
        _currentTriangle.X6.y.toStringAsFixed(3),
        null
      ],
      [
        'X7  ' + i18n(context, 'triangle_output_gergonne'),
        _currentTriangle.X7.x.toStringAsFixed(3),
        _currentTriangle.X7.y.toStringAsFixed(3),
        null
      ],
      [
        'X8  ' + i18n(context, 'triangle_output_nagel'),
        _currentTriangle.X8.x.toStringAsFixed(3),
        _currentTriangle.X8.y.toStringAsFixed(3),
        null
      ],
      [
        'X9  ' + i18n(context, 'triangle_output_mitten'),
        _currentTriangle.X9.x.toStringAsFixed(3),
        _currentTriangle.X9.y.toStringAsFixed(3),
        null
      ],
      [
        'X10 ' + i18n(context, 'triangle_output_spieker'),
        _currentTriangle.X10.x.toStringAsFixed(3),
        _currentTriangle.X10.y.toStringAsFixed(3),
        null
      ],
      [
        'X11 ' + i18n(context, 'triangle_output_feuerbach'),
        _currentTriangle.X11.x.toStringAsFixed(3),
        _currentTriangle.X11.y.toStringAsFixed(3),
        null
      ],
      [
        'X12 ' + i18n(context, 'triangle_output_harmonic_conjugate_x11'),
        _currentTriangle.X12.x.toStringAsFixed(3),
        _currentTriangle.X12.y.toStringAsFixed(3),
        null
      ],
      [
        'X13 ' + i18n(context, 'triangle_output_fermat_torricelli'),
        _currentTriangle.X13.x.toStringAsFixed(3),
        _currentTriangle.X13.y.toStringAsFixed(3),
        null
      ],
      [
        'X14 ' + i18n(context, 'triangle_output_2ndisogonic'),
        _currentTriangle.X14.x.toStringAsFixed(3),
        _currentTriangle.X14.y.toStringAsFixed(3),
        null
      ],
      [
        'X15 ' + i18n(context, 'triangle_output_1stisodynamic'),
        _currentTriangle.X15.x.toStringAsFixed(3),
        _currentTriangle.X15.y.toStringAsFixed(3),
        null
      ],
      [
        'X16 ' + i18n(context, 'triangle_output_2ndisodynamic'),
        _currentTriangle.X16.x.toStringAsFixed(3),
        _currentTriangle.X16.y.toStringAsFixed(3),
        null
      ],
      [
        'X17 ' + i18n(context, 'triangle_output_napoleon_outer'),
        _currentTriangle.X17.x.toStringAsFixed(3),
        _currentTriangle.X17.y.toStringAsFixed(3),
        null
      ],
      [
        'X18 ' + i18n(context, 'triangle_output_napoleon_inner'),
        _currentTriangle.X18.x.toStringAsFixed(3),
        _currentTriangle.X18.y.toStringAsFixed(3),
        null
      ],
      [
        'X19 ' + i18n(context, 'triangle_output_clawson'),
        _currentTriangle.X19.x.toStringAsFixed(3),
        _currentTriangle.X19.y.toStringAsFixed(3),
        null
      ],
      [
        'X20 ' + i18n(context, 'triangle_output_longchamps'),
        _currentTriangle.X20.x.toStringAsFixed(3),
        _currentTriangle.X20.y.toStringAsFixed(3),
        null
      ],
      [
        'X21 ' + i18n(context, 'triangle_output_schiffler'),
        _currentTriangle.X21.x.toStringAsFixed(3),
        _currentTriangle.X21.y.toStringAsFixed(3),
        null
      ],
      [
        'X22 ' + i18n(context, 'triangle_output_exeter'),
        _currentTriangle.X22.x.toStringAsFixed(3),
        _currentTriangle.X22.y.toStringAsFixed(3),
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
        _currentTriangle.inCircle.x.toStringAsFixed(3),
        _currentTriangle.inCircle.y.toStringAsFixed(3),
        _currentTriangle.inCircle.r.toStringAsFixed(3),
      ],
      [
        i18n(context, 'triangle_output_circumscribedcircle'),
        _currentTriangle.circumscribedCircle.x.toStringAsFixed(3),
        _currentTriangle.circumscribedCircle.y.toStringAsFixed(3),
        _currentTriangle.circumscribedCircle.r.toStringAsFixed(3),
      ],
      [
        i18n(context, 'triangle_output_feuerbachcircle'),
        _currentTriangle.feuerbachCircle.x.toStringAsFixed(3),
        _currentTriangle.feuerbachCircle.y.toStringAsFixed(3),
        _currentTriangle.feuerbachCircle.r.toStringAsFixed(3),
      ],
      [
        i18n(context, 'triangle_output_excircle') + ' a',
        _currentTriangle.exCircles[0].x.toStringAsFixed(3),
        _currentTriangle.exCircles[0].y.toStringAsFixed(3),
        _currentTriangle.exCircles[0].r.toStringAsFixed(3),
      ],
      [
        i18n(context, 'triangle_output_excircle') +' b',
        _currentTriangle.exCircles[1].x.toStringAsFixed(3),
        _currentTriangle.exCircles[1].y.toStringAsFixed(3),
        _currentTriangle.exCircles[1].r.toStringAsFixed(3),
      ],
      [
        i18n(context, 'triangle_output_excircle')+ ' c',
        _currentTriangle.exCircles[2].x.toStringAsFixed(3),
        _currentTriangle.exCircles[2].y.toStringAsFixed(3),
        _currentTriangle.exCircles[2].r.toStringAsFixed(3),
      ],
    ];
  }

  void _createGraphicOutput() {
    _triangleImage = Uint8List.fromList([]);
     triangleData2Image(
       triangle: _currentTriangle,
       labels: _currentLabels,
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
              ?  _triangleImage.isEmpty
                  ? GCWOutputText(
                      text: i18n(context, 'triangle_error'),
                    )
                  : GCWImageView(
                      imageData: GCWImageViewData(GCWFile(bytes: _triangleImage)),
                      suppressOpenInTool: const {GCWImageViewOpenInTools.METADATA},
                    )
              : Container(),
        ],
      ),
    );
  }

  bool _degeneratedTriangle(XYPoint a, XYPoint b, XYPoint c) {
    a = a.normalized();
    b = b.normalized();
    c = c.normalized();
    return (a.equals(b) || a.equals(c) || b.equals(c));
  }

  Map<String, String> _translateLabels(Map<String, String> labels){
    Map<String, String> result = {};
    for (String key in labels.keys) {
      result[key] = i18n(context, labels[key]!);
    }
    return result;
  }
}
