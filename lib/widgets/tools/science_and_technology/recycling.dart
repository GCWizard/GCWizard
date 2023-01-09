import 'package:flutter/material.dart';
import 'package:gc_wizard/i18n/app_localizations.dart';
import 'package:gc_wizard/logic/tools/science_and_technology/recycling.dart';
import 'package:gc_wizard/widgets/common/gcw_columned_multiline_output.dart';

class Recycling extends StatefulWidget {
  @override
  RecyclingState createState() => RecyclingState();
}

class RecyclingState extends State<Recycling> {
  @override
  Widget build(BuildContext context) {
    List<List<dynamic>> data = RECYCLING_CODES.entries.map((entry) {
      return <dynamic>[
        entry.key.replaceAll(RegExp(r'[^0-9]'), ''),
        entry.value['short'],
        i18n(context, entry.value['name'])
      ];
    }).toList();

    data.insert(
        0, [i18n(context, 'recycling_code'), i18n(context, 'recycling_short'), i18n(context, 'recycling_name')]);

    return GCWColumnedMultilineOutput(
        data: data,
        flexValues: [1, 2, 4],
        hasHeader: true,
        copyColumn: 1
    );
  }
}
