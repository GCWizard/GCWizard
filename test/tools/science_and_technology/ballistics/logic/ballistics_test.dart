import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/science_and_technology/ballistics/logic/ballistics.dart';

void main() {
  // https://www.rechner.club/physik/schiefer-wurf-berechnen
  group("ballistics.calculate:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {
        'velocity': 0.0,
        'angle': 0.0,
        'height': 0.0,
        'acceleration': 9.81,
        'drag': AIR_RESISTANCE.NONE,
        'mass': 0.0,
        'diameter': 0.0,
        'density': 0.0,
        'dragcoefficient': 0.0,
        'expectedOutput': OutputBallistics(Time: 0.0, Height: 0.0, Distance: 0.0, maxSpeed: 0.0)
      },
      {
        'velocity': 10.0,
        'angle': 60.0,
        'height': 2.0,
        'acceleration': 9.81,
        'drag': AIR_RESISTANCE.NONE,
        'mass': 0.0,
        'diameter': 0.0,
        'density': 0.0,
        'dragcoefficient': 0.0,
        'expectedOutput': OutputBallistics(Time: 1.9723308267639443, Height: 5.822629969418959, Distance: 9.861654133819723, maxSpeed: 11.8)
      },
      {
        'velocity': 0.0,
        'angle': 0.0,
        'height': 0.0,
        'acceleration': 9.81,
        'drag': AIR_RESISTANCE.NEWTON,
        'mass': 0.0,
        'diameter': 0.0,
        'density': 0.0,
        'dragcoefficient': 0.0,
        'expectedOutput': OutputBallistics(Time: 0.0, Height: 0.0, Distance: 0.0, maxSpeed: 0.0)
      },
    ];

    for (var elem in _inputsToExpected) {
      test(
          'velocity: ${elem['velocity']}, angle: ${elem['angle']}, height: ${elem['height']}, acceleration: ${elem['acceleration']}, '
          'acceleration: ${elem['inputUnit2']}, prefix: ${elem['prefix']}', () {
        OutputBallistics _actual = OutputBallistics(Time: 0, Height: 0, Distance: 0, maxSpeed: 0);
        switch (elem['drag']) {
          case AIR_RESISTANCE.NONE:
            _actual = calculateBallisticsNoDrag(elem['velocity'] as double, elem['angle'] as double,
                elem['acceleration'] as double, elem['height'] as double);
            break;
          case AIR_RESISTANCE.NEWTON:
            _actual = calculateBallisticsNewton(
              elem['velocity'] as double,
              elem['angle'] as double,
              elem['acceleration'] as double,
              elem['height'] as double,
              elem['mass'] as double,
              elem['diameter'] as double,
              elem['dragcoefficient'] as double,
              elem['density'] as double,
            );
            break;
        }
        expect(_actual.Distance, (elem['expectedOutput'] as OutputBallistics).Distance);
        expect(_actual.Time, (elem['expectedOutput'] as OutputBallistics).Time);
        expect(_actual.Height, (elem['expectedOutput'] as OutputBallistics).Height);
        expect(_actual.maxSpeed, (elem['expectedOutput'] as OutputBallistics).maxSpeed);
      });
    }
  });
}
