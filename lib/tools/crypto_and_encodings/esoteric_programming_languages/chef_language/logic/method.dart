part of 'package:gc_wizard/tools/crypto_and_encodings/esoteric_programming_languages/chef_language/logic/chef_language.dart';

class _Method {
  String? ingredient;
  int? mixingbowl;
  int? bakingdish;
  String? auxrecipe;
  int? time; //'Refrigerate for number of hours' / 'Stir for number of minutes'
  String? verb;
  _CHEF_Method? type;
  int? n;

  _Method(String line, int this.n, String language) {
    line = line.trim();
    List<RegExp> matchers = <RegExp>[];
    if (language == 'ENG') {
      matchers = _CHEF_matchersENG;
      if (matchers[0].hasMatch(line)) {
        // take
        ingredient = matchers[0].firstMatch(line)!.group(2)!;
        type = _CHEF_Method.Take;
      } else if (matchers[1].hasMatch(line)) {
        // put | fold
        if (matchers[1].firstMatch(line)!.group(1) == 'put') {
          type = _CHEF_Method.Put;
        } else {
          type = _CHEF_Method.Fold;
        }
        ingredient = matchers[1].firstMatch(line)!.group(3)!;
        mixingbowl =
            (matchers[1].firstMatch(line)!.group(6) == null ? 1 : int.parse(matchers[1].firstMatch(line)!.group(6)!)) - 1;
      } else if (matchers[2].hasMatch(line)) {
        // add dry ingredients
        type = _CHEF_Method.AddDry;
        mixingbowl =
            (matchers[2].firstMatch(line)!.group(5) == null ? 1 : int.parse(matchers[2].firstMatch(line)!.group(5)!)) - 1;
      } else if (matchers[3].hasMatch(line)) {
        // add | remove | combine | divide
        switch (matchers[3].firstMatch(line)!.group(1)) {
          case 'add':
            type = _CHEF_Method.Add;
            break;
          case 'remove':
            type = _CHEF_Method.Remove;
            break;
          case 'combine':
            type = _CHEF_Method.Combine;
            break;
          case 'divide':
            type = _CHEF_Method.Divide;
            break;
        }
        ingredient = matchers[3].firstMatch(line)!.group(3)!;
        mixingbowl =
            (matchers[3].firstMatch(line)!.group(8) == null ? 1 : int.parse(matchers[3].firstMatch(line)!.group(8)!)) - 1;
      } else if (matchers[4].hasMatch(line)) {
        //liquefy contents
        type = _CHEF_Method.LiquefyBowl;
        mixingbowl =
            (matchers[4].firstMatch(line)!.group(3) == null ? 1 : int.parse(matchers[4].firstMatch(line)!.group(3)!)) - 1;
      } else if (matchers[5].hasMatch(line)) {
        //liquefy
        type = _CHEF_Method.Liquefy;
        ingredient = matchers[5].firstMatch(line)!.group(2)!;
      } else if (matchers[6].hasMatch(line)) {
        // stir the
        type = _CHEF_Method.Stir;
        mixingbowl =
            (matchers[6].firstMatch(line)!.group(4) == null ? 1 : int.parse(matchers[6].firstMatch(line)!.group(4)!)) - 1;
        time = int.parse(matchers[6].firstMatch(line)!.group(6)!);
      } else if (matchers[7].hasMatch(line)) {
        // stir into
        type = _CHEF_Method.StirInto;
        ingredient = matchers[7].firstMatch(line)!.group(2)!;
        mixingbowl =
            (matchers[7].firstMatch(line)!.group(5) == null ? 1 : int.parse(matchers[7].firstMatch(line)!.group(5)!)) - 1;
      } else if (matchers[8].hasMatch(line)) {
        // mix
        type = _CHEF_Method.Mix;
        mixingbowl =
            (matchers[8].firstMatch(line)!.group(4) == null ? 1 : int.parse(matchers[8].firstMatch(line)!.group(4)!)) - 1;
      } else if (matchers[9].hasMatch(line)) {
        // clean
        type = _CHEF_Method.Clean;
        mixingbowl =
            (matchers[9].firstMatch(line)!.group(3) == null ? 1 : int.parse(matchers[9].firstMatch(line)!.group(3)!)) - 1;
      } else if (matchers[10].hasMatch(line)) {
        // pour
        type = _CHEF_Method.Pour;
        mixingbowl =
            (matchers[10].firstMatch(line)!.group(4) == null ? 1 : int.parse(matchers[10].firstMatch(line)!.group(4)!)) -
                1;
        bakingdish =
            (matchers[10].firstMatch(line)!.group(8) == null ? 1 : int.parse(matchers[10].firstMatch(line)!.group(8)!)) -
                1;
      } else if (matchers[11].hasMatch(line)) {
        // set aside
        type = _CHEF_Method.SetAside;
      } else if (matchers[12].hasMatch(line)) {
        // refridgerate
        type = _CHEF_Method.Refrigerate;
        time = matchers[12].firstMatch(line)!.group(2) == null ? 0 : int.parse(matchers[12].firstMatch(line)!.group(2)!);
      } else if (matchers[13].hasMatch(line)) {
        // serve with
        type = _CHEF_Method.Serve;
        auxrecipe = matchers[13].firstMatch(line)!.group(2)!;
      } else if (matchers[14].hasMatch(line)) {
        // suggestion
        type = _CHEF_Method.Remember;
      } else if (matchers[15].hasMatch(line)) {
        // xxx (the) ingredient until yyyed
        type = _CHEF_Method.VerbUntil;
        verb = matchers[15].firstMatch(line)!.group(5)!;
        if (matchers[15].firstMatch(line)?.group(4) != null) {
          ingredient = matchers[15].firstMatch(line)!.group(4)!;
        }
      } else if (matchers[16].hasMatch(line)) {
        // yyy (the) ingredient
        type = _CHEF_Method.Verb;
        verb = matchers[16].firstMatch(line)!.group(1)!;
        ingredient = matchers[16].firstMatch(line)!.group(3)!;
      } else {
        // invalid method
        type = _CHEF_Method.Invalid;
        ingredient = line;
      }
    } else {
      matchers = _CHEF_matchersDEU;
      if (matchers[0].hasMatch(line)) {
        // die zutat aus dem kühlschrank nehmen
        ingredient = matchers[0].firstMatch(line)!.group(2)!;
        type = _CHEF_Method.Nehmen;
      } else if (matchers[1].hasMatch(line)) {
        // zutat in die schüssel geben
        type = _CHEF_Method.Geben;
        ingredient = matchers[1].firstMatch(line)!.group(2)!;
        mixingbowl =
            (matchers[1].firstMatch(line)!.group(4) == null ? 1 : int.parse(matchers[1].firstMatch(line)!.group(4)!)) - 1;
      } else if (matchers[2].hasMatch(line)) {
        // zutat in die schüssel unterheben
        type = _CHEF_Method.Unterheben;
        ingredient = matchers[2].firstMatch(line)!.group(2)!;
        mixingbowl =
            (matchers[2].firstMatch(line)!.group(4) == null ? 1 : int.parse(matchers[2].firstMatch(line)!.group(4)!)) - 1;
      } else if (matchers[3].hasMatch(line)) {
        // feste zutaten hinzufügen
        type = _CHEF_Method.FestesHinzugeben;
        mixingbowl =
            (matchers[3].firstMatch(line)!.group(8) == null ? 1 : int.parse(matchers[3].firstMatch(line)!.group(8)!)) - 1;
      } else if (matchers[4].hasMatch(line)) {
        // füge hinzu |entferne | kombiniere | teile
        switch (matchers[4].firstMatch(line)!.group(12)) {
          case 'hinzufügen':
          case 'dazugeben':
            type = _CHEF_Method.Dazugeben;
            break;
          case 'entfernen':
          case 'abschoepfen':
            type = _CHEF_Method.Abschoepfen;
            break;
          case 'kombinieren':
            type = _CHEF_Method.Kombinieren;
            break;
          case 'teilen':
            type = _CHEF_Method.Teilen;
            break;
        }
        ingredient = matchers[4].firstMatch(line)!.group(2)!;
        mixingbowl =
            (matchers[4].firstMatch(line)!.group(7) == null ? 1 : int.parse(matchers[4].firstMatch(line)!.group(7)!)) - 1;
      } else if (matchers[5].hasMatch(line)) {
        //RegExp(r'^inhalt(e)? der ((\d+)(ten) )?(rühr)?schüssel( auf dem stövchen)?( erhitzen| zerlassen| schmelzen| verflüssigen)$'),
        //inhalt der schüssel verflüssigen
        type = _CHEF_Method.SchuesselErhitzen;
        mixingbowl =
            (matchers[5].firstMatch(line)!.group(3) == null ? 1 : int.parse(matchers[5].firstMatch(line)!.group(3)!)) - 1;
      } else if (matchers[6].hasMatch(line)) {
        //zutat verflüssigen
        type = _CHEF_Method.Schmelzen;
        ingredient = matchers[6].firstMatch(line)!.group(2)!;
      } else if (matchers[7].hasMatch(line)) {
        // schüssel rühren
        type = _CHEF_Method.SchuessselRuehren;
        mixingbowl =
            (matchers[7].firstMatch(line)!.group(4) == null ? 1 : int.parse(matchers[7].firstMatch(line)!.group(4)!)) - 1;
        time = int.parse(matchers[7].firstMatch(line)!.group(7)!);
      } else if (matchers[8].hasMatch(line)) {
        // zutat unterrühren
        type = _CHEF_Method.ZutatRuehren;
        ingredient = matchers[8].firstMatch(line)!.group(2)!;
        mixingbowl =
            (matchers[8].firstMatch(line)!.group(6) == null ? 1 : int.parse(matchers[8].firstMatch(line)!.group(6)!)) - 1;
      } else if (matchers[9].hasMatch(line)) {
        // mischen
        type = _CHEF_Method.Mischen;
        mixingbowl =
            (matchers[9].firstMatch(line)!.group(2) == null ? 1 : int.parse(matchers[9].firstMatch(line)!.group(2)!)) - 1;
      } else if (matchers[10].hasMatch(line)) {
        // säubern || waschen
        type = _CHEF_Method.Saeubern;
        mixingbowl =
            (matchers[10].firstMatch(line)!.group(2) == null ? 1 : int.parse(matchers[10].firstMatch(line)!.group(2)!)) -
                1;
      } else if (matchers[11].hasMatch(line)) {
        // stürzen || gießen
        type = _CHEF_Method.Ausgiessen;
        mixingbowl =
            (matchers[11].firstMatch(line)!.group(4) == null ? 1 : int.parse(matchers[11].firstMatch(line)!.group(4)!)) -
                1;
        bakingdish =
            (matchers[11].firstMatch(line)!.group(12) == null ? 1 : int.parse(matchers[11].firstMatch(line)!.group(12)!)) -
                1;
      } else if (matchers[12].hasMatch(line)) {
        // zur seite stellen
        type = _CHEF_Method.BeiseiteStellen;
      } else if (matchers[13].hasMatch(line)) {
        // einfrieren
        type = _CHEF_Method.Gefrieren;
        time = matchers[13].firstMatch(line)!.group(3) == null ? 0 : int.parse(matchers[13].firstMatch(line)!.group(3)!);
      } else if (matchers[14].hasMatch(line)) {
        // serve with
        type = _CHEF_Method.Servieren;
        auxrecipe = matchers[14].firstMatch(line)!.group(2)!;
      } else if (matchers[15].hasMatch(line)) {
        // vorschlag
        type = _CHEF_Method.Erinnern;
      } else if (matchers[16].hasMatch(line)) {
        // solange yyy bis zutat zur ...
        type = _CHEF_Method.WiederholenBis;
        verb = matchers[16].firstMatch(line)!.group(1)!;
        ingredient = matchers[16].firstMatch(line)!.group(4)!;
      } else if (matchers[17].hasMatch(line)) {
        // die zutat yyy
        type = _CHEF_Method.Wiederholen;
        verb = matchers[17].firstMatch(line)!.group(3)!;
        ingredient = matchers[17].firstMatch(line)!.group(2)!;
      } else {
        // invalid method
        type = _CHEF_Method.Unbekannt;
        ingredient = line;
      }
    }
  }
}
