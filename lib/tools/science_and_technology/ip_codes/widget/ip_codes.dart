import 'package:flutter/material.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_dropdown.dart';
import 'package:gc_wizard/common_widgets/gcw_text.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_columned_multiline_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/i18n/app_localizations.dart';
import 'package:gc_wizard/tools/science_and_technology/ip_codes/logic/ip_codes.dart';

class IPCodes extends StatefulWidget {
  @override
  IPCodesState createState() => IPCodesState();
}

class IPCodesState extends State<IPCodes> {
  var _currentIPClass = IP_CODES.keys.first;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GCWDropDown(
          value: _currentIPClass,
          items: IP_CODES.keys.map((clazz) {
            return GCWDropDownMenuItem(
                value: clazz,
                child: i18n(context, 'ipcodes_${clazz}_title'),
                subtitle: i18n(context, 'ipcodes_${clazz}_description'));
          }).toList(),
          onChanged: (value) {
            setState(() {
              _currentIPClass = value;
            });
          },
        ),
        GCWDefaultOutput(child: _buildOutput()),
      ],
    );
  }

  String _ipTexts(String key) {
    if (_currentIPClass != 'ip1') return i18n(context, 'ipcodes_${_currentIPClass}_$key');

    var effect = i18n(context, 'ipcodes_ip1_${key}_effect');
    var example = i18n(context, 'ipcodes_ip1_${key}_example');
    example = example != null ? '\n\n' + example : '';

    return effect + example;
  }

  Widget _buildOutput() {
    return GCWColumnedMultilineOutput(
        firstRows: [Container(
                      child: GCWText(text: i18n(context, 'ipcodes_${_currentIPClass}_description')),
                      padding: EdgeInsets.only(bottom: 10),
                    )],
        data: IP_CODES[_currentIPClass].map((key) {
                return [key, _ipTexts(key)];
              }).toList(),
        flexValues: [1, 4]
    );
  }
}