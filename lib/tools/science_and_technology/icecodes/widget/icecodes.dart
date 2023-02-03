import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/app_localizations.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_dropdown.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_columned_multiline_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/tools/science_and_technology/icecodes/logic/icecodes.dart';

class IceCodes extends StatefulWidget {
  @override
  IceCodesState createState() => IceCodesState();
}

class IceCodesState extends State<IceCodes> {
  IceCodeSystem _currentIceCodeSystem = IceCodeSystem.BALTIC;
  IceCodeSubSystem _currentIceCodeSubSystemBaltic = IceCodeSubSystem.A;
  IceCodeSubSystem _currentIceCodeSubSystemEU = IceCodeSubSystem.CONDITION;
  IceCodeSubSystem _currentIceCodeSubSystemWMO = IceCodeSubSystem.CONCENTRATION;
  IceCodeSubSystem _currentIceCodeSubSystem = IceCodeSubSystem.A;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GCWDropDown(
          value: _currentIceCodeSystem,
          onChanged: (value) {
            setState(() {
              _currentIceCodeSystem = value;
              switch (_currentIceCodeSystem) {
                case IceCodeSystem.BALTIC:
                  _currentIceCodeSubSystemBaltic = IceCodeSubSystem.A;
                  break;
                case IceCodeSystem.EU:
                  _currentIceCodeSubSystemBaltic = IceCodeSubSystem.CONDITION;
                  break;
                case IceCodeSystem.WMO:
                  _currentIceCodeSubSystemBaltic = IceCodeSubSystem.CONCENTRATION;
                  break;
                case IceCodeSystem.SIGRID:
                  _currentIceCodeSubSystemBaltic = IceCodeSubSystem.SIGRID;
                  break;
              }
              _currentIceCodeSubSystem = _currentIceCodeSubSystemBaltic;
            });
          },
          items: ICECODE_SYSTEM.entries.map((system) {
            return GCWDropDownMenuItem(
              value: system.key,
              child: i18n(context, system.value),
            );
          }).toList(),
        ),
        if (_currentIceCodeSystem == IceCodeSystem.BALTIC)
          GCWDropDown(
            value: _currentIceCodeSubSystemBaltic,
            onChanged: (value) {
              setState(() {
                _currentIceCodeSubSystemBaltic = value;
                _currentIceCodeSubSystem = value;
              });
            },
            items: ICECODE_SUBSYSTEM_BALTIC.entries.map((system) {
              return GCWDropDownMenuItem(
                value: system.key,
                child: i18n(context, system.value),
              );
            }).toList(),
          ),
        if (_currentIceCodeSystem == IceCodeSystem.EU)
          GCWDropDown(
            value: _currentIceCodeSubSystemEU,
            onChanged: (value) {
              setState(() {
                _currentIceCodeSubSystemEU = value;
                _currentIceCodeSubSystem = value;
              });
            },
            items: ICECODE_SUBSYSTEM_EU.entries.map((system) {
              return GCWDropDownMenuItem(
                value: system.key,
                child: i18n(context, system.value),
              );
            }).toList(),
          ),
        if (_currentIceCodeSystem == IceCodeSystem.WMO)
          GCWDropDown(
            value: _currentIceCodeSubSystemWMO,
            onChanged: (value) {
              setState(() {
                _currentIceCodeSubSystemWMO = value;
                _currentIceCodeSubSystem = value;
              });
            },
            items: ICECODE_SUBSYSTEM_WMO.entries.map((system) {
              return GCWDropDownMenuItem(
                value: system.key,
                child: i18n(context, system.value),
              );
            }).toList(),
          ),
        _buildOutput()
      ],
    );
  }

  Widget _buildOutput() {
    var iceCode = ICECODES[_currentIceCodeSystem];
    return GCWDefaultOutput(
      child: GCWColumnedMultilineOutput(
        data: iceCode[_currentIceCodeSubSystem].entries.map((entry) {
                return [entry.key, i18n(context, entry.value)];
              }).toList(),
        flexValues: [1, 5]
      )
    );
  }
}
