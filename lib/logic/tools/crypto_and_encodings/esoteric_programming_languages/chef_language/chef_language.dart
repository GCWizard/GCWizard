import 'dart:math';
import 'package:gc_wizard/logic/tools/crypto_and_encodings/esoteric_programming_languages/chef_language/kitchen.dart';
import 'package:gc_wizard/logic/tools/crypto_and_encodings/esoteric_programming_languages/chef_language/recipe.dart';
import 'package:gc_wizard/logic/tools/science_and_technology/primes/primes.dart';
import 'package:gc_wizard/logic/tools/crypto_and_encodings/esoteric_programming_languages/chef_language/chef_international.dart';

List<String> _getAuxiliaryRecipe(String name, int value, List<String> ingredientOne, ingredientTwo, String language){
  List<String> output = new List<String>();
  bool combine = true;
  List<BigInt> nList = new List<BigInt>();
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
      for (int i = 0; i < nList.length - 1; i++){
        if (nOne > sqrt(value))
          nOne = nOne ~/ nList[i].toInt();
        else
          break;
      }
      nTwo = value ~/ nOne;
    } else {
      nOne = nList[0].toInt();
      nTwo = nList[1].toInt();
    }
  }
  output.add(name);
  output.add('');
  output.add(getText(textId.Ingredients, '', language));
  output.add(nOne.toString() + ' ' + ingredientOne[0] + ' ' + ingredientOne[1]);
  output.add(nTwo.toString() + ' ' + ingredientTwo[0] + ' ' + ingredientTwo[1]);
  output.add('');
  output.add(getText(textId.Method, '', language));
  output.add(getText(textId.Put, ingredientOne[1], language));
  if (combine)
    output.add(getText(textId.Combine, ingredientTwo[1], language));
  else
    output.add(getText(textId.Add, ingredientTwo[1], language));
  return output;
}


