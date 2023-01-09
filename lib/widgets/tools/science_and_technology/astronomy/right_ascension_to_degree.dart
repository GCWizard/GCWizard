import 'package:flutter/material.dart';
import 'package:gc_wizard/i18n/app_localizations.dart';
import 'package:gc_wizard/logic/tools/coords/converter/dmm.dart';
import 'package:gc_wizard/logic/tools/coords/converter/dms.dart';
import 'package:gc_wizard/logic/tools/coords/data/coordinates.dart';
import 'package:gc_wizard/logic/tools/science_and_technology/astronomy/right_ascension_to_degree.dart';
import 'package:gc_wizard/theme/theme.dart';
import 'package:gc_wizard/widgets/common/base/gcw_dropdownbutton.dart';
import 'package:gc_wizard/widgets/common/base/gcw_iconbutton.dart';
import 'package:gc_wizard/widgets/common/base/gcw_text.dart';
import 'package:gc_wizard/widgets/common/base/gcw_toast.dart';
import 'package:gc_wizard/widgets/common/gcw_columned_multiline_output.dart';
import 'package:gc_wizard/widgets/common/gcw_datetime_picker.dart';
import 'package:gc_wizard/widgets/common/gcw_default_output.dart';
import 'package:gc_wizard/widgets/common/gcw_integer_textfield.dart';
import 'package:gc_wizard/widgets/common/gcw_output.dart';
import 'package:gc_wizard/widgets/common/gcw_paste_button.dart';
import 'package:gc_wizard/widgets/common/gcw_text_divider.dart';
import 'package:gc_wizard/widgets/common/gcw_toolbar.dart';
import 'package:gc_wizard/widgets/common/gcw_twooptions_switch.dart';
import 'package:gc_wizard/widgets/tools/coords/base/gcw_coords_sign_dropdownbutton.dart';
import 'package:gc_wizard/widgets/utils/textinputformatter/integer_minutesseconds_textinputformatter.dart';
import 'package:gc_wizard/widgets/utils/textinputformatter/integer_textinputformatter.dart';


class RightAscensionToDegree extends StatefulWidget {
  @override
  RightAscensionToDegreeState createState() => RightAscensionToDegreeState();
}

class RightAscensionToDegreeState extends State<RightAscensionToDegree> {
  FocusNode _hoursFocusNode;
  FocusNode _minutesFocusNode;
  FocusNode _secondsFocusNode;
  FocusNode _mSecondsFocusNode;

  FocusNode _decMilliDegreesFocusNode;

  TextEditingController _hoursController;
  TextEditingController _minutesController;
  TextEditingController _secondsController;
  TextEditingController _mSecondsController;

  TextEditingController _decDegreesController;
  TextEditingController _decMilliDegreesController;

  var _currentRaDeg = RaDeg(0.0);
  var _currentRightAscension = RightAscension(0, 0, 0, 0.0);
  var _currentDecryptFormat = keyCoordsDEC;

  var _currentDecSign = 1;
  String _currentDecDegrees = '0';
  String _currentDecMilliDegrees = '0';

  TextEditingController _DmmDegreesController;
  TextEditingController _DmmMinutesController;
  TextEditingController _DmmMilliMinutesController;
  int _currentDmmSign = 1;
  String _currentDmmDegrees = '0';
  String _currentDmmMinutes = '0';
  String _currentDmmMilliMinutes = '0';
  FocusNode _dmmMinutesFocusNode;
  FocusNode _dmmMilliMinutesFocusNode;

  TextEditingController _DmsDegreesController;
  TextEditingController _DmsMinutesController;
  TextEditingController _DmsSecondsController;
  TextEditingController _DmsMilliSecondsController;
  int _currentDmsSign = 1;
  String _currentDmsDegrees = '0';
  String _currentDmsMinutes = '0';
  String _currentDmsSeconds = '0';
  String _currentDmsMilliSeconds = '0';
  FocusNode _dmsMinutesFocusNode;
  FocusNode _dmsSecondsFocusNode;
  FocusNode _dmsMilliSecondsFocusNode;

  GCWSwitchPosition _currentMode = GCWSwitchPosition.right;

