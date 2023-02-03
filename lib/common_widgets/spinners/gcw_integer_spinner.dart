import 'package:flutter/material.dart';
import 'package:gc_wizard/application/theme/theme.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_iconbutton.dart';
import 'package:gc_wizard/common_widgets/gcw_text.dart';
import 'package:gc_wizard/common_widgets/spinners/spinner_constants.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_integer_textfield.dart';

enum SpinnerOverflowType {
  SUPPRESS_OVERFLOW, // stop spinning at min and max
  ALLOW_OVERFLOW, // overflow at min and max: when x < min -> max; when x > max -> min
  OVERFLOW_MIN, // overflow only on min: when x < min -> max; when x > max: ok
  OVERFLOW_MAX // overflow only on max: when x < min: ok; when x > max -> min
}

class GCWIntegerSpinner extends StatefulWidget {
  final Function onChanged;
  final title;
  final int value;
  final int min;
  final int max;
  final int leftPadZeros;
  final controller;
  final SpinnerLayout layout;
  final FocusNode focusNode;
  final SpinnerOverflowType overflow;

  const GCWIntegerSpinner(
      {Key key,
      this.onChanged,
      this.title,
      this.value,
      this.min: -9007199254740991,
      this.max: 9007199254740992,
      this.leftPadZeros,
      this.controller,
      this.layout: SpinnerLayout.HORIZONTAL,
      this.focusNode,
      this.overflow:
          SpinnerOverflowType.ALLOW_OVERFLOW // TODO: Automatically true if this.min == null || this.max == null
      })
      : super(key: key);

  @override
  GCWIntegerSpinnerState createState() => GCWIntegerSpinnerState();
}

class GCWIntegerSpinnerState extends State<GCWIntegerSpinner> {
  TextEditingController _controller;
  var _currentValue = 0;

  var _externalChange = true;

  @override
  void initState() {
    super.initState();

    if (widget.controller != null) {
      _controller = widget.controller;
    } else {
      if (widget.value != null) _currentValue = widget.value;

      _controller = TextEditingController(text: _currentValue.toString());
    }
  }

  @override
  void dispose() {
    if (widget.controller == null) _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.value != null) {
      _currentValue = widget.value;

      if (_externalChange) _controller.text = _currentValue.toString();
    }

    _externalChange = true;

    return _buildSpinner();
  }

  _decreaseValue() {
    setState(() {
      if (widget.min == null || _currentValue > widget.min || widget.overflow == SpinnerOverflowType.OVERFLOW_MAX) {
        _currentValue--;
      } else if ([SpinnerOverflowType.ALLOW_OVERFLOW, SpinnerOverflowType.OVERFLOW_MIN].contains(widget.overflow) &&
          _currentValue == widget.min &&
          widget.max != null) {
        _currentValue = widget.max;
      }

      _setCurrentValueAndEmitOnChange(setTextFieldText: true);
    });
  }

  _increaseValue() {
    setState(() {
      if (widget.max == null || _currentValue < widget.max || widget.overflow == SpinnerOverflowType.OVERFLOW_MIN) {
        _currentValue++;
      } else if ([SpinnerOverflowType.ALLOW_OVERFLOW, SpinnerOverflowType.OVERFLOW_MAX].contains(widget.overflow) &&
          _currentValue == widget.max &&
          widget.min != null) {
        _currentValue = widget.min;
      }

      _setCurrentValueAndEmitOnChange(setTextFieldText: true);
    });
  }

  Widget _buildTitle() {
    return widget.title == null ? Container() : Expanded(child: GCWText(text: widget.title + ':'), flex: 1);
  }

  Widget _buildTextField() {
    return GCWIntegerTextField(
        focusNode: widget.focusNode,
        min: widget.overflow == SpinnerOverflowType.OVERFLOW_MAX ? null : widget.min,
        max: widget.overflow == SpinnerOverflowType.OVERFLOW_MIN ? null : widget.max,
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
    if (setTextFieldText) {
      var text = _currentValue.toString();

      if (widget.leftPadZeros != null && widget.leftPadZeros > 0) {
        text = text.padLeft(widget.leftPadZeros, '0');
      }

      _controller.text = text;
    }

    widget.onChanged(_currentValue);
  }
}