String generateChef(String language, title, String remark, String time, String temperature, String outputToGenerate, bool auxiliary){
  int value = 0;
  int i = 0;
  var output = StringBuffer();
  List<String> outputElements = new List<String>();                                    // store the output elements
  List<String> methodList = new List<String>();                                   // store the methods
  List<String> ingredientList = new List<String>();                               // store the ingredients
  Map <String, List<String>> auxiliaryRecipes = new Map <String, List<String>>(); // store the auxiliary recipes

  Map<int, String> amount = new Map<int, String>();                               // store the already got value
  Map<String, String> ingredientListed = new Map<String, String>();               // store the already used ingredients

  List<String> itemList = new List<String>();                                          // List with all ingredients
  List<String> itemListLiquid= new List<String>();                                     // List with only liquid ingredients
  List<String> itemListDry = new List<String>();                                       // List with only dry ingredients
  List<String> itemListMeasuresLiquid= new List<String>();                             // List with measures for liquid ingredients
  List<String> itemListMeasuresDry = new List<String>();                               // List with measures for dry ingredients
  List<String> itemListMeasure = new List<String>();                                   // List with all measures
  List<List<String>> itemListAuxiliary = new List<List<String>>();                           // List with strinds to generate title of an aux recipe

  String item = '';  
  String measure = '';
  String auxiliaryName = '';
  
  List<String> ingredientOne = new List<String>();                                     // store 1st ingredient, amount an measure for aux recipe
  List<String> ingredientTwo = new List<String>();                                     // store 2nd ingredient, amount an measure for aux recipe
  
  Random random = new Random();

  // fill the lists for the ingredients depending on language
  if (language == 'ENG') {
    itemListDry.addAll(itemListDryENG);
    itemListLiquid.addAll(itemListLiquidENG);
    itemListAuxiliary.addAll(itemListAuxiliaryENG);
    itemListMeasure.addAll(measuresENG);
    itemListMeasuresLiquid.addAll(liquidMeasuresENG);
    itemListMeasuresDry.addAll(dryMeasuresENG);
  } else {
    itemListDry.addAll(itemListDryDEU);
    itemListLiquid.addAll(itemListLiquidDEU);
    itemListAuxiliary.addAll(itemListAuxiliaryDEU);
    itemListMeasure.addAll(measuresDEU);
    itemListMeasuresLiquid.addAll(liquidMeasuresDEU);
    itemListMeasuresDry.addAll(dryMeasuresDEU);
  }

  if (auxiliary) { // have to be used add ingredient to generate a space-char
    if (language == 'ENG'){
      amount[32] = 'ambergris';
      ingredientList.add(32.toString() + ' ml ambergris');
    } else {
      amount[32] = 'Ambra';
      ingredientList.add(32.toString() + ' ml Ambra');
    }

    // divide output into groups of digits and non-digits
    RegExp expr = new RegExp(r'(([\D]+)|([\d]+))+?'); // any non digit | any digit
    expr.allMatches(outputToGenerate).forEach((match) {
      if (match.group(1) != null) {
        outputElements.add(match.group(1));
      }
    });

    // reverse every output-element - it is a stack, so last in first out!
    for (i = 0; i < outputElements.length / 2; i++) {
      var temp = outputElements[i];
      if (int.tryParse(temp) == null)
        temp = temp.split('').reversed.join('');
      if (int.tryParse(outputElements[outputElements.length - 1 - i]) == null)
        outputElements[i] = outputElements[outputElements.length - 1 - i].split('').reversed.join('');
      else
        outputElements[i] = outputElements[outputElements.length - 1 - i];
      outputElements[outputElements.length - 1 - i] = temp;
    }

    i = 0;
    outputElements.forEach((element) {
      // check element => number => 0 - 9    => 48 - 57 = liquid
      //                            10 - 99  => numbers = dry
      //                            100 ...  => aux recipe
      //                  string => all char => liquid
      if (int.tryParse(element) != null) { // element is a number
        value = int.parse(element);
        if (value < 10) { // => digit 0-9 => store digit as charcode 48 - 57 => liquid ingredient
          value = value + 48;
          if (amount[value] == null) { // value was not used before <=> a new digit
            item = itemListLiquid.elementAt(random.nextInt(itemListLiquid.length));
            while (ingredientListed[item] != null) {
              item = itemListLiquid.elementAt(random.nextInt(itemListLiquid.length));
            }
            ingredientListed[item] = item;
            measure = itemListMeasuresLiquid.elementAt(random.nextInt(itemListMeasuresLiquid.length));
            ingredientList.add(value.toString() + ' ' + measure + ' ' +  item);
            amount[value] = item;
            methodList.add(getText(textId.Put, amount[value], language));
          }
          else { // digit was already processed
            methodList.add(getText(textId.Put, amount[value], language));
          }
        }
        else if (value < 100) { // => number 10-99 => store number as char with charcode 10 - 99 => dry, unspecific ingredients
          if (amount[value] == null) { // value was not used before <=> a new a new number
            item = itemListDry.elementAt(random.nextInt(itemListDry.length));
            measure = itemListMeasuresDry.elementAt(random.nextInt(itemListMeasuresDry.length));
            while (ingredientListed[item] != null) {
              item = itemListDry.elementAt(random.nextInt(itemListDry.length));
            }
            ingredientListed[item] = item;
            ingredientList.add(value.toString() + ' ' + measure + ' ' + item);
            amount[value] = item;
            methodList.add(getText(textId.Put, amount[value], language));
          } else { // number was already processed
             if (itemListLiquid.contains(amount[value])) { // value is used with liquid => process and get new dry ingredient
               item = itemListDry.elementAt(random.nextInt(itemListDry.length));
               measure = itemListMeasuresDry.elementAt(random.nextInt(itemListMeasuresDry.length));
               while (ingredientListed[item] != null) {
                 item = itemListDry.elementAt(random.nextInt(itemListDry.length));
               }
               ingredientListed[item] = item;
               ingredientList.add(value.toString() + ' ' + measure + ' ' + item);
               amount[value] = item;
               methodList.add(getText(textId.Put, amount[value], language));
             }
             else {
               methodList.add(getText(textId.Put, amount[value], language));
             }
          }
        }
        else { // value >= 100 => auxiliary recipe to provide number: pour, clean, serve with, pour

          // build name for auxiliary recipe
          auxiliaryName = itemListAuxiliary[0][random.nextInt(4)] + itemListAuxiliary[1][random.nextInt(4)] + itemListAuxiliary[2][random.nextInt(4)] + itemListAuxiliary[3][random.nextInt(4)];
          while (auxiliaryRecipes[auxiliaryName] != null) {
            auxiliaryName = itemListAuxiliary[0][random.nextInt(4)] + itemListAuxiliary[1][random.nextInt(4)] + itemListAuxiliary[2][random.nextInt(4)] + itemListAuxiliary[3][random.nextInt(4)];
          }
          // get two ingredients to calculate value
          ingredientOne = [itemListMeasuresDry.elementAt(random.nextInt(itemListMeasuresDry.length)), itemListDry.elementAt(random.nextInt(itemListDry.length))];
          ingredientTwo = [itemListMeasuresDry.elementAt(random.nextInt(itemListMeasuresDry.length)), itemListDry.elementAt(random.nextInt(itemListDry.length))];
          while (ingredientTwo.elementAt(1) == ingredientOne.elementAt(1)) {
            ingredientTwo = [itemListMeasuresDry.elementAt(random.nextInt(itemListMeasuresDry.length)), itemListDry.elementAt(random.nextInt(itemListDry.length))];
          }
          // build auxiliary recipe
          auxiliaryRecipes[auxiliaryName] = _getAuxiliaryRecipe(auxiliaryName, value, ingredientOne, ingredientTwo, language);
          if (i > 0) {
            methodList.add(getText(textId.Pour, '', language));
            methodList.add(getText(textId.Clean, '', language));
          }
          methodList.add(getText(textId.Serve_with, auxiliaryName, language));
        }
      }
      else { // element is a string of non-digits  => Liquid ingredients
        List<String> Elements = element.split('');
        Elements.forEach((element) {
          value = element.codeUnitAt(0);
          if (amount[value] == null) { // a new character
            item = itemListLiquid.elementAt(random.nextInt(itemListLiquid.length)); // get liquid item [measure,name]
            measure = itemListMeasuresLiquid.elementAt(random.nextInt(itemListMeasuresLiquid.length));

            while (ingredientListed[item] != null) { // ingredient already in use
              item = itemListLiquid.elementAt(random.nextInt(itemListLiquid.length));
            }
            ingredientListed[item] = item;
            ingredientList.add(value.toString() + ' ' + measure + ' ' +  item);
            amount[value] = item;
            methodList.add(getText(textId.Put, amount[value], language));
          }
          else { // character was already processed {
            methodList.add(getText(textId.Put, amount[value], language));
          }
        });
      }
      i++;
    }); // outputElements.forEach((element)
  }
  else { // build "normal" linear recipe
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
    outputElements.forEach((element) {
      value = element.codeUnitAt(0);
      if (amount[value] == null) {
        item = itemList.elementAt(random.nextInt(itemList.length));
        measure = itemListMeasure.elementAt(random.nextInt(itemListMeasure.length));
        while (ingredientListed[item] != null) {
          item = itemList.elementAt(random.nextInt(itemList.length));
        }
        ingredientListed[item] = item;
        ingredientList.add(value.toString() + ' ' + measure + ' ' +  item);
        amount[value] = item;
        methodList.add(getText(textId.Put, amount[value], language));
      }
      else {
        methodList.add(getText(textId.Put, amount[value], language));
      }
    });
  }

  output.writeln(title + '.');
  output.writeln('');
  if (remark != '') output.writeln(remark + '\n');
  output.writeln(getText(textId.Ingredients, '', language) );
  output.writeln(ingredientList.join('\n'));
  output.writeln('');
  if (int.tryParse(time) != null) {
    output.writeln(getText(textId.Cooking_time, time, language) + '\n');
  }
  if (int.tryParse(temperature) != null) {
    output.writeln(getText(textId.Pre_heat_oven, temperature, language) + '\n');
  }
  output.writeln(getText(textId.Method, '', language));
  output.writeln(methodList.join('\n'));
  if (!auxiliary)
    output.writeln(getText(textId.Liquefy_contents, '', language));
  output.writeln(getText(textId.Pour, '', language));
  output.writeln('');
  output.writeln(getText(textId.Serves, '', language));

  auxiliaryRecipes.forEach((key, value) {
    output.writeln('\n');
    for (int i = 0; i < value.length; i++){
      output.writeln(value[i]);
    }
  });
  if (auxiliaryRecipes.length > 0) {
  }
  return output.toString().replaceAll('  ', ' ');
}


