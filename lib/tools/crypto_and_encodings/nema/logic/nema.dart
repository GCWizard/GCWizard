part 'package:gc_wizard/tools/crypto_and_encodings/nema/logic/nema_data_exer.dart';
part 'package:gc_wizard/tools/crypto_and_encodings/nema/logic/nema_data_oper.dart';
part 'package:gc_wizard/tools/crypto_and_encodings/nema/logic/nema_source.dart';

class NEMAOutput{
  String output;
  String rotor;

  NEMAOutput({required this.output, required this.rotor});
}

enum NEMA_TYPE { EXER, OPER }

const Map<String, String> NEMA_DIGIT_TO_LETTER = {
  '1': 'q',
  '2': 'w',
  '3': 'e',
  '4': 'r',
  '5': 't',
  '6': 'z',
  '7': 'u',
  '8': 'i',
  '9': 'o',
  '0': 'p',
};

bool _nema_valid_key_exer(String key) {
  int error = 0;

  List<String> checkList = [];
  const List<String> keyList = [
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
  const List<String> keyList = [
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
      _s0 = nema_s0_exer;
      _s10 = nema_s10_exer;
      break;
    case NEMA_TYPE.OPER:
      _v = nema_v_oper;
      _iv = nema_iv_oper;
      _s0 = nema_s0_oper;
      _s10 = nema_s10_oper;
      break;
  }
}

NEMAOutput nema(
  String input,
  NEMA_TYPE type,
  String innerKey,
  String outerKey,
) {
  if (innerKey.isEmpty || outerKey.isEmpty) {
    return NEMAOutput(output: '', rotor: '');
  }
  String rotor = outerKey.toUpperCase();

  List<String> output = [];

  nema_init(type);

  _innerKeyToEinstellung(type, innerKey.toUpperCase());
  _is_einstellen();

  _outerKeyToRotor(outerKey.toUpperCase());

  input.replaceAll(' ', '').split('').forEach((char) {
    _vorschub();
    if (NEMA_DIGIT_TO_LETTER[char] != null) {
      output.add(_chiffrieren(NEMA_DIGIT_TO_LETTER[char]!.codeUnitAt(0)));
    } else {
      output.add(_chiffrieren(char.toLowerCase().codeUnitAt(0)));
    }
  });

  rotor = '';
  for (int i = 1; i < _rotor.length; i++) {
    rotor = rotor + String.fromCharCode(_rotor[i] + 65);
  }
  return NEMAOutput(output: _formatOutputNEMA(output.join('')), rotor: rotor);
}

void _outerKeyToRotor(String outerKey) {
  for (int i = 0; i < 10; i++) {
    _rotor[i + 1] = outerKey[i].codeUnitAt(0) - 65;
  }
}

void _innerKeyToEinstellung(NEMA_TYPE type, String innerKey) {
  int index = 0;
  const Map<NEMA_TYPE, Map<String, int>> key = {
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

String _formatOutputNEMA(String output){
  List<String> result = [];
  int index = 1;
  output.split('').forEach((char) {
    result.add(char);
    if (index % 5 == 0) {
      result.add(' ');
    }
    index++;
  });
  return result.join('');
}
