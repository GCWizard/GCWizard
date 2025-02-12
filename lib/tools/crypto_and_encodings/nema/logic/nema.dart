part 'package:gc_wizard/tools/crypto_and_encodings/nema/logic/nema_data_exer.dart';
part 'package:gc_wizard/tools/crypto_and_encodings/nema/logic/nema_data_oper.dart';

enum NEMA_TYPE { EXER, OPER }

List<List<int>> _v = [];
List<List<int>> _iv = [];
List<int> _einstellung = [0, 0, 0, 0, 0, 0, 0, 0];

int _zaehler = 0;

/* Spezialfälle, s0 und s10 sind die Steuerscheiben an der Walze 10, 'um'
   ist die Umkehrwalze, 'in' gibt den Zusammenhang Taste -> Position der
   Anschlusskontakte, 'ini' denjenigen Position -> Taste */

const List<int> _s10 = [
  1,
  0,
  1,
  1,
  1,
  1,
  1,
  1,
  1,
  1,
  1,
  1,
  0,
  1,
  1,
  1,
  1,
  1,
  1,
  1,
  1,
  1,
  1,
  1,
  1,
  0
];
const List<int> _s0 = [
  0,
  1,
  0,
  1,
  1,
  0,
  0,
  1,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  1,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0
];
const List<int> _um = [
  10,
  21,
  13,
  10,
  2,
  2,
  24,
  24,
  13,
  10,
  16,
  14,
  8,
  16,
  10,
  13,
  7,
  1,
  25,
  16,
  18,
  13,
  5,
  19,
  16,
  12
];
const List<int> _in = [
  14,
  1,
  3,
  12,
  22,
  11,
  10,
  9,
  17,
  8,
  7,
  6,
  25,
  0,
  16,
  15,
  24,
  21,
  13,
  20,
  18,
  2,
  23,
  4,
  5,
  19,
];

const String _ini = "NBVCXYLKJHGFDSAPOIUZTREWQM";

/* Die momentan eingestellten Steuerscheiben s, Kontaktwalzen r und deren
   Inversion ir. Die Zahlen beziehen sich auf die Walzennummer. */

List<int> _s2 = List.filled(26, 0);
List<int> _s4 = List.filled(26, 0);
List<int> _s6 = List.filled(26, 0);
List<int> _s8 = List.filled(26, 0);
List<int> _r3 = List.filled(26, 0);
List<int> _r5 = List.filled(26, 0);
List<int> _r7 = List.filled(26, 0);
List<int> _r9 = List.filled(26, 0);
List<int> _ir3 = List.filled(26, 0);
List<int> _ir5 = List.filled(26, 0);
List<int> _ir7 = List.filled(26, 0);
List<int> _ir9 = List.filled(26, 0);

/* Die Stellung der Walzen 1 ... 10  (0 wird nicht benötigt) */

List<int> _rotor = List.filled(
  11,
  0,
);

bool _nema_valid_key_exer(String key) {
  int error = 0;

  List<String> checkList = [];
  List<String> keyList = [
    '16',
    '19',
    '20',
    '21',
    'A',
    'B',
    'C',
    'D',
  ];
  key.split('-').forEach((element) {
    if (keyList.contains(element)) {
      if (checkList.contains(element)) {
        error++;
      } else {
        checkList.add(element);
      }
    } else {
      error++;
    }
  });
  return (error == 0);
}

bool _nema_valid_key_oper(String key) {
  int error = 0;
  List<String> checkList = [];
  List<String> keyList = [
    '12',
    '13',
    '14',
    '15',
    '17',
    '18',
    'A',
    'B',
    'C',
    'D',
    'E',
    'F'
  ];
  key.replaceAll(' ', '-').split('-').forEach((element) {
    if (keyList.contains(element)) {
      if (checkList.contains(element)) {
        error++;
      } else {
        checkList.add(element);
      }
    } else {
      error++;
    }
  });
  return (error == 0);
}

bool nema_valid_key(String key, NEMA_TYPE type) {
  key = key.replaceAll(' ', '-');
  if (key.split('-').length != 8) return false;

  switch (type) {
    case NEMA_TYPE.EXER:
      return _nema_valid_key_exer(key.toUpperCase());
    case NEMA_TYPE.OPER:
      return _nema_valid_key_oper(key.toUpperCase());
  }
}

void nema_init(NEMA_TYPE type) {
  switch (type) {
    case NEMA_TYPE.EXER:
      _v = nema_v_exer;
      _iv = nema_iv_exer;
//      _einstellung = nema_einstellung_exer;
      break;
    case NEMA_TYPE.OPER:
      _v = nema_v_oper;
      _iv = nema_iv_oper;
//      _einstellung = nema_einstellung_oper;
      break;
  }
}

