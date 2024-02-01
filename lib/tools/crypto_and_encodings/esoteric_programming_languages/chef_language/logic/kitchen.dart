part of 'package:gc_wizard/tools/crypto_and_encodings/esoteric_programming_languages/chef_language/logic/chef_language.dart';

class _Kitchen {
  late List<_Container> mixingbowls;
  late List<_Container> bakingdishes;
  Map<String, _Recipe> recipes;
  _Recipe recipe;
  late bool valid;
  late bool exception;
  late List<String> meal;
  late List<String> error;
  late bool liquefyMissing;

  _Kitchen(this.recipes, this.recipe, List<_Container>? mbowls, List<_Container>? bdishes, String language) {
    valid = true;
    exception = false;
    meal = <String>[];
    error = <String>[];
    liquefyMissing = true;
    //start with at least 1 mixing bowl.
    int maxbowl = 0;
    int maxdish = -1;

    if (recipe.getMethods() != null) {
      for (var m in recipe.getMethods()!) {
        if (m.bakingdish != null && m.bakingdish! > maxdish) maxdish = m.bakingdish!;
        if (m.mixingbowl != null && m.mixingbowl! > maxbowl) maxbowl = m.mixingbowl!;
      }

      mixingbowls = List<_Container>.generate(mbowls == null ? maxbowl + 1 : max(maxbowl + 1, mbowls.length), (i) {
        return _Container(null);
      });
      if (mbowls != null) {
        for (int i = 0; i < mbowls.length; i++) {
          mixingbowls[i] = _Container(mbowls[i]);
        }
      }

      bakingdishes = List<_Container>.generate(bdishes == null ? maxdish + 1 : max(maxdish + 1, bdishes.length), (i) {
        return _Container(null);
      });
      if (bdishes != null) {
        for (int i = 0; i < bdishes.length; i++) {
          bakingdishes[i] = _Container(bdishes[i]);
        }
      }
    } else {
      valid = false;
      error.addAll([
        _CHEF_Messages[language]?['chef_error_structure_recipe'] ?? '',
        _CHEF_Messages[language]?['chef_error_structure_recipe_methods'] ?? '',
        _CHEF_Messages[language]?['chef_error_syntax_method'] ?? '',
        ''
      ]);
    }
  }

