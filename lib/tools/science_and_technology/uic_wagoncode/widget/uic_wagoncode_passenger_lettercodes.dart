import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/application/theme/theme.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_dropdown.dart';
import 'package:gc_wizard/common_widgets/gcw_text.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_columned_multiline_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/tools/science_and_technology/uic_wagoncode/logic/uic_wagoncode_passenger_lettercodes.dart';

class UICWagonCodePassengerLettercodes extends StatefulWidget {
  const UICWagonCodePassengerLettercodes({Key? key}) : super(key: key);

  @override
  _UICWagonCodePassengerLettercodesState createState() => _UICWagonCodePassengerLettercodesState();
}

class _UICWagonCodePassengerLettercodesState extends State<UICWagonCodePassengerLettercodes> {
  String _currentInput = '';
  String _countryCode = '80';

  late TextEditingController _inputController;

  @override
  void initState() {
    super.initState();
    _inputController = TextEditingController(text: _currentInput);
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GCWDropDown(
          value: _countryCode,
          title: i18n(context, 'uic_countrycode'),
          items: [
            '50 (DR)', '80 (DB)', '81 (ÖBB)', '85 (SBB)', '-1'
          ].map((country) {
            return GCWDropDownMenuItem(
                value: country.substring(0, 2),
                child: country == '-1' ? i18n(context, 'common_other') : country
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _countryCode = value;
            });
          }
        ),
        Container(
          height: 2 * DOUBLE_DEFAULT_MARGIN
        ),
        GCWText(
          text: i18n(context, 'common_case_sensitive'),
          style: gcwDescriptionTextStyle(),
        ),
        GCWTextField(
          controller: _inputController,
          onChanged: (value) {
            setState(() {
              _currentInput = value;
            });
          },
        ),
        GCWDefaultOutput(child: _buildOutput())
      ],
    );
  }

  Widget _buildOutput() {
    return GCWColumnedMultilineOutput(
      data: uicPassengerWagonLetterCodes(_countryCode, _currentInput).entries.map((e) {
        return [e.key, i18n(context, e.value)];
      }).toList(),
      flexValues: const [1, 4]
    );
  }
}
