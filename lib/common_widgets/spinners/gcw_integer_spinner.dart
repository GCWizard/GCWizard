import 'package:flutter/material.dart';
import 'package:gc_wizard/application/theme/theme.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_iconbutton.dart';
import 'package:gc_wizard/common_widgets/gcw_text.dart';
import 'package:gc_wizard/common_widgets/spinners/spinner_constants.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_integer_textfield.dart';
import 'package:gc_wizard/utils/complex_return_types.dart';
import 'package:gc_wizard/utils/constants.dart';

enum SpinnerOverflowType {
  SUPPRESS_OVERFLOW, // stop spinning at min and max
  ALLOW_OVERFLOW, // overflow at min and max: when x < min -> max; when x > max -> min
  OVERFLOW_MIN, // overflow only on min: when x < min -> max; when x > max: ok
  OVERFLOW_MAX // overflow only on max: when x < min: ok; when x > max -> min
}

class GCWIntegerSpinner extends StatefulWidget {
  final void Function(int) onChanged;
  final String? title;
  final int value;
  int min;
  int max;
  final int? leftPadZeros;
  final TextEditingController? controller;
  final SpinnerLayout layout;
  final FocusNode? focusNode;
  final SpinnerOverflowType overflow;
  final List<int> flexValues;

  GCWIntegerSpinner({
    Key? key,
    required this.onChanged,
    this.title,
    required this.value,
    this.min = MIN_INT,
    this.max = MAX_INT,
    this.leftPadZeros,
    this.controller,
    this.layout = SpinnerLayout.HORIZONTAL,
    this.focusNode,
    this.overflow =
        SpinnerOverflowType.ALLOW_OVERFLOW, // TODO: Automatically true if this.min == null || this.max == null
    this.flexValues = const [],
  }) : super(key: key);

  @override
  _GCWIntegerSpinnerState createState() => _GCWIntegerSpinnerState();
}

class _GCWIntegerSpinnerState extends State<GCWIntegerSpinner> {
  late TextEditingController _controller;
  var _currentValue = 0;

  var _externalChange = true;

  @override
  void initState() {
    super.initState();

    if (widget.controller != null) {
      _controller = widget.controller!;
    } else {
      _currentValue = widget.value;

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
    _currentValue = widget.value;
    if (_externalChange) _controller.text = _currentValue.toString();

    _externalChange = true;

    return _buildSpinner();
  }

  void _decreaseValue() {
    setState(() {
      if (_currentValue > widget.min || widget.overflow == SpinnerOverflowType.OVERFLOW_MAX) {
        _currentValue--;
      } else if ([SpinnerOverflowType.ALLOW_OVERFLOW, SpinnerOverflowType.OVERFLOW_MIN].contains(widget.overflow) &&
          _currentValue == widget.min) {
        _currentValue = widget.max;
      }

      _setCurrentValueAndEmitOnChange(setTextFieldText: true);
    });
  }

  void _increaseValue() {
    // setState(() {
    if (_currentValue < widget.max || widget.overflow == SpinnerOverflowType.OVERFLOW_MIN) {
      _currentValue++;
    } else if ([SpinnerOverflowType.ALLOW_OVERFLOW, SpinnerOverflowType.OVERFLOW_MAX].contains(widget.overflow) &&
        _currentValue == widget.max) {
      _currentValue = widget.min;
    }

    _setCurrentValueAndEmitOnChange(setTextFieldText: true);
    // });
  }

  Widget _buildTitle() {
    return (widget.title == null)
        ? Container()
        : Expanded(
            flex: widget.flexValues.isNotEmpty ? widget.flexValues[0] : 1, child: GCWText(text: widget.title! + ':'));
  }

  Widget _buildTextField() {
    return GCWIntegerTextField(
        focusNode: widget.focusNode,
        min: widget.overflow == SpinnerOverflowType.OVERFLOW_MAX ? null : widget.min,
        max: widget.overflow == SpinnerOverflowType.OVERFLOW_MIN ? null : widget.max,
        controller: _controller,
        onChanged: (IntegerText ret) {
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
              flex: widget.flexValues.length > 1 ? widget.flexValues[1] : 3,
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
              flex: widget.flexValues.length > 1 ? widget.flexValues[1] : 3,
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
    if (setTextFieldText) {
      var text = _currentValue.toString();

      if (widget.leftPadZeros != null && widget.leftPadZeros! > 0) {
        text = text.padLeft(widget.leftPadZeros!, '0');
      }

      _controller.text = text;
    }

    widget.onChanged(_currentValue);
  }
}
