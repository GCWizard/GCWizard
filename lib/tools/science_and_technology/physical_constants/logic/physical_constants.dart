// https://physics.nist.gov/cuu/Constants/index.html

const Map<String, Map<String, dynamic>> PHYSICAL_CONSTANTS = {
  'physical_constants_atomic_mass': {
    'symbol': 'm\u1d64',
    'value': '1.660 539 066 60',
    'exponent': -27,
    'standard_uncertainty': '0.000 000 000 50',
    'unit': 'kg'
  },
  'physical_constants_avogadro': {
    'symbol': 'N\u2090',
    'value': '6.022 140 76',
    'exponent': 23,
    'unit': 'mol\u207B\u00B9'
  },
  'physical_constants_boltzmann': {'symbol': 'k', 'value': '1.380 649', 'exponent': -23, 'unit': 'J/K'},
  'physical_constants_conductance_quantum': {
    'symbol': 'G\u2080',
    'value': '7.748 091 729',
    'exponent': -5,
    'unit': 'S'
  },
  'physical_constants_electron_mass': {
    'symbol': 'm\u2091',
    'value': '9.109 383 701 5',
    'exponent': -31,
    'standard_uncertainty': '0.000 000 0028',
    'unit': 'kg'
  },
  'physical_constants_electron_volt': {'symbol': 'eV', 'value': '1.602 176 634', 'exponent': -19, 'unit': 'J'},
  'physical_constants_elementary_charge': {'symbol': 'e', 'value': '1.602 176 634', 'exponent': -19, 'unit': 'C'},
  'physical_constants_faraday': {'symbol': 'F', 'value': '96 485.332 12', 'unit': 'C/mol'},
  'physical_constants_finestructure': {
    'symbol': 'α',
    'value': '7.297 352 569 3',
    'exponent': -3,
    'standard_uncertainty': '0.000 000 0011'
  },
  'physical_constants_hyperfine_transition_frequency_cs133': {
    'symbol': 'Δv_Cs',
    'value': '9 192 631 770',
    'unit': 'Hz'
  },
  'physical_constants_josephson': {'symbol': 'K\u2c7c', 'value': '483 597.8484', 'exponent': 9, 'unit': 'Hz/V'},
  'physical_constants_luminous_efficacy': {'symbol': 'K_cd', 'value': '683', 'unit': 'lm/W'},
  'physical_constants_magnetic_flux_quantum': {'symbol': 'Φ', 'value': '2.067 833 848', 'exponent': -15, 'unit': 'Wb'},
  'physical_constants_molar_gas': {'symbol': 'R', 'value': '8.314 462 618', 'unit': 'J/(mol K)'},
  'physical_constants_newton_gravitation': {
    'symbol': 'G',
    'value': '6.674 30',
    'exponent': -11,
    'standard_uncertainty': '0.000 15',
    'unit': 'm³/(kg s)'
  },
  'physical_constants_planck': {'symbol': 'h', 'value': '6.626 070 15', 'exponent': -34, 'unit': 'J/Hz'},
  'physical_constants_planck_reduced': {'symbol': 'ħ', 'value': '1.054 571 817 646 156', 'exponent': -34, 'unit': 'Js'},
  'physical_constants_proton_mass': {
    'symbol': 'm\u209a',
    'value': '1.672 621 923 69',
    'standard_uncertainty': '0.000 000 000 51',
    'exponent': -27,
    'unit': 'kg'
  },
  'physical_constants_proton_electron_mass_ration': {
    'symbol': 'm\u209a/m\u2091',
    'value': '1 836.152 673 43',
    'standard_uncertainty': '0.000 000 11'
  },
  'physical_constants_rydberg': {
    'symbol': 'R∞',
    'value': '3.289 841 960 2508',
    'standard_uncertainty': '0.000 000 000 0064',
    'exponent': 15,
    'unit': 'Hz'
  },
  'physical_constants_speedoflight_vacuum': {'symbol': 'c', 'value': '299 792 458', 'unit': 'm/s'},
  'physical_constants_std_acceleration_gravity': {'symbol': 'g\u2099', 'value': '9.806 65', 'unit': 'm/s\u00B2'},
  'physical_constants_std_atmosphere': {'symbol': 'atm', 'value': '101 325', 'unit': 'Pa'},
  'physical_constants_std_state_pressure': {'symbol': 'ssp', 'value': '100 000', 'unit': 'Pa'},
  'physical_constants_stefan_boltzmann': {
    'symbol': 'σ',
    'value': '5.670 374 419',
    'exponent': '-8',
    'unit': 'W/(m\u00B2 K\u2074)'
  },
  'physical_constants_vacuum_electric_permittivity': {
    'symbol': 'ε\u2080',
    'value': '8.854 187 8128',
    'unit': 'F/m',
    'standard_uncertainty': '0.000 000 0013',
    'exponent': -12
  },
  'physical_constants_vacuum_magnetic_permeability': {
    'symbol': 'μ\u2080',
    'value': '1.256 637 062 12',
    'unit': 'N/A²',
    'standard_uncertainty': '0.000 000 000 19',
    'exponent': -6
  },
  'physical_constants_von_klitzing': {'symbol': 'R\u2096', 'value': '25 812.807 45', 'unit': 'Ω'}
};
