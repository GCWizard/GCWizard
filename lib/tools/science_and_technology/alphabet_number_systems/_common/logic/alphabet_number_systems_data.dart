part of 'package:gc_wizard/tools/science_and_technology/alphabet_number_systems/_common/logic/alphabet_number_systems.dart';

// https://de.wikipedia.org/wiki/Milesisches_System
// Zahlenwerte
// hebräisch	Wert	griechisch
// Aleph	א	   1  	Alpha	  α
// Beth	 ב  	 2  	Beta  	β
// Gimel	ג	   3	  Gamma	  γ
// Daleth	ד	   4	  Delta 	δ
// He	 ה    	 5	  Epsilon	ε
// Waw	 ו  	 6	  Digamma	ϝ
// Zajin	ז	   7	  Zeta	  ζ
// Chet	ח  	   8	  Eta	    η
// Tet  	 ט	 9	  Theta	  θ
// Jod  	י	  10	  Iota	  ι
// Kaph 	כ	  20	  Kappa	  κ
// Lamed	ל	  30	  Lambda	λ
// Mem  	מ	  40	  My	    μ
// Nun  	נ	  50	  Ny	    ν
// Samech	ס	  60	  Xi	    ξ
// Ajin 	ע	  70	  Omikron	ο
// Pe   	 פ	80	  Pi	    π
// Tzade	צ	  90	  Qoppa	  ϟ
// Koph 	ק	 100	  Rho	    ρ
// Resch	ר	 200	  Sigma	  σ
// Schin	ש	 300	  Tau	    τ
// Taw  	ת	 400	  Ypsilon	υ
// Kaph 	ך	 500	  Phi	    φ
// Mem  	ם	 600	  Chi	    χ
// Nun  	ן	 700	  Psi	    ψ
// Pe   	ף	 800	  Omega	  ω
// Tzade 	ץ	 900	  Sampi	  ϡ

enum ALPHABET_NUMBER_SYSTEMS { HEBREW, MILESIAN }

const Map<String, int> _MILESIANNUMBERS_H = {
  'ρ': 100,
  'σ': 200,
  'τ': 300,
  'υ': 400,
  'φ': 500,
  'χ': 600,
  'ψ': 700,
  'ω': 800,
  '\u03E1': 900, // ϡ
  '': 0,
};
const Map<String, int> _MILESIANNUMBERS_T = {
  'ι': 10,
  'κ': 20,
  'λ': 30,
  'μ': 40,
  'ν': 50,
  'ξ': 60,
  'ο': 70,
  'π': 80,
  '\u03DF': 90, // ϟ
  '': 0,
};
const Map<String, int> _MILESIANNUMBERS_O = {
  'α': 1,
  'β': 2,
  'γ': 3,
  'δ': 4,
  'ε': 5,
  '\u03C2': 6, // ς
  'ζ': 7,
  'η': 8,
  'θ': 9,
  '': 0,
};

const Map<String, int> _HEBREWNUMBERS_H = {
  'ק': 100,
  'ר': 200,
  'ש': 300,
  'ת': 400,
  'ך': 500,
  'ם': 600,
  'ן': 700,
  'ף': 800,
  'ץ': 900,
  '': 0,
};
const Map<String, int> _HEBREWNUMBERS_T = {
  'י': 10,
  'כ': 20,
  'ל': 30,
  'מ': 40,
  'נ': 50,
  'ס': 60,
  'ע': 70,
  'פ': 80,
  'צ': 90,
  '': 0,
};
const Map<String, int> _HEBREWNUMBERS_O = {
  'א': 1,
  'ב': 2,
  'ג': 3,
  'ד': 4,
  'ה': 5,
  'ו': 6,
  'ז': 7,
  'ח': 8,
  'ט': 9,
  '': 0,
};

const ALPHABETNUMBERSYSTEMS = {
  ALPHABET_NUMBER_SYSTEMS.HEBREW: {
    1: _HEBREWNUMBERS_O,
    10: _HEBREWNUMBERS_T,
    100: _HEBREWNUMBERS_H,
  },
  ALPHABET_NUMBER_SYSTEMS.MILESIAN: {
    1: _MILESIANNUMBERS_O,
    10: _MILESIANNUMBERS_T,
    100: _MILESIANNUMBERS_H,
  },
};

List<GCWDropDownMenuItem<int>> AlphabetNumberSystemsDropwdownList(
    ALPHABET_NUMBER_SYSTEMS alphabetNumberSystem, int system) {
  return ALPHABETNUMBERSYSTEMS[alphabetNumberSystem]![system]!.entries.map((mode) {
    return GCWDropDownMenuItem(
      value: mode.value,
      child: mode.key,
    );
  }).toList();
}
