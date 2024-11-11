import 'dart:math';

enum CardDeck {SKAT, POKER, ROMME}
class Card {
  final String suit;
  final String value;

  Card(this.suit, this.value);

  @override
  String toString() {
    return suit +  value;
  }
}
class JokerCard extends Card {
  JokerCard() : super('', '');

  @override
  String toString() {
    return 'randomizer_cards_joker';
  }
}

List<Card> initializeCardDeck(CardDeck deckType) {
  var deck = <Card>[];
  var suits = ['\u2660', '\u2665', '\u2666', '\u2663'];
  var values = ['7', '8', '9', '10', 'randomizer_cards_jack', 'randomizer_cards_queen', 'randomizer_cards_king', 'randomizer_cards_ace'];
  if (deckType == CardDeck.POKER || deckType == CardDeck.ROMME) {
    values.addAll(const ['2', '3', '4', '5', '6']);
  }
  for (var suit in suits) {
    for (var value in values) {
      deck.add(Card(suit, value));
    }
  }
  if (deckType == CardDeck.ROMME) {
    deck.add(JokerCard());
    deck.add(JokerCard());
    deck.add(JokerCard());
    deck.addAll(List<Card>.from(deck));
  }

  deck.shuffle();

  return deck;
}

class CardsDraw {
  final List<Card> cardsDrawn;
  final List<Card> cardsRemaining;

  CardsDraw(this.cardsDrawn, this.cardsRemaining);
}

CardsDraw drawCards(List<Card> deck, int cardsToDraw) {
  if (cardsToDraw <= 0) {
    return CardsDraw(<Card>[], deck);
  }

  int cardCount = min(cardsToDraw, deck.length);

  var cards = deck.sublist(0, cardCount);
  deck.removeRange(0, cardCount);

  return CardsDraw(cards, deck);
}