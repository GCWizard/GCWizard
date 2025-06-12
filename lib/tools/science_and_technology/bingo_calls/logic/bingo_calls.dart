import 'dart:core';
import 'dart:ui';

class BingoCall {
  final int number;
  final List<String> title;
  final String description;

  const BingoCall({
    required this.number,
    required this.title,
    required this.description,
  });
}

enum BINGOCALLS_LANGUAGES { DE, EN }

const Map<BINGOCALLS_LANGUAGES, String> BINGOCALLS_LANGUAGE_LIST = {
  //BINGOCALLS_LANGUAGES.DE: "common_language_german",
  BINGOCALLS_LANGUAGES.EN: "common_language_english",
};

final Map<Locale, BINGOCALLS_LANGUAGES> SUPPORTED_SPELLING_LOCALES = {
  //const Locale('de'): BINGOCALLS_LANGUAGES.DE,
  const Locale('en'): BINGOCALLS_LANGUAGES.EN,
};

const Map<BINGOCALLS_LANGUAGES, Map<String, BingoCall>> BINGO_CALLS = {
  //BINGOCALLS_LANGUAGES.DE: BINGO_CALLS_DE,
  BINGOCALLS_LANGUAGES.EN: BINGO_CALLS_EN,
};

// TMZ (6/2025): for the time beeing there exists only an english version
// if there exists Bingo calls in other languages the following maps should be enhanced:
// - BINGOCALLS_LANGUAGE_LIST
// - SUPPORTED_SPELLING_LOCALES
// - BINGO_CALLS
/*
const Map<String, BingoCall> BINGO_CALLS_DE = {
  // https://gamblingngo.com/de/guides/bingo-calls/
  '1': BingoCall(
    number: 1,
    title: ['Kellys Auge'],
    description: 'ein militärischer Slang oder eine Anspielung auf einen australischen Volkshelden, Ned Kelly',
  ),
  '2': BingoCall(
    number: 2,
    title: ['Eine kleine Ente'],
    description: '2 sieht aus wie eine kleine Ente, daher der Spitzname',
  ),
  '3': BingoCall(
    number: 3,
    title: ['Tasse Tee'],
    description: 'drei Reime mit Tee, und die Briten lieben ihre Tasse Tee',
  ),
  '4': BingoCall(
    number: 4,
    title: ['Klopfe an die tür'],
    description: 'vier, an die Tür klopfen, ein weiterer Reim',
  ),
  '5': BingoCall(
    number: 5,
    title: ['Man Alive'],
    description: 'fünf Reime mit lebendig',
  ),
  '6': BingoCall(
    number: 6,
    title: ['Tom Mix', 'Halbes Dutzend'],
    description: 'ein Verweis auf einen US-Westernfilmstar Tom Mix, der sich auf sechs reimt; Ein halbes Dutzend ist sechs',
  ),
  '7': BingoCall(
    number: 7,
    title: ['Glückliche sieben'],
    description: 'Sieben gilt in vielen Kulturen als Glückszahl, natürlich auch im Bingo',
  ),
  '8': BingoCall(
    number: 8,
    title: ['Garden Gate'],
    description: 'gate reimt sich auf acht, aber es gibt eine Legende von einem Gartentor, das eine verschlüsselte Nachricht ist',
  ),
  '9': BingoCall(
    number: 9,
    title: ['Arztbefehle '],
    description: 'ein Hinweis auf die Abführpille Nummer 9, die Soldaten während des Zweiten Weltkriegs gegeben wurde',
  ),
  '10': BingoCall(
    number: 10,
    title: ['Boris Höhle'],
    description: 'eine Referenz von 10 Downing Street, der Residenz des Premierministers (der Spitzname ändert sich mit jedem neuen Premierminister)',
  ),
  '11': BingoCall(
    number: 11,
    title: ['Beine 11 '],
    description: '11 sieht aus wie ein Paar schlanke Beine, am liebsten eine Frau mit Absätzen',
  ),
  '12': BingoCall(
    number: 12,
    title: ['Ein Dutzend'],
    description: 'Ein Dutzend ist 12',
  ),
  '13': BingoCall(
    number: 13,
    title: ['Pech für manche'],
    description: '13 gilt als Unglückszahl, aber nur für manche, wie der Bingo-Spruch schon sagt',
  ),
  '14': BingoCall(
    number: 14,
    title: ['Valentinstag '],
    description: 'ein Hinweis auf den 14. Februar, den Tag der Liebe und Romantik',
  ),
  '15': BingoCall(
    number: 15,
    title: ['Jung und scharf '],
    description: 'fünfzehn Reime mit scharf',
  ),
  '16': BingoCall(
    number: 16,
    title: ['süß 16'],
    description: 'ein Hinweis auf die Sweet 16, wenn sich eine Person in einen Erwachsenen verwandelt',
  ),
  '17': BingoCall(
    number: 17,
    title: ['Dancing Queen'],
    description: 'bezieht sich auf ABBAs Dancing Queen, „…young and sweet, only seventeen.“',
  ),
  '18': BingoCall(
    number: 18,
    title: ['Coming of Age'],
    description: 'das Alter, in dem man rechtlich erwachsen wird',
  ),
  '19': BingoCall(
    number: 19,
    title: ['Auf Wiedersehen Teenager '],
    description: 'das letzte Teenagerjahr',
  ),
  '20': BingoCall(
    number: 20,
    title: ['Ein Ergebnis', 'viel bekommen'],
    description: '20 Einheiten in einer Partitur / mit zwanzig viele Reime bekommen',
  ),
  '21': BingoCall(
    number: 21,
    title: ['Königsblau Gesundheit'],
    description: 'ein Hinweis auf den königlichen Gruß von 21 Kanonen',
  ),
  '22': BingoCall(
    number: 22,
    title: ['Zwei kleine Enten'],
    description: '22 sieht aus wie zwei kleine Enten nebeneinander',
  ),
  '23': BingoCall(
    number: 23,
    title: ['Der Herr ist mein Hirte'],
    description: 'ein Hinweis auf den ersten Vers von Psalm 23 des Alten Testaments',
  ),
  '24': BingoCall(
    number: 24,
    title: ['Zwei Dutzend'],
    description: '12 ist ein Dutzend, 24 ist zwei Dutzend',
  ),
  '25': BingoCall(
    number: 25,
    title: ['Ente und Tauche'],
    description: '2 ist eine Ente, fünf Reime mit Tauchen',
  ),
  '26': BingoCall(
    number: 26,
    title: ['A bis Z', 'halbe Krone'],
    description: 'das Alphabet hat 26 Buchstaben; zwei Schilling und sechs Pence (26) machten eine halbe Krone',
  ),
  '27': BingoCall(
    number: 27,
    title: ['Tor zum Himmel'],
    description: 'ein Hinweis darauf, einen Gewinn auf der Nummer 27 zu nennen',
  ),
  '28': BingoCall(
    number: 28,
    title: ['Übergewicht', 'in einem Zustand'],
    description: 'ein Hinweis auf jemanden, der sich in einem Zustand befindet, sich schlecht fühlt, übergewichtig ist',
  ),
  '29': BingoCall(
    number: 29,
    title: ['Rise and Shine'],
    description: 'Rise and Shine reimt sich auf neunundzwanzig',
  ),
  '30': BingoCall(
    number: 30,
    title: ['Schmutzige Gertie'],
    description: 'ein Reim auf ein humorvolles Soldatenlied aus den 1920er Jahren „Dirty Gertie from Bizerte“',
  ),
  '31': BingoCall(
    number: 31,
    title: ['Steh auf und lauf'],
    description: 'der Ausdruck reimt sich auf die Zahl einunddreißig',
  ),
  '32': BingoCall(
    number: 32,
    title: ['Schnalle meinen Schuh'],
    description: 'der Ausdruck reimt sich auf die Zahl zweiunddreißig',
  ),
  '33': BingoCall(
    number: 33,
    title: ['Alle drei'],
    description: '33 sind alle Dreien in einem 90-Ball-Bingo',
  ),
  '34': BingoCall(
    number: 34,
    title: ['Frage nach mehr'],
    description: 'der Ausdruck reimt sich auf vierunddreißig',
  ),
  '35': BingoCall(
    number: 35,
    title: ['Springen und Jive'],
    description: 'ein Reim mit der Zahl fünfunddreißig',
  ),
  '36': BingoCall(
    number: 36,
    title: ['Drei Dutzend'],
    description: '12 ist ein Dutzend, 36 ist drei Dutzend',
  ),
  '37': BingoCall(
    number: 37,
    title: ['Mehr als 11'],
    description: 'ein Satz, der sich auf siebenunddreißig reimt',
  ),
  '38': BingoCall(
    number: 38,
    title: ['Christmas Cake'],
    description: 'ein Satz, der sich auf achtunddreißig reimt',
  ),
  '39': BingoCall(
    number: 39,
    title: ['39 Schritte'],
    description: 'eine Anspielung auf den berühmten Alfred-Hitchcock-Film „Die 39 Stufen“',
  ),
  '40': BingoCall(
    number: 40,
    title: ['Freche 40'],
    description: 'eine Anspielung auf den Satz „das Leben beginnt mit 40!“',
  ),
  '41': BingoCall(
    number: 41,
    title: ['Zeit für Spaß'],
    description: 'ein Satz, der sich auf einundvierzig reimt',
  ),
  '42': BingoCall(
    number: 42,
    title: ['Winnie the Pooh'],
    description: 'ein Verweis auf das beliebte Märchenbuch über einen honigliebenden Bären',
  ),
  '43': BingoCall(
    number: 43,
    title: ['Auf die Knie'],
    description: 'ein Hinweis auf einen Ausdruck, der von den britischen Soldaten verwendet wurde',
  ),
  '44': BingoCall(
    number: 44,
    title: ['Hängende Schubladen'],
    description: 'ein Hinweis auf schlaffe Hosen',
  ),
  '45': BingoCall(
    number: 45,
    title: ['Auf halbem Wege'],
    description: 'in einem 90-Ball-Bingo-Spiel ist 45 die Hälfte des Ziels',
  ),
  '46': BingoCall(
    number: 46,
    title: ['Bis hin zu Tricks'],
    description: '',
  ),
  '47': BingoCall(
    number: 47,
    title: [''],
    description: '',
  ),
  '48': BingoCall(
    number: 48,
    title: ['Vier Dutzend'],
    description: '12 ist ein Dutzend, 48 ist vier Dutzend',
  ),
  '49': BingoCall(
    number: 49,
    title: [''],
    description: '',
  ),
  '50': BingoCall(
    number: 50,
    title: [''],
    description: '',
  ),
  '51': BingoCall(
    number: 51,
    title: [''],
    description: '',
  ),
  '52': BingoCall(
    number: 52,
    title: [''],
    description: '',
  ),
  '53': BingoCall(
    number: 53,
    title: ['Hier kommt Herbie'],
    description: '53 ist die Nummer des VW Käfers Herbie aus den Walt-Disney-Filmen',
  ),
  '54': BingoCall(
    number: 54,
    title: [''],
    description: '',
  ),
  '55': BingoCall(
    number: 55,
    title: ['lebende Schlangen'],
    description: 'eine Anspielung auf die Fünfer, die wie zusammengerollte Schlangen aussehen',
  ),
  '56': BingoCall(
    number: 56,
    title: [''],
    description: '',
  ),
  '57': BingoCall(
    number: 57,
    title: ['Heinz Sorten'],
    description: 'ein Hinweis auf die 57 Sorten Konservenprodukte von Heinz, die Zahl 57 steht auf dem Etikett der Heinz-Produkte',
  ),
  '58': BingoCall(
    number: 58,
    title: [''],
    description: '',
  ),
  '59': BingoCall(
    number: 59,
    title: [''],
    description: '',
  ),
  '60': BingoCall(
    number: 60,
    title: ['Fünf Dutzend', 'Oma wird munter'],
    description: '12 ist ein Dutzend, 60 ist fünf Dutzend; das traditionelle Alter, in dem Frauen im Vereinigten Königreich in Rente gingen',
  ),
  '61': BingoCall(
    number: 61,
    title: [''],
    description: '',
  ),
  '62': BingoCall(
    number: 62,
    title: [''],
    description: '',
  ),
  '63': BingoCall(
    number: 63,
    title: [''],
    description: '',
  ),
  '64': BingoCall(
    number: 64,
    title: [''],
    description: '',
  ),
  '65': BingoCall(
    number: 65,
    title: ['Alterspension '],
    description: 'as traditionelle Alter, in dem Männer im Vereinigten Königreich in Rente gingen',
  ),
  '66': BingoCall(
    number: 66,
    title: [''],
    description: '',
  ),
  '67': BingoCall(
    number: 67,
    title: [''],
    description: '',
  ),
  '68': BingoCall(
    number: 68,
    title: [''],
    description: '',
  ),
  '69': BingoCall(
    number: 69,
    title: [''],
    description: '',
  ),
  '70': BingoCall(
    number: 70,
    title: [''],
    description: '',
  ),
  '71': BingoCall(
    number: 71,
    title: [''],
    description: '',
  ),
  '72': BingoCall(
    number: 72,
    title: ['Sechs Dutzend'],
    description: '12 ist ein Dutzend, 72 ist sechs Dutzend',
  ),
  '73': BingoCall(
    number: 73,
    title: [''],
    description: '',
  ),
  '74': BingoCall(
    number: 74,
    title: [''],
    description: '',
  ),
  '75': BingoCall(
    number: 75,
    title: [''],
    description: '',
  ),
  '76': BingoCall(
    number: 76,
    title: [''],
    description: '',
  ),
  '77': BingoCall(
    number: 77,
    title: ['Sunset Strip'],
    description: 'ein Verweis auf die TV-Serie „77, Sunset Strip“',
  ),
  '78': BingoCall(
    number: 7,
    title: [''],
    description: '',
  ),
  '79': BingoCall(
    number: 79,
    title: [''],
    description: '',
  ),
  '80': BingoCall(
    number: 80,
    title: [''],
    description: '',
  ),
  '81': BingoCall(
    number: 81,
    title: [''],
    description: '',
  ),
  '82': BingoCall(
    number: 82,
    title: [''],
    description: '',
  ),
  '83': BingoCall(
    number: 83,
    title: [''],
    description: '',
  ),
  '84': BingoCall(
    number: 84,
    title: ['Sieben Dutzend'],
    description: '21 ist ein Dutzend, 84 ist sieben Dutzend',
  ),
  '85': BingoCall(
    number: 85,
    title: [''],
    description: '',
  ),
  '86': BingoCall(
    number: 86,
    title: [''],
    description: '',
  ),
  '87': BingoCall(
    number: 87,
    title: [''],
    description: '',
  ),
  '88': BingoCall(
    number: 88,
    title: ['Zwei fette Damen'],
    description: 'die zwei Achten sehen nebeneinander aus wie dicke Damen',
  ),
  '89': BingoCall(
    number: 89,
    title: ['Fast da'],
    description: 'die vorletzte Bingozahl, fast bis zum Ende',
  ),
  '90': BingoCall(
    number: 90,
    title: ['Top of the Shop', 'End of the Line', 'So weit wir gehen'],
    description: 'ein Hinweis auf die höchste oder letzte Zahl im Bingo',
  ),
};

const Map<String, BingoCall> BINGO_CALLS_ = {
  '1': BingoCall(
    number: 1,
    title: [''],
    description: '',
  ),
  '2': BingoCall(
    number: 2,
    title: [''],
    description: '',
  ),
  '3': BingoCall(
    number: 3,
    title: [''],
    description: '',
  ),
  '4': BingoCall(
    number: 4,
    title: [''],
    description: '',
  ),
  '5': BingoCall(
    number: 5,
    title: [''],
    description: '',
  ),
  '6': BingoCall(
    number: 6,
    title: [''],
    description: '',
  ),
  '7': BingoCall(
    number: 7,
    title: [''],
    description: '',
  ),
  '8': BingoCall(
    number: 8,
    title: [''],
    description: '',
  ),
  '9': BingoCall(
    number: 9,
    title: [''],
    description: '',
  ),
  '10': BingoCall(
    number: 10,
    title: [''],
    description: '',
  ),
  '11': BingoCall(
    number: 11,
    title: [''],
    description: '',
  ),
  '12': BingoCall(
    number: 12,
    title: [''],
    description: '',
  ),
  '13': BingoCall(
    number: 13,
    title: [''],
    description: '',
  ),
  '14': BingoCall(
    number: 14,
    title: [''],
    description: '',
  ),
  '15': BingoCall(
    number: 15,
    title: [''],
    description: '',
  ),
  '16': BingoCall(
    number: 16,
    title: [''],
    description: '',
  ),
  '17': BingoCall(
    number: 17,
    title: [''],
    description: '',
  ),
  '18': BingoCall(
    number: 18,
    title: [''],
    description: '',
  ),
  '19': BingoCall(
    number: 19,
    title: [''],
    description: '',
  ),
  '20': BingoCall(
    number: 20,
    title: [''],
    description: '',
  ),
  '21': BingoCall(
    number: 21,
    title: [''],
    description: '',
  ),
  '22': BingoCall(
    number: 22,
    title: [''],
    description: '',
  ),
  '23': BingoCall(
    number: 23,
    title: [''],
    description: '',
  ),
  '24': BingoCall(
    number: 24,
    title: [''],
    description: '',
  ),
  '25': BingoCall(
    number: 25,
    title: [''],
    description: '',
  ),
  '26': BingoCall(
    number: 26,
    title: [''],
    description: '',
  ),
  '27': BingoCall(
    number: 27,
    title: [''],
    description: '',
  ),
  '28': BingoCall(
    number: 28,
    title: [''],
    description: '',
  ),
  '29': BingoCall(
    number: 29,
    title: [''],
    description: '',
  ),
  '30': BingoCall(
    number: 30,
    title: [''],
    description: '',
  ),
  '31': BingoCall(
    number: 31,
    title: [''],
    description: '',
  ),
  '32': BingoCall(
    number: 32,
    title: [''],
    description: '',
  ),
  '33': BingoCall(
    number: 33,
    title: [''],
    description: '',
  ),
  '34': BingoCall(
    number: 34,
    title: [''],
    description: '',
  ),
  '35': BingoCall(
    number: 35,
    title: [''],
    description: '',
  ),
  '36': BingoCall(
    number: 36,
    title: [''],
    description: '',
  ),
  '37': BingoCall(
    number: 37,
    title: [''],
    description: '',
  ),
  '38': BingoCall(
    number: 38,
    title: [''],
    description: '',
  ),
  '39': BingoCall(
    number: 39,
    title: [''],
    description: '',
  ),
  '40': BingoCall(
    number: 40,
    title: [''],
    description: '',
  ),
  '41': BingoCall(
    number: 41,
    title: [''],
    description: '',
  ),
  '42': BingoCall(
    number: 42,
    title: [''],
    description: '',
  ),
  '43': BingoCall(
    number: 43,
    title: [''],
    description: '',
  ),
  '44': BingoCall(
    number: 44,
    title: [''],
    description: '',
  ),
  '45': BingoCall(
    number: 45,
    title: [''],
    description: '',
  ),
  '46': BingoCall(
    number: 46,
    title: [''],
    description: '',
  ),
  '47': BingoCall(
    number: 47,
    title: [''],
    description: '',
  ),
  '48': BingoCall(
    number: 48,
    title: [''],
    description: '',
  ),
  '49': BingoCall(
    number: 49,
    title: [''],
    description: '',
  ),
  '50': BingoCall(
    number: 50,
    title: [''],
    description: '',
  ),
  '51': BingoCall(
    number: 51,
    title: [''],
    description: '',
  ),
  '52': BingoCall(
    number: 52,
    title: [''],
    description: '',
  ),
  '53': BingoCall(
    number: 53,
    title: [''],
    description: '',
  ),
  '54': BingoCall(
    number: 54,
    title: [''],
    description: '',
  ),
  '55': BingoCall(
    number: 55,
    title: [''],
    description: '',
  ),
  '56': BingoCall(
    number: 56,
    title: [''],
    description: '',
  ),
  '57': BingoCall(
    number: 57,
    title: [''],
    description: '',
  ),
  '58': BingoCall(
    number: 58,
    title: [''],
    description: '',
  ),
  '59': BingoCall(
    number: 59,
    title: [''],
    description: '',
  ),
  '60': BingoCall(
    number: 60,
    title: [''],
    description: '',
  ),
  '61': BingoCall(
    number: 61,
    title: [''],
    description: '',
  ),
  '62': BingoCall(
    number: 62,
    title: [''],
    description: '',
  ),
  '63': BingoCall(
    number: 63,
    title: [''],
    description: '',
  ),
  '64': BingoCall(
    number: 64,
    title: [''],
    description: '',
  ),
  '65': BingoCall(
    number: 65,
    title: [''],
    description: '',
  ),
  '66': BingoCall(
    number: 66,
    title: [''],
    description: '',
  ),
  '67': BingoCall(
    number: 67,
    title: [''],
    description: '',
  ),
  '68': BingoCall(
    number: 68,
    title: [''],
    description: '',
  ),
  '69': BingoCall(
    number: 69,
    title: [''],
    description: '',
  ),
  '70': BingoCall(
    number: 70,
    title: [''],
    description: '',
  ),
  '71': BingoCall(
    number: 71,
    title: [''],
    description: '',
  ),
  '72': BingoCall(
    number: 72,
    title: [''],
    description: '',
  ),
  '73': BingoCall(
    number: 73,
    title: [''],
    description: '',
  ),
  '74': BingoCall(
    number: 74,
    title: [''],
    description: '',
  ),
  '75': BingoCall(
    number: 75,
    title: [''],
    description: '',
  ),
  '76': BingoCall(
    number: 76,
    title: [''],
    description: '',
  ),
  '77': BingoCall(
    number: 77,
    title: [''],
    description: '',
  ),
  '78': BingoCall(
    number: 7,
    title: [''],
    description: '',
  ),
  '79': BingoCall(
    number: 79,
    title: [''],
    description: '',
  ),
  '80': BingoCall(
    number: 80,
    title: [''],
    description: '',
  ),
  '81': BingoCall(
    number: 81,
    title: [''],
    description: '',
  ),
  '82': BingoCall(
    number: 82,
    title: [''],
    description: '',
  ),
  '83': BingoCall(
    number: 83,
    title: [''],
    description: '',
  ),
  '84': BingoCall(
    number: 84,
    title: [''],
    description: '',
  ),
  '85': BingoCall(
    number: 85,
    title: [''],
    description: '',
  ),
  '86': BingoCall(
    number: 86,
    title: [''],
    description: '',
  ),
  '87': BingoCall(
    number: 87,
    title: [''],
    description: '',
  ),
  '88': BingoCall(
    number: 88,
    title: [''],
    description: '',
  ),
  '89': BingoCall(
    number: 89,
    title: [''],
    description: '',
  ),
  '90': BingoCall(
    number: 90,
    title: [''],
    description: '',
  ),
};
*/

