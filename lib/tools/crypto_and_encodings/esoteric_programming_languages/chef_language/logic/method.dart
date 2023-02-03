part of 'package:gc_wizard/tools/crypto_and_encodings/esoteric_programming_languages/chef_language/logic/chef_language.dart';

class _Method {
  String ingredient;
  int mixingbowl;
  int bakingdish;
  String auxrecipe;
  int time; //'Refrigerate for number of hours' / 'Stir for number of minutes'
  String verb;
  _Type type;
  int n;

  _Method(String line, int n, language) {
    line = line.trim();
    this.n = n;
    List<RegExp> matchers = <RegExp>[];
    if (language == 'ENG') {
      matchers = _matchersENG;
      if (matchers[0].hasMatch(line)) {
        // take
        ingredient = matchers[0].firstMatch(line).group(2);
        type = _Type.Take;
      } else if (matchers[1].hasMatch(line)) {
        // put | fold
        if (matchers[1].firstMatch(line).group(1) == 'put')
          type = _Type.Put;
        else
          type = _Type.Fold;
        ingredient = matchers[1].firstMatch(line).group(3);
        mixingbowl =
            (matchers[1].firstMatch(line).group(6) == null ? 1 : int.parse(matchers[1].firstMatch(line).group(6))) - 1;
      } else if (matchers[2].hasMatch(line)) {
        // add dry ingredients
        type = _Type.AddDry;
        mixingbowl =
            (matchers[2].firstMatch(line).group(5) == null ? 1 : int.parse(matchers[2].firstMatch(line).group(5))) - 1;
      } else if (matchers[3].hasMatch(line)) {
        // add | remove | combine | divide
        switch (matchers[3].firstMatch(line).group(1)) {
          case 'add':
            type = _Type.Add;
            break;
          case 'remove':
            type = _Type.Remove;
            break;
          case 'combine':
            type = _Type.Combine;
            break;
          case 'divide':
            type = _Type.Divide;
            break;
        }
        ingredient = matchers[3].firstMatch(line).group(3);
        mixingbowl =
            (matchers[3].firstMatch(line).group(8) == null ? 1 : int.parse(matchers[3].firstMatch(line).group(8))) - 1;
      } else if (matchers[4].hasMatch(line)) {
        //liquefy contents
        type = _Type.LiquefyBowl;
        mixingbowl =
            (matchers[4].firstMatch(line).group(3) == null ? 1 : int.parse(matchers[4].firstMatch(line).group(3))) - 1;
      } else if (matchers[5].hasMatch(line)) {
        //liquefy
        type = _Type.Liquefy;
        ingredient = matchers[5].firstMatch(line).group(2);
      } else if (matchers[6].hasMatch(line)) {
        // stir the
        type = _Type.Stir;
        mixingbowl =
            (matchers[6].firstMatch(line).group(4) == null ? 1 : int.parse(matchers[6].firstMatch(line).group(4))) - 1;
        time = int.parse(matchers[6].firstMatch(line).group(6));
      } else if (matchers[7].hasMatch(line)) {
        // stir into
        type = _Type.StirInto;
        ingredient = matchers[7].firstMatch(line).group(2);
        mixingbowl =
            (matchers[7].firstMatch(line).group(5) == null ? 1 : int.parse(matchers[7].firstMatch(line).group(5))) - 1;
      } else if (matchers[8].hasMatch(line)) {
        // mix
        type = _Type.Mix;
        mixingbowl =
            (matchers[8].firstMatch(line).group(4) == null ? 1 : int.parse(matchers[8].firstMatch(line).group(4))) - 1;
      } else if (matchers[9].hasMatch(line)) {
        // clean
        type = _Type.Clean;
        mixingbowl =
            (matchers[9].firstMatch(line).group(3) == null ? 1 : int.parse(matchers[9].firstMatch(line).group(3))) - 1;
      } else if (matchers[10].hasMatch(line)) {
        // pour
        type = _Type.Pour;
        mixingbowl =
            (matchers[10].firstMatch(line).group(4) == null ? 1 : int.parse(matchers[10].firstMatch(line).group(4))) -
                1;
        bakingdish =
            (matchers[10].firstMatch(line).group(8) == null ? 1 : int.parse(matchers[10].firstMatch(line).group(8))) -
                1;
      } else if (matchers[11].hasMatch(line)) {
        // set aside
        type = _Type.SetAside;
      } else if (matchers[12].hasMatch(line)) {
        // refridgerate
        type = _Type.Refrigerate;
        time = matchers[12].firstMatch(line).group(2) == null ? 0 : int.parse(matchers[12].firstMatch(line).group(2));
      } else if (matchers[13].hasMatch(line)) {
        // serve with
        type = _Type.Serve;
        auxrecipe = matchers[13].firstMatch(line).group(2);
      } else if (matchers[14].hasMatch(line)) {
        // suggestion
        type = _Type.Remember;
      } else if (matchers[15].hasMatch(line)) {
        // xxx (the) ingredient until yyyed
        type = _Type.VerbUntil;
        verb = matchers[15].firstMatch(line).group(5);
        ingredient = matchers[15].firstMatch(line).group(4);
      } else if (matchers[16].hasMatch(line)) {
        // yyy (the) ingredient
        type = _Type.Verb;
        verb = matchers[16].firstMatch(line).group(1);
        ingredient = matchers[16].firstMatch(line).group(3);
      } else {
        // invalid method
        type = _Type.Invalid;
        ingredient = line;
      }
    } else {
      matchers = _matchersDEU;
      if (matchers[0].hasMatch(line)) {
        // die zutat aus dem kühlschrank nehmen
        ingredient = matchers[0].firstMatch(line).group(2);
        type = _Type.Nehmen;
      } else if (matchers[1].hasMatch(line)) {
        // zutat in die schüssel geben
        type = _Type.Geben;
        ingredient = matchers[1].firstMatch(line).group(2);
        mixingbowl =
            (matchers[1].firstMatch(line).group(4) == null ? 1 : int.parse(matchers[1].firstMatch(line).group(4))) - 1;
      } else if (matchers[2].hasMatch(line)) {
        // zutat in die schüssel unterheben
        type = _Type.Unterheben;
        ingredient = matchers[2].firstMatch(line).group(2);
        mixingbowl =
            (matchers[2].firstMatch(line).group(4) == null ? 1 : int.parse(matchers[2].firstMatch(line).group(4))) - 1;
      } else if (matchers[3].hasMatch(line)) {
        // feste zutaten hinzufügen
        type = _Type.FestesHinzugeben;
        mixingbowl =
            (matchers[3].firstMatch(line).group(8) == null ? 1 : int.parse(matchers[3].firstMatch(line).group(8))) - 1;
      } else if (matchers[4].hasMatch(line)) {
        // füge hinzu |entferne | kombiniere | teile
        switch (matchers[4].firstMatch(line).group(12)) {
          case 'hinzufügen':
          case 'dazugeben':
            type = _Type.Dazugeben;
            break;
          case 'entfernen':
          case 'abschöpfen':
            type = _Type.Abschoepfen;
            break;
          case 'kombinieren':
            type = _Type.Kombinieren;
            break;
          case 'teilen':
            type = _Type.Teilen;
            break;
        }
        ingredient = matchers[4].firstMatch(line).group(2);
        mixingbowl =
            (matchers[4].firstMatch(line).group(7) == null ? 1 : int.parse(matchers[4].firstMatch(line).group(7))) - 1;
      } else if (matchers[5].hasMatch(line)) {
        //RegExp(r'^inhalt(e)? der ((\d+)(ten) )?(rühr)?schüssel( auf dem stövchen)?( erhitzen| zerlassen| schmelzen| verflüssigen)$'),
        //inhalt der schüssel verflüssigen
        type = _Type.SchuesselErhitzen;
        mixingbowl =
            (matchers[5].firstMatch(line).group(3) == null ? 1 : int.parse(matchers[5].firstMatch(line).group(3))) - 1;
      } else if (matchers[6].hasMatch(line)) {
        //zutat verflüssigen
        type = _Type.Schmelzen;
        ingredient = matchers[6].firstMatch(line).group(2);
      } else if (matchers[7].hasMatch(line)) {
        // schüssel rühren
        type = _Type.SchuessselRuehren;
        mixingbowl =
            (matchers[7].firstMatch(line).group(4) == null ? 1 : int.parse(matchers[7].firstMatch(line).group(4))) - 1;
        time = int.parse(matchers[7].firstMatch(line).group(7));
      } else if (matchers[8].hasMatch(line)) {
        // zutat unterrühren
        type = _Type.ZutatRuehren;
        ingredient = matchers[8].firstMatch(line).group(2);
        mixingbowl =
            (matchers[8].firstMatch(line).group(6) == null ? 1 : int.parse(matchers[8].firstMatch(line).group(6))) - 1;
      } else if (matchers[9].hasMatch(line)) {
        // mischen
        type = _Type.Mischen;
        mixingbowl =
            (matchers[9].firstMatch(line).group(2) == null ? 1 : int.parse(matchers[9].firstMatch(line).group(2))) - 1;
      } else if (matchers[10].hasMatch(line)) {
        // säubern || waschen
        type = _Type.Saeubern;
        mixingbowl =
            (matchers[10].firstMatch(line).group(2) == null ? 1 : int.parse(matchers[10].firstMatch(line).group(2))) -
                1;
      } else if (matchers[11].hasMatch(line)) {
        // stürzen || gießen
        type = _Type.Ausgiessen;
        mixingbowl =
            (matchers[11].firstMatch(line).group(4) == null ? 1 : int.parse(matchers[11].firstMatch(line).group(4))) -
                1;
        bakingdish =
            (matchers[11].firstMatch(line).group(12) == null ? 1 : int.parse(matchers[11].firstMatch(line).group(12))) -
                1;
      } else if (matchers[12].hasMatch(line)) {
        // zur seite stellen
        type = _Type.BeiseiteStellen;
      } else if (matchers[13].hasMatch(line)) {
        // einfrieren
        type = _Type.Gefrieren;
        time = matchers[13].firstMatch(line).group(3) == null ? 0 : int.parse(matchers[13].firstMatch(line).group(3));
      } else if (matchers[14].hasMatch(line)) {
        // serve with
        type = _Type.Servieren;
        auxrecipe = matchers[14].firstMatch(line).group(2);
      } else if (matchers[15].hasMatch(line)) {
        // vorschlag
        type = _Type.Erinnern;
      } else if (matchers[16].hasMatch(line)) {
        // solange yyy bis zutat zur ...
        type = _Type.WiederholenBis;
        verb = matchers[16].firstMatch(line).group(1);
        ingredient = matchers[16].firstMatch(line).group(4);
      } else if (matchers[17].hasMatch(line)) {
        // die zutat yyy
        type = _Type.Wiederholen;
        verb = matchers[17].firstMatch(line).group(3);
        ingredient = matchers[17].firstMatch(line).group(2);
      } else {
        // invalid method
        type = _Type.Unbekannt;
        ingredient = line;
      }
    }
  }
}
