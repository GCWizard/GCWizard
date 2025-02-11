part 'package:gc_wizard/tools/crypto_and_encodings/nema/logic/nema_data_exer.dart';
part 'package:gc_wizard/tools/crypto_and_encodings/nema/logic/nema_data_oper.dart';

enum NEMA_TYPE {EXER, OPER}

List<List<int>> _v = [];
List<List<int>> _iv = [];
List<int> _einstellung = [];

/* Spezialfälle, s0 und s10 sind die Steuerscheiben an der Walze 10, 'um'
   ist die Umkehrwalze, 'in' gibt den Zusammenhang Taste -> Position der
   Anschlusskontakte, 'ini' denjenigen Position -> Taste */

const List<int> _s10 = [1,0,1,1,1,1,1,1,1,1,1,1,0,1,1,1,1,1,1,1,1,1,1,1,1,0];
const List<int> _s0 = [0,1,0,1,1,0,0,1,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0];
const List<int> _um = [10,21,13,10,2,2,24,24,13,10,16,14,8,16,10,13,7,1,25,16,18,13,5,19,16,12];
const List<int> _inTastePos = [14,1,3,12,22,11,10,9,17,8,7,6,25,0,16,15,24,21,13,20,18,2,23,4,5,19,];
const String _ini = "NBVCXYLKJHGFDSAPOIUZTREWQM";


/* Die momentan eingestellten Steuerscheiben s, Kontaktwalzen r und deren
   Inversion ir. Die Zahlen beziehen sich auf die Walzennummer. */

List<int> _s2 = [], _s4 = [], _s6 = [], _s8 = [];
List<int> _r3 = [], _r5 = [], _r7 = [], _r9 = [];
List<int> _ir3 = [], _ir5 = [], _ir7 = [], _ir9 = [];


/* Die Stellung der Walzen 1 ... 10  (0 wird nicht benötigt) */

List<int> _rotor = [];


bool _nema_valid_key_exer(String key){
  bool result = true;

  return result;
}

bool _nema_valid_key_oper(String key){
  bool result = true;

  return result;
}

bool nema_valid_key(String key, NEMA_TYPE type){
  switch (type) {
    case NEMA_TYPE.EXER: return _nema_valid_key_exer(key);
    case NEMA_TYPE.OPER: return _nema_valid_key_oper(key);
  }
}

void nema_init(NEMA_TYPE type){
  switch (type) {
    case NEMA_TYPE.EXER:
      _v = nema_v_exer;
      _iv = nema_iv_exer;
      _einstellung = nema_einstellung_exer;
      break;
    case NEMA_TYPE.OPER:
      _v = nema_v_oper;
      _iv = nema_iv_oper;
      _einstellung = nema_einstellung_oper;
      break;
  }
}

String nema(String input) {
  String output = 'HIER STEHT DER TEXT';

  return output;
}