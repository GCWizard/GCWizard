int fractionPartAsInteger(double value) {
  if (value == null) return null;
  var valueSplitted = value.toString().split('.');

  if (valueSplitted.length < 2)
    return 0;
  else
    return int.parse(valueSplitted[1]);
}

bool doubleEquals(double a, double b, {double tolerance: 1e-10}) {
  if (a == null && b == null) return true;

  if (a == null || b == null) return false;

  return (a - b).abs() < tolerance;
}