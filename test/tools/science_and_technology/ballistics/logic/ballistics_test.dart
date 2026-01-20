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
        'duration': 0.0,
        'distance': 0.0,
        'expectedOutput': OutputBallistics(Time: 0.0, maxHeight: 0.0, Distance: 0.0, maxSpeed: 0.0, Speed: 0.0, Angle: 0.0)
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
        'duration': 0.0,
        'distance': 0.0,
        'dragcoefficient': 0.0,
        'expectedOutput': OutputBallistics(Time: 1.9723308267639443, maxHeight: 5.822629969418959, Distance: 9.861654133819723, maxSpeed: 11.8, Speed: 10.0, Angle: 0.0)
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
        'expectedOutput': OutputBallistics(Time: 0.0, maxHeight: 0.0, Distance: 0.0, maxSpeed: 0.0, Speed: 0.0, Angle: 0.0)
      },
    ];

    for (var elem in _inputsToExpected) {
      test(
          'velocity: ${elem['velocity']}, angle: ${elem['angle']}, height: ${elem['height']}, acceleration: ${elem['acceleration']}, '
          'acceleration: ${elem['acceleration']}, duration: ${elem['duration']}, distance: ${elem['distance']}', () {
        OutputBallistics _actual = OutputBallistics(Time: 0, maxHeight: 0, Distance: 0, maxSpeed: 0, Speed: 0.0, Angle: 0.0);
        switch (elem['drag']) {
          case AIR_RESISTANCE.NONE:
            _actual = calculateBallisticsNoDrag(
                velocity: elem['velocity'] as double,
                angle: elem['angle'] as double,
                acceleration: elem['acceleration'] as double,
                startHeight: elem['height'] as double,
                duration: elem['duration'] as double,
                distance: elem['distance'] as double,
                dataMode: BALLISTICS_DATA_MODE.ANGLE_VELOCITY_TO_DISTANCE_DURATION);
            break;
          case AIR_RESISTANCE.NEWTON:
            _actual = calculateBallisticsNewton(
              V0: elem['velocity'] as double,
              Winkel: elem['angle'] as double,
              g: elem['acceleration'] as double,
              startHeight: elem['height'] as double,
              Masse: elem['mass'] as double,
              a: elem['diameter'] as double,
              cw: elem['dragcoefficient'] as double,
              rho: elem['density'] as double,
              dataMode: BALLISTICS_DATA_MODE.ANGLE_VELOCITY_TO_DISTANCE_DURATION,
            );
            break;
        }
        expect(_actual.Distance, (elem['expectedOutput'] as OutputBallistics).Distance);
        expect(_actual.Time, (elem['expectedOutput'] as OutputBallistics).Time);
        expect(_actual.maxHeight, (elem['expectedOutput'] as OutputBallistics).maxHeight);
        expect(_actual.maxSpeed, (elem['expectedOutput'] as OutputBallistics).maxSpeed);
        expect(_actual.Speed, (elem['expectedOutput'] as OutputBallistics).Speed);
      });
    }
  });
}
