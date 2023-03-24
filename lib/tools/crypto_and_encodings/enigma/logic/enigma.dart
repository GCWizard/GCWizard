import 'package:gc_wizard/utils/alphabets.dart';
import 'package:gc_wizard/utils/collection_utils.dart';
import 'package:gc_wizard/utils/complex_return_types.dart';
import 'package:gc_wizard/utils/string_utils.dart';

enum EnigmaRotorType { STANDARD, ENTRY_ROTOR, REFLECTOR }

class EnigmaRotor {
  final String name;
  final String alphabet;
  final String turnovers; // see https://en.wikipedia.org/wiki/Enigma_machine#Turnover
  final EnigmaRotorType type;

  const EnigmaRotor(this.name, this.alphabet, {this.turnovers = '', this.type = EnigmaRotorType.STANDARD});

  @override
  String toString() {
    return 'name: $name, alphabet: $alphabet, turnovers: $turnovers, type: $type';
  }
}

const String defaultRotorStandard = 'I, Enigma I \'Wehrmacht\'';
const String defaultRotorEntryRotor = 'ETW, Enigma I \'Wehrmacht\'';
const String defaultRotorReflector = 'UKW B, M3 + M4 \'Wehrmacht\'';

const List<EnigmaRotor> allEnigmaRotors = [
  // Enigma I, M3, M4 (Kriegsmarine)
  EnigmaRotor(defaultRotorEntryRotor, 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', type: EnigmaRotorType.ENTRY_ROTOR),
  EnigmaRotor(defaultRotorStandard, 'EKMFLGDQVZNTOWYHXUSPAIBRCJ', turnovers: 'Q'),
  EnigmaRotor('II, Enigma I \'Wehrmacht\'', 'AJDKSIRUXBLHWTMCQGZNPYFVOE', turnovers: 'E'),
  EnigmaRotor('III, Enigma I \'Wehrmacht\'', 'BDFHJLCPRTXVZNYEIWGAKMUSQO', turnovers: 'V'),
  EnigmaRotor('IV, M3 \'Wehrmacht\'', 'ESOVPZJAYQUIRHXLNFTGKDCMWB', turnovers: 'J'),
  EnigmaRotor('V, M3 \'Wehrmacht\'', 'VZBRGITYUPSDNHLXAWMJQOFECK', turnovers: 'Z'),
  EnigmaRotor('VI, M3 + M4 \'Wehrmacht\'', 'JPGVOUMFYQBENHZRDKASXLICTW', turnovers: 'ZM'),
  EnigmaRotor('VII, M3 + M4 \'Wehrmacht\'', 'NZJHGRCXMYSWBOUFAIVLPEKQDT', turnovers: 'ZM'),
  EnigmaRotor('VIII, M3 + M4 \'Wehrmacht\'', 'FKQHTLXOCBJSPDZRAMEWNIUYGV', turnovers: 'ZM'),
  EnigmaRotor('UKW A, M3 \'Wehrmacht\'', 'EJMZALYXVBWFCRQUONTSPIKHGD', type: EnigmaRotorType.REFLECTOR),
  EnigmaRotor(defaultRotorReflector, 'YRUHQSLDPXNGOKMIEBFZCWVJAT', type: EnigmaRotorType.REFLECTOR),
  EnigmaRotor('UKW C, M3 + M4 \'Wehrmacht\'', 'FVPJIAOYEDRZXWGCTKUQSBNMHL', type: EnigmaRotorType.REFLECTOR),

  // M4 'Shark'
  EnigmaRotor('ETW, M4 \'Shark\'', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', type: EnigmaRotorType.ENTRY_ROTOR),
  EnigmaRotor('Greek B \'Beta\', M4 \'Shark\'', 'LEYJVCNIXWPBQMDRTAKZGFUHOS'),
  EnigmaRotor('Greek C \'Gamma\', M4 \'Shark\'', 'FSOKANUERHMBTIYCWLQPZXVGJD'),
  EnigmaRotor('UKW B \'thin\', M4 \'Shark\'', 'ENKQAUYWJICOPBLMDXZVFTHRGS', type: EnigmaRotorType.REFLECTOR),
  EnigmaRotor('UKW C \'thin\', M4 \'Shark\'', 'RDOBJNTKVEHMLFCWZAXGYIPSUQ', type: EnigmaRotorType.REFLECTOR),

  // Modell 'Tirpitz'
  EnigmaRotor('ETW (T), Enigma T \'Tirpitz\'', 'KZROUQHYAIGBLWVSTDXFPNMCJE', type: EnigmaRotorType.ENTRY_ROTOR),
  EnigmaRotor('I (T), Enigma T \'Tirpitz\'', 'KPTYUELOCVGRFQDANJMBSWHZXI', turnovers: 'EKQWZ'),
  EnigmaRotor('II (T), Enigma T \'Tirpitz\'', 'UPHZLWEQMTDJXCAKSOIGVBYFNR', turnovers: 'FLRWZ'),
  EnigmaRotor('III (T), Enigma T \'Tirpitz\'', 'QUDLYRFEKONVZAXWHMGPJBSICT', turnovers: 'EKQWZ'),
  EnigmaRotor('IV (T), Enigma T \'Tirpitz\'', 'CIWTBKXNRESPFLYDAGVHQUOJZM', turnovers: 'FLRWZ'),
  EnigmaRotor('V (T), Enigma T \'Tirpitz\'', 'UAXGISNJBVERDYLFZWTPCKOHMQ', turnovers: 'CFKRY'),
  EnigmaRotor('VI (T), Enigma T \'Tirpitz\'', 'XFUZGALVHCNYSEWQTDMRBKPIOJ', turnovers: 'EIMQX'),
  EnigmaRotor('VII (T), Enigma T \'Tirpitz\'', 'BJVFTXPLNAYOZIKWGDQERUCHSM', turnovers: 'CFKRY'),
  EnigmaRotor('VIII (T), Enigma T \'Tirpitz\'', 'YMTPNZHWKODAJXELUQVGCBISFR', turnovers: 'EIMQX'),
  EnigmaRotor('UKW (T), Enigma T \'Tirpitz\'', 'GEKPBTAUMOCNILJDXZYFHWVQSR', type: EnigmaRotorType.REFLECTOR),

  // Enigma G (Abwehr)
  EnigmaRotor('ETW (G), Enigma G \'Abwehr\'', 'QWERTZUIOASDFGHJKPYXCVBNML', type: EnigmaRotorType.ENTRY_ROTOR),
  EnigmaRotor('I (G), Enigma G \'Abwehr\'', 'DMTWSILRUYQNKFEJCAZBPGXOHV', turnovers: 'ABCEFGIKLOPQSUVWZ'),
  EnigmaRotor('II (G), Enigma G \'Abwehr\'', 'HQZGPJTMOBLNCIFDYAWVEUSRKX', turnovers: 'ACDFGHKMNQSTVYZ'),
  EnigmaRotor('III (G), Enigma G \'Abwehr\'', 'UQNTLSZFMREHDPXKIBVYGJCWOA', turnovers: 'AEFHKMNRUWX'),
  EnigmaRotor('UKW (G), Enigma G \'Abwehr\'', 'RULQMZJSYGOCETKWDAHNBXPVIF', type: EnigmaRotorType.REFLECTOR),

  // Enigma G312 (Abwehr); Source: cryptomuseum.com
  EnigmaRotor('ETW (G), Enigma G312 \'Abwehr\'', 'QWERTZUIOASDFGHJKPYXCVBNML', type: EnigmaRotorType.ENTRY_ROTOR),
  EnigmaRotor('I (G), Enigma G312 \'Abwehr\'', 'DMTWSILRUYQNKFEJCAZBPGXOHV', turnovers: 'SUVWZABCEFGIKLOPQ'),
  EnigmaRotor('II (G), Enigma G312 \'Abwehr\'', 'HQZGPJTMOBLNCIFDYAWVEUSRKX', turnovers: 'STVYZACDFGHKMNQ'),
  EnigmaRotor('III (G), Enigma G312 \'Abwehr\'', 'UQNTLSZFMREHDPXKIBVYGJCWOA', turnovers: 'UWXAEFHKMNR'),
  EnigmaRotor('UKW (G), Enigma G312 \'Abwehr\'', 'RULQMZJSYGOCETKWDAHNBXPVIF', type: EnigmaRotorType.REFLECTOR),

  // Enigma G260 (Abwehr); Source: cryptomuseum.com
  EnigmaRotor('ETW (G), Enigma G260 \'Abwehr\'', 'QWERTZUIOASDFGHJKPYXCVBNML', type: EnigmaRotorType.ENTRY_ROTOR),
  EnigmaRotor('I (G), Enigma G260 \'Abwehr\'', 'RCSPBLKQAUMHWYTIFZVGOJNEXD', turnovers: 'SUVWZABCEFGIKLOPQ'),
  EnigmaRotor('II (G), Enigma G260 \'Abwehr\'', 'WCMIBVPJXAROSGNDLZKEYHUFQT', turnovers: 'STVYZACDFGHKMNQ'),
  EnigmaRotor('III (G), Enigma G260 \'Abwehr\'', 'FVDHZELSQMAXOKYIWPGCBUJTNR', turnovers: 'UWXAEFHKMNR'),
  EnigmaRotor('UKW (G), Enigma G260 \'Abwehr\'', 'IMETCGFRAYSQBZXWLHKDVUPOJN', type: EnigmaRotorType.REFLECTOR),

  // Enigma Reichsbahn
  EnigmaRotor('ETW, Enigma \'Reichsbahn\'', 'QWERTZUIOASDFGHJKPYXCVBNML', type: EnigmaRotorType.ENTRY_ROTOR),
  EnigmaRotor('I, Enigma \'Reichsbahn\'', 'JGDQOXUSCAMIFRVTPNEWKBLZYH', turnovers: 'N'),
  EnigmaRotor('II, Enigma \'Reichsbahn\'', 'NTZPSFBOKMWRCJDIVLAEYUXHGQ', turnovers: 'E'),
  EnigmaRotor('III, Enigma \'Reichsbahn\'', 'JVIUBHTCDYAKEQZPOSGXNRMWFL', turnovers: 'Y'),
  EnigmaRotor('UKW, Enigma \'Reichsbahn\'', 'QYHOGNECVPUZTFDJAXWMKISRBL', type: EnigmaRotorType.REFLECTOR),

  // Enigma D
  EnigmaRotor('ETW (D), Enigma D, Version 1', 'JWULCMNOHPQZYXIRADKEGVBTSF', type: EnigmaRotorType.ENTRY_ROTOR),
  EnigmaRotor('ETW (D), Enigma D, Version 2', 'QWERTZUIOASDFGHJKPYXCVBNML', type: EnigmaRotorType.ENTRY_ROTOR),
  EnigmaRotor('I (D), Enigma D', 'LPGSZMHAEOQKVXRFYBUTNICJDW', turnovers: 'Y'),
  EnigmaRotor('II (D), Enigma D', 'SLVGBTFXJQOHEWIRZYAMKPCNDU', turnovers: 'E'),
  EnigmaRotor('III (D), Enigma D', 'CJGDPSHKTURAWZXFMYNQOBVLIE', turnovers: 'N'),
  EnigmaRotor('UKW (D), Enigma D', 'IMETCGFRAYSQBZXWLHKDVUPOJN', turnovers: 'N', type: EnigmaRotorType.REFLECTOR),

  // Enigma Swiss-K
  EnigmaRotor('ETW, Enigma Swiss-K', 'QWERTZUIOASDFGHJKPYXCVBNML', type: EnigmaRotorType.ENTRY_ROTOR),
  EnigmaRotor('I, Enigma Swiss-K', 'LPGSZMHAEOQKVXRFYBUTNICJDW', turnovers: 'Y'),
  EnigmaRotor('II, Enigma Swiss-K', 'SLVGBTFXJQOHEWIRZYAMKPCNDU', turnovers: 'E'),
  EnigmaRotor('III, Enigma Swiss-K', 'CJGDPSHKTURAWZXFMYNQOBVLIE', turnovers: 'N'),
  EnigmaRotor('UKW, Enigma Swiss-K', 'IMETCGFRAYSQBZXWLHKDVUPOJN', type: EnigmaRotorType.REFLECTOR),
  EnigmaRotor('UKW, Enigma Swiss-K', 'IMETCGFRAYSQBZXWLHKDVUPOJN', type: EnigmaRotorType.REFLECTOR),
  EnigmaRotor('UKW, Enigma Swiss-K', 'IMETCGFRAYSQBZXWLHKDVUPOJN', type: EnigmaRotorType.REFLECTOR),
];

EnigmaRotor getEnigmaRotorByName(String name) {
  return allEnigmaRotors.firstWhere((ells) => ells.name == name);
}

class EnigmaRotorConfiguration {
  EnigmaRotor rotor;
  int offset = 0;
  int setting = 0;

  EnigmaRotorConfiguration(this.rotor, {Object offset = 1, Object setting = 1}) {
    if (offset is int) {
      this.offset = offset - 1;
    } else if (offset is String) {
      this.offset = alphabet_AZ[offset.toUpperCase()]! - 1;
    }

    if (setting is int) {
      this.setting = setting - 1;
    } else if (setting is String) {
      this.setting = alphabet_AZ[setting.toUpperCase()]! - 1;
    }
  }

  int get settingWithOffset {
    return (setting - offset + 26) % 26;
  }

  EnigmaRotorConfiguration clone() {
    return EnigmaRotorConfiguration(rotor,
        offset: offset + 1, // +1 because the constructor subtracts one
        setting: setting + 1);
  }

  @override
  String toString() {
    return 'rotor: $rotor, offset: $offset, setting: $setting';
  }
}

class EnigmaKey {
  List<EnigmaRotorConfiguration> rotorConfigurations;
  Map<String, String> plugboard = {};

  void _createPlugboard(Map<String, String> plugboard) {
    plugboard.forEach((k, v) => this.plugboard.putIfAbsent(k.toUpperCase(), () => v.toUpperCase()));

    // When A->B in plugboard, B->A has to be in there as well
    // Well if there's a record B which doesn't map to A, this is kept, although historical nonsense (cables connecting A and B work in both directions)
    var inversePlugboard = Map<String, String>.from(switchMapKeyValue(plugboard));
    inversePlugboard.forEach((k, v) => this.plugboard.putIfAbsent(k.toUpperCase(), () => v.toUpperCase()));
  }

  EnigmaKey(this.rotorConfigurations, {Map<String, String> plugboard = const {}}) {
    _createPlugboard(plugboard);
  }

  @override
  String toString() {
    return 'rotorConfigurations: $rotorConfigurations, plugboard: $plugboard';
  }
}

String _normalizeInput(String input) {
  input = normalizeUmlauts(input).toUpperCase();
  input = input.replaceAll(RegExp(r'[^A-Z]'), '');
  return input;
}

bool _rotorConfigCausesTurnover(EnigmaRotorConfiguration configuration) {
  var letter = alphabet_AZIndexes[configuration.setting + 1]!;
  return configuration.rotor.turnovers.contains(letter);
}

void _stepping(List<EnigmaRotorConfiguration> configurations) {
  int i = 0;
  bool selfTurnover = false;
  bool turnoverThroughPrevious = false;
  do {
    var currentConfig = configurations[i];

    selfTurnover = _rotorConfigCausesTurnover(currentConfig);

    if (i == 0 || selfTurnover || turnoverThroughPrevious) currentConfig.setting = (currentConfig.setting + 1) % 26;

    turnoverThroughPrevious = selfTurnover;

    i++;
  } while (i < configurations.length);
}

List<EnigmaRotorConfiguration> _standardRotorConfigurations(EnigmaKey key) {
  return key.rotorConfigurations.where((position) => position.rotor.type == EnigmaRotorType.STANDARD).toList();
}

List<int> _rotorConfigurations(EnigmaKey key) {
  return key.rotorConfigurations.map((configuration) => configuration.setting).toList();
}

IntegerListText calculateEnigma(String input, EnigmaKey key) {
  if (_standardRotorConfigurations(key).isEmpty) {
    return IntegerListText('', _rotorConfigurations(key));
  }

  input = _normalizeInput(input);
  if (input.isEmpty) return IntegerListText('', _rotorConfigurations(key));

  var output = '';

  input.split('').forEach((letter) {
    //rotate
    _stepping(_standardRotorConfigurations(key));

    //calcPlugboard
    letter = key.plugboard[letter] ?? letter;
    //calcEntryWheel
    int rotorNumber = 0;
    while (rotorNumber < key.rotorConfigurations.length) {
      var rotor = key.rotorConfigurations[rotorNumber];
      // rotor (alphabet) rotated by value of setting
      var letterIndex = (alphabet_AZ[letter]! - 1 + rotor.settingWithOffset) % 26;
      // mapping alphabet to rotor alphabet
      letter = rotor.rotor.alphabet[letterIndex];

      // normalize output to natural alphabet for further rotors
      letterIndex = (alphabet_AZ[letter]! - 1 - rotor.settingWithOffset + 26) % 26;
      letter = alphabet_AZIndexes[letterIndex + 1]!;

      rotorNumber++;
    }

    // If previous rotor was a reflector, go way back; switch input and output alphabets
    if (key.rotorConfigurations[--rotorNumber].rotor.type == EnigmaRotorType.REFLECTOR) {
      rotorNumber--;

      while (rotorNumber >= 0) {
        var rotor = key.rotorConfigurations[rotorNumber];

        var letterIndex = (alphabet_AZ[letter]! - 1 + rotor.settingWithOffset) % 26;
        letter = alphabet_AZIndexes[letterIndex + 1]!;

        letterIndex = rotor.rotor.alphabet.indexOf(letter);
        letter = alphabet_AZIndexes[(letterIndex - rotor.settingWithOffset + 26) % 26 + 1]!;

        rotorNumber--;
      }

      letter = key.plugboard[letter] ?? letter;
    }

    output += letter;
  });

  return IntegerListText(output, _rotorConfigurations(key));
}

// Sometimes the message has been encrypted twice. The first decryption showed a pattern: three letters, repeated once, e.g. ABCABC
// at the beginning. This 3-letter pattern was used as rotor setting for the second decryption
// PS: the 3 depends on the number of rotors; when there are four rotors, there will be 4-letter pattern
List<IntegerListText> calculateEnigmaWithMessageKey(String input, EnigmaKey key) {
  var firstResult = calculateEnigma(input, key);
  String firstCalculation = firstResult.text;

  if (firstCalculation.isEmpty) return [firstResult];

  List<IntegerListText> output = [firstResult];

  var standardRotorConfigurations = _standardRotorConfigurations(key);
  var numberRotors = standardRotorConfigurations.length;

  // Set the new RotorSetting
  if (firstCalculation.length > numberRotors * 2 &&
      firstCalculation.substring(0, numberRotors) == firstCalculation.substring(numberRotors, numberRotors * 2)) {
    var pattern = firstCalculation
        .substring(0, numberRotors)
        .split('')
        .map((letter) => alphabet_AZ[letter]! - 1)
        .toList() // map to alphabet index
        .reversed
        .toList(); // backwards because of the typically inverse order of the rotors

    int i = 0;
    for (var configuration in standardRotorConfigurations) {
      configuration.setting = pattern[i++];
    }

    output.add(calculateEnigma(input.replaceAll(' ', '').substring(numberRotors * 2), key));
  }

  return output;
}