  @override
  void initState() {
    super.initState();
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
    _hoursController?.dispose();
    _minutesController?.dispose();
    _secondsController?.dispose();
    _mSecondsController?.dispose();

    _decDegreesController?.dispose();
    _decMilliDegreesController?.dispose();

    _hoursFocusNode?.dispose();
    _minutesFocusNode?.dispose();
    _secondsFocusNode?.dispose();
    _mSecondsFocusNode?.dispose();

    _decMilliDegreesFocusNode?.dispose();

    _DmmDegreesController?.dispose();
    _DmmMinutesController?.dispose();
    _DmmMilliMinutesController?.dispose();
    _dmmMinutesFocusNode?.dispose();
    _dmmMilliMinutesFocusNode?.dispose();

    _DmsDegreesController?.dispose();
    _DmsMinutesController?.dispose();
    _DmsSecondsController?.dispose();
    _DmsMilliSecondsController?.dispose();
    _dmsMinutesFocusNode?.dispose();
    _dmsSecondsFocusNode?.dispose();
    _dmsMilliSecondsFocusNode?.dispose();

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
                trailing: GCWPasteButton(
                iconSize: IconButtonSize.SMALL,
                onSelected: (text) {
                  setState(() {
                    _parseRAPaste(text);
                  });
                },
              )),
        _currentMode == GCWSwitchPosition.left ? _buildDecryptWidget() : _buildHmsWidget(),
        Container(height: 10),
        _buildOutput()
      ],
    );
  }

  Widget _buildDecryptWidget() {
    var _decryptWidget;
    switch (_currentDecryptFormat) {
      case keyCoordsDEC:
        _decryptWidget = _buildDecPartRow();
        break;
      case keyCoordsDMM:
        _decryptWidget = _buildDmmPartRow();
        break;
      case keyCoordsDMS:
        _decryptWidget = _buildDmsPartRow();
        break;
    }

    return Column(children: [
      GCWDropDownButton(
        value: _currentDecryptFormat,
        onChanged: (newValue) {
          setState(() {
            _currentDecryptFormat = newValue;

            switch (_currentDecryptFormat) {
              case keyCoordsDEC:
                _setDecRightAscension();
                break;
              case keyCoordsDMM:
                _setDmmDegrees();
                break;
              case keyCoordsDMS:
                _setDmsRightAscension();
                break;
            }
          });
        },
        items: [
          GCWDropDownMenuItem(
            value: keyCoordsDEC,
            child: getCoordinateFormatByKey(keyCoordsDEC).name,
          ),
          GCWDropDownMenuItem(
            value: keyCoordsDMM,
            child: getCoordinateFormatByKey(keyCoordsDMM).name,
          ),
          GCWDropDownMenuItem(
            value: keyCoordsDMS,
            child: getCoordinateFormatByKey(keyCoordsDMS).name,
          ),
        ],
      ),
      Container(height: 10),
      _decryptWidget
    ]);
  }

  Widget _buildHmsWidget() {
    return Column(children: [
      GCWToolBar(
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
        flexValues: [5, 5, 1, 5, 1, 5, 1, 8],
      ),
      GCWDateTimePicker(
        config: {
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
            _currentRightAscension = RightAscension.fromDuration(value['duration']);
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
            child: GCWCoordsSignDropDownButton(
                itemList: ['+', '-'],
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
                child: GCWIntegerTextField(
                    hintText: 'DD',
                    textInputFormatter: IntegerTextInputFormatter(min: 0),
                    controller: _DmmDegreesController,
                    onChanged: (ret) {
                      setState(() {
                        _currentDmmDegrees = ret['text'];
                        _setDmmDegrees();
                      });
                    }),
                padding: EdgeInsets.only(left: DOUBLE_DEFAULT_MARGIN),
              )),
          Expanded(
            flex: 1,
            child: GCWText(align: Alignment.center, text: '°'),
          ),
          Expanded(
            flex: 6,
            child: GCWIntegerTextField(
                hintText: 'MM',
                textInputFormatter: IntegerMinutesSecondsTextInputFormatter(),
                controller: _DmmMinutesController,
                focusNode: _dmmMinutesFocusNode,
                onChanged: (ret) {
                  setState(() {
                    _currentDmmMinutes = ret['text'];
                    _setDmmDegrees();

                    if (_currentDmmMinutes.length == 2) FocusScope.of(context).requestFocus(_dmmMilliMinutesFocusNode);
                  });
                }),
          ),
          Expanded(
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
                    _currentDmmMilliMinutes = ret['text'];
                    _setDmmDegrees();
                  });
                }),
          ),
          Expanded(
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
            child: GCWCoordsSignDropDownButton(
                itemList: ['+', '-'],
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
                child: GCWIntegerTextField(
                    hintText: 'DD',
                    textInputFormatter: IntegerTextInputFormatter(min: 0),
                    controller: _DmsDegreesController,
                    onChanged: (ret) {
                      setState(() {
                        _currentDmsDegrees = ret['text'];
                        _setDmsRightAscension();
                      });
                    }),
                padding: EdgeInsets.only(left: DOUBLE_DEFAULT_MARGIN),
              )),
          Expanded(
            flex: 1,
            child: GCWText(align: Alignment.center, text: '°'),
          ),
          Expanded(
            flex: 6,
            child: GCWIntegerTextField(
                hintText: 'MM',
                textInputFormatter: IntegerMinutesSecondsTextInputFormatter(),
                controller: _DmsMinutesController,
                focusNode: _dmsMinutesFocusNode,
                onChanged: (ret) {
                  setState(() {
                    _currentDmsMinutes = ret['text'];
                    _setDmsRightAscension();

                    if (_currentDmsMinutes.length == 2) FocusScope.of(context).requestFocus(_dmsSecondsFocusNode);
                  });
                }),
          ),
          Expanded(
            flex: 1,
            child: GCWText(align: Alignment.center, text: '\''),
          ),
          Expanded(
            flex: 6,
            child: GCWIntegerTextField(
                hintText: 'SS',
                textInputFormatter: IntegerMinutesSecondsTextInputFormatter(),
                controller: _DmsSecondsController,
                focusNode: _dmsSecondsFocusNode,
                onChanged: (ret) {
                  setState(() {
                    _currentDmsSeconds = ret['text'];
                    _setDmsRightAscension();

                    if (_currentDmsSeconds.length == 2) FocusScope.of(context).requestFocus(_dmsMilliSecondsFocusNode);
                  });
                }),
          ),
          Expanded(
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
                    _currentDmsMilliSeconds = ret['text'];
                    _setDmsRightAscension();
                  });
                }),
          ),
          Expanded(
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
            child: GCWCoordsSignDropDownButton(
                itemList: ['+', '-'],
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
                child: GCWIntegerTextField(
                    hintText: 'DD',
                    textInputFormatter: IntegerTextInputFormatter(min: 0),
                    controller: _decDegreesController,
                    onChanged: (ret) {
                      setState(() {
                        _currentDecDegrees = ret['text'];
                        _setDecRightAscension();
                      });
                    }),
                padding: EdgeInsets.only(left: DOUBLE_DEFAULT_MARGIN),
              )),
          Expanded(
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
                    _currentDecMilliDegrees = ret['text'];
                    _setDecRightAscension();
                  });
                }),
          ),
          Expanded(
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
      RaDeg output = raRightAscension2Degree(_currentRightAscension);
      var dmm = DMMLatitude.from(doubleToDMMPart(output.degrees)).format(6).replaceAll('N ', '').replaceAll('S ', '-');

      var dms = DMSLatitude.from(doubleToDMSPart(output.degrees)).format(6).replaceAll('N ', '').replaceAll('S ', '-');

      var rows = [
        [getCoordinateFormatByKey(keyCoordsDEC).name, output.toString() + '°'],
        [getCoordinateFormatByKey(keyCoordsDMM).name, dmm],
        [getCoordinateFormatByKey(keyCoordsDMS).name, dms],
      ];
      return GCWDefaultOutput(child: GCWColumnedMultilineOutput(data: rows));
    }
  }

  _parseRAPaste(String input) {
    var rightAscension = RightAscension.parse(input);
    if (rightAscension == null) {
      showToast(i18n(context, 'right_ascension_to_degree_clipboard_nodatafound'));
      return;
    }

    _currentRightAscension = rightAscension;
    setState(() {
      _hoursController.text = _currentRightAscension?.hours?.abs().toString();
      _minutesController.text = _currentRightAscension?.minutes?.toString();
      _secondsController.text = _currentRightAscension?.seconds?.truncate().toString();
      _mSecondsController.text = _currentRightAscension?.milliseconds?.toString();
    });
  }
}
