import 'package:gc_wizard/utils/alphabets.dart';
import 'package:gc_wizard/utils/common_utils.dart';
import 'package:tuple/tuple.dart';

const int _JOKER_A = 53;
const int _JOKER_B = 54;

class SolitaireOutput {
  final String output;
  final String keyStream;
  final String resultDeck;

  SolitaireOutput(this.output, this.keyStream, this.resultDeck);
}

Map<String, int> _createSolitaireAlphabetMap() {
  return alphabet_AZ;
}

SolitaireOutput encryptSolitaire(String input, String key) {
  return _solitaireBase(input, key, true);
}

SolitaireOutput decryptSolitaire(String input, String key) {
  return _solitaireBase(input, key, false);
}

SolitaireOutput _solitaireBase(String input, String key, bool encrypt) {
  if (input == null || input.length == 0) return null;

  var alphabet = _createSolitaireAlphabetMap();
  if (alphabet == null) return null;

  input = input.toUpperCase().split('').map((character) => alphabet.containsKey(character) ? character : '').join();

  if (key != null) {
    key = key.toUpperCase().split('').map((character) => alphabet.containsKey(character) ? character : '').join();
  }

  if (encrypt) {
    // Groups of 5 letters
    int streamLength = (input.length / 5.0).ceil() * 5;
    // Use X to fill the last group
    input = input.padRight(streamLength, 'X');
  }

  var deck = createDeck();
  var tuple = createKeyStream(input, key, deck, alphabet);
  var keyStream = tuple.item1;
  deck = tuple.item2;
  String output;
  if (encrypt) {
    output = _createEncryptOutput(input, keyStream, alphabet);
    output = insertSpaceEveryNthCharacter(output, 5);
  } else
    output = _createDecryptOutput(input, keyStream, alphabet);

  return SolitaireOutput(output, keyStream, deck.join(', '));
}

String _createEncryptOutput(String input, String keyStream, Map<String, int> alphabet) {
  var output = '';
  for (int i = 0; i < input.length; i++) output += _chr(alphabet[input[i]] + alphabet[keyStream[i]], alphabet);

  return output;
}

String _createDecryptOutput(String input, String keyStream, Map<String, int> alphabet) {
  var output = "";
  for (int i = 0; i < input.length; i++) output += _chr(alphabet[input[i]] - alphabet[keyStream[i]], alphabet);

  return output;
}

List<int> createDeck() {
  var deck = <int>[];
  // Bridge cards +2 joker
  for (int i = 0; i < 54; i++) deck.add(i + 1);

  return deck;
}

Tuple2<String, List<int>> createKeyStream(String input, String key, List<int> deck, Map<String, int> alphabet) {
  var streamLetters = '';
  int issueCard;

  // use key -> init deck
  if (key != null && key != "") {
    for (int i = 0; i < key.length; i++) {
      deck = _cycleDeck(deck);
      // Step 4 (position -> value from key letter)
      deck = _takeOff(deck, alphabet[key[i]]);
    }
  }

  for (int i = 0; i < input.length; i++) {
    deck = _cycleDeck(deck);
    issueCard = _issueCard(key, i, deck);

    // if issueCard a joker ?
    while ((issueCard == _JOKER_A) || (issueCard == _JOKER_B)) {
      deck = _cycleDeck(deck);
      issueCard = _issueCard(key, i, deck);
    }
    streamLetters += _chr(issueCard, alphabet);
  }

  return Tuple2<String, List<int>>(streamLetters, deck);
}

String _chr(int letter, Map<String, int> alphabet) {
  letter = letter % alphabet.length;

  if (letter == 0) letter = alphabet.length;

  var letterString = alphabet.keys.firstWhere((k) => alphabet[k] == letter, orElse: () => null);

  return letterString;
}

int _issueCard(String key, int index, List<int> deck) {
  int cardIndex = deck[0];

  if (cardIndex == _JOKER_B) cardIndex = _JOKER_A;
  return deck[cardIndex];
}

List<int> _cycleDeck(List<int> deck) {
  // Step 1 (Joker A. Move it down one card)
  var deckSize = deck.length;
  var offet = 1;
  var jokerAPos = deck.indexOf(_JOKER_A);
  // last card?
  if (jokerAPos == deckSize - 1)
    // under first card
    offet += 1;
  var newPos = (jokerAPos + offet) % (deckSize);
  deck.remove(_JOKER_A);
  deck.insert(newPos, _JOKER_A);

  // Step 2 (Joker B. Move it down two cards)
  offet = 2;
  var jokerBPos = deck.indexOf(_JOKER_B);
  // last/ prelast card ?
  if (jokerBPos >= deckSize - 2)
    // under first/ second card
    offet += 1;
  newPos = (jokerBPos + offet) % (deckSize);
  deck.remove(_JOKER_B);
  deck.insert(newPos, _JOKER_B);

  // Step 3 (tripartite take-off through. That means, swap the cards before the first joker with those after the second joker)
  jokerAPos = deck.indexOf(_JOKER_A);
  jokerBPos = deck.indexOf(_JOKER_B);
  var firstjoker = jokerAPos < jokerBPos ? jokerAPos : jokerBPos;
  var secondjoker = jokerAPos < jokerBPos ? jokerBPos : jokerAPos;

  var newDeck = <int>[];
  var positionFrom = secondjoker + 1;
  var count = (deckSize - 1) - secondjoker;
  newDeck = _copyToDeck(deck, newDeck, positionFrom, count);

  positionFrom = firstjoker;
  count = secondjoker - firstjoker + 1;
  newDeck = _copyToDeck(deck, newDeck, positionFrom, count);

  positionFrom = 0;
  count = firstjoker;
  deck = _copyToDeck(deck, newDeck, positionFrom, count);

  // Step 4 (position -> value from last card)
  return _takeOff(deck, deck[deckSize - 1]);
}

// Step 4 (take off and leave the bottom card on the bottom)
List<int> _takeOff(List<int> deck, int liftOffPosition) {
  var deckSize = deck.length;
  var newDeck = <int>[];
  var positionFrom = liftOffPosition;
  if (positionFrom == _JOKER_B) positionFrom = _JOKER_A;
  var count = (deckSize - 1) - positionFrom;

  newDeck = _copyToDeck(deck, newDeck, positionFrom, count);
  count = positionFrom;
  positionFrom = 0;
  newDeck = _copyToDeck(deck, newDeck, positionFrom, count);

  // set last card
  newDeck = _copyToDeck(deck, newDeck, deckSize - 1, 1);

  return newDeck;
}

List<int> _copyToDeck(List<int> deck, List<int> targetDeck, int positionFrom, int count) {
  for (int i = 0; i < count; i++) targetDeck.add(deck[positionFrom + i]);

  return targetDeck;
}

String _solitaireDeckToString(List<int> deck) {
  var output = '';

  output = deck.map((entry) => entry.toString() + ", ").join();

  return output.replaceFirst(', ', '', output.length - 2);
}
