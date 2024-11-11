part of 'package:gc_wizard/tools/crypto_and_encodings/general_codebreakers/multi_decoder/widget/multi_decoder.dart';

const List<String> _mdtToolsRegistry = [
  MDT_INTERNALNAMES_ROTATION,
  MDT_INTERNALNAMES_ROT5,
  MDT_INTERNALNAMES_ROT18,
  MDT_INTERNALNAMES_ROT47,
  MDT_INTERNALNAMES_REVERSE,
  MDT_INTERNALNAMES_ATBASH,
  MDT_INTERNALNAMES_ALPHABETVALUES,
  MDT_INTERNALNAMES_ASCII,
  MDT_INTERNALNAMES_NUMERALBASES,
  MDT_INTERNALNAMES_BASE,
  MDT_INTERNALNAMES_BRAILLE_DOT_NUMBERS,
  MDT_INTERNALNAMES_COORDINATEFORMATS,
  MDT_INTERNALNAMES_BACON,
  MDT_INTERNALNAMES_GCCODE,
  MDT_INTERNALNAMES_BCD,
  MDT_INTERNALNAMES_KENNY,
  MDT_INTERNALNAMES_ENCLOSEDAREAS,
  MDT_INTERNALNAMES_BEGHILOS,
  MDT_INTERNALNAMES_SEGMENTDISPLAY,
  MDT_INTERNALNAMES_VANITY_MULTITAP,
  MDT_INTERNALNAMES_VANITY_NUMBERSEARCH,
  MDT_INTERNALNAMES_ROMANNUMBERS,
  MDT_INTERNALNAMES_BINARY2IMAGE,
  MDT_INTERNALNAMES_KEYBOARDLAYOUT,
  MDT_INTERNALNAMES_KEYBOARDNUMBERS,
  MDT_INTERNALNAMES_WASD,
  MDT_INTERNALNAMES_CCITT1,
  MDT_INTERNALNAMES_CCITT2,
  MDT_INTERNALNAMES_CHRONOGRAM,
  MDT_INTERNALNAMES_PLAYFAIR,
  MDT_INTERNALNAMES_POLYBIOS,
  MDT_INTERNALNAMES_POKEMON,
  MDT_INTERNALNAMES_TAPIR,
  MDT_INTERNALNAMES_RAGBABY,
  MDT_INTERNALNAMES_ONETIMEPAD,
  MDT_INTERNALNAMES_VIGENERE,
  MDT_INTERNALNAMES_ESOTERIC_LANGUAGE_BEATNIK,
  MDT_INTERNALNAMES_ESOTERIC_LANGUAGE_BRAINFK_DERIVATIVE,
  MDT_INTERNALNAMES_ESOTERIC_LANGUAGE_CHEF,
  MDT_INTERNALNAMES_ESOTERIC_LANGUAGE_COW,
  MDT_INTERNALNAMES_ESOTERIC_LANGUAGE_DEADFISH,
  MDT_INTERNALNAMES_ESOTERIC_LANGUAGE_HOHOHO,
  MDT_INTERNALNAMES_ESOTERIC_LANGUAGE_KAROL_ROBOT,
  MDT_INTERNALNAMES_ESOTERIC_LANGUAGE_MALBOLGE,
  MDT_INTERNALNAMES_ESOTERIC_LANGUAGE_WHITESPACE,
];

