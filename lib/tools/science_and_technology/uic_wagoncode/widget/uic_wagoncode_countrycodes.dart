import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_dropdown.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_columned_multiline_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/tools/science_and_technology/uic_wagoncode/logic/uic_wagoncode.dart';

enum _GCWWagonCodesCountryCodesSortBy {NUMBER_CODE, LETTER_CODE, NAME}

class UICWagonCodeCountryCodes extends StatefulWidget {
  const UICWagonCodeCountryCodes({Key? key}) : super(key: key);

  @override
  _UICWagonCodeCountryCodesState createState() => _UICWagonCodeCountryCodesState();
}

class _UICWagonCodeCountryCodesState extends State<UICWagonCodeCountryCodes> {
  _GCWWagonCodesCountryCodesSortBy _currentSortBy = _GCWWagonCodesCountryCodesSortBy.NUMBER_CODE;

  String _sortBy(_GCWWagonCodesCountryCodesSortBy value) {
    String out;
    switch (value) {
      case _GCWWagonCodesCountryCodesSortBy.NUMBER_CODE:
        out = 'uic_wagoncode_countrycodes_sortby_numbercode';
        break;
      case _GCWWagonCodesCountryCodesSortBy.LETTER_CODE:
        out = 'uic_wagoncode_countrycodes_sortby_lettercode';
        break;
      case _GCWWagonCodesCountryCodesSortBy.NAME:
        out = 'common_name';
        break;
      default:
        out = '';
        break;
    }

    return i18n(context, out);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GCWDropDown(
            title: i18n(context, 'common_search'),
            value: _currentSortBy,
            items: _GCWWagonCodesCountryCodesSortBy.values.map((sortBy) {
              return GCWDropDownMenuItem(
                value: sortBy,
                child: _sortBy(sortBy)
              );
            }).toList(),
            onChanged: (_GCWWagonCodesCountryCodesSortBy value) {
              setState(() {
                _currentSortBy = value;
              });
            }
        ),
        GCWDefaultOutput(child: _buildOutput())
      ],
    );
  }

  Widget _buildOutput() {
    List<List<String>> data = UICCountryCodes.map((UICCountryCode country) {
      var name = i18n(context, country.name);

      switch (_currentSortBy) {
        case _GCWWagonCodesCountryCodesSortBy.NUMBER_CODE:
          return [country.numberCode, name, country.letterCode];
        case _GCWWagonCodesCountryCodesSortBy.LETTER_CODE:
          return [country.letterCode, name, country.numberCode];
        case _GCWWagonCodesCountryCodesSortBy.NAME:
          return [name, country.numberCode, country.letterCode];
        default:
          return <String>[];
      }
    }).toList();
    data.sort((a, b) => a[0].compareTo(b[0]));

    var flexValues = <int>[];
    var numberCodeHeader = i18n(context, 'uic_wagoncode_countrycodes_sortby_numbercode');
    var letterCodeHeader = i18n(context, 'uic_wagoncode_countrycodes_sortby_lettercode');
    var nameHeader = i18n(context, 'common_name');
    switch (_currentSortBy) {
      case _GCWWagonCodesCountryCodesSortBy.NUMBER_CODE:
        flexValues = [1, 2, 1];
        data.insert(0, [numberCodeHeader, nameHeader, letterCodeHeader]);
        break;
      case _GCWWagonCodesCountryCodesSortBy.LETTER_CODE:
        flexValues = [1, 2, 1];
        data.insert(0, [letterCodeHeader, nameHeader, numberCodeHeader]);
        break;
      case _GCWWagonCodesCountryCodesSortBy.NAME:
        flexValues = [2, 1, 1];
        data.insert(0, [nameHeader, numberCodeHeader, letterCodeHeader]);
        break;
      default:
        break;
    }

    return GCWColumnedMultilineOutput(data: data, flexValues: flexValues, copyColumn: 1, hasHeader: true);
  }
}
