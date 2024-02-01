// https://www.history.navy.mil/research/library/online-reading-room/title-list-alphabetically/n/navajo-code-talker-dictionary.html
// https://www.ancestrycdn.com/aa-k12/1112/assets/Navajo-Code-Talkers-dictionary.pdf

import 'dart:math';

import 'package:gc_wizard/utils/collection_utils.dart';
import 'package:gc_wizard/utils/constants.dart';

part 'package:gc_wizard/tools/crypto_and_encodings/navajo/logic/navajo_dictionary.dart';

Map<String, String> _addSpecialEntries(Map<String, String> source, Map<String, String> special) {
  source.addAll(special);
  return source;
}

String _shrinkText(String input) {
  return input
      .replaceAll('COMMANDING GEN.', 'COMMANDINGGEN')
      .replaceAll('MAJOR GEN.', 'MAJORGEN')
      .replaceAll('BRIGADIER GEN.', 'BRIGADIERGEN')
      .replaceAll('LT. COLONEL', 'LTCOLONEL')
      .replaceAll('COMMANDING OFFICER', 'COMMANDINGOFFICER')
      .replaceAll('EXECUTIVE OFFICER', 'EXECUTIVEOFFICER')
      .replaceAll('SOUTH AMERICA', 'SOUTHAMERICA')
      .replaceAll('DIVE BOMBER', 'DIVEBOMBER')
      .replaceAll('TORPEDO PLANE', 'TORPEDOPLANE')
      .replaceAll('OBS. PLAN', 'OBSPLAN')
      .replaceAll('FIGHTER PLANE', 'FIGHTERPLANE')
      .replaceAll('BOMBER PLANE', 'BOMBERPLANE')
      .replaceAll('PATROL PLANE', 'PATROLPLANE')
      .replaceAll('MINE SWEEPER', 'MINESWEEPER')
      .replaceAll('MOSQUITO BOAT', 'MOSQUITOBOAT')
      .replaceAll('BOOBY TRAP', 'BOOBYTRAP')
      .replaceAll('BULL DOZER', 'BULLDOZER')
      .replaceAll('COAST GUARD', 'COASTGUARD')
      .replaceAll('COUNTER ATTACK ', 'COUNTERATTACK ')
      .replaceAll('DIG IN', 'DIGIN')
      .replaceAll('FLAME THROWER', 'FLAMETHROWER')
      .replaceAll('HALF TRACK', 'HALFTRACK')
      .replaceAll('HIGH EXPLOSIVE', 'HIGHEXPLOSIVE')
      .replaceAll('MACHINE GUN', 'MACHINEGUN')
      .replaceAll('MERCHANT SHIP', 'MERCHANTSHIP')
      .replaceAll('PILL BOX', 'PILLBOX')
      .replaceAll('PINNED DOWN', 'PINNEDDOWN')
      .replaceAll('ROBOT BOMB', 'ROBOTBOMB')
      .replaceAll('SEMI COLON', 'SEMICOLON')
      .replaceAll('SUPPLY SHIP', 'SUPPLYSHIP')
      .replaceAll('TANK DESTROYER', 'TANKDESTROYER')
      .replaceAll('TRAFFIC DIAGRAM', 'TRAFFICDIAGRAM');
}

