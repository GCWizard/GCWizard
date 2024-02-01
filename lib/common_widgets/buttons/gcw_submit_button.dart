import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_button.dart';

class GCWSubmitButton extends StatefulWidget {
  final void Function() onPressed;

  const GCWSubmitButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  _GCWSubmitButtonState createState() => _GCWSubmitButtonState();
}

class _GCWSubmitButtonState extends State<GCWSubmitButton> {
  @override
  Widget build(BuildContext context) {
    return GCWButton(onPressed: widget.onPressed, text: i18n(context, 'common_submit_button_text'));
  }
}
