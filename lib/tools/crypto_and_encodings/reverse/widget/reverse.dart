import 'package:flutter/material.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/reverse/logic/reverse.dart';
import 'package:gc_wizard/tools/common/base/gcw_textfield/widget/gcw_textfield.dart';
import 'package:gc_wizard/tools/common/gcw_default_output/widget/gcw_default_output.dart';

class Reverse extends StatefulWidget {
  @override
  ReverseState createState() => ReverseState();
}

class ReverseState extends State<Reverse> {
  String _output = '';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GCWTextField(
          onChanged: (text) {
            setState(() {
              _output = reverse(text);
            });
          },
        ),
        GCWDefaultOutput(child: _output)
      ],
    );
  }
}
