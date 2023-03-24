import 'package:flutter/material.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/base/_common/logic/base.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/base/_common/widget/base.dart';

class Base58 extends AbstractBase {
  const Base58({Key? key}) : super(key: key, encode: encodeBase58, decode: decodeBase58);
}
