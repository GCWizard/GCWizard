String _sanitizePassword(String? password, int key) {
  password ??= '';

  password = password.toUpperCase().replaceAll(RegExp('[^A-Z]'), 'Z');

  if (password.length < key) password = password.padRight(key, 'Z');

  if (password.length > key) password = password.substring(0, key);

  return password;
}

List<List<String>> _applyPasswordToMatrix(List<List<String>> matrix, String password) {
  var orderedPassword = password.split('').asMap().entries.toList();
  orderedPassword.sort((a, b) => a.value.compareTo(b.value));

  var indexedPassword = orderedPassword.asMap().entries.toList();
  indexedPassword.sort((a, b) => a.value.key.compareTo(b.value.key));

  var shuffledMatrix = <List<String>>[];
  for (var character in indexedPassword) {
    shuffledMatrix.add(matrix[character.key]);
  }

  return shuffledMatrix;
}

List<List<String>> _fillMatrix(String input, int key) {
  var matrix = List<List<String>>.generate(key, (index) => List<String>.generate(input.length, (index) => '.'));

  var currentRow = 0;
  var goDown = true;

  for (int i = 0; i < input.length; i++) {
    matrix[currentRow][i] = input[i];

    if (currentRow == 0) {
      goDown = true;
    }

    if (currentRow == key - 1) {
      goDown = false;
    }

    if (goDown) {
      currentRow++;
    } else {
      currentRow--;
    }
  }

  return matrix;
}

String encryptRailFence(String input, int key, {int? offset, String? password}) {
  if (input.isEmpty) return '';

  if (key < 2) return input;

  if (offset == null || offset < 0) offset = 0;

  password = _sanitizePassword(password, key);

  input = '\x00' * offset + input;

  var matrix = _fillMatrix(input, key);
  matrix = _applyPasswordToMatrix(matrix, password);

  var out = '';
  for (var row in matrix) {
    for (var cell in row) {
      if (cell != '.') out += cell;
    }
  }

  return out.replaceAll('\x00', '');
}

String decryptRailFence(String input, int key, {int? offset, String? password}) {
  if (input.isEmpty) return '';

  if (key < 2) return input;

  if (offset == null || offset < 0) offset = 0;

  password = _sanitizePassword(password, key);

  var mapMatrix = _fillMatrix('\x01' * offset + '\x00' * input.length, key);
  mapMatrix = _applyPasswordToMatrix(mapMatrix, password);

  var matrix = List<List<String>>.from(mapMatrix);

  int i = 0;
  mapMatrix.asMap().forEach((rowIndex, row) {
    row.asMap().forEach((columnIndex, cell) {
      if (cell == '\x00') matrix[rowIndex][columnIndex] = input[i++];
    });
  });

  var out = '';
  for (i = 0; i < input.length + offset; i++) {
    for (int j = 0; j < key; j++) {
      if (matrix[j][i] != '.') out += matrix[j][i];
    }
  }

  return out.replaceAll('\x01', '');
}
