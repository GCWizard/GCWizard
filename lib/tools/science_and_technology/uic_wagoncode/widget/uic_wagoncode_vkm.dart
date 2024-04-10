import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_button.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_columned_multiline_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_twooptions_switch.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/tools/science_and_technology/uic_wagoncode/logic/uic_wagoncode_vkm.dart';

class UICWagonCodeVKM extends StatefulWidget {
  const UICWagonCodeVKM({Key? key}) : super(key: key);

  @override
  _UICWagonCodeVKMState createState() => _UICWagonCodeVKMState();
}

class _UICWagonCodeVKMState extends State<UICWagonCodeVKM> {
  late TextEditingController _inputControllerCode;
  late TextEditingController _inputControllerName;

  String _currentInputCode = '';
  String _currentInputName = '';

  GCWSwitchPosition _currentMode = GCWSwitchPosition.right;

  Widget? _output;

  @override
  void initState() {
    super.initState();
    _inputControllerCode = TextEditingController(text: _currentInputCode);
    _inputControllerName = TextEditingController(text: _currentInputName);
  }

  @override
  void dispose() {
    _inputControllerCode.dispose();
    _inputControllerName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GCWTwoOptionsSwitch(
          value: _currentMode,
          notitle: true,
          leftValue: i18n(context, 'uic_wagoncode_vkm_search_name'),
          rightValue: i18n(context, 'uic_wagoncode_vkm_search_code'),
          onChanged: (value) {
            setState(() {
              _currentMode = value;
              _output = null;
            });
          },
        ),
        _currentMode == GCWSwitchPosition.left
            ? GCWTextField(
          controller: _inputControllerName,
          hintText: i18n(context, 'common_name_contains'),
          onChanged: (text) {
            setState(() {
              _currentInputName = text;
              _output = null;
            });
          },
        )
        : GCWTextField(
          controller: _inputControllerCode,
          hintText: i18n(context, 'common_code_startswith'),
          onChanged: (text) {
            setState(() {
              _currentInputCode = text;
              _output = null;
            });
          },
        ),
        GCWButton(
          text: i18n(context, 'common_search'),
          onPressed: () {
            setState(() {
              _output = _buildOutput();
            });
          },
        ),
        GCWDefaultOutput(child: _output)
      ],
    );
  }

  Widget _buildOutput() {
    if (_currentMode == GCWSwitchPosition.left) {
      // search for name
      if (_currentInputName.isEmpty) return Container();

      var data =
          UICWagonCodesVKM.where((vkm) {
            var vkmName = removeDiacritics(vkm.keeper_name.toLowerCase());
            var checkName = removeDiacritics(_currentInputName.toLowerCase());
            return vkmName.contains(checkName);
          }).map((vkm) => [vkm.keeper_name, vkm.vkm, vkm.country]).toList();

      var flexValues = [2, 1, 1];
      data.sort((a, b) => a[0].compareTo(b[0]));
      data.insert(0, [
        i18n(context, 'common_name'),
        i18n(context, 'uic_wagoncode_vkm_vkm'),
        i18n(context, 'common_country')
      ]);

      return GCWColumnedMultilineOutput(data: data, flexValues: flexValues, copyColumn: 1, hasHeader: true);
    } else {
      // search for code
      if (_currentInputCode.isEmpty) return Container();

      var data =
          UICWagonCodesVKM.where((vkm) {
            var vkmCode = removeDiacritics(vkm.vkm.toLowerCase());
            var checkCode = removeDiacritics(_currentInputCode.toLowerCase());
            return vkmCode.startsWith(checkCode);
          }).map((vkm) => [vkm.vkm, vkm.keeper_name, vkm.country]).toList();

      var flexValues = [1, 2, 1];
      data.sort((a, b) {
        var result = a[0].compareTo(b[0]);
        if (result != 0) return result;

        return a[1].compareTo(b[1]);
      });

      data.insert(0, [
        i18n(context, 'uic_wagoncode_vkm_vkm'),
        i18n(context, 'common_name'),
        i18n(context, 'common_country')
      ]);

      return GCWColumnedMultilineOutput(data: data, flexValues: flexValues, copyColumn: 1, hasHeader: true);
    }
  }
}
