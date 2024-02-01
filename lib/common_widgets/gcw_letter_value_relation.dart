import 'package:flutter/material.dart';
import 'package:gc_wizard/application/theme/theme.dart';
import 'package:gc_wizard/common_widgets/gcw_text.dart';
import 'package:gc_wizard/common_widgets/spinners/gcw_abc_spinner.dart';
import 'package:gc_wizard/common_widgets/spinners/gcw_integer_spinner.dart';

class GCWLetterValueRelation extends StatefulWidget {
  final void Function(int) onChanged;
  final int minValue;
  final int startValue;

  const GCWLetterValueRelation({Key? key, required this.onChanged, this.minValue = 1, this.startValue = 1})
      : super(key: key);

  @override
  _GCWLetterValueRelationState createState() => _GCWLetterValueRelationState();
}

class _GCWLetterValueRelationState extends State<GCWLetterValueRelation> {
  late int _currentKey;
  int _currentLetterValue = 1;

  @override
  void initState() {
    super.initState();
    _currentKey = widget.startValue;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: GCWABCSpinner(
          value: _currentLetterValue,
          suppressLetterValues: true,
          onChanged: (value) {
            setState(() {
              _currentLetterValue = value;
              _calculateAndEmitValue();
            });
          },
        )),
        Container(
          padding: const EdgeInsets.only(left: 2 * DEFAULT_MARGIN, right: 2 * DEFAULT_MARGIN),
          child: const GCWText(
            text: '=',
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
          child: GCWIntegerSpinner(
            value: _currentKey,
            min: widget.minValue,
            max: widget.minValue + 25,
            onChanged: (value) {
              setState(() {
                _currentKey = value;
                _calculateAndEmitValue();
              });
            },
          ),
        )
      ],
    );
  }

  void _calculateAndEmitValue() {
    var key = _currentKey - _currentLetterValue + 1;

    if (key < widget.minValue) key += 26;

    widget.onChanged(key);
  }
}
