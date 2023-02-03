import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/app_localizations.dart';
import 'package:gc_wizard/common_widgets/dividers/gcw_text_divider.dart';
import 'package:gc_wizard/common_widgets/gcw_text.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_twooptions_switch.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/tools/science_and_technology/dna/logic/dna.dart';

class DNANucleicAcidSequence extends StatefulWidget {
  @override
  DNANucleicAcidSequenceState createState() => DNANucleicAcidSequenceState();
}

class DNANucleicAcidSequenceState extends State<DNANucleicAcidSequence> {
  var _currentMode = GCWSwitchPosition.right;
  var _currentInput = '';
  var _currentDNAMode = GCWSwitchPosition.left;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GCWTextField(
          onChanged: (value) {
            setState(() {
              _currentInput = value;
            });
          },
        ),
        GCWTwoOptionsSwitch(
          value: _currentMode,
          onChanged: (value) {
            setState(() {
              _currentMode = value;
            });
          },
        ),
        GCWTwoOptionsSwitch(
          leftValue: i18n(context, 'dna_nucleicacidsequence_type_dna'),
          rightValue: i18n(context, 'dna_nucleicacidsequence_type_mrna'),
          title: i18n(context, 'dna_nucleicacidsequence_type'),
          value: _currentDNAMode,
          onChanged: (value) {
            setState(() {
              _currentDNAMode = value;
            });
          },
        ),
        _buildOutput()
      ],
    );
  }

  _buildOutput() {
    if (_currentMode == GCWSwitchPosition.left) {
      var output;

      if (_currentDNAMode == GCWSwitchPosition.left) {
        output = encodeDNANucleobaseSequence(_currentInput);
      } else {
        output = encodeRNANucleobaseSequence(_currentInput);
      }

      return GCWDefaultOutput(child: output);
    } else {
      var acids = <AminoAcid>[];
      if (_currentDNAMode == GCWSwitchPosition.left) {
        acids = decodeDNANucleobaseSequence(_currentInput);
      } else {
        acids = decodeRNANucleobaseSequence(_currentInput);
      }

      var includesM = false;
      var outputText = acids.map((acid) {
        if (acid.symbolShort == null) {
          switch (acid.type) {
            case NucleobaseSequenceType.START:
              return i18n(context, 'dna_start');
            case NucleobaseSequenceType.STOP:
              return i18n(context, 'dna_stop');
            default:
              return '';
          }
        }

        if (acid.symbolShort == 'M') includesM = true;

        return acid.symbolShort;
      }).join();

      return Column(
        children: <Widget>[
          GCWDefaultOutput(child: outputText),
          includesM ? GCWTextDivider(text: i18n(context, 'common_note')) : Container(),
          includesM
              ? GCWText(
                  text: i18n(context, 'dna_nucleicacidsequence_notem',
                      parameters: [_currentDNAMode == GCWSwitchPosition.left ? 'ATG' : 'AUG']))
              : Container()
        ],
      );
    }
  }
}
