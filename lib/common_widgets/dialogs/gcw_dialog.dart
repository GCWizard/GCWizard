import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/app_localizations.dart';
import 'package:gc_wizard/application/theme/theme.dart';
import 'package:gc_wizard/application/theme/theme_colors.dart';

final TextStyle _textStyle = gcwTextStyle().copyWith(color: themeColors().dialogText());
final TextStyle _boldTextStyle = _textStyle.copyWith(fontWeight: FontWeight.bold);

void showGCWDialog(BuildContext context, String title, Widget? child, List<Widget> buttons,
    {bool cancelButton = true, bool closeOnOutsideTouch = false}) {
  if (cancelButton) {
    buttons.add(GCWDialogButton(
      text: i18n(context, 'common_cancel'),
    ));
  }

  AlertDialog dialog = AlertDialog(
      title: Text(title),
      content: child,
      actions: buttons,
      backgroundColor: themeColors().dialog(),
      titleTextStyle: _boldTextStyle,
      contentTextStyle: _textStyle);

  showDialog<bool>(
    context: context,
    barrierDismissible: closeOnOutsideTouch,
    builder: (BuildContext context) {
      return dialog;
    },
  );
}

void showGCWAlertDialog(BuildContext context, String title, String text,
    void Function()? onOKPressed, {bool cancelButton = true}) {
  GCWDialogButton _okButton = GCWDialogButton(text: i18n(context, 'common_ok'), onPressed: onOKPressed);

  showGCWDialog(context, title, Text(text), [_okButton], cancelButton: cancelButton);
}

class GCWDialogButton extends StatefulWidget {
  final String text;
  final void Function()? onPressed;
  final bool suppressClose;

  const GCWDialogButton({Key? key, required this.text, this.onPressed, this.suppressClose = false})
      : super(key: key);

  @override
  _GCWDialogButtonState createState() => _GCWDialogButtonState();
}

class _GCWDialogButtonState extends State<GCWDialogButton> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      //TODO: GCWText instead Text; currently with GCWText onPressed() is not called
      child: Text(
        widget.text,
        style: _boldTextStyle,
      ),
      onPressed: () {
        if (!widget.suppressClose) Navigator.of(context).pop();

        if (widget.onPressed != null) widget.onPressed!();
      }
    );
  }
}
