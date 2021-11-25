import 'package:flutter/material.dart';
import 'package:gc_wizard/i18n/app_localizations.dart';
import 'package:gc_wizard/logic/common/parser/variable_string_expander.dart';
import 'package:gc_wizard/logic/common/units/length.dart';
import 'package:gc_wizard/logic/common/units/unit_category.dart';
import 'package:gc_wizard/logic/tools/coords/data/coordinates.dart';
import 'package:gc_wizard/logic/tools/coords/parser/variable_latlon.dart';
import 'package:gc_wizard/logic/tools/coords/utils.dart';
import 'package:gc_wizard/persistence/formula_solver/model.dart' as formula_base;
import 'package:gc_wizard/persistence/variable_coordinate/json_provider.dart';
import 'package:gc_wizard/persistence/variable_coordinate/model.dart';
import 'package:gc_wizard/theme/theme.dart';
import 'package:gc_wizard/widgets/common/base/gcw_dialog.dart';
import 'package:gc_wizard/widgets/common/base/gcw_iconbutton.dart';
import 'package:gc_wizard/widgets/common/base/gcw_output_text.dart';
import 'package:gc_wizard/widgets/common/base/gcw_text.dart';
import 'package:gc_wizard/widgets/common/base/gcw_textfield.dart';
import 'package:gc_wizard/widgets/common/base/gcw_toast.dart';
import 'package:gc_wizard/widgets/common/gcw_key_value_editor.dart';
import 'package:gc_wizard/widgets/common/gcw_onoff_switch.dart';
import 'package:gc_wizard/widgets/common/gcw_submit_button.dart';
import 'package:gc_wizard/widgets/common/gcw_text_divider.dart';
import 'package:gc_wizard/widgets/common/gcw_twooptions_switch.dart';
import 'package:gc_wizard/widgets/common/units/gcw_unit_dropdownbutton.dart';
import 'package:gc_wizard/widgets/tools/coords/base/gcw_coords_output.dart';
import 'package:gc_wizard/widgets/tools/coords/base/gcw_coords_outputformat.dart';
import 'package:gc_wizard/widgets/tools/coords/base/utils.dart';
import 'package:gc_wizard/widgets/tools/coords/map_view/gcw_map_geometries.dart';
import 'package:gc_wizard/widgets/tools/coords/utils/user_location.dart';
import 'package:gc_wizard/widgets/utils/textinputformatter/coords_text_variablecoordinate_textinputformatter.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';

final _WARNING_COUNT = 500;
final _TOOMANY_COUNT = 5000;

class VariableCoordinate extends StatefulWidget {
  final Formula formula;

  const VariableCoordinate({Key key, this.formula}) : super(key: key);

  @override
  VariableCoordinateState createState() => VariableCoordinateState();
}

class VariableCoordinateState extends State<VariableCoordinate> {
  Widget _output = GCWCoordsOutput(outputs: []);
  GCWSwitchPosition _currentCoordMode = GCWSwitchPosition.left;

  Length _currentLengthUnit = UNITCATEGORY_LENGTH.defaultUnit;
  bool _currentProjectionMode = false;
  var _currentOutputFormat = defaultCoordFormat();

  var _inputController;
  var _bearingController;
  var _distanceController;

  var _currentInput = '';
  var _currentBearingInput = '';
  var _currentDistanceInput = '';
  var _currentReverseBearing = false;
  var _currentFromInput = '';
  var _currentToInput = '';

  List<dynamic> _currentOutput = [];
  List<GCWMapPoint> _currentMapPoints = [];

  bool _isOnLocationAccess = false;
  var _location = Location();

  @override
  void initState() {
    super.initState();

    _currentInput = widget.formula.formula ?? '';
    _currentProjectionMode = widget.formula.projection != null && widget.formula.projection.distanceUnit != null;

    if (_currentProjectionMode) {
      _currentDistanceInput = widget.formula.projection.distance ?? '';
      _currentLengthUnit = baseLengths.firstWhere((unit) => unit.name == widget.formula.projection.distanceUnit);
      _currentBearingInput = widget.formula.projection.bearing ?? '';
      _currentReverseBearing = widget.formula.projection.reverse;
    }

    _inputController = TextEditingController(text: _currentInput);
    _bearingController = TextEditingController(text: _currentBearingInput);
    _distanceController = TextEditingController(text: _currentDistanceInput);
  }

  @override
  void dispose() {
    _inputController.dispose();
    _bearingController.dispose();
    _distanceController.dispose();

    super.dispose();
  }

  _updateValue(formula_base.FormulaValue value) {
    updateFormulaValue(value, widget.formula);
  }

  _addEntry(String currentFromInput, String currentToInput, BuildContext context) {
    if (currentFromInput.length > 0) {
      insertFormulaValue(formula_base.FormulaValue(currentFromInput, currentToInput), widget.formula);
    }
  }

