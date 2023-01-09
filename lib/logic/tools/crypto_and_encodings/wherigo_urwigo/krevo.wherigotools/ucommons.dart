import 'dart:math';

/*
 * Port from https://github.com/Krevo/WherigoTools/blob/master/ucommons.php
 *
 * MIT License
 */

/*
* Urwhigo.Hash() is in fact a variant of the Robert Sedgewick's Hash Algorithm
*/
int RSHash(String string) {
  var a = 63689;
  var b = 378551;
  var hash = 0;

  for (var i = 0; i < string.length; i++) {
    hash = hash * a + string.codeUnits[i];
    hash = hash % 65535;
    a = a * b;
    a = a % 65535;
  }

  return hash;
}

// ML (10/2022): originally called convBase
String urwigoConvBase(int numberInput, String fromBaseInput, String toBaseInput) {
  var toBase = toBaseInput.split('').toList();
  var toLen = toBaseInput.length;
  var retval = '';
  var base10 = numberInput;

  if (base10 < toBaseInput.length) return toBase[base10];

  while (base10 != 0) {
    retval = toBase[base10 % toLen] + retval;
    base10 = base10 ~/ toLen;
  }

  return retval;
}

/*
  This function will yield collisions for the desired hash
*/
String findHash(int hashToFind, int len) {
  var max = pow(26, len);
  for (var i = 0; i < max; i++) {
    var s = urwigoConvBase(i, '0123456789', 'abcdefghijklmnopqrstuvwxyz').padLeft(len, 'a');

    if (RSHash(s) == hashToFind) {
      return s;
    }
  }

  return null;
}
