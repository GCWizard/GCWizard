import 'package:flutter/material.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/base/_common/logic/base.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/base/_common/widget/base.dart';

class Base64 extends AbstractBase {
  const Base64({Key? key}) : super(key: key, encode: encodeBase64, decode: decodeBase64);
}
