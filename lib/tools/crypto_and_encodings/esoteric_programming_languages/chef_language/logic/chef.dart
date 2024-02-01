part of 'package:gc_wizard/tools/crypto_and_encodings/esoteric_programming_languages/chef_language/logic/chef_language.dart';

class _Chef {
  var recipes = <String, _Recipe>{};
  _Recipe? mainrecipe;
  var error = <String>[];
  bool valid = true;
  var meal = <String>[];
  bool liquefyMissing = true;

  _Chef(String readRecipe, String language) {
    if (readRecipe.isEmpty) return;

    int progress = 0;
    _Recipe? r;
    String title = '';
    String line = '';
    bool mainrecipeFound = false;
    bool progressError = false;
    bool ingredientsFound = false;
    bool methodsFound = false;
    bool servesFound = false;
    bool refrigerateFound = false;
    bool titleFound = false;

    // remove blank lines at start and trim lines
    List<String> recipe = readRecipe.split('\n');
    while (recipe[0].isEmpty) {
      for (int i = 1; i < recipe.length; i++) {
        recipe[i - 1] = recipe[i].trim();
      }
    }

    // remove blank lines at end
    while (recipe[recipe.length - 1].isEmpty) {
      recipe.removeAt(recipe.length - 1);
    }

    // trim lines
    for (int i = 1; i < recipe.length; i++) {
      recipe[i] = recipe[i].trim();
      // add blank lines before aux recipes
      if (recipe[i].endsWith('.')) {
        //recipe[i] = '\n' + recipe[i];
      }
    }
    readRecipe = recipe.join('\n');

    // check and add missing title
    if (readRecipe.startsWith('ingredients') || readRecipe.startsWith('zutaten')) {
      readRecipe = 'nouvelle cuisine\n\n' + readRecipe;
    }

    // check and repair recipe regarding blank lines, whitespace
    recipe = readRecipe.split('\n');

    // remove blank lines inside sections ingredients, methods
    bool ingredientSection = false;
    bool methodSection = false;
    bool auxRecipe = false;

    for (int i = 0; i < recipe.length - 1; i++) {
      if (recipe[i].startsWith("ingredients") || recipe[i].startsWith("zutaten")) ingredientSection = true;

      if (recipe[i].startsWith("cooking time") ||
          recipe[i].startsWith("garzeit") ||
          recipe[i].startsWith("pre-heat oven") ||
          recipe[i].startsWith("pre heat oven") ||
          recipe[i].startsWith("ofen auf") ||
          recipe[i].startsWith("method") ||
          recipe[i].startsWith("zubereitung")) ingredientSection = false;

      if (recipe[i].startsWith("method") || recipe[i].startsWith("zubereitung")) methodSection = true;

      if (recipe[i].startsWith("serves") || recipe[i].startsWith("portionen")) {
        methodSection = false;
        auxRecipe = true;
      }

      if ((recipe[i].isEmpty || recipe[i] == '\n') && ingredientSection) {
        if (recipe[i + 1].startsWith('method') ||
            recipe[i + 1].startsWith('zubereitung') ||
            recipe[i + 1].startsWith("cooking time") ||
            recipe[i + 1].startsWith("garzeit") ||
            recipe[i + 1].startsWith("pre-heat oven") ||
            recipe[i + 1].startsWith("pre heat oven") ||
            recipe[i + 1].startsWith("ofen auf") ||
            recipe[i + 1].startsWith("serves") ||
            recipe[i + 1].startsWith("portionen")) {
        } else {
          recipe.removeAt(i);
        }
      }

      if ((recipe[i] == '' || recipe[i] == '\n') && methodSection) {
        if (recipe[i + 1].startsWith('method') ||
            recipe[i + 1].startsWith('zubereitung') ||
            recipe[i + 1].startsWith("cooking time") ||
            recipe[i + 1].startsWith("garzeit") ||
            recipe[i + 1].startsWith("pre-heat oven") ||
            recipe[i + 1].startsWith("pre heat oven") ||
            recipe[i + 1].startsWith("ofen auf") ||
            recipe[i + 1].startsWith("serves") ||
            recipe[i + 1].startsWith("portionen") ||
            _isMethod(recipe[i + 1])) {
        } else {
          if (!auxRecipe) recipe.removeAt(i);
        }
      }
    }
    recipe = recipe.join('\n').split('\n');

    // add blank lines to build the necessary sections
    String s0 = recipe[0];
    for (int i = 1; i < recipe.length; i++) {
      if (recipe[i].startsWith("ingredients") ||
          recipe[i].startsWith("zutaten") ||
          recipe[i].startsWith("cooking time") ||
          recipe[i].startsWith("garzeit") ||
          recipe[i].startsWith("pre-heat oven") ||
          recipe[i].startsWith("pre heat oven") ||
          recipe[i].startsWith("ofen auf") ||
          recipe[i].startsWith("method") ||
          recipe[i].startsWith("zubereitung") ||
          recipe[i].startsWith("serves") ||
          recipe[i].startsWith("portionen")) if (s0.isNotEmpty) recipe[i] = '\n' + recipe[i];
      s0 = recipe[i];
    }
    readRecipe = recipe.join('\n');
    readRecipe = readRecipe.replaceAll(RegExp(r'\n(\n)+'), '\n\n');
    recipe = readRecipe.split("\n\n");
    for (int i = 0; i < recipe.length; i++) {
      line = recipe[i];
      if (line.startsWith("ingredients") || line.startsWith("zutaten")) {
        if (progress > 3) {
          valid = false;
          _addError(language, 2, progress);
        }
        progress = 3;
        r!.setIngredients(line, language);
        ingredientsFound = true;
        if (r.error) {
          error.addAll(r.errorList);
          valid = false;
        }
      } else if (line.startsWith("cooking time") || line.startsWith("garzeit")) {
        if (progress > 4) {
          valid = false;
          _addError(language, 3, progress);
        }
        progress = 4;
        r!.setCookingTime(line, language);
        if (r.error) {
          error.addAll(r.errorList);
          valid = false;
        }
      } else if (line.startsWith("pre-heat oven") || line.startsWith("pre heat oven") || line.startsWith("ofen auf")) {
        if (progress > 5) {
          valid = false;
          _addError(language, 4, progress);
        }
        progress = 5;
        r!.setOvenTemp(line, language);
        if (r.error) {
          error.addAll(r.errorList);
          valid = false;
        }
      } else if (line.startsWith("method") || line.startsWith("zubereitung")) {
        if (progress > 5) {
          valid = false;
          _addError(language, 5, progress);
        }
        progress = 6;
        r!.setMethod(line, language);
        methodsFound = true;
        if (line.contains('refrigerate') || line.contains('einfrieren')) refrigerateFound = true;
        if (r.error) {
          error.addAll(r.errorList);
          valid = false;
        }
      } else if (line.startsWith("serves") || line.startsWith("portionen")) {
        if (progress != 6) {
          valid = false;
          _addError(language, 6, progress);
        }
        progress = 0;
        r!.setServes(line, language);
        servesFound = true;
        if (r.error) {
          error.addAll(r.errorList);
          valid = false;
        }
      } else {
        if (progress == 0 || progress >= 6) {
          title = _parseTitle(line);
          titleFound = true;
          r = _Recipe(line);
          if (mainrecipe == null) {
            mainrecipe = r;
            mainrecipeFound = true;
          }
          progress = 1;
          recipes.addAll({title: r});
        } else if (progress == 1) {
          progress = 2;
          r!.setComments(line);
        } else {
          valid = false;
          if (!progressError) {
            progressError = true;
            if (mainrecipeFound) {
              error.add(_CHEF_Messages[language]?['chef_error_structure_subrecipe'] ?? '');
            }
            error.addAll([
              _CHEF_Messages[language]?['chef_error_structure_recipe_read_unexpected_comments_title'] ?? '',
              _CHEF_Messages[language]?[_progressToExpected(language, progress)] ?? '',
              _CHEF_Messages[language]?['chef_hint_recipe_hint'] ?? '',
              _CHEF_Messages[language]?[_structHint(language, progress)] ?? '',
              ''
            ]);
          }
        }
      }
    }
    // for each element of the recipe

    if (mainrecipe == null) {
      valid = false;
      error.addAll([
        _CHEF_Messages[language]?['chef_error_structure_recipe'] ?? '',
        _CHEF_Messages[language]?['chef_error_structure_recipe_empty_missing_title'] ?? '',
        ''
      ]);
    }

    if (!titleFound) {
      valid = false;
      error.addAll([
        _CHEF_Messages[language]?['chef_error_structure_recipe'] ?? '',
        _CHEF_Messages[language]?['chef_error_structure_recipe_missing_title'] ?? '',
        ''
      ]);
    }
    if (!ingredientsFound) {
      valid = false;
      error.addAll([
        _CHEF_Messages[language]?['chef_error_structure_recipe'] ?? '',
        _CHEF_Messages[language]?['chef_error_structure_recipe_empty_ingredients'] ?? '',
        ''
      ]);
    }
    if (!methodsFound) {
      valid = false;
      error.addAll([
        _CHEF_Messages[language]?['chef_error_structure_recipe'] ?? '',
        _CHEF_Messages[language]?['chef_error_structure_recipe_empty_methods'] ?? '',
        ''
      ]);
    }

    if (!servesFound && !refrigerateFound) {
      valid = false;
      error.addAll([
        _CHEF_Messages[language]?['chef_error_structure_recipe'] ?? '',
        _CHEF_Messages[language]?['chef_error_structure_recipe_empty_serves'] ?? '',
        ''
      ]);
    }
  } // chef

