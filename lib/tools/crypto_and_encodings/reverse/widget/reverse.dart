import 'package:flutter/material.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/reverse/logic/reverse.dart';

class Reverse extends StatefulWidget {
  const Reverse({Key? key}) : super(key: key);

  @override
  _ReverseState createState() => _ReverseState();
}

class _ReverseState extends State<Reverse> {
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
