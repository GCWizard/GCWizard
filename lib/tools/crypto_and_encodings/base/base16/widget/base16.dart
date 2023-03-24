import 'package:flutter/material.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/base/_common/logic/base.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/base/_common/widget/base.dart';

class Base16 extends AbstractBase {
  const Base16({Key? key}) : super(key: key, encode: encodeBase16, decode: decodeBase16);
}
