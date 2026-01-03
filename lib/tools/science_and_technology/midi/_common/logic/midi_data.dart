// https://de.wikipedia.org/wiki/Frequenzen_der_gleichstufigen_Stimmung
// https://en.wikipedia.org/wiki/Piano_key_frequencies
// https://fr.wikipedia.org/wiki/Fr%C3%A9quences_des_touches_du_piano

enum MIDIFields {
  COLOR,
  FREQUENCY,
  HELMHOLTZ,
  SCIENTIFIC,
  GERMAN,
  PIANO,
  LATIN,
  KEYBOARD,
}

class MIDIKey {
  final String midi;
  final String color;
  final String frequency;
  final String helmholtz;
  final String scientific;
  final String german;
  final String piano;
  final String latin;
  final String keyboard;

  const MIDIKey(
      {required this.midi,
      required this.color,
      required this.frequency,
      required this.helmholtz,
      required this.scientific,
      required this.german,
      required this.piano,
      required this.latin,
      required this.keyboard});

  String getField(MIDIFields field) {
    switch (field) {
      case MIDIFields.COLOR:
        return color;
      case MIDIFields.FREQUENCY:
        return frequency;
      case MIDIFields.HELMHOLTZ:
        return helmholtz;
      case MIDIFields.SCIENTIFIC:
        return scientific;
      case MIDIFields.GERMAN:
        return german;
      case MIDIFields.PIANO:
        return piano;
      case MIDIFields.LATIN:
        return latin;
      case MIDIFields.KEYBOARD:
        return keyboard;
    }
  }
}

