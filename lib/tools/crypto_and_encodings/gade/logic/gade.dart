//http://www.crumlin.dk/geocaching/gade/#:~:text=A%20Gade%20is%20a%20method%2C%20invented%20by%20the,least%20one%20variable%20containing%20each%20digit%20%28including%20zero%29.

Map<String, String> buildGade(String input) {
  var outputList = <String>[];
  var gadeMap = new Map<String, String>();

  outputList = input.replaceAll(RegExp(r'[^0-9]'), '').split('');
  outputList.sort();

  for (int index = 0; index <= 9; index++) {
    if (!outputList.contains(index.toString())) {
      outputList.add(index.toString());
    }
  }

  for (int index = 0; index < outputList.length; index++) {
    if (index < 26) {
      gadeMap[String.fromCharCode(index + 65)] = outputList[index];
    }
  }

  return gadeMap;
}
