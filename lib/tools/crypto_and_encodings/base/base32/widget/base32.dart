import 'package:flutter/material.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/base/_common/logic/base.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/base/_common/widget/base.dart';

class Base32 extends AbstractBase {
  const Base32({Key? key}) : super(key: key, encode: encodeBase32, decode: decodeBase32);
}
