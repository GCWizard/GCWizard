import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/common_widgets/dividers/gcw_text_divider.dart';

class GCWRadioButtonSet extends StatefulWidget {
  final void Function(int) onChanged;
  final String? title;
  final int activeButton;
  final List<String> buttons;
  final bool notitle;
  final int? number;

  const GCWRadioButtonSet(
      {Key? key,
      this.title,
      this.number,
      required this.activeButton,
      required this.buttons,
      required this.onChanged,
      this.notitle = false})
      : super(key: key);

  @override
  _GCWRadioButtonSetState createState() => _GCWRadioButtonSetState();
}

class _GCWRadioButtonSetState extends State<GCWRadioButtonSet> {
  int _activeButton = 0;

  Widget _buttons() {
    List<Widget> buttons = [];

    for (int i = 0; i < widget.buttons.length; i++) {
         Widget button = Expanded(
           child: ListTile(
             title: Text(i18n(context, widget.buttons[i])),
             dense: true,
             leading: Radio<int>(
               value: i,
               groupValue: _activeButton,
               onChanged: (int? value) {
                 setState(() {
                   _activeButton = value!;
                   widget.onChanged(_activeButton);
                 });
               },
             ),
           ),
         );
      buttons.add(button);
    }
    return Row(
      children: buttons,
    );
  }

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        widget.notitle
            ? Container()
            : GCWTextDivider(
                text: (widget.title ?? i18n(context, 'common_mode')),
              ),
        _buttons(),
      ],
    );
  }
}
