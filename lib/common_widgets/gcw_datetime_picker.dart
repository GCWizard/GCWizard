import 'package:flutter/material.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_dropdown.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_sign_dropdown.dart';
import 'package:gc_wizard/common_widgets/gcw_text.dart';
import 'package:gc_wizard/common_widgets/gcw_toolbar.dart';
import 'package:gc_wizard/common_widgets/spinners/gcw_double_spinner.dart';
import 'package:gc_wizard/common_widgets/spinners/gcw_dropdown_spinner.dart';
import 'package:gc_wizard/common_widgets/spinners/gcw_integer_spinner.dart';
import 'package:gc_wizard/common_widgets/spinners/spinner_constants.dart';
import 'package:gc_wizard/utils/data_type_utils/double_type_utils.dart';

enum DateTimePickerConfig {
  /// Show sign selection
  SIGN,

  /// Show year, day, month
  DATE,

  /// Show days
  DAY,

  /// Show hour, minutes, seconds, milliseconds
  TIME,

  /// Show seconds without decimal places
  SECOND_AS_INT,

  /// Show milliseconds (option for SECOND_AS_INT)
  TIME_MSEC,

  /// Show timezones
  TIMEZONES,
}

class TimeZone {
  final int offset;
  final String name;

  TimeZone(this.offset, this.name);
}

final TIMEZONES = [
  TimeZone(720, 'IDLW'),
  TimeZone(-660, ''),
  TimeZone(-600, 'HAST'),
  TimeZone(-570, ''),
  TimeZone(-540, 'HDT, AKST, YST'),
  TimeZone(-480, 'PST, PT, AKDT, YDT'),
  TimeZone(-420, 'MST, PDT'),
  TimeZone(-360, 'CST, MDT'),
  TimeZone(-300, 'CDT, EST'),
  TimeZone(-240, 'EDT, AST'),
  TimeZone(-210, 'NST'),
  TimeZone(-180, '-ADT'),
  TimeZone(-150, 'NDT'),
  TimeZone(-120, ''),
  TimeZone(-60, ''),
  TimeZone(0, 'UTC, GMT, WET/WEZ'),
  TimeZone(60, 'WEST/WEDT/WESZ, BST, IST, CET/MET/MEZ'),
  TimeZone(120, 'CEST/CEDT/MEST/MESZ, WAST, EET/OEZ, CAT, SAST'),
  TimeZone(180, 'EEST/EEDT, BT, MSK, EAT, AST'),
  TimeZone(210, 'IRT'),
  TimeZone(240, ''),
  TimeZone(270, 'IRST'),
  TimeZone(300, ''),
  TimeZone(330, 'IST'),
  TimeZone(345, ''),
  TimeZone(360, ''),
  TimeZone(390, ''),
  TimeZone(420, 'ICT'),
  TimeZone(480, 'CNST'),
  TimeZone(540, 'JST'),
  TimeZone(570, 'ACST'),
  TimeZone(600, 'AEST'),
  TimeZone(630, 'ACDT'),
  TimeZone(660, 'AEDT, NFT'),
  TimeZone(720, 'IDLE, NZST'),
  TimeZone(765, 'IDLE, NZST'),
  TimeZone(780, 'NZDT'),
  TimeZone(825, ''),
  TimeZone(840, ''),
];

class GCWDateTimePicker extends StatefulWidget {
  final Function onChanged;
  final DateTime datetime;
  final Duration duration;
  final Set<DateTimePickerConfig> config;
  final Duration timezoneOffset;
  final int minDays;
  final int maxDays;
  final int maxHours;
  final double maxSeconds;

  final TextEditingController yearController;
  final TextEditingController monthController;
  final TextEditingController dayController;
  final TextEditingController hoursController;
  final TextEditingController minutesController;
  final TextEditingController secondsController;
  final TextEditingController mSecondsController;

  const GCWDateTimePicker({
    Key key,
    this.onChanged,
    this.datetime,
    this.duration,
    this.config,
    this.timezoneOffset: const Duration(hours: 0),
    this.minDays: 1,
    this.maxDays: 31,
    this.maxHours: 23,
    this.maxSeconds: 59.999,
    this.yearController,
    this.monthController,
    this.dayController,
    this.hoursController,
    this.minutesController,
    this.secondsController,
    this.mSecondsController,
  }) : super(key: key);

