// https://coord.info/GC4ZE0V
// http://karel.sourceforge.net/
// https://de.wikipedia.org/wiki/Robot_Karol
// https://www.mebis.bayern.de/infoportal/faecher/mint/inf/robot-karol/
// https://www.cs.mtsu.edu/~untch/karel/
// https://en.wikipedia.org/wiki/Karel_(programming_language)

const KAREL_ENCODING = {
  ' ': 'linksdrehen schritt(7) rechtsdrehen',
  'A':
      'schritt(3) markesetzen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen rechtsdrehen rechtsdrehen schritt(3) rechtsdrehen schritt markesetzen linksdrehen schritt schritt markesetzen rechtsdrehen schritt linksdrehen schritt markesetzen rechtsdrehen schritt rechtsdrehen schritt markesetzen schritt schritt markesetzen rechtsdrehen schritt markesetzen linksdrehen schritt(3) linksdrehen schritt(2) linksdrehen markesetzen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen schritt(3) rechtsdrehen schritt(3) rechtsdrehen',
  'B':
      'schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen linksdrehen schritt markesetzen schritt markesetzen schritt markesetzen schritt linksdrehen schritt markesetzen schritt markesetzen schritt linksdrehen schritt markesetzen schritt markesetzen schritt markesetzen rechtsdrehen schritt rechtsdrehen schritt(3) linksdrehen markesetzen schritt markesetzen schritt linksdrehen schritt markesetzen schritt markesetzen schritt markesetzen rechtsdrehen schritt rechtsdrehen schritt(6) rechtsdrehen',
  'C':
      'schritt(2) linksdrehen schritt(4) markesetzen linksdrehen schritt linksdrehen schritt markesetzen schritt markesetzen schritt markesetzen schritt linksdrehen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen schritt linksdrehen schritt markesetzen schritt markesetzen schritt markesetzen schritt linksdrehen schritt markesetzen schritt(6) rechtsdrehen schritt(3) rechtsdrehen',
  'D':
      'schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen linksdrehen schritt markesetzen schritt markesetzen schritt markesetzen schritt linksdrehen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen schritt linksdrehen schritt markesetzen schritt markesetzen schritt markesetzen rechtsdrehen schritt rechtsdrehen schritt(6) rechtsdrehen',
  'E':
      'schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen linksdrehen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen linksdrehen schritt(3) linksdrehen schritt(2) markesetzen schritt markesetzen rechtsdrehen schritt(3) rechtsdrehen markesetzen schritt markesetzen schritt markesetzen schritt markesetzen schritt(3) linksdrehen schritt linksdrehen linksdrehen',
  'F':
      'schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen linksdrehen schritt linksdrehen schritt(3) rechtsdrehen markesetzen schritt markesetzen linksdrehen schritt(3) linksdrehen schritt linksdrehen linksdrehen markesetzen schritt markesetzen schritt markesetzen schritt markesetzen linksdrehen schritt rechtsdrehen schritt(3) rechtsdrehen',
  'G':
      'schritt(2) markesetzen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen schritt linksdrehen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen linksdrehen schritt markesetzen schritt markesetzen schritt markesetzen linksdrehen schritt markesetzen schritt markesetzen schritt rechtsdrehen schritt(3) rechtsdrehen markesetzen schritt markesetzen schritt markesetzen schritt rechtsdrehen schritt markesetzen linksdrehen schritt(3) linksdrehen schritt(2) linksdrehen linksdrehen',
  'H':
      'schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen rechtsdrehen rechtsdrehen schritt(3) rechtsdrehen schritt markesetzen schritt markesetzen schritt markesetzen  schritt rechtsdrehen markesetzen schritt markesetzen schritt markesetzen schritt markesetzen rechtsdrehen rechtsdrehen schritt(4) markesetzen schritt markesetzen schritt markesetzen schritt rechtsdrehen schritt(3) rechtsdrehen',
  'I':
      'schritt linksdrehen markesetzen schritt rechtsdrehen markesetzen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen rechtsdrehen schritt markesetzen rechtsdrehen rechtsdrehen schritt(2) markesetzen linksdrehen schritt(6) markesetzen schritt(1) rechtsdrehen schritt(3) rechtsdrehen',
  'J':
      'schritt markesetzen linksdrehen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen rechtsdrehen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen schritt rechtsdrehen schritt markesetzen schritt markesetzen schritt markesetzen schritt rechtsdrehen schritt markesetzen schritt markesetzen schritt(5) rechtsdrehen schritt(7) rechtsdrehen',
  'K':
      'schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen linksdrehen schritt(4) markesetzen linksdrehen schritt linksdrehen schritt markesetzen schritt rechtsdrehen schritt markesetzen schritt linksdrehen schritt markesetzen rechtsdrehen schritt rechtsdrehen schritt markesetzen schritt linksdrehen schritt markesetzen schritt rechtsdrehen schritt markesetzen schritt(3) linksdrehen schritt linksdrehen linksdrehen',
  'L':
      'schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen linksdrehen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen schritt(3) linksdrehen schritt(7) linksdrehen linksdrehen',
  'M':
      'schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen linksdrehen schritt linksdrehen schritt(5) markesetzen rechtsdrehen schritt rechtsdrehen schritt markesetzen linksdrehen schritt linksdrehen schritt markesetzen schritt rechtsdrehen schritt markesetzen rechtsdrehen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen linksdrehen schritt(3) linksdrehen schritt(7) linksdrehen linksdrehen',
  'N':
      'schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen rechtsdrehen rechtsdrehen schritt(6) rechtsdrehen schritt rechtsdrehen schritt markesetzen linksdrehen schritt rechtsdrehen schritt markesetzen schritt markesetzen schritt markesetzen linksdrehen schritt rechtsdrehen schritt markesetzen schritt linksdrehen schritt linksdrehen markesetzen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen schritt rechtsdrehen schritt(3) rechtsdrehen',
  'O':
      'schritt(2) markesetzen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen schritt linksdrehen schritt markesetzen schritt markesetzen schritt markesetzen schritt  linksdrehen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen schritt linksdrehen schritt markesetzen schritt markesetzen schritt markesetzen schritt rechtsdrehen schritt rechtsdrehen schritt(7) rechtsdrehen',
  'P':
      'schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen linksdrehen schritt linksdrehen schritt(3) rechtsdrehen markesetzen schritt markesetzen schritt markesetzen schritt linksdrehen schritt markesetzen schritt markesetzen schritt linksdrehen schritt markesetzen schritt markesetzen schritt markesetzen rechtsdrehen schritt rechtsdrehen schritt(6) rechtsdrehen',
  'Q':
      'schritt(2) markesetzen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen schritt linksdrehen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen linksdrehen schritt markesetzen linksdrehen schritt markesetzen schritt rechtsdrehen schritt markesetzen rechtsdrehen schritt(2) markesetzen linksdrehen schritt markesetzen schritt markesetzen schritt markesetzen schritt linksdrehen schritt markesetzen schritt markesetzen schritt markesetzen rechtsdrehen schritt rechtsdrehen schritt(6) rechtsdrehen',
  'R':
      'schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen linksdrehen schritt(4) markesetzen linksdrehen schritt linksdrehen schritt markesetzen schritt rechtsdrehen schritt markesetzen schritt linksdrehen schritt markesetzen rechtsdrehen rechtsdrehen schritt markesetzen schritt markesetzen schritt linksdrehen schritt markesetzen schritt markesetzen schritt linksdrehen schritt markesetzen schritt markesetzen schritt markesetzen rechtsdrehen schritt rechtsdrehen schritt(6) rechtsdrehen',
  'S':
      'schritt(2) linksdrehen schritt(4) markesetzen linksdrehen schritt linksdrehen schritt markesetzen schritt markesetzen schritt markesetzen schritt linksdrehen schritt markesetzen schritt markesetzen schritt linksdrehen schritt markesetzen schritt markesetzen schritt markesetzen schritt rechtsdrehen schritt markesetzen schritt markesetzen schritt rechtsdrehen schritt markesetzen schritt markesetzen schritt markesetzen schritt rechtsdrehen schritt markesetzen schritt(6) rechtsdrehen schritt(7) rechtsdrehen',
  'T':
      'schritt markesetzen linksdrehen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen rechtsdrehen schritt rechtsdrehen schritt(2) linksdrehen markesetzen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen linksdrehen schritt(5) linksdrehen schritt(7) rechtsdrehen rechtsdrehen',
  'U':
      'schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen schritt linksdrehen schritt markesetzen schritt markesetzen schritt markesetzen schritt  linksdrehen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen markesetzen schritt rechtsdrehen schritt(3) rechtsdrehen',
  'V':
      'schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen schritt linksdrehen schritt markesetzen schritt rechtsdrehen schritt markesetzen linksdrehen schritt linksdrehen schritt markesetzen rechtsdrehen schritt linksdrehen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen schritt rechtsdrehen schritt(3) rechtsdrehen',
  'W':
      'schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen schritt linksdrehen schritt markesetzen schritt markesetzen schritt markesetzen schritt linksdrehen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen linksdrehen schritt(2) linksdrehen schritt(4) markesetzen schritt markesetzen linksdrehen schritt(5) linksdrehen schritt(6) rechtsdrehen rechtsdrehen',
  'X':
      'schritt markesetzen schritt markesetzen schritt(4) markesetzen schritt markesetzen linksdrehen schritt linksdrehen schritt(2) markesetzen schritt(2) markesetzen rechtsdrehen schritt rechtsdrehen schritt markesetzen schritt linksdrehen schritt markesetzen linksdrehen schritt(2) markesetzen schritt(2) rechtsdrehen schritt markesetzen rechtsdrehen schritt markesetzen schritt(4) markesetzen schritt markesetzen linksdrehen schritt(3) linksdrehen schritt(7) rechtsdrehen rechtsdrehen',
  'Y':
      'schritt markesetzen schritt markesetzen schritt linksdrehen schritt markesetzen rechtsdrehen schritt markesetzen linksdrehen schritt rechtsdrehen schritt markesetzen schritt markesetzen schritt markesetzen linksdrehen schritt linksdrehen schritt(3) markesetzen schritt markesetzen rechtsdrehen schritt linksdrehen schritt markesetzen schritt markesetzen schritt rechtsdrehen schritt(3) rechtsdrehen',
  'Z':
      'schritt linksdrehen markesetzen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen rechtsdrehen schritt markesetzen schritt rechtsdrehen schritt markesetzen schritt linksdrehen schritt markesetzen schritt rechtsdrehen schritt markesetzen schritt linksdrehen schritt markesetzen schritt markesetzen linksdrehen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen schritt(3) linksdrehen schritt(7) rechtsdrehen rechtsdrehen',
  '0':
      'schritt(2) markesetzen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen schritt linksdrehen schritt markesetzen schritt markesetzen schritt markesetzen schritt linksdrehen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen schritt linksdrehen schritt markesetzen schritt markesetzen schritt markesetzen linksdrehen schritt(4) markesetzen linksdrehen schritt linksdrehen schritt markesetzen rechtsdrehen schritt linksdrehen schritt markesetzen schritt(3) rechtsdrehen schritt(4) rechtsdrehen',
  '1':
      'schritt schritt schritt markesetzen linksdrehen schritt linksdrehen schritt markesetzen rechtsdrehen schritt linksdrehen schritt markesetzen rechtsdrehen rechtsdrehen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen rechtsdrehen rechtsdrehen schritt(7) rechtsdrehen schritt(3) rechtsdrehen',
  '2':
      'schritt schritt schritt markesetzen linksdrehen linksdrehen schritt markesetzen rechtsdrehen schritt linksdrehen schritt markesetzen rechtsdrehen schritt markesetzen schritt markesetzen rechtsdrehen schritt linksdrehen schritt markesetzen rechtsdrehen schritt markesetzen rechtsdrehen schritt linksdrehen schritt markesetzen rechtsdrehen schritt linksdrehen schritt markesetzen rechtsdrehen schritt linksdrehen schritt markesetzen rechtsdrehen schritt linksdrehen schritt markesetzen linksdrehen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen linksdrehen schritt(7) rechtsdrehen schritt(3) rechtsdrehen',
  '3':
      'schritt schritt markesetzen linksdrehen schritt linksdrehen schritt markesetzen rechtsdrehen schritt markesetzen schritt markesetzen schritt rechtsdrehen schritt markesetzen schritt markesetzen schritt rechtsdrehen schritt markesetzen schritt markesetzen rechtsdrehen rechtsdrehen schritt(2) rechtsdrehen schritt markesetzen schritt markesetzen schritt rechtsdrehen schritt markesetzen schritt markesetzen schritt markesetzen schritt rechtsdrehen schritt markesetzen schritt(6) rechtsdrehen schritt(7) rechtsdrehen',
  '4':
      'linksdrehen schritt rechtsdrehen schritt markesetzen schritt markesetzen rechtsdrehen schritt linksdrehen schritt markesetzen schritt markesetzen linksdrehen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen linksdrehen schritt(3) linksdrehen schritt linksdrehen schritt markesetzen schritt markesetzen schritt(2) markesetzen schritt markesetzen schritt markesetzen linksdrehen schritt(4) linksdrehen schritt(7) rechtsdrehen rechtsdrehen',
  '5':
      'linksdrehen schritt(4) rechtsdrehen schritt markesetzen rechtsdrehen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen linksdrehen schritt markesetzen schritt markesetzen schritt markesetzen linksdrehen schritt markesetzen schritt markesetzen schritt markesetzen schritt rechtsdrehen schritt markesetzen schritt markesetzen schritt rechtsdrehen schritt markesetzen schritt markesetzen schritt markesetzen schritt rechtsdrehen schritt markesetzen schritt(6) rechtsdrehen schritt(7) rechtsdrehen',
  '6':
      'linksdrehen schritt(4) rechtsdrehen schritt(2) markesetzen rechtsdrehen schritt rechtsdrehen schritt markesetzen linksdrehen schritt markesetzen schritt markesetzen schritt linksdrehen schritt markesetzen schritt markesetzen schritt markesetzen linksdrehen schritt markesetzen schritt markesetzen schritt markesetzen schritt rechtsdrehen schritt markesetzen schritt markesetzen schritt rechtsdrehen schritt markesetzen schritt markesetzen schritt markesetzen schritt rechtsdrehen schritt markesetzen schritt markesetzen schritt(5) rechtsdrehen schritt(7) rechtsdrehen',
  '7':
      'schritt markesetzen linksdrehen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen rechtsdrehen schritt markesetzen schritt markesetzen rechtsdrehen schritt linksdrehen schritt markesetzen schritt markesetzen rechtsdrehen schritt linksdrehen schritt markesetzen schritt markesetzen linksdrehen schritt(5) linksdrehen schritt(7) rechtsdrehen rechtsdrehen',
  '8':
      'schritt(3) linksdrehen linksdrehen markesetzen schritt markesetzen schritt rechtsdrehen schritt markesetzen schritt markesetzen schritt markesetzen schritt rechtsdrehen schritt markesetzen schritt markesetzen schritt rechtsdrehen schritt markesetzen schritt markesetzen schritt markesetzen schritt linksdrehen schritt markesetzen schritt markesetzen schritt linksdrehen schritt markesetzen schritt markesetzen schritt markesetzen schritt linksdrehen schritt markesetzen schritt markesetzen schritt(5) rechtsdrehen schritt(3) rechtsdrehen',
  '9':
      'schritt(3) markesetzen linksdrehen linksdrehen schritt markesetzen schritt rechtsdrehen schritt markesetzen schritt markesetzen schritt markesetzen schritt rechtsdrehen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen schritt rechtsdrehen schritt markesetzen schritt markesetzen schritt markesetzen schritt rechtsdrehen schritt markesetzen schritt(2) rechtsdrehen schritt markesetzen schritt markesetzen schritt markesetzen linksdrehen schritt(4) rechtsdrehen schritt(4) rechtsdrehen',
  '°':
      'schritt markesetzen schritt markesetzen schritt markesetzen linksdrehen schritt markesetzen schritt markesetzen linksdrehen schritt markesetzen schritt markesetzen linksdrehen schritt markesetzen rechtsdrehen schritt rechtsdrehen schritt(4) rechtsdrehen',
  '.': 'schritt(7) markesetzen linksdrehen schritt(3) linksdrehen schritt(7) rechtsdrehen rechtsdrehen',
  ',':
      'schritt(7) markesetzen linksdrehen schritt linksdrehen schritt markesetzen schritt(6) rechtsdrehen schritt(3) rechtsdrehen'
};

