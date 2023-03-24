import 'dart:math';

import 'package:gc_wizard/tools/science_and_technology/primes/_common/logic/primes.dart';
import 'package:gc_wizard/utils/string_utils.dart';
import 'package:intl/intl.dart';

part 'package:gc_wizard/tools/crypto_and_encodings/esoteric_programming_languages/chef_language/logic/chef_international.dart';
part 'package:gc_wizard/tools/crypto_and_encodings/esoteric_programming_languages/chef_language/logic/component.dart';
part 'package:gc_wizard/tools/crypto_and_encodings/esoteric_programming_languages/chef_language/logic/container.dart';
part 'package:gc_wizard/tools/crypto_and_encodings/esoteric_programming_languages/chef_language/logic/ingredient.dart';
part 'package:gc_wizard/tools/crypto_and_encodings/esoteric_programming_languages/chef_language/logic/kitchen.dart';
part 'package:gc_wizard/tools/crypto_and_encodings/esoteric_programming_languages/chef_language/logic/method.dart';
part 'package:gc_wizard/tools/crypto_and_encodings/esoteric_programming_languages/chef_language/logic/recipe.dart';
part 'package:gc_wizard/tools/crypto_and_encodings/esoteric_programming_languages/chef_language/logic/chef.dart';

List<String> _getAuxiliaryRecipe(String name, int value, List<String> ingredientOne, List<String> ingredientTwo, String language) {
  List<String> output = <String>[];
  bool combine = true;
  List<BigInt> nList = <BigInt>[];
  int nOne = 0;
  int nTwo = 0;

  if (isPrime(BigInt.from(value))) {
    combine = false;
    nOne = value ~/ 5 * 2;
    nTwo = value - nOne;
  } else {
    combine = true;
    nList = integerFactorization(value);
    if (nList.length != 2) {
      nOne = value;
      for (int i = 0; i < nList.length - 1; i++) {
        if (nOne > sqrt(value)) {
          nOne = nOne ~/ nList[i].toInt();
        } else {
          break;
        }
      }
      nTwo = value ~/ nOne;
    } else {
      nOne = nList[0].toInt();
      nTwo = nList[1].toInt();
    }
  }
  output.add(name);
  output.add('');
  output.add(_getText(_CHEF_textId.Ingredients, '', language));
  output.add(nOne.toString() + ' ' + ingredientOne[0] + ' ' + ingredientOne[1]);
  output.add(nTwo.toString() + ' ' + ingredientTwo[0] + ' ' + ingredientTwo[1]);
  output.add('');
  output.add(_getText(_CHEF_textId.Method, '', language));
  output.add(_getText(_CHEF_textId.Put, ingredientOne[1], language));
  if (combine) {
    output.add(_getText(_CHEF_textId.Combine, ingredientTwo[1], language));
  } else {
    output.add(_getText(_CHEF_textId.Add, ingredientTwo[1], language));
  }
  return output;
}

