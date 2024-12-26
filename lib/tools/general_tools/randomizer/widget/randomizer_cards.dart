import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/application/theme/theme.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_button.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_dropdown.dart';
import 'package:gc_wizard/common_widgets/gcw_snackbar.dart';
import 'package:gc_wizard/common_widgets/gcw_text.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_columned_multiline_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/spinners/gcw_integer_spinner.dart';
import 'package:gc_wizard/tools/general_tools/randomizer/logic/randomizer_cards.dart' as cards;

class RandomizerCards extends StatefulWidget {
  const RandomizerCards({Key? key}) : super(key: key);

  @override
  _RandomizerCardsState createState() => _RandomizerCardsState();
}

class _RandomizerCardsState extends State<RandomizerCards> {
  var _currentCount = 1;

  Widget _currentOutput = const GCWDefaultOutput();

  var _currentDeckType = cards.CardDeck.POKER;
  late List<cards.Card> _currentDeck;

  final _cardsDrawn = <List<cards.Card>>[];

  @override
  void initState() {
    super.initState();

    _currentDeck = cards.initializeCardDeck(_currentDeckType);
  }

  void _reinit() {
    _currentOutput = const GCWDefaultOutput();
    _currentDeck = cards.initializeCardDeck(_currentDeckType);
    _cardsDrawn.clear();
    _currentCount = 1;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GCWDropDown<cards.CardDeck>(
          value: _currentDeckType,
          items: cards.CardDeck.values.map((cards.CardDeck deck) {
            String title, description;
            switch (deck) {
              case cards.CardDeck.SKAT:
                title = 'randomizer_cards_skat_title';
                description = 'randomizer_cards_skat_description';
                break;
              case cards.CardDeck.POKER:
                title = 'randomizer_cards_poker_title';
                description = 'randomizer_cards_poker_description';
                break;
              case cards.CardDeck.ROMME:
                title = 'randomizer_cards_romme_title';
                description = 'randomizer_cards_romme_description';
                break;
            }

            return GCWDropDownMenuItem<cards.CardDeck>(
              value: deck,
              child: i18n(context, title),
              subtitle: i18n(context, description)
            );
          }).toList(),
          onChanged: (cards.CardDeck value) {
            setState(() {
              _currentDeckType = value;
              _reinit();
            });
          }
        ),
        GCWButton(
          text: i18n(context, 'randomizer_cards_reshuffle'),
          onPressed: () {
            setState(() {
              _reinit();
            });
          },
        ),
        GCWText(
          text: i18n(context, 'randomizer_cards_remaining') + ': ' + _currentDeck.length.toString()
        ),
        Container(height: DOUBLE_DEFAULT_MARGIN),
        GCWIntegerSpinner(
          title: i18n(context, 'common_count'),
          min: 1,
          max: _currentDeck.length,
          value: _currentCount,
          onChanged: (int value) {
            setState(() {
              _currentCount = value;
            });
          },
        ),
        GCWButton(
          text: i18n(context, 'randomizer_cards_draw'),
          onPressed: () {
            setState(() {
              _calculateOutput();
            });
          }
        ),
        _currentOutput
      ],
    );
  }

  void _calculateOutput() {
    if (_currentDeck.isEmpty) {
      showSnackBar(i18n(context, 'randomizer_cards_deckempty'), context);
      return;
    }

    var drawn = cards.drawCards(_currentDeck, _currentCount);
    _currentDeck = drawn.cardsRemaining;
    _cardsDrawn.add(drawn.cardsDrawn);

    if (_currentCount > _currentDeck.length) {
      _currentCount = _currentDeck.length;
    }

    _currentOutput = GCWDefaultOutput(
      child: Column(
        children: [GCWColumnedMultilineOutput(flexValues: const [1, 6], data: _cardsDrawn.asMap().map((int index, List<cards.Card> draw) {
          return MapEntry(
            index,
            [index + 1, draw.map((cards.Card card) => _cardName(card)).join(' ')]
          );
        }).values.toList()),
      ]),
    );
  }

  String _cardName(cards.Card card) {
    if (card is cards.JokerCard) {
      return '\u2605';
    }

    if (card.value == '10') {
      return card.suit + card.value;
    }

    var name = i18n(context, card.value, ifTranslationNotExists: card.value);
    return card.suit + name[0];
  }
}