/// all multiDecoder default options
final _initialOptions = <String, Map<String, Object>>{
  MDT_INTERNALNAMES_ALPHABETVALUES: {MDT_ALPHABETVALUES_OPTION_ALPHABET: 'alphabet_name_az'},
  MDT_INTERNALNAMES_BACON: {MDT_BACON_OPTION_MODE: MDT_BACON_OPTION_MODE_AB},
  MDT_INTERNALNAMES_BASE: {MDT_BASE_OPTION_BASEFUNCTION: 'base_base64'},
  MDT_INTERNALNAMES_BCD: {MDT_BCD_OPTION_BCDFUNCTION: 'bcd_original'},
  MDT_INTERNALNAMES_CCITT1: {MDT_CCITT1_OPTION_MODE: MDT_CCITT1_OPTION_MODE_BINARY},
  MDT_INTERNALNAMES_CCITT2: {MDT_CCITT2_OPTION_MODE: MDT_CCITT2_OPTION_MODE_BINARY},
  MDT_INTERNALNAMES_COORDINATEFORMATS: {
    MDT_COORDINATEFORMATS_OPTION_FORMAT: coordinateFormatDefinitionByKey(CoordinateFormatKey.UTM).persistenceKey
  },
  MDT_INTERNALNAMES_ESOTERIC_LANGUAGE_BEATNIK: {MDT_ESOTERIC_LANGUAGE_BEATNIK_OPTION_MODE: scrabbleID_EN},
  MDT_INTERNALNAMES_ESOTERIC_LANGUAGE_BRAINFK_DERIVATIVE: {
    MDT_ESOTERIC_LANGUAGE_BRAINFK_DERIVATIVE_OPTION_MODE: MDT_ESOTERIC_LANGUAGE_BRAINFK_DERIVATIVE_OPTION_BRAINFK
  },
  MDT_INTERNALNAMES_ESOTERIC_LANGUAGE_CHEF: {
    MDT_ESOTERIC_LANGUAGE_CHEF_OPTION_MODE: MDT_ESOTERIC_LANGUAGES_CHEF_OPTION_ENGLISH
  },
  MDT_INTERNALNAMES_ESOTERIC_LANGUAGE_DEADFISH: {
    MDT_ESOTERIC_LANGUAGE_DEADFISH_OPTION_MODE: MDT_ESOTERIC_LANGUAGES_DEADFISH_OPTION_IDSO
  },
  MDT_INTERNALNAMES_GCCODE: {MDT_GCCODE_OPTION_MODE: MDT_GCCODE_OPTION_MODE_IDTOGCCODE},
  MDT_INTERNALNAMES_ENCLOSEDAREAS: {MDT_ENCLOSEDAREAS_OPTION_MODE: 'enclosedareas_with4'},
  MDT_INTERNALNAMES_KEYBOARDLAYOUT: {
    MDT_KEYBOARDLAYOUT_OPTION_FROM: getKeyboardByType(KEYBOARD_TYPE.QWERTY_US_INT)?.name ?? '',
    MDT_KEYBOARDLAYOUT_OPTION_TO: getKeyboardByType(KEYBOARD_TYPE.QWERTZ_T1)?.name ?? ''
  },
  MDT_INTERNALNAMES_KEYBOARDNUMBERS: {MDT_KEYBOARDNUMBERS_OPTION_TYPE: 'keyboard_mode_qwertz_ristome_dvorak'},
  MDT_INTERNALNAMES_NUMERALBASES: {MDT_NUMERALBASES_OPTION_FROM: 16},
  MDT_INTERNALNAMES_ONETIMEPAD: {MDT_ONETIMEPAD_OPTION_KEY: 1},
  MDT_INTERNALNAMES_PLAYFAIR: {MDT_PLAYFAIR_OPTION_MODE: alphabetModeName(AlphabetModificationMode.J_TO_I)},
  MDT_INTERNALNAMES_POLYBIOS: {MDT_POLYBIOS_OPTION_MODE: alphabetModeName(AlphabetModificationMode.J_TO_I)},
  MDT_INTERNALNAMES_ROMANNUMBERS: {MDT_ROMANNUMBERS_OPTION_MODE: MDT_ROMANNUMBERS_OPTION_MODE_SUBTRACTION},
  MDT_INTERNALNAMES_ROTATION: {MDT_ROTATION_OPTION_KEY: 13},
  MDT_INTERNALNAMES_SEGMENTDISPLAY: {MDT_SEGMENTDISPLAY_OPTION_NUMBERSEGMENTS: 7},
  MDT_INTERNALNAMES_VANITY_MULTITAP: {MDT_VANITYMULTITAP_OPTION_PHONEMODEL: NAME_PHONEMODEL_SIMPLE_SPACE_0},
  MDT_INTERNALNAMES_VANITY_NUMBERSEARCH: {
    MDT_VANITY_NUMBERSEARCH_OPTION_LANGUAGE: 'common_language_german'},
  MDT_INTERNALNAMES_VIGENERE: {MDT_VIGENERE_OPTION_KEY: 1},
  MDT_INTERNALNAMES_WASD: {MDT_WASD_OPTION_SET: KEYBOARD_CONTROLS[WASD_TYPE.NWSE]!},
  MDT_INTERNALNAMES_RAGBABY: {MDT_RAGBABY_OPTION_MODE: 'ragbaby_option_24'},
};

Object? getDefaultValue(String internalToolName, String option) {
  return _initialOptions[internalToolName]?[option];
}

String checkStringFormatOrDefaultOption(String internalToolName, Map<String, Object?> options, String option) {
  var value = options[option];
  if (value is String) return value;
  value = getDefaultValue(internalToolName, option);
  if (value is String) return value;

  throw Exception('invalid tool option');
}

int checkIntFormatOrDefaultOption(String internalToolName, Map<String, Object?> options, String option) {
  var value = options[option];
  if (value is int) return value;
  value = getDefaultValue(internalToolName, option);
  if (value is int) return value;

  throw Exception('invalid tool option');
}

Map<String, Object?> _multiDecoderToolOptionToGCWMultiDecoderToolOptions(List<MultiDecoderToolOption> mdtOptions) {
  var gcwOptions = <String, Object?>{};

  for (var option in mdtOptions) {
    gcwOptions.putIfAbsent(option.name, () => option.value);
  }

  return gcwOptions;
}

