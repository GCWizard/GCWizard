import 'package:flutter/material.dart';
import 'package:gc_wizard/i18n/app_localizations.dart';
import 'package:gc_wizard/tools/science_and_technology/ip_codes/logic/ip_codes.dart';
import 'package:gc_wizard/tools/common/base/gcw_dropdownbutton/widget/gcw_dropdownbutton.dart';
import 'package:gc_wizard/tools/common/base/gcw_text/widget/gcw_text.dart';
import 'package:gc_wizard/tools/common/gcw_default_output/widget/gcw_default_output.dart';
import 'package:gc_wizard/tools/utils/common_widget_utils/widget/common_widget_utils.dart';

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
        GCWDropDownButton(
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

  _buildOutput() {
    var children = columnedMultiLineOutput(
        context,
        IP_CODES[_currentIPClass].map((key) {
          return [key, _ipTexts(key)];
        }).toList(),
        flexValues: [1, 4]);

    children.insert(
        0,
        Container(
          child: GCWText(text: i18n(context, 'ipcodes_${_currentIPClass}_description')),
          padding: EdgeInsets.only(bottom: 10),
        ));

    return Column(children: children);
  }
}
