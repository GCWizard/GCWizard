import 'package:flutter/material.dart';
import 'package:gc_wizard/common_widgets/gcw_web_statefulwidget.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';

abstract class AbstractRotation extends GCWWebStatefulWidget {
  final String Function(String) rotate;

  AbstractRotation({Key? key, required this.rotate, required super.apiSpecification}) : super(key: key);

  @override
  _AbstractRotationState createState() => _AbstractRotationState();
}

class _AbstractRotationState extends State<AbstractRotation> {
  late TextEditingController _controller;

  String _currentInput = '';

  @override
  void initState() {
    super.initState();

    if (widget.hasWebParameter()) {
      _currentInput = widget.getWebParameter('input') ?? _currentInput;
      widget.webParameter = null;
    }
    _controller = TextEditingController(text: _currentInput);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GCWTextField(
          controller: _controller,
          onChanged: (text) {
            setState(() {
              _currentInput = text;
            });
          },
        ),
        GCWDefaultOutput(child: widget.rotate(_currentInput))
      ],
    );
  }
}
