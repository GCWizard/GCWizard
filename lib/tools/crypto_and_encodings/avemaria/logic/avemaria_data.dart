// https://practice.nationalcybercup.org/cryptography/avemaria
// https://en.wikipedia.org/wiki/Polygraphia_(book)
// https://books.google.de/books?id=fQdCAAAAcAAJ&pg=PP1&redir_esc=y#v=onepage&q&f=false
// http://www.esotericarchives.com/tritheim/stegano.htm
// https://www.dcode.fr/trithemius-ave-maria

part of 'package:gc_wizard/tools/crypto_and_encodings/avemaria/logic/avemaria.dart';

const Map<String, String> _AVE_MARIA = {
  'deus': 'A',
  'clemens': 'A',
  'creator': 'B',
  'clementissimus': 'B',
  'conditor': 'C',
  'pius': 'C',
  'piissimus': 'D',
  'opifex': 'D',
  'magnus': 'E',
  'dominus': 'E',
  'excelsus': 'F',
  'dominator': 'F',
  'maximus': 'G',
  'consolator': 'G',
  'arbiter': 'H',
  'optimus': 'H',
  'iudex': 'I',
  'sapientissimus': 'I',
  'illuminator': 'K',
  'inuisibilis': 'K',
  'illustrator': 'L',
  'immortalis': 'L',
  'rector': 'M',
  'aeternus': 'M',
  'rex': 'N',
  'sempiternus': 'N',
  'imperator': 'O',
  'gloriosus': 'O',
  'gubernator': 'P',
  'fortissimus': 'P',
  'factor': 'Q',
  'sanctissimus': 'Q',
  'fabricator': 'R',
  'incompraehensibilis': 'R',
  'conseruator': 'S',
  'omnipotens': 'S',
  'redemptor': 'T',
  'pacificus': 'T',
  'auctor': 'U',
  'misericors': 'U',
  'princeps': 'X',
  'misericordissimus': 'X',
  'pastor': 'Y',
  'conctipotens': 'Y',
  'moderator': 'Z',
  'magnificus': 'Z',
};

const List<MapEntry<String, String>> _AVE_MARIA_ENCODE_EXTENSION = [
  MapEntry<String, String>('iudex', 'J'),
  MapEntry<String, String>('sapientissimus', 'J'),
  MapEntry<String, String>('auctor', 'V'),
  MapEntry<String, String>('misericors', 'V'),
  MapEntry<String, String>('auctor', 'W'),
  MapEntry<String, String>('misericors', 'W')
];
