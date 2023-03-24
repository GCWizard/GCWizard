int fractionPartAsInteger(double value) {
  var valueSplitted = value.toString().split('.');

  if (valueSplitted.length < 2) {
    return 0;
  } else {
    return int.parse(valueSplitted[1]);
  }
}

bool doubleEquals(double a, double b, {double tolerance = 1e-10}) {
  return (a - b).abs() < tolerance;
}

bool isDouble(String text) {
  return double.tryParse(text) != null;
}

int sign(double value) {
  return value == 0 ? 1 : value.sign.toInt();
}