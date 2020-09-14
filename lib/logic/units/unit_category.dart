import 'package:gc_wizard/logic/units/angle.dart';
import 'package:gc_wizard/logic/units/area.dart';
import 'package:gc_wizard/logic/units/density.dart';
import 'package:gc_wizard/logic/units/energy.dart';
import 'package:gc_wizard/logic/units/force.dart';
import 'package:gc_wizard/logic/units/length.dart';
import 'package:gc_wizard/logic/units/mass.dart';
import 'package:gc_wizard/logic/units/power.dart';
import 'package:gc_wizard/logic/units/pressure.dart';
import 'package:gc_wizard/logic/units/temperature.dart';
import 'package:gc_wizard/logic/units/time.dart';
import 'package:gc_wizard/logic/units/unit.dart';
import 'package:gc_wizard/logic/units/velocity.dart';
import 'package:gc_wizard/logic/units/volume.dart';

final UNITCATEGORY_ANGLE = UnitCategory('unitconverter_category_angle', angles, ANGLE_DEGREE, true);
final UNITCATEGORY_AREA = UnitCategory('unitconverter_category_area', areas, AREA_SQUAREMETER, false);
final UNITCATEGORY_DENSITY = UnitCategory('unitconverter_category_density', densities, DENSITY_KILOGRAMPERCUBICMETER, false);
final UNITCATEGORY_ENERGY = UnitCategory('unitconverter_category_energy', energies, ENERGY_JOULE, true);
final UNITCATEGORY_FORCE = UnitCategory('unitconverter_category_force', forces, FORCE_NEWTON, true);
final UNITCATEGORY_LENGTH = UnitCategory('unitconverter_category_length', baseLengths, LENGTH_METER, true);
final UNITCATEGORY_MASS = UnitCategory('unitconverter_category_mass', baseMasses, MASS_GRAM, true);
final UNITCATEGORY_POWER = UnitCategory('unitconverter_category_power', powers, POWER_WATT, true);
final UNITCATEGORY_PRESSURE = UnitCategory('unitconverter_category_pressure', pressures, PRESSURE_PASCAL, true);
final UNITCATEGORY_TEMPERATURE = UnitCategory('unitconverter_category_temperature', temperatures, TEMPERATURE_KELVIN, true);
final UNITCATEGORY_TIME = UnitCategory('unitconverter_category_time', times, TIME_SECOND, true);
final UNITCATEGORY_VELOCITY = UnitCategory('unitconverter_category_velocity', velocities, VELOCITY_MS, false);
final UNITCATEGORY_VOLUME = UnitCategory('unitconverter_category_volume', volumes, VOLUME_CUBICMETER, false);

class UnitCategory {
  String key;
  List<Unit> units;
  Unit defaultUnit;
  bool usesPrefixes;

  UnitCategory(this.key, this.units, this.defaultUnit, this.usesPrefixes);
}