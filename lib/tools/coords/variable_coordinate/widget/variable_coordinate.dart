import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/application/permissions/user_location.dart';
import 'package:gc_wizard/application/theme/theme.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_iconbutton.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_submit_button.dart';
import 'package:gc_wizard/tools/coords/_common/widget/gcw_coords_output/gcw_coords_output.dart';
import 'package:gc_wizard/tools/coords/_common/widget/gcw_coords_output/gcw_coords_outputformat.dart';
import 'package:gc_wizard/common_widgets/dialogs/gcw_dialog.dart';
import 'package:gc_wizard/common_widgets/dividers/gcw_text_divider.dart';
import 'package:gc_wizard/common_widgets/gcw_snackbar.dart';
import 'package:gc_wizard/common_widgets/gcw_text.dart';
import 'package:gc_wizard/common_widgets/key_value_editor/gcw_key_value_editor.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_output_text.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_onoff_switch.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_twooptions_switch.dart';
import 'package:gc_wizard/common_widgets/text_input_formatters/variablestring_textinputformatter.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/common_widgets/units/gcw_unit_dropdown.dart';
import 'package:gc_wizard/tools/coords/_common/formats/dmm/logic/dmm.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinate_format_constants.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinate_text_formatter.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinates.dart';
import 'package:gc_wizard/tools/coords/_common/logic/default_coord_getter.dart';
import 'package:gc_wizard/tools/coords/map_view/logic/map_geometries.dart';
import 'package:gc_wizard/tools/coords/variable_coordinate/logic/variable_latlon.dart';
import 'package:gc_wizard/tools/coords/variable_coordinate/persistence/json_provider.dart';
import 'package:gc_wizard/tools/coords/variable_coordinate/persistence/model.dart';
import 'package:gc_wizard/tools/formula_solver/persistence/model.dart' as formula_base;
import 'package:gc_wizard/tools/science_and_technology/unit_converter/logic/default_units_getter.dart';
import 'package:gc_wizard/tools/science_and_technology/unit_converter/logic/length.dart';
import 'package:gc_wizard/utils/complex_return_types.dart';
import 'package:gc_wizard/utils/constants.dart';
import 'package:gc_wizard/utils/variable_string_expander.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';

const _WARNING_COUNT = 500;
const _TOOMANY_COUNT = 5000;

class VariableCoordinate extends StatefulWidget {
  final VariableCoordinateFormula formula;

  const VariableCoordinate({Key? key, required this.formula}) : super(key: key);

  @override
  _VariableCoordinateState createState() => _VariableCoordinateState();
}

class _VariableCoordinateState extends State<VariableCoordinate> {
  Widget _output = GCWCoordsOutput(outputs: const []);
  GCWSwitchPosition _currentCoordMode = GCWSwitchPosition.left;

  Length _currentLengthUnit = defaultLengthUnit;
  bool _currentProjectionMode = false;
  var _currentOutputFormat = defaultCoordinateFormat;

  late TextEditingController _inputController;
  late TextEditingController _bearingController;
  late TextEditingController _distanceController;

  var _currentInput = '';
  var _currentBearingInput = '';
  var _currentDistanceInput = '';
  var _currentReverseBearing = false;
  var _currentFromInput = '';
  var _currentToInput = '';

  List<Object> _currentOutput = [];
  List<GCWMapPoint> _currentMapPoints = [];

  bool _isOnLocationAccess = false;
  final _location = Location();