String nema(
  String input,
  NEMA_TYPE type,
  String innerKey,
  String outerKey,
) {
  List<String> output = [];

  nema_init(type);

  _innerKeyToEinstellung(type, innerKey.toUpperCase());
  _is_einstellen();

  _outerKeyToRotor(outerKey.toUpperCase());

  input.split('').forEach((char) {
    _vorschub();
    output.add(_chiffrieren(char.toLowerCase().codeUnitAt(0)));
  });

  return output.join('');
}

void _outerKeyToRotor(String outerKey) {
  for (int i = 0; i < 10; i++) {
    _rotor[i + 1] = outerKey[i].codeUnitAt(0) - 65;
  }
}

void _innerKeyToEinstellung(NEMA_TYPE type, String innerKey) {
  int index = 0;
  Map<NEMA_TYPE, Map<String, int>> key = {
    NEMA_TYPE.EXER: {
      '16': 0,
      '19': 1,
      '20': 2,
      '21': 3,
      'A': 4,
      'B': 5,
      'C': 6,
      'D': 7,
    },
    NEMA_TYPE.OPER: {
      '12': 0,
      '13': 1,
      '14': 2,
      '15': 3,
      '17': 4,
      '18': 5,
      'A': 6,
      'B': 7,
      'C': 8,
      'D': 9,
      'E': 10,
      'F': 11,
    }
  };
  innerKey.replaceAll(' ', '-').split('-').forEach((element) {
    _einstellung[index] = key[type]![element]!;
    index++;
  });
}

String _chiffrieren(int klartext) {
/* Klartext wird als Kleinbuchstabe mitgebracht */

  int zwischen = _in[klartext - 97];
/* Offset weg und Position auf Anschlusskontakten */

  zwischen = (zwischen + _r9[(zwischen + _rotor[9]) % 26]) % 26;
  zwischen = (zwischen + _r7[(zwischen + _rotor[7]) % 26]) % 26;
  zwischen = (zwischen + _r5[(zwischen + _rotor[5]) % 26]) % 26;
  zwischen = (zwischen + _r3[(zwischen + _rotor[3]) % 26]) % 26;
  zwischen = (zwischen + _um[(zwischen + _rotor[1]) % 26]) % 26;
  zwischen = (zwischen + _ir3[(zwischen + _rotor[3]) % 26]) % 26;
  zwischen = (zwischen + _ir5[(zwischen + _rotor[5]) % 26]) % 26;
  zwischen = (zwischen + _ir7[(zwischen + _rotor[7]) % 26]) % 26;
  zwischen = (zwischen + _ir9[(zwischen + _rotor[9]) % 26]) % 26;

  return (_ini[zwischen]);
/* von Anschlussplatte auf Buchstaben */
}

void _is_einstellen() {
  for (int j = 0; j <= 25; j++) {
/* übernimmt die Werte aus dem Vorrat */
    _s2[j] = _v[_einstellung[0]][j];
    _s4[j] = _v[_einstellung[2]][j];
    _s6[j] = _v[_einstellung[4]][j];
    _s8[j] = _v[_einstellung[6]][j];
    _r3[j] = _v[_einstellung[1]][j];
    _r5[j] = _v[_einstellung[3]][j];
    _r7[j] = _v[_einstellung[5]][j];
    _r9[j] = _v[_einstellung[7]][j];
    _ir3[j] = _iv[_einstellung[1]][j];
    _ir5[j] = _iv[_einstellung[3]][j];
    _ir7[j] = _iv[_einstellung[5]][j];
    _ir9[j] = _iv[_einstellung[7]][j];
  }
}

void _vorschub() {
  /* Tastendruck auf Walzen übertragen */

/* die Rotoren 3 und 7 haben doppelte Abhängigkeit */
/* die Rotoren 4 und 8 haben einfache Abhängigkeit von s0 */

  if (_s0[((_rotor[10] + 17) % 26)] != 0) {
    if (_s4[((_rotor[4] + 16) % 26)] != 0) _rotor[3] = (_rotor[3] + 25) % 26;
    _rotor[4] = (_rotor[4] + 25) % 26;
    if (_s8[((_rotor[8] + 16) % 26)] != 0) _rotor[7] = (_rotor[7] + 25) % 26;
    _rotor[8] = (_rotor[8] + 25) % 26;
  }

/* die Rotoren 1, 5 und 9 haben einfache Abhängigkeit */

  if (_s2[((_rotor[2] + 16) % 26)] != 0) _rotor[1] = (_rotor[1] + 25) % 26;
  if (_s6[((_rotor[6] + 16) % 26)] != 0) _rotor[5] = (_rotor[5] + 25) % 26;
  if (_s10[((_rotor[10] + 16) % 26)] != 0) _rotor[9] = (_rotor[9] + 25) % 26;

/* die Rotoren 2, 6 und 10 werden bei jedem Tastendruck bewegt */

  _rotor[2] = (_rotor[2] + 25) % 26;
  _rotor[6] = (_rotor[6] + 25) % 26;
  _rotor[10] = (_rotor[10] + 25) % 26;
}
