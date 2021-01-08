import 'package:flutter/material.dart';
import 'package:gc_wizard/i18n/app_localizations.dart';
import 'package:gc_wizard/theme/theme.dart';
import 'package:gc_wizard/theme/theme_colors.dart';

final TextStyle _textStyle = gcwTextStyle().copyWith(color: themeColors().dialogText());
final TextStyle _boldTextStyle = _textStyle.copyWith(fontWeight: FontWeight.bold);

showGCWDialog(BuildContext context, String title, Widget child, List<GCWDialogButton> buttons, {cancelButton: true, closeOnOutsideTouch: false}) {
  if (cancelButton)
    buttons.add(_cancelButton);

  AlertDialog dialog = AlertDialog(
    title: Text(title),
    content: child,
    actions: buttons,
    backgroundColor: themeColors().dialog(),
    titleTextStyle: _boldTextStyle,
    contentTextStyle: _textStyle
  );

  showDialog(
    context: context,
    barrierDismissible: closeOnOutsideTouch,
    builder: (BuildContext context) {
      return dialog;
    },
  );
}

showGCWAlertDialog(BuildContext context, String title, String text, Function onOKPressed) {
  GCWDialogButton _okButton = GCWDialogButton(
    text: i18n(context, 'common_ok'),
    onPressed: onOKPressed
  );

  showGCWDialog(context, title, Text(text), [_okButton]);
}

class GCWDialogButton extends StatefulWidget {
  final String text;
  final isCancelButton;
  final Function onPressed;
  final bool suppressClose;

  const GCWDialogButton({Key key, this.text, this.onPressed, this.isCancelButton: false, this.suppressClose: false}) : super(key: key);

  @override
  _GCWDialogButtonState createState() => _GCWDialogButtonState();
}

class _GCWDialogButtonState extends State<GCWDialogButton> {

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      //TODO: GCWText instead Text; currently with GCWText onPressed() is not called
      child: Text(
        widget.isCancelButton ? i18n(context, 'common_cancel') : widget.text,
        style: _boldTextStyle,
      ),
      onPressed: () {
        if (!widget.suppressClose)
          Navigator.of(context).pop();

        if (!widget.isCancelButton && widget.onPressed != null)
          widget.onPressed();
      },
    );
  }
}

final _cancelButton = GCWDialogButton(
  isCancelButton: true,
);