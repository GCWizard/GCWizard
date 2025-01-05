import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';

import 'package:gc_wizard/application/theme/theme.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_submit_button.dart';
import 'package:gc_wizard/common_widgets/dividers/gcw_text_divider.dart';
import 'package:gc_wizard/common_widgets/gcw_expandable.dart';
import 'package:gc_wizard/common_widgets/gcw_text.dart';
import 'package:gc_wizard/common_widgets/image_viewers/gcw_imageview.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_columned_multiline_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_output_text.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/utils/file_utils/gcw_file.dart';
import 'package:gc_wizard/tools/science_and_technology/triangle/logic/triangle.dart';

class Triangle extends StatefulWidget {
  const Triangle({Key? key}) : super(key: key);

  @override
  TriangleState createState() => TriangleState();
}

class TriangleState extends State<Triangle> {

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
  late XYPoint _spieker;
  late XYPoint _feuerbach;
  late XYPoint _mitten;
  late List<XYCircle> _exCircle;
  late List<XYPoint> _sidesMidPoint;
  late List<XYPoint> _altitudesBasePoint;

  Uint8List _triangleImage = Uint8List.fromList([]);

  bool _isCalculatedData = false;
  bool _isCalculatedImage = false;

  int _sidesAnglesData = 0;

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
      _buildInputWidgetABC(),
      GCWSubmitButton(
        onPressed: () {
          setState(() {
            if (_allBasicDataAvailable()) {
              _createAdditionalData();
              _isCalculatedData = true;
              _isCalculatedImage = false;
            }
          });
        },
      ),
      GCWTextDivider(text: i18n(context, 'common_output')),
      _buildOutput(context)
    ]);
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
              padding: const EdgeInsets.only(left: DEFAULT_MARGIN, right: DEFAULT_MARGIN),
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
              padding: const EdgeInsets.only(left: DEFAULT_MARGIN, right: DEFAULT_MARGIN),
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
              padding: const EdgeInsets.only(left: DEFAULT_MARGIN, right: DEFAULT_MARGIN),
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
    if (_isCalculatedData) {
      return Column(children: <Widget>[
        Column(
          children: <Widget>[
            GCWColumnedMultilineOutput(data: _outputBasicData, flexValues: const [2, 1, 1, 1], copyAll: true),
            GCWTextDivider(suppressTopSpace: false, text: i18n(context, 'triangle_output_sidesmidpoint')),
            GCWColumnedMultilineOutput(
                data: _outputDataPointsSidesMidPoint, flexValues: const [2, 1, 1, 1], copyAll: true),
            GCWTextDivider(suppressTopSpace: false, text: i18n(context, 'triangle_output_altitudesbasepoint')),
            GCWColumnedMultilineOutput(
                data: _outputDataPointsAltitudeBasePoints, flexValues: const [2, 1, 1, 1], copyAll: true),
          ],
        ),
        GCWExpandableTextDivider(
          text: i18n(context, 'triangle_output_points'),
          suppressTopSpace: false,
          child: GCWColumnedMultilineOutput(data: _outputPoints, flexValues: const [2, 1, 1, 1], copyAll: true),
        ),
        GCWExpandableTextDivider(
          text: i18n(context, 'triangle_output_circles'),
          suppressTopSpace: false,
          child: GCWColumnedMultilineOutput(data: _outputCircles, flexValues: const [2, 1, 1, 1], copyAll: true),
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
    return (double.tryParse(_currentAxInput) != null &&
          double.tryParse(_currentAyInput) != null &&
          double.tryParse(_currentBxInput) != null &&
          double.tryParse(_currentByInput) != null &&
          double.tryParse(_currentCxInput) != null &&
          double.tryParse(_currentCyInput) != null);
  }

  void _createAdditionalData() {
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

    _angles = triangleAngles(_A, _B, _C)!;
    _sides = triangleSides(_A, _B, _C);
    _medians = triangleMedians(_A, _B, _C);
    _altitudes = triangleAltitudes(_A, _B, _C);
    _anglebisector = triangleAngleBiSectors(_A, _B, _C);
    _centroid = triangleCentroid(_A, _B, _C);
    _orthocenter = triangleOrthocenter(_A, _B, _C);
    _innercircle = triangleInCircle(_A, _B, _C);
    _outercircle = triangleCircumCircle(_A, _B, _C);
    _feuerbachcircle = triangleFeuerbachCircle(_A, _B, _C);
    _gergonne = triangleGergonne(_A, _B, _C);
    _lemoine = triangleLemoine(_A, _B, _C);
    _nagel = triangleNagel(_A, _B, _C);
    _spieker = triangleSpieker(_A, _B, _C);
    _feuerbach = triangleFeuerbach(_A, _B, _C);
    _mitten = triangleMitten(_A, _B, _C);
    _exCircle = triangleExCircles(_A, _B, _C);
    _sidesMidPoint = triangleSidesMidPoints(_A, _B, _C);
    _altitudesBasePoint = triangleAltitudesBasePoints(_A, _B, _C);

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
        triangleCircumference(_A, _B, _C).toStringAsFixed(3),
        null,
        null
      ],
      [i18n(context, 'triangle_output_area'), triangleArea(_A, _B, _C).toStringAsFixed(3), null, null],
    ];
    _outputDataPointsSidesMidPoint = [
      [
        'a\nx, y',
        _sidesMidPoint[0].x.toStringAsFixed(3),
        _sidesMidPoint[0].y.toStringAsFixed(3),
        null,
      ],
      [
        'b\nx, y',
        _sidesMidPoint[1].x.toStringAsFixed(3),
        _sidesMidPoint[1].y.toStringAsFixed(3),
        null,
      ],
      [
        'c\nx, y',
        _sidesMidPoint[2].x.toStringAsFixed(3),
        _sidesMidPoint[2].y.toStringAsFixed(3),
        null,
      ],
    ];
    _outputDataPointsAltitudeBasePoints = [
      [
        'a\nx, y',
        _altitudesBasePoint[0].x.toStringAsFixed(3),
        _altitudesBasePoint[0].y.toStringAsFixed(3),
        null,
      ],
      [
        'b\nx, y',
        _altitudesBasePoint[1].x.toStringAsFixed(3),
        _altitudesBasePoint[1].y.toStringAsFixed(3),
        null,
      ],
      [
        'c\nx, y',
        _altitudesBasePoint[2].x.toStringAsFixed(3),
        _altitudesBasePoint[2].y.toStringAsFixed(3),
        null,
      ],
    ];
    _outputPoints = [
      [
        i18n(context, 'triangle_output_incenter'),
        _innercircle.x.toStringAsFixed(3),
        _innercircle.y.toStringAsFixed(3),
        null
      ],
      [i18n(context, 'triangle_output_centroid'), _centroid.x.toStringAsFixed(3), _centroid.y.toStringAsFixed(3), null],
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
      [i18n(context, 'triangle_output_lemoine'), _lemoine.x.toStringAsFixed(3), _lemoine.y.toStringAsFixed(3), null],
      [i18n(context, 'triangle_output_gergonne'), _gergonne.x.toStringAsFixed(3), _gergonne.y.toStringAsFixed(3), null],
      [i18n(context, 'triangle_output_nagel'), _nagel.x.toStringAsFixed(3), _nagel.y.toStringAsFixed(3), null],
      [i18n(context, 'triangle_output_mitten'), _mitten.x.toStringAsFixed(3), _mitten.y.toStringAsFixed(3), null],
      [i18n(context, 'triangle_output_spieker'), _spieker.x.toStringAsFixed(3), _spieker.y.toStringAsFixed(3), null],
      [
        i18n(context, 'triangle_output_feuerbach'),
        _feuerbach.x.toStringAsFixed(3),
        _feuerbach.y.toStringAsFixed(3),
        null
      ],
    ];
    _outputCircles = [
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
      CG: _centroid,
      F: _feuerbach,
      L: _lemoine,
      M: _mitten,
      N: _nagel,
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
                if (_isCalculatedData) {
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
