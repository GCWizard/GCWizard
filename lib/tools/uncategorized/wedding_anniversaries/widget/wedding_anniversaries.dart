import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_dropdown.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_columned_multiline_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_twooptions_switch.dart';
import 'package:gc_wizard/tools/uncategorized/wedding_anniversaries/logic/wedding_anniversaries.dart';

class WeddingAnniversaries extends StatefulWidget {
  const WeddingAnniversaries({Key? key}) : super(key: key);

  @override
  _WeddingAnniversariesState createState() => _WeddingAnniversariesState();
}

class _WeddingAnniversariesState extends State<WeddingAnniversaries> {
  late WeddingCountries _currentCountry;

  GCWSwitchPosition _currentMode = GCWSwitchPosition.right;

  @override
  void initState() {
    super.initState();
    _currentCountry = WeddingCountries.DE;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[

        GCWDropDown<WeddingCountries>(
          title: i18n(context, 'common_country'),
          value: _currentCountry,
          onChanged: (value) {
            setState(() {
              _currentCountry = value;
            });
          },
          items: WeddingCountries.values.map((country) {
            return GCWDropDownMenuItem(value: country, child: i18n(context, localizationName(country)));
          }).toList(),
        ),

        GCWTwoOptionsSwitch(
          value: _currentMode,
          notitle: true,
          leftValue: i18n(context, 'common_element'),
          rightValue: i18n(context, 'common_year'),
          onChanged: (value) {
            setState(() {
              _currentMode = value;
            });
          },
        ),
        _buildOutput()
      ],
    );
  }

  Widget _buildOutput() {
    Map<String, List<String>> _currentMap = countryAnniversaries(_currentCountry);
    List<List<String>> output = [];

    if (_currentMode == GCWSwitchPosition.left) {
      // generate output: Element -> Years
      output.add([i18n(context, "common_element"),
        i18n(context, "common_year")]);

      var switchedList = _flipKeyValue(_currentMap).entries.map((e) => [
        i18n(context, e.key.toString()), e.value.join(", ")
      ]).toList();
      switchedList.sort((a, b) => a[0].toLowerCase().compareTo(b[0].toLowerCase()));

      output.addAll(switchedList);

    } else {
      // generate output: Year -> Elements
      output.add([i18n(context, "common_year"),
        i18n(context, "common_element")]);

      _currentMap.forEach((key, valueList) {
        List<String> values = [];
        for (var word in valueList) {
          values.add(i18n(context, word));
        }
        output.add([key, values.join(", ")]);
      });
    }

    return GCWDefaultOutput(
      child: GCWColumnedMultilineOutput(
        flexValues: (_currentMode == GCWSwitchPosition.right)
            ? const [1, 6]
            : const [2, 3],
        hasHeader: true,
        data: output,
      ),
    );
  }
}

Map<U, List<T>> _flipKeyValue<T, U>(Map<T, List<U>> map) {
  var newMap = <U, List<T>>{};
  map.forEach((key, valueList) {
    for (var value in valueList) {
      newMap.putIfAbsent(value, () => []).add(key);
    }
  });
  return newMap;
}
