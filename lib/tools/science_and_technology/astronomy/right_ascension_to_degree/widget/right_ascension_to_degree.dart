import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/application/theme/theme.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_iconbutton.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_paste_button.dart';
import 'package:gc_wizard/common_widgets/dividers/gcw_text_divider.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_dropdown.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_sign_dropdown.dart';
import 'package:gc_wizard/common_widgets/gcw_datetime_picker.dart';
import 'package:gc_wizard/common_widgets/gcw_snackbar.dart';
import 'package:gc_wizard/common_widgets/gcw_text.dart';
import 'package:gc_wizard/common_widgets/gcw_toolbar.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_columned_multiline_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_output.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_twooptions_switch.dart';
import 'package:gc_wizard/common_widgets/text_input_formatters/gcw_integer_textinputformatter.dart';
import 'package:gc_wizard/common_widgets/text_input_formatters/gcw_minutesseconds_textinputformatter.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_integer_textfield.dart';
import 'package:gc_wizard/tools/coords/_common/formats/dmm/logic/dmm.dart';
import 'package:gc_wizard/tools/coords/_common/formats/dms/logic/dms.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinate_format_constants.dart';
import 'package:gc_wizard/tools/coords/_common/widget/gcw_coords.dart';
import 'package:gc_wizard/tools/science_and_technology/astronomy/right_ascension_to_degree/logic/right_ascension_to_degree.dart';

class RightAscensionToDegree extends StatefulWidget {
  const RightAscensionToDegree({Key? key}) : super(key: key);

  @override
  _RightAscensionToDegreeState createState() => _RightAscensionToDegreeState();
}

class _RightAscensionToDegreeState extends State<RightAscensionToDegree> {
  late FocusNode _decMilliDegreesFocusNode;

  late TextEditingController _hoursController;
  late TextEditingController _minutesController;
  late TextEditingController _secondsController;
  late TextEditingController _mSecondsController;

  late TextEditingController _decDegreesController;
  late TextEditingController _decMilliDegreesController;

  var _currentRaDeg = RaDeg(0.0);
  var _currentRightAscension = RightAscension(0, 0, 0, 0.0);
  var _currentDecryptFormat = CoordinateFormatKey.DEC;

  var _currentDecSign = 1;
  String _currentDecDegrees = '0';
  String _currentDecMilliDegrees = '0';

  late TextEditingController _DmmDegreesController;
  late TextEditingController _DmmMinutesController;
  late TextEditingController _DmmMilliMinutesController;
  int _currentDmmSign = 1;
  String _currentDmmDegrees = '0';
  String _currentDmmMinutes = '0';
  String _currentDmmMilliMinutes = '0';
  late FocusNode _dmmMinutesFocusNode;
  late FocusNode _dmmMilliMinutesFocusNode;

  late TextEditingController _DmsDegreesController;
  late TextEditingController _DmsMinutesController;
  late TextEditingController _DmsSecondsController;
  late TextEditingController _DmsMilliSecondsController;
  int _currentDmsSign = 1;
  String _currentDmsDegrees = '0';
  String _currentDmsMinutes = '0';
  String _currentDmsSeconds = '0';
  String _currentDmsMilliSeconds = '0';
  late FocusNode _dmsMinutesFocusNode;
  late FocusNode _dmsSecondsFocusNode;
  late FocusNode _dmsMilliSecondsFocusNode;

  GCWSwitchPosition _currentMode = GCWSwitchPosition.right;

