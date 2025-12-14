// http://www.crumlin.dk/geocaching/gade/#:~:text=A%20Gade%20is%20a%20method%2C%20invented%20by%20the,least%20one%20variable%20containing%20each%20digit%20%28including%20zero%29.
// https://gcwiki.dk/doku.php?id=gade_beregningsteknik
// https://gcwiki.dk/doku.php?id=edag_beregningsteknik&s%5b%5d=gade
// https://gcwiki.dk/doku.php?id=lowe_beregningsteknik
// https://gcwiki.dk/doku.php?id=ewol

enum GADE_TYPES {GADE, EDAG, LOWE, EWOL}

Map<GADE_TYPES, String> gadeTypes = {
  GADE_TYPES.GADE: 'GADE',
  GADE_TYPES.EDAG: 'EDAG',
  GADE_TYPES.LOWE: 'LOWE',
  GADE_TYPES.EWOL: 'EWOL',
};

Map<String, String> calculateGade(GADE_TYPES type, String input){
  switch (type) {
    case GADE_TYPES.GADE: return _buildGade(input);
    case GADE_TYPES.EDAG: return _buildEdag(input);
    case GADE_TYPES.LOWE: return _buildLowe(input);
    case GADE_TYPES.EWOL: return _buildEwol(input);
  }
}

Map<String, String> _buildLowe(String input) {
  var inputList = <String>[];
  var oddList = <String>[];
  var evenList = <String>[];
  var outputList = <String>[];

  var gadeMap = <String, String>{};

  inputList = input.replaceAll(RegExp(r'\D'), '').split('');
  inputList.sort();

  for (int i = 0; i < inputList.length; i++) {
    if (int.parse(inputList[i]) % 2 == 0) {
      evenList.add(inputList[i]);
    } else {
      oddList.add(inputList[i]);
    }
  }

  for (int i = 0; i <= 9; i++) {
    if (i % 2 == 0) {
      if (!evenList.contains(i.toString())) {
        evenList.add(i.toString());
      }
    } else {
      if (!oddList.contains(i.toString())) {
        oddList.add(i.toString());
      }
    }
  }

  outputList.addAll(evenList);
  outputList.addAll(oddList);
  for (int index = 0; index < outputList.length; index++) {
    if (index <= 26) {
      gadeMap[String.fromCharCode(index + 65)] = outputList[index];
    }
  }

  return gadeMap;
}

Map<String, String> _buildEwol(String input) {
  var inputList = <String>[];
  var oddList = <String>[];
  var evenList = <String>[];
  var outputList = <String>[];

  var gadeMap = <String, String>{};

  inputList = input.replaceAll(RegExp(r'\D'), '').split('');
  inputList.sort();
  inputList = inputList.reversed.toList();

  for (int i = 0; i < inputList.length; i++) {
    if (int.parse(inputList[i]) % 2 == 0) {
      evenList.add(inputList[i]);
    } else {
      oddList.add(inputList[i]);
    }
  }

  for (int i = 9; i >= 0; i--) {
    if (i % 2 == 0) {
      if (!evenList.contains(i.toString())) {
        evenList.add(i.toString());
      }
    } else {
      if (!oddList.contains(i.toString())) {
        oddList.add(i.toString());
      }
    }
  }

  outputList.addAll(oddList);
  outputList.addAll(evenList);
  for (int index = 0; index < outputList.length; index++) {
    if (index <= 26) {
      gadeMap[String.fromCharCode(index + 65)] = outputList[index];
    }
  }

  return gadeMap;
}

Map<String, String> _buildEdag(String input) {
  var outputList = <String>[];
  var gadeMap = <String, String>{};

  outputList = input.replaceAll(RegExp(r'\D'), '').split('');
  outputList.sort();
  outputList = outputList.reversed.toList();


  for (int index = 9; index >= 0; index--) {
    if (!outputList.contains(index.toString())) {
      outputList.add(index.toString());
    }
  }

  for (int index = 0; index < outputList.length; index++) {
    if (index <= 26) {
      gadeMap[String.fromCharCode(index + 65)] = outputList[index];
    }
  }

  return gadeMap;
}

Map<String, String> _buildGade(String input) {
  var outputList = <String>[];
  var gadeMap = <String, String>{};

  outputList = input.replaceAll(RegExp(r'\D'), '').split('');
  outputList.sort();

  for (int index = 0; index <= 9; index++) {
    if (!outputList.contains(index.toString())) {
      outputList.add(index.toString());
    }
  }

  for (int index = 0; index < outputList.length; index++) {
    if (index <= 26) {
      gadeMap[String.fromCharCode(index + 65)] = outputList[index];
    }
  }

  return gadeMap;
}