  @override
  void initState() {
    super.initState();

    _currentInput = widget.formula.formula;
    _currentProjectionMode = widget.formula.projection != null;

    if (_currentProjectionMode) {
      _currentDistanceInput = widget.formula.projection!.distance;
      _currentLengthUnit = baseLengths.firstWhere((unit) => unit.name == widget.formula.projection!.distanceUnit.name);
      _currentBearingInput = widget.formula.projection!.bearing;
      _currentReverseBearing = widget.formula.projection!.reverse;
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

  void _updateNewEntry(KeyValueBase entry) {
    _currentFromInput = entry.key;
    _currentToInput = entry.value;
  }

  void _addEntry(KeyValueBase entry) {
    if (entry.key.isNotEmpty) {
      var newEntry =
          formula_base.FormulaValue(entry.key, entry.value, type: formula_base.FormulaValueType.INTERPOLATED);
      insertFormulaValue(newEntry, widget.formula);
    }
  }

  void _updateEntry(KeyValueBase entry) {
    updateFormulaValue(entry, widget.formula);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(right: DEFAULT_MARGIN),
                child: GCWTextField(
                  controller: _inputController,
                  onChanged: (value) {
                    _currentInput = value;
                    widget.formula.formula = _currentInput;
                    updateFormula(widget.formula);
                  },
                ),
              ),
            ),
            GCWIconButton(
              icon: _isOnLocationAccess ? Icons.refresh : Icons.location_on,
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
                var projection = ProjectionData(
                    _currentDistanceInput, _currentLengthUnit, _currentBearingInput, _currentReverseBearing);

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
        _output,
      ],
    );
  }

  Widget _buildVariablesEditor() {
    return GCWKeyValueEditor(
      keyHintText: i18n(context, 'coords_variablecoordinate_variable'),
      valueHintText: i18n(context, 'coords_variablecoordinate_possiblevalues'),
      addValueInputFormatters: [VariableStringTextInputFormatter()],
      valueFlex: 4,
      onNewEntryChanged: _updateNewEntry,
      entries: widget.formula.values,
      onAddEntry: (entry) => _addEntry(entry),
      onUpdateEntry: (entry) => _updateEntry(entry),
      addOnDispose: true,
      validateEditedValue: (String input) {
        return VARIABLESTRING.hasMatch(input);
      },
      invalidEditedValueMessage: i18n(context, 'formulasolver_values_novalidinterpolated'),
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
                        padding: const EdgeInsets.only(right: DOUBLE_DEFAULT_MARGIN),
                        child: GCWTextField(
                          hintText: i18n(context, 'common_distance_hint'),
                          controller: _distanceController,
                          onChanged: (text) {
                            _currentDistanceInput = text;

                            if (_currentProjectionMode) {
                              widget.formula.projection!.distance = _currentDistanceInput;
                            }
                            updateFormula(widget.formula);
                          },
                        ),
                      )),
                  Expanded(
                      flex: 1,
                      child: GCWUnitDropDown<Length>(
                          unitList: allLengths(),
                          value: _currentLengthUnit,
                          onChanged: (Length value) {
                            setState(() {
                              _currentLengthUnit = value;

                              if (_currentProjectionMode) {
                                widget.formula.projection!.distanceUnit = _currentLengthUnit;
                              }
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

                      if (_currentProjectionMode) {
                        widget.formula.projection!.bearing = _currentBearingInput;
                      }
                      updateFormula(widget.formula);
                    },
                  ),
                ),
                const Expanded(
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

                          if (_currentProjectionMode) {
                            widget.formula.projection!.reverse = _currentReverseBearing;
                          }
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
    if (widget.formula.values.isEmpty) return _substitutions;

    for (var value in widget.formula.values) {
      _substitutions.putIfAbsent(value.key, () => value.value);
    }

    if (_currentFromInput.isNotEmpty && _currentToInput.isNotEmpty) {
      _substitutions.putIfAbsent(_currentFromInput, () => _currentToInput);
    }

    return _substitutions;
  }

  void _calculateOutput(BuildContext context) {
    Map<String, String> _substitutions = _getSubstitutions();

    ProjectionData? projectionData;
    if (_currentProjectionMode) {
      projectionData = ProjectionData(
        _currentProjectionMode == false || _currentDistanceInput.isEmpty ? '0' : _currentDistanceInput,
        _currentLengthUnit,
        _currentProjectionMode == false || _currentBearingInput.isEmpty ? '0' : _currentBearingInput,
        _currentReverseBearing,
      );
    }

    var coords = parseVariableLatLon(_currentInput, _substitutions, projectionData: projectionData);

    setState(() {
      _buildOutput(coords);
    });
  }

  String _formatVariables(Map<String, String>? variables) {
    if (variables == null || variables.isEmpty) return '';

    return variables.entries
        .map((variable) => variable.key.toUpperCase() + ': ' + variable.value.toString())
        .join(', ');
  }

  void _buildOutput(VariableCoordinateResults coords) {
    var normalCoords = coords.coordinates;
    var leftPaddedCoords = coords.leftPadCoordinates;

    var hasLeftPaddedCoords = leftPaddedCoords.isNotEmpty;

    _currentOutput = (_currentCoordMode == GCWSwitchPosition.left ? normalCoords : leftPaddedCoords)
        .map((VariableCoordinateSingleResult varCoordResult) {
      var formattedCoordinate = formatCoordOutput(varCoordResult.coordinate, _currentOutputFormat, defaultEllipsoid);
      return Column(
        children: [
          GCWOutputText(text: formattedCoordinate),
          GCWText(
              text: _formatVariables(varCoordResult.variables),
              style: gcwTextStyle().copyWith(fontSize: fontSizeSmall()))
        ],
      );
    }).toList();

    _currentMapPoints = (_currentCoordMode == GCWSwitchPosition.left ? normalCoords : leftPaddedCoords)
        .map((VariableCoordinateSingleResult varCoordResult) {
      return GCWMapPoint(
          point: varCoordResult.coordinate,
          markerText: _formatVariables(varCoordResult.variables),
          coordinateFormat: _currentOutputFormat);
    }).toList();

    if (_currentOutput.isEmpty) {
      _currentOutput = [i18n(context, 'coords_variablecoordinate_nooutputs')];
    }

    _output = Column(children: [
      _currentOutputFormat.type == CoordinateFormatKey.DMM && hasLeftPaddedCoords
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

  void _setUserLocationCoords() {
    if (_isOnLocationAccess) return;

    setState(() {
      _isOnLocationAccess = true;
    });

    checkLocationPermission(_location).then((value) {
      if (value == false) {
        setState(() {
          _isOnLocationAccess = false;
        });
        showSnackBar(i18n(context, 'coords_common_location_permissiondenied'), context);

        return;
      }

      _location.getLocation().then((locationData) {
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

        var coords = buildDefaultCoordinateByCoordinates(_coords);
        String insertedCoord;
        if (defaultCoordinateFormat.type == CoordinateFormatKey.DMM) {
          //Insert Geocaching Format with exact 3 digits
          insertedCoord = DMMCoordinate.fromLatLon(coords.toLatLng()!).toString(3);
        } else {
          insertedCoord = formatCoordOutput(coords.toLatLng()!, defaultCoordinateFormat, defaultEllipsoid);
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
