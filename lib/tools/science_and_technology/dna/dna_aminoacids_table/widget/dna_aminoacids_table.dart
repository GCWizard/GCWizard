import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/app_localizations.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_columned_multiline_output.dart';
import 'package:gc_wizard/tools/science_and_technology/dna/logic/dna.dart';

class DNAAminoAcidsTable extends StatefulWidget {
  const DNAAminoAcidsTable({Key? key}) : super(key: key);

  @override
  DNAAminoAcidsTableState createState() => DNAAminoAcidsTableState();
}

class DNAAminoAcidsTableState extends State<DNAAminoAcidsTable> {
  @override
  Widget build(BuildContext context) {
    List<List<Object>> acids = aminoAcids.map((acid) {
      String name;
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
        name = i18n(context, acid.name!);
      }

      if (acid.symbolShort == 'M') name += '\n${i18n(context, 'dna_start')}';

      var sequences = acid.nucleobaseSequences;
      sequences.sort();

      return [
        name,
        acid.symbolLong ?? '-',
        acid.symbolShort ?? '-',
        sequences.join(', ')
      ];
    }).toList();

    acids.sort((a, b) => (a[0] as String).compareTo((b[0] as String)));

    return GCWColumnedMultilineOutput(
        data: acids,
        flexValues: const [3, 1, 1, 2]
    );
  }
}
