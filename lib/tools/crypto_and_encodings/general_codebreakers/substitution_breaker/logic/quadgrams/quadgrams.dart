part of 'package:gc_wizard/tools/crypto_and_encodings/general_codebreakers/substitution_breaker/logic/substitution_logic_aggregator.dart';

class Quadgrams extends _Quadgrams {
  static const int maxAlphabetLength = 32;
  Map<int, List<int>> quadgramsCompressed;
  String assetLocation;
  List<int> _quadgrams;

  List<int> quadgrams() {
    if (_quadgrams != null) return _quadgrams;

    if (quadgramsCompressed == null) return null;

    _quadgrams = decompressQuadgrams(quadgramsCompressed, pow(Quadgrams.maxAlphabetLength, 3) * alphabet.length);
    quadgramsCompressed = null;
    return _quadgrams;
  }

  static Map<int, List<int>> compressQuadgrams(List<int> quadgrams) {
    var map = Map<int, List<int>>();
    var blockStart = -1;
    const int zeroCount = 5;

    for (int i = 0; i < quadgrams.length; i++) {
      if ((blockStart < 0) && (quadgrams[i] != 0)) blockStart = i;

      if (blockStart >= 0) {
        // if five 0 => new list
        if (((i + zeroCount < quadgrams.length) &&
            (quadgrams[i + 1] == 0) | (quadgrams[i + 1] == null) &&
            (quadgrams[i + 2] == 0) | (quadgrams[i + 2] == null) &&
            (quadgrams[i + 3] == 0) | (quadgrams[i + 3] == null) &&
            (quadgrams[i + 4] == 0) | (quadgrams[i + 4] == null) &&
            (quadgrams[i + 5] == 0) | (quadgrams[i + 5] == null)) ||
            (i + zeroCount >= quadgrams.length)) {
          var quadgramList = <int>[];
          quadgramList.addAll(quadgrams.getRange(
              blockStart, (i + zeroCount >= quadgrams.length) ? quadgrams.length : min(i + 1, quadgrams.length)));
          map.addAll({blockStart: quadgramList});
          i += zeroCount;
          blockStart = -1;
        }
      }
    }
    return map;
  }

  static List<int> decompressQuadgrams(Map<int, List<int>> quadgramsCompressed, int size) {
    if (quadgramsCompressed == null) return null;
    var list = List<int>(size);

    list.fillRange(0, list.length, 0);

    quadgramsCompressed.forEach((idx, values) {
      for (int i = idx; i < idx + values.length; i++) {
        list[i] = values[i - idx];
      }
    });
    return list;
  }

  static String quadgramsMapToString(Map<int, List<int>> quadgramsCompressed) {
    var sb = new StringBuffer();
    bool first = true;
    bool firstEntry = true;
    String out = '';
    var idx = 0;
    sb.write('{"');
    quadgramsCompressed.forEach((idx, values) {
      if (firstEntry)
        firstEntry = false;
      else
        sb.write(',"');
      sb.write(idx.toString());
      sb.write('":');
      sb.write('[');
      first = true;
      values.forEach((val) {
        if (first)
          first = false;
        else
          sb.write(',');
        if (val == null) val = 0;
        out = val.round().toString();
        sb.write(out);
      });
      sb.write(']');
    });
    sb.write('}');

    out = '';
    out = sb.toString().split('').map((char) {
      if (idx > 230 && ((char == ',') | (char == '}'))) {
        idx = 0;
        return char + '\n';
      } else {
        idx += 1;
        return char;
      }
    }).join();

    return out;
  }

  static String quadgramsListToString(List<int> quadgrams) {
    var sb = new StringBuffer();
    bool first = true;
    var idx = 0;
    String out = '';
    quadgrams.forEach((val) {
      if (first)
        first = false;
      else
        sb.write(',');
      if (val == null) val = 0;
      out = val.round().toString();
      sb.write(out);
      idx += out.length + 1;
      if (idx > 230) {
        sb.write("\n");
        idx = 0;
      }
    });
    return sb.toString();
  }
}
