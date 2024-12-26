import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/application/theme/theme.dart';
import 'package:gc_wizard/application/theme/theme_colors.dart';
import 'package:gc_wizard/common_widgets/dividers/gcw_text_divider.dart';
import 'package:gc_wizard/common_widgets/gcw_text.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_columned_multiline_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/spinners/gcw_integer_spinner.dart';
import 'package:gc_wizard/tools/games/tower_of_hanoi/logic/tower_of_hanoi.dart';

class TowerOfHanoi extends StatefulWidget {
  const TowerOfHanoi({Key? key}) : super(key: key);

  @override
  _TowerOfHanoiState createState() => _TowerOfHanoiState();
}

class _TowerOfHanoiState extends State<TowerOfHanoi> {

  int _discCount = 1;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GCWIntegerSpinner(
          title: i18n(context, 'tower_of_hanoi_disc_count'),
          value: _discCount,
          min: 1,
          max: MAXDISCCOUNT,
          onChanged: (value) {
            setState(() {
              _discCount = value;
            });
          },
          flexValues: const [1, 1],
        ),
        GCWDefaultOutput(child: _buildOutput(context))
      ],
    );
  }

  Widget _buildOutput(BuildContext context) {
    var moveString = i18n(context, 'tower_of_hanoi_move_message');

    var dataMoves = <List<Object>>[];
    if (_discCount <= MAXDISCVIEWCOUNT) {
      dataMoves = moves(_discCount).mapIndexed((index, entry) {
        var move = moveString.replaceFirst('{0}', entry.$2.toString());
        move = move.replaceFirst('{1}', entry.$3.toString());
        move = move.replaceFirst('{2}', entry.$4.toString());
        return <Object>[(index + 1).toString(),
          Column(
            children: [
              GCWText(text: move),
              Container(height: 2 * DOUBLE_DEFAULT_MARGIN),
              Container(
                color: themeColors().dialog(),
                child: GCWText(
                  text: entry.$1,
                  style: gcwMonotypeTextStyle().copyWith(color: themeColors().dialogText()),
                ),
              ),
            ],
          )
        ];
      }).toList();

      dataMoves.insert(0, [
        i18n(context, 'tower_of_hanoi_move'),
        i18n(context, 'tower_of_hanoi_towers')
      ]);
    }

    return Column(
        children: <Widget>[
          GCWColumnedMultilineOutput(
            data: [[i18n(context, 'tower_of_hanoi_move_count'),
              moveCount(_discCount).toString()]],
            flexValues: const [2, 4]
          ),
          Container(padding: const EdgeInsets.only(bottom: 10)),
          GCWTextDivider(text: i18n(context, 'tower_of_hanoi_moves')),
          (_discCount > MAXDISCVIEWCOUNT)
            ? GCWText(text: i18n(context, 'tower_of_hanoi_to_many_moves'))
            : GCWColumnedMultilineOutput(
                hasHeader: true,
                flexValues: const [1, 4],
                data: dataMoves
              ),
    ]);
  }
}