  String _parseTitle(String title) {
    if (title.endsWith('.')) {
      title = title.substring(0, title.length - 1);
    }
    return title.toLowerCase();
  }

  void _addError(String language, int progressToExpected, int progress) {
    error.add(_CHEF_Messages[language]?['chef_error_structure_recipe'] ?? '');
    if (progressToExpected >= 0) {
      error.addAll([
        _CHEF_Messages[language]?['chef_error_structure_recipe_read_unexpected'] ?? '',
        _progressToExpected(language, progressToExpected),
        _CHEF_Messages[language]?['chef_error_structure_recipe_expecting'] ?? '',
        _progressToExpected(language, progress),
        ''
      ]);
    } else {
      error.addAll([
        _CHEF_Messages[language]?['chef_error_structure_recipe_read_unexpected_comments_title'] ?? '',
        _progressToExpected(language, progress),
        _CHEF_Messages[language]?['chef_hint_recipe_hint'] ?? '',
        _structHint(language, progress)
      ]);
    }
    error.add('');
  }

  String _structHint(String language, int progress) {
    switch (progress) {
      case 2:
        return _CHEF_Messages[language]?['chef_hint_recipe_ingredients'] ?? '';
      case 3:
        return _CHEF_Messages[language]?['chef_hint_recipe_methods'] ?? '';
      case 4:
        return _CHEF_Messages[language]?['chef_hint_recipe_oven_temperature'] ?? '';
    }
    return _CHEF_Messages[language]?["chef_hint_no_hint_available"] ?? '';
  }

