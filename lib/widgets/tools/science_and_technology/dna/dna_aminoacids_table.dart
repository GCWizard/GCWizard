import 'package:flutter/material.dart';
import 'package:gc_wizard/i18n/app_localizations.dart';
import 'package:gc_wizard/logic/tools/science_and_technology/dna.dart';
import 'package:gc_wizard/widgets/common/gcw_columned_multiline_output.dart';

class DNAAminoAcidsTable extends StatefulWidget {
  @override
  DNAAminoAcidsTableState createState() => DNAAminoAcidsTableState();
}

class DNAAminoAcidsTableState extends State<DNAAminoAcidsTable> {
  @override
  Widget build(BuildContext context) {
    var acids = aminoAcids.map((acid) {
      var name;
      if (acid.name == null) {
        switch (acid.type) {
          case NucleobaseSequenceType.START:
            name = i18n(context, 'dna_start');
            break;
          case NucleobaseSequenceType.STOP:
            name = i18n(context, 'dna_stop');
            break;
          default:
            name = '';
        }
      } else {
        name = i18n(context, acid.name);
      }

      if (acid.symbolShort == 'M') name += '\n${i18n(context, 'dna_start')}';

      var sequences = acid.nucleobaseSequences;
      sequences.sort();

      return [
        name,
        acid.symbolLong == null ? '-' : acid.symbolLong,
        acid.symbolShort == null ? '-' : acid.symbolShort,
        sequences.join(', ')
      ];
    }).toList();

    acids.sort((a, b) => a[0].compareTo(b[0]));

    return GCWColumnedMultilineOutput(
        data: acids,
        flexValues: [3, 1, 1, 2]
    );
  }
}
