// https://www.code-knacker.de/eiscode.htm
//
// EU     https://eur-lex.europa.eu/legal-content/DE/TXT/PDF/?uri=CELEX:32007R0416
//        S.  83 Ice condition code
//        S.  89 Ice_accessibility_code
//        S.  92 Ice_classification_code
//
// BALTIC https://www.bsh.de/EN/TOPICS/Marine_environment/Ice/Ice_observations/Ice_observations_node.html
//        https://www.bsh.de/DE/THEMEN/Meeresumwelt/Eis/Eisbeobachtungen/eisbeobachtungen_node.html
//
// WMO    https://library.wmo.int/doc_num.php?explnum_id=4651
//        S. 115 Concentration
//        S. 116 Stage of development and thickness - Symbols
//        S. 117 Form of ice
//        S. 118 Stage of melting (ms)
//        S. 119 Snow depth (s)
//
// SIGRID http://www.aari.ru/gdsidb/format/sigrid-1.pdf
//        S. 16 Concentration

// enum IceCodeLanguage { DE, EN, FR }
// Map<IceCodeLanguage, String> ICECODE_LANGUAGES = {
//   IceCodeLanguage.DE: 'common_language_german',
//   IceCodeLanguage.EN: 'common_language_english',
//   IceCodeLanguage.FR: 'common_language_french',
// };

enum IceCodeSystem {
  EU,
  BALTIC,
  WMO,
  SIGRID,
}

Map<IceCodeSystem, String> ICECODE_SYSTEM = {
  IceCodeSystem.EU: 'icecodes_system_eu',
  IceCodeSystem.BALTIC: 'icecodes_system_baltic',
  IceCodeSystem.WMO: 'icecodes_system_wmo',
  IceCodeSystem.SIGRID: 'icecodes_system_sigrid',
};

enum IceCodeSubSystem {
  CONDITION,
  ACCESSIBILITY,
  CLASSIFICATION,
  CONCENTRATION,
  DEVELOPMENT,
  FORM,
  MELTING,
  SNOW,
  A,
  S,
  T,
  K,
  SIGRID
}

Map<IceCodeSubSystem, String> ICECODE_SUBSYSTEM_EU = {
  IceCodeSubSystem.CONDITION: 'icecodes_system_eu_condition',
  IceCodeSubSystem.ACCESSIBILITY: 'icecodes_system_eu_accessibility',
  IceCodeSubSystem.CLASSIFICATION: 'icecodes_system_eu_classification',
};

Map<IceCodeSubSystem, String> ICECODE_SUBSYSTEM_BALTIC = {
  IceCodeSubSystem.A: 'icecodes_system_baltic_a',
  IceCodeSubSystem.S: 'icecodes_system_baltic_s',
  IceCodeSubSystem.T: 'icecodes_system_baltic_t',
  IceCodeSubSystem.K: 'icecodes_system_baltic_k',
};

Map<IceCodeSubSystem, String> ICECODE_SUBSYSTEM_WMO = {
  IceCodeSubSystem.CONCENTRATION: 'icecodes_system_wmo_concentration',
  IceCodeSubSystem.DEVELOPMENT: 'icecodes_system_wmo_development',
  IceCodeSubSystem.FORM: 'icecodes_system_wmo_form',
  IceCodeSubSystem.MELTING: 'icecodes_system_wmo_melting',
  IceCodeSubSystem.SNOW: 'icecodes_system_wmo_snow',
};