  _Container? cook(String additionalIngredients, String language, int depth) {
    int ingredientIndex = 0;
    List<String> input = additionalIngredients.split(' ');

    Map<String, _Ingredient> ingredients = recipe.getIngredients();
    var methods = recipe.getMethods();
    var loops = <_LoopData>[];
    _Component? c;
    int i = 0;
    bool deepfrozen = false;
    bool exceptionArose = false;
    methodloop:
    while (i < (methods?.length ?? 0) && !deepfrozen && !exceptionArose) {
      _Method m = methods![i];
      if (m.type == _CHEF_Method.Invalid) {
        valid = false;
        error.addAll([
          _CHEF_Messages[language]?['chef_error_syntax_method'] ?? '',
          m.ingredient ?? '',
          _CHEF_Messages[language]?['chef_error_syntax_method_unsupported'] ?? '',
          ''
        ]);
        return null;
      }
      // else {
      //   if (ingredients[m.ingredient] == null) {
      //     valid = false;
      //     error.addAll([
      //       _CHEF_Messages[language]?['common_programming_error_runtime'] ?? '',
      //       _CHEF_Messages[language]?['chef_error_runtime_method_step'] ?? '',
      //       m.n.toString() + ' : ' + m.type.toString(),
      //       _CHEF_Messages[language]?['chef_error_runtime_ingredient_not_found'] ?? '',
      //       m.ingredient ?? '',
      //       ''
      //     ]);
      //     return null;
      //   }
      // }
      switch (m.type) {
        case _CHEF_Method.Take:
        case _CHEF_Method.Nehmen:
          if ((input.join('').isNotEmpty) && (ingredientIndex <= input.length - 1)) {
            ingredients[m.ingredient]!.setAmount(int.tryParse(input[ingredientIndex]));
            ingredientIndex++;
          } else {
            valid = false;
            error.addAll([
              _CHEF_Messages[language]?['common_programming_error_runtime'] ?? '',
              _CHEF_Messages[language]?['chef_error_runtime_missing_input'] ?? '',
              ''
            ]);
            return null;
          }
          break;

        case _CHEF_Method.Put:
        case _CHEF_Method.Geben:
          // var mb = mixingbowls[m.mixingbowl!];
          // mb.push(_Component.Contructor1(ingredients[m.ingredient]!));
          // mixingbowls[m.mixingbowl!] = mb;
          mixingbowls[m.mixingbowl!].push(_Component.Contructor1(ingredients[m.ingredient]!));
          break;

        case _CHEF_Method.Fold:
        case _CHEF_Method.Unterheben:
          if (mixingbowls[m.mixingbowl!].size() == 0) {
            valid = false;
            error.addAll([
              _CHEF_Messages[language]?['common_programming_error_runtime'] ?? '',
              _CHEF_Messages[language]?['chef_error_runtime_folded_from_empty_mixing_bowl'] ?? '',
              _CHEF_Messages[language]?['chef_error_runtime_method_step'] ?? '',
              m.n.toString() + ' : ' + m.type.toString() + ' => ' + (m.mixingbowl! + 1).toString(),
              ''
            ]);
            return null;
          }
          // var mb = mixingbowls[m.mixingbowl!];
          // c = mb.pop();
          // mixingbowls[m.mixingbowl!] = mb;
          c = mixingbowls[m.mixingbowl!].pop();
          ingredients[m.ingredient]!.setAmount(c!.getValue());
          ingredients[m.ingredient]!.setState(c.getState());
          break;

        case _CHEF_Method.Add:
        case _CHEF_Method.Dazugeben:
          if (mixingbowls[m.mixingbowl!].size() == 0) {
            valid = false;
            error.addAll([
              _CHEF_Messages[language]?['common_programming_error_runtime'] ?? '',
              _CHEF_Messages[language]?['chef_error_runtime_add_to_empty_mixing_bowl'] ?? '',
              _CHEF_Messages[language]?['chef_error_runtime_method_step'] ?? '',
              m.n.toString() + ' : ' + m.type.toString() + ' => ' + (m.mixingbowl! + 1).toString(),
              ''
            ]);
            return null;
          }
          c = mixingbowls[m.mixingbowl!].peek();
          c.setValue(c.getValue() + ingredients[m.ingredient]!.getAmount()!);
          break;

        case _CHEF_Method.Remove: // ingredient.amount from mixingbowl
        case _CHEF_Method.Abschoepfen:
          if (mixingbowls[m.mixingbowl!].size() == 0) {
            valid = false;
            error.addAll([
              _CHEF_Messages[language]?['common_programming_error_runtime'] ?? '',
              _CHEF_Messages[language]?['chef_error_runtime_remove_from_empty_mixing_bowl'] ?? '',
              _CHEF_Messages[language]?['chef_error_runtime_method_step'] ?? '',
              m.n.toString() + ' : ' + m.type.toString() + ' => ' + (m.mixingbowl! + 1).toString(),
              ''
            ]);
            return null;
          }
          c = mixingbowls[m.mixingbowl!].peek(); // returns top of m.mixingbowl
          c.setValue(c.getValue() - ingredients[m.ingredient]!.getAmount()!);
          break;

        case _CHEF_Method.Combine:
        case _CHEF_Method.Kombinieren:
          if (mixingbowls[m.mixingbowl!].size() == 0) {
            valid = false;
            error.addAll([
              _CHEF_Messages[language]?['common_programming_error_runtime'] ?? '',
              _CHEF_Messages[language]?['chef_error_runtime_combine_with_empty_mixing_bowl'] ?? '',
              _CHEF_Messages[language]?['chef_error_runtime_method_step'] ?? '',
              m.n.toString() + ' : ' + m.type.toString() + ' => ' + (m.mixingbowl! + 1).toString(),
              ''
            ]);
            return null;
          }
          c = mixingbowls[m.mixingbowl!].peek();
          c.setValue(c.getValue() * ingredients[m.ingredient]!.getAmount()!);
          break;

        case _CHEF_Method.Divide:
        case _CHEF_Method.Teilen:
          if (mixingbowls[m.mixingbowl!].size() == 0) {
            valid = false;
            error.addAll([
              _CHEF_Messages[language]?['common_programming_error_runtime'] ?? '',
              _CHEF_Messages[language]?['chef_error_runtime_divide_from_empty_mixing_bowl'] ?? '',
              _CHEF_Messages[language]?['chef_error_runtime_method_step'] ?? '',
              m.n.toString() + ' : ' + m.type.toString() + ' => ' + (m.mixingbowl! + 1).toString()
            ]);
            return null;
          }
          c = mixingbowls[m.mixingbowl!].peek();
          c.setValue((c.getValue() ~/ ingredients[m.ingredient]!.getAmount()!).round());
          break;

        case _CHEF_Method.AddDry:
        case _CHEF_Method.FestesHinzugeben:
          int sum = 0;
          ingredients.forEach((key, value) {
            if (value.getState() == _State.Dry) sum += value.getAmount()!;
          });
          mixingbowls[m.mixingbowl!].push(_Component(sum, _State.Dry, ''));
          break;

        case _CHEF_Method.Liquefy:
        case _CHEF_Method.Schmelzen:
          ingredients[m.ingredient]!.liquefy();
          break;

        case _CHEF_Method.LiquefyBowl:
        case _CHEF_Method.SchuesselErhitzen:
          mixingbowls[m.mixingbowl!].liquefy();
          liquefyMissing = false;
          break;

        case _CHEF_Method.Stir:
        case _CHEF_Method.SchuessselRuehren:
          if (mixingbowls[m.mixingbowl!].size() == 0) {
            valid = false;
            error.addAll([
              _CHEF_Messages[language]?['common_programming_error_runtime'] ?? '',
              _CHEF_Messages[language]?['chef_error_runtime_stir_empty_mixing_bowl'] ?? '',
              _CHEF_Messages[language]?['chef_error_runtime_method_step'] ?? '',
              m.n.toString() + ' : ' + m.type.toString() + ' => ' + (m.mixingbowl! + 1).toString()
            ]);
            return null;
          }
          mixingbowls[m.mixingbowl!].stir(m.time!);
          break;

        case _CHEF_Method.StirInto:
        case _CHEF_Method.ZutatRuehren:
          if (mixingbowls[m.mixingbowl!].size() == 0) {
            valid = false;
            error.addAll([
              _CHEF_Messages[language]?['common_programming_error_runtime'] ?? '',
              _CHEF_Messages[language]?['chef_error_runtime_stir_in_empty_mixing_bowl'] ?? '',
              _CHEF_Messages[language]?['chef_error_runtime_method_step'] ?? '',
              m.n.toString() + ' : ' + m.type.toString() + ' => ' + (m.mixingbowl! + 1).toString()
            ]);
            return null;
          }
          mixingbowls[m.mixingbowl!].stir(ingredients[m.ingredient]!.getAmount()!);
          break;

        case _CHEF_Method.Mix:
        case _CHEF_Method.Mischen:
          if (mixingbowls[m.mixingbowl!].size() == 0) {
            valid = false;
            error.addAll([
              _CHEF_Messages[language]?['common_programming_error_runtime'] ?? '',
              _CHEF_Messages[language]?['chef_error_runtime_mix_empty_mixing_bowl'] ?? '',
              _CHEF_Messages[language]?['chef_error_runtime_method_step'] ?? '',
              m.n.toString() + ' : ' + m.type.toString() + ' => ' + (m.mixingbowl! + 1).toString()
            ]);
            return null;
          }
          mixingbowls[m.mixingbowl!].shuffle();
          break;

        case _CHEF_Method.Clean:
        case _CHEF_Method.Saeubern:
          mixingbowls[m.mixingbowl!].clean();
          break;

        case _CHEF_Method.Pour:
        case _CHEF_Method.Ausgiessen:
          bakingdishes[m.bakingdish!].combine(mixingbowls[m.mixingbowl!]);
          break;

        case _CHEF_Method.Verb:
        case _CHEF_Method.Wiederholen:
          int end = i + 1;
          for (; end < methods.length; end++) {
            if (_sameVerb(m.verb, methods[end].verb, language) &&
                (methods[end].type == _CHEF_Method.VerbUntil || methods[end].type == _CHEF_Method.WiederholenBis)) {
              break;
            }
          }
          if (end == methods.length) {
            valid = false;
            error.addAll([
              _CHEF_Messages[language]?['common_programming_error_runtime'] ?? '',
              _CHEF_Messages[language]?['chef_error_runtime_method_loop'] ?? '',
              m.n.toString() + ' : ' + m.type.toString()
            ]);
            return null;
          }
          if (ingredients[m.ingredient]!.getAmount()! <= 0) {
            i = end + 1;
            continue methodloop;
          } else {
            loops.insertAll(0, {_LoopData(i, end, m.verb!)});
          }
          break;

        case _CHEF_Method.VerbUntil:
        case _CHEF_Method.WiederholenBis:
          if (!_sameVerb(loops[0].verb, m.verb, language)) {
            valid = false;
            error.addAll([
              _CHEF_Messages[language]?['common_programming_error_runtime'] ?? '',
              _CHEF_Messages[language]?['chef_error_runtime_method_loop_end'] ?? '',
              m.n.toString() + ' : ' + m.type.toString()
            ]);
            return null;
          }
          if (ingredients[m.ingredient] != null) {
            ingredients[m.ingredient]!.setAmount(ingredients[m.ingredient]!.getAmount()! - 1);
          }
          i = loops[0].from;
          loops.removeAt(0);
          continue methodloop;

        case _CHEF_Method.SetAside:
        case _CHEF_Method.BeiseiteStellen:
          if (loops.isEmpty) {
            valid = false;
            error.addAll([
              _CHEF_Messages[language]?['common_programming_error_runtime'] ?? '',
              _CHEF_Messages[language]?['chef_error_runtime_method_loop_aside'] ?? '',
              m.n.toString() + ' : ' + m.type.toString()
            ]);
            return null;
          } else {
            i = loops[0].to + 1;
            loops.removeAt(0);
            continue methodloop;
          }

        case _CHEF_Method.Serve:
        case _CHEF_Method.Servieren:
          if (recipes[m.auxrecipe!.toLowerCase()] == null) {
            valid = false;
            error.addAll([
              _CHEF_Messages[language]?['common_programming_error_runtime'] ?? '',
              _CHEF_Messages[language]?['chef_error_runtime_method_aux_recipe'] ?? '',
              m.n.toString() + ' : ' + m.type.toString() + ' => ' + (m.auxrecipe ?? '')
            ]);
            return null;
          }
          try {
            _Kitchen k = _Kitchen(recipes, recipes[m.auxrecipe!.toLowerCase()]!, mixingbowls, bakingdishes, language);
            _Container? con = k.cook(additionalIngredients, language, depth + 1);
            if (k.exception) {
              valid = false;
              exception = true;
              exceptionArose = true;
              //error.removeRange(0, error.length-1);
              error.addAll(k.error);
              continue methodloop;
            } else if (con != null) {
              mixingbowls[0].combine(con);
            } else {
              valid = false;
              error.addAll([
                _CHEF_Messages[language]?['common_programming_error_runtime'] ?? '',
                _CHEF_Messages[language]?['chef_error_runtime_method_aux_recipe'] ?? '',
                _CHEF_Messages[language]?['chef_error_runtime_method_aux_recipe_return'] ?? '',
                '=> ' + (m.auxrecipe ?? ''),
              ]);
              return null;
            }
          } catch (e) {
            valid = false;
            exception = true;
            error.addAll([
              _CHEF_Messages[language]?['common_programming_error_runtime'] ?? '',
              _CHEF_Messages[language]?['chef_error_runtime_exception'] ?? '',
              _CHEF_Messages[language]?['chef_error_runtime_serving_aux'] ?? '',
              e.toString(),
              ' at depth ' + depth.toString()
            ]);
            exceptionArose = true;
            continue methodloop;
          }
          break;

        case _CHEF_Method.Refrigerate:
        case _CHEF_Method.Gefrieren:
          if (m.time! > 0) {
            _serve(m.time!);
          }
          deepfrozen = true;
          break;

        case _CHEF_Method.Remember:
        case _CHEF_Method.Erinnern:
          break;
        default:
          {
            valid = false;
            error.addAll([
              _CHEF_Messages[language]?['common_programming_error_runtime'] ?? '',
              _CHEF_Messages[language]?['chef_error_syntax_method_unsupported'] ?? '',
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
      if (mixingbowls.isNotEmpty) {
        return mixingbowls[0];
      } // end of auxiliary recipe
      //return null;  // end of mainrecipe
    }
    return null;
  } // cook

  bool _sameVerb(String? imp, String? verb, String language) {
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
  int from;
  int to;
  String verb;

  _LoopData(this.from, this.to, this.verb);
}
