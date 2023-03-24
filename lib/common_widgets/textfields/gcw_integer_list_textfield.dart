import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/utils/collection_utils.dart';
import 'package:gc_wizard/utils/complex_return_types.dart';

class GCWIntegerListTextField extends StatefulWidget {
  final TextEditingController? controller;
  final void Function(IntegerListText) onChanged;
  final String? hintText;

  const GCWIntegerListTextField({
    Key? key,
    required this.onChanged,
    this.controller,
    this.hintText,
  }) : super(key: key);

  @override
  _GCWIntegerListTextFieldState createState() => _GCWIntegerListTextFieldState();
}

class _GCWIntegerListTextFieldState extends State<GCWIntegerListTextField> {
  @override
  Widget build(BuildContext context) {
    return GCWTextField(
      hintText: widget.hintText,
      onChanged: (text) {
        setState(() {
          var list = textToIntList(text);
          widget.onChanged(IntegerListText(text, list));
        });
      },
      controller: widget.controller,
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9\s]'))],
    );
  }
}
