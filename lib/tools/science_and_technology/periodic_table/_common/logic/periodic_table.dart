import 'package:gc_wizard/utils/constants.dart';
import 'package:gc_wizard/utils/datetime_utils.dart';

enum GroupType { MAIN_GROUP, SUB_GROUP }

enum StateOfMatter { SOLID, LIQUID, GAS, UNKNOWN }

enum PeriodicTableCategory {
  ELEMENT_NAME,
  CHEMICAL_SYMBOL,
  ATOMIC_NUMBER,
  MASS,
  ELECTRONEGATIVITY,
  MELTING_POINT,
  BOILING_POINT,
  IUPAC_GROUP_NAME,
  IS_RADIOACTIVE,
  IS_SYNTHETIC,
  PERIOD,
  IUPAC_GROUP,
  DENSITY,
  MOST_COMMON_ISOTOP,
  HALF_LIFE,
  MAIN_GROUP,
  SUB_GROUP,
  STATE_OF_MATTER
}

enum IUPACGroupName {
  ALKALI_METALS,
  ALKALINE_EARTH_METALS,
  EARTH_METALS,
  TETRELS,
  PNICTOGENS,
  CHALCOGENS,
  HALOGENS,
  NOBLE_GASES,
  LANTHANIDES,
  ACTINIDES
}

final iupacGroupNameToString = {
  IUPACGroupName.ALKALI_METALS: 'periodictable_attribute_iupacgroupname_alkalimetals',
  IUPACGroupName.ALKALINE_EARTH_METALS: 'periodictable_attribute_iupacgroupname_alkalineearthmetals',
  IUPACGroupName.EARTH_METALS: 'periodictable_attribute_iupacgroupname_earthmetals',
  IUPACGroupName.TETRELS: 'periodictable_attribute_iupacgroupname_tetrels',
  IUPACGroupName.PNICTOGENS: 'periodictable_attribute_iupacgroupname_pnictogens',
  IUPACGroupName.CHALCOGENS: 'periodictable_attribute_iupacgroupname_chalcogens',
  IUPACGroupName.HALOGENS: 'periodictable_attribute_iupacgroupname_halogens',
  IUPACGroupName.NOBLE_GASES: 'periodictable_attribute_iupacgroupname_noblegases',
  IUPACGroupName.LANTHANIDES: 'periodictable_attribute_iupacgroupname_lanthanides',
  IUPACGroupName.ACTINIDES: 'periodictable_attribute_iupacgroupname_actinides',
};

final stateOfMatterToString = {
  StateOfMatter.SOLID: 'periodictable_attribute_stateofmatter_solid',
  StateOfMatter.LIQUID: 'periodictable_attribute_stateofmatter_liquid',
  StateOfMatter.GAS: 'periodictable_attribute_stateofmatter_gas',
  StateOfMatter.UNKNOWN: 'common_unknown'
};

class PeriodicTableElement {
  final String name;
  final String chemicalSymbol;
  final int atomicNumber;
  final double mass;
  final double electronegativity;
  final double meltingPoint;
  final double boilingPoint;
  IUPACGroupName iupacGroupName;
  final bool isRadioactive;
  final bool isSynthetic;
  final int period;
  final int iupacGroup;
  final double density;
  final int mostCommonIsotop;
  final double halfLife; //German: Halbwertszeit
  final List<String> comments;
  int mainGroup;
  int subGroup;
  StateOfMatter stateOfMatter;

  PeriodicTableElement(
      this.name,
      this.chemicalSymbol,
      this.atomicNumber,
      this.mass,
      this.electronegativity,
      this.meltingPoint,
      this.boilingPoint,
      this.isRadioactive,
      this.isSynthetic,
      this.period,
      this.iupacGroup,
      this.density,
      this.mostCommonIsotop,
      this.halfLife, //German: Halbwertszeit
      {this.comments: const []}) {
    var group = iupacGroupToMainSubGroup(iupacGroup);
    if (group['type'] == GroupType.MAIN_GROUP)
      this.mainGroup = group['value'];
    else
      this.subGroup = group['value'];

    if (this.boilingPoint == -double.infinity && this.meltingPoint == -double.infinity) {
      this.stateOfMatter = StateOfMatter.UNKNOWN;
    } else if (this.boilingPoint > -double.infinity && this.boilingPoint < 20) {
      this.stateOfMatter = StateOfMatter.GAS;
    } else if (this.meltingPoint > -double.infinity && this.meltingPoint < 20) {
      this.stateOfMatter = StateOfMatter.LIQUID;
    } else {
      this.stateOfMatter = StateOfMatter.SOLID;
    }

    switch (this.iupacGroup) {
      case 1:
        this.iupacGroupName = IUPACGroupName.ALKALI_METALS;
        break;
      case 2:
        this.iupacGroupName = IUPACGroupName.ALKALINE_EARTH_METALS;
        break;
      case 13:
        this.iupacGroupName = IUPACGroupName.EARTH_METALS;
        break;
      case 14:
        this.iupacGroupName = IUPACGroupName.TETRELS;
        break;
      case 15:
        this.iupacGroupName = IUPACGroupName.PNICTOGENS;
        break;
      case 16:
        this.iupacGroupName = IUPACGroupName.CHALCOGENS;
        break;
      case 17:
        this.iupacGroupName = IUPACGroupName.HALOGENS;
        break;
      case 18:
        this.iupacGroupName = IUPACGroupName.NOBLE_GASES;
        break;
    }

    if (this.atomicNumber >= 57 && this.atomicNumber <= 71) {
      this.iupacGroupName = IUPACGroupName.LANTHANIDES;
    } else if (this.atomicNumber >= 89 && this.atomicNumber <= 103) {
      this.iupacGroupName = IUPACGroupName.ACTINIDES;
    }
  }

