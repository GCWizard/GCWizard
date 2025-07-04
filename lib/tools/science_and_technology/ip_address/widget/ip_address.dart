import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/common_widgets/dividers/gcw_text_divider.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_columned_multiline_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/spinners/gcw_integer_spinner.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_twooptions_switch.dart';
import 'package:gc_wizard/tools/science_and_technology/ip_address/logic/ip_address.dart';
import 'package:gc_wizard/tools/science_and_technology/ip_address/widget/gcw_ip_address.dart';

class IPAddress extends StatefulWidget {
  const IPAddress({super.key});

  @override
  _IPAddressState createState() => _IPAddressState();
}

class _IPAddressState extends State<IPAddress> {
  var _currentInputIP = IP([0,0,0,0]);

  var _currentSubnetMaskMode = GCWSwitchPosition.left;
  var _currentSubnetMaskSpinner = 0;
  var _currentSubnetMaskIP = IP([0,0,0,0]);
  var _currentSubnetMask = IPSubnetMask.fromBits(0);

  void _setSubnetMaskValue() {
    _currentSubnetMask = (_currentSubnetMaskMode == GCWSwitchPosition.left)
        ? IPSubnetMask.fromBits(_currentSubnetMaskSpinner)
        : IPSubnetMask(_currentSubnetMaskIP);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GCWTextDivider(text: i18n(context, 'ipaddress_ipaddress')),
        GCWIPAddress(
          value: _currentInputIP,
          onChanged: (IP value) {
            setState(() {
              _currentInputIP = value;
            });
          }
        ),
        GCWTextDivider(text: i18n(context, 'ipaddress_subnetmask')),
        GCWTwoOptionsSwitch(
          leftValue: i18n(context, 'ipaddress_subnetmask_usedbits'),
          rightValue: i18n(context, 'ipaddress_subnetmask_ipmask'),
          value: _currentSubnetMaskMode,
          onChanged: (value) {
            setState(() {
              _currentSubnetMaskMode = value;
              _setSubnetMaskValue();
            });
          }
        ),
        (_currentSubnetMaskMode == GCWSwitchPosition.left)
          ? GCWIntegerSpinner(
              value: _currentSubnetMaskSpinner,
              min: 0,
              max: 32,
              onChanged: (int value) {
                setState(() {
                  _currentSubnetMaskSpinner = value;
                  _setSubnetMaskValue();
                });
              },
            )
          : GCWIPAddress(
              value: _currentSubnetMaskIP,
              onChanged: (IP value) {
                setState(() {
                  _currentSubnetMaskIP = value;
                  _setSubnetMaskValue();
                });
              }
            ),
        GCWDefaultOutput(
          child: _buildOutput()
        )
      ],
    );
  }

  Object _buildOutput() {
    if (!_currentInputIP.isValid) {
      return i18n(context, 'ipaddress_error_invalidip');
    }
    if (!_currentSubnetMask.isValid) {
      return i18n(context, 'ipaddress_error_invalidsubnetmask');
    }

    var output = ipSubnet(_currentInputIP, _currentSubnetMask);

    return GCWColumnedMultilineOutput(
      data: [
        [i18n(context, 'ipaddress_subnetmask'), output.subnetMask.subnet.toString() + ' (${output.subnetMask.toBits()})', output.subnetMask.subnet.toBinaryString()],
        [i18n(context, 'ipaddress_networkname'), output.networkNameIPPart.toString() + '/${output.subnetMask.toBits()}', output.networkNameIPPart.toBinaryString()],
        [i18n(context, 'ipaddress_networkclass'), output.networkClass ?? '-', null],
        [i18n(context, 'ipaddress_broadcastip'), nullableIPsToString(output.broadcastIP), nullableBinaryIPsToString(output.broadcastIP)],
        [i18n(context, 'ipaddress_startip'), nullableIPsToString(output.startIP), nullableBinaryIPsToString(output.startIP)],
        [i18n(context, 'ipaddress_endip'), nullableIPsToString(output.endIP), nullableBinaryIPsToString(output.endIP)],
        [i18n(context, 'ipaddress_totalips'), output.totalNumbersIPs, null],
        [i18n(context, 'ipaddress_usableips'), output.usableNumberIPs, null],
      ],
      copyColumn: 1,
    );
  }
}
