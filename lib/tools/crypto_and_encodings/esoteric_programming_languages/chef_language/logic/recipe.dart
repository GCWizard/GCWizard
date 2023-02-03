part of 'package:gc_wizard/tools/crypto_and_encodings/esoteric_programming_languages/chef_language/logic/chef_language.dart';

class _Recipe {
  String title;
  Map<String, _Ingredient> ingredients;
  String comment;
  int cookingtime;
  int oventemp;
  int gasmark;
  List<_Method> methods;
  int serves;
  bool error;
  List<String> errorList;
  bool liquefyMissing;

  _Recipe(String title) {
    this.title = title;
    this.comment = '';
    this.serves = 0;
    this.error = false;
    this.errorList = <String>[];
    this.liquefyMissing = false;
  }

  void setIngredients(String Input, language) {
    var f = new NumberFormat('###');
    this.ingredients = Map<String, _Ingredient>();
    var i = 0;
    List<String> ingredientsInput = Input.split('\n');
    ingredientsInput.forEach((ingredientLine) {
      //Clearing the 'Ingredients.' header
      if (i > 0) {
        _Ingredient ing = new _Ingredient(ingredientLine);
        if (ing.getName() == 'INVALID') {
          error = true;
          this.errorList.add(_Messages[language]['chef_error_syntax']);
          this.errorList.add(_Messages[language]['chef_error_syntax_ingredient']);
          this.errorList.add(_Messages[language]['chef_error_syntax_ingredient_name']);
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
    this.methods = List<_Method>();
    //List<String> scanner = method.replaceAll("\n", "").replaceAll(". ",".").split('.');
    List<String> methodList =
        method.replaceAll("zubereitung:", "zubereitung.").replaceAll("\n", " ").replaceAll(". ", ".").split('.');
    for (int i = 1; i < methodList.length - 1; i++) {
      var m = new _Method(methodList[i], i, language);
      if (m.type == _Type.Invalid || m.type == _Type.Unbekannt) {
        this.error = true;
        this.errorList.add(_Messages[language]['chef_error_syntax']);
        this.errorList.add(_Messages[language]['chef_error_syntax_method']);
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
      errorList.add(_Messages[language]['chef_error_syntax']);
      errorList.add(_Messages[language]['chef_error_syntax_cooking_time']);
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
      errorList.add(_Messages[language]['chef_error_syntax']);
      errorList.add(_Messages[language]['chef_error_syntax_oven_temperature']);
      errorList.add(oventemp);
      errorList.add('');
    }
  }

  void setServes(String serves, language) {
    if (RegExp(r'^(serves |portionen(:)? )(\d*)(\.)$').hasMatch(serves)) {
      this.serves = int.parse(RegExp(r'^(serves |portionen(:)? )(\d*)(\.)$').firstMatch(serves).group(3));
    } else {
      this.error = true;
      errorList.add(_Messages[language]['chef_error_syntax']);
      errorList.add(_Messages[language]['chef_error_syntax_serves']);
      errorList.add(_Messages[language]['chef_error_syntax_serves_without_number']);
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

  _Method getMethod(int i) {
    return methods[i];
  }

  List<_Method> getMethods() {
    return methods;
  }

  Map<String, _Ingredient> getIngredients() {
    return ingredients;
  }
}
