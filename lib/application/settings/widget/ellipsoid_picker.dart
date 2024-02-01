part of 'package:gc_wizard/application/settings/widget/settings_coordinates.dart';

class _EllipsoidPicker extends StatefulWidget {
  final void Function(Ellipsoid) onChanged;

  const _EllipsoidPicker({Key? key, required this.onChanged}) : super(key: key);

  @override
  _EllipsoidPickerState createState() => _EllipsoidPickerState();
}

class _EllipsoidPickerState extends State<_EllipsoidPicker> {
  static const _keyInverseFlattening = 'inverse_flattening';
  static const _keyFlattening = 'flattening';
  static const _keyMinorAxis = 'minor_axis';

  late TextEditingController _firstCustomValueController;
  late TextEditingController _secondCustomValueController;
  late DoubleText _firstCustomValue;
  late DoubleText _secondCustomValue;

  late GCWSwitchPosition _currentMode;
  String _currentEllipsoidCustom2ndValue = _keyMinorAxis;
  late Ellipsoid _currentStandardEllipsoid;

  Ellipsoid _currentEllipsoid = defaultEllipsoid;

  @override
  void initState() {
    super.initState();

    _currentMode = _currentEllipsoid.type == EllipsoidType.STANDARD ? GCWSwitchPosition.left : GCWSwitchPosition.right;

    if (_currentEllipsoid.type == EllipsoidType.USER_DEFINED) {
      _firstCustomValue = DoubleText(_currentEllipsoid.a.toString(), _currentEllipsoid.a);
      _secondCustomValue = DoubleText(_currentEllipsoid.b.toString(), _currentEllipsoid.b);
      _currentStandardEllipsoid = _currentEllipsoid;
    } else {
      _firstCustomValue = defaultDoubleText;
      _secondCustomValue = defaultDoubleText;
      _currentStandardEllipsoid = _currentEllipsoid;
    }

    _firstCustomValueController = TextEditingController(text: _firstCustomValue.text);
    _secondCustomValueController = TextEditingController(text: _secondCustomValue.text);
  }

  @override
  void dispose() {
    _firstCustomValueController.dispose();
    _secondCustomValueController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _secondCustomValues = {
      _keyMinorAxis: i18n(context, 'coords_ellipsoid_minoraxis'),
      _keyInverseFlattening: i18n(context, 'coords_ellipsoid_inverseflattening'),
      _keyFlattening: i18n(context, 'coords_ellipsoid_flattening'),
    };

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
          ? GCWDropDown<Ellipsoid>(
              value: _currentStandardEllipsoid,
              items: allEllipsoids.map((ellipsoid) {
                return GCWDropDownMenuItem(
                  value: ellipsoid,
                  child: i18n(context, ellipsoid.name!, ifTranslationNotExists: ellipsoid.name!),
                );
              }).toList(),
              onChanged: (Ellipsoid newValue) {
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
                    Expanded(flex: 2, child: GCWText(text: i18n(context, 'coords_ellipsoid_majoraxis'))),
                    Expanded(
                        flex: 3,
                        child: GCWDoubleTextField(
                          controller: _firstCustomValueController,
                          min: 0.0,
                          onChanged: (ret) {
                            setState(() {
                              _firstCustomValue = ret;
                              _setCurrentEllipsoidAndEmitOnChange(context);
                            });
                          },
                        ))
                  ],
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                        flex: 2,
                        child: GCWDropDown<String>(
                          value: _currentEllipsoidCustom2ndValue,
                          items: _secondCustomValues.entries.map((MapEntry<String, String> value) {
                            return GCWDropDownMenuItem(
                              value: value.key,
                              child: value.value,
                            );
                          }).toList(),
                          onChanged: (String newValue) {
                            setState(() {
                              _currentEllipsoidCustom2ndValue = newValue;
                              _setCurrentEllipsoidAndEmitOnChange(context);
                            });
                          },
                        )),
                    Expanded(
                        flex: 3,
                        child: GCWDoubleTextField(
                          controller: _secondCustomValueController,
                          min: 0.0,
                          onChanged: (ret) {
                            setState(() {
                              _secondCustomValue = ret;
                              _setCurrentEllipsoidAndEmitOnChange(context);
                            });
                          },
                        ))
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
      padding: const EdgeInsets.only(top: 20),
      child: GCWColumnedMultilineOutput(data: ellipsoidData),
    );
  }

  void _setCurrentEllipsoidAndEmitOnChange(BuildContext context) {
    if (_currentMode == GCWSwitchPosition.left) {
      _firstCustomValueController.clear();
      _secondCustomValueController.clear();
      _firstCustomValue = defaultDoubleText;
      _secondCustomValue = defaultDoubleText;
      _currentEllipsoidCustom2ndValue = _keyMinorAxis;

      _currentEllipsoid = _currentStandardEllipsoid;
    } else {
      var a = max<double>(_firstCustomValue.value, 1.0);
      var second = _secondCustomValue.value;

      switch (_currentEllipsoidCustom2ndValue) {
        case _keyInverseFlattening:
          _currentEllipsoid = Ellipsoid(null, a, max<double>(second, 1.01), type: EllipsoidType.USER_DEFINED);
          break;
        case _keyMinorAxis:
          var b = max<double>(second, 1.0);
          var invF = a / max<double>(a - b, practical_epsilon);
          _currentEllipsoid = Ellipsoid(null, a, invF, type: EllipsoidType.USER_DEFINED);
          break;
        case _keyFlattening:
          _currentEllipsoid = Ellipsoid(null, a, 1.0 / min<double>(1.0 / 1.01, max<double>(second, practical_epsilon)),
              type: EllipsoidType.USER_DEFINED);
          break;
      }
    }

    widget.onChanged(_currentEllipsoid);
  }
}
