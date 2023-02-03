part of 'package:gc_wizard/tools/crypto_and_encodings/esoteric_programming_languages/chef_language/logic/chef_language.dart';

class _Kitchen {
  List<_Container> mixingbowls;
  List<_Container> bakingdishes;
  Map<String, _Recipe> recipes;
  _Recipe recipe;
  bool valid;
  bool exception;
  List<String> error;
  List<String> meal;
  bool liquefyMissing;

  _Kitchen(Map<String, _Recipe> recipes, _Recipe mainrecipe, List<_Container> mbowls, List<_Container> bdishes,
      String language) {
    this.valid = true;
    this.exception = false;
    this.meal = <String>[];
    this.error = <String>[];
    this.recipes = recipes;
    this.liquefyMissing = true;
    //start with at least 1 mixing bowl.
    int maxbowl = 0, maxdish = -1;
    this.recipe = mainrecipe;
    if (this.recipe.getMethods() != null) {
      this.recipe.getMethods().forEach((m) {
        if (m.bakingdish != null && m.bakingdish > maxdish) maxdish = m.bakingdish;
        if (m.mixingbowl != null && m.mixingbowl > maxbowl) maxbowl = m.mixingbowl;
      });

      this.mixingbowls = new List<_Container>(mbowls == null ? maxbowl + 1 : max(maxbowl + 1, mbowls.length));
      for (int i = 0; i < this.mixingbowls.length; i++) this.mixingbowls[i] = new _Container(null);
      if (mbowls != null) {
        for (int i = 0; i < mbowls.length; i++) {
          this.mixingbowls[i] = new _Container(mbowls[i]);
        }
      }

      this.bakingdishes = new List<_Container>(bdishes == null ? maxdish + 1 : max(maxdish + 1, bdishes.length));
      for (int i = 0; i < this.bakingdishes.length; i++) this.bakingdishes[i] = new _Container(null);
      if (bdishes != null) {
        for (int i = 0; i < bdishes.length; i++) {
          this.bakingdishes[i] = new _Container(bdishes[i]);
        }
      }
    } else {
      valid = false;
      error.addAll([
        _Messages[language]['chef_error_structure_recipe'],
        _Messages[language]['chef_error_structure_recipe_methods'],
        _Messages[language]['chef_error_syntax_method'],
        ''
      ]);
    }
  }

