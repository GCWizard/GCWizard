import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gc_wizard/application/theme/theme.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_iconbutton.dart';
import 'package:gc_wizard/common_widgets/gcw_text.dart';
import 'package:gc_wizard/common_widgets/spinners/spinner_constants.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_double_textfield.dart';
import 'package:intl/intl.dart';

class GCWDoubleSpinner extends StatefulWidget {
  final Function onChanged;
  final title;
  final value;
  final min;
  final max;
  final controller;
  final numberDecimalDigits;
  final SpinnerLayout layout;
  final focusNode;
  final suppressOverflow;

  GCWDoubleSpinner(
      {Key key,
      this.onChanged,
      this.title,
      this.value,
      this.min,
      this.max,
      this.numberDecimalDigits: 2,
      this.controller,
      this.layout: SpinnerLayout.HORIZONTAL,
      this.focusNode,
      this.suppressOverflow: false})
      : super(key: key);

  @override
  GCWDoubleSpinnerState createState() => GCWDoubleSpinnerState();
}

class GCWDoubleSpinnerState extends State<GCWDoubleSpinner> {
  TextEditingController _controller;

  bool _externalChange = true;

  var _currentValue = 0.0;
  var _numberFormat;

  @override
  void initState() {
    super.initState();

    _currentValue = widget.value;

    var formatString = '0';
    if (widget.numberDecimalDigits > 0) formatString += '.' + '#' * widget.numberDecimalDigits;
    _numberFormat = NumberFormat(formatString);

    if (widget.controller != null)
      _controller = widget.controller;
    else
      _controller = TextEditingController(text: _numberFormat.format(_currentValue));
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.value != null) {
      _currentValue = widget.value;

      if (_externalChange) _controller.text = _numberFormat.format(_currentValue);
    }

    _externalChange = true;

    return _buildSpinner();
  }

  _decreaseValue() {
    setState(() {
      if (widget.min == null || _currentValue > widget.min) {
        var newValue = _currentValue;
        if ((newValue.floor() - newValue).abs() <= 10e-10) {
          newValue--;
        } else {
          newValue = newValue.floor().toDouble();
        }

        _currentValue = widget.min == null ? newValue : max(widget.min, newValue);
      } else if (!widget.suppressOverflow && _currentValue == widget.min && widget.max != null) {
        _currentValue = widget.max;
      }

      _setCurrentValueAndEmitOnChange(setTextFieldText: true);
    });
  }

  _increaseValue() {
    setState(() {
      if (widget.max == null || _currentValue < widget.max) {
        var newValue = _currentValue;
        if ((newValue.ceil() - newValue).abs() <= 10e-10) {
          newValue++;
        } else {
          newValue = newValue.ceil().toDouble();
        }

        _currentValue = widget.max == null ? newValue : min(widget.max, newValue);
      } else if (!widget.suppressOverflow && _currentValue == widget.max && widget.min != null) {
        _currentValue = widget.min;
      }

      _setCurrentValueAndEmitOnChange(setTextFieldText: true);
    });
  }

  Widget _buildTitle() {
    return widget.title == null ? Container() : Expanded(child: GCWText(text: widget.title + ':'), flex: 1);
  }

  Widget _buildTextField() {
    return GCWDoubleTextField(
        focusNode: widget.focusNode,
        min: widget.min,
        max: widget.max,
        numberDecimalDigits: widget.numberDecimalDigits,
        controller: _controller,
        onChanged: (ret) {
          setState(() {
            _externalChange = false;

            _currentValue = ret['value'];

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
              child: Row(
                children: <Widget>[
                  Container(
                    child: GCWIconButton(icon: Icons.remove, onPressed: _decreaseValue),
                    margin: EdgeInsets.only(right: DOUBLE_DEFAULT_MARGIN),
                  ),
                  Expanded(child: _buildTextField()),
                  Container(
                    child: GCWIconButton(icon: Icons.add, onPressed: _increaseValue),
                    margin: EdgeInsets.only(left: DOUBLE_DEFAULT_MARGIN),
                  )
                ],
              ),
              flex: 3)
        ],
      );
    } else {
      return Row(
        children: <Widget>[
          _buildTitle(),
          Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  GCWIconButton(icon: Icons.arrow_drop_up, onPressed: _increaseValue),
                  _buildTextField(),
                  GCWIconButton(icon: Icons.arrow_drop_down, onPressed: _decreaseValue),
                ],
              ),
              flex: 3),
        ],
      );
    }
  }

  _setCurrentValueAndEmitOnChange({setTextFieldText: false}) {
    if (setTextFieldText) _controller.text = _numberFormat.format(_currentValue);

    widget.onChanged(_currentValue);
  }
}
