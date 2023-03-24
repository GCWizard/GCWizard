import 'dart:math';

import 'package:gc_wizard/tools/crypto_and_encodings/bundeswehr_talkingboard/bundeswehr_auth/logic/bundeswehr_auth.dart';
import 'package:gc_wizard/utils/constants.dart';

const BUNDESWEHR_TALKINGBOARD_CODE_RESPONSE_OK = 'bundeswehr_talkingboard_auth_response_ok';

class BundeswehrTalkingBoardCodingOutput {
  final String ResponseCode;
  final String Details;

  BundeswehrTalkingBoardCodingOutput({required this.ResponseCode, required this.Details});
}

BundeswehrTalkingBoardCodingOutput encodeBundeswehr(
    String plainText, BundeswehrTalkingBoardAuthentificationTable tableEncoding) {
  if (tableEncoding.Encoding!.isEmpty) {
    return BundeswehrTalkingBoardCodingOutput(
        ResponseCode: BUNDESWEHR_TALKINGBOARD_AUTH_RESPONSE_EMPTY_CUSTOM_NUMERAL_TABLE, Details: '');
  }

  if (plainText.isEmpty) {
    return BundeswehrTalkingBoardCodingOutput(ResponseCode: BUNDESWEHR_TALKINGBOARD_CODE_RESPONSE_OK, Details: '');
  }

  plainText = plainText.toUpperCase();

  List<String> result = [];
  var random = Random();
  plainText.split('').forEach((char) {
    if (random.nextInt(100) > 75) {
      result.add(_getObfuscatedTupel(tableEncoding));
    }
    result.add(tableEncoding.Encoding![char]![random.nextInt(tableEncoding.Encoding![char]!.length)]);
  });
  return BundeswehrTalkingBoardCodingOutput(
      ResponseCode: BUNDESWEHR_TALKINGBOARD_CODE_RESPONSE_OK, Details: result.join(' '));
}

BundeswehrTalkingBoardCodingOutput decodeBundeswehr(
    String cypherText, BundeswehrTalkingBoardAuthentificationTable tableNumeralCode) {
  if (tableNumeralCode.Content.isEmpty) {
    return BundeswehrTalkingBoardCodingOutput(
        ResponseCode: BUNDESWEHR_TALKINGBOARD_AUTH_RESPONSE_EMPTY_CUSTOM_NUMERAL_TABLE, Details: '');
  }

  String result = '';

  if (cypherText.isEmpty) {
    return BundeswehrTalkingBoardCodingOutput(ResponseCode: BUNDESWEHR_TALKINGBOARD_CODE_RESPONSE_OK, Details: result);
  }

  cypherText = cypherText.toUpperCase();

  cypherText.split(' ').forEach((pair) {
    if (pair.length == 2) {
      result = result + _decodeNumeralCode(pair, tableNumeralCode);
    } else {
      result = result + UNKNOWN_ELEMENT;
    }
  });
  return BundeswehrTalkingBoardCodingOutput(ResponseCode: BUNDESWEHR_TALKINGBOARD_CODE_RESPONSE_OK, Details: result);
}

String _decodeNumeralCode(String tupel, BundeswehrTalkingBoardAuthentificationTable tableNumeralCode) {
  int index = 0;
  if (tableNumeralCode.xAxis.contains(tupel[1])) {
    tupel = tupel[1] + tupel[0];
  }
  if ((tableNumeralCode.xAxis.contains(tupel[0]) && tableNumeralCode.xAxis.contains(tupel[1])) ||
      (tableNumeralCode.yAxis.contains(tupel[0]) && tableNumeralCode.yAxis.contains(tupel[1]))) {
    index = -1;
  } else {
    index = tableNumeralCode.xAxis.indexOf(tupel[0]) + 13 * tableNumeralCode.yAxis.indexOf(tupel[1]);
  }

  if (0 < index && index < 169) {
    return tableNumeralCode.Content[index];
  } else {
    return '';
  }
}

String _getObfuscatedTupel(BundeswehrTalkingBoardAuthentificationTable tableNumeralCode) {
  var random = Random();
  if (random.nextInt(100) > 50) {
    return tableNumeralCode.yAxis[random.nextInt(13)] + tableNumeralCode.yAxis[random.nextInt(13)];
  } else {
    return tableNumeralCode.xAxis[random.nextInt(13)] + tableNumeralCode.xAxis[random.nextInt(13)];
  }
}