const Map<int, MIDIKey> MIDI_KEYS = {
// https://inspiredacoustics.com/en/MIDI_note_numbers_and_center_frequencies
// https://sengpielaudio.com/Rechner-notennamen.htm
  0: MIDIKey(
      midi: "0",
      color: "common_color_white",
      frequency: "8.18",
      helmholtz: "",
      scientific: "",
      german: "",
      piano: "",
      latin: "",
      keyboard: ""),
  1: MIDIKey(
      midi: "1",
      color: "common_color_black",
      frequency: "8.66",
      helmholtz: "",
      scientific: "",
      german: "",
      piano: "",
      latin: "",
      keyboard: ""),
  2: MIDIKey(
      midi: "2",
      color: "common_color_white",
      frequency: "9.18",
      helmholtz: "",
      scientific: "",
      german: "",
      piano: "",
      latin: "",
      keyboard: ""),
  3: MIDIKey(
      midi: "3",
      color: "common_color_black",
      frequency: "9.72",
      helmholtz: "",
      scientific: "",
      german: "",
      piano: "",
      latin: "",
      keyboard: ""),
  4: MIDIKey(
      midi: "4",
      color: "common_color_white",
      frequency: "10.30",
      helmholtz: "",
      scientific: "",
      german: "",
      piano: "",
      latin: "",
      keyboard: ""),
  5: MIDIKey(
      midi: "5",
      color: "common_color_white",
      frequency: "10.91",
      helmholtz: "",
      scientific: "",
      german: "",
      piano: "",
      latin: "",
      keyboard: ""),
  6: MIDIKey(
      midi: "6",
      color: "common_color_black",
      frequency: "11.56",
      helmholtz: "",
      scientific: "",
      german: "",
      piano: "",
      latin: "",
      keyboard: ""),
  7: MIDIKey(
      midi: "7",
      color: "common_color_white",
      frequency: "12.25",
      helmholtz: "",
      scientific: "",
      german: "",
      piano: "",
      latin: "",
      keyboard: ""),
  8: MIDIKey(
      midi: "8",
      color: "common_color_black",
      frequency: "12.98",
      helmholtz: "",
      scientific: "",
      german: "",
      piano: "",
      latin: "",
      keyboard: ""),
  9: MIDIKey(
      midi: "9",
      color: "common_color_white",
      frequency: "13.75",
      helmholtz: "",
      scientific: "",
      german: "",
      piano: "",
      latin: "",
      keyboard: ""),
  10: MIDIKey(
      midi: "10",
      color: "common_color_black",
      frequency: "14.57",
      helmholtz: "",
      scientific: "",
      german: "",
      piano: "",
      latin: "",
      keyboard: ""),
  11: MIDIKey(
      midi: "11",
      color: "common_color_white",
      frequency: "15.43",
      helmholtz: "",
      scientific: "",
      german: "",
      piano: "",
      latin: "",
      keyboard: ""),
  12: MIDIKey(
      midi: "12",
      color: "common_color_white",
      frequency: "16.35160",
      helmholtz: "C͵͵ sub-contra-octave",
      scientific: "C0 Double Pedal C",
      german: "C2",
      piano: "-8",
      latin: "Do-1",
      keyboard: ""),
  13: MIDIKey(
      midi: "13",
      color: "common_color_black",
      frequency: "17.32391",
      helmholtz: "C♯͵͵/D♭͵͵",
      scientific: "C♯0/D♭0",
      german: "Cis2/Des2",
      piano: "-7",
      latin: "Do-1#",
      keyboard: ""),
  14: MIDIKey(
      midi: "14",
      color: "common_color_white",
      frequency: "18.35405",
      helmholtz: "D͵͵",
      scientific: "D0",
      german: "D2",
      piano: "-6",
      latin: "Re-1",
      keyboard: ""),
  15: MIDIKey(
      midi: "15",
      color: "common_color_black",
      frequency: "19.44544",
      helmholtz: "D♯͵͵/E♭͵͵",
      scientific: "D♯0/E♭0",
      german: "Dis2/Es2",
      piano: "-5",
      latin: "Re-1#",
      keyboard: ""),
  16: MIDIKey(
      midi: "16",
      color: "common_color_white",
      frequency: "20.60172",
      helmholtz: "E͵͵",
      scientific: "E0",
      german: "E2",
      piano: "-4",
      latin: "Mi-1",
      keyboard: ""),
  17: MIDIKey(
      midi: "17",
      color: "common_color_white",
      frequency: "21.82676",
      helmholtz: "F͵͵",
      scientific: "F0",
      german: "F2",
      piano: "-3",
      latin: "Fa-1",
      keyboard: ""),
  18: MIDIKey(
      midi: "18",
      color: "common_color_black",
      frequency: "23.12465",
      helmholtz: "F♯͵͵/G♭͵͵",
      scientific: "F♯0/G♭0",
      german: "Fis2/Ges2",
      piano: "-2",
      latin: "Fa-1#",
      keyboard: ""),
  19: MIDIKey(
      midi: "19",
      color: "common_color_white",
      frequency: "24.49971",
      helmholtz: "G͵͵",
      scientific: "G0",
      german: "G2",
      piano: "-1",
      latin: "SOl-1",
      keyboard: ""),
  20: MIDIKey(
      midi: "20",
      color: "common_color_black",
      frequency: "25.95654",
      helmholtz: "G♯͵͵/A♭͵͵",
      scientific: "G♯0/A♭0",
      german: "Gis2/As2",
      piano: "0",
      latin: "Sol-1#",
      keyboard: ""),
  21: MIDIKey(
      midi: "21",
      color: "common_color_white",
      frequency: "27.50000",
      helmholtz: "A͵͵",
      scientific: "A0",
      german: "A2",
      piano: "1",
      latin: "La-1",
      keyboard: ""),
  22: MIDIKey(
      midi: "22",
      color: "common_color_black",
      frequency: "29.13524",
      helmholtz: "A♯͵͵/B♭͵͵",
      scientific: "A♯0/B♭0",
      german: "Ais2/B2",
      piano: "2",
      latin: "La-1#",
      keyboard: ""),
  23: MIDIKey(
      midi: "23",
      color: "common_color_white",
      frequency: "30.86771",
      helmholtz: "B͵͵",
      scientific: "B0",
      german: "H2",
      piano: "3",
      latin: "Si-1",
      keyboard: ""),
  24: MIDIKey(
      midi: "24",
      color: "common_color_white",
      frequency: "32.70320",
      helmholtz: "C͵ contra-octave",
      scientific: "C1 Pedal C",
      german: "C1",
      piano: "4",
      latin: "Do0",
      keyboard: ""),
  25: MIDIKey(
      midi: "25",
      color: "common_color_black",
      frequency: "34.64783",
      helmholtz: "C♯͵/D♭͵",
      scientific: "C♯1/D♭1",
      german: "Cis1/Des1",
      piano: "5",
      latin: "Do0#",
      keyboard: ""),
  26: MIDIKey(
      midi: "26",
      color: "common_color_white",
      frequency: "36.70810",
      helmholtz: "D͵",
      scientific: "D1",
      german: "D1",
      piano: "6",
      latin: "Re0",
      keyboard: ""),
  27: MIDIKey(
      midi: "27",
      color: "common_color_black",
      frequency: "38.89087",
      helmholtz: "D♯͵/E♭͵",
      scientific: "D♯1/E♭1",
      german: "Dis1/Es1",
      piano: "7",
      latin: "Re0#",
      keyboard: ""),
  28: MIDIKey(
      midi: "28",
      color: "common_color_white",
      frequency: "41.20344",
      helmholtz: "E͵",
      scientific: "E1",
      german: "E1",
      piano: "8",
      latin: "Mi0",
      keyboard: ""),
  29: MIDIKey(
      midi: "29",
      color: "common_color_white",
      frequency: "43.65353",
      helmholtz: "F͵",
      scientific: "F1",
      german: "F1",
      piano: "9",
      latin: "Fa0",
      keyboard: ""),
  30: MIDIKey(
      midi: "30",
      color: "common_color_black",
      frequency: "46.24930",
      helmholtz: "F♯͵/G♭͵",
      scientific: "F♯1/G♭1",
      german: "Fis1/Ges1",
      piano: "10",
      latin: "Fa0#",
      keyboard: ""),
  31: MIDIKey(
      midi: "31",
      color: "common_color_white",
      frequency: "48.99943",
      helmholtz: "G͵",
      scientific: "G1",
      german: "G1",
      piano: "11",
      latin: "Sol0",
      keyboard: ""),
  32: MIDIKey(
      midi: "32",
      color: "common_color_black",
      frequency: "51.91309",
      helmholtz: "G♯͵/A♭͵",
      scientific: "G♯1/A♭1",
      german: "Gis1/As1",
      piano: "12",
      latin: "Sol0#",
      keyboard: ""),
  33: MIDIKey(
      midi: "33",
      color: "common_color_white",
      frequency: "55.00000",
      helmholtz: "A͵",
      scientific: "A1",
      german: "A1",
      piano: "13",
      latin: "La0",
      keyboard: ""),
  34: MIDIKey(
      midi: "34",
      color: "common_color_black",
      frequency: "58.27047",
      helmholtz: "A♯͵/B♭͵",
      scientific: "A♯1/B♭1",
      german: "Ais1/B1",
      piano: "14",
      latin: "La0#",
      keyboard: ""),
  35: MIDIKey(
      midi: "35",
      color: "common_color_white",
      frequency: "61.73541",
      helmholtz: "B͵",
      scientific: "B1",
      german: "H1",
      piano: "15",
      latin: "Si0",
      keyboard: ""),
  36: MIDIKey(
      midi: "36",
      color: "common_color_white",
      frequency: "65.40639",
      helmholtz: "C great octave",
      scientific: "C2 Deep C",
      german: "C",
      piano: "16",
      latin: "Do1",
      keyboard: "1"),
  37: MIDIKey(
      midi: "37",
      color: "common_color_black",
      frequency: "69.29566",
      helmholtz: "C♯/D♭",
      scientific: "C♯2/D♭2",
      german: "Cis/Des",
      piano: "17",
      latin: "Do1#",
      keyboard: "2"),
  38: MIDIKey(
      midi: "38",
      color: "common_color_white",
      frequency: "73.41619",
      helmholtz: "D",
      scientific: "D2",
      german: "D",
      piano: "18",
      latin: "Re1",
      keyboard: "3"),
  39: MIDIKey(
      midi: "39",
      color: "common_color_black",
      frequency: "77.78175",
      helmholtz: "D♯/E♭",
      scientific: "D♯2/E♭2",
      german: "Dis/Es",
      piano: "19",
      latin: "Re1#",
      keyboard: "4"),
  40: MIDIKey(
      midi: "40",
      color: "common_color_white",
      frequency: "82.40689",
      helmholtz: "E",
      scientific: "E2",
      german: "E",
      piano: "20",
      latin: "Mi1",
      keyboard: "5"),
  41: MIDIKey(
      midi: "41",
      color: "common_color_white",
      frequency: "87.30706",
      helmholtz: "F",
      scientific: "F2",
      german: "F",
      piano: "21",
      latin: "Fa1",
      keyboard: "6"),
  42: MIDIKey(
      midi: "42",
      color: "common_color_black",
      frequency: "92.49861",
      helmholtz: "F♯/G♭",
      scientific: "F♯2/G♭2",
      german: "Fis/Ges",
      piano: "22",
      latin: "Fa1#",
      keyboard: "7"),
  43: MIDIKey(
      midi: "43",
      color: "common_color_white",
      frequency: "97.99886",
      helmholtz: "G",
      scientific: "G2",
      german: "G",
      piano: "23",
      latin: "Sol1",
      keyboard: "8"),
  44: MIDIKey(
      midi: "44",
      color: "common_color_black",
      frequency: "103.8262",
      helmholtz: "G♯/A♭",
      scientific: "G♯2/A♭2",
      german: "Gis/As",
      piano: "24",
      latin: "Sol1#",
      keyboard: "9"),
  45: MIDIKey(
      midi: "45",
      color: "common_color_white",
      frequency: "110.0000",
      helmholtz: "A",
      scientific: "A2",
      german: "A",
      piano: "25",
      latin: "La1",
      keyboard: "10"),
  46: MIDIKey(
      midi: "46",
      color: "common_color_black",
      frequency: "116.5409",
      helmholtz: "A♯/B♭",
      scientific: "A♯2/B♭2",
      german: "Ais/B",
      piano: "26",
      latin: "La1#",
      keyboard: "11"),
  47: MIDIKey(
      midi: "47",
      color: "common_color_white",
      frequency: "123.4708",
      helmholtz: "B",
      scientific: "B2",
      german: "H",
      piano: "27",
      latin: "Si1",
      keyboard: "12"),
  48: MIDIKey(
      midi: "48",
      color: "common_color_white",
      frequency: "130.8128",
      helmholtz: "c small octave",
      scientific: "C3",
      german: "c",
      piano: "28",
      latin: "Do2",
      keyboard: "13"),
  49: MIDIKey(
      midi: "49",
      color: "common_color_black",
      frequency: "138.5913",
      helmholtz: "c♯/d♭",
      scientific: "C♯3/D♭3",
      german: "cis/des",
      piano: "29",
      latin: "Do2#",
      keyboard: "14"),
  50: MIDIKey(
      midi: "50",
      color: "common_color_white",
      frequency: "146.8324",
      helmholtz: "d",
      scientific: "D3",
      german: "d",
      piano: "30",
      latin: "Re2",
      keyboard: "15"),
  51: MIDIKey(
      midi: "51",
      color: "common_color_black",
      frequency: "155.5635",
      helmholtz: "d♯/e♭",
      scientific: "D♯3/E♭3",
      german: "dis/es",
      piano: "31",
      latin: "Re2#",
      keyboard: "16"),
  52: MIDIKey(
      midi: "52",
      color: "common_color_white",
      frequency: "164.8138",
      helmholtz: "e",
      scientific: "E3",
      german: "e",
      piano: "32",
      latin: "Mi2",
      keyboard: "17"),
  53: MIDIKey(
      midi: "53",
      color: "common_color_white",
      frequency: "174.6141",
      helmholtz: "f",
      scientific: "F3",
      german: "f",
      piano: "33",
      latin: "Fa2",
      keyboard: "18"),
  54: MIDIKey(
      midi: "54",
      color: "common_color_black",
      frequency: "184.9972",
      helmholtz: "f♯/g♭",
      scientific: "F♯3/G♭3",
      german: "fis/ges",
      piano: "34",
      latin: "Fa2#",
      keyboard: "19"),
  55: MIDIKey(
      midi: "55",
      color: "common_color_white",
      frequency: "195.9977",
      helmholtz: "g",
      scientific: "G3",
      german: "g",
      piano: "35",
      latin: "Sol2",
      keyboard: "20"),
  56: MIDIKey(
      midi: "56",
      color: "common_color_black",
      frequency: "207.6523",
      helmholtz: "g♯/a♭",
      scientific: "G♯3/A♭3",
      german: "gis/as",
      piano: "36",
      latin: "Sol2#",
      keyboard: "21"),
  57: MIDIKey(
      midi: "57",
      color: "common_color_white",
      frequency: "220.0000",
      helmholtz: "a",
      scientific: "A3",
      german: "a",
      piano: "37",
      latin: "La2",
      keyboard: "22"),
  58: MIDIKey(
      midi: "58",
      color: "common_color_black",
      frequency: "233.0819",
      helmholtz: "a♯/b♭",
      scientific: "A♯3/B♭3",
      german: "ais/b",
      piano: "38",
      latin: "La2#",
      keyboard: "23"),
  59: MIDIKey(
      midi: "59",
      color: "common_color_white",
      frequency: "246.9417",
      helmholtz: "b",
      scientific: "B3",
      german: "h",
      piano: "39",
      latin: "Si2",
      keyboard: "24"),
  60: MIDIKey(
      midi: "60",
      color: "common_color_white",
      frequency: "261.6256",
      helmholtz: "c′ 1-line octave",
      scientific: "C4 Middle C",
      german: "c1",
      piano: "40",
      latin: "Do3",
      keyboard: "25"),
  61: MIDIKey(
      midi: "61",
      color: "common_color_black",
      frequency: "277.1826",
      helmholtz: "c♯′/d♭′",
      scientific: "C♯4/D♭4",
      german: "cis1/des1",
      piano: "41",
      latin: "Do3#",
      keyboard: "26"),
  62: MIDIKey(
      midi: "62",
      color: "common_color_white",
      frequency: "293.6648",
      helmholtz: "d′",
      scientific: "D4",
      german: "d1",
      piano: "42",
      latin: "Re3",
      keyboard: "27"),
  63: MIDIKey(
      midi: "63",
      color: "common_color_black",
      frequency: "311.1270",
      helmholtz: "d♯′/e♭′",
      scientific: "D♯4/E♭4",
      german: "dis1/es1",
      piano: "43",
      latin: "Re3#",
      keyboard: "28"),
  64: MIDIKey(
      midi: "64",
      color: "common_color_white",
      frequency: "329.6276",
      helmholtz: "e′",
      scientific: "E4",
      german: "e1",
      piano: "44",
      latin: "Mi3",
      keyboard: "29"),
  65: MIDIKey(
      midi: "65",
      color: "common_color_white",
      frequency: "349.2282",
      helmholtz: "f′",
      scientific: "F4",
      german: "f1",
      piano: "45",
      latin: "Fa3",
      keyboard: "30"),
  66: MIDIKey(
      midi: "66",
      color: "common_color_black",
      frequency: "369.9944",
      helmholtz: "f♯′/g♭′",
      scientific: "F♯4/G♭4",
      german: "fis1/ges1",
      piano: "46",
      latin: "Fa3#",
      keyboard: "31"),
  67: MIDIKey(
      midi: "67",
      color: "common_color_white",
      frequency: "391.9954",
      helmholtz: "g′",
      scientific: "G4",
      german: "g1",
      piano: "47",
      latin: "Sol3",
      keyboard: "32"),
  68: MIDIKey(
      midi: "68",
      color: "common_color_black",
      frequency: "415.3047",
      helmholtz: "g♯′/a♭′",
      scientific: "G♯4/A♭4",
      german: "gis1/as1",
      piano: "48",
      latin: "Sol3#",
      keyboard: "33"),
  69: MIDIKey(
      midi: "69",
      color: "common_color_white",
      frequency: "440.0000",
      helmholtz: "a′",
      scientific: "A4 A440",
      german: "a1",
      piano: "49",
      latin: "La3",
      keyboard: "34"),
  70: MIDIKey(
      midi: "70",
      color: "common_color_black",
      frequency: "466.1638",
      helmholtz: "a♯′/b♭′",
      scientific: "A♯4/B♭4",
      german: "ais1/b1",
      piano: "50",
      latin: "La3#",
      keyboard: "35"),
  71: MIDIKey(
      midi: "71",
      color: "common_color_white",
      frequency: "493.8833",
      helmholtz: "b′",
      scientific: "B4",
      german: "h1",
      piano: "51",
      latin: "Si3",
      keyboard: "36"),
  72: MIDIKey(
      midi: "72",
      color: "common_color_white",
      frequency: "523.2511",
      helmholtz: "c′′ 2-line octave",
      scientific: "C5 Tenor C",
      german: "c2",
      piano: "52",
      latin: "Do4",
      keyboard: "37"),
  73: MIDIKey(
      midi: "73",
      color: "common_color_black",
      frequency: "554.3653",
      helmholtz: "c♯′′/d♭′′",
      scientific: "C♯5/D♭5",
      german: "cis2/des2",
      piano: "53",
      latin: "Do4#",
      keyboard: "38"),
  74: MIDIKey(
      midi: "74",
      color: "common_color_white",
      frequency: "587.3295",
      helmholtz: "d′′",
      scientific: "D5",
      german: "d2",
      piano: "54",
      latin: "Re4",
      keyboard: "39"),
  75: MIDIKey(
      midi: "75",
      color: "common_color_black",
      frequency: "622.2540",
      helmholtz: "d♯′′/e♭′′",
      scientific: "D♯5/E♭5",
      german: "dis2/es2",
      piano: "55",
      latin: "Re4#",
      keyboard: "40"),
  76: MIDIKey(
      midi: "76",
      color: "common_color_white",
      frequency: "659.2551",
      helmholtz: "e′′",
      scientific: "E5",
      german: "e2",
      piano: "56",
      latin: "Mi4",
      keyboard: "41"),
  77: MIDIKey(
      midi: "77",
      color: "common_color_white",
      frequency: "698.4565",
      helmholtz: "f′′",
      scientific: "F5",
      german: "f2",
      piano: "57",
      latin: "Fa4",
      keyboard: "42"),
  78: MIDIKey(
      midi: "78",
      color: "common_color_black",
      frequency: "739.9888",
      helmholtz: "f♯′′/g♭′′",
      scientific: "F♯5/G♭5",
      german: "fis2/ges2",
      piano: "58",
      latin: "Fa4#",
      keyboard: "43"),
  79: MIDIKey(
      midi: "79",
      color: "common_color_white",
      frequency: "783.9909",
      helmholtz: "g′′",
      scientific: "G5",
      german: "g2",
      piano: "59",
      latin: "Sol4",
      keyboard: "44"),
  80: MIDIKey(
      midi: "80",
      color: "common_color_black",
      frequency: "830.6094",
      helmholtz: "g♯′′/a♭′′",
      scientific: "G♯5/A♭5",
      german: "gis2/as2",
      piano: "60",
      latin: "Sol4#",
      keyboard: "45"),
  81: MIDIKey(
      midi: "81",
      color: "common_color_white",
      frequency: "880.0000",
      helmholtz: "a′′",
      scientific: "A5",
      german: "a2",
      piano: "61",
      latin: "La4",
      keyboard: "46"),
  82: MIDIKey(
      midi: "82",
      color: "common_color_black",
      frequency: "932.3275",
      helmholtz: "a♯′′/b♭′′",
      scientific: "A♯5/B♭5",
      german: "ais2/b2",
      piano: "62",
      latin: "La4#",
      keyboard: "47"),
  83: MIDIKey(
      midi: "83",
      color: "common_color_white",
      frequency: "987.7666",
      helmholtz: "b′′",
      scientific: "B5",
      german: "h2",
      piano: "63",
      latin: "Si4",
      keyboard: "48"),
  84: MIDIKey(
      midi: "84",
      color: "common_color_white",
      frequency: "1046.502",
      helmholtz: "c′′′ 3-line octave",
      scientific: "C6 Soprano C (High C)",
      german: "c3",
      piano: "64",
      latin: "Do5",
      keyboard: "49"),
  85: MIDIKey(
      midi: "85",
      color: "common_color_black",
      frequency: "1108.731",
      helmholtz: "c♯′′′/d♭′′′",
      scientific: "C♯6/D♭6",
      german: "cis3/des3",
      piano: "65",
      latin: "Do5#",
      keyboard: "50"),
  86: MIDIKey(
      midi: "86",
      color: "common_color_white",
      frequency: "1174.659",
      helmholtz: "d′′′",
      scientific: "D6",
      german: "d3",
      piano: "66",
      latin: "Re5",
      keyboard: "51"),
  87: MIDIKey(
      midi: "87",
      color: "common_color_black",
      frequency: "1244.508",
      helmholtz: "d♯′′′/e♭′′′",
      scientific: "D♯6/E♭6",
      german: "dis3/es3",
      piano: "67",
      latin: "Re5#",
      keyboard: "52"),
  88: MIDIKey(
      midi: "88",
      color: "common_color_white",
      frequency: "1318.510",
      helmholtz: "e′′′",
      scientific: "E6",
      german: "e3",
      piano: "68",
      latin: "Mi5",
      keyboard: "53"),
  89: MIDIKey(
      midi: "89",
      color: "common_color_white",
      frequency: "1396.913",
      helmholtz: "f′′′",
      scientific: "F6",
      german: "f3",
      piano: "69",
      latin: "Fa5",
      keyboard: "54"),
  90: MIDIKey(
      midi: "90",
      color: "common_color_black",
      frequency: "1479.978",
      helmholtz: "f♯′′′/g♭′′′",
      scientific: "F♯6/G♭6",
      german: "fis3/ges3",
      piano: "70",
      latin: "Fa5#",
      keyboard: "55"),
  91: MIDIKey(
      midi: "91",
      color: "common_color_white",
      frequency: "1567.982",
      helmholtz: "g′′′",
      scientific: "G6",
      german: "g3",
      piano: "71",
      latin: "Sol5",
      keyboard: "56"),
  92: MIDIKey(
      midi: "92",
      color: "common_color_black",
      frequency: "1661.219",
      helmholtz: "g♯′′′/a♭′′′",
      scientific: "G♯6/A♭6",
      german: "gis3/as3",
      piano: "72",
      latin: "Sol5#",
      keyboard: "57"),
  93: MIDIKey(
      midi: "93",
      color: "common_color_white",
      frequency: "1760.000",
      helmholtz: "a′′′",
      scientific: "A6",
      german: "a3",
      piano: "73",
      latin: "La5",
      keyboard: "58"),
  94: MIDIKey(
      midi: "94",
      color: "common_color_black",
      frequency: "1864.655",
      helmholtz: "a♯′′′/b♭′′′",
      scientific: "A♯6/B♭6",
      german: "ais3/b3",
      piano: "74",
      latin: "La5#",
      keyboard: "59"),
  95: MIDIKey(
      midi: "95",
      color: "common_color_white",
      frequency: "1975.533",
      helmholtz: "b′′′",
      scientific: "B6",
      german: "h3",
      piano: "75",
      latin: "Si5",
      keyboard: "60"),
  96: MIDIKey(
      midi: "96",
      color: "common_color_white",
      frequency: "2093.005",
      helmholtz: "c′′′′ 4-line octave",
      scientific: "C7 Double high C",
      german: "c4",
      piano: "76",
      latin: "Do6",
      keyboard: "61"),
  97: MIDIKey(
      midi: "97",
      color: "common_color_black",
      frequency: "2217.461",
      helmholtz: "c♯′′′′/d♭′′′′",
      scientific: "C♯7/D♭7",
      german: "cis4/des4",
      piano: "77",
      latin: "Do6#",
      keyboard: ""),
  98: MIDIKey(
      midi: "98",
      color: "common_color_white",
      frequency: "2349.318",
      helmholtz: "d′′′′",
      scientific: "D7",
      german: "d4",
      piano: "78",
      latin: "Re6",
      keyboard: ""),
  99: MIDIKey(
      midi: "99",
      color: "common_color_black",
      frequency: "2489.016",
      helmholtz: "d♯′′′′/e♭′′′′",
      scientific: "D♯7/E♭7",
      german: "dis4/es4",
      piano: "79",
      latin: "Re6#",
      keyboard: ""),
  100: MIDIKey(
      midi: "100",
      color: "common_color_white",
      frequency: "2637.020",
      helmholtz: "e′′′′",
      scientific: "E7",
      german: "e4",
      piano: "80",
      latin: "Mi6",
      keyboard: ""),
  101: MIDIKey(
      midi: "101",
      color: "common_color_white",
      frequency: "2793.826",
      helmholtz: "f′′′′",
      scientific: "F7",
      german: "f4",
      piano: "81",
      latin: "Fa6",
      keyboard: ""),
  102: MIDIKey(
      midi: "102",
      color: "common_color_black",
      frequency: "2959.955",
      helmholtz: "f♯′′′′/g♭′′′′",
      scientific: "F♯7/G♭7",
      german: "fis4/ges4",
      piano: "82",
      latin: "Fa6#",
      keyboard: ""),
  103: MIDIKey(
      midi: "103",
      color: "common_color_white",
      frequency: "3135.963",
      helmholtz: "g′′′′",
      scientific: "G7",
      german: "g4",
      piano: "84",
      latin: "Sol6",
      keyboard: ""),
  104: MIDIKey(
      midi: "104",
      color: "common_color_black",
      frequency: "3322.438",
      helmholtz: "g♯′′′′/a♭′′′′",
      scientific: "G♯7/A♭7",
      german: "gis4/as4",
      piano: "84",
      latin: "Sol6#",
      keyboard: ""),
  105: MIDIKey(
      midi: "105",
      color: "common_color_white",
      frequency: "3520.000",
      helmholtz: "a′′′′",
      scientific: "A7",
      german: "a4",
      piano: "85",
      latin: "La6",
      keyboard: ""),
  106: MIDIKey(
      midi: "106",
      color: "common_color_black",
      frequency: "3729.310",
      helmholtz: "a♯′′′′/b♭′′′′",
      scientific: "A♯7/B♭7",
      german: "ais4/b4",
      piano: "86",
      latin: "La6#",
      keyboard: ""),
  107: MIDIKey(
      midi: "107",
      color: "common_color_white",
      frequency: "3951.066",
      helmholtz: "b′′′′",
      scientific: "B7",
      german: "h4",
      piano: "87",
      latin: "Si6",
      keyboard: ""),
  108: MIDIKey(
      midi: "108",
      color: "common_color_white",
      frequency: "4186.009",
      helmholtz: "c′′′′′ 5-line octave",
      scientific: "C8 Eighth octave",
      german: "c5",
      piano: "88",
      latin: "Do7",
      keyboard: ""),
  109: MIDIKey(
      midi: "109",
      color: "common_color_black",
      frequency: "4434.922",
      helmholtz: "c♯′′′′′/d♭′′′′′",
      scientific: "C♯8/D♭8",
      german: "cis5/des5",
      piano: "89",
      latin: "Do7#",
      keyboard: ""),
  110: MIDIKey(
      midi: "110",
      color: "common_color_white",
      frequency: "4698.636",
      helmholtz: "d′′′′′",
      scientific: "D8",
      german: "d5",
      piano: "90",
      latin: "Re7",
      keyboard: ""),
  111: MIDIKey(
      midi: "111",
      color: "common_color_black",
      frequency: "4978.032",
      helmholtz: "d♯′′′′′/e♭′′′′′",
      scientific: "D♯8/E♭8",
      german: "dis5/es5",
      piano: "91",
      latin: "Re7#",
      keyboard: ""),
  112: MIDIKey(
      midi: "112",
      color: "common_color_white",
      frequency: "5274.041",
      helmholtz: "e′′′′′",
      scientific: "E8",
      german: "e5",
      piano: "92",
      latin: "Mi7",
      keyboard: ""),
  113: MIDIKey(
      midi: "113",
      color: "common_color_white",
      frequency: "5587.652",
      helmholtz: "f′′′′′",
      scientific: "F8",
      german: "f5",
      piano: "93",
      latin: "Fa7",
      keyboard: ""),
  114: MIDIKey(
      midi: "114",
      color: "common_color_black",
      frequency: "5919.911",
      helmholtz: "f♯′′′′′/g♭′′′′′",
      scientific: "F♯8/G♭8",
      german: "fis5/ges5",
      piano: "94",
      latin: "Fa7#",
      keyboard: ""),
  115: MIDIKey(
      midi: "115",
      color: "common_color_white",
      frequency: "6271.927",
      helmholtz: "g′′′′′",
      scientific: "G8",
      german: "g5",
      piano: "95",
      latin: "Sol7",
      keyboard: ""),
  116: MIDIKey(
      midi: "116",
      color: "common_color_black",
      frequency: "6644.875",
      helmholtz: "g♯′′′′′/a♭′′′′′",
      scientific: "G♯8/A♭8",
      german: "gis5/as5",
      piano: "96",
      latin: "Sol7#",
      keyboard: ""),
  117: MIDIKey(
      midi: "117",
      color: "common_color_white",
      frequency: "7040.000",
      helmholtz: "a′′′′′",
      scientific: "A8",
      german: "a5",
      piano: "97",
      latin: "La7",
      keyboard: ""),
  118: MIDIKey(
      midi: "118",
      color: "common_color_black",
      frequency: "7458.620",
      helmholtz: "a♯′′′′′/b♭′′′′′",
      scientific: "A♯8/B♭8",
      german: "ais5/b5",
      piano: "98",
      latin: "La6#",
      keyboard: ""),
  119: MIDIKey(
      midi: "119",
      color: "common_color_white",
      frequency: "7902.133",
      helmholtz: "b′′′′′",
      scientific: "B8",
      german: "h5",
      piano: "99",
      latin: "Si7",
      keyboard: ""),
  120: MIDIKey(
      midi: "120",
      color: "common_color_white",
      frequency: "8372.02",
      helmholtz: "c′′′′′",
      scientific: "C9",
      german: "",
      piano: "",
      latin: "",
      keyboard: ""),
  121: MIDIKey(
      midi: "121",
      color: "common_color_black",
      frequency: "8869.84",
      helmholtz: "c♯’’’’’’/d♭’’’’’’",
      scientific: "C#9/Db9",
      german: "cis’’’’’’/des’’’’’’",
      piano: "",
      latin: "",
      keyboard: ""),
  122: MIDIKey(
      midi: "122",
      color: "common_color_white",
      frequency: "9397.27",
      helmholtz: "d’’’’’’",
      scientific: "D9",
      german: "d’’’’’’",
      piano: "",
      latin: "",
      keyboard: ""),
  123: MIDIKey(
      midi: "123",
      color: "common_color_black",
      frequency: "9956.06",
      helmholtz: "d♯’’’’’’/e♭’’’’’’",
      scientific: "D#9/Eb9",
      german: "dis’’’’’’/es’’’’’’",
      piano: "",
      latin: "",
      keyboard: ""),
  124: MIDIKey(
      midi: "125",
      color: "common_color_white",
      frequency: "10548.08",
      helmholtz: "e’’’’’’",
      scientific: "E9",
      german: "e’’’’’’",
      piano: "",
      latin: "",
      keyboard: ""),
  125: MIDIKey(
      midi: "125",
      color: "common_color_white",
      frequency: "11175.30",
      helmholtz: "f’’’’’’",
      scientific: "F9",
      german: "	f’’’’’’",
      piano: "",
      latin: "",
      keyboard: ""),
  126: MIDIKey(
      midi: "126",
      color: "common_color_black",
      frequency: "11839.82",
      helmholtz: "f♯’’’’’’/g♭’’’’’’",
      scientific: "F#9/Gb9",
      german: "fis’’’’’’/ges’’’’’’",
      piano: "",
      latin: "",
      keyboard: ""),
  127: MIDIKey(
      midi: "127",
      color: "common_color_white",
      frequency: "12543.85",
      helmholtz: "g’’’’’’",
      scientific: "G9",
      german: "g’’’’’’",
      piano: "",
      latin: "",
      keyboard: ""),
};

