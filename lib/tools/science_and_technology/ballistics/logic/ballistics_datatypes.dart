part of 'package:gc_wizard/tools/science_and_technology/ballistics/logic/ballistics.dart';

enum BALLISTICS_DATA_MODE {
  ANGLE_DURATION_TO_DISTANCE_VELOCITY,
  ANGLE_VELOCITY_TO_DISTANCE_DURATION,
  ANGLE_DISTANCE_TO_DURATION_VELOCITY,
  DURATION_DISTANCE_TO_ANGLE_VELOCITY,
  DURATION_VELOCITY_TO_ANGLE_DISTANCE,
  VELOCITY_DISTANCE_TO_ANGLE_DURATION,
}

Map<BALLISTICS_DATA_MODE, String> BALLISTICS_DATA_MODE_LIST = {
  BALLISTICS_DATA_MODE.ANGLE_DURATION_TO_DISTANCE_VELOCITY:
      'ballistics_data_mode_at2dv',
  BALLISTICS_DATA_MODE.ANGLE_VELOCITY_TO_DISTANCE_DURATION:
      'ballistics_data_mode_av2dt',
  BALLISTICS_DATA_MODE.ANGLE_DISTANCE_TO_DURATION_VELOCITY:
      'ballistics_data_mode_ad2tv',
  BALLISTICS_DATA_MODE.DURATION_DISTANCE_TO_ANGLE_VELOCITY:
      'ballistics_data_mode_td2av',
  BALLISTICS_DATA_MODE.DURATION_VELOCITY_TO_ANGLE_DISTANCE:
      'ballistics_data_mode_tv2ad',
  BALLISTICS_DATA_MODE.VELOCITY_DISTANCE_TO_ANGLE_DURATION:
      'ballistics_data_mode_vd2at',
};

enum AIR_RESISTANCE { NONE, NEWTON }

Map<AIR_RESISTANCE, String> AIR_RESISTANCE_LIST = {
  AIR_RESISTANCE.NONE: 'ballistics_drag_none',
  AIR_RESISTANCE.NEWTON: 'ballistics_drag_newton',
};

class OutputBallistics {
  final double Time;
  final double Distance;
  final double maxHeight;
  final double Speed;
  final double maxSpeed;
  final double Angle;

  OutputBallistics(
      {required this.Time,
      required this.Distance,
      required this.maxHeight,
      required this.Speed,
      required this.maxSpeed,
      required this.Angle,});
}
