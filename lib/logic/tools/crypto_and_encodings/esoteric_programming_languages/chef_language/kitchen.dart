import 'dart:math';

import 'package:gc_wizard/logic/tools/crypto_and_encodings/esoteric_programming_languages/chef_language/chef_international.dart';
import 'package:gc_wizard/logic/tools/crypto_and_encodings/esoteric_programming_languages/chef_language/component.dart';
import 'package:gc_wizard/logic/tools/crypto_and_encodings/esoteric_programming_languages/chef_language/container.dart';
import 'package:gc_wizard/logic/tools/crypto_and_encodings/esoteric_programming_languages/chef_language/ingredient.dart';
import 'package:gc_wizard/logic/tools/crypto_and_encodings/esoteric_programming_languages/chef_language/method.dart';
import 'package:gc_wizard/logic/tools/crypto_and_encodings/esoteric_programming_languages/chef_language/recipe.dart';

class Kitchen {
  List<Container> mixingbowls;
  List<Container> bakingdishes;
  Map<String, Recipe> recipes;
  Recipe recipe;
  bool valid;
  bool exception;
  List<String> error;
  List<String> meal;
  bool liquefyMissing;

  Kitchen(Map<String, Recipe> recipes, Recipe mainrecipe, List<Container> mbowls, List<Container> bdishes,
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

      this.mixingbowls = new List<Container>(mbowls == null ? maxbowl + 1 : max(maxbowl + 1, mbowls.length));
      for (int i = 0; i < this.mixingbowls.length; i++) this.mixingbowls[i] = new Container(null);
      if (mbowls != null) {
        for (int i = 0; i < mbowls.length; i++) {
          this.mixingbowls[i] = new Container(mbowls[i]);
        }
      }

      this.bakingdishes = new List<Container>(bdishes == null ? maxdish + 1 : max(maxdish + 1, bdishes.length));
      for (int i = 0; i < this.bakingdishes.length; i++) this.bakingdishes[i] = new Container(null);
      if (bdishes != null) {
        for (int i = 0; i < bdishes.length; i++) {
          this.bakingdishes[i] = new Container(bdishes[i]);
        }
      }
    } else {
      valid = false;
      error.addAll([
        Messages[language]['chef_error_structure_recipe'],
        Messages[language]['chef_error_structure_recipe_methods'],
        Messages[language]['chef_error_syntax_method'],
        ''
      ]);
    }
  }

  Container cook(String additionalIngredients, language, int depth) {
    int ingredientIndex = 0;
    List<String> input = additionalIngredients.split(' ');

    Map<String, Ingredient> ingredients = recipe.getIngredients();
    List<Method> methods = recipe.getMethods();
    var loops = List<_LoopData>();
    Component c;
    int i = 0;
    bool deepfrozen = false;
    bool exceptionArose = false;
    methodloop:
    while (i < methods.length && !deepfrozen && !exceptionArose) {
      Method m = methods[i];
      switch (m.type) {
        case Type.Invalid:
          valid = false;
          error.addAll([
            Messages[language]['chef_error_syntax_method'],
            m.ingredient,
            Messages[language]['chef_error_syntax_method_unsupported'],
            ''
          ]);
          return null;
          break;
        case Type.Take:
        case Type.Nehmen:
        case Type.Put:
        case Type.Geben:
        case Type.Fold:
        case Type.Unterheben:
        case Type.Add:
        case Type.Dazugeben:
        case Type.Remove:
        case Type.Abschoepfen:
        case Type.Combine:
        case Type.Kombinieren:
        case Type.Divide:
        case Type.Teilen:
        case Type.Liquefy:
        case Type.Schmelzen:
        case Type.StirInto:
        case Type.ZutatRuehren:
        case Type.Verb:
        case Type.Wiederholen:
          if (ingredients[m.ingredient] == null) {
            valid = false;
            error.addAll([
              Messages[language]['common_programming_error_runtime'],
              Messages[language]['chef_error_runtime_method_step'],
              m.n.toString() + ' : ' + m.type.toString(),
              Messages[language]['chef_error_runtime_ingredient_not_found'],
              m.ingredient,
              ''
            ]);
            return null;
          }
      }
      switch (m.type) {
        case Type.Take:
        case Type.Nehmen:
          if ((input.join('') != '') && (ingredientIndex <= input.length - 1)) {
            ingredients[m.ingredient].setAmount(int.parse(input[ingredientIndex]));
            ingredientIndex++;
          } else {
            valid = false;
            error.addAll([
              Messages[language]['common_programming_error_runtime'],
              Messages[language]['chef_error_runtime_missing_input'],
              ''
            ]);
            return null;
          }
          break;

        case Type.Put:
        case Type.Geben:
          mixingbowls[m.mixingbowl].push(Component.Contructor1(ingredients[m.ingredient]));
          break;

        case Type.Fold:
        case Type.Unterheben:
          if (mixingbowls[m.mixingbowl].size() == 0) {
            valid = false;
            error.addAll([
              Messages[language]['common_programming_error_runtime'],
              Messages[language]['chef_error_runtime_folded_from_empty_mixing_bowl'],
              Messages[language]['chef_error_runtime_method_step'],
              m.n.toString() + ' : ' + m.type.toString() + ' => ' + (m.mixingbowl + 1).toString(),
              ''
            ]);
            return null;
          }
          c = mixingbowls[m.mixingbowl].pop();
          ingredients[m.ingredient].setAmount(c.getValue());
          ingredients[m.ingredient].setState(c.getState());
          break;

        case Type.Add:
        case Type.Dazugeben:
          if (mixingbowls[m.mixingbowl].size() == 0) {
            valid = false;
            error.addAll([
              Messages[language]['common_programming_error_runtime'],
              Messages[language]['chef_error_runtime_add_to_empty_mixing_bowl'],
              Messages[language]['chef_error_runtime_method_step'],
              m.n.toString() + ' : ' + m.type.toString() + ' => ' + (m.mixingbowl + 1).toString(),
              ''
            ]);
            return null;
          }
          c = mixingbowls[m.mixingbowl].peek();
          c.setValue(c.getValue() + ingredients[m.ingredient].getAmount());
          break;

        case Type.Remove: // ingredient.amount from mixingbowl
        case Type.Abschoepfen:
          if (mixingbowls[m.mixingbowl].size() == 0) {
            valid = false;
            error.addAll([
              Messages[language]['common_programming_error_runtime'],
              Messages[language]['chef_error_runtime_remove_from_empty_mixing_bowl'],
              Messages[language]['chef_error_runtime_method_step'],
              m.n.toString() + ' : ' + m.type.toString() + ' => ' + (m.mixingbowl + 1).toString(),
              ''
            ]);
            return null;
          }
          c = mixingbowls[m.mixingbowl].peek(); // returns top of m.mixingbowl
          c.setValue(c.getValue() - ingredients[m.ingredient].getAmount());
          break;

        case Type.Combine:
        case Type.Kombinieren:
          if (mixingbowls[m.mixingbowl].size() == 0) {
            valid = false;
            error.addAll([
              Messages[language]['common_programming_error_runtime'],
              Messages[language]['chef_error_runtime_combine_with_empty_mixing_bowl'],
              Messages[language]['chef_error_runtime_method_step'],
              m.n.toString() + ' : ' + m.type.toString() + ' => ' + (m.mixingbowl + 1).toString(),
              ''
            ]);
            return null;
          }
          c = mixingbowls[m.mixingbowl].peek();
          c.setValue(c.getValue() * ingredients[m.ingredient].getAmount());
          break;

        case Type.Divide:
        case Type.Teilen:
          if (mixingbowls[m.mixingbowl].size() == 0) {
            valid = false;
            error.addAll([
              Messages[language]['common_programming_error_runtime'],
              Messages[language]['chef_error_runtime_divide_from_empty_mixing_bowl'],
              Messages[language]['chef_error_runtime_method_step'],
              m.n.toString() + ' : ' + m.type.toString() + ' => ' + (m.mixingbowl + 1).toString()
            ]);
            return null;
          }
          c = mixingbowls[m.mixingbowl].peek();
          c.setValue((c.getValue() ~/ ingredients[m.ingredient].getAmount()).round());
          break;

        case Type.AddDry:
        case Type.FestesHinzugeben:
          int sum = 0;
          ingredients.forEach((key, value) {
            if (value.getState() == State.Dry) sum += value.getAmount();
          });
          mixingbowls[m.mixingbowl].push(new Component(sum, State.Dry, ''));
          break;

        case Type.Liquefy:
        case Type.Schmelzen:
          ingredients[m.ingredient].liquefy();
          break;

        case Type.LiquefyBowl:
        case Type.SchuesselErhitzen:
          mixingbowls[m.mixingbowl].liquefy();
          liquefyMissing = false;
          break;

        case Type.Stir:
        case Type.SchuessselRuehren:
          if (mixingbowls[m.mixingbowl].size() == 0) {
            valid = false;
            error.addAll([
              Messages[language]['common_programming_error_runtime'],
              Messages[language]['chef_error_runtime_stir_empty_mixing_bowl'],
              Messages[language]['chef_error_runtime_method_step'],
              m.n.toString() + ' : ' + m.type.toString() + ' => ' + (m.mixingbowl + 1).toString()
            ]);
            return null;
          }
          mixingbowls[m.mixingbowl].stir(m.time);
          break;

        case Type.StirInto:
        case Type.ZutatRuehren:
          if (mixingbowls[m.mixingbowl].size() == 0) {
            valid = false;
            error.addAll([
              Messages[language]['common_programming_error_runtime'],
              Messages[language]['chef_error_runtime_stir_in_empty_mixing_bowl'],
              Messages[language]['chef_error_runtime_method_step'],
              m.n.toString() + ' : ' + m.type.toString() + ' => ' + (m.mixingbowl + 1).toString()
            ]);
            return null;
          }
          mixingbowls[m.mixingbowl].stir(ingredients[m.ingredient].getAmount());
          break;

        case Type.Mix:
        case Type.Mischen:
          if (mixingbowls[m.mixingbowl].size() == 0) {
            valid = false;
            error.addAll([
              Messages[language]['common_programming_error_runtime'],
              Messages[language]['chef_error_runtime_mix_empty_mixing_bowl'],
              Messages[language]['chef_error_runtime_method_step'],
              m.n.toString() + ' : ' + m.type.toString() + ' => ' + (m.mixingbowl + 1).toString()
            ]);
            return null;
          }
          mixingbowls[m.mixingbowl].shuffle();
          break;

        case Type.Clean:
        case Type.Saeubern:
          mixingbowls[m.mixingbowl].clean();
          break;

        case Type.Pour:
        case Type.Ausgiessen:
          bakingdishes[m.bakingdish].combine(mixingbowls[m.mixingbowl]);
          break;

        case Type.Verb:
        case Type.Wiederholen:
          int end = i + 1;
          for (; end < methods.length; end++) {
            if (_sameVerb(m.verb, methods[end].verb, language) &&
                (methods[end].type == Type.VerbUntil || methods[end].type == Type.WiederholenBis)) {
              break;
            }
          }
          if (end == methods.length) {
            valid = false;
            error.addAll([
              Messages[language]['common_programming_error_runtime'],
              Messages[language]['chef_error_runtime_method_loop'],
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

        case Type.VerbUntil:
        case Type.WiederholenBis:
          if (!_sameVerb(loops[0].verb, m.verb, language)) {
            valid = false;
            error.addAll([
              Messages[language]['common_programming_error_runtime'],
              Messages[language]['chef_error_runtime_method_loop_end'],
              m.n.toString() + ' : ' + m.type.toString()
            ]);
            return null;
          }
          if (ingredients[m.ingredient] != null)
            ingredients[m.ingredient].setAmount(ingredients[m.ingredient].getAmount() - 1);
          i = loops[0].from;
          loops.removeAt(0);
          continue methodloop;

        case Type.SetAside:
        case Type.BeiseiteStellen:
          if (loops.length == 0) {
            valid = false;
            error.addAll([
              Messages[language]['common_programming_error_runtime'],
              Messages[language]['chef_error_runtime_method_loop_aside'],
              m.n.toString() + ' : ' + m.type.toString()
            ]);
            return null;
          } else {
            i = loops[0].to + 1;
            loops.removeAt(0);
            continue methodloop;
          }
          break;

        case Type.Serve:
        case Type.Servieren:
          if (recipes[m.auxrecipe.toLowerCase()] == null) {
            valid = false;
            error.addAll([
              Messages[language]['common_programming_error_runtime'],
              Messages[language]['chef_error_runtime_method_aux_recipe'],
              m.n.toString() + ' : ' + m.type.toString() + ' => ' + m.auxrecipe
            ]);
            return null;
          }
          try {
            Kitchen k = new Kitchen(recipes, recipes[m.auxrecipe.toLowerCase()], mixingbowls, bakingdishes, language);
            Container con = k.cook(additionalIngredients, language, depth + 1);
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
                Messages[language]['common_programming_error_runtime'],
                Messages[language]['chef_error_runtime_method_aux_recipe'],
                Messages[language]['chef_error_runtime_method_aux_recipe_return'],
                '=> ' + m.auxrecipe,
              ]);
              return null;
            }
          } catch (e) {
            valid = false;
            exception = true;
            error.addAll([
              Messages[language]['common_programming_error_runtime'],
              Messages[language]['chef_error_runtime_exception'],
              Messages[language]['chef_error_runtime_serving_aux'],
              e.toString(),
              ' at depth ' + depth.toString()
            ]);
            exceptionArose = true;
            continue methodloop;
          }
          break;

        case Type.Refrigerate:
        case Type.Gefrieren:
          if (m.time > 0) {
            _serve(m.time);
          }
          deepfrozen = true;
          break;

        case Type.Remember:
        case Type.Erinnern:
          break;
        default:
          {
            valid = false;
            error.addAll([
              Messages[language]['common_programming_error_runtime'],
              Messages[language]['chef_error_syntax_method_unsupported'],
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