  get formattedHalfLife {
    return formatDaysToNearestUnit(this.halfLife);
  }

  get formattedDensity {
    return (this.density < 0.1) ? this.density.toStringAsExponential() : this.density.toString();
  }

  @override
  String toString() {
    return 'name: $name ($chemicalSymbol, $atomicNumber)';
  }
}

Map<String, dynamic> iupacGroupToMainSubGroup(int iupacGroup) {
  var value;
  var type;

  if ([1, 2].contains(iupacGroup)) {
    type = GroupType.MAIN_GROUP;
    value = iupacGroup;
  } else if ([3, 4, 5, 6, 7].contains(iupacGroup)) {
    type = GroupType.SUB_GROUP;
    value = iupacGroup;
  } else if ([8, 9, 10].contains(iupacGroup)) {
    type = GroupType.SUB_GROUP;
    value = 8;
  } else if ([11, 12].contains(iupacGroup)) {
    type = GroupType.SUB_GROUP;
    value = iupacGroup - 10;
  } else if ([13, 14, 15, 16, 17, 18].contains(iupacGroup)) {
    type = GroupType.MAIN_GROUP;
    value = iupacGroup - 10;
  }

  return {'type': type, 'value': value};
}

final List<PeriodicTableElement> allPeriodicTableElements = [
  PeriodicTableElement('periodictable_element_hydrogen', 'H', 1, 1.0079, 2.2, -259.14, -252.87, false, false, 1, 1,
      0.00008988, 1, double.infinity),
  PeriodicTableElement('periodictable_element_helium', 'He', 2, 4.0026, double.infinity, -272.2, -268.93, false, false,
      1, 18, 0.0001785, 4, double.infinity,
      comments: ['periodictable_comment_noblegases']),
  PeriodicTableElement('periodictable_element_lithium', 'Li', 3, 6.941, 0.98, 180.54, 1342, false, false, 2, 1, 0.534,
      7, double.infinity),
  PeriodicTableElement('periodictable_element_beryllium', 'Be', 4, 9.0122, 1.57, 1287, 2469, false, false, 2, 2, 1.848,
      9, double.infinity),
  PeriodicTableElement(
      'periodictable_element_boron', 'B', 5, 10.811, 2.04, 2076, 3927, false, false, 2, 13, 2.460, 11, double.infinity),
  PeriodicTableElement(
      'periodictable_element_carbon', 'C', 6, 12.011, 2.55, 3547, 4827, false, false, 2, 14, 3.51, 12, double.infinity,
      comments: ['periodictable_comment_c']),
  PeriodicTableElement('periodictable_element_nitrogen', 'N', 7, 14.007, 3.04, -210.1, -195.79, false, false, 2, 15,
      0.00112506, 14, double.infinity),
  PeriodicTableElement('periodictable_element_oxygen', 'O', 8, 15.999, 3.44, -218.3, -182.9, false, false, 2, 16,
      0.001429, 16, double.infinity),
  PeriodicTableElement('periodictable_element_fluorine', 'F', 9, 18.998, 4.0, -219.62, -188.12, false, false, 2, 17,
      0.001695, 19, double.infinity),
  PeriodicTableElement('periodictable_element_neon', 'Ne', 10, 20.18, double.infinity, -248.59, -246.08, false, false,
      2, 18, 0.0008999, 20, double.infinity,
      comments: ['periodictable_comment_noblegases']),
  PeriodicTableElement('periodictable_element_sodium', 'Na', 11, 22.99, 0.93, 97.72, 883, false, false, 3, 1, 0.968, 23,
      double.infinity),
  PeriodicTableElement('periodictable_element_magnesium', 'Mg', 12, 24.305, 1.31, 650, 1090, false, false, 3, 2, 1.738,
      24, double.infinity),
  PeriodicTableElement('periodictable_element_aluminium', 'Al', 13, 26.982, 1.61, 660.32, 2467, false, false, 3, 13,
      2.698, 27, double.infinity),
  PeriodicTableElement('periodictable_element_silicon', 'Si', 14, 28.086, 1.90, 1410, 2355, false, false, 3, 14, 2.336,
      28, double.infinity),
  PeriodicTableElement('periodictable_element_phosphorus', 'P', 15, 30.974, 2.19, 44.2, 277, false, false, 3, 15, 1.83,
      31, double.infinity,
      comments: ['periodictable_comment_p']),
  PeriodicTableElement('periodictable_element_sulfur', 'S', 16, 32.065, 2.58, 115.21, 444.72, false, false, 3, 16,
      2.067, 32, double.infinity),
  PeriodicTableElement('periodictable_element_chlorine', 'Cl', 17, 35.453, 3.16, -101.5, -34.04, false, false, 3, 17,
      0.003215, 35, double.infinity),
  PeriodicTableElement('periodictable_element_argon', 'Ar', 18, 39.948, double.infinity, -189.3, -185.8, false, false,
      3, 18, 0.0017837, 40, double.infinity,
      comments: ['periodictable_comment_noblegases']),
  PeriodicTableElement('periodictable_element_potassium', 'K', 19, 39.098, 0.82, 63.38, 759, false, false, 4, 1, 0.862,
      39, double.infinity),
  PeriodicTableElement('periodictable_element_calcium', 'Ca', 20, 40.078, 1.00, 842, 1484, false, false, 4, 2, 1.55, 40,
      double.infinity),
  PeriodicTableElement('periodictable_element_scandium', 'Sc', 21, 44.956, 1.36, 1541, 2830, false, false, 4, 3, 2.985,
      45, double.infinity),
  PeriodicTableElement('periodictable_element_titanium', 'Ti', 22, 47.867, 1.54, 1668, 3287, false, false, 4, 4, 4.50,
      48, double.infinity),
  PeriodicTableElement('periodictable_element_vanadium', 'V', 23, 50.942, 1.63, 1910, 3407, false, false, 4, 5, 6.11,
      51, double.infinity),
  PeriodicTableElement('periodictable_element_chromium', 'Cr', 24, 51.996, 1.66, 1907, 2671, false, false, 4, 6, 7.14,
      52, double.infinity),
  PeriodicTableElement('periodictable_element_manganese', 'Mn', 25, 54.938, 1.55, 1246, 2061, false, false, 4, 7, 7.44,
      55, double.infinity),
  PeriodicTableElement(
      'periodictable_element_iron', 'Fe', 26, 55.845, 1.83, 1538, 2861, false, false, 4, 8, 7.874, 56, double.infinity),
  PeriodicTableElement('periodictable_element_cobalt', 'Co', 27, 58.933, 1.88, 1495, 2927, false, false, 4, 9, 8.90, 59,
      double.infinity),
  PeriodicTableElement('periodictable_element_nickel', 'Ni', 28, 58.693, 1.91, 1455, 2730, false, false, 4, 10, 8.908,
      58, double.infinity),
  PeriodicTableElement('periodictable_element_copper', 'Cu', 29, 63.546, 1.9, 1084.62, 2927, false, false, 4, 11, 8.92,
      63, double.infinity),
  PeriodicTableElement(
      'periodictable_element_zinc', 'Zn', 30, 65.38, 1.65, 419.53, 907, false, false, 4, 12, 7.14, 64, double.infinity),
  PeriodicTableElement('periodictable_element_gallium', 'Ga', 31, 69.723, 1.81, 29.76, 2204, false, false, 4, 13, 5.904,
      68, double.infinity),
  PeriodicTableElement('periodictable_element_germanium', 'Ge', 32, 72.64, 2.01, 938.3, 2820, false, false, 4, 14,
      5.323, 74, double.infinity),
  PeriodicTableElement(
      'periodictable_element_arsenic', 'As', 33, 74.922, 2.18, 817, 615, false, false, 4, 15, 5.72, 75, double.infinity,
      comments: ['periodictable_comment_as_1', 'periodictable_comment_as_2']),
  PeriodicTableElement('periodictable_element_selenium', 'Se', 34, 78.96, 2.55, 221, 685, false, false, 4, 16, 4.819,
      80, double.infinity),
  PeriodicTableElement('periodictable_element_bromine', 'Br', 35, 79.904, 2.96, -7.3, 59, false, false, 4, 17, 3.122,
      79, double.infinity),
  PeriodicTableElement('periodictable_element_krypton', 'Kr', 36, 83.798, 3.0, -157.36, -153.22, false, false, 4, 18,
      0.00374, 84, double.infinity,
      comments: ['periodictable_comment_mayreactwithf']),
  PeriodicTableElement('periodictable_element_rubidium', 'Rb', 37, 85.468, 0.82, 39.31, 688, false, false, 5, 1, 1.532,
      85, double.infinity),
  PeriodicTableElement('periodictable_element_strontium', 'Sr', 38, 87.62, 0.95, 777, 1382, false, false, 5, 2, 2.63,
      88, double.infinity),
  PeriodicTableElement('periodictable_element_yttrium', 'Y', 39, 88.906, 1.22, 1526, 3336, false, false, 5, 3, 4.472,
      89, double.infinity),
  PeriodicTableElement('periodictable_element_zirconium', 'Zr', 40, 91.224, 1.33, 1857, 4409, false, false, 5, 4, 6.501,
      90, double.infinity),
  PeriodicTableElement('periodictable_element_niobium', 'Nb', 41, 92.906, 1.6, 2477, 4744, false, false, 5, 5, 8.57, 93,
      double.infinity),
  PeriodicTableElement('periodictable_element_molybdenum', 'Mo', 42, 95.96, 2.16, 2623, 4639, false, false, 5, 6, 10.28,
      98, double.infinity),
  PeriodicTableElement(
      'periodictable_element_technetium', 'Tc', 43, 97.91, 1.9, 2157, 4265, true, true, 5, 7, 11.5, 98, 1.533e9,
      comments: ['periodictable_comment_tc', 'periodictable_comment_massnotexact']),
  PeriodicTableElement('periodictable_element_ruthenium', 'Ru', 44, 101.07, 2.2, 2334, 4150, false, false, 5, 8, 12.37,
      102, double.infinity),
  PeriodicTableElement('periodictable_element_rhodium', 'Rh', 45, 102.91, 2.28, 1964, 3699, false, false, 5, 9, 12.38,
      103, double.infinity),
  PeriodicTableElement('periodictable_element_palladium', 'Pd', 46, 106.42, 2.20, 1554.9, 2963, false, false, 5, 10,
      11.99, 106, double.infinity),
  PeriodicTableElement('periodictable_element_silver', 'Ag', 47, 107.87, 1.93, 961.78, 2162, false, false, 5, 11, 10.49,
      107, double.infinity),
  PeriodicTableElement('periodictable_element_cadmium', 'Cd', 48, 112.41, 1.69, 321.07, 767, false, false, 5, 12, 8.65,
      114, double.infinity),
  PeriodicTableElement('periodictable_element_indium', 'In', 49, 114.82, 1.78, 156.6, 2072, false, false, 5, 13, 7.31,
      115, double.infinity),
  PeriodicTableElement('periodictable_element_tin', 'Sn', 50, 118.72, 1.96, 231.93, 2602, false, false, 5, 14, 7.265,
      118, double.infinity,
      comments: ['periodictable_comment_sn']),
  PeriodicTableElement('periodictable_element_antimony', 'Sb', 51, 121.76, 2.05, 630.63, 1587, false, false, 5, 15,
      6.697, 121, double.infinity),
  PeriodicTableElement('periodictable_element_tellurium', 'Te', 52, 127.6, 2.1, 449.51, 988, false, false, 5, 16, 6.24,
      130, double.infinity),
  PeriodicTableElement('periodictable_element_iodine', 'I', 53, 126.9, 2.66, 113.70, 184.3, false, false, 5, 17, 4.94,
      127, double.infinity),
  PeriodicTableElement('periodictable_element_xenon', 'Xe', 54, 131.29, 2.6, -111.7, -108.0, false, false, 5, 18,
      0.005898, 132, double.infinity,
      comments: ['periodictable_comment_mayreactwithf', 'periodictable_comment_xe']),
  PeriodicTableElement('periodictable_element_caesium', 'Cs', 55, 132.91, 0.79, 28.44, 671, false, false, 6, 1, 1.90,
      133, double.infinity),
  PeriodicTableElement('periodictable_element_barium', 'Ba', 56, 137.33, 0.89, 727, 1870, false, false, 6, 2, 3.62, 138,
      double.infinity),
  PeriodicTableElement('periodictable_element_lanthanum', 'La', 57, 138.91, 1.1, 920, 3470, false, false, 6, 3, 6.17,
      139, double.infinity,
      comments: ['periodictable_comment_la']),
  PeriodicTableElement('periodictable_element_cerium', 'Ce', 58, 140.12, 1.12, 795, 3360, false, false, 6, 3, 6.773,
      140, double.infinity),
  PeriodicTableElement('periodictable_element_praseodymium', 'Pr', 59, 140.91, 1.13, 935, 3290, false, false, 6, 3,
      6.475, 141, double.infinity),
  PeriodicTableElement('periodictable_element_neodymium', 'Nd', 60, 144.24, 1.14, 1024, 3100, false, false, 6, 3, 7.003,
      142, double.infinity),
  PeriodicTableElement(
      'periodictable_element_promethium', 'Pm', 61, 144.9, 1.13, 1100, 3000, true, true, 6, 3, 7.2, 145, 365 * 17.7,
      comments: ['periodictable_comment_massnotexact', 'periodictable_comment_mostcommonisotop']),
  PeriodicTableElement('periodictable_element_samarium', 'Sm', 62, 150.36, 1.17, 1072, 1803, false, false, 6, 3, 7.536,
      152, double.infinity),
  PeriodicTableElement('periodictable_element_europium', 'Eu', 63, 151.96, 1.2, 826, 1527, false, false, 6, 3, 5.245,
      153, double.infinity),
  PeriodicTableElement('periodictable_element_gadolinium', 'Gd', 64, 157.25, 1.20, 1312, 3250, false, false, 6, 3,
      7.886, 158, double.infinity),
  PeriodicTableElement('periodictable_element_terbium', 'Tb', 65, 158.93, 1.1, 1356, 3230, false, false, 6, 3, 8.253,
      159, double.infinity),
  PeriodicTableElement('periodictable_element_dysprosium', 'Dy', 66, 162.5, 1.22, 1407, 2567, false, false, 6, 3, 8.559,
      164, double.infinity),
  PeriodicTableElement('periodictable_element_holmium', 'Ho', 67, 164.93, 1.23, 1461, 2720, false, false, 6, 3, 8.78,
      165, double.infinity),
  PeriodicTableElement('periodictable_element_erbium', 'Er', 68, 167.26, 1.24, 1529, 2868, false, false, 6, 3, 9.045,
      168, double.infinity),
  PeriodicTableElement('periodictable_element_thulium', 'Tm', 69, 168.93, 1.25, 1545, 1950, false, false, 6, 3, 9.318,
      169, double.infinity),
  PeriodicTableElement('periodictable_element_ytterbium', 'Yb', 70, 173.05, 1.1, 824, 1196, false, false, 6, 3, 6.973,
      174, double.infinity),
  PeriodicTableElement('periodictable_element_lutetium', 'Lu', 71, 174.97, 1.27, 1652, 3402, false, false, 6, 3, 9.84,
      175, double.infinity),
  PeriodicTableElement('periodictable_element_hafnium', 'Hf', 72, 178.49, 1.3, 2233, 4603, false, false, 6, 4, 13.28,
      180, double.infinity),
  PeriodicTableElement('periodictable_element_tantalum', 'Ta', 73, 180.95, 1.5, 3017, 5458, false, false, 6, 5, 16.65,
      181, double.infinity),
  PeriodicTableElement('periodictable_element_tungsten', 'W', 74, 183.84, 2.36, 3422, 5555, false, false, 6, 6, 19.3,
      184, double.infinity),
  PeriodicTableElement(
      'periodictable_element_rhenium', 'Re', 75, 186.21, 1.9, 3186, 5596, true, false, 6, 7, 21.0, 187, 1.58775e13,
      comments: ['periodictable_comment_re']),
  PeriodicTableElement('periodictable_element_osmium', 'Os', 76, 190.23, 2.2, 3130, 5000, false, false, 6, 8, 22.59,
      192, double.infinity,
      comments: ['periodictable_comment_os']),
  PeriodicTableElement('periodictable_element_iridium', 'Ir', 77, 192.22, 2.20, 2466, 4428, false, false, 6, 9, 22.56,
      193, double.infinity),
  PeriodicTableElement('periodictable_element_platinum', 'Pt', 78, 195.08, 2.28, 1768.3, 3825, false, false, 6, 10,
      21.45, 195, double.infinity),
  PeriodicTableElement('periodictable_element_gold', 'Au', 79, 196.97, 2.54, 1064.18, 2856, false, false, 6, 11, 19.32,
      197, double.infinity),
  PeriodicTableElement('periodictable_element_mercury', 'Hg', 80, 200.59, 2.00, -38.83, 356.73, false, false, 6, 12,
      13.5459, 202, double.infinity),
  PeriodicTableElement('periodictable_element_thallium', 'Tl', 81, 204.38, 1.62, 304, 1473, false, false, 6, 13, 11.85,
      205, double.infinity),
  PeriodicTableElement('periodictable_element_lead', 'Pb', 82, 207.2, 2.33, 327.43, 1749, false, false, 6, 14, 11.342,
      208, double.infinity),
  PeriodicTableElement(
      'periodictable_element_bismuth', 'Bi', 83, 208.98, 2.02, 271.3, 1564, true, false, 6, 15, 9.78, 209, 6.935e21,
      comments: ['periodictable_comment_bi']),
  PeriodicTableElement('periodictable_element_polonium', 'Po', 84, 209, 2.0, 254, 962, true, false, 6, 16, 9.196, 209,
      (365 * 103).toDouble(),
      comments: ['periodictable_comment_massnotexact', 'periodictable_comment_mostcommonisotop']),
  PeriodicTableElement(
      'periodictable_element_astatine', 'At', 85, 210, 2.2, 302, 337, true, false, 6, 17, 8.75, 210, (8.1 / 24),
      comments: [
        'periodictable_comment_at',
        'periodictable_comment_massnotexact',
        'periodictable_comment_mostcommonisotop'
      ]),
  PeriodicTableElement(
      'periodictable_element_radon', 'Rn', 86, 222, double.infinity, -71, -61.8, true, false, 6, 18, 0.00973, 222, 3.82,
      comments: [
        'periodictable_comment_noblegases',
        'periodictable_comment_massnotexact',
        'periodictable_comment_mostcommonisotop'
      ]),
  PeriodicTableElement(
      'periodictable_element_francium', 'Fr', 87, 223, 0.7, 27, 677, true, false, 7, 1, 1.87, 223, (22.0 / 60 / 24),
      comments: ['periodictable_comment_massnotexact', 'periodictable_comment_mostcommonisotop']),
  PeriodicTableElement(
      'periodictable_element_radium', 'Ra', 88, 226, 0.9, 700, 1737, true, false, 7, 2, 5.5, 226, 584.73,
      comments: ['periodictable_comment_massnotexact', 'periodictable_comment_mostcommonisotop']),
  PeriodicTableElement(
      'periodictable_element_actinium', 'Ac', 89, 227, 1.1, 1050, 3300, true, false, 7, 3, 10.07, 227, 7946.05,
      comments: [
        'periodictable_comment_ac',
        'periodictable_comment_massnotexact',
        'periodictable_comment_mostcommonisotop'
      ]),
  PeriodicTableElement(
      'periodictable_element_thorium', 'Th', 90, 232.04, 1.3, 1755, 4788, true, false, 7, 3, 11.724, 232, 5.12825e12),
  PeriodicTableElement('periodictable_element_protactinium', 'Pa', 91, 231.04, 1.5, 1568, 4027, true, false, 7, 3,
      15.37, 231, 365 * 32.760,
      comments: ['periodictable_comment_pa', 'periodictable_comment_mostcommonisotop']),
  PeriodicTableElement(
      'periodictable_element_uranium', 'U', 92, 238.03, 1.38, 1133, 3930, true, false, 7, 3, 19.16, 238, 365 * 4.468e9),
  PeriodicTableElement(
      'periodictable_element_neptunium', 'Np', 93, 237.05, 1.36, 639, 3902, true, false, 7, 3, 20.45, 237, 782.56e6,
      comments: ['periodictable_comment_massnotexact', 'periodictable_comment_mostcommonisotop']),
  PeriodicTableElement(
      'periodictable_element_plutonium', 'Pu', 94, 244.05, 1.28, 639.4, 3230, true, false, 7, 3, 19.816, 244, 365 * 8e7,
      comments: ['periodictable_comment_massnotexact']),
  PeriodicTableElement(
      'periodictable_element_americium', 'Am', 95, 243.05, 1.3, 1176, 2607, true, true, 7, 3, 13.67, 243, 2690.05,
      comments: ['periodictable_comment_massnotexact', 'periodictable_comment_mostcommonisotop']),
  PeriodicTableElement(
      'periodictable_element_curium', 'Cm', 96, 247.05, 1.3, 1340, 3110, true, true, 7, 3, 13.51, 247, 569.4e7,
      comments: ['periodictable_comment_massnotexact', 'periodictable_comment_mostcommonisotop']),
  PeriodicTableElement('periodictable_element_berkelium', 'Bk', 97, 247.05, 1.30, 986, -double.infinity, true, true, 7,
      3, 14.78, 247, 503.7, comments: [
    'periodictable_comment_bk',
    'periodictable_comment_massnotexact',
    'periodictable_comment_mostcommonisotop'
  ]),
  PeriodicTableElement('periodictable_element_californium', 'Cf', 98, 251.05, 1.3, 900, 1470, true, true, 7, 3, 15.1,
      251, (365 * 898).toDouble(),
      comments: ['periodictable_comment_massnotexact', 'periodictable_comment_mostcommonisotop']),
  PeriodicTableElement(
      'periodictable_element_einsteinium', 'Es', 99, 253, 1.3, 860, 996, true, true, 7, 3, 8.84, 252, 470.85,
      comments: ['periodictable_comment_massnotexact', 'periodictable_comment_mostcommonisotop']),
  PeriodicTableElement(
      'periodictable_element_fermium', 'Fm', 100, 257, 1.3, 1527, -double.infinity, true, true, 7, 3, 9.7, 257, 100.5,
      comments: [
        'periodictable_comment_densityvaries',
        'periodictable_comment_massnotexact',
        'periodictable_comment_mostcommonisotop'
      ]),
  PeriodicTableElement('periodictable_element_mendelevium', 'Md', 101, 258, 1.3, 827, -double.infinity, true, true, 7,
      3, 10.3, 258, 51.5, comments: [
    'periodictable_comment_densityvaries',
    'periodictable_comment_massnotexact',
    'periodictable_comment_mostcommonisotop'
  ]),
  PeriodicTableElement('periodictable_element_nobelium', 'No', 102, 259, 1.3, 827, -double.infinity, true, true, 7, 3,
      9.9, 259, (58.0 / 60 / 24), comments: [
    'periodictable_comment_densityvaries',
    'periodictable_comment_massnotexact',
    'periodictable_comment_mostcommonisotop'
  ]),
  PeriodicTableElement('periodictable_element_lawrencium', 'Lr', 103, 262, 1.3, 1627, -double.infinity, true, true, 7,
      3, 16.1, 264, (10.0 / 24), comments: [
    'periodictable_comment_densityvaries',
    'periodictable_comment_massnotexact',
    'periodictable_comment_mostcommonisotop'
  ]),
  PeriodicTableElement('periodictable_element_rutherfordium', 'Rf', 104, 261.1, -double.infinity, 2100, 5500, true,
      true, 7, 4, 23.2, 265, (1.3 / 24),
      comments: ['periodictable_comment_densityvaries', 'periodictable_comment_massnotexact']),
  PeriodicTableElement('periodictable_element_dubnium', 'Db', 105, 262.1, -double.infinity, -double.infinity,
      -double.infinity, true, true, 7, 5, 29.3, 268, 1.3, comments: [
    'periodictable_comment_densityvaries',
    'periodictable_comment_massnotexact',
    'periodictable_comment_mostcommonisotop'
  ]),
  PeriodicTableElement('periodictable_element_seaborgium', 'Sg', 106, 266.1, -double.infinity, -double.infinity,
      -double.infinity, true, true, 7, 6, 35, 272, 1.0 / 24, comments: [
    'periodictable_comment_densityvaries',
    'periodictable_comment_massnotexact',
    'periodictable_comment_mostcommonisotop'
  ]),
  PeriodicTableElement('periodictable_element_bohrium', 'Bh', 107, 264.1, -double.infinity, -double.infinity,
      -double.infinity, true, true, 7, 7, 37.1, 273, 1.5 / 24, comments: [
    'periodictable_comment_densityvaries',
    'periodictable_comment_massnotexact',
    'periodictable_comment_mostcommonisotop'
  ]),
  PeriodicTableElement('periodictable_element_hassium', 'Hs', 108, 269.1, -double.infinity, -double.infinity,
      -double.infinity, true, true, 7, 8, 41, 276, 1.0 / 24, comments: [
    'periodictable_comment_densityvaries',
    'periodictable_comment_massnotexact',
    'periodictable_comment_mostcommonisotop'
  ]),
  PeriodicTableElement('periodictable_element_meitnerium', 'Mt', 109, 268.1, -double.infinity, -double.infinity,
      -double.infinity, true, true, 7, 9, 37.4, 279, 6.0 / 60 / 24, comments: [
    'periodictable_comment_densityvaries',
    'periodictable_comment_massnotexact',
    'periodictable_comment_mostcommonisotop'
  ]),
  PeriodicTableElement('periodictable_element_darmstadtium', 'Ds', 110, 272.1, -double.infinity, -double.infinity,
      -double.infinity, true, true, 7, 10, 34.8, 278, 10.0 / 60 / 60 / 24, comments: [
    'periodictable_comment_densityvaries',
    'periodictable_comment_massnotexact',
    'periodictable_comment_mostcommonisotop'
  ]),
  PeriodicTableElement('periodictable_element_roentgenium', 'Rg', 111, 272.1, -double.infinity, -double.infinity,
      -double.infinity, true, true, 7, 11, 28.7, 283, 10.0 / 60 / 24,
      comments: [
        'periodictable_comment_rg',
        'periodictable_comment_densityvaries',
        'periodictable_comment_massnotexact',
        'periodictable_comment_mostcommonisotop'
      ]),
  PeriodicTableElement('periodictable_element_copernicium', 'Cn', 112, 277, -double.infinity, 10, 67, true, true, 7, 12,
      14, 285, 34.0 / 60 / 60 / 24,
      comments: [
        'periodictable_comment_cn_1',
        'periodictable_comment_densityvaries',
        'periodictable_comment_massnotexact',
        'periodictable_comment_mostcommonisotop'
      ]),
  PeriodicTableElement('periodictable_element_nihonium', 'Nh', 113, 286, -double.infinity, 430, 1130, true, true, 7, 13,
      16, 287, 20.0 / 60 / 24,
      comments: [
        'periodictable_comment_nh',
        'periodictable_comment_densityvaries',
        'periodictable_comment_massnotexact',
        'periodictable_comment_mostcommonisotop'
      ]),
  PeriodicTableElement('periodictable_element_flerovium', 'Fl', 114, 289, -double.infinity, -double.infinity, -60, true,
      true, 7, 14, 14.0, 289, 2.7 / 60 / 60 / 24,
      comments: [
        'periodictable_comment_fl',
        'periodictable_comment_densityvaries',
        'periodictable_comment_massnotexact',
        'periodictable_comment_mostcommonisotop'
      ]),
  PeriodicTableElement('periodictable_element_moscovium', 'Mc', 115, 288, -double.infinity, 400, 1100, true, true, 7,
      15, 13.5, 291, 1.0 / 60 / 24,
      comments: [
        'periodictable_comment_mc',
        'periodictable_comment_densityvaries',
        'periodictable_comment_massnotexact',
        'periodictable_comment_mostcommonisotop'
      ]),
  PeriodicTableElement('periodictable_element_livermorium', 'Lv', 116, 292, -double.infinity, 420, 812, true, true, 7,
      16, 12.9, 293, 5.3e-2 / 60 / 60 / 24,
      comments: [
        'periodictable_comment_lv',
        'periodictable_comment_densityvaries',
        'periodictable_comment_massnotexact',
        'periodictable_comment_mostcommonisotop'
      ]),
  PeriodicTableElement('periodictable_element_tenessine', 'Ts', 117, 292, -double.infinity, 450, 610, true, true, 7, 17,
      7.2, 294, 7.8e-2 / 60 / 60 / 24,
      comments: [
        'periodictable_comment_ts',
        'periodictable_comment_densityvaries',
        'periodictable_comment_massnotexact',
        'periodictable_comment_mostcommonisotop'
      ]),
  PeriodicTableElement('periodictable_element_oganesson', 'Og', 118, 294, -double.infinity, 50, 80, true, true, 7, 18,
      5, 294, 8.9e-4 / 60 / 60 / 24,
      comments: [
        'periodictable_comment_og',
        'periodictable_comment_noblegases',
        'periodictable_comment_densityvaries',
        'periodictable_comment_massnotexact',
        'periodictable_comment_mostcommonisotop'
      ]),
];

String atomicNumbersToText(List<int> atomicNumbers) {
  if (atomicNumbers == null || atomicNumbers.isEmpty) return '';

  return atomicNumbers.map((atomicNumber) {
    var element =
        allPeriodicTableElements.firstWhere((element) => element.atomicNumber == atomicNumber, orElse: () => null);
    return element != null ? element.chemicalSymbol : UNKNOWN_ELEMENT;
  }).join();
}

List<int> textToAtomicNumbers(String input) {
  if (input == null || input.isEmpty) return <int>[];
  input = input.replaceAll(RegExp(r'[^A-Za-z]'), '');
  if (input.isEmpty) return <int>[];

  var chemSymbol = RegExp(r'[A-Z][a-z]*');
  return chemSymbol.allMatches(input).map((symbol) {
    var element =
        allPeriodicTableElements.firstWhere((element) => element.chemicalSymbol == symbol.group(0), orElse: () => null);
    if (element == null) return null;

    return element.atomicNumber;
  }).toList();
}
