// https://de.wikipedia.org/wiki/Frequenzen_der_gleichstufigen_Stimmung
// https://en.wikipedia.org/wiki/Piano_key_frequencies
// https://fr.wikipedia.org/wiki/Fr%C3%A9quences_des_touches_du_piano
// https://it.wikipedia.org/wiki/Frequenze_del_pianoforte


import 'dart:math';

enum PianoFields { COLOR, FREQUENCY, HELMHOLTZ, SCIENTIFIC, GERMAN, ITALIAN, MIDI }

enum MiddleCStandard {
  C3, // Yamaha Standard
  C4, // ISO/Scientific Standard (Roland, etc.)
  C5 // Older DAWs
}

class PianoKey {
  final String number;
  final String color;
  final String frequency;
  final String helmholtz;
  final String scientific;
  final String german;
  final String italian;
  final String midi;

  const PianoKey({
    required this.number,
    required this.color,
    required this.frequency,
    required this.helmholtz,
    required this.scientific,
    required this.german,
    required this.italian,
    required this.midi,
  });

  String getField(PianoFields field) {
    switch (field) {
      case PianoFields.COLOR:
        return color;
      case PianoFields.FREQUENCY:
        return frequency;
      case PianoFields.HELMHOLTZ:
        return helmholtz;
      case PianoFields.SCIENTIFIC:
        return scientific;
      case PianoFields.GERMAN:
        return german;
      case PianoFields.ITALIAN:
        return italian;
      case PianoFields.MIDI:
        return midi;
    }
  }
}

class PianoCalculator {
  static const List<String> _notesScientific = [
    "C",
    "C♯/D♭",
    "D",
    "D♯/E♭",
    "E",
    "F",
    "F♯/G♭",
    "G",
    "G♯/A♭",
    "A",
    "A♯/B♭",
    "B"
  ];

  static const List<String> _notesGerman = [
    "C",
    "Cis/Des",
    "D",
    "Dis/Es",
    "E",
    "F",
    "Fis/Ges",
    "G",
    "Gis/As",
    "A",
    "Ais/B",
    "H"
  ];

  static const List<String> _notesItalian = [
    "Do",
    "Do♯/Re♭",
    "Re",
    "Re♯/Mi♭",
    "Mi",
    "Fa",
    "Fa♯/Sol♭",
    "Sol",
    "Sol♯/La♭",
    "La",
    "La♯/Si♭",
    "Si"
  ];

  static const Map<int, String> _notesHelmholtz = {
    -8: "C͵͵ sub-contra-octave",
    -7: "C♯͵͵/D♭͵͵",
    -6: "D͵͵",
    -5: "D♯͵͵/E♭͵͵",
    -4: "E͵͵",
    -3: "F͵͵",
    -2: "F♯͵͵/G♭͵͵",
    -1: "G͵͵",
    0: "G♯͵͵/A♭͵͵",
    1: "A͵͵",
    2: "A♯͵͵/B♭͵͵",
    3: "B͵͵",
    4: "C͵ contra-octave",
    5: "C♯͵/D♭͵",
    6: "D͵",
    7: "D♯͵/E♭͵",
    8: "E͵",
    9: "F͵",
    10: "F♯͵/G♭͵",
    11: "G͵",
    12: "G♯͵/A♭͵",
    13: "A͵",
    14: "A♯͵/B♭͵",
    15: "B͵",
    16: "C great octave",
    17: "C♯/D♭",
    18: "D",
    19: "D♯/E♭",
    20: "E",
    21: "F",
    22: "F♯/G♭",
    23: "G",
    24: "G♯/A♭",
    25: "A",
    26: "A♯/B♭",
    27: "B",
    28: "c small octave",
    29: "c♯/d♭",
    30: "d",
    31: "d♯/e♭",
    32: "e",
    33: "f",
    34: "f♯/g♭",
    35: "g",
    36: "g♯/a♭",
    37: "a",
    38: "a♯/b♭",
    39: "b",
    40: "c′ 1-line octave",
    41: "c♯′/d♭′",
    42: "d′",
    43: "d♯′/e♭′",
    44: "e′",
    45: "f′",
    46: "f♯′/g♭′",
    47: "g′",
    48: "g♯′/a♭′",
    49: "a′",
    50: "a♯′/b♭′",
    51: "b′",
    52: "c′′ 2-line octave",
    53: "c♯′′/d♭′′",
    54: "d′′",
    55: "d♯′′/e♭′′",
    56: "e′′",
    57: "f′′",
    58: "f♯′′/g♭′′",
    59: "g′′",
    60: "g♯′′/a♭′′",
    61: "a′′",
    62: "a♯′′/b♭′′",
    63: "b′′",
    64: "c′′′ 3-line octave",
    65: "c♯′′′/d♭′′′",
    66: "d′′′",
    67: "d♯′′′/e♭′′′",
    68: "e′′′",
    69: "f′′′",
    70: "f♯′′′/g♭′′′",
    71: "g′′′",
    72: "g♯′′′/a♭′′′",
    73: "a′′′",
    74: "a♯′′′/b♭′′′",
    75: "b′′′",
    76: "c′′′′ 4-line octave",
    77: "c♯′′′′/d♭′′′′",
    78: "d′′′′",
    79: "d♯′′′′/e♭′′′′",
    80: "e′′′′",
    81: "f′′′′",
    82: "f♯′′′′/g♭′′′′",
    83: "g′′′′",
    84: "g♯′′′′/a♭′′′′",
    85: "a′′′′",
    86: "a♯′′′′/b♭′′′′",
    87: "b′′′′",
    88: "c′′′′′ 5-line octave",
    89: "c♯′′′′′/d♭′′′′′",
    90: "d′′′′′",
    91: "d♯′′′′′/e♭′′′′′",
    92: "e′′′′′",
    93: "f′′′′′",
    94: "f♯′′′′′/g♭′′′′′",
    95: "g′′′′′",
    96: "g♯′′′′′/a♭′′′′′",
    97: "a′′′′′",
    98: "a♯′′′′′/b♭′′′′′",
    99: "b′′′′′",
  };

