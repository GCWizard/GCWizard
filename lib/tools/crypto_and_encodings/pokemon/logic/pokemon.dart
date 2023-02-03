// https://www.geocaching.com/geocache/GC975GK_professor-birk
// Piluffme luflorsasesa Florlusasa manpison sonsaflortu SesamkatuMansamsonsonpi lupi sakla arsaklatusa Regsammansasonsamtu seregflorsakarda lufftulu saflortusa Assaklamonflortululufftuar zuluffson Arsasamflapiflakasatu mosamkarkardasa Reglufftumanda

import 'package:gc_wizard/utils/constants.dart';

Map<String, String> _POKEMON = {
// http://fbcs.bplaced.net/multi_encoder_decoder.html
  'g': 'ar',
  'v': 'as',
  'j': 'chu',
  't': 'da',
  'c': 'fla',
  'i': 'flor',
  'x': 'ge',
  'h': 'ka',
  'l': 'kar',
  'r': 'kla',
  'd': 'lu',
  'u': 'luff',
  'k': 'man',
  'f': 'me',
  'w': 'mo',
  'b': 'mon',
  'q': 'pa',
  'a': 'pi',
  'p': 'reg',
  'e': 'sa',
  'o': 'sam',
  's': 'se',
  'm': 'son',
  'y': 'tron',
  'n': 'tu',
  'z': 'zu',
  ' ': ' ',
};

List<Map<String, String>> _DECODE_POKEMON = [
  {'same': 'ef'},
  {'saman': 'ek'},
  {'samon': 'eb'},
  {'samo': 'ew'},
  {'sasam': 'eo'},
  {'klason': 'rm'},
  {'klase': 'rs'},
  {'kason': 'hm'},
  {'kase': 'hs'},
  {'kasam': 'he'},
  {'kasa': 'he'},
  {'flason': 'cm'},
  {'flase': 'cs'},
  {'flasa': 'ce'},
  {'sason': 'em'},
  {'sase': 'es'},
  {'sasa': 'ee'},
  {'dason': 'tm'},
  {'dase': 'ts'},
  {'dasa': 'te'},
  {'pason': 'qm'},
  {'pase': 'qs'},
  {'pasa': 'qe'},
  {'as': 'v'},
  {'pareg': 'qp'},
  {'kareg': 'hp'},
  {'klareg': 'rp'},
  {'flareg': 'cp'},
  {'sareg': 'ep'},
  {'dareg': 'tp'},
  {'reg': 'p'},
  {'kar': 'l'},
  {'kas': 'h'},
  {'kla': 'r'},
  {'ka': 'h'},
  {'fla': 'c'},
  {'sam': 'o'},
  {'sa': 'e'},
  {'da': 't'},
  {'pa': 'q'},
  {'ar': 'g'},
  {'zu': 'z'},
  {'tu': 'n'},
  {'tron': 'y'},
  {'son': 'm'},
  {'se': 's'},
  {'pi': 'a'},
  {'luff': 'u'},
  {'lu': 'd'},
  {'flor': 'i'},
  {'chu': 'j'},
  {'mon': 'b'},
  {'mo': 'w'},
  {'me': 'f'},
  {'man': 'k'},
  {'ge': 'x'},
];

String encodePokemon(String plainText) {
  if (plainText == null || plainText == '') return '';
  String result = '';
  for (int i = 0; i < plainText.length; i++) result = result + _POKEMON[plainText[i].toLowerCase()];
  return result.toUpperCase();
}

String decodePokemon(String chiffreText) {
  if (chiffreText == null || chiffreText == '') return '';

  List<String> result = [];
  chiffreText = chiffreText.toLowerCase();
  chiffreText.split(' ').forEach((element) {
    result.add(_decode(element));
  });
  return result.join(' ').toUpperCase();
}

String _decode(String input) {
  String cypher = input;
  String result = '';
  int iteration = cypher.length + 1;

  if (cypher.length == 1) return UNKNOWN_ELEMENT;

  while (cypher.length > 0 && iteration > 0) {
    iteration--;
    int j = 0;
    while (j < _DECODE_POKEMON.length) {
      if (cypher.startsWith(_DECODE_POKEMON[j].keys.toList()[0])) {
        cypher = cypher.replaceFirst(_DECODE_POKEMON[j].keys.toList()[0], '');
        result = result + _DECODE_POKEMON[j].values.toList()[0];
        j = _DECODE_POKEMON.length;
        iteration = cypher.length;
      }
      j++;
    }
  }
  if (result == '' || cypher.length > 0) result = UNKNOWN_ELEMENT;

  return result;
}
