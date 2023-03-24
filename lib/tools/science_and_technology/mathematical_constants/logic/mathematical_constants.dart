// https://physics.nist.gov/cuu/Constants/index.html

class MathematicalConstant {
  final String? symbol;
  final String value;
  final List<String>? additional_names;
  final String? tool;

  const MathematicalConstant({
    this.symbol,
    required this.value,
    this.additional_names,
    this.tool
    
  });
}

const Map<String, MathematicalConstant> MATHEMATICAL_CONSTANTS = {
  'mathematical_constants_zero': MathematicalConstant(
    symbol: '0',
    value: '0',
  ),
  'mathematical_constants_one': MathematicalConstant(
    symbol: '1',
    value: '0',
    additional_names: ['mathematical_constants_unity'],
  ),
  'mathematical_constants_i': MathematicalConstant(
    symbol: 'i',
    value: '\u221a–1',
  ),
  'mathematical_constants_pi': MathematicalConstant(
    symbol: '\u03c0',
    value: '3.14159 26535 89793 23846 26433 83279 50288 ...',
    additional_names: [
      'mathematical_constants_archimedes',
      'mathematical_constants_circlenumber',
      'mathematical_constants_ludolph'
    ],
    tool: 'pi'
  ),
  'mathematical_constants_e': MathematicalConstant(
    symbol: 'e',
    value: '2.71828 18284 59045 23536 02874 71352 66249 ...',
    additional_names: ['mathematical_constants_eulernumber', 'mathematical_constants_napier'],
    tool: 'e'
  ),
  'mathematical_constants_phi': MathematicalConstant(
    symbol: '\u03d5',
    value: '1.61803 39887 49894 84820 ...',
    additional_names: ['mathematical_constants_goldenratio'],
    tool: 'phi'
  ),
  'mathematical_constants_silverratio': MathematicalConstant(
    symbol: 'δ\u209b',
    value: '2.41421 35623 73095 04880 16887 24209 69807 ...',
    tool: 'silverratio'
  ),
  'mathematical_constants_pythagoras': MathematicalConstant(
    symbol: '\u221a2',
    value: '1.41421 35623 73095 04880 16887 24209 69807 ...',
    additional_names: ['mathematical_constants_sqrt2'],
    tool: 'sqrt2'
  ),
  'mathematical_constants_theodorus': MathematicalConstant(
    symbol: '\u221a3',
    value: '1.73205 08075 68877 29352 74463 41505 87236 ...',
    additional_names: ['mathematical_constants_sqrt3'],
    tool: 'sqrt3'
  ),
  'mathematical_constants_sqrt5': MathematicalConstant(
    symbol: '\u221a5',
    value: '2.23606 79774 99789 69640 91736 68731 27623 ...',
    tool: 'sqrt5'
  ),
  'mathematical_constants_hitchhiker': MathematicalConstant(value: '42'),
  'mathematical_constants_sheldonprime': MathematicalConstant(value: '73'),
  'mathematical_constants_eulermascheroni': MathematicalConstant(
    symbol: '\u03b3',
    value: '0.57721 56649 01532 86060 65120 90082 40243 ...',
    additional_names: ['mathematical_constants_eulerconstant'],
  ),
  'mathematical_constants_apery': MathematicalConstant(symbol: '\u03b6(3)', value: '1.20205 69031 59594 28539 97381 61511 44999 ...'),
  'mathematical_constants_edosborwein': MathematicalConstant(symbol: 'E_B_', value: '1.60669 51524 15291 76378 33015 23190 92458 ...'),
  'mathematical_constants_ramanujansoldner': MathematicalConstant(
    symbol: '\u03bc',
    value: '1.45136 92348 83381 05028 39684 85892 02744 ...'
  ),
  'mathematical_constants_lemniscate': MathematicalConstant(symbol: '\u03D6', value: '2.62205 75542 92119 81046 48395 89891 11941 ...'),
  'mathematical_constants_legendre': MathematicalConstant(symbol: 'B_L_', value: '1.08366'),
  'mathematical_constants_conway': MathematicalConstant(
    symbol: '\u03bb',
    value: '1.30357 72690 34296 39125 70991 12152 55189 ...',
  ),
  'mathematical_constants_feigenbaum1': MathematicalConstant(
    symbol: '\u03b4',
    value: '4.66920 16091 02990 67185 32038 20466 20161 ...',
  ),
  'mathematical_constants_feigenbaum2': MathematicalConstant(
    symbol: '\u03b1',
    value: '2.50290 78750 95892 82228 39028 73218 21578 ...',
  ),
  'mathematical_constants_reciprocalfibonacci': MathematicalConstant(
    symbol: '\u03a8',
    value: '3.35988 56662 43177 55317 20113 02918 92717 ...',
  ),
  'mathematical_constants_laplacelimit': MathematicalConstant(
    value: '0.66274 34193 49181 58097 47420 97109 25290 ...',
  ),
  'mathematical_constants_twinprime': MathematicalConstant(
    symbol: 'C_2_',
    value: '0.66016 18158 46869 57392 78121 10014 55577 ...',
  ),
  'mathematical_constants_bruntwinprime': MathematicalConstant(
    symbol: 'B_2_',
    value: '1.90216 05831 04 ...',
  ),
  'mathematical_constants_universalparabolic': MathematicalConstant(
    symbol: 'P_2_',
    value: '2.29558 71493 92638 07403 42980 49189 49039 ...',
  ),
  'mathematical_constants_porter': MathematicalConstant(
    value: '1.46707 80794  ...',
  ),
  'mathematical_constants_plastic': MathematicalConstant(
    symbol: '\u03c1',
    value: '1.32471 79572 44746 02596 09088 54478 09734  ...',
    additional_names: [
      'mathematical_constants_platin',
      'mathematical_constants_minimalpisot',
      'mathematical_constants_siegel'
    ]
  ),
};