bool isValid(String input){
  bool flag = true;
  if (input == null || input == '')
    return true;
  List<String> numbers = input.split(' ');
  numbers.forEach((element) {
    if (int.tryParse(element) == null) {
      flag = false;
    }
  });
  return flag;
}


List<String> interpretChef(String language, recipe, input) {
  if (recipe == null || recipe == '')
    return new List<String>();

  return decodeChef(language, recipe, input);
}


List<String> decodeChef(String language, recipe, additionalIngredients)  {
  Chef interpreter = Chef(recipe, language);
  if (interpreter.valid) {
    interpreter.bake(language, additionalIngredients);
    if (interpreter.valid)
      return interpreter.meal;
    else // runtime error
      return interpreter.error;
  } else { // invalid recipe
    return interpreter.error;
  }
}


class Chef {

  Map<String, Recipe> recipes;
  Recipe mainrecipe;
  List<String> error;
  bool valid;
  List<String> meal;

  Chef(String readRecipe, language) {
    this.meal = new List<String>();    valid = true;
    error = new List<String>();
    recipes = new Map<String, Recipe>();
    int progress = 0;
    Recipe r = null;
    String title = '';
    String line = '';
    bool mainrecipeFound = false;
    bool progressError = false;
    bool ingredientsFound = false;
    bool methodsFound = false;
    bool servesFound = false;
    bool refrigerateFound = false;
    bool titleFound = false;

    readRecipe.split("\n\n").forEach((element) {
      line = element.trim();
      if (line.startsWith("ingredients") || line.startsWith("zutaten")) {
        if (progress > 3) {
          valid = false;
          _addError(language, 2, progress);
          return '';
        }
        progress = 3;
        r.setIngredients(line, language);
        ingredientsFound = true;
        if (r.error) {
          this.error.addAll(r.errorList);
          valid = false;
          return '';
        }
      }
      else if (line.startsWith("cooking time") || line.startsWith("garzeit")) {
        if (progress > 4) {
          valid = false;
          _addError(language, 3, progress);
          return '';
        }
        progress = 4;
        r.setCookingTime(line, language);
        if (r.error){
          this.error.addAll(r.errorList);
          this.valid = false;
          return '';
        }
      }
      else if (line.startsWith("pre-heat oven") || line.startsWith("pre heat oven") || line.startsWith("ofen auf")) {
        if (progress > 5) {
          valid = false;
          _addError(language, 4, progress);
          return '';
        }
        progress = 5;
        r.setOvenTemp(line, language);
        if (r.error){
          this.error.addAll(r.errorList);
          this.valid = false;
          return '';
        }
      }
      else if (line.startsWith("method") || line.startsWith("zubereitung")) {
        if (progress > 5){
          valid = false;
          _addError(language, 5, progress);
          return '';
        }
        progress = 6;
        r.setMethod(line, language);
        methodsFound = true;
        if (line.contains('refrigerate') || line.contains('einfrieren'))
          refrigerateFound = true;
        if (r.error){
          this.error.addAll(r.errorList);
          this.valid = false;
          return '';
        }
      }
      else if (line.startsWith("serves") || line.startsWith("portionen")) {
        if (progress != 6) {
          valid = false;
          _addError(language, 6, progress);
          return '';
        }
        progress = 0;
        r.setServes(line, language);
        servesFound = true;
        if (r.error){
          this.error.addAll(r.errorList);
          this.valid = false;
          return '';
        }
      }
      else {
        if (progress == 0 || progress >= 6) {
          title = _parseTitle(line);
          titleFound = true;
          r = new Recipe(line);
          if (mainrecipe == null) {
            mainrecipe = r;
            mainrecipeFound = true;
          }
          progress = 1;
          recipes.addAll({title : r});
        }
        else if (progress == 1) {
          progress = 2;
          r.setComments(line);
        }
        else {
          valid = false;
          if (!progressError)
            {
              progressError = true;
              if (mainrecipeFound) {
                error.add(Messages[language]['chef_error_structure_subrecipe']);
              }
              error.addAll([
                Messages[language]['chef_error_structure_recipe_read_unexpected_comments_title'],
                Messages[language][_progressToExpected(language, progress)],
                Messages[language]['chef_hint_recipe_hint'],
                Messages[language][_structHint(language, progress)],
                '']);
            }
          return '';
        }
      }
    });
    if (mainrecipe == null) {
      valid = false;
      error.addAll([
        Messages[language]['chef_error_structure_recipe'],
        Messages[language]['chef_error_structure_recipe_empty_missing_title'],
        '']);
      return;
    }
    if (!titleFound) {
      valid = false;
      error.addAll([
        Messages[language]['chef_error_structure_recipe'],
        Messages[language]['chef_error_structure_recipe_missing_title'],
        '']);
      return;
    }
    if (!ingredientsFound) {
      valid = false;
      error.addAll([
        Messages[language]['chef_error_structure_recipe'],
        Messages[language]['chef_error_structure_recipe_empty_ingredients'],
        '']);
      return;
    }
    if (!methodsFound) {
      valid = false;
      error.addAll([
        Messages[language]['chef_error_structure_recipe'],
        Messages[language]['chef_error_structure_recipe_empty_methods'],
        '']);
      return;
    }
    if (!servesFound && !refrigerateFound) {
      valid = false;
      error.addAll([
        Messages[language]['chef_error_structure_recipe'],
        Messages[language]['chef_error_structure_recipe_empty_serves'],
        '']);
      return;
    }
  } // chef