/// all multiDecoder tools
AbstractMultiDecoderTool _multiDecoderToolToGCWMultiDecoderTool(BuildContext context, MultiDecoderToolEntity mdtTool) {
  AbstractMultiDecoderTool gcwTool;

  var options = _initialOptions[mdtTool.internalToolName] ?? <String, Object?>{};
  if (mdtTool.options.isNotEmpty) options = _multiDecoderToolOptionToGCWMultiDecoderToolOptions(mdtTool.options);

  switch (mdtTool.internalToolName) {
    case MDT_INTERNALNAMES_ALPHABETVALUES:
      gcwTool = MultiDecoderToolAlphabetValues(id: mdtTool.id, name: mdtTool.name, options: options);
      break;
    case MDT_INTERNALNAMES_ASCII:
      gcwTool = MultiDecoderToolASCII(id: mdtTool.id, name: mdtTool.name, options: options);
      break;
    case MDT_INTERNALNAMES_ATBASH:
      gcwTool = MultiDecoderToolAtbash(id: mdtTool.id, name: mdtTool.name, options: options);
      break;
    case MDT_INTERNALNAMES_BACON:
      gcwTool = MultiDecoderToolBacon(id: mdtTool.id, name: mdtTool.name, options: options);
      break;
    case MDT_INTERNALNAMES_BASE:
      gcwTool = MultiDecoderToolBase(id: mdtTool.id, name: mdtTool.name, options: options);
      break;
    case MDT_INTERNALNAMES_BCD:
      gcwTool = MultiDecoderToolBCD(id: mdtTool.id, name: mdtTool.name, options: options);
      break;
    case MDT_INTERNALNAMES_BEGHILOS:
      gcwTool = MultiDecoderToolBeghilos(id: mdtTool.id, name: mdtTool.name, options: options);
      break;
    case MDT_INTERNALNAMES_BINARY2IMAGE:
      gcwTool = MultiDecoderBinary2Image(id: mdtTool.id, name: mdtTool.name, options: options);
      break;
    case MDT_INTERNALNAMES_BRAILLE_DOT_NUMBERS:
      gcwTool = MultiDecoderToolBrailleDotNumbers(id: mdtTool.id, name: mdtTool.name, options: options);
      break;
    case MDT_INTERNALNAMES_CCITT1:
      gcwTool = MultiDecoderToolCcitt1(id: mdtTool.id, name: mdtTool.name, options: options);
      break;
    case MDT_INTERNALNAMES_CCITT2:
      gcwTool = MultiDecoderToolCcitt2(id: mdtTool.id, name: mdtTool.name, options: options);
      break;
    case MDT_INTERNALNAMES_CHRONOGRAM:
      gcwTool = MultiDecoderToolChronogram(id: mdtTool.id, name: mdtTool.name, options: options);
      break;
    case MDT_INTERNALNAMES_COORDINATEFORMATS:
      gcwTool =
          MultiDecoderToolCoordinateFormats(id: mdtTool.id, name: mdtTool.name, options: options);
      break;
    case MDT_INTERNALNAMES_ESOTERIC_LANGUAGE_BEATNIK:
      gcwTool = MultiDecoderToolEsotericLanguageBeatnik(
          id: mdtTool.id, name: mdtTool.name, options: options, context: context);
      break;
    case MDT_INTERNALNAMES_ESOTERIC_LANGUAGE_BRAINFK_DERIVATIVE:
      gcwTool = MultiDecoderToolEsotericLanguageBrainfkDerivative(
          id: mdtTool.id, name: mdtTool.name, options: options, context: context);
      break;
    case MDT_INTERNALNAMES_ESOTERIC_LANGUAGE_CHEF:
      gcwTool =
          MultiDecoderToolEsotericLanguageChef(id: mdtTool.id, name: mdtTool.name, options: options, context: context);
      break;
    case MDT_INTERNALNAMES_ESOTERIC_LANGUAGE_COW:
      gcwTool = MultiDecoderToolEsotericLanguageCow(id: mdtTool.id, name: mdtTool.name, options: options);
      break;
    case MDT_INTERNALNAMES_ESOTERIC_LANGUAGE_DEADFISH:
      gcwTool = MultiDecoderToolEsotericLanguageDeadfish(
          id: mdtTool.id, name: mdtTool.name, options: options, context: context);
      break;
    case MDT_INTERNALNAMES_ESOTERIC_LANGUAGE_HOHOHO:
      gcwTool = MultiDecoderToolEsotericLanguageHohoho(id: mdtTool.id, name: mdtTool.name, options: options);
      break;
    case MDT_INTERNALNAMES_ESOTERIC_LANGUAGE_KAROL_ROBOT:
      gcwTool = MultiDecoderToolEsotericLanguageKarolRobot(id: mdtTool.id, name: mdtTool.name, options: options);
      break;
    case MDT_INTERNALNAMES_ESOTERIC_LANGUAGE_MALBOLGE:
      gcwTool = MultiDecoderToolEsotericLanguageMalbolge(id: mdtTool.id, name: mdtTool.name, options: options);
      break;
    case MDT_INTERNALNAMES_ESOTERIC_LANGUAGE_WHITESPACE:
      gcwTool = MultiDecoderToolEsotericLanguageWhitespace(id: mdtTool.id, name: mdtTool.name, options: options);
      break;
    case MDT_INTERNALNAMES_ENCLOSEDAREAS:
      gcwTool = MultiDecoderToolEnclosedAreas(id: mdtTool.id, name: mdtTool.name, options: options, context: context);
      break;
    case MDT_INTERNALNAMES_GCCODE:
      gcwTool = MultiDecoderToolGCCode(id: mdtTool.id, name: mdtTool.name, options: options, context: context);
      break;
    case MDT_INTERNALNAMES_KENNY:
      gcwTool = MultiDecoderToolKenny(id: mdtTool.id, name: mdtTool.name, options: options);
      break;
    case MDT_INTERNALNAMES_KEYBOARDLAYOUT:
      gcwTool = MultiDecoderToolKeyboardLayout(id: mdtTool.id, name: mdtTool.name, options: options);
      break;
    case MDT_INTERNALNAMES_KEYBOARDNUMBERS:
      gcwTool = MultiDecoderToolKeyboardNumbers(id: mdtTool.id, name: mdtTool.name, options: options);
      break;
    case MDT_INTERNALNAMES_NUMERALBASES:
      gcwTool = MultiDecoderToolNumeralBases(id: mdtTool.id, name: mdtTool.name, options: options);
      break;
    case MDT_INTERNALNAMES_ONETIMEPAD:
      gcwTool = MultiDecoderToolOneTimePad(id: mdtTool.id, name: mdtTool.name, options: options);
      break;
    case MDT_INTERNALNAMES_PLAYFAIR:
      gcwTool = MultiDecoderToolPlayfair(id: mdtTool.id, name: mdtTool.name, options: options);
      break;
    case MDT_INTERNALNAMES_POLYBIOS:
      gcwTool = MultiDecoderToolPolybios(id: mdtTool.id, name: mdtTool.name, options: options);
      break;
    case MDT_INTERNALNAMES_POKEMON:
      gcwTool = MultiDecoderToolPokemon(id: mdtTool.id, name: mdtTool.name, options: options);
      break;
    case MDT_INTERNALNAMES_REVERSE:
      gcwTool = MultiDecoderToolReverse(id: mdtTool.id, name: mdtTool.name, options: options);
      break;
    case MDT_INTERNALNAMES_ROMANNUMBERS:
      gcwTool = MultiDecoderToolRomanNumbers(id: mdtTool.id, name: mdtTool.name, options: options);
      break;
    case MDT_INTERNALNAMES_RAGBABY:
      gcwTool = MultiDecoderToolRagbaby(id: mdtTool.id, name: mdtTool.name, options: options);
      break;
    case MDT_INTERNALNAMES_ROT18:
      gcwTool = MultiDecoderToolROT18(id: mdtTool.id, name: mdtTool.name, options: options);
      break;
    case MDT_INTERNALNAMES_ROT47:
      gcwTool = MultiDecoderToolROT47(id: mdtTool.id, name: mdtTool.name, options: options);
      break;
    case MDT_INTERNALNAMES_ROT5:
      gcwTool = MultiDecoderToolROT5(id: mdtTool.id, name: mdtTool.name, options: options);
      break;
    case MDT_INTERNALNAMES_ROTATION:
      gcwTool = MultiDecoderToolRotation(id: mdtTool.id, name: mdtTool.name, options: options);
      break;
    case MDT_INTERNALNAMES_SEGMENTDISPLAY:
      gcwTool = MultiDecoderToolSegmentDisplay(id: mdtTool.id, name: mdtTool.name, options: options);
      break;
    case MDT_INTERNALNAMES_TAPIR:
      gcwTool = MultiDecoderToolTapir(id: mdtTool.id, name: mdtTool.name, options: options);
      break;
    case MDT_INTERNALNAMES_VANITY_MULTITAP:
      gcwTool = MultiDecoderToolVanityMultitap(id: mdtTool.id, name: mdtTool.name, options: options);
      break;
    case MDT_INTERNALNAMES_VANITY_NUMBERSEARCH:
      gcwTool = MultiDecoderToolVanityWordsTextSearch(id: mdtTool.id, name: mdtTool.name, options: options, context: context);
      break;
    case MDT_INTERNALNAMES_VIGENERE:
      gcwTool = MultiDecoderToolVigenere(id: mdtTool.id, name: mdtTool.name, options: options);
      break;
    case MDT_INTERNALNAMES_WASD:
      gcwTool = MultiDecoderToolWasd(id: mdtTool.id, name: mdtTool.name, options: options);
      break;
    default:
      gcwTool = MultiDecoderToolDummy();
      break;
  }

  return gcwTool;
}

