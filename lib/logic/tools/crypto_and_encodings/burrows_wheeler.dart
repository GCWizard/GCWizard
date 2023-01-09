class BWTOutput {
  String text;
  String index;

  BWTOutput(this.text, this.index);
}

BWTOutput encryptBurrowsWheeler(String plain, indexChar) {
  if (plain == '' || plain == null) return BWTOutput('', '');

  int len = plain.length;
  List<String> matrix = <String>[];

  matrix.add(plain);
  for (int i = 0; i < len - 1; i++) {
    matrix.add(plain.substring(len - i - 1) + plain.substring(0, len - i - 1));
  }

  matrix.sort();

  String chiffre = '';
  int index = 0;
  for (int i = 0; i < len; i++) {
    chiffre = chiffre + matrix[i].substring(len - 1);
    if (matrix[i] == plain) index = i;
  }

  if (int.tryParse(indexChar) == null)
    chiffre = chiffre.substring(0, index) + indexChar + chiffre.substring(index);
  else {
    index = index + 1;
    indexChar = index.toString();
  }

  return BWTOutput(chiffre, indexChar);
}

BWTOutput decryptBurrowsWheeler(String chiffre, indexChar) {
  if (chiffre == '' || chiffre == null) return BWTOutput('', '');

  int len = chiffre.length;
  int index = 0;
  String input = '';

  if (int.tryParse(indexChar) == null) {
    // index is encoded with a special symbol within the chiffre
    for (int i = 0; i < len; i++) {
      if (chiffre[i] != indexChar)
        input = input + chiffre[i];
      else
        index = i;
    }
    len = len - 1;
  } else {
    index = int.parse(indexChar) - 1;
    input = chiffre;
  }
  Map<int, List<String>> tabelle = new Map<int, List<String>>();

  for (int i = 0; i < len; i++) {
    tabelle[i] = ([i.toString(), input[i]]);
  }

  for (int i = 0; i < len; i++) {
    for (int j = 0; j < len - 1; j++) {
      if (tabelle[j][1].compareTo(tabelle[j + 1][1]) == 1) {
        var h = tabelle[j];
        tabelle[j] = tabelle[j + 1];
        tabelle[j + 1] = h;
      }
    }
  }

  String decoded = '';
  for (int i = 0; i < len; i++) {
    if (tabelle[index] != null) {
      decoded = decoded + tabelle[index][1];
      index = int.parse(tabelle[index][0]);
    }
  }

  return BWTOutput(decoded, indexChar);
}
