part of 'package:gc_wizard/tools/crypto_and_encodings/nema/logic/nema.dart';


/*
* The following source code was developed using Turbo C by
*
*             Walter Schmid HB9AIV
*             Lächlerstrasse 70,
*             8634 Hombrechtikon
*
* for simulating the NEMA:
*    NEMA_KMOB.C  simulating the NEMA for operational use
*    NEMA_KURS.C  simulating the NEMA for training purpose
*
* For deeper insight please check the attached C files.
*
* */

List<List<int>> _v = [];
List<List<int>> _iv = [];
List<int> _einstellung = [0, 0, 0, 0, 0, 0, 0, 0];

List<int> _s0 = [];
List<int> _s10 = [];

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

List<int> _rotor = List.filled(
  11,
  0,
);


String _chiffrieren(int klartext) {

  int zwischen = _in[klartext - 97];

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
}

void _is_einstellen() {
  for (int j = 0; j <= 25; j++) {

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

  if (_s0[((_rotor[10] + 17) % 26)] != 0) {
    if (_s4[((_rotor[4] + 16) % 26)] != 0) _rotor[3] = (_rotor[3] + 25) % 26;
    _rotor[4] = (_rotor[4] + 25) % 26;
    if (_s8[((_rotor[8] + 16) % 26)] != 0) _rotor[7] = (_rotor[7] + 25) % 26;
    _rotor[8] = (_rotor[8] + 25) % 26;
  }

  if (_s2[((_rotor[2] + 16) % 26)] != 0) _rotor[1] = (_rotor[1] + 25) % 26;
  if (_s6[((_rotor[6] + 16) % 26)] != 0) _rotor[5] = (_rotor[5] + 25) % 26;
  if (_s10[((_rotor[10] + 16) % 26)] != 0) _rotor[9] = (_rotor[9] + 25) % 26;

  _rotor[2] = (_rotor[2] + 25) % 26;
  _rotor[6] = (_rotor[6] + 25) % 26;
  _rotor[10] = (_rotor[10] + 25) % 26;
}