enum KAREL_LANGUAGES { DEU, ENG, FRA }

const Map<KAREL_LANGUAGES, String> KAREL_LANGUAGES_LIST = {
  KAREL_LANGUAGES.DEU: 'common_language_german',
  KAREL_LANGUAGES.ENG: 'common_language_english',
  KAREL_LANGUAGES.FRA: 'common_language_french',
};

// GERMAN
const _AUFHEBEN = 'aufheben';
const _HINLEGEN = 'hinlegen';
const _SCHRITT = 'schritt';
const _MARKESETZEN = 'markesetzen';
const _MARKELOESCHEN = 'markelöschen';
const _LINKSDREHEN = 'linksdrehen';
const _RECHTSDREHEN = 'rechtsdrehen';
const _BEENDEN = 'beenden';
const _TON = 'ton';
const _WARTEN = 'warten';

// ENGLISH
const _MOVE = 'move';
const _TURNLEFT = 'turnleft';
const _TURNRIGHT = 'turnright';
const _PUTBEEPER = 'putbeeper';
const _PICKBEEPER = 'pickbeeper';
const _PUTBRICK = 'putbrick';
const _PICKBRICK = 'pickbrick';
const _TURNOFF = 'turnoff';

//FRENCH
const _RAMASSER = 'ramasser';
const _ALLONGER = 'allonger';
const _ETAPE = 'etape';
const _MARQUEETABLIE = 'marqueetablie';
const _MARQUESUPPRESION = 'marquesuppression';
const _TOURNERGAUCHE = 'tournergauche';
const _TOURNERDROIT = 'tournerdroit';
const _FINIR = 'finir';
const _SON = 'son';
const _ATTENDRE = 'attendre';

