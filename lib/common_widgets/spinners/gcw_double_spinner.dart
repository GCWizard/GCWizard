import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gc_wizard/application/theme/theme.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_iconbutton.dart';
import 'package:gc_wizard/common_widgets/gcw_text.dart';
import 'package:gc_wizard/common_widgets/spinners/spinner_constants.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_double_textfield.dart';
import 'package:gc_wizard/utils/complex_return_types.dart';
import 'package:intl/intl.dart';

class GCWDoubleSpinner extends StatefulWidget {
  final void Function(double) onChanged;
  final String? title;
  final double value;
  final double? min;
  final double? max;
  final TextEditingController? controller;
  final int numberDecimalDigits;
  final SpinnerLayout layout;
  final FocusNode? focusNode;
  final bool suppressOverflow;

  const GCWDoubleSpinner(
      {Key? key,
        required this.onChanged,
        this.title,
        required this.value,
        this.min,
        this.max,
        this.numberDecimalDigits = 2,
        this.controller,
        this.layout = SpinnerLayout.HORIZONTAL,
        this.focusNode,
        this.suppressOverflow = false})
      : super(key: key);

  @override
  GCWDoubleSpinnerState createState() => GCWDoubleSpinnerState();
}

class GCWDoubleSpinnerState extends State<GCWDoubleSpinner> {
  late TextEditingController _controller;

  bool _externalChange = true;

  var _currentValue = 0.0;
  late NumberFormat _numberFormat;

  @override
  void initState() {
    super.initState();

    _currentValue = widget.value;

    var formatString = '0';
    if (widget.numberDecimalDigits > 0) formatString += '.' + '#' * widget.numberDecimalDigits;
    _numberFormat = NumberFormat(formatString);

    if (widget.controller != null) {
      _controller = widget.controller!;
    } else {
      _controller = TextEditingController(text: _numberFormat.format(_currentValue));
    }
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _currentValue = widget.value;

    if (_externalChange) _controller.text = _numberFormat.format(_currentValue);

    _externalChange = true;

    return _buildSpinner();
  }

  void _decreaseValue() {
    setState(() {
      if (widget.min == null || _currentValue > widget.min!) {
        var newValue = _currentValue;
        if ((newValue.floor() - newValue).abs() <= 10e-10) {
          newValue--;
        } else {
          newValue = newValue.floor().toDouble();
        }

        _currentValue = widget.min == null ? newValue : max(widget.min!, newValue);
      } else if (!widget.suppressOverflow && _currentValue == widget.min && widget.max != null) {
        _currentValue = widget.max!;
      }

      _setCurrentValueAndEmitOnChange(setTextFieldText: true);
    });
  }

  void _increaseValue() {
    setState(() {
      if (widget.max == null || _currentValue < widget.max!) {
        var newValue = _currentValue;
        if ((newValue.ceil() - newValue).abs() <= 10e-10) {
          newValue++;
        } else {
          newValue = newValue.ceil().toDouble();
        }

        _currentValue = widget.max == null ? newValue : min(widget.max!, newValue);
      } else if (!widget.suppressOverflow && _currentValue == widget.max && widget.min != null) {
        _currentValue = widget.min!;
      }

      _setCurrentValueAndEmitOnChange(setTextFieldText: true);
    });
  }

  Widget _buildTitle() {
    return widget.title == null ? Container() : Expanded(flex: 1, child: GCWText(text: widget.title! + ':'));
  }

  Widget _buildTextField() {
    return GCWDoubleTextField(
        focusNode: widget.focusNode,
        min: widget.min,
        max: widget.max,
        numberDecimalDigits: widget.numberDecimalDigits,
        controller: _controller,
        onChanged: (DoubleText ret) {
          setState(() {
            _externalChange = false;
            _currentValue = ret.value;

            _setCurrentValueAndEmitOnChange();
          });
        });
  }

  Widget _buildSpinner() {
    if (widget.layout == SpinnerLayout.HORIZONTAL) {
      return Row(
        children: <Widget>[
          _buildTitle(),
          Expanded(
              flex: 3,
              child: Row(
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(right: DOUBLE_DEFAULT_MARGIN),
                    child: GCWIconButton(icon: Icons.remove, onPressed: _decreaseValue),
                  ),
                  Expanded(child: _buildTextField()),
                  Container(
                    margin: const EdgeInsets.only(left: DOUBLE_DEFAULT_MARGIN),
                    child: GCWIconButton(icon: Icons.add, onPressed: _increaseValue),
                  )
                ],
              ))
        ],
      );
    } else {
      return Row(
        children: <Widget>[
          _buildTitle(),
          Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  GCWIconButton(icon: Icons.arrow_drop_up, onPressed: _increaseValue),
                  _buildTextField(),
                  GCWIconButton(icon: Icons.arrow_drop_down, onPressed: _decreaseValue),
                ],
              )),
        ],
      );
    }
  }

  void _setCurrentValueAndEmitOnChange({bool setTextFieldText = false}) {
    if (setTextFieldText) _controller.text = _numberFormat.format(_currentValue);

    widget.onChanged(_currentValue);
  }
}
