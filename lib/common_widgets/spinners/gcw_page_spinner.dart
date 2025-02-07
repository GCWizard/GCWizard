import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_iconbutton.dart';
import 'package:gc_wizard/common_widgets/gcw_text.dart';

class GCWPageSpinner extends StatefulWidget {
  final void Function(int) onChanged;
  final String? text;
  final String? textExtension;
  final TextStyle? style;
  final int index;
  final int max;
  final int stepSize;
  final bool suppressOverflow;
  final Widget? trailing;

  const GCWPageSpinner(
      {Key? key,
        required this.onChanged,
        this.text,
        this.textExtension,
        this.style,
        required this.index,
        required this.max,
        this.stepSize = 1,
        this.suppressOverflow = false,
        this.trailing})
      : super(key: key);

  @override
  _GCWPageSpinnerState createState() => _GCWPageSpinnerState();
}

class _GCWPageSpinnerState extends State<GCWPageSpinner> {
  var _currentIndex = 1;

  @override
  Widget build(BuildContext context) {
    _currentIndex = widget.index;

    return Row(
      children: <Widget>[
        GCWIconButton(
          icon: Icons.arrow_forward_ios,
          rotateDegrees: 180,
          onPressed: () {
            _decreaseValue();
          },
        ),
        Expanded(
          child: GCWText(
            align: Alignment.center,
            text: (widget.text == null ? '' : widget.text! + ' ') +
                _formatIndexText() +
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

  String _formatIndexText() {
    if (widget.stepSize > 1) {
      return '$_currentIndex - ${min(_currentIndex + widget.stepSize - 1, widget.max)}/ ${widget.max}';
    } else {
      return '$_currentIndex/ ${widget.max}';
    }
  }

  void _decreaseValue() {
    _currentIndex -= widget.stepSize;
    if (_currentIndex < 1) {
      if (widget.suppressOverflow) {
        _currentIndex = 1;
        return;
      } else {
        _currentIndex = widget.max;
      }
    }
    setState(() {
      widget.onChanged(_currentIndex);
    });
  }

  void _increaseValue() {
    _currentIndex += widget.stepSize;
    if (_currentIndex > widget.max) {
      if (widget.suppressOverflow) {
        _currentIndex = widget.max - widget.stepSize + 1;
        return;
      } else {
        _currentIndex = 1;
      }
    }
    setState(() {
      widget.onChanged(_currentIndex);
    });
  }
}
