import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gc_wizard/i18n/app_localizations.dart';
import 'package:gc_wizard/logic/tools/coords/data/ellipsoid.dart';
import 'package:gc_wizard/utils/constants.dart';
import 'package:gc_wizard/widgets/common/base/gcw_dropdownbutton.dart';
import 'package:gc_wizard/widgets/common/base/gcw_text.dart';
import 'package:gc_wizard/widgets/common/gcw_columned_multiline_output.dart';
import 'package:gc_wizard/widgets/common/gcw_double_textfield.dart';
import 'package:gc_wizard/widgets/common/gcw_twooptions_switch.dart';
import 'package:gc_wizard/widgets/tools/coords/base/utils.dart';

class GCWCoordsEllipsoid extends StatefulWidget {
  final Function onChanged;
  final Ellipsoid ellipsoid;

  const GCWCoordsEllipsoid({Key key, this.ellipsoid, this.onChanged}) : super(key: key);

  @override
  GCWCoordsEllipsoidState createState() => GCWCoordsEllipsoidState();
}

class GCWCoordsEllipsoidState extends State<GCWCoordsEllipsoid> {
  static const keyInverseFlattening = 'inverse_flattening';
  static const keyFlattening = 'flattening';
  static const keyMinorAxis = 'minor_axis';

  TextEditingController _firstUserValueController;
  TextEditingController _secondUserValueController;
  Map<String, dynamic> _firstUserValue;
  Map<String, dynamic> _secondUserValue;

  GCWSwitchPosition _currentMode;
  var _currentEllipsoidUser2ndValue = keyMinorAxis;
  Ellipsoid _currentStandardEllipsoid;

  Ellipsoid _currentEllipsoid;
  @override
  void initState() {
    super.initState();

    _currentEllipsoid = widget.ellipsoid ?? defaultEllipsoid();
    _currentMode = _currentEllipsoid.type == EllipsoidType.STANDARD ? GCWSwitchPosition.left : GCWSwitchPosition.right;

    if (_currentEllipsoid.type == EllipsoidType.USER_DEFINED) {
      _firstUserValue = {'text': _currentEllipsoid.a.toString(), 'value': _currentEllipsoid.a};
      _secondUserValue = {'text': _currentEllipsoid.b.toString(), 'value': _currentEllipsoid.b};
      _currentStandardEllipsoid = getEllipsoidByName(ELLIPSOID_NAME_WGS84);
    } else {
      _firstUserValue = defaultDoubleText;
      _secondUserValue = defaultDoubleText;
      _currentStandardEllipsoid = _currentEllipsoid;
    }

    _firstUserValueController = TextEditingController(text: _firstUserValue['text']);
    _secondUserValueController = TextEditingController(text: _secondUserValue['text']);
  }

  @override
  void dispose() {
    _firstUserValueController.dispose();
    _secondUserValueController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _secondUserValues = [
      {'key': keyMinorAxis, 'name': i18n(context, 'coords_ellipsoid_minoraxis')},
      {'key': keyInverseFlattening, 'name': i18n(context, 'coords_ellipsoid_inverseflattening')},
      {'key': keyFlattening, 'name': i18n(context, 'coords_ellipsoid_flattening')},
    ];

    return Column(children: <Widget>[
      GCWTwoOptionsSwitch(
        leftValue: i18n(context, 'settings_coordinates_defaultrotationellipsoid_existing'),
        rightValue: i18n(context, 'settings_coordinates_defaultrotationellipsoid_user'),
        value: _currentMode,
        onChanged: (value) {
          setState(() {
            _currentMode = value;
            _setCurrentEllipsoidAndEmitOnChange(context);
          });
        },
      ),
      _currentMode == GCWSwitchPosition.left
          ? GCWDropDownButton(
              value: _currentStandardEllipsoid,
              items: allEllipsoids.map((ellipsoid) {
                return GCWDropDownMenuItem(
                  value: ellipsoid,
                  child: i18n(context, ellipsoid.name) ?? ellipsoid.name,
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _currentStandardEllipsoid = newValue;
                  _setCurrentEllipsoidAndEmitOnChange(context);
                });
              },
            )
          : Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(child: GCWText(text: i18n(context, 'coords_ellipsoid_majoraxis')), flex: 2),
                    Expanded(
                        child: GCWDoubleTextField(
                          controller: _firstUserValueController,
                          min: 0.0,
                          onChanged: (ret) {
                            setState(() {
                              _firstUserValue = ret;
                              _setCurrentEllipsoidAndEmitOnChange(context);
                            });
                          },
                        ),
                        flex: 3)
                  ],
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                        child: GCWDropDownButton(
                          value: _currentEllipsoidUser2ndValue,
                          items: _secondUserValues.map((value) {
                            return GCWDropDownMenuItem(
                              value: value['key'],
                              child: value['name'],
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              _currentEllipsoidUser2ndValue = newValue;
                              _setCurrentEllipsoidAndEmitOnChange(context);
                            });
                          },
                        ),
                        flex: 2),
                    Expanded(
                        child: GCWDoubleTextField(
                          controller: _secondUserValueController,
                          min: 0.0,
                          onChanged: (ret) {
                            setState(() {
                              _secondUserValue = ret;
                              _setCurrentEllipsoidAndEmitOnChange(context);
                            });
                          },
                        ),
                        flex: 3)
                  ],
                ),
              ],
            ),
      _buildOutput(context)
    ]);
  }

  Widget _buildOutput(BuildContext context) {
    var ellipsoidData = [
      [i18n(context, 'coords_ellipsoid_majoraxis'), _currentEllipsoid.a],
      [i18n(context, 'coords_ellipsoid_minoraxis'), _currentEllipsoid.b],
      [i18n(context, 'coords_ellipsoid_flattening'), _currentEllipsoid.f],
      [i18n(context, 'coords_ellipsoid_inverseflattening'), _currentEllipsoid.invf],
    ];

    return Padding(
      child: GCWColumnedMultilineOutput(data: ellipsoidData),
      padding: EdgeInsets.only(top: 20),
    );
  }

  _setCurrentEllipsoidAndEmitOnChange(BuildContext context) {
    if (_currentMode == GCWSwitchPosition.left) {
      _firstUserValueController.clear();
      _secondUserValueController.clear();
      _firstUserValue = defaultDoubleText;
      _secondUserValue = defaultDoubleText;
      _currentEllipsoidUser2ndValue = keyMinorAxis;

      _currentEllipsoid = _currentStandardEllipsoid;
    } else {
      var a = max<double>(_firstUserValue['value'], 1.0);
      var second = _secondUserValue['value'];

      switch (_currentEllipsoidUser2ndValue) {
        case keyInverseFlattening:
          _currentEllipsoid = Ellipsoid(null, a, max<double>(second, 1.01), type: EllipsoidType.USER_DEFINED);
          break;
        case keyMinorAxis:
          var b = max<double>(second, 1.0);
          var invF = a / max<double>(a - b, epsilon);
          _currentEllipsoid = Ellipsoid(null, a, invF, type: EllipsoidType.USER_DEFINED);
          break;
        case keyFlattening:
          _currentEllipsoid = Ellipsoid(null, a, 1.0 / min<double>(1.0 / 1.01, max<double>(second, epsilon)),
              type: EllipsoidType.USER_DEFINED);
          break;
      }
    }

    widget.onChanged(_currentEllipsoid);
  }
}