/// default configuration
void _initializeMultiToolDecoder(BuildContext context) {
  var newTools = [
    MultiDecoderToolEntity(i18n(context, MDT_INTERNALNAMES_ROT5), MDT_INTERNALNAMES_ROT5),
    MultiDecoderToolEntity(i18n(context, MDT_INTERNALNAMES_ROT18), MDT_INTERNALNAMES_ROT18),
    MultiDecoderToolEntity(i18n(context, MDT_INTERNALNAMES_ROT47), MDT_INTERNALNAMES_ROT47),
    MultiDecoderToolEntity(i18n(context, MDT_INTERNALNAMES_REVERSE), MDT_INTERNALNAMES_REVERSE),
    MultiDecoderToolEntity(i18n(context, MDT_INTERNALNAMES_ATBASH), MDT_INTERNALNAMES_ATBASH),
    MultiDecoderToolEntity(i18n(context, MDT_INTERNALNAMES_ALPHABETVALUES), MDT_INTERNALNAMES_ALPHABETVALUES),
    MultiDecoderToolEntity(i18n(context, MDT_INTERNALNAMES_ASCII), MDT_INTERNALNAMES_ASCII),
    MultiDecoderToolEntity(i18n(context, MDT_INTERNALNAMES_ROMANNUMBERS), MDT_INTERNALNAMES_ROMANNUMBERS,
        options: [MultiDecoderToolOption(MDT_ROMANNUMBERS_OPTION_MODE, MDT_ROMANNUMBERS_OPTION_MODE_SUBTRACTION)]),
    MultiDecoderToolEntity(i18n(context, MDT_INTERNALNAMES_ROMANNUMBERS), MDT_INTERNALNAMES_ROMANNUMBERS,
        options: [MultiDecoderToolOption(MDT_ROMANNUMBERS_OPTION_MODE, MDT_ROMANNUMBERS_OPTION_MODE_ADDITION)]),
    MultiDecoderToolEntity(i18n(context, MDT_INTERNALNAMES_CHRONOGRAM), MDT_INTERNALNAMES_CHRONOGRAM),
    MultiDecoderToolEntity(i18n(context, MDT_INTERNALNAMES_VANITY_MULTITAP), MDT_INTERNALNAMES_VANITY_MULTITAP,
        options: [MultiDecoderToolOption(MDT_VANITYMULTITAP_OPTION_PHONEMODEL, NAME_PHONEMODEL_SIMPLE_SPACE_0)]),
    MultiDecoderToolEntity(i18n(context, MDT_INTERNALNAMES_VANITY_NUMBERSEARCH), MDT_INTERNALNAMES_VANITY_NUMBERSEARCH),
    MultiDecoderToolEntity(i18n(context, MDT_INTERNALNAMES_NUMERALBASES), MDT_INTERNALNAMES_NUMERALBASES,
        options: [MultiDecoderToolOption(MDT_NUMERALBASES_OPTION_FROM, 2)]),
    MultiDecoderToolEntity(i18n(context, MDT_INTERNALNAMES_NUMERALBASES), MDT_INTERNALNAMES_NUMERALBASES,
        options: [MultiDecoderToolOption(MDT_NUMERALBASES_OPTION_FROM, 3)]),
    MultiDecoderToolEntity(i18n(context, MDT_INTERNALNAMES_NUMERALBASES), MDT_INTERNALNAMES_NUMERALBASES,
        options: [MultiDecoderToolOption(MDT_NUMERALBASES_OPTION_FROM, 8)]),
    MultiDecoderToolEntity(i18n(context, MDT_INTERNALNAMES_NUMERALBASES), MDT_INTERNALNAMES_NUMERALBASES,
        options: [MultiDecoderToolOption(MDT_NUMERALBASES_OPTION_FROM, 16)]),
    MultiDecoderToolEntity(i18n(context, MDT_INTERNALNAMES_BASE), MDT_INTERNALNAMES_BASE,
        options: [MultiDecoderToolOption(MDT_BASE_OPTION_BASEFUNCTION, 'base_base16')]),
    MultiDecoderToolEntity(i18n(context, MDT_INTERNALNAMES_BASE), MDT_INTERNALNAMES_BASE,
        options: [MultiDecoderToolOption(MDT_BASE_OPTION_BASEFUNCTION, 'base_base32')]),
    MultiDecoderToolEntity(i18n(context, MDT_INTERNALNAMES_BASE), MDT_INTERNALNAMES_BASE,
        options: [MultiDecoderToolOption(MDT_BASE_OPTION_BASEFUNCTION, 'base_base64')]),
    MultiDecoderToolEntity(i18n(context, MDT_INTERNALNAMES_BASE), MDT_INTERNALNAMES_BASE,
        options: [MultiDecoderToolOption(MDT_BASE_OPTION_BASEFUNCTION, 'base_base85')]),
    MultiDecoderToolEntity(i18n(context, MDT_INTERNALNAMES_COORDINATEFORMATS), MDT_INTERNALNAMES_COORDINATEFORMATS,
        options: [
          MultiDecoderToolOption(MDT_COORDINATEFORMATS_OPTION_FORMAT,
              coordinateFormatDefinitionByKey(CoordinateFormatKey.UTM).persistenceKey)
        ]),
    MultiDecoderToolEntity(i18n(context, MDT_INTERNALNAMES_COORDINATEFORMATS), MDT_INTERNALNAMES_COORDINATEFORMATS,
        options: [
          MultiDecoderToolOption(MDT_COORDINATEFORMATS_OPTION_FORMAT,
              coordinateFormatDefinitionByKey(CoordinateFormatKey.MGRS).persistenceKey)
        ]),
    MultiDecoderToolEntity(i18n(context, MDT_INTERNALNAMES_COORDINATEFORMATS), MDT_INTERNALNAMES_COORDINATEFORMATS,
        options: [
          MultiDecoderToolOption(MDT_COORDINATEFORMATS_OPTION_FORMAT,
              coordinateFormatDefinitionByKey(CoordinateFormatKey.XYZ).persistenceKey)
        ]),
    MultiDecoderToolEntity(i18n(context, MDT_INTERNALNAMES_COORDINATEFORMATS), MDT_INTERNALNAMES_COORDINATEFORMATS,
        options: [
          MultiDecoderToolOption(MDT_COORDINATEFORMATS_OPTION_FORMAT,
              coordinateFormatDefinitionByKey(CoordinateFormatKey.MAIDENHEAD).persistenceKey)
        ]),
    MultiDecoderToolEntity(i18n(context, MDT_INTERNALNAMES_COORDINATEFORMATS), MDT_INTERNALNAMES_COORDINATEFORMATS,
        options: [
          MultiDecoderToolOption(MDT_COORDINATEFORMATS_OPTION_FORMAT,
              coordinateFormatDefinitionByKey(CoordinateFormatKey.NATURAL_AREA_CODE).persistenceKey)
        ]),
    MultiDecoderToolEntity(i18n(context, MDT_INTERNALNAMES_COORDINATEFORMATS), MDT_INTERNALNAMES_COORDINATEFORMATS,
        options: [
          MultiDecoderToolOption(MDT_COORDINATEFORMATS_OPTION_FORMAT,
              coordinateFormatDefinitionByKey(CoordinateFormatKey.LAMBERT).persistenceKey)
        ]),
    MultiDecoderToolEntity(i18n(context, MDT_INTERNALNAMES_COORDINATEFORMATS), MDT_INTERNALNAMES_COORDINATEFORMATS,
        options: [
          MultiDecoderToolOption(MDT_COORDINATEFORMATS_OPTION_FORMAT,
              coordinateFormatDefinitionByKey(CoordinateFormatKey.GEOHEX).persistenceKey)
        ]),
    MultiDecoderToolEntity(i18n(context, MDT_INTERNALNAMES_COORDINATEFORMATS), MDT_INTERNALNAMES_COORDINATEFORMATS,
        options: [
          MultiDecoderToolOption(MDT_COORDINATEFORMATS_OPTION_FORMAT,
              coordinateFormatDefinitionByKey(CoordinateFormatKey.GEO3X3).persistenceKey)
        ]),
    MultiDecoderToolEntity(i18n(context, MDT_INTERNALNAMES_COORDINATEFORMATS), MDT_INTERNALNAMES_COORDINATEFORMATS,
        options: [
          MultiDecoderToolOption(MDT_COORDINATEFORMATS_OPTION_FORMAT,
              coordinateFormatDefinitionByKey(CoordinateFormatKey.MAKANEY).persistenceKey)
        ]),
    MultiDecoderToolEntity(i18n(context, MDT_INTERNALNAMES_COORDINATEFORMATS), MDT_INTERNALNAMES_COORDINATEFORMATS,
        options: [
          MultiDecoderToolOption(MDT_COORDINATEFORMATS_OPTION_FORMAT,
              coordinateFormatDefinitionByKey(CoordinateFormatKey.OPEN_LOCATION_CODE).persistenceKey)
        ]),
    MultiDecoderToolEntity(i18n(context, MDT_INTERNALNAMES_COORDINATEFORMATS), MDT_INTERNALNAMES_COORDINATEFORMATS,
        options: [
          MultiDecoderToolOption(MDT_COORDINATEFORMATS_OPTION_FORMAT,
              coordinateFormatDefinitionByKey(CoordinateFormatKey.QUADTREE).persistenceKey)
        ]),
    MultiDecoderToolEntity(i18n(context, MDT_INTERNALNAMES_COORDINATEFORMATS), MDT_INTERNALNAMES_COORDINATEFORMATS,
        options: [
          MultiDecoderToolOption(MDT_COORDINATEFORMATS_OPTION_FORMAT,
              coordinateFormatDefinitionByKey(CoordinateFormatKey.REVERSE_WIG_WALDMEISTER).persistenceKey)
        ]),
    MultiDecoderToolEntity(i18n(context, MDT_INTERNALNAMES_COORDINATEFORMATS), MDT_INTERNALNAMES_COORDINATEFORMATS,
        options: [
          MultiDecoderToolOption(MDT_COORDINATEFORMATS_OPTION_FORMAT,
              coordinateFormatDefinitionByKey(CoordinateFormatKey.REVERSE_WIG_DAY1976).persistenceKey)
        ]),
    MultiDecoderToolEntity(i18n(context, MDT_INTERNALNAMES_COORDINATEFORMATS), MDT_INTERNALNAMES_COORDINATEFORMATS,
        options: [
          MultiDecoderToolOption(MDT_COORDINATEFORMATS_OPTION_FORMAT,
              coordinateFormatDefinitionByKey(CoordinateFormatKey.REVERSE_WIG_10Y_WALDMEISTER).persistenceKey)
        ]),
    MultiDecoderToolEntity(i18n(context, MDT_INTERNALNAMES_COORDINATEFORMATS), MDT_INTERNALNAMES_COORDINATEFORMATS,
        options: [
          MultiDecoderToolOption(MDT_COORDINATEFORMATS_OPTION_FORMAT,
              coordinateFormatDefinitionByKey(CoordinateFormatKey.BOSCH).persistenceKey)
        ]),
    MultiDecoderToolEntity(i18n(context, MDT_INTERNALNAMES_COORDINATEFORMATS), MDT_INTERNALNAMES_COORDINATEFORMATS,
        options: [
          MultiDecoderToolOption(MDT_COORDINATEFORMATS_OPTION_FORMAT,
              coordinateFormatDefinitionByKey(CoordinateFormatKey.GARS).persistenceKey)
        ]),
    MultiDecoderToolEntity(i18n(context, MDT_INTERNALNAMES_COORDINATEFORMATS), MDT_INTERNALNAMES_COORDINATEFORMATS,
        options: [
          MultiDecoderToolOption(MDT_COORDINATEFORMATS_OPTION_FORMAT,
              coordinateFormatDefinitionByKey(CoordinateFormatKey.S2CELLS_HILBERT).persistenceKey)
        ]),
    MultiDecoderToolEntity(i18n(context, MDT_INTERNALNAMES_VIGENERE), MDT_INTERNALNAMES_VIGENERE),
    MultiDecoderToolEntity(i18n(context, MDT_INTERNALNAMES_PLAYFAIR), MDT_INTERNALNAMES_PLAYFAIR),
    MultiDecoderToolEntity(i18n(context, MDT_INTERNALNAMES_POLYBIOS), MDT_INTERNALNAMES_POLYBIOS),
    MultiDecoderToolEntity(i18n(context, MDT_INTERNALNAMES_TAPIR), MDT_INTERNALNAMES_TAPIR),
    MultiDecoderToolEntity(i18n(context, MDT_INTERNALNAMES_POKEMON), MDT_INTERNALNAMES_POKEMON),
    MultiDecoderToolEntity(i18n(context, MDT_INTERNALNAMES_KEYBOARDNUMBERS), MDT_INTERNALNAMES_KEYBOARDNUMBERS),
    MultiDecoderToolEntity(i18n(context, MDT_INTERNALNAMES_ENCLOSEDAREAS), MDT_INTERNALNAMES_ENCLOSEDAREAS),
    MultiDecoderToolEntity(i18n(context, MDT_INTERNALNAMES_GCCODE), MDT_INTERNALNAMES_GCCODE,
        options: [MultiDecoderToolOption(MDT_GCCODE_OPTION_MODE, MDT_GCCODE_OPTION_MODE_IDTOGCCODE)]),
    MultiDecoderToolEntity(i18n(context, MDT_INTERNALNAMES_GCCODE), MDT_INTERNALNAMES_GCCODE,
        options: [MultiDecoderToolOption(MDT_GCCODE_OPTION_MODE, MDT_GCCODE_OPTION_MODE_GCCODETOID)]),
    MultiDecoderToolEntity(i18n(context, MDT_INTERNALNAMES_SEGMENTDISPLAY), MDT_INTERNALNAMES_SEGMENTDISPLAY,
        options: [MultiDecoderToolOption(MDT_SEGMENTDISPLAY_OPTION_NUMBERSEGMENTS, 7)]),
    MultiDecoderToolEntity(i18n(context, MDT_INTERNALNAMES_SEGMENTDISPLAY), MDT_INTERNALNAMES_SEGMENTDISPLAY,
        options: [MultiDecoderToolOption(MDT_SEGMENTDISPLAY_OPTION_NUMBERSEGMENTS, 14)]),
    MultiDecoderToolEntity(i18n(context, MDT_INTERNALNAMES_SEGMENTDISPLAY), MDT_INTERNALNAMES_SEGMENTDISPLAY,
        options: [MultiDecoderToolOption(MDT_SEGMENTDISPLAY_OPTION_NUMBERSEGMENTS, 16)]),
    MultiDecoderToolEntity(i18n(context, MDT_INTERNALNAMES_WASD), MDT_INTERNALNAMES_WASD),
    MultiDecoderToolEntity(i18n(context, MDT_INTERNALNAMES_BEGHILOS), MDT_INTERNALNAMES_BEGHILOS),
    MultiDecoderToolEntity(i18n(context, MDT_INTERNALNAMES_ONETIMEPAD), MDT_INTERNALNAMES_ONETIMEPAD),
    MultiDecoderToolEntity(i18n(context, MDT_INTERNALNAMES_KENNY), MDT_INTERNALNAMES_KENNY),
    MultiDecoderToolEntity(i18n(context, MDT_INTERNALNAMES_RAGBABY), MDT_INTERNALNAMES_RAGBABY,
        options: [MultiDecoderToolOption(MDT_RAGBABY_OPTION_MODE, 'ragbaby_option_24')]),
    MultiDecoderToolEntity(i18n(context, MDT_INTERNALNAMES_BINARY2IMAGE), MDT_INTERNALNAMES_BINARY2IMAGE),
    MultiDecoderToolEntity(i18n(context, MDT_INTERNALNAMES_BRAILLE_DOT_NUMBERS), MDT_INTERNALNAMES_BRAILLE_DOT_NUMBERS),
    MultiDecoderToolEntity(i18n(context, MDT_INTERNALNAMES_BACON), MDT_INTERNALNAMES_BACON,
        options: [MultiDecoderToolOption(MDT_BACON_OPTION_MODE, MDT_BACON_OPTION_MODE_AB)]),
    MultiDecoderToolEntity(i18n(context, MDT_INTERNALNAMES_BACON), MDT_INTERNALNAMES_BACON,
        options: [MultiDecoderToolOption(MDT_BACON_OPTION_MODE, MDT_BACON_OPTION_MODE_01)]),
    MultiDecoderToolEntity(i18n(context, MDT_INTERNALNAMES_BCD), MDT_INTERNALNAMES_BCD,
        options: [MultiDecoderToolOption(MDT_BCD_OPTION_BCDFUNCTION, 'bcd_original')]),
    MultiDecoderToolEntity(i18n(context, MDT_INTERNALNAMES_CCITT1), MDT_INTERNALNAMES_CCITT1),
    MultiDecoderToolEntity(i18n(context, MDT_INTERNALNAMES_CCITT2), MDT_INTERNALNAMES_CCITT2),
    MultiDecoderToolEntity(i18n(context, MDT_INTERNALNAMES_KEYBOARDLAYOUT), MDT_INTERNALNAMES_KEYBOARDLAYOUT),
    MultiDecoderToolEntity(
        i18n(context, MDT_INTERNALNAMES_ESOTERIC_LANGUAGE_BEATNIK), MDT_INTERNALNAMES_ESOTERIC_LANGUAGE_BEATNIK),
    MultiDecoderToolEntity(i18n(context, MDT_INTERNALNAMES_ESOTERIC_LANGUAGE_BRAINFK_DERIVATIVE),
        MDT_INTERNALNAMES_ESOTERIC_LANGUAGE_BRAINFK_DERIVATIVE),
    MultiDecoderToolEntity(
        i18n(context, MDT_INTERNALNAMES_ESOTERIC_LANGUAGE_CHEF), MDT_INTERNALNAMES_ESOTERIC_LANGUAGE_CHEF),
    MultiDecoderToolEntity(
        i18n(context, MDT_INTERNALNAMES_ESOTERIC_LANGUAGE_COW), MDT_INTERNALNAMES_ESOTERIC_LANGUAGE_COW),
    MultiDecoderToolEntity(
        i18n(context, MDT_INTERNALNAMES_ESOTERIC_LANGUAGE_DEADFISH), MDT_INTERNALNAMES_ESOTERIC_LANGUAGE_DEADFISH),
    MultiDecoderToolEntity(
        i18n(context, MDT_INTERNALNAMES_ESOTERIC_LANGUAGE_HOHOHO), MDT_INTERNALNAMES_ESOTERIC_LANGUAGE_HOHOHO),
    MultiDecoderToolEntity(i18n(context, MDT_INTERNALNAMES_ESOTERIC_LANGUAGE_KAROL_ROBOT),
        MDT_INTERNALNAMES_ESOTERIC_LANGUAGE_KAROL_ROBOT),
    MultiDecoderToolEntity(
        i18n(context, MDT_INTERNALNAMES_ESOTERIC_LANGUAGE_MALBOLGE), MDT_INTERNALNAMES_ESOTERIC_LANGUAGE_MALBOLGE),
    MultiDecoderToolEntity(
        i18n(context, MDT_INTERNALNAMES_ESOTERIC_LANGUAGE_WHITESPACE), MDT_INTERNALNAMES_ESOTERIC_LANGUAGE_WHITESPACE),
  ];

  for (int i = 25; i >= 1; i--) {
    newTools.insert(
        0,
        MultiDecoderToolEntity(i18n(context, MDT_INTERNALNAMES_ROTATION), MDT_INTERNALNAMES_ROTATION,
            options: [MultiDecoderToolOption(MDT_ROTATION_OPTION_KEY, i)]));
  }

  for (var tool in newTools.reversed) {
    insertMultiDecoderTool(tool);
  }
}
