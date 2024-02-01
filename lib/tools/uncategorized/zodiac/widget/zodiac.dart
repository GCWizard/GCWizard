import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/application/theme/theme.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_dropdown.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_columned_multiline_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/spinners/gcw_dropdown_spinner.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_twooptions_switch.dart';
import 'package:gc_wizard/tools/uncategorized/zodiac/logic/zodiac.dart';
import 'package:gc_wizard/utils/string_utils.dart';
import 'package:intl/intl.dart';

enum _ZODIACSIGNS_ATTRIBUTES {
  date,
  house,
  element,
  quality,
  polarity,
  planet,
}

class Zodiac extends StatefulWidget {
  const Zodiac({Key? key}) : super(key: key);

  @override
  _ZodiacState createState() => _ZodiacState();
}

class _ZodiacState extends State<Zodiac> {
  var _currentMode = GCWSwitchPosition.left;
  var _currentZodiacSign = 0;
  var _currentAttribute = _ZODIACSIGNS_ATTRIBUTES.values.first;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GCWTwoOptionsSwitch(
          title: i18n(context, 'zodiac_show'),
          leftValue: i18n(context, 'zodiac_show_zodiac'),
          rightValue: i18n(context, 'zodiac_show_attributes'),
          value: _currentMode,
          onChanged: (value) {
            setState(() {
              _currentMode = value;
            });
          },
        ),
        Container(height: DOUBLE_DEFAULT_MARGIN),
        if (_currentMode == GCWSwitchPosition.left)
          GCWDropDownSpinner(
            index: _currentZodiacSign,
            items: ZODIACSIGNS
                .map((key, value) {
                  return MapEntry(key, i18n(context, key));
                })
                .values
                .toList(),
            onChanged: (value) {
              setState(() {
                _currentZodiacSign = value;
              });
            },
          ),
        if (_currentMode == GCWSwitchPosition.right)
          GCWDropDown<_ZODIACSIGNS_ATTRIBUTES>(
            value: _currentAttribute,
            items: _ZODIACSIGNS_ATTRIBUTES.values.map((attribute) {
              return GCWDropDownMenuItem(value: attribute, child: i18n(context, _attributeName(attribute)));
            }).toList(),
            onChanged: (value) {
              setState(() {
                _currentAttribute = value;
              });
            },
          ),
        GCWDefaultOutput(
          child: _buildOutput(),
        ),
      ],
    );
  }

  String _createDateOutput(ZodiacDate dateValues) {
    var startDate = DateTime(0, dateValues.start_month, dateValues.start_day);
    var endDate = DateTime(0, dateValues.end_month, dateValues.end_day);

    var dateFormat = DateFormat('MMMMd', Localizations.localeOf(context).toString());
    return dateFormat.format(startDate) + ' - ' + dateFormat.format(endDate);
  }

  String _createPlanetOutput(List<String>? planets) {
    if (planets == null || planets.isEmpty) return '';
    var output = i18n(context, planets[0]);
    if (planets.length == 1) return output;

    output += '\n\n' + i18n(context, 'zodiac_attribute_planet_additional') + ':\n';
    output += List<String>.from(planets.sublist(1)).map((e) => i18n(context, e)).join('\n');

    return output;
  }

  Widget _buildOutput() {
    if (_currentMode == GCWSwitchPosition.left) {
      var zodiacSignKey = ZODIACSIGNS.keys.toList()[_currentZodiacSign];
      var zodiacSign = ZODIACSIGNS[zodiacSignKey];
      if (zodiacSign == null) return Container();

      return GCWColumnedMultilineOutput(data: [
        [i18n(context, _attributeName(_ZODIACSIGNS_ATTRIBUTES.date)), _createDateOutput(zodiacSign.date)],
        [i18n(context, _attributeName(_ZODIACSIGNS_ATTRIBUTES.planet)), _createPlanetOutput(zodiacSign.planet)],
        [i18n(context, _attributeName(_ZODIACSIGNS_ATTRIBUTES.element)), i18n(context, zodiacSign.element)],
        [i18n(context, _attributeName(_ZODIACSIGNS_ATTRIBUTES.house)), zodiacSign.house],
        [i18n(context, _attributeName(_ZODIACSIGNS_ATTRIBUTES.quality)), i18n(context, zodiacSign.quality)],
        [i18n(context, _attributeName(_ZODIACSIGNS_ATTRIBUTES.polarity)), i18n(context, zodiacSign.polarity)],
      ], flexValues: const [
        1,
        2
      ]);
    } else {
      return GCWColumnedMultilineOutput(
        data: ZODIACSIGNS
            .map((key, value) {
              String output = '';
              switch (_currentAttribute) {
                case _ZODIACSIGNS_ATTRIBUTES.date:
                  output = _createDateOutput(value.date);
                  break;
                case _ZODIACSIGNS_ATTRIBUTES.planet:
                  output = _createPlanetOutput(value.planet);
                  break;
                case _ZODIACSIGNS_ATTRIBUTES.house:
                  output = value.house.toString();
                  break;
                case _ZODIACSIGNS_ATTRIBUTES.element:
                  output = i18n(context, value.element);
                  break;
                case _ZODIACSIGNS_ATTRIBUTES.quality:
                  output = i18n(context, value.quality);
                  break;
                case _ZODIACSIGNS_ATTRIBUTES.polarity:
                  output = i18n(context, value.polarity);
                  break;
              }

              return MapEntry(key, [i18n(context, key), output]);
            })
            .values
            .toList(),
      );
    }
  }

  String _attributeName(_ZODIACSIGNS_ATTRIBUTES attribute) {
    return 'zodiac_attribute_' + enumName(attribute.toString());
  }
}
