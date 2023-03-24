import 'package:flutter/material.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/bcd/_common/logic/bcd.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/bcd/_common/widget/bcd.dart';

class BCD2of5Postnet extends AbstractBCD {
  const BCD2of5Postnet({Key? key}) : super(key: key, type: BCDType.POSTNET);
}
