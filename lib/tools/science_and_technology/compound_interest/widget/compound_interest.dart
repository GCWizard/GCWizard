import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/app_localizations.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_dropdown.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/spinners/gcw_double_spinner.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_onoff_switch.dart';
import 'package:gc_wizard/tools/science_and_technology/compound_interest/logic/compound_interest.dart';
import 'package:intl/intl.dart';

class CompoundInterest extends StatefulWidget {
  const CompoundInterest({Key? key}) : super(key: key);

  @override
  CompoundInterestState createState() => CompoundInterestState();
}

const _MODE_PRINCIPALSUM = 'compoundinterest_modes_principalsum';
const _MODE_ORIGINALPRINCIPALSUM = 'compoundinterest_modes_originalprincipalsum';
const _MODE_ANNUALRATE = 'compoundinterest_modes_annualrate';
const _MODE_TOTALYEARS = 'compoundinterest_modes_totalyears';

const _MODES = [
  _MODE_PRINCIPALSUM,
  _MODE_ORIGINALPRINCIPALSUM,
  _MODE_ANNUALRATE,
  _MODE_TOTALYEARS,
];

class CompoundInterestState extends State<CompoundInterest> {
  var _currentMode = _MODES.first;

  var _currentPrincipalSum = 0.0;
  var _currentOriginalPrincipalSum = 0.0;
  var _currentAnnualRate = 0.0;
  var _currentTotalYears = 0.0;
  var _currentCompoundFrequency = COMPOUND_FREQUENCY.YEARLY;
  var _currentCompoundInterest = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GCWDropDown<String>(
          value: _currentMode,
          items: _MODES.map((mode) {
            return GCWDropDownMenuItem(
              value: mode,
              child: i18n(context, mode),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _currentMode = value;
            });
          },
        ),
        _currentMode != _MODE_ORIGINALPRINCIPALSUM
            ? GCWDoubleSpinner(
                value: _currentOriginalPrincipalSum,
                numberDecimalDigits: 3,
                title: i18n(context, 'compoundinterest_modes_originalprincipalsum'),
                onChanged: (value) {
                  setState(() {
                    _currentOriginalPrincipalSum = value;
                  });
                },
              )
            : Container(),
        _currentMode != _MODE_PRINCIPALSUM
            ? GCWDoubleSpinner(
                value: _currentPrincipalSum,
                numberDecimalDigits: 3,
                title: i18n(context, 'compoundinterest_modes_principalsum'),
                onChanged: (value) {
                  setState(() {
                    _currentPrincipalSum = value;
                  });
                },
              )
            : Container(),
        _currentMode != _MODE_ANNUALRATE
            ? GCWDoubleSpinner(
                value: _currentAnnualRate,
                numberDecimalDigits: 8,
                title: i18n(context, 'compoundinterest_modes_annualrate'),
                onChanged: (value) {
                  setState(() {
                    _currentAnnualRate = value;
                  });
                },
              )
            : Container(),
        _currentMode != _MODE_TOTALYEARS
            ? GCWDoubleSpinner(
                title: i18n(context, 'compoundinterest_modes_totalyears'),
                value: _currentTotalYears,
                numberDecimalDigits: 8,
                onChanged: (value) {
                  setState(() {
                    _currentTotalYears = value;
                  });
                },
              )
            : Container(),
        GCWOnOffSwitch(
          value: _currentCompoundInterest,
          title: i18n(context, 'compoundinterest_compoundinterest'),
          onChanged: (value) {
            setState(() {
              _currentCompoundInterest = value;
            });
          },
        ),
        _currentCompoundInterest
            ? GCWDropDown<COMPOUND_FREQUENCY>(
                value: _currentCompoundFrequency,
                title: i18n(context, 'compoundinterest_compoundfrequency'),
                items: COMPOUND_FREQUENCY.values.map((freq) {
                  return GCWDropDownMenuItem(value: freq, child: i18n(context, _compoundFrequencyTitle(freq)));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _currentCompoundFrequency = value;
                  });
                },
              )
            : Container(),
        GCWDefaultOutput(
          child: _buildOutput(),
        )
      ],
    );
  }

  String _compoundFrequencyTitle(COMPOUND_FREQUENCY freq) {
    switch (freq) {
      case COMPOUND_FREQUENCY.YEARLY:
        return 'compoundinterest_compoundfrequency_yearly';
      case COMPOUND_FREQUENCY.MONTHLY:
        return 'compoundinterest_compoundfrequency_monthly';
      case COMPOUND_FREQUENCY.QUARTERLY:
        return 'compoundinterest_compoundfrequency_quarterly';
      case COMPOUND_FREQUENCY.WEEKLY:
        return 'compoundinterest_compoundfrequency_weekly';
      case COMPOUND_FREQUENCY.DAILY_360:
        return 'compoundinterest_compoundfrequency_daily360';
      case COMPOUND_FREQUENCY.DAILY_365:
        return 'compoundinterest_compoundfrequency_daily365';
    }
  }

  String _buildOutput() {
    var number = 0.0;
    var frequency = compoundFrequency(_currentCompoundFrequency);

    if (_currentCompoundInterest) {
      switch (_currentMode) {
        case _MODE_PRINCIPALSUM:
          number =
              principalSumCompound(_currentOriginalPrincipalSum, _currentAnnualRate, _currentTotalYears, frequency);
          break;
        case _MODE_ORIGINALPRINCIPALSUM:
          number =
              originalPrincipalSumCompound(_currentPrincipalSum, _currentAnnualRate, _currentTotalYears, frequency);
          break;
        case _MODE_ANNUALRATE:
          number = annualInterestRateCompound(
              _currentOriginalPrincipalSum, _currentPrincipalSum, _currentTotalYears, frequency);
          break;
        case _MODE_TOTALYEARS:
          number =
              totalYearsCompound(_currentOriginalPrincipalSum, _currentPrincipalSum, _currentAnnualRate, frequency);
          break;
      }
    } else {
      switch (_currentMode) {
        case _MODE_PRINCIPALSUM:
          number = principalSum(_currentOriginalPrincipalSum, _currentAnnualRate, _currentTotalYears);
          break;
        case _MODE_ORIGINALPRINCIPALSUM:
          number = originalPrincipalSum(_currentPrincipalSum, _currentAnnualRate, _currentTotalYears);
          break;
        case _MODE_ANNUALRATE:
          number = annualInterestRate(_currentOriginalPrincipalSum, _currentPrincipalSum, _currentTotalYears);
          break;
        case _MODE_TOTALYEARS:
          number = totalYears(_currentOriginalPrincipalSum, _currentPrincipalSum, _currentAnnualRate);
          break;
      }
    }

    String formatString;
    switch (_currentMode) {
      case _MODE_PRINCIPALSUM:
        formatString = '0.000';
        break;
      case _MODE_ORIGINALPRINCIPALSUM:
        formatString = '0.000';
        break;
      case _MODE_ANNUALRATE:
        formatString = '0.000#####';
        break;
      case _MODE_TOTALYEARS:
        formatString = '0.000#####';
        break;
      default:
        formatString = '0.000';
    }

    return NumberFormat(formatString).format(number) + (_currentMode == _MODE_ANNUALRATE ? ' %' : '');
  }
}
