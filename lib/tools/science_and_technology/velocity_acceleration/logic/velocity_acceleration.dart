import 'dart:math';

double velocity({required double time, double? distance, double? acceleration}) {
  if (acceleration != null) {
    return acceleration * time;
  } else {
    return distance ?? 0.0 * time;
  }
}

double distance({required double time, double? velocity, double? acceleration}) {
  if (acceleration != null) {
    return 0.5 * acceleration * time * time;
  } else {
    return (velocity ?? 0.0) * time;
  }
}

double time({required double distance, double? velocity, double? acceleration}) {
  if (acceleration != null) {
    if (acceleration == 0.0) {
      return double.nan;
    }

    return sqrt((2 * distance) / acceleration);
  } else {
    if (velocity == null || velocity == 0.0) {
      return double.nan;
    }

    return distance / velocity;
  }
}

double acceleration({required double time, double? distance, double? velocity}) {
  if (time == 0.0) {
    return double.nan;
  }

  if (velocity != null) {
    return velocity / time;
  } else {
    return 2 * (distance ?? 0.0) / time / time;
  }
}
