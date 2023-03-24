import 'package:flutter/material.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';

abstract class AbstractRotation extends StatefulWidget {
  final String Function(String) rotate;

  const AbstractRotation({Key? key, required this.rotate}) : super(key: key);

  @override
  AbstractRotationState createState() => AbstractRotationState();
}

class AbstractRotationState extends State<AbstractRotation> {
  String _output = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GCWTextField(
          onChanged: (text) {
            setState(() {
              _output = widget.rotate(text);
            });
          },
        ),
        GCWDefaultOutput(child: _output)
      ],
    );
  }
}
