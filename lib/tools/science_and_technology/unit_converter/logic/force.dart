import 'package:gc_wizard/tools/science_and_technology/unit_converter/logic/unit.dart';

class Force extends Unit {
  late double Function (double) toNewton;
  late double Function (double) fromNewton;

  Force({required String name, required String symbol, bool isReference = false, required double inNewton})
      : super(name, symbol, isReference, (e) => e * inNewton, (e) => e / inNewton) {
    toNewton = toReference;
    fromNewton = fromReference;
  }
}

final FORCE_NEWTON = Force(
  name: 'common_unit_force_n_name',
  symbol: 'N',
  inNewton: 1.0,
  isReference: true,
);

final FORCE_POUND = Force(name: 'common_unit_force_lbf_name', symbol: 'lbf', inNewton: 0.45359237 * 9.80665);

final FORCE_POUNDAL = Force(name: 'common_unit_force_pdl_name', symbol: 'pdl', inNewton: 0.138254954376);

final FORCE_POND = Force(name: 'common_unit_force_p_name', symbol: 'p', inNewton: 0.00980665);

final FORCE_DYNE = Force(name: 'common_unit_force_dyn_name', symbol: 'dyn', inNewton: 1e-5);

// https://webmadness.net/blog/?post=knuth
final FORCE_BLINTZAL = Force(name: 'common_unit_force_blintzal_name', symbol: 'b-al', inNewton: 1.104380691060943e-5);

final List<Force> forces = [
  FORCE_NEWTON,
  FORCE_POUND,
  FORCE_POUNDAL,
  FORCE_POND,
  FORCE_DYNE,
  FORCE_BLINTZAL,
];