  @override
  void initState() {
    super.initState();

    _decMilliDegreesFocusNode = FocusNode();

    _hoursController = TextEditingController(text: _currentRightAscension.hours.toString());
    _minutesController = TextEditingController(text: _currentRightAscension.minutes.toString());
    _secondsController = TextEditingController(text: _currentRightAscension.seconds.truncate().toString());
    _mSecondsController = TextEditingController(text: _currentRightAscension.seconds.toString().split('.')[1]);

    _decDegreesController = TextEditingController(text: _currentDecDegrees);
    _decMilliDegreesController = TextEditingController(text: _currentDecMilliDegrees);

    _DmmDegreesController = TextEditingController(text: _currentDmmDegrees.toString());
    _DmmMinutesController = TextEditingController(text: _currentDmmMinutes.toString());
    _DmmMilliMinutesController = TextEditingController(text: _currentDmmMilliMinutes.toString());
    _dmmMinutesFocusNode = FocusNode();
    _dmmMilliMinutesFocusNode = FocusNode();

    _DmsDegreesController = TextEditingController(text: _currentDmsDegrees.toString());
    _DmsMinutesController = TextEditingController(text: _currentDmsMinutes.toString());
    _DmsSecondsController = TextEditingController(text: _currentDmsSeconds.toString());
    _DmsMilliSecondsController = TextEditingController(text: _currentDmsMilliSeconds.toString());
    _dmsMinutesFocusNode = FocusNode();
    _dmsSecondsFocusNode = FocusNode();
    _dmsMilliSecondsFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _hoursController.dispose();
    _minutesController.dispose();
    _secondsController.dispose();
    _mSecondsController.dispose();

    _decDegreesController.dispose();
    _decMilliDegreesController.dispose();

    _decMilliDegreesFocusNode.dispose();

    _DmmDegreesController.dispose();
    _DmmMinutesController.dispose();
    _DmmMilliMinutesController.dispose();
    _dmmMinutesFocusNode.dispose();
    _dmmMilliMinutesFocusNode.dispose();

    _DmsDegreesController.dispose();
    _DmsMinutesController.dispose();
    _DmsSecondsController.dispose();
    _DmsMilliSecondsController.dispose();
    _dmsMinutesFocusNode.dispose();
    _dmsSecondsFocusNode.dispose();
    _dmsMilliSecondsFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GCWTwoOptionsSwitch(
          value: _currentMode,
          onChanged: (value) {
            setState(() {
              _currentMode = value;
            });
          },
        ),
        _currentMode == GCWSwitchPosition.left
            ? Container()
            : GCWTextDivider(
                text: '',
                trailing: GCWPasteButton(
                  iconSize: IconButtonSize.SMALL,
                  onSelected: (text) {
                    setState(() {
                      _parseRAPaste(text);
                    });
                  },
                ),
              ),
        _currentMode == GCWSwitchPosition.left ? _buildDecryptWidget() : _buildHmsWidget(),
        Container(height: 10),
        _buildOutput()
      ],
    );
  }

  Widget _buildDecryptWidget() {
    Widget _decryptWidget;
    switch (_currentDecryptFormat) {
      case CoordinateFormatKey.DEC:
        _decryptWidget = _buildDecPartRow();
        break;
      case CoordinateFormatKey.DMM:
        _decryptWidget = _buildDmmPartRow();
        break;
      case CoordinateFormatKey.DMS:
        _decryptWidget = _buildDmsPartRow();
        break;
      default:
        _decryptWidget = _buildDecPartRow();
    }

    return Column(children: [
      GCWDropDown<CoordinateFormatKey>(
        value: _currentDecryptFormat,
        onChanged: (newValue) {
          setState(() {
            _currentDecryptFormat = newValue;

            switch (_currentDecryptFormat) {
              case CoordinateFormatKey.DEC:
                _setDecRightAscension();
                break;
              case CoordinateFormatKey.DMM:
                _setDmmDegrees();
                break;
              case CoordinateFormatKey.DMS:
                _setDmsRightAscension();
                break;
              default:
                _setDecRightAscension();
            }
          });
        },
        items: [
          GCWDropDownMenuItem(
            value: CoordinateFormatKey.DEC,
            child: coordinateWidgetInfoByType(CoordinateFormatKey.DEC)!.name,
          ),
          GCWDropDownMenuItem(
            value: CoordinateFormatKey.DMM,
            child: coordinateWidgetInfoByType(CoordinateFormatKey.DMM)!.name,
          ),
          GCWDropDownMenuItem(
            value: CoordinateFormatKey.DMS,
            child: coordinateWidgetInfoByType(CoordinateFormatKey.DMS)!.name,
          ),
        ],
      ),
      Container(height: 10),
      _decryptWidget
    ]);
  }

  Widget _buildHmsWidget() {
    return Column(children: [
      const GCWToolBar(
        flexValues: [5, 5, 1, 5, 1, 5, 1, 8],
        children: [
          GCWText(text: '+/-', align: Alignment.center),
          GCWText(text: 'h', align: Alignment.center),
          GCWText(text: ''),
          GCWText(text: 'min', align: Alignment.center),
          GCWText(text: ''),
          GCWText(text: 's', align: Alignment.center),
          GCWText(text: ''),
          GCWText(text: 'ms', align: Alignment.center)
        ],
      ),
      GCWDateTimePicker(
        config: const {
          DateTimePickerConfig.SIGN,
          DateTimePickerConfig.TIME,
          DateTimePickerConfig.SECOND_AS_INT,
          DateTimePickerConfig.TIME_MSEC
        },
        hoursController: _hoursController,
        minutesController: _minutesController,
        secondsController: _secondsController,
        mSecondsController: _mSecondsController,
        maxHours: null,
        duration: _currentRightAscension.toDuration(),
        onChanged: (value) {
          setState(() {
            _currentRightAscension = RightAscension.fromDuration(value.duration)!;
          });
        },
      ),
    ]);
  }

  Widget _buildDmmPartRow() {
    return Column(children: [
      Row(
        children: <Widget>[
          Expanded(
            flex: 6,
            child: GCWSignDropDown(
                itemList: const ['+', '-'],
                value: _currentDmmSign,
                onChanged: (value) {
                  setState(() {
                    _currentDmmSign = value;
                    _setDmmDegrees();
                  });
                }),
          ),
          Expanded(
              flex: 6,
              child: Container(
                padding: const EdgeInsets.only(left: DOUBLE_DEFAULT_MARGIN),
                child: GCWIntegerTextField(
                    hintText: 'DD',
                    textInputFormatter: GCWIntegerTextInputFormatter(min: 0),
                    controller: _DmmDegreesController,
                    onChanged: (ret) {
                      setState(() {
                        _currentDmmDegrees = ret.text;
                        _setDmmDegrees();
                      });
                    }),
              )),
          const Expanded(
            flex: 1,
            child: GCWText(align: Alignment.center, text: '°'),
          ),
          Expanded(
            flex: 6,
            child: GCWIntegerTextField(
                hintText: 'MM',
                textInputFormatter: GCWMinutesSecondsTextInputFormatter(),
                controller: _DmmMinutesController,
                focusNode: _dmmMinutesFocusNode,
                onChanged: (ret) {
                  setState(() {
                    _currentDmmMinutes = ret.text;
                    _setDmmDegrees();

                    if (_currentDmmMinutes.length == 2) FocusScope.of(context).requestFocus(_dmmMilliMinutesFocusNode);
                  });
                }),
          ),
          const Expanded(
            flex: 1,
            child: GCWText(align: Alignment.center, text: '.'),
          ),
          Expanded(
            flex: 13,
            child: GCWIntegerTextField(
                hintText: 'MMM',
                min: 0,
                controller: _DmmMilliMinutesController,
                focusNode: _dmmMilliMinutesFocusNode,
                onChanged: (ret) {
                  setState(() {
                    _currentDmmMilliMinutes = ret.text;
                    _setDmmDegrees();
                  });
                }),
          ),
          const Expanded(
            flex: 1,
            child: GCWText(align: Alignment.center, text: '\''),
          ),
        ],
      ),
    ]);
  }

  Widget _buildDmsPartRow() {
    return Column(children: [
      Row(
        children: <Widget>[
          Expanded(
            flex: 6,
            child: GCWSignDropDown(
                itemList: const ['+', '-'],
                value: _currentDmsSign,
                onChanged: (value) {
                  setState(() {
                    _currentDmsSign = value;
                    _setDmsRightAscension();
                  });
                }),
          ),
          Expanded(
              flex: 6,
              child: Container(
                padding: const EdgeInsets.only(left: DOUBLE_DEFAULT_MARGIN),
                child: GCWIntegerTextField(
                    hintText: 'DD',
                    textInputFormatter: GCWIntegerTextInputFormatter(min: 0),
                    controller: _DmsDegreesController,
                    onChanged: (ret) {
                      setState(() {
                        _currentDmsDegrees = ret.text;
                        _setDmsRightAscension();
                      });
                    }),
              )),
          const Expanded(
            flex: 1,
            child: GCWText(align: Alignment.center, text: '°'),
          ),
          Expanded(
            flex: 6,
            child: GCWIntegerTextField(
                hintText: 'MM',
                textInputFormatter: GCWMinutesSecondsTextInputFormatter(),
                controller: _DmsMinutesController,
                focusNode: _dmsMinutesFocusNode,
                onChanged: (ret) {
                  setState(() {
                    _currentDmsMinutes = ret.text;
                    _setDmsRightAscension();

                    if (_currentDmsMinutes.length == 2) FocusScope.of(context).requestFocus(_dmsSecondsFocusNode);
                  });
                }),
          ),
          const Expanded(
            flex: 1,
            child: GCWText(align: Alignment.center, text: '\''),
          ),
          Expanded(
            flex: 6,
            child: GCWIntegerTextField(
                hintText: 'SS',
                textInputFormatter: GCWMinutesSecondsTextInputFormatter(),
                controller: _DmsSecondsController,
                focusNode: _dmsSecondsFocusNode,
                onChanged: (ret) {
                  setState(() {
                    _currentDmsSeconds = ret.text;
                    _setDmsRightAscension();

                    if (_currentDmsSeconds.length == 2) FocusScope.of(context).requestFocus(_dmsMilliSecondsFocusNode);
                  });
                }),
          ),
          const Expanded(
            flex: 1,
            child: GCWText(align: Alignment.center, text: '.'),
          ),
          Expanded(
            flex: 6,
            child: GCWIntegerTextField(
                hintText: 'SSS',
                min: 0,
                controller: _DmsMilliSecondsController,
                focusNode: _dmsMilliSecondsFocusNode,
                onChanged: (ret) {
                  setState(() {
                    _currentDmsMilliSeconds = ret.text;
                    _setDmsRightAscension();
                  });
                }),
          ),
          const Expanded(
            flex: 1,
            child: GCWText(align: Alignment.center, text: '"'),
          ),
        ],
      ),
    ]);
  }

  void _setDmsRightAscension() {
    int _degrees = ['', '-'].contains(_currentDmsDegrees) ? 0 : int.parse(_currentDmsDegrees);
    int _minutes = ['', '-'].contains(_currentDmsMinutes) ? 0 : int.parse(_currentDmsMinutes);
    int _seconds = ['', '-'].contains(_currentDmsSeconds) ? 0 : int.parse(_currentDmsSeconds);
    double _secondsD = double.parse('$_seconds.$_currentDmsMilliSeconds');

    _currentRaDeg = RaDeg.fromDMS(_currentDmsSign, _degrees, _minutes, _secondsD);
  }

  void _setDmmDegrees() {
    int _degrees = ['', '-'].contains(_currentDmmDegrees) ? 0 : int.parse(_currentDmmDegrees);
    int _minutes = ['', '-'].contains(_currentDmmMinutes) ? 0 : int.parse(_currentDmmMinutes);
    double _minutesD = double.parse('$_minutes.$_currentDmmMilliMinutes');

    _currentRaDeg = RaDeg.fromDMM(_currentDmmSign, _degrees, _minutesD);
  }

  void _setDecRightAscension() {
    int _degrees = ['', '-'].contains(_currentDecDegrees) ? 0 : int.parse(_currentDecDegrees);
    double _degreesD = double.parse('$_degrees.$_currentDecMilliDegrees');

    _currentRaDeg = RaDeg.fromDEC(_currentDecSign, _degreesD);
  }

  Widget _buildDecPartRow() {
    return Column(children: <Widget>[
      Row(
        children: <Widget>[
          Expanded(
            flex: 6,
            child: GCWSignDropDown(
                itemList: const ['+', '-'],
                value: _currentDecSign,
                onChanged: (value) {
                  setState(() {
                    _currentDecSign = value;
                    _setDecRightAscension();
                  });
                }),
          ),
          Expanded(
              flex: 6,
              child: Container(
                padding: const EdgeInsets.only(left: DOUBLE_DEFAULT_MARGIN),
                child: GCWIntegerTextField(
                    hintText: 'DD',
                    textInputFormatter: GCWIntegerTextInputFormatter(min: 0),
                    controller: _decDegreesController,
                    onChanged: (ret) {
                      setState(() {
                        _currentDecDegrees = ret.text;
                        _setDecRightAscension();
                      });
                    }),
              )),
          const Expanded(
            flex: 1,
            child: GCWText(align: Alignment.center, text: '.'),
          ),
          Expanded(
            flex: 20,
            child: GCWIntegerTextField(
                hintText: 'DDD',
                min: 0,
                controller: _decMilliDegreesController,
                focusNode: _decMilliDegreesFocusNode,
                onChanged: (ret) {
                  setState(() {
                    _currentDecMilliDegrees = ret.text;
                    _setDecRightAscension();
                  });
                }),
          ),
          const Expanded(
            flex: 1,
            child: GCWText(align: Alignment.center, text: '°'),
          ),
          Container(height: 10),
        ],
      ),
    ]);
  }

  Widget _buildOutput() {
    if (_currentMode == GCWSwitchPosition.left) {
      return GCWOutput(
          title: i18n(context, 'common_output') + ': ' + i18n(context, 'astronomy_position_rightascension'),
          child: raDegree2RightAscension(_currentRaDeg).toString());
    } else {
      RaDeg output = raRightAscension2Degree(_currentRightAscension)!;
      var dmm = DMMLatitude.from(doubleToDMMPart(output.degrees)).format(6).replaceAll('N ', '').replaceAll('S ', '-');

      var dms = DMSLatitude.from(doubleToDMSPart(output.degrees)).format(6).replaceAll('N ', '').replaceAll('S ', '-');

      var rows = [
        [coordinateWidgetInfoByType(CoordinateFormatKey.DEC)!.name, output.toString() + '°'],
        [coordinateWidgetInfoByType(CoordinateFormatKey.DMM)!.name, dmm],
        [coordinateWidgetInfoByType(CoordinateFormatKey.DMS)!.name, dms],
      ];
      return GCWDefaultOutput(child: GCWColumnedMultilineOutput(data: rows));
    }
  }

  void _parseRAPaste(String input) {
    var rightAscension = RightAscension.parse(input);
    if (rightAscension == null) {
      showSnackBar(i18n(context, 'right_ascension_to_degree_clipboard_nodatafound'), context);
      return;
    }

    _currentRightAscension = rightAscension;
    setState(() {
      _hoursController.text = _currentRightAscension.hours.abs().toString();
      _minutesController.text = _currentRightAscension.minutes.toString();
      _secondsController.text = _currentRightAscension.seconds.truncate().toString();
      _mSecondsController.text = _currentRightAscension.milliseconds.toString();
    });
  }
}