const Map<int, String> MIDI_INSTRUMENTS = {
  // https://en.wikipedia.org/wiki/General_MIDI#Program_change_events
//Piano
  1: "Acoustic Grand Piano or Piano 1",
  2: "Bright Acoustic Piano or Piano 2",
  3: "Electric Grand Piano or Piano 3 (usually modeled after Yamaha CP-70)",
  4: "Honky-tonk Piano",
  5: "Electric Piano 1 (usually a Rhodes or Wurlitzer piano)",
  6: "Electric Piano 2 (usually an FM piano patch, often chorused)",
  7: "Harpsichord (often with a fixed velocity level)",
  8: "Clavinet",
// Chromatic Percussion
  9: "Celesta",
  10: "Glockenspiel",
  11: "Music Box",
  12: "Vibraphone",
  13: "Marimba",
  14: "Xylophone",
  15: "Tubular Bells",
  16: "Dulcimer or Santoor",
// Organ
  17: "Drawbar Organ or Organ 1",
  18: "Percussive Organ or Organ 2",
  19: "Rock Organ or Organ 3",
  20: "Church Organ",
  21: "Reed Organ",
  22: "Accordion",
  23: "Harmonica",
  24: "Bandoneon or Tango Accordion",
// Guitar
// In most synthesizer interpretations, guitar and bass sounds are set an octave lower than other instruments.
// 25 Acoustic Guitar (nylon)
// 26 Acoustic Guitar (steel)
// 27 Electric Guitar (jazz)
// 28 Electric Guitar (clean, often chorused, resembling a Stratocaster run through a Roland Jazz Chorus amplifier)
// 29 Electric Guitar (muted)
// 30 Overdriven Guitar
// 31 Distortion Guitar
// 32 Guitar Harmonics
// Bass
// 33 Acoustic Bass
// 34 Electric Bass (finger)
// 35 Electric Bass (picked)
// 36 Fretless Bass
// 37 Slap Bass 1
// 38 Slap Bass 2
// 39 Synth Bass 1
// 40 Synth Bass 2
// Strings
// 41 Violin
// 42 Viola
// 43 Cello
// 44 Contrabass
// 45 Tremolo Strings
// 46 Pizzicato Strings
// 47 Orchestral Harp
// 48 Timpani
// Ensemble
// 49 String Ensemble 1 (often in marcato)
// 50 String Ensemble 2 (slower attack than String Ensemble 1)
// 51 Synth Strings 1
// 52 Synth Strings 2
// 53 Choir Aahs
// 54 Voice Oohs (or Doos)
// 55 Synth Voice or Synth Choir
// 56 Orchestra Hit
// Brass
// 57 Trumpet
// 58 Trombone
// 59 Tuba
// 60 Muted Trumpet
// 61 French Horn
// 62 Brass Section
// 63 Synth Brass 1
// 64 Synth Brass 2
// Reed
// 65 Soprano Sax
// 66 Alto Sax
// 67 Tenor Sax
// 68 Baritone Sax
// 69 Oboe
// 70 English Horn
// 71 Bassoon
// 72 Clarinet
// Pipe
// 73 Piccolo
// 74 Flute
// 75 Recorder
// 76 Pan Flute
// 77 Blown bottle
// 78 Shakuhachi
// 79 Whistle
// 80 Ocarina
// Synth Lead
// 81 Lead 1 (square, often chorused)
// 82 Lead 2 (sawtooth or saw, often chorused)
// 83 Lead 3 (calliope, usually resembling a woodwind)
// 84 Lead 4 (chiff)
// 85 Lead 5 (charang, a guitar-like lead)
// 86 Lead 6 (voice, derived from "synth voice" with faster attack)
// 87 Lead 7 (fifths)
// 88 Lead 8 (bass and lead or solo lead or sometimes mistakenly called "brass and lead")
// Synth Pad
// 89 Pad 1 (new age, pad stacked with a bell, often derived from "Fantasia" patch from Roland D-50)
// 90 Pad 2 (warm, a mellower pad with slow attack)
// 91 Pad 3 (polysynth or poly, a saw-like percussive pad resembling an early 1980s polyphonic synthesizer)
// 92 Pad 4 (choir, identical to "synth voice" with longer decay)
// 93 Pad 5 (bowed glass or bowed, a sound resembling a glass harmonica)
// 94 Pad 6 (metallic, often created from a piano or guitar sample played with the attack removed)
// 95 Pad 7 (halo, choir-like pad, often with a filter effect)
// 96 Pad 8 (sweep, pad with a pronounced "wah" filter effect)
// Synth Effects
// 97 FX 1 (rain, a bright pluck with echoing pulses that decreases in pitch)
// 98 FX 2 (soundtrack, a bright perfect fifth pad)
// 99 FX 3 (crystal, a synthesized bell sound)
// 100 FX 4 (atmosphere, usually a classical guitar-like sound)
// 101 FX 5 (brightness, bright pad stacked with choir or bell)
// 102 FX 6 (goblins, a slow-attack pad with chirping or murmuring sounds)
// 103 FX 7 (echoes or echo drops, similar to "rain")
// 104 FX 8 (sci-fi or star theme, usually an electric guitar-like pad)
// Ethnic
  105: "Sitar",
  106: "Banjo",
  107: "Shamisen",
  108: "Koto",
  109: "Kalimba",
  110: "Bag pipe",
  111: "Fiddle",
  112: "Shanai",
// Percussive
  113: "Tinkle Bell",
  114: "Agogô or cowbell",
  115: "Steel Drums",
  116: "Woodblock",
  117: "Taiko Drum or Surdo",
  118: "Melodic Tom",
  119:
      "Synth Drum (a synthesized tom-tom derived from Simmons electronic drum)",
  120: "Reverse Cymbal",
// Sound Effects
  121: "Guitar Fret Noise",
  122: "Breath Noise",
  123: "Seashore",
  124: "Bird Tweet",
  125: "Telephone Ring",
  126: "Helicopter",
  127: "Applause",
  128: "Gunshot",
};

