import 'package:flutter/material.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/rotation/logic/rotator.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/rotation/widget/base_rot.dart';

class Rot13 extends AbstractRotation {
  Rot13({Key key}) : super(key: key, rotate: Rotator().rot13);
}
