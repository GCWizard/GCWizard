import 'package:flutter/material.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/base/_common/logic/base.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/base/_common/widget/base.dart';

class Base85 extends AbstractBase {
  const Base85({Key? key}) : super(key: key, encode: encodeBase85, decode: decodeBase85);
}
