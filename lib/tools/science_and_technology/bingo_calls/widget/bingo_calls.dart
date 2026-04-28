import 'package:flutter/material.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_columned_multiline_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/tools/science_and_technology/bingo_calls/logic/bingo_calls.dart';

class BingoCalls extends StatefulWidget {
  const BingoCalls({super.key});

  @override
  _BingoCallsState createState() => _BingoCallsState();
}

class _BingoCallsState extends State<BingoCalls> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _buildOutput(context);
  }

  Widget _buildOutput(BuildContext context) {
    List<List<String>> output = [];

    BINGO_CALLS_EN.forEach((k, v) {
      output.add([k, v.title.join('\n'), v.description]);
    });

    return GCWDefaultOutput(
      child: GCWColumnedMultilineOutput(
        data: output,
        flexValues: const [1, 2, 4],
        copyColumn: 1,
      ),
    );
  }

}