  _Container cook(String additionalIngredients, language, int depth) {
    int ingredientIndex = 0;
    List<String> input = additionalIngredients.split(' ');

    Map<String, _Ingredient> ingredients = recipe.getIngredients();
    List<_Method> methods = recipe.getMethods();
    var loops = List<_LoopData>();
    _Component c;
    int i = 0;
    bool deepfrozen = false;
    bool exceptionArose = false;
    methodloop:
    while (i < methods.length && !deepfrozen && !exceptionArose) {
      _Method m = methods[i];
      switch (m.type) {
        case _Type.Invalid:
          valid = false;
          error.addAll([
            _Messages[language]['chef_error_syntax_method'],
            m.ingredient,
            _Messages[language]['chef_error_syntax_method_unsupported'],
            ''
          ]);
          return null;
          break;
        case _Type.Take:
        case _Type.Nehmen:
        case _Type.Put:
        case _Type.Geben:
        case _Type.Fold:
        case _Type.Unterheben:
        case _Type.Add:
        case _Type.Dazugeben:
        case _Type.Remove:
        case _Type.Abschoepfen:
        case _Type.Combine:
        case _Type.Kombinieren:
        case _Type.Divide:
        case _Type.Teilen:
        case _Type.Liquefy:
        case _Type.Schmelzen:
        case _Type.StirInto:
        case _Type.ZutatRuehren:
        case _Type.Verb:
        case _Type.Wiederholen:
          if (ingredients[m.ingredient] == null) {
            valid = false;
            error.addAll([
              _Messages[language]['common_programming_error_runtime'],
              _Messages[language]['chef_error_runtime_method_step'],
              m.n.toString() + ' : ' + m.type.toString(),
              _Messages[language]['chef_error_runtime_ingredient_not_found'],
              m.ingredient,
              ''
            ]);
            return null;
          }
      }
      switch (m.type) {
        case _Type.Take:
        case _Type.Nehmen:
          if ((input.join('') != '') && (ingredientIndex <= input.length - 1)) {
            ingredients[m.ingredient].setAmount(int.parse(input[ingredientIndex]));
            ingredientIndex++;
          } else {
            valid = false;
            error.addAll([
              _Messages[language]['common_programming_error_runtime'],
              _Messages[language]['chef_error_runtime_missing_input'],
              ''
            ]);
            return null;
          }
          break;

        case _Type.Put:
        case _Type.Geben:
          mixingbowls[m.mixingbowl].push(_Component.Contructor1(ingredients[m.ingredient]));
          break;

        case _Type.Fold:
        case _Type.Unterheben:
          if (mixingbowls[m.mixingbowl].size() == 0) {
            valid = false;
            error.addAll([
              _Messages[language]['common_programming_error_runtime'],
              _Messages[language]['chef_error_runtime_folded_from_empty_mixing_bowl'],
              _Messages[language]['chef_error_runtime_method_step'],
              m.n.toString() + ' : ' + m.type.toString() + ' => ' + (m.mixingbowl + 1).toString(),
              ''
            ]);
            return null;
          }
          c = mixingbowls[m.mixingbowl].pop();
          ingredients[m.ingredient].setAmount(c.getValue());
          ingredients[m.ingredient].setState(c.getState());
          break;

        case _Type.Add:
        case _Type.Dazugeben:
          if (mixingbowls[m.mixingbowl].size() == 0) {
            valid = false;
            error.addAll([
              _Messages[language]['common_programming_error_runtime'],
              _Messages[language]['chef_error_runtime_add_to_empty_mixing_bowl'],
              _Messages[language]['chef_error_runtime_method_step'],
              m.n.toString() + ' : ' + m.type.toString() + ' => ' + (m.mixingbowl + 1).toString(),
              ''
            ]);
            return null;
          }
          c = mixingbowls[m.mixingbowl].peek();
          c.setValue(c.getValue() + ingredients[m.ingredient].getAmount());
          break;

        case _Type.Remove: // ingredient.amount from mixingbowl
        case _Type.Abschoepfen:
          if (mixingbowls[m.mixingbowl].size() == 0) {
            valid = false;
            error.addAll([
              _Messages[language]['common_programming_error_runtime'],
              _Messages[language]['chef_error_runtime_remove_from_empty_mixing_bowl'],
              _Messages[language]['chef_error_runtime_method_step'],
              m.n.toString() + ' : ' + m.type.toString() + ' => ' + (m.mixingbowl + 1).toString(),
              ''
            ]);
            return null;
          }
          c = mixingbowls[m.mixingbowl].peek(); // returns top of m.mixingbowl
          c.setValue(c.getValue() - ingredients[m.ingredient].getAmount());
          break;

        case _Type.Combine:
        case _Type.Kombinieren:
          if (mixingbowls[m.mixingbowl].size() == 0) {
            valid = false;
            error.addAll([
              _Messages[language]['common_programming_error_runtime'],
              _Messages[language]['chef_error_runtime_combine_with_empty_mixing_bowl'],
              _Messages[language]['chef_error_runtime_method_step'],
              m.n.toString() + ' : ' + m.type.toString() + ' => ' + (m.mixingbowl + 1).toString(),
              ''
            ]);
            return null;
          }
          c = mixingbowls[m.mixingbowl].peek();
          c.setValue(c.getValue() * ingredients[m.ingredient].getAmount());
          break;

        case _Type.Divide:
        case _Type.Teilen:
          if (mixingbowls[m.mixingbowl].size() == 0) {
            valid = false;
            error.addAll([
              _Messages[language]['common_programming_error_runtime'],
              _Messages[language]['chef_error_runtime_divide_from_empty_mixing_bowl'],
              _Messages[language]['chef_error_runtime_method_step'],
              m.n.toString() + ' : ' + m.type.toString() + ' => ' + (m.mixingbowl + 1).toString()
            ]);
            return null;
          }
          c = mixingbowls[m.mixingbowl].peek();
          c.setValue((c.getValue() ~/ ingredients[m.ingredient].getAmount()).round());
          break;

        case _Type.AddDry:
        case _Type.FestesHinzugeben:
          int sum = 0;
          ingredients.forEach((key, value) {
            if (value.getState() == _State.Dry) sum += value.getAmount();
          });
          mixingbowls[m.mixingbowl].push(new _Component(sum, _State.Dry, ''));
          break;

        case _Type.Liquefy:
        case _Type.Schmelzen:
          ingredients[m.ingredient].liquefy();
          break;

        case _Type.LiquefyBowl:
        case _Type.SchuesselErhitzen:
          mixingbowls[m.mixingbowl].liquefy();
          liquefyMissing = false;
          break;

        case _Type.Stir:
        case _Type.SchuessselRuehren:
          if (mixingbowls[m.mixingbowl].size() == 0) {
            valid = false;
            error.addAll([
              _Messages[language]['common_programming_error_runtime'],
              _Messages[language]['chef_error_runtime_stir_empty_mixing_bowl'],
              _Messages[language]['chef_error_runtime_method_step'],
              m.n.toString() + ' : ' + m.type.toString() + ' => ' + (m.mixingbowl + 1).toString()
            ]);
            return null;
          }
          mixingbowls[m.mixingbowl].stir(m.time);
          break;

        case _Type.StirInto:
        case _Type.ZutatRuehren:
          if (mixingbowls[m.mixingbowl].size() == 0) {
            valid = false;
            error.addAll([
              _Messages[language]['common_programming_error_runtime'],
              _Messages[language]['chef_error_runtime_stir_in_empty_mixing_bowl'],
              _Messages[language]['chef_error_runtime_method_step'],
              m.n.toString() + ' : ' + m.type.toString() + ' => ' + (m.mixingbowl + 1).toString()
            ]);
            return null;
          }
          mixingbowls[m.mixingbowl].stir(ingredients[m.ingredient].getAmount());
          break;

        case _Type.Mix:
        case _Type.Mischen:
          if (mixingbowls[m.mixingbowl].size() == 0) {
            valid = false;
            error.addAll([
              _Messages[language]['common_programming_error_runtime'],
              _Messages[language]['chef_error_runtime_mix_empty_mixing_bowl'],
              _Messages[language]['chef_error_runtime_method_step'],
              m.n.toString() + ' : ' + m.type.toString() + ' => ' + (m.mixingbowl + 1).toString()
            ]);
            return null;
          }
          mixingbowls[m.mixingbowl].shuffle();
          break;

        case _Type.Clean:
        case _Type.Saeubern:
          mixingbowls[m.mixingbowl].clean();
          break;

        case _Type.Pour:
        case _Type.Ausgiessen:
          bakingdishes[m.bakingdish].combine(mixingbowls[m.mixingbowl]);
          break;

        case _Type.Verb:
        case _Type.Wiederholen:
          int end = i + 1;
          for (; end < methods.length; end++) {
            if (_sameVerb(m.verb, methods[end].verb, language) &&
                (methods[end].type == _Type.VerbUntil || methods[end].type == _Type.WiederholenBis)) {
              break;
            }
          }
          if (end == methods.length) {
            valid = false;
            error.addAll([
              _Messages[language]['common_programming_error_runtime'],
              _Messages[language]['chef_error_runtime_method_loop'],
              m.n.toString() + ' : ' + m.type.toString()
            ]);
            return null;
          }
          if (ingredients[m.ingredient].getAmount() <= 0) {
            i = end + 1;
            continue methodloop;
          } else
            loops.insertAll(0, {_LoopData(i, end, m.verb)});
          break;

        case _Type.VerbUntil:
        case _Type.WiederholenBis:
          if (!_sameVerb(loops[0].verb, m.verb, language)) {
            valid = false;
            error.addAll([
              _Messages[language]['common_programming_error_runtime'],
              _Messages[language]['chef_error_runtime_method_loop_end'],
              m.n.toString() + ' : ' + m.type.toString()
            ]);
            return null;
          }
          if (ingredients[m.ingredient] != null)
            ingredients[m.ingredient].setAmount(ingredients[m.ingredient].getAmount() - 1);
          i = loops[0].from;
          loops.removeAt(0);
          continue methodloop;

        case _Type.SetAside:
        case _Type.BeiseiteStellen:
          if (loops.length == 0) {
            valid = false;
            error.addAll([
              _Messages[language]['common_programming_error_runtime'],
              _Messages[language]['chef_error_runtime_method_loop_aside'],
              m.n.toString() + ' : ' + m.type.toString()
            ]);
            return null;
          } else {
            i = loops[0].to + 1;
            loops.removeAt(0);
            continue methodloop;
          }
          break;

        case _Type.Serve:
        case _Type.Servieren:
          if (recipes[m.auxrecipe.toLowerCase()] == null) {
            valid = false;
            error.addAll([
              _Messages[language]['common_programming_error_runtime'],
              _Messages[language]['chef_error_runtime_method_aux_recipe'],
              m.n.toString() + ' : ' + m.type.toString() + ' => ' + m.auxrecipe
            ]);
            return null;
          }
          try {
            _Kitchen k = new _Kitchen(recipes, recipes[m.auxrecipe.toLowerCase()], mixingbowls, bakingdishes, language);
            _Container con = k.cook(additionalIngredients, language, depth + 1);
            if (k.exception) {
              valid = false;
              exception = true;
              exceptionArose = true;
              //error.removeRange(0, error.length-1);
              error.addAll(k.error);
              continue methodloop;
            } else if (con != null)
              mixingbowls[0].combine(con);
            else {
              valid = false;
              error.addAll([
                _Messages[language]['common_programming_error_runtime'],
                _Messages[language]['chef_error_runtime_method_aux_recipe'],
                _Messages[language]['chef_error_runtime_method_aux_recipe_return'],
                '=> ' + m.auxrecipe,
              ]);
              return null;
            }
          } catch (e) {
            valid = false;
            exception = true;
            error.addAll([
              _Messages[language]['common_programming_error_runtime'],
              _Messages[language]['chef_error_runtime_exception'],
              _Messages[language]['chef_error_runtime_serving_aux'],
              e.toString(),
              ' at depth ' + depth.toString()
            ]);
            exceptionArose = true;
            continue methodloop;
          }
          break;

        case _Type.Refrigerate:
        case _Type.Gefrieren:
          if (m.time > 0) {
            _serve(m.time);
          }
          deepfrozen = true;
          break;

        case _Type.Remember:
        case _Type.Erinnern:
          break;
        default:
          {
            valid = false;
            error.addAll([
              _Messages[language]['common_programming_error_runtime'],
              _Messages[language]['chef_error_syntax_method_unsupported'],
              m.n.toString() + ' : ' + m.type.toString()
            ]);
            return null;
          }
      }
      i++;
    } // end of MethodLoop - all is done
    if (!exceptionArose) {
      if (recipe.getServes() > 0 && !deepfrozen) {
        _serve(recipe.getServes());
      }
      if (mixingbowls.length > 0) {
        return mixingbowls[0];
      } // end of auxiliary recipe
      //return null;  // end of mainrecipe
    }
  } // cook

  bool _sameVerb(String imp, verb, language) {
    if (verb == null || imp == null) return false;
    verb = verb.toLowerCase();
    imp = imp.toLowerCase();
    int L = imp.length;
    if (language == 'ENG') {
      return verb == (imp + "n") || //shake ~ shaken
          verb == (imp + "d") || //prepare ~ prepared
          verb == (imp + "ed") || //monitor ~ monitored
          verb == (imp + (imp[L - 1]) + "ed") || //stir ~ stirred
          (imp[L - 1] == 'y' && verb == (imp.substring(0, L - 1) + "ied")); //carry ~ carried
    } else {
      return verb == imp;
    }
  }

  void _serve(int n) {
    for (int i = 0; i < n && i < bakingdishes.length; i++) {
      meal.add(bakingdishes[i].serve());
    }
  }
}

class _LoopData {
  int from, to;
  String verb;

  _LoopData(int from, int to, String verb) {
    this.from = from;
    this.to = to;
    this.verb = verb;
  }
}
