import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/application/theme/theme.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_iconbutton.dart';
import 'package:gc_wizard/common_widgets/gcw_toolbar.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_columned_multiline_output.dart';
import 'package:gc_wizard/common_widgets/spinners/gcw_integer_spinner.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_twooptions_switch.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/maya_numbers/widget/maya_numbers_segment_display.dart';
import 'package:gc_wizard/tools/science_and_technology/maya_calendar/logic/maya_calendar.dart';
import 'package:gc_wizard/tools/science_and_technology/segment_display/_common/logic/segment_display.dart';
import 'package:gc_wizard/tools/science_and_technology/segment_display/_common/widget/n_segment_display.dart';
import 'package:gc_wizard/tools/science_and_technology/segment_display/_common/widget/segmentdisplay_output.dart';
import 'package:intl/intl.dart';

class MayaCalendar extends StatefulWidget {
  const MayaCalendar({Key? key}) : super(key: key);

  @override
  _MayaCalendarState createState() => _MayaCalendarState();
}

class _MayaCalendarState extends State<MayaCalendar> {
  int _currentEncodeInput = 0;
  final String _currentLongCount = '';
  late TextEditingController _longCountController;

  var _currentDisplays = Segments.Empty();
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

  Widget _buildVisualDecryption() {
    var currentDisplay = buildSegmentMap(_currentDisplays);

    onChanged(Map<String, bool> d) {
      setState(() {
        var newSegments = <String>[];
        d.forEach((key, value) {
          if (!value) return;
          newSegments.add(key);
        });

        _currentDisplays.replaceLastSegment(newSegments);
      });
    }

    return Column(
      children: <Widget>[
        Container(
          width: 180,
          padding: const EdgeInsets.only(top: DEFAULT_MARGIN * 2, bottom: DEFAULT_MARGIN * 4),
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
                _currentDisplays.addEmptySegment();
              });
            },
          ),
          GCWIconButton(
            icon: Icons.backspace,
            onPressed: () {
              setState(() {
                _currentDisplays.removeLastSegment();
              });
            },
          ),
          GCWIconButton(
            icon: Icons.clear,
            onPressed: () {
              setState(() {
                _currentDisplays = Segments.Empty();
              });
            },
          )
        ])
      ],
    );
  }

  Widget _buildDigitalOutput(Segments segments) {
    return SegmentDisplayOutput(
        segmentFunction: (displayedSegments, readOnly) {
          return MayaNumbersSegmentDisplay(segments: displayedSegments, readOnly: readOnly);
        },
        segments: segments,
        readOnly: true);
  }

  Widget _buildOutput() {
    var outputDates = <String, Object>{};
    var dateFormat = DateFormat('yMMMMd', Localizations.localeOf(context).toString());

    if (_currentMode == GCWSwitchPosition.left) {
      //encode
      var segments = encodeMayaCalendar(_currentEncodeInput);
      var gregorian = MayaDayCountToGregorianCalendar(MayaLongCountToMayaDayCount(segments.numbers));
      var julian = MayaDayCountToJulianCalendar(MayaLongCountToMayaDayCount(segments.numbers));

      outputDates[i18n(context, 'mayacalendar_system_longcount')] = MayaLongCount(segments.numbers) +
          '\n' +
          MayaLongCountToTzolkin(segments.numbers) +
          '   ' +
          MayaLongCountToHaab(segments.numbers);
      outputDates[i18n(context, 'mayacalendar_juliandate')] =
          MayaDayCountToJulianDate(MayaLongCountToMayaDayCount(segments.numbers));
      outputDates[i18n(context, 'mayacalendar_gregoriancalendar')] = dateFormat.format(gregorian);
      outputDates[i18n(context, 'mayacalendar_juliancalendar')] = dateFormat.format(julian);

      return Column(
        children: <Widget>[
          _buildDigitalOutput(segments),
          GCWColumnedMultilineOutput(
              data: outputDates.entries.map((entry) {
                return [entry.key, entry.value];
              }).toList(),
              flexValues: const [1, 1]),
        ],
      );
    } else {
      //decode
      var output = _currentDisplays.buildOutput();
      var segments = decodeMayaCalendar(output);
      var gregorian = MayaDayCountToGregorianCalendar(segments.vigesimal.toInt());
      var julian = MayaDayCountToJulianCalendar(segments.vigesimal.toInt());

      outputDates[i18n(context, 'mayacalendar_daycount')] = segments.vigesimal;
      outputDates[i18n(context, 'mayacalendar_system_longcount')] = MayaLongCount(segments.numbers) +
          '\n' +
          MayaLongCountToTzolkin(segments.numbers) +
          '   ' +
          MayaLongCountToHaab(segments.numbers);
      outputDates[i18n(context, 'mayacalendar_juliandate')] = MayaDayCountToJulianDate(segments.vigesimal.toInt());
      outputDates[i18n(context, 'mayacalendar_gregoriancalendar')] = dateFormat.format(gregorian);
      outputDates[i18n(context, 'mayacalendar_juliancalendar')] = dateFormat.format(julian);
      return Column(
        children: <Widget>[
          _buildDigitalOutput(segments),
          GCWColumnedMultilineOutput(
              data: outputDates.entries.map((entry) {
                return [entry.key, entry.value];
              }).toList(),
              flexValues: const [1, 1]),
        ],
      );
    }
  }
}