const Set<String> _SET_TURNLEFT = {_LINKSDREHEN, _TURNLEFT, _TOURNERGAUCHE};
const Set<String> _SET_TURNRIGHT = {_RECHTSDREHEN, _TURNRIGHT, _TOURNERDROIT};
const Set<String> _SET_MOVE = {_SCHRITT, _MOVE, _ETAPE};
const Set<String> _SET_PICKBRICK = {_AUFHEBEN, _PICKBRICK, _RAMASSER};
const Set<String> _SET_PUTBRICK = {_HINLEGEN, _PUTBRICK, _ALLONGER};
const Set<String> _SET_PICKBEEPER = {_MARKELOESCHEN, _PICKBEEPER, _MARQUESUPPRESION};
const Set<String> _SET_PUTBEEPER = {_MARKESETZEN, _PUTBEEPER, _MARQUEETABLIE};
const Set<String> _SET_HALT = {_BEENDEN, _TURNOFF, _FINIR};
const Set<String> _SET_WAIT = {_WARTEN, _ATTENDRE};
const Set<String> _SET_SOUND = {_TON, _SON};

const _KAROL_COLORS = {
  'weiß': '0',
  'weiss': '0',
  'schwarz': '1',
  'hellrot': '2',
  'hellgelb': '3',
  'hellgrün': '4',
  'hellgruen': '4',
  'hellcyan': '5',
  'hellblau': '6',
  'hellmagenta': '7',
  'rot': '8',
  'gelb': '9',
  'grün': 'A',
  'gruen': 'A',
  'cyan': 'B',
  'blau': 'C',
  'magenta': 'D',
  'dunkelrot': 'E',
  'dunkelgelb': 'F',
  'dunkelgrün': 'G',
  'dunkelgruen': 'G',
  'dunkelcyan': 'H',
  'dunkelblau': 'I',
  'dunkelmagenta': 'J',
  'orange': 'K',
  'hellorange': 'L',
  'dunkelorange': 'M',
  'braun': 'N',
  'dunkelbraun': 'O',
  // ENGLISH
  'white': '0',
  'black': '1',
  'lightred': '2',
  'lightyellow': '3',
  'lightgreen': '4',
  'lightcyan': '5',
  'lightblue': '6',
  'lightmagenta': '7',
  'red': '8',
  'yellow': '9',
  'green': 'A',
  //'cyan': 'B',
  'blue': 'C',
  //'magenta': 'D',
  'darkred': 'E',
  'darkyellow': 'F',
  'darkgren': 'G',
  'darkcyan': 'H',
  'darkblue': 'I',
  'darkmagenta': 'J',
  //'orange': 'K',
  'darkorange': 'L',
  'lightorange': 'M',
  'brown': 'N',
  'darkbrown': 'O',
  // FRENCH
  'blanc': '0',
  'noir': '1',
  'rougeclair': '2',
  'jauneclair': '3',
  'vertclair': '4',
  'cyanclair': '5',
  'bleuclair': '6',
  'magentaclair': '7',
  'rouge': '8',
  'jaune': '9',
  'vert': 'A',
  //'cyan': 'B',
  'bleu': 'C',
  //'magenta': 'D',
  'rougefonce': 'E',
  'jaunefonce': 'F',
  'vertfonce': 'G',
  'cyanfonce': 'H',
  'bleufonce': 'I',
  'magentafonce': 'J',
  //'orange': 'K',
  'orangeclair': 'L',
  'orangefonce': 'M',
  'brun': 'N',
  'brunfonce': 'O',
};

