
const highKey = 'SCOUT';
const lowKey = 'scout';

const matrix = [
  ['A', 'B', 'C', 'D', 'E'],
  ['F', 'G', 'H', 'I', 'J'],
  ['K', 'L', 'M', 'N', 'O'],
  ['P', 'R', 'S', 'T', 'U'],
  ['V', 'Y', 'Å', 'Ä', 'Ö'],
];

const encodeMap = {
  'A': 'Ss',
  'B': 'Cs',
  'C': 'Os',
  'D': 'Us',
  'E': 'Ts',
  'F': 'Sc',
  'G': 'Cc',
  'H': 'Oc',
  'I': 'Uc',
  'J': 'Tc',
  'K': 'So',
  'L': 'Co',
  'M': 'Oo',
  'N': 'Uo',
  'O': 'To',
  'P': 'Su',
  'R': 'Cu',
  'S': 'Ou',
  'T': 'Uu',
  'U': 'Tu',
  'V': 'St',
  'Y': 'Ct',
  'Å': 'Ot',
  'Ä': 'Ut',
  'Ö': 'Tt',
};

class RangeException implements Exception {
  final String symbol;
  const RangeException(this.symbol);
  @override
  String toString() => 'RangeException: $symbol';
}

String decodeScout(String input) {
  if (input.isEmpty) return '';

  var parts = input.split(" ");

  List<String> out = [];
  for (var part in parts) {
    if (part.length != 2) {
      return '';
    }
    var hc = part[0];
    var lc = part[1];

    var hi = highKey.indexOf(hc);
    var li = lowKey.indexOf(lc);

    if (hi < 0 || li < 0) {
      throw RangeException(part);
    }

    out.add(matrix[li][hi]);
  }

  return out.join(" ");
}

String encodeScout(String input) {
  if (input.isEmpty) return '';

   var inputUp = input.toUpperCase();
   var parts = inputUp.split("");

  List<String> out = [];
  for (var inp in parts) {
    if (encodeMap.containsKey(inp)) {
      out.add(encodeMap[inp]!);
    } else {
      throw RangeException(inp);
    }
   }
  return out.join(" ");
}

