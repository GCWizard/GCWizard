import 'package:flutter/material.dart';
import 'package:gc_wizard/i18n/app_localizations.dart';
import 'package:gc_wizard/logic/common/date_utils.dart';
import 'package:gc_wizard/logic/tools/science_and_technology/maya_calendar.dart';
import 'package:gc_wizard/theme/theme.dart';
import 'package:gc_wizard/widgets/common/base/gcw_iconbutton.dart';
import 'package:gc_wizard/widgets/common/gcw_columned_multiline_output.dart';
import 'package:gc_wizard/widgets/common/gcw_integer_spinner.dart';
import 'package:gc_wizard/widgets/common/gcw_segmentdisplay_output.dart';
import 'package:gc_wizard/widgets/common/gcw_toolbar.dart';
import 'package:gc_wizard/widgets/common/gcw_twooptions_switch.dart';
import 'package:gc_wizard/widgets/tools/crypto_and_encodings/maya_numbers_segment_display.dart';

class MayaCalendar extends StatefulWidget {
  @override
  MayaCalendarState createState() => MayaCalendarState();
}

class MayaCalendarState extends State<MayaCalendar> {
  var _currentEncodeInput = 0;
  var _currentLongCount = '';
  var _longCountController;

  List<List<String>> _currentDisplays = [];
  var _currentMode = GCWSwitchPosition.right;

  @override
  void initState() {
    super.initState();
    _longCountController = TextEditingController(text: _currentLongCount);
  }