enum _KAROL_DIRECTION { SOUTH, NORTH, EAST, WEST }

String KarolRobotOutputEncode(String output, KAREL_LANGUAGES language) {
  String program = '';
  int lineLength = 0;
  if (output.isEmpty) return '';

  output.trim().toUpperCase().split('\n').forEach((line) {
    line.split('').forEach((char) {
      program = program + (KAREL_ENCODING[char] ?? '') + ' ';
      if (char == '.') {
        lineLength = lineLength + 3;
      } else if (char == 'I' || char == '1' || char == '°') {
        lineLength = lineLength + 5;
      } else {
        lineLength = lineLength + 7;
      }
    });

    program = program +
        _RECHTSDREHEN +
        ' ' +
        _SCHRITT +
        '(' +
        lineLength.toString() +
        ') ' +
        _LINKSDREHEN +
        ' ' +
        _SCHRITT +
        '(9) ';

    lineLength = 0;
  });

  switch (language) {
    case KAREL_LANGUAGES.DEU:
      return program;

    case KAREL_LANGUAGES.ENG:
      program = program
          .replaceAll(_SCHRITT, _MOVE)
          .replaceAll(_LINKSDREHEN, _TURNLEFT)
          .replaceAll(_RECHTSDREHEN, _TURNRIGHT)
          .replaceAll(_MARKESETZEN, _PUTBEEPER);
      //replace move(x) with move ... move x-times
      RegExp expSchritt = RegExp(r'(move)(\(\d+\))?');
      if (expSchritt.hasMatch(program)) {
        program = program.replaceAllMapped(expSchritt, (Match m) {
          var MOVE_LIST = <String>[];
          if (int.tryParse(m.group(0)!.replaceAll(_MOVE, '').replaceAll('(', '').replaceAll(')', '')) != null) {
            for (int i = 0;
                i < int.parse(m.group(0)!.replaceAll(_MOVE, '').replaceAll('(', '').replaceAll(')', ''));
                i++) {
              MOVE_LIST.add('move');
            }
            return MOVE_LIST.join(' ');
          } else {
            return 'move';
          }
        });
      }
      return program;

    case KAREL_LANGUAGES.FRA:
      program = program
          .replaceAll(_SCHRITT, _ETAPE)
          .replaceAll(_LINKSDREHEN, _TOURNERGAUCHE)
          .replaceAll(_RECHTSDREHEN, _TOURNERDROIT)
          .replaceAll(_MARKESETZEN, _MARQUEETABLIE);
      return program;
  }
}

