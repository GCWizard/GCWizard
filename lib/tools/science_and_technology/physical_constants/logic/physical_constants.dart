// https://physics.nist.gov/cuu/Constants/index.html

class PhysicalConstant {
  final String symbol;
  final String value;
  final int? exponent;
  final String? standard_uncertainty;
  final String? unit;

  const PhysicalConstant({
    required this.symbol,
    required this.value,
    this.exponent,
    this.standard_uncertainty,
    this.unit
  });
}

const Map<String, PhysicalConstant> PHYSICAL_CONSTANTS = {
  'physical_constants_atomic_mass': PhysicalConstant(
    symbol: 'm_u_',
    value: '1.660 539 066 60',
    exponent: -27,
    standard_uncertainty: '0.000 000 000 50',
    unit: 'kg'
  ),
  'physical_constants_avogadro': PhysicalConstant(symbol: 'N_a_', value: '6.022 140 76', exponent: 23, unit: 'mol^-1^'),
  'physical_constants_boltzmann': PhysicalConstant(symbol: 'k', value: '1.380 649', exponent: -23, unit: 'J/K'),
  'physical_constants_conductance_quantum': PhysicalConstant(symbol: 'G_0_', value: '7.748 091 729', exponent: -5, unit: 'S'),
  'physical_constants_electron_mass': PhysicalConstant(
    symbol: 'm_e_',
    value: '9.109 383 701 5',
    exponent: -31,
    standard_uncertainty: '0.000 000 0028',
    unit: 'kg'
  ),
  'physical_constants_electron_volt': PhysicalConstant(symbol: 'eV', value: '1.602 176 634', exponent: -19, unit: 'J'),
  'physical_constants_elementary_charge': PhysicalConstant(symbol: 'e', value: '1.602 176 634', exponent: -19, unit: 'C'),
  'physical_constants_faraday': PhysicalConstant(symbol: 'F', value: '96 485.332 12', unit: 'C/mol'),
  'physical_constants_finestructure': PhysicalConstant(
    symbol: 'α',
    value: '7.297 352 569 3',
    exponent: -3,
    standard_uncertainty: '0.000 000 0011'
  ),
  'physical_constants_hyperfine_transition_frequency_cs133': PhysicalConstant(
    symbol: 'Δv_Cs_',
    value: '9 192 631 770',
    unit: 'Hz'
  ),
  'physical_constants_josephson': PhysicalConstant(symbol: 'K_j_', value: '483 597.8484', exponent: 9, unit: 'Hz/V'),
  'physical_constants_luminous_efficacy': PhysicalConstant(symbol: 'K_cd_', value: '683', unit: 'lm/W'),
  'physical_constants_magnetic_flux_quantum': PhysicalConstant(symbol: 'Φ', value: '2.067 833 848', exponent: -15, unit: 'Wb'),
  'physical_constants_molar_gas': PhysicalConstant(symbol: 'R', value: '8.314 462 618', unit: 'J/(mol K)'),
  'physical_constants_newton_gravitation': PhysicalConstant(
    symbol: 'G',
    value: '6.674 30',
    exponent: -11,
    standard_uncertainty: '0.000 15',
    unit: 'm^3^/(kg s)'
  ),
  'physical_constants_planck': PhysicalConstant(symbol: 'h', value: '6.626 070 15', exponent: -34, unit: 'J/Hz'),
  'physical_constants_planck_reduced': PhysicalConstant(symbol: 'ħ', value: '1.054 571 817 646 156', exponent: -34, unit: 'Js'),
  'physical_constants_proton_mass': PhysicalConstant(
    symbol: 'm_p_',
    value: '1.672 621 923 69',
    standard_uncertainty: '0.000 000 000 51',
    exponent: -27,
    unit: 'kg'
  ),
  'physical_constants_proton_electron_mass_ration': PhysicalConstant(
    symbol: 'm_p_/m_e_',
    value: '1 836.152 673 43',
    standard_uncertainty: '0.000 000 11'
  ),
  'physical_constants_rydberg': PhysicalConstant(
    symbol: 'R_∞_',
    value: '3.289 841 960 2508',
    standard_uncertainty: '0.000 000 000 0064',
    exponent: 15,
    unit: 'Hz'
  ),
  'physical_constants_speedoflight_vacuum': PhysicalConstant(symbol: 'c', value: '299 792 458', unit: 'm/s'),
  'physical_constants_std_acceleration_gravity': PhysicalConstant(symbol: 'g_n_', value: '9.806 65', unit: 'm/s\u00B2'),
  'physical_constants_std_atmosphere': PhysicalConstant(symbol: 'atm', value: '101 325', unit: 'Pa'),
  'physical_constants_std_state_pressure': PhysicalConstant(symbol: 'ssp', value: '100 000', unit: 'Pa'),
  'physical_constants_stefan_boltzmann': PhysicalConstant(
    symbol: 'σ',
    value: '5.670 374 419',
    exponent: -8,
    unit: 'W/(m^2^K^4^)'
  ),
  'physical_constants_vacuum_electric_permittivity': PhysicalConstant(
    symbol: 'ε_0_',
    value: '8.854 187 8128',
    unit: 'F/m',
    standard_uncertainty: '0.000 000 0013',
    exponent: -12
  ),
  'physical_constants_vacuum_magnetic_permeability': PhysicalConstant(
    symbol: 'μ_0_',
    value: '1.256 637 062 12',
    unit: 'N/A²',
    standard_uncertainty: '0.000 000 000 19',
    exponent: -6
  ),
  'physical_constants_von_klitzing': PhysicalConstant(symbol: 'R_k_', value: '25 812.807 45', unit: 'Ω')
};
