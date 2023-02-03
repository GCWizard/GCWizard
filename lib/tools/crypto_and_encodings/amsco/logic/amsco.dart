import 'dart:math';

class AmscoOutput {
  final String output;
  final String grid;
  final ErrorCode errorCode;

  AmscoOutput(this.output, this.grid, this.errorCode);
}

enum ErrorCode { OK, Key }

bool _validKey(String key) {
  if (key == null || key == '') return false;

  if (int.tryParse(key) == null) return false;

  if (key.contains('0')) return false;

  //doubles numbers ?
  if (key.length != key.split('').toSet().join().length) return false;

  // all numbers consecutively?
  for (int i = 1; i <= key.length; i++) {
    if (!key.contains(i.toString())) return false;
  }

  return true;
}

String _cleanKey(String key) {
  return key.replaceAll(' ', '');
}

Map<String, List<String>> _createAmscoGrid(String input, String key, bool oneCharStart, bool decrypt) {
  var grid = Map<String, List<String>>();

  input = input.replaceAll(' ', '');
  input = input.toUpperCase();

  for (int i = 0; i < key.toString().length; i++) {
    grid.addAll({key[i]: <String>[]});
  }

  int i = 0;
  bool twoChar;
  while (i < input.length) {
    grid.keys.forEach((_key) {
      if (i < input.length) {
        twoChar = (key.indexOf(_key) % 2) == (oneCharStart ? 1 : 0);
        if (key.length % 2 == 1) {
          if (grid[_key].length % 2 == 1) twoChar = !twoChar;
        }

        grid[_key].add(input.substring(i, twoChar ? min(i + 2, input.length) : i + 1));
        i += twoChar ? 2 : 1;
        twoChar = !twoChar;
      }
    });
  }

  if (decrypt) {
    i = 0;
    for (int column = 1; column <= key.length; column++) {
      for (int row = 0; row < grid[column.toString()].length; row++) {
        var textLength = grid[column.toString()][row].length;
        grid[column.toString()][row] = input.substring(i, i + textLength);
        i += textLength;
      }
    }
  }

  return grid;
}

AmscoOutput encryptAmsco(String input, String key, bool oneCharStart) {
  if (input == null || key == null || input == '' || key == '') return AmscoOutput('', '', ErrorCode.OK);

  key = _cleanKey(key);
  if (!_validKey(key)) return AmscoOutput('', '', ErrorCode.Key);

  var grid = _createAmscoGrid(input, key, oneCharStart, false);
  var sortedKeys = grid.keys.toList();
  var output = '';

  sortedKeys.sort();
  sortedKeys.forEach((_key) {
    grid[_key].forEach((text) {
      output += text;
    });
  });

  return AmscoOutput(output, _amscoGridToString(grid), ErrorCode.OK);
}

AmscoOutput decryptAmsco(String input, String key, bool oneCharStart) {
  if (input == null || key == null || input == '' || key == '') return AmscoOutput('', '', ErrorCode.OK);

  key = _cleanKey(key);
  if (!_validKey(key)) return AmscoOutput('', '', ErrorCode.Key);

  var grid = _createAmscoGrid(input, key, oneCharStart, true);
  var row = 0;
  var finish = false;
  var output = '';

  while (!finish) {
    key.split('').forEach((_key) {
      if (row >= grid[_key].length) finish = true;
      if (!finish) output += grid[_key][row];
    });
    row += 1;
  }

  return AmscoOutput(output, _amscoGridToString(grid), ErrorCode.OK);
}

String _amscoGridToString(Map<String, List<String>> grid) {
  var row = 0;
  var finish = false;
  var output = '';

  grid.keys.forEach((_key) {
    output += _key.toString().padRight(2) + " ";
  });
  output += '\n';

  while (!finish) {
    grid.keys.forEach((_key) {
      if (row >= grid[_key].length) finish = true;
      if (!finish) output += grid[_key][row].padRight(2) + " ";
    });
    output += '\n';
    row += 1;
  }

  return output;
}