  String _parseTitle(String title) {
    if (title.endsWith('.')) {
      title = title.substring(0, title.length - 1);
    }
    return title.toLowerCase();
  }

  void _addError(String language, int progressToExpected, int progress) {
    error.add(Messages[language]['chef_error_structure_recipe']);
    if (progressToExpected >= 0) {
      error.addAll([
        Messages[language]['chef_error_structure_recipe_read_unexpected'],
        _progressToExpected(language, progressToExpected),
        Messages[language]['chef_error_structure_recipe_expecting'],
        _progressToExpected(language, progress),
       '']);
    } else {
      error.addAll([
        Messages[language]['chef_error_structure_recipe_read_unexpected_comments_title'],
        _progressToExpected(language, progress),
        Messages[language]['chef_hint_recipe_hint'],
        _structHint(language, progress)]);
    }
    error.add('');
  }

  String _structHint(String language, int progress) {
    switch (progress) {
      case 2 : return Messages[language]['chef_hint_recipe_ingredients'];
      case 3 : return Messages[language]['chef_hint_recipe_methods'];
      case 4 : return Messages[language]['chef_hint_recipe_oven_temperature'];
    }
    return Messages[language]["chef_hint_no_hint_available"];
  }

  String _progressToExpected(String language, int progress) {
    String output = '';
    switch (progress) {
      case 0 :  output =  Messages[language]['chef_error_structure_recipe_title']; break;
      case 1 :  output =  Messages[language]['chef_error_structure_recipe_comments']; break;
      case 2 :  output =  Messages[language]['chef_error_structure_recipe_ingredient_list']; break;
      case 3 :  output =  Messages[language]['chef_error_structure_recipe_cooking_time']; break;
      case 4 :  output =  Messages[language]['chef_error_structure_recipe_oven_temperature']; break;
      case 5 :  output =  Messages[language]['chef_error_structure_recipe_methods']; break;
      case 6 :  output =  Messages[language]['chef_error_structure_recipe_serve_amount']; break;
    }
    return output;
  }

  void bake(String language, additionalIngredients) {
    Kitchen k = new Kitchen(this.recipes, this.mainrecipe, null, null, language);
    if (k.valid) {
      k.cook(additionalIngredients, language, 1);
    }
    this.valid = k.valid;
    this.meal = k.meal;
    this.error = k.error;
  }
}