String generateChef(
    String language,String title, String remark, String time, String temperature, String outputToGenerate, bool auxiliary) {
  int value = 0;
  int i = 0;
  var output = StringBuffer();
  List<String> outputElements = <String>[]; // store the output elements
  List<String> methodList = <String>[]; // store the methods
  List<String> ingredientList = <String>[]; // store the ingredients
  Map<String, List<String>> auxiliaryRecipes = <String, List<String>>{}; // store the auxiliary recipes

  Map<int, String> amount = <int, String>{}; // store the already got value
  Map<String, String> ingredientListed = <String, String>{}; // store the already used ingredients

  List<String> itemList = <String>[]; // List with all ingredients
  List<String> itemListLiquid = <String>[]; // List with only liquid ingredients
  List<String> itemListDry = <String>[]; // List with only dry ingredients
  List<String> itemListMeasuresLiquid = <String>[]; // List with measures for liquid ingredients
  List<String> itemListMeasuresDry = <String>[]; // List with measures for dry ingredients
  List<String> itemListMeasure = <String>[]; // List with all measures
  List<List<String>> itemListAuxiliary = <List<String>>[]; // List with strinds to generate title of an aux recipe

  String item = '';
  String measure = '';
  String auxiliaryName = '';

  List<String> ingredientOne = <String>[]; // store 1st ingredient, amount an measure for aux recipe
  List<String> ingredientTwo = <String>[]; // store 2nd ingredient, amount an measure for aux recipe

  Random random = Random();

  // fill the lists for the ingredients depending on language
  if (language == 'ENG') {
    itemListDry.addAll(_CHEF_itemListDryENG);
    itemListLiquid.addAll(_CHEF_itemListLiquidENG);
    itemListAuxiliary.addAll(_CHEF_itemListAuxiliaryENG);
    itemListMeasure.addAll(_CHEF_measuresENG);
    itemListMeasuresLiquid.addAll(_CHEF_liquidMeasuresENG);
    itemListMeasuresDry.addAll(_CHEF_dryMeasuresENG);
  } else {
    itemListDry.addAll(_CHEF_itemListDryDEU);
    itemListLiquid.addAll(_CHEF_itemListLiquidDEU);
    itemListAuxiliary.addAll(_CHEF_itemListAuxiliaryDEU);
    itemListMeasure.addAll(_CHEF_measuresDEU);
    itemListMeasuresLiquid.addAll(_CHEF_liquidMeasuresDEU);
    itemListMeasuresDry.addAll(_CHEF_dryMeasuresDEU);
  }

  if (auxiliary) {
    // have to be used add ingredient to generate a space-char
    if (language == 'ENG') {
      amount[32] = 'ambergris';
      ingredientList.add(32.toString() + ' ml ambergris');
    } else {
      amount[32] = 'Ambra';
      ingredientList.add(32.toString() + ' ml Ambra');
    }

    // divide output into groups of digits and non-digits
    RegExp expr = RegExp(r'(([\D]+)|([\d]+))+?'); // any non digit | any digit
    expr.allMatches(outputToGenerate).forEach((match) {
      if (match.group(1) != null) {
        outputElements.add(match.group(1)!);
      }
    });

    // reverse every output-element - it is a stack, so last in first out!
    for (i = 0; i < outputElements.length / 2; i++) {
      var temp = outputElements[i];
      if (int.tryParse(temp) == null) temp = temp.split('').reversed.join('');
      if (int.tryParse(outputElements[outputElements.length - 1 - i]) == null) {
        outputElements[i] = outputElements[outputElements.length - 1 - i].split('').reversed.join('');
      } else {
        outputElements[i] = outputElements[outputElements.length - 1 - i];
      }
      outputElements[outputElements.length - 1 - i] = temp;
    }

    i = 0;
    for (var element in outputElements) {
      // check element => number => 0 - 9    => 48 - 57 = liquid
      //                            10 - 99  => numbers = dry
      //                            100 ...  => aux recipe
      //                  string => all char => liquid
      if (int.tryParse(element) != null) {
        // element is a number
        value = int.parse(element);
        if (value < 10) {
          // => digit 0-9 => store digit as charcode 48 - 57 => liquid ingredient
          value = value + 48;
          if (amount[value] == null) {
            // value was not used before <=> a new digit
            item = itemListLiquid.elementAt(random.nextInt(itemListLiquid.length));
            while (ingredientListed[item] != null) {
              item = itemListLiquid.elementAt(random.nextInt(itemListLiquid.length));
            }
            ingredientListed[item] = item;
            measure = itemListMeasuresLiquid.elementAt(random.nextInt(itemListMeasuresLiquid.length));
            ingredientList.add(value.toString() + ' ' + measure + ' ' + item);
            amount[value] = item;
            methodList.add(_getText(_CHEF_textId.Put, amount[value]!, language));
          } else {
            // digit was already processed
            methodList.add(_getText(_CHEF_textId.Put, amount[value]!, language));
          }
        } else if (value < 100) {
          // => number 10-99 => store number as char with charcode 10 - 99 => dry, unspecific ingredients
          if (amount[value] == null) {
            // value was not used before <=> a new a new number
            item = itemListDry.elementAt(random.nextInt(itemListDry.length));
            measure = itemListMeasuresDry.elementAt(random.nextInt(itemListMeasuresDry.length));
            while (ingredientListed[item] != null) {
              item = itemListDry.elementAt(random.nextInt(itemListDry.length));
            }
            ingredientListed[item] = item;
            ingredientList.add(value.toString() + ' ' + measure + ' ' + item);
            amount[value] = item;
            methodList.add(_getText(_CHEF_textId.Put, amount[value]!, language));
          } else {
            // number was already processed
            if (itemListLiquid.contains(amount[value])) {
              // value is used with liquid => process and get new dry ingredient
              item = itemListDry.elementAt(random.nextInt(itemListDry.length));
              measure = itemListMeasuresDry.elementAt(random.nextInt(itemListMeasuresDry.length));
              while (ingredientListed[item] != null) {
                item = itemListDry.elementAt(random.nextInt(itemListDry.length));
              }
              ingredientListed[item] = item;
              ingredientList.add(value.toString() + ' ' + measure + ' ' + item);
              amount[value] = item;
              methodList.add(_getText(_CHEF_textId.Put, amount[value]!, language));
            } else {
              methodList.add(_getText(_CHEF_textId.Put, amount[value]!, language));
            }
          }
        } else {
          // value >= 100 => auxiliary recipe to provide number: pour, clean, serve with, pour

          // build name for auxiliary recipe
          auxiliaryName = itemListAuxiliary[0][random.nextInt(4)] +
              itemListAuxiliary[1][random.nextInt(4)] +
              itemListAuxiliary[2][random.nextInt(4)] +
              itemListAuxiliary[3][random.nextInt(4)];
          while (auxiliaryRecipes[auxiliaryName] != null) {
            auxiliaryName = itemListAuxiliary[0][random.nextInt(4)] +
                itemListAuxiliary[1][random.nextInt(4)] +
                itemListAuxiliary[2][random.nextInt(4)] +
                itemListAuxiliary[3][random.nextInt(4)];
          }
          // get two ingredients to calculate value
          ingredientOne = [
            itemListMeasuresDry.elementAt(random.nextInt(itemListMeasuresDry.length)),
            itemListDry.elementAt(random.nextInt(itemListDry.length))
          ];
          ingredientTwo = [
            itemListMeasuresDry.elementAt(random.nextInt(itemListMeasuresDry.length)),
            itemListDry.elementAt(random.nextInt(itemListDry.length))
          ];
          while (ingredientTwo.elementAt(1) == ingredientOne.elementAt(1)) {
            ingredientTwo = [
              itemListMeasuresDry.elementAt(random.nextInt(itemListMeasuresDry.length)),
              itemListDry.elementAt(random.nextInt(itemListDry.length))
            ];
          }
          // build auxiliary recipe
          auxiliaryRecipes[auxiliaryName] =
              _getAuxiliaryRecipe(auxiliaryName, value, ingredientOne, ingredientTwo, language);
          if (i > 0) {
            methodList.add(_getText(_CHEF_textId.Pour, '', language));
            methodList.add(_getText(_CHEF_textId.Clean, '', language));
          }
          methodList.add(_getText(_CHEF_textId.Serve_with, auxiliaryName, language));
        }
      } else {
        // element is a string of non-digits  => Liquid ingredients
        List<String> Elements = element.split('');
        for (var element in Elements) {
          value = element.codeUnitAt(0);
          if (amount[value] == null) {
            // a new character
            item = itemListLiquid.elementAt(random.nextInt(itemListLiquid.length)); // get liquid item [measure,name]
            measure = itemListMeasuresLiquid.elementAt(random.nextInt(itemListMeasuresLiquid.length));

            while (ingredientListed[item] != null) {
              // ingredient already in use
              item = itemListLiquid.elementAt(random.nextInt(itemListLiquid.length));
            }
            ingredientListed[item] = item;
            ingredientList.add(value.toString() + ' ' + measure + ' ' + item);
            amount[value] = item;
            methodList.add(_getText(_CHEF_textId.Put, amount[value]!, language));
          } else {
            // character was already processed {
            methodList.add(_getText(_CHEF_textId.Put, amount[value]!, language));
          }
        }
      }
      i++;
    } // outputElements.forEach((element)
  } else {
    // build "normal" linear recipe
    itemList.addAll(itemListDry);
    itemList.addAll(itemListLiquid);
    itemListMeasure.addAll(itemListMeasuresDry);
    itemListMeasure.addAll(itemListMeasuresLiquid);

    outputElements = outputToGenerate.split('');
    for (int i = 0; i < outputElements.length / 2; i++) {
      var temp = outputElements[i];
      outputElements[i] = outputElements[outputElements.length - 1 - i];
      outputElements[outputElements.length - 1 - i] = temp;
    }
    for (var element in outputElements) {
      value = element.codeUnitAt(0);
      if (amount[value] == null) {
        item = itemList.elementAt(random.nextInt(itemList.length));
        measure = itemListMeasure.elementAt(random.nextInt(itemListMeasure.length));
        while (ingredientListed[item] != null) {
          item = itemList.elementAt(random.nextInt(itemList.length));
        }
        ingredientListed[item] = item;
        ingredientList.add(value.toString() + ' ' + measure + ' ' + item);
        amount[value] = item;
        methodList.add(_getText(_CHEF_textId.Put, amount[value]!, language));
      } else {
        methodList.add(_getText(_CHEF_textId.Put, amount[value]!, language));
      }
    }
  }

  output.writeln(title + '.');
  output.writeln('');
  if (remark.isNotEmpty) output.writeln(remark + '\n');
  output.writeln(_getText(_CHEF_textId.Ingredients, '', language));
  output.writeln(ingredientList.join('\n'));
  output.writeln('');
  if (int.tryParse(time) != null) {
    output.writeln(_getText(_CHEF_textId.Cooking_time, time, language) + '\n');
  }
  if (int.tryParse(temperature) != null) {
    output.writeln(_getText(_CHEF_textId.Pre_heat_oven, temperature, language) + '\n');
  }
  output.writeln(_getText(_CHEF_textId.Method, '', language));
  output.writeln(methodList.join('\n'));
  if (!auxiliary) output.writeln(_getText(_CHEF_textId.Liquefy_contents, '', language));
  output.writeln(_getText(_CHEF_textId.Pour, '', language));
  output.writeln('');
  output.writeln(_getText(_CHEF_textId.Serves, '', language));

  auxiliaryRecipes.forEach((key, value) {
    output.writeln('\n');
    for (int i = 0; i < value.length; i++) {
      output.writeln(value[i]);
    }
  });
  if (auxiliaryRecipes.isNotEmpty) {}
  return output.toString().replaceAll('  ', ' ');
}