  String _progressToExpected(String language, int progress) {
    String output = '';
    switch (progress) {
      case 0:
        output = _CHEF_Messages[language]?['chef_error_structure_recipe_title'] ?? '';
        break;
      case 1:
        output = _CHEF_Messages[language]?['chef_error_structure_recipe_comments'] ?? '';
        break;
      case 2:
        output = _CHEF_Messages[language]?['chef_error_structure_recipe_ingredient_list'] ?? '';
        break;
      case 3:
        output = _CHEF_Messages[language]?['chef_error_structure_recipe_cooking_time'] ?? '';
        break;
      case 4:
        output = _CHEF_Messages[language]?['chef_error_structure_recipe_oven_temperature'] ?? '';
        break;
      case 5:
        output = _CHEF_Messages[language]?['chef_error_structure_recipe_methods'] ?? '';
        break;
      case 6:
        output = _CHEF_Messages[language]?['chef_error_structure_recipe_serve_amount'] ?? '';
        break;
    }
    return output;
  }

  void bake(String language, String additionalIngredients) {
    if (mainrecipe == null) return;
    _Kitchen k = _Kitchen(recipes, mainrecipe!, null, null, language);
    if (k.valid) {
      k.cook(additionalIngredients, language, 1);
    }
    valid = k.valid;
    meal = k.meal;
    error = k.error;
    liquefyMissing = k.liquefyMissing;
  }
}
