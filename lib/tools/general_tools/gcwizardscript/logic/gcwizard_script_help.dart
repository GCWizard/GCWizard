part of 'package:gc_wizard/tools/general_tools/gcwizardscript/logic/gcwizard_script.dart';

const GCWIZARDSCRIPT_HELP_EXAMPLES = 0;
const GCWIZARDSCRIPT_HELP_VARIABLE = 1;
const GCWIZARDSCRIPT_HELP_DATATYPES = 2;
const GCWIZARDSCRIPT_HELP_OPERATORS = 3;
const GCWIZARDSCRIPT_HELP_COMMANDS = 4;
const GCWIZARDSCRIPT_HELP_CONTROLS = 5;
const GCWIZARDSCRIPT_HELP_MATH = 6;
const GCWIZARDSCRIPT_HELP_STRINGS = 7;
const GCWIZARDSCRIPT_HELP_LISTS = 8;
const GCWIZARDSCRIPT_HELP_FILES = 9;
const GCWIZARDSCRIPT_HELP_DATE = 10;
const GCWIZARDSCRIPT_HELP_GRAPHIC = 11;
const GCWIZARDSCRIPT_HELP_WPTS = 12;
const GCWIZARDSCRIPT_HELP_COORD = 13;

Map<int, List<String>> GCW_SKRIPT_HELP_URLS = {
  GCWIZARDSCRIPT_HELP_EXAMPLES: [
    'gcwizard_script_help_examples',
    'https://blog.gcwizard.net/manual/de/basic/04-beispiele/'
  ],
  GCWIZARDSCRIPT_HELP_VARIABLE: [
    'gcwizard_script_help_variables',
    'https://blog.gcwizard.net/manual/de/variablen-und-datentypen/variablen/'
  ],
  GCWIZARDSCRIPT_HELP_DATATYPES: [
    'gcwizard_script_help_datatypes',
    'https://blog.gcwizard.net/manual/de/variablen-und-datentypen/01-variablen-und-datentypen/'
  ],
  GCWIZARDSCRIPT_HELP_OPERATORS: [
    'gcwizard_script_help_operators',
    'https://blog.gcwizard.net/manual/de/2-operatoren-und-funktionen/operatoren-und-funktionen/'
  ],
  GCWIZARDSCRIPT_HELP_COMMANDS: [
    'gcwizard_script_help_commands',
    'https://blog.gcwizard.net/manual/de/31-befehle/031-gc-wizard-skript-befehle/'
  ],
  GCWIZARDSCRIPT_HELP_CONTROLS: [
    'gcwizard_script_help_controls',
    'https://blog.gcwizard.net/manual/de/32-kontrollstrukturen/032-gc-wizard-skript-kontrollstrukturen/'
  ],
  GCWIZARDSCRIPT_HELP_MATH: [
    'gcwizard_script_help_math',
    'https://blog.gcwizard.net/manual/de/41-mathematik/041-gc-wizard-skript-mathematische-funktionen/'
  ],
  GCWIZARDSCRIPT_HELP_STRINGS: [
    'gcwizard_script_help_strings',
    'https://blog.gcwizard.net/manual/de/42-zeichenketten/042-gc-wizard-skript-funktionen-fur-zeichen-und-zeichenketten/'
  ],
  GCWIZARDSCRIPT_HELP_LISTS: ['gcwizard_script_help_lists', 'https://blog.gcwizard.net/manual/de/48-listen/listen/'],
  GCWIZARDSCRIPT_HELP_FILES: ['gcwizard_script_help_files', 'https://blog.gcwizard.net/manual/de/dateien/ubersicht/'],
  GCWIZARDSCRIPT_HELP_DATE: [
    'gcwizard_script_help_datetime',
    'https://blog.gcwizard.net/manual/de/43-datum-zeit/043-gc-wizard-skript-datums-zeitfunktionen/'
  ],
  GCWIZARDSCRIPT_HELP_GRAPHIC: [
    'gcwizard_script_help_graphics',
    'https://blog.gcwizard.net/manual/de/44-grafik/044-gc-wizard-skript-funktionen-zum-erstellen-von-grafiken/'
  ],
  GCWIZARDSCRIPT_HELP_WPTS: [
    'gcwizard_script_help_waypoints',
    'https://blog.gcwizard.net/manual/de/45-wegpunktlisten/045-gc-wizard-skript-funktionen-fur-wegpunktlisten/'
  ],
  GCWIZARDSCRIPT_HELP_COORD: [
    'gcwizard_script_help_coordinates',
    'https://blog.gcwizard.net/manual/de/46-koordinaten/046-gc-wizard-skript-funktionen-fur-koordinatenberechnungen/'
  ],
};