  @override
  void dispose() {
    _longCountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      GCWTwoOptionsSwitch(
        value: _currentMode,
        onChanged: (value) {
          setState(() {
            _currentMode = value;
          });
        },
      ),
      _currentMode == GCWSwitchPosition.left // encrypt: input number => output segment
          ? GCWIntegerSpinner(
              overflow: SpinnerOverflowType.SUPPRESS_OVERFLOW,
              min: 0,
              value: _currentEncodeInput,
              onChanged: (value) {
                setState(() {
                  _currentEncodeInput = value;
                });
              },
            )
          : Column(
              // decrpyt: input segment => output number
              children: <Widget>[_buildVisualDecryption()],
            ),
      _buildOutput()
    ]);
  }

  _buildVisualDecryption() {
    Map<String, bool> currentDisplay;

    var displays = _currentDisplays;
    if (displays != null && displays.length > 0)
      currentDisplay = Map<String, bool>.fromIterable(displays.last ?? [], key: (e) => e, value: (e) => true);
    else
      currentDisplay = {};

    var onChanged = (Map<String, bool> d) {
      setState(() {
        var newSegments = <String>[];
        d.forEach((key, value) {
          if (!value) return;
          newSegments.add(key);
        });

        newSegments.sort();

        if (_currentDisplays.length == 0) _currentDisplays.add([]);

        _currentDisplays[_currentDisplays.length - 1] = newSegments;
      });
    };

    return Column(
      children: <Widget>[
        Container(
          width: 180,
          padding: EdgeInsets.only(top: DEFAULT_MARGIN * 2, bottom: DEFAULT_MARGIN * 4),
          child: Row(
            children: <Widget>[
              Expanded(
                child: MayaNumbersSegmentDisplay(
                  segments: currentDisplay,
                  onChanged: onChanged,
                ),
              )
            ],
          ),
        ),
        GCWToolBar(children: [
          GCWIconButton(
            icon: Icons.space_bar,
            onPressed: () {
              setState(() {
                _currentDisplays.add([]);
              });
            },
          ),
          GCWIconButton(
            icon: Icons.backspace,
            onPressed: () {
              setState(() {
                if (_currentDisplays.length > 0) _currentDisplays.removeLast();
              });
            },
          ),
          GCWIconButton(
            icon: Icons.clear,
            onPressed: () {
              setState(() {
                _currentDisplays = [];
              });
            },
          )
        ])
      ],
    );
  }

  Widget _buildDigitalOutput(List<List<String>> segments) {
    return GCWSegmentDisplayOutput(
        segmentFunction: (displayedSegments, readOnly) {
          return MayaNumbersSegmentDisplay(segments: displayedSegments, readOnly: readOnly);
        },
        segments: segments,
        readOnly: true);
  }

  Widget _buildOutput() {
    Map outputDates = new Map();

    if (_currentMode == GCWSwitchPosition.left) {
      //encode
      var segments = encodeMayaCalendar(_currentEncodeInput);
      var gregorian = MayaDayCountToGregorianCalendar(MayaLongCountToMayaDayCount(segments['numbers']));
      var julian = MayaDayCountToJulianCalendar(MayaLongCountToMayaDayCount(segments['numbers']));

      outputDates[i18n(context, 'mayacalendar_system_longcount')] = MayaLongCount(segments['numbers']) +
          '\n' +
          MayaLongCountToTzolkin(segments['numbers']) +
          '   ' +
          MayaLongCountToHaab(segments['numbers']);
      outputDates[i18n(context, 'mayacalendar_juliandate')] =
          MayaDayCountToJulianDate(MayaLongCountToMayaDayCount(segments['numbers']));
      outputDates[i18n(context, 'mayacalendar_gregoriancalendar')] =
          gregorian.day + ' ' + i18n(context, MONTH[int.parse(gregorian.month)]) + ' ' + gregorian.year;
      outputDates[i18n(context, 'mayacalendar_juliancalendar')] =
          julian.day + ' ' + i18n(context, MONTH[int.parse(julian.month)]) + ' ' + julian.year;

      return Column(
        children: <Widget>[
          _buildDigitalOutput(segments['displays']),
          GCWColumnedMultilineOutput(
            data: outputDates.entries.map((entry) {
                    return [entry.key, entry.value];
                  }).toList(),
            flexValues: [1, 1]
          ),
        ],
      );
    } else {
      //decode
      var output = _currentDisplays.map((character) {
        if (character != null) return character.join();
      }).toList();
      var segments = decodeMayaCalendar(output);
      var gregorian = MayaDayCountToGregorianCalendar(segments['vigesimal']);
      var julian = MayaDayCountToJulianCalendar(segments['vigesimal']);

      outputDates[i18n(context, 'mayacalendar_daycount')] = segments['vigesimal'];
      outputDates[i18n(context, 'mayacalendar_system_longcount')] = MayaLongCount(segments['numbers']) +
          '\n' +
          MayaLongCountToTzolkin(segments['numbers']) +
          '   ' +
          MayaLongCountToHaab(segments['numbers']);
      outputDates[i18n(context, 'mayacalendar_juliandate')] = MayaDayCountToJulianDate(segments['vigesimal']);
      outputDates[i18n(context, 'mayacalendar_gregoriancalendar')] = _DateOutputToString(context, gregorian);
      outputDates[i18n(context, 'mayacalendar_juliancalendar')] = _DateOutputToString(context, julian);
      return Column(
        children: <Widget>[
          _buildDigitalOutput(segments['displays']),
          GCWColumnedMultilineOutput(
            data: outputDates.entries.map((entry) {
                    return [entry.key, entry.value];
                  }).toList(),
            flexValues: [1, 1]
          ),
        ],
      );
    }
  }

  String _DateOutputToString(BuildContext context, DateOutput date) {
    final Locale appLocale = Localizations.localeOf(context);
    switch (appLocale.languageCode) {
      case 'de':
        return date.day + '. ' + i18n(context, MONTH[int.parse(date.month)]) + ' ' + date.year;
      case 'fr':
        return date.day + ' ' + i18n(context, MONTH[int.parse(date.month)]).toLowerCase() + ' ' + date.year;
      default:
        return date.year + ' ' + i18n(context, MONTH[int.parse(date.month)]) + ' ' + date.day;
    }
  }
}
