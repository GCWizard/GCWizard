import 'package:flutter/material.dart';
import 'package:gc_wizard/i18n/app_localizations.dart';
import 'package:gc_wizard/tools/common/base/gcw_button/widget/gcw_button.dart';

class GCWSubmitButton extends StatefulWidget {
  final Function onPressed;

  const GCWSubmitButton({Key key, this.onPressed}) : super(key: key);

  @override
  _GCWSubmitButtonState createState() => _GCWSubmitButtonState();
}

class _GCWSubmitButtonState extends State<GCWSubmitButton> {
  @override
  Widget build(BuildContext context) {
    return GCWButton(onPressed: widget.onPressed, text: i18n(context, 'common_submit_button_text'));
  }
}
