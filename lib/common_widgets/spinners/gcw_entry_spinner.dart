import 'package:flutter/material.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_iconbutton.dart';
import 'package:gc_wizard/common_widgets/gcw_text.dart';

class GCWEntrySpinner extends StatefulWidget {
  final void Function(int) onChanged;
  final String? text;
  final String? textExtension;
  final TextStyle? style;
  final int value;
  final int max;
  final bool viewBraces;
  final bool suppressOverflow;
  final Widget? trailing;

  const GCWEntrySpinner(
      {Key? key,
      required this.onChanged,
      this.text,
      this.textExtension,
      this.style,
      required this.value,
      required this.max,
      this.viewBraces = false,
      this.suppressOverflow = false,
      this.trailing})
      : super(key: key);

  @override
  _GCWEntrySpinnerState createState() => _GCWEntrySpinnerState();
}

class _GCWEntrySpinnerState extends State<GCWEntrySpinner> {
  var _currentValue = 1;

  @override
  Widget build(BuildContext context) {
    _currentValue = widget.value;

    return Row(
      children: <Widget>[
        GCWIconButton(
          icon: Icons.arrow_back_ios,
          onPressed: () {
            _decreaseValue();
          },
        ),
        Expanded(
          child: GCWText(
            align: Alignment.center,
            text: (widget.text == null ? '' : widget.text! + ' ') +
                (widget.viewBraces ? '(' : '') +
                _currentValue.toString() + ' / ' + widget.max.toString() +
                (widget.viewBraces ? ')' : '') +
                (widget.textExtension ?? ''),
            style: widget.style,
          ),
        ),
        widget.trailing ?? Container(),
        GCWIconButton(
          icon: Icons.arrow_forward_ios,
          onPressed: () {
            _increaseValue();
          },
        ),
      ],
    );
  }

  void _decreaseValue() {
    _currentValue--;
    if (_currentValue < 1) {
      if (widget.suppressOverflow) {
        _currentValue = 1;
        return;
      } else {
        _currentValue = widget.max;
      }
    }
    setState(() {
      widget.onChanged(_currentValue);
    });
  }

  void _increaseValue() {
    _currentValue++;
    if (_currentValue > widget.max) {
      if (widget.suppressOverflow) {
        _currentValue = widget.max;
        return;
      } else {
        _currentValue = 1;
      }
    }
    setState(() {
      widget.onChanged(_currentValue);
    });
  }
}