  @override
  GCWDateTimePickerState createState() => GCWDateTimePickerState();
}

class GCWDateTimePickerState extends State<GCWDateTimePicker> {
  var _currentSign = 1;
  var _currentYear = 0;
  var _currentMonth = 1;
  var _currentDay = 1;
  var _currentHour = 0;
  var _currentMinute = 0;
  var _currentSecond = 0;
  var _currentMilliSecond = 0;
  var _currentTimezoneOffset = 0;
  var _currentTimezoneOffsetIndex;

  var _monthFocusNode;
  var _dayFocusNode;
  var _hourFocusNode;
  var _minuteFocusNode;
  var _secondFocusNode;
  var _msecondFocusNode;

  @override
  void initState() {
    super.initState();

    DateTime date = widget.datetime ?? DateTime.now();

    if (widget.config.contains(DateTimePickerConfig.SIGN)) {
      _currentSign = _sign(date);
    }

    if (widget.config.contains(DateTimePickerConfig.DATE)) {
      _currentYear = date.year;
      _currentMonth = date.month;
      _currentDay = date.day;
    }

    if (widget.config.contains(DateTimePickerConfig.DAY)) {
      if (widget.duration != null)
        _currentDay = widget.duration.inDays;
      else
        _currentDay = date.day;
    }

    if (widget.config.contains(DateTimePickerConfig.TIME)) {
      if (widget.duration != null) {
        _currentHour = widget.duration.inHours.remainder(24);
        _currentMinute = widget.duration.inMinutes.remainder(60);
        _currentSecond = widget.duration.inSeconds.remainder(60);
        _currentMilliSecond = _durationMilliseconds(widget.duration);
      } else {
        _currentHour = date.hour;
        _currentMinute = date.minute;
        _currentSecond = date.second;
        _currentMilliSecond = date.millisecond;
      }
    }

    if (widget.config.contains(DateTimePickerConfig.TIMEZONES)) {
      _currentTimezoneOffset = date.timeZoneOffset.inMinutes;
      _currentTimezoneOffsetIndex = _timezoneOffsetToIndex(_currentTimezoneOffset);
    }

    _monthFocusNode = FocusNode();
    _dayFocusNode = FocusNode();
    _hourFocusNode = FocusNode();
    _minuteFocusNode = FocusNode();
    _secondFocusNode = FocusNode();
    _msecondFocusNode = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    var widgets = Map<Widget, int>(); // widget: flex

    if (widget.config.contains(DateTimePickerConfig.TIME)) {
      if (widget.duration != null) {
        // update with new values (paste, ..)
        if (_currentSign != (widget.duration.isNegative ? -1 : 1)) _currentSign = widget.duration.isNegative ? -1 : 1;
        if (_currentHour != widget.duration.inHours.abs()) _currentHour = widget.duration.inHours.abs().remainder(24);
        if (_currentMinute != widget.duration.inMinutes.abs().remainder(60))
          _currentMinute = widget.duration.inMinutes.abs().remainder(60);
        if (_currentSecond != widget.duration.inSeconds.abs().remainder(60))
          _currentSecond = widget.duration.inSeconds.abs().remainder(60);
        if (_currentMilliSecond != _durationMilliseconds(widget.duration))
          _currentMilliSecond = _durationMilliseconds(widget.duration);
      } else if (widget.datetime != null) {
        // update with new values (paste, ..)
        if (_currentHour != widget.datetime.hour) _currentHour = widget.datetime.hour;
        if (_currentMinute == widget.datetime.minute) _currentMinute = widget.datetime.minute;
        if (_currentSecond == widget.datetime.second) _currentSecond = widget.datetime.second;
        if (_currentMilliSecond == widget.datetime.millisecond) _currentMilliSecond = widget.datetime.millisecond;
      }
    } else if (widget.config.contains(DateTimePickerConfig.DATE)) {
      if (widget.datetime != null) {
        // update with new values (paste, ..)
        if (_currentYear != widget.datetime.year) _currentYear = widget.datetime.year;
        if (_currentMonth != widget.datetime.month) _currentMonth = widget.datetime.month;
        if (_currentDay != widget.datetime.day) {
          _currentDay = widget.datetime.day;
        }
      }
    }

    if (widget.config.contains(DateTimePickerConfig.SIGN)) {
      widgets.addAll({
        GCWSignDropDown(
            itemList: ['+', '-'],
            value: _currentSign,
            onChanged: (value) {
              setState(() {
                _currentSign = value;
                _setCurrentValueAndEmitOnChange();
              });
            }): 3
      });
    }

    if (widget.config.contains(DateTimePickerConfig.DATE)) {
      widgets.addAll({
        GCWIntegerSpinner(
          layout: SpinnerLayout.VERTICAL,
          controller: widget.yearController,
          value: _currentYear,
          min: -5000,
          max: 5000,
          onChanged: (value) {
            setState(() {
              _currentYear = value;
              _setCurrentValueAndEmitOnChange();

              if (_currentYear.toString().length == 4) {
                FocusScope?.of(context)?.requestFocus(_monthFocusNode);
              }
            });
          },
        ): 5
      });
    }
    if (widget.config.contains(DateTimePickerConfig.DATE)) {
      widgets.addAll({
        GCWIntegerSpinner(
          focusNode: _monthFocusNode,
          layout: SpinnerLayout.VERTICAL,
          controller: widget.monthController,
          value: _currentMonth,
          min: 1,
          max: 12,
          onChanged: (value) {
            setState(() {
              _currentMonth = value;
              _setCurrentValueAndEmitOnChange();

              if (_dayFocusNode != null && _currentMonth.toString().length == 2) {
                FocusScope?.of(context)?.requestFocus(_dayFocusNode);
              }
            });
          },
        ): 4
      });
    }

    if (widget.config.contains(DateTimePickerConfig.DATE) || widget.config.contains(DateTimePickerConfig.DAY)) {
      widgets.addAll({
        GCWIntegerSpinner(
          focusNode: _dayFocusNode,
          layout: SpinnerLayout.VERTICAL,
          controller: widget.dayController,
          value: _currentDay,
          min: widget.minDays,
          max: widget.maxDays,
          onChanged: (value) {
            setState(() {
              _currentDay = value;
              _setCurrentValueAndEmitOnChange();

              if (_hourFocusNode != null && _currentDay.toString().length == 2) {
                FocusScope?.of(context)?.requestFocus(_hourFocusNode);
              }
            });
          },
        ): 4
      });
    }

    if (widget.config.contains(DateTimePickerConfig.DATE) && widget.config.contains(DateTimePickerConfig.TIME)) {
      widgets.addAll({
        GCWText(
          text: '-',
          textAlign: TextAlign.center,
        ): 1
      });
    }

    if (widget.config.contains(DateTimePickerConfig.TIME)) {
      widgets.addAll({
        GCWIntegerSpinner(
          focusNode: _hourFocusNode,
          layout: SpinnerLayout.VERTICAL,
          controller: widget.hoursController,
          value: _currentHour,
          min: 0,
          max: widget.maxHours,
          onChanged: (value) {
            setState(() {
              _currentHour = value;
              _setCurrentValueAndEmitOnChange();

              if (_minuteFocusNode != null && _currentHour.toString().length == 2) {
                FocusScope.of(context).requestFocus(_minuteFocusNode);
              }
            });
          },
        ): 4
      });
      widgets.addAll({
        GCWIntegerSpinner(
          focusNode: _minuteFocusNode,
          layout: SpinnerLayout.VERTICAL,
          controller: widget.minutesController,
          value: _currentMinute,
          min: 0,
          max: widget.maxSeconds.toInt(),
          onChanged: (value) {
            setState(() {
              _currentMinute = value;
              _setCurrentValueAndEmitOnChange();

              if (_secondFocusNode != null && _currentMinute.toString().length == 2) {
                FocusScope.of(context).requestFocus(_secondFocusNode);
              }
            });
          },
        ): 4
      });
      if (widget.config.contains(DateTimePickerConfig.SECOND_AS_INT)) {
        widgets.addAll({
          GCWIntegerSpinner(
            focusNode: _secondFocusNode,
            layout: SpinnerLayout.VERTICAL,
            controller: widget.secondsController,
            value: _currentSecond.truncate(),
            min: 0,
            max: widget.maxSeconds.truncate(),
            onChanged: (value) {
              setState(() {
                _currentSecond = value;
                _setCurrentValueAndEmitOnChange();

                if (_msecondFocusNode != null && _currentSecond.toString().length == 2) {
                  FocusScope.of(context).requestFocus(_msecondFocusNode);
                }
              });
            },
          ): 4
        });
      } else {
        widgets.addAll({
          GCWDoubleSpinner(
            focusNode: _secondFocusNode,
            layout: SpinnerLayout.VERTICAL,
            controller: widget.secondsController,
            value: double.parse(_currentSecond.toString() + '.' + _currentMilliSecond.toString()),
            numberDecimalDigits: 4,
            min: 0.0,
            max: widget.maxSeconds,
            onChanged: (value) {
              setState(() {
                _currentSecond = value.truncate();
                _currentMilliSecond = fractionPartAsInteger(value);
                _setCurrentValueAndEmitOnChange();
              });
            },
          ): 6
        });
      }
      if (widget.config.contains(DateTimePickerConfig.TIME_MSEC)) {
        widgets.addAll({
          GCWIntegerSpinner(
            focusNode: _msecondFocusNode,
            layout: SpinnerLayout.VERTICAL,
            controller: widget.mSecondsController,
            value: _currentMilliSecond,
            min: 0,
            max: 999,
            onChanged: (value) {
              setState(() {
                _currentMilliSecond = value;
                _setCurrentValueAndEmitOnChange();
              });
            },
          ): 4
        });
      }
    }

    return Column(
      children: <Widget>[
        GCWToolBar(
          children: widgets.keys.toList(),
          flexValues: widgets.values.toList(),
        ),
        widget.config.contains(DateTimePickerConfig.TIMEZONES) ? _buildTimeZonesDropdown() : Container()
      ],
    );
  }

