import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_dropdown.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_columned_multiline_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_twooptions_switch.dart';
import 'package:gc_wizard/tools/science_and_technology/countries/logic/countries.dart';
import 'package:gc_wizard/utils/string_utils.dart';

class Countries extends StatefulWidget {
  final List<CountryProperties> fields;

  const Countries({Key? key, required this.fields}) : super(key: key);

  @override
  _CountriesState createState() => _CountriesState();
}

class _CountriesState extends State<Countries> {
  var _currentSwitchSort = GCWSwitchPosition.left;
  var _currentSort = 0;
  // ignore: prefer_final_fields
  var _currentSortList = ['common_countries'];

  @override
  void initState() {
    super.initState();

    _currentSortList.addAll(widget.fields.map((e) => 'countries_${enumName(e.toString())}_sort'));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        if (widget.fields.length == 1)
          GCWTwoOptionsSwitch(
            value: _currentSwitchSort,
            title: i18n(context, 'common_sortby'),
            leftValue: i18n(context, _currentSortList[0]),
            rightValue: i18n(context, _currentSortList[1]),
            onChanged: (value) {
              setState(() {
                _currentSwitchSort = value;
                _currentSort = value == GCWSwitchPosition.left ? 0 : 1;
              });
            },
          ),
        if (widget.fields.length > 1)
          GCWDropDown<int>(
            title: i18n(context, 'common_sortby'),
            value: _currentSort,
            onChanged: (value) {
              setState(() {
                _currentSort = value;
              });
            },
            items: _currentSortList
                .asMap()
                .map((index, field) {
                  return MapEntry(index, GCWDropDownMenuItem(value: index, child: i18n(context, field)));
                })
                .values
                .toList(),
          ),
        GCWDefaultOutput(child: _buildOutput())
      ],
    );
  }

  Widget _buildOutput() {
    var field = _currentSort == 0 ? widget.fields[0] : widget.fields[_currentSort - 1];
    var flexValues = List<int>.generate(widget.fields.length, (index) => 1);

    var data = COUNTRIES.values
        .where((e) => e.getProperty(field) != null)
        .where((e) => (e.getProperty(field) is String) ? (e.getProperty(field) as String).isNotEmpty : true)
        .map((e) {
      if (_currentSort == 0) {
        List<Object> dataList = [i18n(context, e.name)];
        dataList.addAll(widget.fields.map((field) => e.getProperty(field)!));

        return dataList;
      } else {
        var dataList = [e.getProperty(field)!, i18n(context, e.name)];
        dataList.addAll(widget.fields.where((f) => f != field).map((f) => e.getProperty(f)!));

        return dataList;
      }
    }).toList();

    if (_currentSort == 0) {
      flexValues.insert(0, widget.fields.length + 1);
    } else {
      flexValues.insert(1, widget.fields.length + 1);
    }

    data.sort((List<Object> a, List<Object> b) {
      if (a[0] is String) {
        return _compareAsString(a, b);
      } else if (a[0] is int) {
        return _compareAsInt(a, b);
      } else {
        return 0;
      }
    });

    return GCWColumnedMultilineOutput(data: data, flexValues: flexValues, copyColumn: 1);
  }

  int _compareAsString(List<Object> a, List<Object> b) {
    var result = (a[0] as String).compareTo(b[0] as String);
    if (result != 0) return result;

    return (a[1] as String).compareTo(b[1] as String);
  }

  int _compareAsInt(List<Object> a, List<Object> b) {
    var result = (a[0] as int).compareTo(b[0] as int);
    if (result != 0) return result;

    return (a[1] as int).compareTo(b[1] as int);
  }
}