String _enfoldText(String input) {
  return input
      .replaceAll('COMMANDINGGEN', 'COMMANDING GEN.')
      .replaceAll('MAJORGEN', 'MAJOR GEN.')
      .replaceAll('BRIGADIERGEN', 'BRIGADIER GEN.')
      .replaceAll('LTCOLONEL', 'LT. COLONEL')
      .replaceAll('COMMANDINGOFFICER', 'COMMANDING OFFICER')
      .replaceAll('EXECUTIVEOFFICER', 'EXECUTIVE OFFICER')
      .replaceAll('SOUTHAMERICA', 'SOUTH AMERICA')
      .replaceAll('DIVEBOMBER', 'DIVE BOMBER')
      .replaceAll('TORPEDOPLANE', 'TORPEDO PLANE')
      .replaceAll('OBSPLAN', 'OBS. PLAN')
      .replaceAll('FIGHTERPLANE', 'FIGHTER PLANE')
      .replaceAll('BOMBERPLANE', 'BOMBER PLANE')
      .replaceAll('PATROLPLANE', 'PATROL PLANE')
      .replaceAll('MINESWEEPER', 'MINE SWEEPER')
      .replaceAll('MOSQUITOBOAT', 'MOSQUITO BOAT')
      .replaceAll('BOOBYTRAP', 'BOOBY TRAP')
      .replaceAll('BULLDOZER', 'BULL DOZER')
      .replaceAll('COASTGUARD', 'COAST GUARD')
      .replaceAll('COUNTERATTACK ', 'COUNTER ATTACK ')
      .replaceAll('DIGIN', 'DIG IN')
      .replaceAll('FLAMETHROWER', 'FLAME THROWER')
      .replaceAll('HALFTRACK', 'HALF TRACK')
      .replaceAll('HIGHEXPLOSIVE', 'HIGH EXPLOSIVE')
      .replaceAll('MACHINEGUN', 'MACHINE GUN')
      .replaceAll('MERCHANTSHIP', 'MERCHANT SHIP')
      .replaceAll('PILLBOX', 'PILL BOX')
      .replaceAll('PINNEDDOWN', 'PINNED DOWN')
      .replaceAll('ROBOTBOMB', 'ROBOT BOMB')
      .replaceAll('SEMICOLON', 'SEMI COLON')
      .replaceAll('SUPPLYSHIP', 'SUPPLY SHIP')
      .replaceAll('TANKDESTROYER', 'TANK DESTROYER')
      .replaceAll('TRAFFICDIAGRAM', 'TRAFFIC DIAGRAM');
}

String decodeNavajo(String cipherText, bool useOnlyAlphabet) {
  List<String> result = <String>[];
  if (cipherText.isEmpty) return '';

  cipherText = cipherText.toUpperCase().replaceAll(RegExp(r'\s{3,}'), '  ').replaceAll('.', ' . ').trim();

  cipherText.split('  ').forEach((element) {
    element.split(' ').forEach((element) {
      if (_NAVAJO_DECODE_ALPHABET[element] == null) {
        if (useOnlyAlphabet) {
          result.add(UNKNOWN_ELEMENT);
        } else {
          if (_NAVAJO_DECODE_DICTIONARY[element] == null) {
            result.add(UNKNOWN_ELEMENT);
          } else {
            result.add(_enfoldText(_NAVAJO_DECODE_DICTIONARY[element]!));
            result.add(' ');
          }
        }
      } else {
        result.add(_NAVAJO_DECODE_ALPHABET[element]!);
      }
    });
    result.add(' ');
  });
  return _enfoldText(result.join('').trim());
}

String encodeNavajo(String plainText, bool useOnlyAlphabet) {
  List<String> result = <String>[];
  if (plainText.isEmpty) return '';

  _shrinkText(plainText.toUpperCase()).split(' ').forEach((element) {
    if (useOnlyAlphabet) {
      result.add(encodeLetterWise(element));
    } else if (_NAVAJO_ENCODE_DICTIONARY[element] == null) {
      result.add(encodeLetterWise(element));
    } else {
      result.add(_NAVAJO_ENCODE_DICTIONARY[element]!);
    }
    result.add('');
  });
  return result.join(' ').trim();
}

String encodeLetterWise(String plainText) {
  List<String> result = <String>[];
  plainText.split('').forEach((element) {
    if (_NAVAJO_ENCODE_ALPHABET[element] == null) {
      result.add(element);
    } else {
      result.add(_NAVAJO_ENCODE_ALPHABET[element]![Random().nextInt(_NAVAJO_ENCODE_ALPHABET[element]!.length)]);
    }
  });
  return result.join(' ');
}
