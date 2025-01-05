import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/common_widgets/gcw_text.dart';
import 'package:gc_wizard/common_widgets/text_input_formatters/gcw_bearing_textinputformatter.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_double_textfield.dart';
import 'package:gc_wizard/utils/complex_return_types.dart';
import 'package:gc_wizard/utils/constants.dart';

class GCWAngle extends StatefulWidget {
  final void Function(DoubleText) onChanged;
  final String? hintText;

  const GCWAngle({Key? key, required this.onChanged, this.hintText}) : super(key: key);

  @override
  _GCWAngleState createState() => _GCWAngleState();
}

class _GCWAngleState extends State<GCWAngle> {
  late TextEditingController _angleController;
  var _currentAngle = defaultDoubleText;

  @override
  void initState() {
    super.initState();
    _angleController = TextEditingController(text: _currentAngle.text);
  }

  @override
  void dispose() {
    _angleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(children: <Widget>[
      Expanded(
        flex: 33,
        child: GCWDoubleTextField(
          hintText: widget.hintText ?? i18n(context, 'common_bearing_hint'),
          controller: _angleController,
          textInputFormatter: GCWBearingTextInputFormatter(),
          onChanged: (DoubleText ret) {
            setState(() {
              _currentAngle = ret;
              widget.onChanged(_currentAngle);
            });
          },
        ),
      ),
      const Expanded(
        flex: 1,
        child: GCWText(text: '°'),
      ),
    ]);
  }
}
