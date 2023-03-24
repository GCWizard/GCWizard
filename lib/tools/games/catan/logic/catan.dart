enum CatanMode { BASE, EXPANSION }

const Map<String, int> _catanBaseAZToNumbers = {
  "A": 5,
  "B": 2,
  "C": 6,
  "D": 3,
  "E": 8,
  "F": 10,
  "G": 9,
  "H": 12,
  "I": 11,
  "J": 4,
  "K": 8,
  "L": 10,
  "M": 9,
  "N": 4,
  "O": 5,
  "P": 6,
  "Q": 3,
  "R": 11
};

const Map<String, int> _catanExpansionAZToNumbers = {
  "A": 2,
  "B": 5,
  "C": 4,
  "D": 6,
  "E": 3,
  "F": 9,
  "G": 8,
  "H": 11,
  "I": 11,
  "J": 10,
  "K": 6,
  "L": 3,
  "M": 8,
  "N": 4,
  "O": 8,
  "P": 10,
  "Q": 11,
  "R": 12,
  "S": 10,
  "T": 5,
  "U": 4,
  "V": 9,
  "W": 5,
  "X": 9,
  "Y": 12,
  "Za": 3,
  "Zb": 2,
  "Zc": 6,
};

List<int> encodeCatan(String input, CatanMode mode) {
  if (input.isEmpty) return <int>[];

  input = input.toUpperCase();

  var values = <int>[];
  while (input.isNotEmpty) {
    int? value;

    if (mode == CatanMode.EXPANSION && input.startsWith('Z')) {
      if (input.length == 1) break;

      value = _catanExpansionAZToNumbers['Z' + input[1].toLowerCase()];
      if (value != null) {
        values.add(value);

        if (input.length > 2) {
          input = input.substring(2);
          continue;
        } else {
          break;
        }
      } else {
        input = input.substring(1);
        continue;
      }
    }

    var letter = input[0];
    if (mode == CatanMode.BASE) {
      value = _catanBaseAZToNumbers[letter];
    } else {
      value = _catanExpansionAZToNumbers[letter];
    }

    if (value != null) values.add(value);

    if (input.length > 1) {
      input = input.substring(1);
    } else {
      break;
    }
  }

  return values;
}
