import 'package:flutter/material.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/base/_common/logic/base.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/base/_common/widget/base.dart';

class Base122 extends AbstractBase {
  Base122({Key key}) : super(key: key, encode: encodeBase122, decode: decodeBase122);
}
