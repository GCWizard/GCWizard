import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/common_widgets/dividers/gcw_text_divider.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_columned_multiline_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/tools/science_and_technology/ip_address/logic/ip_address.dart';
import 'package:gc_wizard/tools/science_and_technology/ip_address/widget/gcw_ip_address.dart';

class IPAddressMinimumSubnet extends StatefulWidget {
  const IPAddressMinimumSubnet({super.key});

  @override
  _IPAddressMinimumSubnetState createState() => _IPAddressMinimumSubnetState();
}

class _IPAddressMinimumSubnetState extends State<IPAddressMinimumSubnet> {
  var _currentInputIP_Start = IP([0,0,0,0]);
  var _currentInputIP_End = IP([0,0,0,0]);


  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GCWTextDivider(text: i18n(context, 'common_start')),
        GCWIPAddress(
          value: _currentInputIP_Start,
          onChanged: (IP value) {
            setState(() {
              _currentInputIP_Start = value;
            });
          }
        ),
        GCWTextDivider(text: i18n(context, 'common_end')),
        GCWIPAddress(
            value: _currentInputIP_End,
            onChanged: (IP value) {
              setState(() {
                _currentInputIP_End = value;
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
    if (!_currentInputIP_Start.isValid || !_currentInputIP_End.isValid) {
      return i18n(context, 'ipaddress_error_invalidip');
    }

    var output = minimumSubnet(_currentInputIP_Start, _currentInputIP_End);

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