  _updateNewEntry(String currentFromInput, String currentToInput, BuildContext context) {
    _currentFromInput = currentFromInput;
    _currentToInput = currentToInput;
  }

  _updateEntry(dynamic id, String key, String value) {
    var entry = widget.formula.values.firstWhere((element) => element.id == id);
    entry.key = key;
    entry.value = value;
    _updateValue(entry);
  }

  _removeEntry(dynamic id, BuildContext context) {
    deleteFormulaValue(id, widget.formula);
  }

  _disposeEntry(String currentFromInput, String currentToInput, BuildContext context) {
    if (currentFromInput != null &&
        currentFromInput.length > 0 &&
        currentToInput != null &&
        currentToInput.length > 0) {
      _addEntry(currentFromInput, currentToInput, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: [
            Expanded(
              child: Container(
                child: GCWTextField(
                  controller: _inputController,
                  onChanged: (value) {
                    _currentInput = value;
                    widget.formula.formula = _currentInput;
                    updateFormula(widget.formula);
                  },
                ),
                padding: EdgeInsets.only(right: DEFAULT_MARGIN),
              ),
            ),
            GCWIconButton(
              iconData: _isOnLocationAccess ? Icons.refresh : Icons.location_on,
              onPressed: () {
                _setUserLocationCoords();
              },
            ),
          ],
        ),
        GCWOnOffSwitch(
          title: i18n(context, 'coords_variablecoordinate_projection'),
          value: _currentProjectionMode,
          onChanged: (value) {
            setState(() {
              _currentProjectionMode = value;

              if (_currentProjectionMode) {
                var projection = ProjectionFormula(
                    _currentDistanceInput, _currentLengthUnit.name, _currentBearingInput, _currentReverseBearing);

                widget.formula.projection = projection;
              } else {
                widget.formula.projection = null;
              }
              updateFormula(widget.formula);
            });
          },
        ),
        _buildProjectionInput(),
        GCWTextDivider(
          text: i18n(context, 'coords_variablecoordinate_variables'),
        ),
        _buildVariablesEditor(),
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
            var countCombinations = preCheckCombinations(_getSubstitutions());
            if (countCombinations > _TOOMANY_COUNT) {
              showGCWAlertDialog(context, i18n(context, 'coords_variablecoordinate_toomanyresults_title'),
                  i18n(context, 'coords_variablecoordinate_toomanyresults_text', parameters: [countCombinations]), null,
                  cancelButton: false);

              return;
            }

            if (countCombinations >= _WARNING_COUNT) {
              showGCWAlertDialog(
                context,
                i18n(context, 'coords_variablecoordinate_manyresults_title'),
                i18n(context, 'coords_variablecoordinate_manyresults_text', parameters: [countCombinations]),
                () {
                  _calculateOutput(context);
                },
              );
            } else {
              _calculateOutput(context);
            }
          },
        ),
        _output ?? Container(),
      ],
    );
  }

  Widget _buildVariablesEditor() {
    return GCWKeyValueEditor(
      keyHintText: i18n(context, 'coords_variablecoordinate_variable'),
      valueHintText: i18n(context, 'coords_variablecoordinate_possiblevalues'),
      valueInputFormatters: [CoordsTextVariableCoordinateTextInputFormatter()],
      valueFlex: 2,
      onAddEntry: _addEntry,
      onNewEntryChanged: _updateNewEntry,
      onDispose: _disposeEntry,
      formulaValueList: widget.formula.values,
      onUpdateEntry: _updateEntry,
      onRemoveEntry: _removeEntry,
    );
  }

  Widget _buildProjectionInput() {
    return _currentProjectionMode
        ? Column(
            children: [
              Row(
                children: <Widget>[
                  Expanded(
                      flex: 3,
                      child: Container(
                        child: GCWTextField(
                          hintText: i18n(context, 'common_distance_hint'),
                          controller: _distanceController,
                          onChanged: (text) {
                            _currentDistanceInput = text;

                            widget.formula.projection.distance = _currentDistanceInput;
                            updateFormula(widget.formula);
                          },
                        ),
                        padding: EdgeInsets.only(right: DOUBLE_DEFAULT_MARGIN),
                      )),
                  Expanded(
                      flex: 1,
                      child: GCWUnitDropDownButton(
                          unitList: allLengths(),
                          value: _currentLengthUnit,
                          onChanged: (Length value) {
                            setState(() {
                              _currentLengthUnit = value;

                              widget.formula.projection.distanceUnit = _currentLengthUnit.name;
                              updateFormula(widget.formula);
                            });
                          }))
                ],
              ),
              Row(children: <Widget>[
                Expanded(
                  flex: 9,
                  child: GCWTextField(
                    hintText: i18n(context, 'common_bearing_hint'),
                    controller: _bearingController,
                    onChanged: (text) {
                      _currentBearingInput = text;

                      widget.formula.projection.bearing = _currentBearingInput;
                      updateFormula(widget.formula);
                    },
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: GCWText(text: '°'),
                ),
                Expanded(
                  flex: 4,
                  child: GCWText(
                    text: i18n(context, 'coords_variablecoordinate_reverse') + ':',
                  ),
                ),
                Expanded(
                    flex: 3,
                    child: GCWOnOffSwitch(
                      value: _currentReverseBearing,
                      notitle: true,
                      onChanged: (value) {
                        setState(() {
                          _currentReverseBearing = value;

                          widget.formula.projection.reverse = _currentReverseBearing;
                          updateFormula(widget.formula);
                        });
                      },
                    ))
              ])
            ],
          )
        : Container();
  }

  Map<String, String> _getSubstitutions() {
    Map<String, String> _substitutions = {};
    widget.formula.values.forEach((value) {
      _substitutions.putIfAbsent(value.key, () => value.value);
    });

    if (_currentFromInput != null &&
        _currentFromInput.length > 0 &&
        _currentToInput != null &&
        _currentToInput.length > 0) {
      _substitutions.putIfAbsent(_currentFromInput, () => _currentToInput);
    }

    return _substitutions;
  }

  _calculateOutput(BuildContext context) {
    Map<String, String> _substitutions = _getSubstitutions();

    Map<String, dynamic> projectionData;
    if (_currentProjectionMode) {
      projectionData = {
        'bearing': _currentProjectionMode == false || _currentBearingInput.length == 0 ? '0' : _currentBearingInput,
        'distance': _currentProjectionMode == false || _currentDistanceInput.length == 0 ? '0' : _currentDistanceInput,
        'reverseBearing': _currentReverseBearing,
        'lengthUnit': _currentLengthUnit,
        'ellipsoid': defaultEllipsoid()
      };
    }

    var coords = parseVariableLatLon(_currentInput, _substitutions, projectionData: projectionData);

    setState(() {
      _buildOutput(coords);
    });
  }

  _formatVariables(variables) {
    return variables.entries
        .map((variable) => variable.key.toUpperCase() + ': ' + variable.value.toString())
        .join(', ');
  }

  _buildOutput(Map<String, dynamic> coords) {
    var normalCoords = coords['coordinates'];
    var leftPaddedCoords = coords['leftPadCoordinates'];

    var hasLeftPaddedCoords = leftPaddedCoords.length > 0;

    _currentOutput = List<GCWOutputText>.from(
        (_currentCoordMode == GCWSwitchPosition.left ? normalCoords : leftPaddedCoords).map((coord) {
      var formattedCoordinate = formatCoordOutput(coord['coordinate'], _currentOutputFormat, defaultEllipsoid());
      return GCWOutputText(
        text: formattedCoordinate + '\n' + _formatVariables(coord['variables']),
        copyText: formattedCoordinate,
      );
    }));

    _currentMapPoints = List<GCWMapPoint>.from(
        (_currentCoordMode == GCWSwitchPosition.left ? normalCoords : leftPaddedCoords).map((coord) {
      return GCWMapPoint(
          point: coord['coordinate'],
          markerText: _formatVariables(coord['variables']),
          coordinateFormat: _currentOutputFormat);
    }));

    if (_currentOutput.length == 0) {
      _currentOutput = [i18n(context, 'coords_variablecoordinate_nooutputs')];
    }

    _output = Column(children: [
      _currentOutputFormat['format'] == keyCoordsDMM && hasLeftPaddedCoords
          ? GCWTwoOptionsSwitch(
              title: i18n(context, 'coords_variablecoordinate_decleftpad'),
              leftValue: i18n(context, 'coords_variablecoordinate_decleftpad_left'),
              rightValue: i18n(context, 'coords_variablecoordinate_decleftpad_right'),
              value: _currentCoordMode,
              onChanged: (value) {
                setState(() {
                  _currentCoordMode = value;
                  _buildOutput(coords);
                });
              },
            )
          : Container(),
      GCWCoordsOutput(
        mapButtonTop: true,
        outputs: _currentOutput,
        points: _currentMapPoints,
      )
    ]);
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

        var coords = LatLng(locationData.latitude, locationData.longitude);
        var insertedCoord;
        if (defaultCoordFormat()['format'] == keyCoordsDMM) {
          //Insert Geocaching Format with exact 3 digits
          insertedCoord = formatCoordOutput(coords, defaultCoordFormat(), defaultEllipsoid(), 3);
        } else {
          insertedCoord = formatCoordOutput(coords, defaultCoordFormat(), defaultEllipsoid());
        }

        _currentInput = insertedCoord.replaceAll('\n', ' ');
        _inputController.text = _currentInput;

        setState(() {
          _isOnLocationAccess = false;
        });
      });
    });
  }
}
