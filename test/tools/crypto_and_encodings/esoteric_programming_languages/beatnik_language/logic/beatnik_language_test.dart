import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/crypto_and_encodings/esoteric_programming_languages/beatnik_language/logic/beatnik_language.dart';
import 'package:gc_wizard/tools/games/scrabble/logic/scrabble_sets.dart';

void main() {

  group("beatnik_language.interpret", () {
    //https://en.wikipedia.org/wiki/Beatnik_(programming_language)
    //https://esolangs.org/wiki/beatnik
    //http://cliffle.com/esoterica/beatnik/
    //   does not work - to much adds => delete two - baser, lilac
    //                 - numbers wrong: queasy => queassiest
    //                 - prints in thw wrong order

    String HelloWorld = '''Soars, larkspurs, rains. 
Indistinctness.
Mario snarl (nurses, natures, rules...) sensuously retries goal.
Agribusinesses' costs par lain ropes (mopes) autos' cores.
Tuner ambitiousness.
Flit.
Dour entombment.
Legals' saner kinking lapse.
Nests glint.
Dread, tied futures, dourer usual tumor grunts alter atonal
  garb tries shouldered coins.
Taste a vast lustiness.
Stile stuns gad subgroup gram lanes.
Draftee insurer road: cuckold blunt, strut sunnier.
Rely enure pantheism: arty gain groups (genies, pan) titters, tattles, nears.
Bluffer tapes?  Idle diatom stooge!
Feted antes anklets ague?  Remit goiter gout!
Doubtless teared toed alohas will dull gangs' aerials' tails' sluices;
Gusset ends!  Gawkier halo!

Enter abstruse rested loser beer guy louts.
Curtain roams lasso weir lupus stunt.
Truant bears animate talon.  Entire torte originally timer.
Redo stilt gobs.

Utter centaurs;
Urgent stars;
Usurers (dilute);
Noses;
Bones;
Brig sonar graders;
Utensil silts;
Lazies.
Fret arson veterinary rows.

Atlas grunted: "Pates, slues, sulfuric manor liaising tines,
  trailers, rep... unfair!  Instant snots!"

Sled rested until eatery fail.
Ergs fortitude
  Indent spotter
Euros enter egg.
Curious tenures.
Torus cutlasses.
Sarong torso earns cruel lags it reeled.

Engineer: "Erase handbag -- unite ratification!"

oaring oaten donkeys unsold, surer rapid saltest tags
BUTTERED TIBIA LUGS REWIRING TOILETS
anion festers raring edit epilogues.
DIRGE ROTOR.
linnet oaring.
GORE BOOTIES.
Ironed goon lists tallest sublets --
Riots,
Raucous onset.

Ignobly, runners' diet anguishes sunrise loner.
Erode mob, slier switcher!
Loaners stilt drudge pearl atoll, risking hats' ends.

Rebind sitters.

Toga epistles -- crud lard.  (Pager purse dons souls.)

glob title a curio hired rites shed suds lade grease strut arctic revs toad
unless idlers rind stilt region land GERMICIDES SULTANA GUTS gill siting leans
nice spurs
tests gloves
roused asp

Holes!  Moles!  (Sores!)
Hygienists!  Scars!  (Asses!)
Smells spell rares.

Cubs instant sing in parse goodies.
Rosin.  Unhelpful sisal acres.  Slope told.
MALENESS PASTA LAB.  "Infirmary vine," rang illiterates (beans).
Rosin sours, insults truss abalones, nailed rules, helical atlases.
Dear remodeling stings mar rents.
Sunless shiner orb (silly idol.)
Clarity disses senna.
Vagabonds sauted; sloes performed gelds.
Alter post radial lip sectioning gums.
Saint Towellings.
Larger aeons telephone stolid char, pal!
Boats Dean forsook, rosters, tunas, terrariums -- united, traced.
Nude pagoda careens.''';
    String Rudimentary = '''Hello, aunts! Around, around, swim!''';
    String Alphabet = '''Ho humbuzz, Dionysus. | orgasm if I feel altruistic & alone...
    Llanfairpwllgwyngyllgogerychwyrndrobwllllantysiliogogogoch?! Ha!
    Monarchies spoil; language intermediates everyone!''';
    String Cliffle = '''Baa, badasssed areas!
Jarheads' arses
      queasy nude adverbs!
    Dare address abase adder? *bares baser dadas* HA!
Equalize, add bezique, bra emblaze.
  He (quezal), aeons liable.  Label lilac "bulla," ocean sauce!
Ends, addends,
   duodena sounded amends.''';
    String CliffleCorrect = '''Baa, badassed areas!
Jarheads' arses
      queassiest nude adverbs!
    Dare address abase adder? *bares  dadas* HA!
Equalize, add bezique, bra emblaze.
  He (quezal), aeons liable.  Label  "bulla," ocean sauce!
Ends, addends,
   duodena sounded amends.''';
    String GC2M99K = '''NORD: AUFGABE SCHWER! BEIDE PERSONEN HATTEN EINES VERSTANDEN: ETWAS FEIERN! NATÜRLICH - NUR WER VERURTEILT DAS? DIE JUGEND? NEIN! DIE IST NÄMLICH SICHERLICH VORSICHTIG. BLIEBEN DIE ÄRZTE. DAMIT SIND MANCHE FAST SOGENANNTE BOTSCHAFTER. KONTAKT VERMEIDEN!

Danke, Onkel Hanno - ich liebe Scrabble.
BLOSS EIN ALT TRINKT NIEMAND IN KÖLN.
Ende der Durchsage!

MENSCH, IST DIE RENTE VERLOREN? SCHLUSS AUS UND ENDE. JA, JA, DER DIREKTOR BEKAM DEN AUFWAND GEZAHLT! :-(

BIS DIE WELT GERETTET IST, IST DIR DAS SEHR ERNST. FAST IST ES ABSEITS. NEUES EUROPA SOLL BEFREIT DENKEN.

BIN DEN ARBEITEN IN DER FREIEN NATUR GEWACHSEN. FILMEN SIE DIE ANDEREN PLANETEN.

DAS PFERD IST EINE LEGENDE. MANGELT ES DIR AN IDEEN? EINE STRASSE - EIN AUSWEG. DIE WEISHEIT IST HERAUSFORDERUNG. NUR AM RANDE: BERG RUFT DAS ECHO.

SIE STARTEN IN DIE WÜSTE WÜSTE. DEINE FRAGE IST EIN GENUSS, FREUND.

IST EISEN ZERSTÖRUNG ODER INFRASTRUKTUR? DAS ZEITALTER DAUERTE EWIG UND DAS KLOSTER IST GEBAUT.

DAS PAPIER IST DEINE STIMME UND DAS IST WIEDERUM TOLL, MEINT DER GENERAL.

IST DEINE TANTE IN SPANIEN IRGENDWO IM URLAUB? SIE TRUG EINE TASCHE IN DEN BUNDESTAG! SEITDEM IST SIE SOWIESO BESONDERS IN DER KRITIK.

LASSEN DEINE DEMONSTRANTEN DEN REKORD ENDLICH SINKEN? DES VATERS GELD IST GARANTIERT RICHTIG GETEILT.

WIE EINE STRASSE IST DIE KINDHEIT JETZT KURZ. WAR JA EH STARKER WANDEL. DONNERSTAG WAR EINE BEI WEITEM HARTE MISSION DER PLANUNG.

DANEBEN IST ÄRGER, WIE ES HEISST, DER MOTOR. EINES INDES HAT DER TRAINER UNBEDINGT VON MIR: CHARAKTER IST SEELE!

UNSER VERHINDERN DER WERBUNG IST OFT KURZ. DER DIREKTOR LAG ÖFTER IN DER BAHN. STOLZ IST TATSACHE UND ALLTAG.

EIN ZWEITER STANDORT IST GERN VORHANDEN UND GESUCHT. DARUM IST EIN DIALOG VIELES NEUES - IST ANREGUNG UND BILDET.

ES REDEN DARUNTER SELTEN DIE ANWOHNER. DIE GENE ANTWORTEN DIR NICHTS. FERNER IST ES EIN DING.

VERTRAUEN IST GEGENSTAND EINZELNER KULTUREN. ES SITZT EIN LEITER IM WALD; ER IST SAUER.

REICHT DAS FREUNDE DER DISTANZ? DA DEINE UMWELT DIR ERGEBEN IST, IST ES EH EINE VISION DES KINOS. DAS NIVEAU IST VÖLLIG EGAL.

POLITISCHES SCHAFFEN IST ENTLASTUNG - ENTLASTUNG DER STEUER. ICH SEHE GIFTGAS - EINE SUBSTANZ DER CHEMIE.

DIE ARMUT DER MASSE IST REINE VERGANGENHEIT. ES DAUERTE TAGE. DA ERKENNT MAN DIE GESTE DER FEINEN GESELLSCHAFT.

DU BIST DIE BEUTE DES TOURISMUS'!

DIE IRONIE IST UNSER VERLUST AN STARKER ETHIK - SO ZIEMLICH.''';

    List<Map<String, Object?>> _inputsToExpected = [
      {'scrabbleSet' : scrabbleID_EN, 'sourcecode' : HelloWorld, 'input' : '', 'expectedOutput' : BeatnikOutput(['Hello, world!\n'], [], [], [], [])},
      {'scrabbleSet' : scrabbleID_EN, 'sourcecode' : Rudimentary, 'input' : 'a', 'expectedOutput' : BeatnikOutput(['h'], [], [], [], [])},
      {'scrabbleSet' : scrabbleID_EN, 'sourcecode' : Alphabet, 'input' : '', 'expectedOutput' : BeatnikOutput([' !"#\$%&'"'"'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~'], [], [], [], [])},
      {'scrabbleSet' : scrabbleID_EN, 'sourcecode' : Cliffle, 'input' : '', 'expectedOutput' : BeatnikOutput(['common_programming_error_runtime','beatnik_error_runtime_stack','beatnik_error_runtime_add'], [], [], [], [])},
      {'scrabbleSet' : scrabbleID_EN, 'sourcecode' : CliffleCorrect, 'input' : '', 'expectedOutput' : BeatnikOutput(['\niH'], [], [], [], [])},
      {'scrabbleSet' : scrabbleID_D, 'sourcecode' : GC2M99K, 'input' : '', 'expectedOutput' : BeatnikOutput(['Cache bei:N51°15.176 E6° 32.373'], [], [], [], [])},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = interpretBeatnik(elem['scrabbleSet'] as String, elem['sourcecode'] as String, elem['input'] as String);
        var length = (elem['expectedOutput'] as BeatnikOutput).output.length;
        for (int i = 0; i < length; i++) {
          expect(_actual.output[i], (elem['expectedOutput'] as BeatnikOutput).output[i]);
        }
      });
    }
  });


}