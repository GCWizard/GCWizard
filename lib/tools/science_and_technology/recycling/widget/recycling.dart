import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/app_localizations.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_columned_multiline_output.dart';
import 'package:gc_wizard/tools/science_and_technology/recycling/logic/recycling.dart';

class Recycling extends StatefulWidget {
  const Recycling({Key? key}) : super(key: key);

  @override
  RecyclingState createState() => RecyclingState();
}

class RecyclingState extends State<Recycling> {
  @override
  Widget build(BuildContext context) {
    List<List<dynamic>> data = RECYCLING_CODES.entries.map((entry) {
      return <dynamic>[
        entry.key.replaceAll(RegExp(r'\D'), ''),
        entry.value['short'],
        i18n(context, entry.value['name']!)
      ];
    }).toList();

    data.insert(
        0, [i18n(context, 'recycling_code'), i18n(context, 'recycling_short'), i18n(context, 'recycling_name')]);

    return GCWColumnedMultilineOutput(
        data: data,
        flexValues: const [1, 2, 4],
        hasHeader: true,
        copyColumn: 1
    );
  }
}
