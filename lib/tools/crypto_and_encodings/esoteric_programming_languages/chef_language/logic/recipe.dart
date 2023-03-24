part of 'package:gc_wizard/tools/crypto_and_encodings/esoteric_programming_languages/chef_language/logic/chef_language.dart';

class _Recipe {
  late String title;
  late Map<String, _Ingredient> ingredients;
  String? comment;
  int? cookingtime;
  int? oventemp;
  int? gasmark;
  List<_Method>? methods;
  late int serves;
  bool error = false;
  late List<String> errorList;

  _Recipe(this.title) {
    comment = '';
    serves = 0;
    error = false;
    errorList = <String>[];
  }

  void setIngredients(String Input, String language) {
    var f = NumberFormat('###');
    ingredients = <String, _Ingredient>{};
    var i = 0;
    List<String> ingredientsInput = Input.split('\n');
    for (var ingredientLine in ingredientsInput) {
      //Clearing the 'Ingredients.' header
      if (i > 0) {
        _Ingredient ing = _Ingredient(ingredientLine);
        if (ing.getName() == 'INVALID') {
          error = true;
          errorList.add(_CHEF_Messages[language]?['chef_error_syntax'] ?? '');
          errorList.add(_CHEF_Messages[language]?['chef_error_syntax_ingredient'] ?? '');
          errorList.add(_CHEF_Messages[language]?['chef_error_syntax_ingredient_name'] ?? '');
          errorList.add(f.format(i).toString() + ' : ' + ingredientLine);
          errorList.add('');
          continue;
        } else {
          error = false;
          ingredients.addAll({ing.getName()!.toLowerCase(): ing});
        }
      }
      i++;
    }
  }

  void setComments(String comment) {
    this.comment = comment;
  }

  void setMethod(String method, String language) {
    NumberFormat f = NumberFormat('###');
    methods = <_Method>[];
    //List<String> scanner = method.replaceAll("\n", "").replaceAll(". ",".").split('.');
    List<String> methodList =
        method.replaceAll("zubereitung:", "zubereitung.").replaceAll("\n", " ").replaceAll(". ", ".").split('.');
    for (int i = 1; i < methodList.length - 1; i++) {
      _Method m = _Method(methodList[i], i, language);
      if (m.type == _CHEF_Method.Invalid || m.type == _CHEF_Method.Unbekannt) {
        error = true;
        errorList.add(_CHEF_Messages[language]?['chef_error_syntax'] ?? '');
        errorList.add(_CHEF_Messages[language]?['chef_error_syntax_method'] ?? '');
        errorList.add(f.format(i).toString() + ' : ' + methodList[i]);
        errorList.add('');
      } else {
        if (methods == null) throw const FormatException('setMethod');
        methods!.add(m);
      }
    }
  }

  void setCookingTime(String cookingtime, String language) {
    RegExp expr = RegExp(r'^(cooking time: |garzeit: )(\d*)( minute(s)?| minute(n)?| hour(s)?| stunde(n)?)\.$');
    if (expr.hasMatch(cookingtime)) {
      this.cookingtime = int.parse(expr.firstMatch(cookingtime)!.group(2)!);
    } else {
      error = true;
      errorList.add(_CHEF_Messages[language]?['chef_error_syntax'] ?? '');
      errorList.add(_CHEF_Messages[language]?['chef_error_syntax_cooking_time'] ?? '');
      errorList.add(cookingtime);
      errorList.add('');
    }
  }

  void setOvenTemp(String oventemp, String language) {
    RegExp expr = RegExp(
        r'^(pre(-| )heat oven to |ofen auf )(\d*) (degrees|grad) cel(c|s)ius( \(gas (mark |skala )(\d*)\))?( vorheizen)?.$');
    if (expr.hasMatch(oventemp)) {
      this.oventemp = int.parse(expr.firstMatch(oventemp)!.group(3)!);
      if (expr.firstMatch(oventemp)!.group(8) != null) {
        gasmark = int.parse(expr.firstMatch(oventemp)!.group(8)!);
      }
    } else {
      error = true;
      errorList.add(_CHEF_Messages[language]?['chef_error_syntax'] ?? '');
      errorList.add(_CHEF_Messages[language]?['chef_error_syntax_oven_temperature'] ?? '');
      errorList.add(oventemp);
      errorList.add('');
    }
  }

  void setServes(String serves, String language) {
    RegExp regex = RegExp(r'^(serves |portionen(:)? )(\d*)(\.)$');
    if (regex.hasMatch(serves)) {
      this.serves = int.parse(RegExp(r'^(serves |portionen(:)? )(\d*)(\.)$').firstMatch(serves)!.group(3)!);
    } else {
      error = true;
      errorList.add(_CHEF_Messages[language]?['chef_error_syntax'] ?? '');
      errorList.add(_CHEF_Messages[language]?['chef_error_syntax_serves'] ?? '');
      errorList.add(_CHEF_Messages[language]?['chef_error_syntax_serves_without_number'] ?? '');
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

  int? getIngredientValue(String s) {
    return ingredients[s]?.getAmount();
  }

  void setIngredientValue(String s, int n) {
    var value =  ingredients[s];
    if (value == null) throw const FormatException('setIngredientValue');
    value.setAmount(n);
  }

  _Method? getMethod(int i) {
    return methods?[i];
  }

  List<_Method>? getMethods() {
    return methods;
  }

  Map<String, _Ingredient> getIngredients() {
    return ingredients;
  }
}