const Map<String, BingoCall> BINGO_CALLS_EN = {
  // https://blog.meccabingo.com/bingo-calls-complete-list/
  '1': BingoCall(
      number: 1,
      title: ['Kelly’s eye'],
      description:
          'This bingo saying could be a reference to Ned Kelly, one of Australia’s greatest folk heroes – but many think it’s just military slang.'),
  '2': BingoCall(
    number: 2,
    title: ['One little duck'],
    description: 'The number 2 looks just like a little duckling!',
  ),
  '3': BingoCall(
    number: 3,
    title: ['Cup of tea'],
    description:
        'Because the British are particularly fond of tea and purely because it rhymes. Put the kettle on then!',
  ),
  '4': BingoCall(
    number: 4,
    title: ['Knock at the door'],
    description: 'Who’s there?! This phrase rhymes with the number 4.',
  ),
  '5': BingoCall(
    number: 5,
    title: ['Man alive'],
    description: 'Another great bingo calling sheet rhyme.',
  ),
  '6': BingoCall(
    number: 6,
    title: ['Tom Mix', 'Half a dozen'],
    description:
        'Tom Mix was America’s first Western Star, appearing in 291 films. His legend lives on in this rhyming bingo call. A dozen is 12 and half of 12 is 6, which is the alternative bingo saying the caller could choose.',
  ),
  '7': BingoCall(
    number: 7,
    title: ['Lucky seven'],
    description:
        'The number 7 is considered lucky in many cultures. There are 7 days of the week, 7 colours of the rainbow and 7 notes on a musical scale.',
  ),
  '8': BingoCall(
    number: 8,
    title: ['Garden gate'],
    description:
        'This saying rhymes with the number 8, but there’s said to be something more about the history of this call. Legend has it that the ‘garden gate’ was a code for a secret meeting or drop off point.',
  ),
  '9': BingoCall(
    number: 9,
    title: ['Doctor’s orders'],
    description:
        'During World War II, Number 9 was the name of a pill given out by army doctors to solidiers who were a little bit poorly. This powerful laxative was said to clear the system of all ills!',
  ),
  '10': BingoCall(
    number: 10,
    title: ['<Prime Minister’s name>’s den'],
    description: 'Always up to date, bingo callers will insert the name of the current Prime Minister into this call. It references number 10 Downing Street.',
  ),
  '11': BingoCall(
    number: 11,
    title: ['Legs eleven'],
    description: 'One of the many calls that relates to the shape that the number makes. The two 1s look like a pair of slender legs. Whit woo!',
  ),
  '12': BingoCall(
    number: 12,
    title: ['One dozen'],
    description: '12 makes up a dozen.',
  ),
  '13': BingoCall(
    number: 13,
    title: ['Unlucky for some'],
    description: 'Many superstitious people believe that 13 is an unlucky number – but if you call house on 13, it’s lucky for you!',
  ),
  '14': BingoCall(
    number: 14,
    title: ['Valentine’s Day'],
    description: 'Referring to 14th February, the international day of romance.',
  ),
  '15': BingoCall(
    number: 15,
    title: ['Young and keen'],
    description: '15 rhymes with keen.',
  ),
  '16': BingoCall(
    number: 16,
    title: ['Sweet 16 and never been kissed'],
    description: 'Turning 16 marks a special birthday. You’re not quite an adult, but you’re no longer a child.',
  ),
  '17': BingoCall(
    number: 17,
    title: ['Dancing queen'],
    description: '“You are the dancing queen, young and sweet, only seventeen!” We can thank ABBA and their 1976 hit single ‘Dancing Queen’ for this bingo call.',
  ),
  '18': BingoCall(
    number: 18,
    title: ['Coming of age'],
    description: 'This milestone denotes when you’re officially an adult. Some callers also shout: “Now you can vote!”',
  ),
  '19': BingoCall(
    number: 19,
    title: ['Goodbye teens'],
    description: 'The last teenage year!',
  ),
  '20': BingoCall(
    number: 20,
    title: ['One score', 'Getting Plenty'],
    description: 'There are 20 units in a score. The phrase ‘getting plenty’ is also a cheeky rhyme with the number.',
  ),
  '21': BingoCall(
    number: 21,
    title: ['Royal salute', 'Key of the door'],
    description: 'There are 21 guns fired in a royal or military salute. 21 was also the traditional age where you’d move out of your parents’ house and have your own keys to your own place.',
  ),
  '22': BingoCall(
    number: 22,
    title: ['Two little ducks'],
    description: 'Again, this call exists to describe the shape that the numbers make.',
  ),
  '23': BingoCall(
    number: 23,
    title: ['The Lord is my shepherd'],
    description: 'A biblical reference, this is the first phrase of Psalm 23 in the Old Testament.',
  ),
  '24': BingoCall(
    number: 24,
    title: ['Two dozen'],
    description: '12 is one dozen and 24 makes two dozen.',
  ),
  '25': BingoCall(
    number: 25,
    title: ['Duck and dive'],
    description: 'Another call that rhymes but it’s also said that the number 2 is the duck and you want to dive away from the number 5 which looks like a snake! One of the stranger bingo terms, that’s for sure.',
  ),
  '26': BingoCall(
    number: 26,
    title: ['Half a crown'],
    description: 'This saying comes from predecimalization (old money), where two shillings and sixpence made up half a crown.',
  ),
  '27': BingoCall(
    number: 27,
    title: ['Gateway to heaven'],
    description: 'You will be in heaven if you call house on this bingo rhyming slang!',
  ),
  '28': BingoCall(
    number: 28,
    title: ['In a state'],
    description: 'Cockney rhyming slang. “He was in a right two and eight” means “He was in a poor state!”',
  ),
  '29': BingoCall(
    number: 29,
    title: ['Rise and shine'],
    description: 'The numbers rhyme with this cheery saying.',
  ),
  '30': BingoCall(
    number: 30,
    title: ['Dirty Gertie'],
    description: 'Rhyming with 30, this phrase comes from the nickname for the statue La Délivrance, a bronze sculpture of a naked lady installed in North London in 1927. There was also a raucous song called Dirty Gertie from Bizerte, which was sung by Allied soldiers in North Africa during the Second World War.',
  ),
  '31': BingoCall(
    number: 31,
    title: ['Get up and run'],
    description: 'Get up and run when you hear this rhyming call for 31.',
  ),
  '32': BingoCall(
    number: 32,
    title: ['Buckle my shoe'],
    description: 'The phrase rhymes with the numbers.',
  ),
  '33': BingoCall(
    number: 33,
    title: ['All the threes', 'Fish, chips and peas'],
    description: '33 represents all the 3s available in a 90 ball game. It also rhymes with the traditional English fish supper from the chippy. Yum!',
  ),
  '34': BingoCall(
    number: 34,
    title: ['Ask for more'],
    description: 'A great rhyme, especially following 33!',
  ),
  '35': BingoCall(
    number: 35,
    title: ['Jump and jive'],
    description: 'You’ll be doing this dance step if you call house on number 35.',
  ),
  '36': BingoCall(
    number: 36,
    title: ['Three dozen'],
    description: 'Plain and simple, 3 lots of 12.',
  ),
  '37': BingoCall(
    number: 37,
    title: ['More than eleven'],
    description: 'Lots of numbers are more than 11, but this one kind of rhymes!',
  ),
  '38': BingoCall(
    number: 38,
    title: ['Christmas cake'],
    description: 'Another term derived from cockney rhyming slang.',
  ),
  '39': BingoCall(
    number: 39,
    title: ['39 steps'],
    description: 'From the 1935 Alfred Hitchcock movie called 39 Steps.',
  ),
  '40': BingoCall(
    number: 40,
    title: ['Life begins'],
    description: 'Life begins at 40! Who are we to disagree with this well-known bingo call?!',
  ),
  '41': BingoCall(
    number: 41,
    title: ['Time for fun'],
    description: 'Life has begun so it’s time for some fun!',
  ),
  '42': BingoCall(
    number: 42,
    title: ['Winnie the Pooh'],
    description: 'Winnie the Pooh books by A. A. Milne were first published in 1926. The honey-loving bear became part of the Walt Disney family in 1965.',
  ),
  '43': BingoCall(
    number: 43,
    title: ['Down on your knees'],
    description: 'Harking back to war-time Britain, this phrase was often used by soldiers during the war.',
  ),
  '44': BingoCall(
    number: 44,
    title: ['Droopy drawers'],
    description: 'Said to be a visual reference to sagging trousers!',
  ),
  '45': BingoCall(
    number: 45,
    title: ['Halfway there'],
    description: 'There are 90 balls in traditional British bingo [www.meccabingo.com] games and 45 is half of 90.',
  ),
  '46': BingoCall(
    number: 46,
    title: ['Up to tricks'],
    description: 'This phrase rhymes with the number 46.',
  ),
  '47': BingoCall(
    number: 47,
    title: ['Four and seven'],
    description: 'Not particularly inspiring, but does what it says on the tin. Can you think of a better one?',
  ),
  '48': BingoCall(
    number: 48,
    title: ['Four dozen'],
    description: '4 x 12 = 48',
  ),
  '49': BingoCall(
    number: 49,
    title: ['PC'],
    description: 'This call is based on the old TV programme ‘The Adventures of P.C. 49,’ which aired from 1946–53. The show told the stories of an unconventional police constable solving cases in London.',
  ),
  '50': BingoCall(
    number: 50,
    title: ['Half a century'],
    description: 'A full century is 100 and 50 is half of that.',
  ),
  '51': BingoCall(
    number: 51,
    title: ['Tweak of the thumb'],
    description: 'A quirky call that rhymes. Could also be replaced with “I love my mum.”',
  ),
  '52': BingoCall(
    number: 52,
    title: ['Danny La Rue'],
    description: 'Another great rhyme that references the Irish cross-dressing singer and entertainer who rose to fame in the mid ‘40s.',
  ),
  '53': BingoCall(
    number: 53,
    title: ['Here comes Herbie'],
    description: '53 is the number of the VW Beetle Herbie, the car featured in a number of films by Walt Disney in the 1960s. Players often respond with “Beep, beep!”',
  ),
  '54': BingoCall(
    number: 54,
    title: ['Clean the floor'],
    description: 'Nobody wants to think about housework while they’re playing bingo, but this rhyme has been around for years.',
  ),
  '55': BingoCall(
    number: 55,
    title: ['Snakes alive'],
    description: 'Another visual bingo call. The two fives look like snakes ready to spring.',
  ),
  '56': BingoCall(
    number: 56,
    title: ['Shotts Bus', 'Was she worth it?'],
    description: 'The original number of the bus route from Glasgow to Shotts. Five shillings and sixpence was how much a marriage licence used to cost. When the caller asked: “Was she worth it?” many players would shout back “Every penny!”',
  ),
  '57': BingoCall(
    number: 57,
    title: ['Heinz varieties'],
    description: 'Referring to the number in the logo of food company Heinz. The number 57 was reportedly picked by the founder as he wanted to claim he offered the greatest selection of pickles. Five was his lucky number and 7 was his wife’s.',
  ),
  '58': BingoCall(
    number: 58,
    title: ['Make them wait'],
    description: 'This is another rhyming call. Players often respond with “Choo choo, Thomas!”',
  ),
  '59': BingoCall(
    number: 59,
    title: ['Brighton Line'],
    description: 'There are mixed ideas on where this comes from. Some think that it’s the number of the train from Brighton to London, engine 59 – and others say that all original telephone numbers in Brighton started with 59.',
  ),
  '60': BingoCall(
    number: 60,
    title: ['Five dozen', 'Grandma’s getting frisky'],
    description: 'Our favourite reference is back again! 5 x 12 = 60. 60 almost rhymes with frisky and is the traditional age that women could retire and draw a state pension.',
  ),
  '61': BingoCall(
    number: 61,
    title: ['Baker’s bun'],
    description: 'This bingo call rhymes with the number.',
  ),
  '62': BingoCall(
    number: 62,
    title: ['Turn the screw', 'Tickety-boo'],
    description: 'Both these phrases rhyme with the number. Tickety-boo is slang for ‘good’ or ‘going well’.',
  ),
  '63': BingoCall(
    number: 63,
    title: ['Tickle me'],
    description: 'Another cheeky phrase that rhymes, but its origins are unclear.',
  ),
  '64': BingoCall(
    number: 64,
    title: ['Red raw'],
    description: 'Not the closest rhyme to the number 64 but this bingo call seems to have stood the test of time.',
  ),
  '65': BingoCall(
    number: 65,
    title: ['Old age pension'],
    description: 'The traditional age that men could retire in the UK.',
  ),
  '66': BingoCall(
    number: 66,
    title: ['Clickety click'],
    description: 'This great sounding rhyme sounds like a train steaming down a track.',
  ),
  '67': BingoCall(
    number: 67,
    title: ['Stairway to heaven'],
    description: 'Another whimsical rhyming bingo call.',
  ),
  '68': BingoCall(
    number: 68,
    title: ['Pick a mate'],
    description: 'Bingo is better with friends! Pick a mate and look out for this rhyming call.',
  ),
  '69': BingoCall(
    number: 69,
    title: ['Any way up'],
    description: 'This call explains how the number 69 looks the same upside down.',
  ),
  '70': BingoCall(
    number: 70,
    title: ['Three score and ten'],
    description: 'More maths! 3 x 2 = 60, plus 10 = 70!',
  ),
  '71': BingoCall(
    number: 71,
    title: ['Bang on the drum'],
    description: 'In the early 2000s, a campaign called to change this traditional call to ‘J.Lo’s bum’. What do you make of that?',
  ),
  '72': BingoCall(
    number: 72,
    title: ['Six dozen'],
    description: 'Another reference using that famous dozen metric.',
  ),
  '73': BingoCall(
    number: 73,
    title: ['Queen bee'],
    description: 'We’re buzzing about this bingo call that rhymes.',
  ),
  '74': BingoCall(
    number: 74,
    title: ['Hit the floor'],
    description: 'A call that rhymes. Makes us want to hit the dance floor, too!',
  ),
  '75': BingoCall(
    number: 75,
    title: ['Strive and strive'],
    description: 'We’re striving for a full house. Hope it lands when this call is shouted.',
  ),
  '76': BingoCall(
    number: 76,
    title: ['Trombones'],
    description: 'This pop-culture bingo call references the lyrics in the popular marching song ‘76 Trombones’ from the musical, The Music Man.',
  ),
  '77': BingoCall(
    number: 77,
    title: ['Sunset strip'],
    description: 'So called because of the popular 1950s/60s private investigator TV show, 77 Sunset Strip.',
  ),
  '78': BingoCall(
    number: 78,
    title: ['39 more steps'],
    description: 'This references the 39 Steps film again, as 39 + 39 = 78',
  ),
  '79': BingoCall(
    number: 79,
    title: ['One more time'],
    description: 'Nothing to do with Britney Spears, just another call that rhymes!',
  ),
  '80': BingoCall(
    number: 80,
    title: ['Ghandi’s breakfast'],
    description: 'Because he is said to have ate nothing… eight nothing… geddit?!',
  ),
  '81': BingoCall(
    number: 81,
    title: ['Stop and run'],
    description: 'A bit of a confusing bingo rhyme…how can you stop and run and the same time?',
  ),
  '82': BingoCall(
    number: 82,
    title: ['Straight on through'],
    description: 'Another lovely rhyme that’s been around since bingo began.',
  ),
  '83': BingoCall(
    number: 83,
    title: ['Time for tea'],
    description: 'Another reference to the UK’s favourite beverage. Two quintessentially British pastimes; bingo and brews!',
  ),
  '84': BingoCall(
    number: 84,
    title: ['Seven dozen'],
    description: 'The last of our dozen references! 7 x 12 = 84.',
  ),
  '85': BingoCall(
    number: 85,
    title: ['Staying alive'],
    description: 'This bingo call was around well before the Bee Gees, but we like it and it rhymes!',
  ),
  '86': BingoCall(
    number: 86,
    title: ['Between the sticks'],
    description: 'Not only does this rhyme, but it is said to refer to the number 86 being the position of goalkeepers, who would spend the match ‘between the sticks’ or goalposts.',
  ),
  '87': BingoCall(
    number: 87,
    title: ['Torquay in Devon'],
    description: 'It rhymes and also provides a geography lesson!',
  ),
  '88': BingoCall(
    number: 88,
    title: ['Two fat ladies'],
    description: 'A visual representation… the number 88 is said to look like two fat ladies sitting next to each other.',
  ),
  '89': BingoCall(
    number: 89,
    title: ['Nearly there'],
    description: 'A reference to 89 being 1 away from 90 – the end of the bingo numbers.',
  ),
  '90': BingoCall(
    number: 90,
    title: ['Top of the shop', 'end of the line', 'as far as we go'],
    description: 'All the calls that go with the number 90 in bingo reference it being the highest or last number.',
  ),
};



