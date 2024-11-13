import 'dart:math';

double degreesToRadian(double degrees) {
  return degrees * pi / 180.0;
}

double radianToDegrees(double radian) {
  return radian / pi * 180.0;
}

num modulo(num value, num modulator) {
  if (modulator <= 0.0) throw Exception("modulator must be positive");

  while (value < 0.0) {
    value += modulator;
  }

  return value % modulator;
}

num modulo360(num value) {
  return modulo(value, 360.0);
}

num round(double number, {int precision = 0}) {
  if (precision <= 0) return number.round();

  var exp = pow(10, precision);
  return (number * exp).round() / exp;
}

int gcd(int a, int b) {
  int h;
  if (a == 0) return b.abs();
  if (b == 0) return a.abs();

  do {
    h = a % b;
    a = b;
    b = h;
  } while (b != 0);

  return a.abs();
}

int lcm(int a, int b) {
  if (gcd(a, b) == 00) return 0;

  int result = (a * b).abs() ~/ gcd(a, b);

  if ((a < 0) || (b < 0)) {
    return -result;
  }
  return result;
}

/// Multiplication of two matrices
List<List<double>>? matrixMultiplication(List<List<double>> matrix1, List<List<double>> matrix2) {
  if (matrix1.isEmpty || matrix2.isEmpty || matrix1[0].length != matrix2.length) {
    return null;
  }
  var resultMatrix = List<List<double>>.generate(matrix1.length, (index) => List<double>.filled(matrix2.length, 0));

  for (int i = 0; i < matrix1.length; i++) {
    for (int j = 0; j < matrix2.length; j++) {
      for (int x = 0; x < matrix1[i].length; x++) {
        resultMatrix[i][j] += matrix1[i][x] * matrix2[x][j];
      }
    }
  }
  return resultMatrix;
}

// ported from https://dev.to/rk042/how-to-inverse-a-matrix-in-c-12jg
/// Invert of a square matrix
List<List<double>>? matrixInvert(List<List<double>> matrix) {
  int n = matrix.length;
  var augmented = List<List<double>>.generate(n, (index) => List<double>.filled(n * 2, 0));

  // Initialize augmented matrix with the input matrix and the identity matrix
  for (int i = 0; i < n; i++) {
    for (int j = 0; j < n; j++) {
      augmented[i][j] = matrix[i][j].toDouble();
      augmented[i][j + n] = (i == j) ? 1 : 0;
    }
  }

  // Apply Gaussian elimination
  for (int i = 0; i < n; i++) {
    int pivotRow = i;
    for (int j = i + 1; j < n; j++) {
      if (augmented[j][i].abs() > (augmented[pivotRow][i].abs())) {
        pivotRow = j;
      }
    }

    if (pivotRow != i) {
      for (int k = 0; k < 2 * n; k++) {
        double temp = augmented[i][k];
        augmented[i][k] = augmented[pivotRow][k];
        augmented[pivotRow][k] = temp;
      }
    }

    if (augmented[i][i].abs() < 1e-10) return null;

    var pivot = augmented[i][i];
    for (int j = 0; j < 2 * n; j++) {
      augmented[i][j] /= pivot;
    }

    for (int j = 0; j < n; j++) {
      if (j != i) {
        var factor = augmented[j][i];
        for (int k = 0; k < 2 * n; k++) {
          augmented[j][k] -= factor * augmented[i][k];
        }
      }
    }
  }

  var result = List<List<double>>.generate(n, (index) => List<double>.filled(n, 0));
  for (int i = 0; i < n; i++) {
    for (int j = 0; j < n; j++) {
      result[i][j] = augmented[i][j + n];
    }
  }
  return result;
}

/// Determinant of a square matrix
double matrixDeterminante(List<List<double>> matrix) {
  int n = matrix.length;

  for (int i = 0; i < n; i++) {
    if (matrix[i][i] == 0) {
      for (int row = i; row < n; row++) {
        if (matrix[i][row] != 0) { //flip row
          for (int k = 0; k < n; k++) {
            double tmp = matrix[k][i];
            matrix[k][i] = matrix[k][row];
            matrix[k][row] = tmp;
          }
        }
      }
    }
    if (matrix[i][i] == 0) continue;
    for (int j = i + 1; j < n; j++) {
      //generate 0s by addition
      double faktor = -matrix[j][i] / matrix[i][i];
      for (int k = 0; k < n; k++) {
        matrix[j][k] += faktor * matrix[i][k];
      }
    }
  }
  double result = 1;
  for (int i = 0; i < n; i++) {
    result *= matrix[i][i];
  }
  return result;
}