  _indexToTimezoneOffset(int index) {
    return TIMEZONES[index].offset;
  }

  _timezoneOffsetToIndex(int offset) {
    return TIMEZONES.indexWhere((timezone) => timezone.offset == offset);
  }

  _buildTimeZonesDropdown() {
    return Row(
      children: [
        Expanded(child: GCWText(text: 'Timezone'), flex: 1),
        Expanded(
            child: GCWDropDownSpinner(
              index: _currentTimezoneOffsetIndex,
              items: TIMEZONES
                  .asMap()
                  .map((index, timeZone) {
                    return MapEntry(
                        index,
                        GCWDropDownMenuItem(
                            value: index, child: _buildTimeZoneItemText(timeZone), subtitle: timeZone.name ?? ''));
                  })
                  .values
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _currentTimezoneOffsetIndex = value;
                  _currentTimezoneOffset = _indexToTimezoneOffset(value);
                  _setCurrentValueAndEmitOnChange();
                });
              },
            ),
            flex: 3),
      ],
    );
  }

  _buildTimeZoneItemText(TimeZone timeZone) {
    var tzMinutes = timeZone.offset;
    var sign = tzMinutes < 0 ? -1 : 1;

    var tzHours = (tzMinutes.abs() / 60).floor() * sign;
    tzMinutes = tzMinutes.abs() % 60;

    var hoursStr = tzHours < 0 ? tzHours.toString() : '+$tzHours';
    var minutesStr = tzMinutes.toString().padLeft(2, '0');
    var out = '$hoursStr:$minutesStr h';

    return out;
  }

  int _sign(DateTime datetime) {
    if (datetime == null) return 1;

    if (datetime.microsecond < 0) return -1;

    return 1;
  }

  _setCurrentValueAndEmitOnChange() {
    var duration = Duration(
        days: (widget.config.contains(DateTimePickerConfig.DATE) || widget.config.contains(DateTimePickerConfig.DAY))
            ? _currentDay
            : 0,
        hours: _currentHour,
        minutes: _currentMinute,
        seconds: _currentSecond,
        milliseconds: _currentMilliSecond);
    duration *= _currentSign;

    var output = {
      'datetime': DateTime(
          _currentYear, _currentMonth, _currentDay, _currentHour, _currentMinute, _currentSecond, _currentMilliSecond),
      'timezone': Duration(minutes: _currentTimezoneOffset),
      'duration': duration,
    };

    widget.onChanged(output);
  }

  int _durationMilliseconds(Duration duration) {
    return (duration.abs().inMilliseconds - duration.abs().inSeconds * 1000).round();
  }
}
