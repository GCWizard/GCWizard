int _intSqrt(int number) {
  int result = 0;
  int bit = 1 << 30;

  while (bit > number) {
    bit >>= 2;
  }

  while (bit != 0) {
    if (number >= result + bit) {
      number -= result + bit;
      result = (result >> 1) + bit;
    } else {
      result >>= 1;
    }
    bit >>= 2;
  }

  return result;
}

List<int> divisors(int number) {
  List<int> divisorList = <int>[];
  int sqrtNumber = _intSqrt(number);

  for (int i = 1; i <= sqrtNumber; i++) {
    if (number % i == 0) {
      divisorList.add(i);
      if (i != number ~/ i) {
        divisorList.add(number ~/ i);
      }
    }
  }

  divisorList.sort();
  return divisorList;
}