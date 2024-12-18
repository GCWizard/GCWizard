import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_submit_button.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_dropdown.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_columned_multiline_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_output.dart';
import 'package:gc_wizard/common_widgets/spinners/gcw_integer_spinner.dart';
import 'package:gc_wizard/tools/general_tools/randomizer/logic/randomizer_rockpaperscissors.dart';

class RandomizerRockPaperScissors extends StatefulWidget {
  const RandomizerRockPaperScissors({Key? key}) : super(key: key);

  @override
  _RandomizerRockPaperScissorsState createState() => _RandomizerRockPaperScissorsState();
}

class _RandomizerRockPaperScissorsState extends State<RandomizerRockPaperScissors> {
  var _currentCount = 1;
  var _currentVersion = RockPaperScissorsVersion.ORIGINAL;

  Widget _currentOutput = const GCWDefaultOutput();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GCWIntegerSpinner(
          title: i18n(context, 'common_count'),
          min: 1,
          max: 1000,
          value: _currentCount,
          onChanged: (int value) {
            setState(() {
              _currentCount = value;
            });
          },
        ),
        GCWDropDown<RockPaperScissorsVersion>(
          title: i18n(context, 'common_version'),
          value: _currentVersion,
          items: RockPaperScissorsVersion.values.map((value) {
            String title;
            String description;
            switch (value) {
              case RockPaperScissorsVersion.ORIGINAL:
                title = i18n(context, 'randomizer_rockpaperscissors_original');
                description = '';
                break;
              case RockPaperScissorsVersion.BIG_BANG_THEORY:
                title = i18n(context, 'randomizer_rockpaperscissors_bigbangtheory');
                description = i18n(context, 'randomizer_rockpaperscissors_bigbangtheory_description');
                break;
            }

            return GCWDropDownMenuItem<RockPaperScissorsVersion>(
              value: value,
              child: title,
              subtitle: description
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _currentVersion = value;
            });
          }
        ),
        GCWSubmitButton(
          onPressed: () {
            setState(() {
              _calculateOutput();
            });
          },
        ),
        _currentOutput
      ],
    );
  }

  String _elementName(RockPaperScissorsElement element) {
    switch (element) {
      case RockPaperScissorsElement.ROCK: return i18n(context, 'randomizer_rockpaperscissors_rock');
      case RockPaperScissorsElement.PAPER: return i18n(context, 'randomizer_rockpaperscissors_paper');
      case RockPaperScissorsElement.SCISSORS: return i18n(context, 'randomizer_rockpaperscissors_scissors');
      case RockPaperScissorsElement.LIZARD: return i18n(context, 'randomizer_rockpaperscissors_lizard');
      case RockPaperScissorsElement.SPOCK: return i18n(context, 'randomizer_rockpaperscissors_spock');
          }
  }

  String _winnerName(RockPaperScissorsGameResult result) {
    switch (result) {
      case RockPaperScissorsGameResult.LEFT: return i18n(context, 'common_left');
      case RockPaperScissorsGameResult.RIGHT: return i18n(context, 'common_right');
      case RockPaperScissorsGameResult.DRAW: return i18n(context, 'randomizer_rockpaperscissors_draw');
    }
  }

  void _calculateOutput() {
    var out = <RockPaperScissorsResult>[];
    for (int i = 0; i < _currentCount; i++) {
      out.add(randomizerRockPaperScissors(_currentVersion));
    }

    if (out.isEmpty) {
      _currentOutput = const GCWDefaultOutput();
      return;
    }

    var data = out.asMap().map((int index, RockPaperScissorsResult result) {
      return MapEntry(index,
          [
            (index + 1).toString() + '.',
            _elementName(result.left),
            _elementName(result.right),
            _winnerName(result.winner)
          ]
      );
    }).values.toList();

    data.insert(0, [
      '',
      i18n(context, 'common_left'),
      i18n(context, 'common_right'),
      i18n(context, 'common_winner'),
    ]);


    var output = <Widget>[
      GCWColumnedMultilineOutput(data: [
        [_winnerName(RockPaperScissorsGameResult.LEFT), out.where((RockPaperScissorsResult result) => result.winner == RockPaperScissorsGameResult.LEFT).length],
        [_winnerName(RockPaperScissorsGameResult.RIGHT), out.where((RockPaperScissorsResult result) => result.winner == RockPaperScissorsGameResult.RIGHT).length],
        [_winnerName(RockPaperScissorsGameResult.DRAW), out.where((RockPaperScissorsResult result) => result.winner == RockPaperScissorsGameResult.DRAW).length],
      ]),
      GCWOutput(
        title: i18n(context, 'common_details'),
        child: GCWColumnedMultilineOutput(
          data: data,
          hasHeader: true,
          flexValues: const [1,2,2,2],
        ),
      )
    ];

    _currentOutput = GCWDefaultOutput(
      child: Column(
        children: output,
      ),
    );
  }
}
