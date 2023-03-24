import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gc_wizard/common_widgets/text_input_formatters/gcw_integer_textinputformatter.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/utils/complex_return_types.dart';
import 'package:gc_wizard/utils/data_type_utils/integer_type_utils.dart';

class GCWIntegerTextField extends StatefulWidget {
  final TextEditingController? controller;
  final void Function(IntegerText) onChanged;
  final TextInputFormatter? textInputFormatter;
  final String? hintText;
  final int? min;
  final int? max;
  final FocusNode? focusNode;

  const GCWIntegerTextField(
      {Key? key,
      required this.onChanged,
      this.controller,
      this.textInputFormatter,
      this.hintText,
      this.min,
      this.max,
      this.focusNode})
      : super(key: key);

  @override
  _GCWIntegerTextFieldState createState() => _GCWIntegerTextFieldState();
}

class _GCWIntegerTextFieldState extends State<GCWIntegerTextField> {
  late GCWIntegerTextInputFormatter _integerInputFormatter;

  @override
  void initState() {
    super.initState();

    _integerInputFormatter = GCWIntegerTextInputFormatter(min: widget.min ?? 0, max: widget.max);
  }

  @override
  Widget build(BuildContext context) {
    return GCWTextField(
      hintText: widget.hintText,
      onChanged: (String text) {
        setState(() {
          if (!isInteger(text)) {
            return;
          }

          var _value = ['', '-'].contains(text) ? max<int>(widget.min ?? 0, 0) : int.parse(text);

          if (widget.min != null && _value < widget.min!) _value = widget.min!;

          if (widget.max != null && _value > widget.max!) _value = widget.max!;

          widget.onChanged(IntegerText(text, _value));
        });
      },
      controller: widget.controller,
      inputFormatters: [widget.textInputFormatter ?? _integerInputFormatter],
      keyboardType: TextInputType.numberWithOptions(signed: widget.min == null || widget.min! < 0, decimal: false),
      focusNode: widget.focusNode,
    );
  }
}