String KarolRobotOutputDecode(String program) {
  if (program.isEmpty) return '';

  int x = 1;
  int y = 1;
  var direction = _KAROL_DIRECTION.SOUTH;
  int maxX = 1;
  int maxY = 1;
  Map<String, String> world = {};
  bool halt = false;

  String? color = '#';
  int count = 0;
  RegExp expSchritt = RegExp(r'(schritt|move|etape)(\(\d+\))?');
  RegExp expHinlegen = RegExp(r'(hinlegen|putbrick|allonger)(\(\d+\))?');
  program
      .toLowerCase()
      .replaceAll('light ', 'light')
      .replaceAll('dark ', 'dark')
      .replaceAll(' clair', 'clair')
      .replaceAll(' fonc', 'fonc')
      .replaceAll('\n', '')
      .split(' ')
      .forEach((element) {
    if (!halt) {
      if (expSchritt.hasMatch(element)) {
        if (int.tryParse(expSchritt
                .firstMatch(element)!
                .group(0)!
                .replaceAll(_SCHRITT, '')
                .replaceAll(_MOVE, '')
                .replaceAll(_ETAPE, '')
                .replaceAll('(', '')
                .replaceAll(')', '')) ==
            null) {
          count = 1;
        } else {
          count = int.parse(expSchritt
              .firstMatch(element)!
              .group(0)!
              .replaceAll(_SCHRITT, '')
              .replaceAll(_MOVE, '')
              .replaceAll(_ETAPE, '')
              .replaceAll('(', '')
              .replaceAll(')', ''));
        }
        switch (direction) {
          case _KAROL_DIRECTION.NORTH:
            y = y - count;
            break;
          case _KAROL_DIRECTION.SOUTH:
            y = y + count;
            break;
          case _KAROL_DIRECTION.WEST:
            x = x - count;
            break;
          case _KAROL_DIRECTION.EAST:
            x = x + count;
            break;
        }
        if (x > maxX) maxX = x;
        if (y > maxY) maxY = y;
      } else {
        if (expHinlegen.hasMatch(element)) {
          color = _KAROL_COLORS[element
              .replaceAll(_HINLEGEN, '')
              .replaceAll(_PUTBRICK, '')
              .replaceAll(_ALLONGER, '')
              .replaceAll('(', '')
              .replaceAll(')', '')];
          color ??= '8';
          switch (direction) {
            case _KAROL_DIRECTION.NORTH:
              world[x.toString() + '|' + (y - 1).toString()] = color!;
              break;
            case _KAROL_DIRECTION.SOUTH:
              world[x.toString() + '|' + (y + 1).toString()] = color!;
              break;
            case _KAROL_DIRECTION.EAST:
              world[(x + 1).toString() + '|' + (y).toString()] = color!;
              break;
            case _KAROL_DIRECTION.WEST:
              world[(x - 1).toString() + '|' + (y).toString()] = color!;
              break;
          }
        } else {
          if (_SET_MOVE.contains(element)) {
            switch (direction) {
              case _KAROL_DIRECTION.NORTH:
                y = y - 1;
                break;
              case _KAROL_DIRECTION.SOUTH:
                y = y + 1;
                break;
              case _KAROL_DIRECTION.WEST:
                x = x - 1;
                break;
              case _KAROL_DIRECTION.EAST:
                x = x + 1;
                break;
            }
            if (x > maxX) maxX = x;
            if (y > maxY) maxY = y;
          } else if (_SET_TURNLEFT.contains(element)) {
            switch (direction) {
              case _KAROL_DIRECTION.NORTH:
                direction = _KAROL_DIRECTION.WEST;
                break;
              case _KAROL_DIRECTION.SOUTH:
                direction = _KAROL_DIRECTION.EAST;
                break;
              case _KAROL_DIRECTION.WEST:
                direction = _KAROL_DIRECTION.SOUTH;
                break;
              case _KAROL_DIRECTION.EAST:
                direction = _KAROL_DIRECTION.NORTH;
                break;
            }
          } else if (_SET_TURNRIGHT.contains(element)) {
            switch (direction) {
              case _KAROL_DIRECTION.NORTH:
                direction = _KAROL_DIRECTION.EAST;
                break;
              case _KAROL_DIRECTION.SOUTH:
                direction = _KAROL_DIRECTION.WEST;
                break;
              case _KAROL_DIRECTION.WEST:
                direction = _KAROL_DIRECTION.NORTH;
                break;
              case _KAROL_DIRECTION.EAST:
                direction = _KAROL_DIRECTION.SOUTH;
                break;
            }
          } else if (_SET_PICKBRICK.contains(element)) {
            switch (direction) {
              case _KAROL_DIRECTION.NORTH:
                world[x.toString() + '|' + (y - 1).toString()] = '#';
                break;
              case _KAROL_DIRECTION.SOUTH:
                world[x.toString() + '|' + (y + 1).toString()] = '#';
                break;
              case _KAROL_DIRECTION.EAST:
                world[(x + 1).toString() + '|' + (y).toString()] = '#';
                break;
              case _KAROL_DIRECTION.WEST:
                world[(x - 1).toString() + '|' + (y).toString()] = '#';
                break;
            }
          } else if (_SET_PUTBRICK.contains(element)) {
            switch (direction) {
              case _KAROL_DIRECTION.NORTH:
                world[x.toString() + '|' + (y - 1).toString()] = '8';
                break;
              case _KAROL_DIRECTION.SOUTH:
                world[x.toString() + '|' + (y + 1).toString()] = '8';
                break;
              case _KAROL_DIRECTION.EAST:
                world[(x + 1).toString() + '|' + (y).toString()] = '8';
                break;
              case _KAROL_DIRECTION.WEST:
                world[(x - 1).toString() + '|' + (y).toString()] = '8';
                break;
            }
          } else if (_SET_PICKBEEPER.contains(element)) {
            world[x.toString() + '|' + (y).toString()] = '#';
          } else if (_SET_PUTBEEPER.contains(element)) {
            world[x.toString() + '|' + (y).toString()] = '9';
          } else if (_SET_HALT.contains(element)) {
            halt = true;
          } else if (_SET_WAIT.contains(element)) {
          } else if (_SET_SOUND.contains(element)) {}
          else {
            world[x.toString() + '|' + (y).toString()] = '#';
          }
        }
      }
    }
  }); //forEach command

  maxX = maxX + 2;
  maxY = maxY + 2;
  var binaryWorld = List<List<String>>.generate(maxX, (y) => List<String>.filled(maxY, '#'), growable: false);
  world.forEach((key, value) {
    x = int.parse(key.split('|')[0]) - 1;
    y = int.parse(key.split('|')[1]) - 1;
    binaryWorld[x][y] = value;
  });

  String outputLine = '##';
  var output = <String>[];
  output.add(outputLine.padRight(maxX + 2, '#'));
  for (y = 0; y < maxY; y++) {
    outputLine = '##';
    for (x = 0; x < maxX; x++) {
      outputLine = outputLine + binaryWorld[x][y];
    }

    output.add(outputLine);
  }
  return output.join('\n');
}