bool isValid(String input) {
  bool flag = true;
  if (input.isEmpty) return true;
  List<String> numbers = input.split(' ');
  for (var element in numbers) {
    if (int.tryParse(element) == null) {
      flag = false;
    }
  }
  return flag;
}

List<String> interpretChef(String language, String? recipe, String? input) {
  if (recipe == null || recipe.isEmpty) return <String>[];

  return _decodeChef(language, normalizeUmlauts(recipe.toLowerCase().replaceAll(RegExp(r' +'), ' ')), input ?? '');
}

List<String> _decodeChef(String language, String recipe, String additionalIngredients) {
  _Chef interpreter = _Chef(recipe, language);
  List<String> result = [];
  if (interpreter.valid) {
    interpreter.bake(language, additionalIngredients);

    if (interpreter.valid) {
      result.addAll(interpreter.meal);

      if (interpreter.liquefyMissing) {
        result.add('');
        result.add('chef_warning_liquefy_missing_title');
        if (language == "ENG") {
          result.add('» Liquefy contents of the mixing bowl. «');
        } else {
          result.add('» Inhalt der Schüssel auf dem Stövchen erhitzen. «');
        }
        result.add('chef_warning_liquefy_missing_hint');
        if (language == "ENG") {
          result.add('» Pour contents of the mixing bowl into the baking dish. «');
        } else {
          result.add('» Schüssel in eine Servierschale stürzen. «');
        }
      }
      return result;
    } else {
      // runtime error
      return interpreter.error;
    }
  } else {
    // invalid recipe
    return interpreter.error;
  }
}

bool _isMethod(String testString) {
  bool result = false;
  for (var element in _CHEF_matchersDEU) {
    if (element.hasMatch(testString)) result = true;
  }
  for (var element in _CHEF_matchersENG) {
    if (element.hasMatch(testString)) result = true;
  }
  return result;
}