  static String getScientificSuffix(String scientificName) {
    switch (scientificName) {
      case "C0":
        return " Double Pedal C";
      case "C1":
        return " Pedal C";
      case "C2":
        return " Deep C";
      case "C4":
        return " Middle C";
      case "C5":
        return " Tenor C";
      case "C6":
        return " Soprano C (High C)";
      case "C7":
        return " Double High C";
      case "C8":
        return " Eighth octave";
      default:
        return "";
    }
  }

  static PianoKey getKey(int keyId, {MiddleCStandard middleC = MiddleCStandard.C4}) {
    // key id logic
    int n;
    String displayNum;

    if (keyId >= 89 && keyId <= 97) {
      n = keyId - 97;
      displayNum = "$keyId ($n)";
    } else if (keyId >= 98 && keyId <= 108) {
      n = keyId - 9;
      displayNum = "$keyId ($n)";
    } else {
      n = keyId;
      displayNum = "$keyId";
    }

    final int chromaIndex = (n + 8) % 12;
    final int octave = (n + 8) ~/ 12;

    final double freq = 440.0 * pow(2, (n - 49) / 12);

    // Middle C Logic - Standard (C4): Shift 0 - keyId 60
    int octaveShift = 0;
    switch (middleC) {
      case MiddleCStandard.C3:
        octaveShift = 1;
        break;
      case MiddleCStandard.C4:
        octaveShift = 0;
        break;
      case MiddleCStandard.C5:
        octaveShift = -1;
        break;
    }
    int midiVal = n + 20 + (octaveShift * 12);
    if (midiVal < 0 || midiVal > 127) midiVal = -1;
    final midiStr = (midiVal == -1) ? "" : "$midiVal";

    // key color
    const whiteKeys = {0, 2, 4, 5, 7, 9, 11};
    final color = whiteKeys.contains(chromaIndex) ? "common_color_white" : "common_color_black";

    // scientific names
    final scientific = _notesScientific[chromaIndex].split('/').map((s) => "$s$octave").join('/');
    final scientificStr = scientific + getScientificSuffix(scientific);

    // italian & german
    final String octaveSuffix = (octave - 1).toString();
    final italian = _notesItalian[chromaIndex].split('/').map((s) => "$s$octaveSuffix").join('/');

    final german = _notesGerman[chromaIndex].split('/').map((part) {
      if (octave == 0) return "${part}2";
      if (octave == 1) return "${part}1";
      if (octave == 2) return part;
      if (octave == 3) return part.toLowerCase();
      return "${part.toLowerCase()}${octave - 3}";
    }).join('/');

    // helmholtz names
    String helmholtz = _notesHelmholtz[n] ?? "";

    return PianoKey(
      number: displayNum,
      color: color,
      frequency: freq.toStringAsFixed(5),
      helmholtz: helmholtz,
      scientific: scientificStr,
      german: german,
      italian: italian,
      midi: midiStr,
    );
  }
}

PianoKey getPianoKeyFromMap(int key) {
  return PianoCalculator.getKey(key);
}