import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/science_and_technology/projectiles/logic/projectiles.dart';
import 'package:gc_wizard/tools/science_and_technology/unit_converter/logic/energy.dart';
import 'package:gc_wizard/tools/science_and_technology/unit_converter/logic/mass.dart';
import 'package:gc_wizard/tools/science_and_technology/unit_converter/logic/unit_category.dart';
import 'package:gc_wizard/tools/science_and_technology/unit_converter/logic/unit_prefix.dart';
import 'package:gc_wizard/tools/science_and_technology/unit_converter/logic/velocity.dart';
import 'package:intl/intl.dart';

void main() {
  group("Projectiles.calculate:", () {
    List<Map<String, dynamic>> _inputsToExpected = [
      {'mode': UNITCATEGORY_ENERGY, 'prefix' : UNITPREFIX_NONE, 'outputUnit' : ENERGY_JOULE,'inputValue1' : 1.0, 'inputUnit1': MASS_KILOGRAM, 'inputValue2' : 1.0, 'inputUnit2': VELOCITY_MS, 'expectedOutput' : '0.5 J'},
      {'mode': UNITCATEGORY_ENERGY, 'prefix' : UNITPREFIX_KILO, 'outputUnit' : ENERGY_JOULE,'inputValue1' : 1.0, 'inputUnit1': MASS_KILOGRAM, 'inputValue2' : 1.0, 'inputUnit2': VELOCITY_MS, 'expectedOutput' : '0.0005 kJ'},
      {'mode': UNITCATEGORY_MASS, 'prefix' : UNITPREFIX_NONE, 'outputUnit' : MASS_GRAM,'inputValue1' : 0.5, 'inputUnit1': ENERGY_JOULE, 'inputValue2' : 1.0, 'inputUnit2': VELOCITY_MS, 'expectedOutput' : '1000.0 g'},
      {'mode': UNITCATEGORY_MASS, 'prefix' : UNITPREFIX_KILO, 'outputUnit' : MASS_GRAM,'inputValue1' : 0.5, 'inputUnit1': ENERGY_JOULE, 'inputValue2' : 1.0, 'inputUnit2': VELOCITY_MS, 'expectedOutput' : '1.0 kg'},
      {'mode': UNITCATEGORY_VELOCITY, 'prefix' : UNITPREFIX_NONE, 'outputUnit' : VELOCITY_MS,'inputValue1' : 0.5, 'inputUnit1': ENERGY_JOULE, 'inputValue2' : 1.0, 'inputUnit2': MASS_KILOGRAM, 'expectedOutput' : '1.0 m/s'},
      {'mode': UNITCATEGORY_VELOCITY, 'prefix' : UNITPREFIX_NONE, 'outputUnit' : VELOCITY_MS,'inputValue1' : 0.5, 'inputUnit1': ENERGY_JOULE, 'inputValue2' : 1000.0, 'inputUnit2': MASS_GRAM, 'expectedOutput' : '1.0 m/s'},
    ];

    _inputsToExpected.forEach((elem) {
      test('mode: ${elem['mode']}, outputUnit: ${elem['outputUnit']}, inputValue1: ${elem['inputValue1']}, inputValue2: ${elem['inputUnit2']}, inputUnit2: ${elem['inputUnit2']}, prefix: ${elem['prefix']}', () {
        var _actual;
        double _refInputValue1 = elem['inputUnit1'].toReference(elem['inputValue1']);
        double _refInputValue2 = elem['inputUnit2'].toReference(elem['inputValue2']);

        if (elem['mode'] == UNITCATEGORY_ENERGY) {
          _actual = calculateEnergy(_refInputValue1, _refInputValue2);
        } else if (elem['mode'] == UNITCATEGORY_MASS) {
          _actual = calculateMass(_refInputValue1, _refInputValue2);
        } else {
          _actual = calculateVelocity(_refInputValue1, _refInputValue2);
        }
        _actual = elem['outputUnit'].fromReference(_actual) / elem['prefix'].value;
        expect(NumberFormat('0.0' + '#' * 6).format(_actual) + ' ' + (elem['prefix'].symbol ?? '') + elem['outputUnit'].symbol, elem['expectedOutput']);
      });
    });
  });
}