final Map<IceCodeSystem, Map<IceCodeSubSystem, Map<String, String>>> ICECODES = {
  IceCodeSystem.EU: {
    IceCodeSubSystem.CONDITION: {
      'A': 'icecodes_system_eu_condition_a',
      'B': 'icecodes_system_eu_condition_b',
      'C': 'icecodes_system_eu_condition_c',
      'D': 'icecodes_system_eu_condition_d',
      'E': 'icecodes_system_eu_condition_e',
      'F': 'icecodes_system_eu_condition_f',
      'G': 'icecodes_system_eu_condition_g',
      'H': 'icecodes_system_eu_condition_h',
      'K': 'icecodes_system_eu_condition_k',
      'L': 'icecodes_system_eu_condition_l',
      'M': 'icecodes_system_eu_condition_m',
      'P': 'icecodes_system_eu_condition_p',
      'R': 'icecodes_system_eu_condition_r',
      'S': 'icecodes_system_eu_condition_s',
      'U': 'icecodes_system_eu_condition_u',
      'O': 'icecodes_system_eu_condition_o',
      'V': 'icecodes_system_eu_condition_v',
    },
    IceCodeSubSystem.ACCESSIBILITY: {
      'A': 'icecodes_system_eu_accessibility_a',
      'B': 'icecodes_system_eu_accessibility_b',
      'F': 'icecodes_system_eu_accessibility_f',
      'L': 'icecodes_system_eu_accessibility_l',
      'C': 'icecodes_system_eu_accessibility_c',
      'D': 'icecodes_system_eu_accessibility_d',
      'E': 'icecodes_system_eu_accessibility_e',
      'G': 'icecodes_system_eu_accessibility_g',
      'H': 'icecodes_system_eu_accessibility_h',
      'K': 'icecodes_system_eu_accessibility_k',
      'M': 'icecodes_system_eu_accessibility_m',
      'P': 'icecodes_system_eu_accessibility_p',
      'T': 'icecodes_system_eu_accessibility_t',
      'X': 'icecodes_system_eu_accessibility_x',
      'V': 'icecodes_system_eu_accessibility_v',
    },
    IceCodeSubSystem.CLASSIFICATION: {
      'A': 'icecodes_system_eu_classification_a',
      'B': 'icecodes_system_eu_classification_b',
      'C': 'icecodes_system_eu_classification_c',
      'D': 'icecodes_system_eu_classification_d',
      'E': 'icecodes_system_eu_classification_e',
    }
  },
  IceCodeSystem.BALTIC: {
    IceCodeSubSystem.A: {
      '0': 'icecodes_system_baltic_a_0',
      '1': 'icecodes_system_baltic_a_1',
      '2': 'icecodes_system_baltic_a_2',
      '3': 'icecodes_system_baltic_a_3',
      '4': 'icecodes_system_baltic_a_4',
      '5': 'icecodes_system_baltic_a_5',
      '6': 'icecodes_system_baltic_a_6',
      '7': 'icecodes_system_baltic_a_7',
      '8': 'icecodes_system_baltic_a_8',
      '9': 'icecodes_system_baltic_a_9',
      '/': 'icecodes_system_baltic_a_/',
    },
    IceCodeSubSystem.S: {
      '0': 'icecodes_system_baltic_s_0',
      '1': 'icecodes_system_baltic_s_1',
      '2': 'icecodes_system_baltic_s_2',
      '3': 'icecodes_system_baltic_s_3',
      '4': 'icecodes_system_baltic_s_4',
      '5': 'icecodes_system_baltic_s_5',
      '6': 'icecodes_system_baltic_s_6',
      '7': 'icecodes_system_baltic_s_7',
      '8': 'icecodes_system_baltic_s_8',
      '9': 'icecodes_system_baltic_s_9',
      '/': 'icecodes_system_baltic_s_/',
    },
    IceCodeSubSystem.T: {
      '0': 'icecodes_system_baltic_t_0',
      '1': 'icecodes_system_baltic_t_1',
      '2': 'icecodes_system_baltic_t_2',
      '3': 'icecodes_system_baltic_t_3',
      '4': 'icecodes_system_baltic_t_4',
      '5': 'icecodes_system_baltic_t_5',
      '6': 'icecodes_system_baltic_t_6',
      '7': 'icecodes_system_baltic_t_7',
      '8': 'icecodes_system_baltic_t_8',
      '9': 'icecodes_system_baltic_t_9',
      '/': 'icecodes_system_baltic_t_/',
    },
    IceCodeSubSystem.K: {
      '0': 'icecodes_system_baltic_k_0',
      '1': 'icecodes_system_baltic_k_1',
      '2': 'icecodes_system_baltic_k_2',
      '3': 'icecodes_system_baltic_k_3',
      '4': 'icecodes_system_baltic_k_4',
      '5': 'icecodes_system_baltic_k_5',
      '6': 'icecodes_system_baltic_k_6',
      '7': 'icecodes_system_baltic_k_7',
      '8': 'icecodes_system_baltic_k_8',
      '9': 'icecodes_system_baltic_k_9',
      '/': 'icecodes_system_baltic_k_/',
    },
  },
  IceCodeSystem.WMO: {
    IceCodeSubSystem.CONCENTRATION: {
      ' ': 'icecodes_system_wmo_concentration_-',
      '0': 'icecodes_system_wmo_concentration_0',
      '1': 'icecodes_system_wmo_concentration_1',
      '2': 'icecodes_system_wmo_concentration_2',
      '3': 'icecodes_system_wmo_concentration_3',
      '4': 'icecodes_system_wmo_concentration_4',
      '5': 'icecodes_system_wmo_concentration_5',
      '6': 'icecodes_system_wmo_concentration_6',
      '7': 'icecodes_system_wmo_concentration_7',
      '8': 'icecodes_system_wmo_concentration_8',
      '9': 'icecodes_system_wmo_concentration_9',
      '9+': 'icecodes_system_wmo_concentration_9+',
      '10': 'icecodes_system_wmo_concentration_10',
      'x': 'icecodes_system_wmo_concentration_x'
    },
    IceCodeSubSystem.DEVELOPMENT: {
      '0': 'icecodes_system_wmo_development_0',
      '1': 'icecodes_system_wmo_development_1',
      '2': 'icecodes_system_wmo_development_2',
      '3': 'icecodes_system_wmo_development_3',
      '4': 'icecodes_system_wmo_development_4',
      '5': 'icecodes_system_wmo_development_5',
      '6': 'icecodes_system_wmo_development_6',
      '7': 'icecodes_system_wmo_development_7',
      '8': 'icecodes_system_wmo_development_8',
      '9': 'icecodes_system_wmo_development_9',
      '1•': 'icecodes_system_wmo_development_10',
      '4•': 'icecodes_system_wmo_development_40',
      '7•': 'icecodes_system_wmo_development_70',
      '8•': 'icecodes_system_wmo_development_80',
      '9•': 'icecodes_system_wmo_development_90',
      '▲•': 'icecodes_system_wmo_development_D',
      'x': 'icecodes_system_wmo_development_x'
    },
    IceCodeSubSystem.FORM: {
      '0': 'icecodes_system_wmo_form_0',
      '1': 'icecodes_system_wmo_form_1',
      '2': 'icecodes_system_wmo_form_2',
      '3': 'icecodes_system_wmo_form_3',
      '4': 'icecodes_system_wmo_form_4',
      '5': 'icecodes_system_wmo_form_5',
      '6': 'icecodes_system_wmo_form_6',
      '7': 'icecodes_system_wmo_form_7',
      '8': 'icecodes_system_wmo_form_8',
      '9': 'icecodes_system_wmo_form_9',
      'x': 'icecodes_system_wmo_form_x'
    },
    IceCodeSubSystem.MELTING: {
      '0': 'icecodes_system_wmo_melting_0',
      '1': 'icecodes_system_wmo_melting_1',
      '2': 'icecodes_system_wmo_melting_2',
      '3': 'icecodes_system_wmo_melting_3',
      '4': 'icecodes_system_wmo_melting_4',
      '5': 'icecodes_system_wmo_melting_5',
      '6': 'icecodes_system_wmo_melting_6',
      '7': 'icecodes_system_wmo_melting_7',
      '8': 'icecodes_system_wmo_melting_8',
      '9': 'icecodes_system_wmo_melting_9',
    },
    IceCodeSubSystem.SNOW: {
      '0': 'icecodes_system_wmo_snow_0',
      '1': 'icecodes_system_wmo_snow_1',
      '2': 'icecodes_system_wmo_snow_2',
      '3': 'icecodes_system_wmo_snow_3',
      '4': 'icecodes_system_wmo_snow_4',
      '5': 'icecodes_system_wmo_snow_5',
      '6': 'icecodes_system_wmo_snow_6',
      '7': 'icecodes_system_wmo_snow_7',
      '8': 'icecodes_system_wmo_snow_8',
      '9': 'icecodes_system_wmo_snow_9',
    },
  },
  IceCodeSystem.SIGRID: {
    IceCodeSubSystem.SIGRID: {
      '00': 'icecodes_system_sigrid_00',
      '01': 'icecodes_system_sigrid_01',
      '02': 'icecodes_system_sigrid_02',
      '10': 'icecodes_system_sigrid_10',
      '20': 'icecodes_system_sigrid_20',
      '30': 'icecodes_system_sigrid_30',
      '40': 'icecodes_system_sigrid_40',
      '50': 'icecodes_system_sigrid_50',
      '60': 'icecodes_system_sigrid_60',
      '70': 'icecodes_system_sigrid_70',
      '80': 'icecodes_system_sigrid_80',
      '90': 'icecodes_system_sigrid_90',
      '91': 'icecodes_system_sigrid_91',
      '92': 'icecodes_system_sigrid_92',
      '99': 'icecodes_system_sigrid_99',
    },
  }
};
