import 'package:gc_wizard/logic/tools/crypto_and_encodings/esoteric_programming_languages/chef_language/chef_international.dart';
import 'package:gc_wizard/logic/tools/crypto_and_encodings/esoteric_programming_languages/chef_language/ingredient.dart';
import 'package:gc_wizard/logic/tools/crypto_and_encodings/esoteric_programming_languages/chef_language/method.dart';
import 'package:intl/intl.dart';

class Recipe {
  String title;
  Map<String, Ingredient> ingredients;
  String comment;
  int cookingtime;
  int oventemp;
  int gasmark;
  List<Method> methods;
  int serves;
  bool error;
  List<String> errorList;
  bool liquefyMissing;

  Recipe(String title) {
    this.title = title;
    this.comment = '';
    this.serves = 0;
    this.error = false;
    this.errorList = <String>[];
    this.liquefyMissing = false;
  }

  void setIngredients(String Input, language) {
    var f = new NumberFormat('###');
    this.ingredients = Map<String, Ingredient>();
    var i = 0;
    List<String> ingredientsInput = Input.split('\n');
    ingredientsInput.forEach((ingredientLine) {
      //Clearing the 'Ingredients.' header
      if (i > 0) {
        Ingredient ing = new Ingredient(ingredientLine);
        if (ing.getName() == 'INVALID') {
          error = true;
          this.errorList.add(Messages[language]['chef_error_syntax']);
          this.errorList.add(Messages[language]['chef_error_syntax_ingredient']);
          this.errorList.add(Messages[language]['chef_error_syntax_ingredient_name']);
          this.errorList.add(f.format(i).toString() + ' : ' + ingredientLine);
          this.errorList.add('');
          return;
        } else {
          error = false;
          this.ingredients.addAll({ing.getName().toLowerCase(): ing});
        }
      }
      i++;
    });
  }

  void setComments(String comment) {
    this.comment = comment;
  }

  void setMethod(String method, language) {
    var f = new NumberFormat('###');
    this.methods = List<Method>();
    //List<String> scanner = method.replaceAll("\n", "").replaceAll(". ",".").split('.');
    List<String> methodList =
        method.replaceAll("zubereitung:", "zubereitung.").replaceAll("\n", " ").replaceAll(". ", ".").split('.');
    for (int i = 1; i < methodList.length - 1; i++) {
      var m = new Method(methodList[i], i, language);
      if (m.type == Type.Invalid || m.type == Type.Unbekannt) {
        this.error = true;
        this.errorList.add(Messages[language]['chef_error_syntax']);
        this.errorList.add(Messages[language]['chef_error_syntax_method']);
        this.errorList.add(f.format(i).toString() + ' : ' + methodList[i]);
        this.errorList.add('');
      } else {
        this.methods.add(m);
      }
    }
  }

  void setCookingTime(String cookingtime, language) {
    RegExp expr = new RegExp(r'^(cooking time: |garzeit: )(\d*)( minute(s)?| minute(n)?| hour(s)?| stunde(n)?)\.$');
    if (expr.hasMatch(cookingtime)) {
      this.cookingtime = int.parse(expr.firstMatch(cookingtime).group(2));
    } else {
      this.error = true;
      errorList.add(Messages[language]['chef_error_syntax']);
      errorList.add(Messages[language]['chef_error_syntax_cooking_time']);
      errorList.add(cookingtime);
      errorList.add('');
    }
  }

  void setOvenTemp(String oventemp, language) {
    RegExp expr = new RegExp(
        r'^(pre(-| )heat oven to |ofen auf )(\d*) (degrees|grad) cel(c|s)ius( \(gas (mark |skala )(\d*)\))?( vorheizen)?.$');
    if (expr.hasMatch(oventemp)) {
      this.oventemp = int.parse(expr.firstMatch(oventemp).group(3));
      if (expr.firstMatch(oventemp).group(8) != null) {
        this.gasmark = int.parse(expr.firstMatch(oventemp).group(8));
      }
    } else {
      this.error = true;
      errorList.add(Messages[language]['chef_error_syntax']);
      errorList.add(Messages[language]['chef_error_syntax_oven_temperature']);
      errorList.add(oventemp);
      errorList.add('');
    }
  }

  void setServes(String serves, language) {
    if (RegExp(r'^(serves |portionen(:)? )(\d*)(\.)$').hasMatch(serves)) {
      this.serves = int.parse(RegExp(r'^(serves |portionen(:)? )(\d*)(\.)$').firstMatch(serves).group(3));
    } else {
      this.error = true;
      errorList.add(Messages[language]['chef_error_syntax']);
      errorList.add(Messages[language]['chef_error_syntax_serves']);
      errorList.add(Messages[language]['chef_error_syntax_serves_without_number']);
      errorList.add(serves);
      errorList.add('');
    }
  }

  int getServes() {
    return serves;
  }

  String getTitle() {
    return title;
  }

  int getIngredientValue(String s) {
    return ingredients[s].getAmount();
  }

  void setIngredientValue(String s, int n) {
    ingredients[s].setAmount(n);
  }

  Method getMethod(int i) {
    return methods[i];
  }

  List<Method> getMethods() {
    return methods;
  }

  Map<String, Ingredient> getIngredients() {
    return ingredients;
  }
}