const Map<int, String> MIDI_PERCUSSIONS = {};
// 35 Acoustic Bass Drum or Low Bass Drum
// 36 Electric Bass Drum or High Bass Drum
// 37 Side Stick
// 38 Acoustic Snare
// 39 Hand Clap
// 40 Electric Snare or Rimshot
// 41 Low Floor Tom
// 42 Closed Hi-hat
// 43 High Floor Tom
// 44 Pedal Hi-hat
// 45 Low Tom
// 46 Open Hi-hat
// 47 Low-Mid Tom
// 48 High-Mid Tom
// 49 Crash Cymbal 1
// 50 High Tom
// 51 Ride Cymbal 1
// 52 Chinese Cymbal
// 53 Ride Bell
// 54 Tambourine
// 55 Splash Cymbal
// 56 Cowbell
// 57 Crash Cymbal 2
// 58 Vibraslap
// 59 Ride Cymbal 2
// 60 High Bongo
// 61 Low Bongo
// 62 Mute High Conga
// 63 Open High Conga
// 64 Low Conga
// 65 High Timbale
// 66 Low Timbale
// 67 High Agogô
// 68 Low Agogô
// 69 Cabasa
// 70 Maracas
// 71 Short Whistle
// 72 Long Whistle
// 73 Short Güiro
// 74 Long Güiro
// 75 Claves
// 76 High Woodblock
// 77 Low Woodblock
// 78 Mute Cuíca
// 79 Open Cuíca
// 80 Mute Triangle
// 81 Open Triangle
