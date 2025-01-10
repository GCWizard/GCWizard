part of 'package:gc_wizard/tools/science_and_technology/ballistics/logic/ballistics.dart';

enum AIR_RESISTANCE {NONE, NEWTON}

Map<AIR_RESISTANCE, String> AIR_RESISTANCE_LIST = {
  AIR_RESISTANCE.NONE: 'ballistics_drag_none',
  AIR_RESISTANCE.NEWTON: 'ballistics_drag_newton',
};

class OutputBallistics {
  final double Time;
  final double Distance;
  final double Height;
  final double maxSpeed;

  OutputBallistics({required this.Time, required this.Distance, required this.Height, required this.maxSpeed});
}

