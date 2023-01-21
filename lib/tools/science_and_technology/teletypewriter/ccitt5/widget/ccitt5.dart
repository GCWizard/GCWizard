import 'package:flutter/material.dart';
import 'package:gc_wizard/tools/science_and_technology/teletypewriter/logic/teletypewriter.dart';
import 'package:gc_wizard/tools/science_and_technology/teletypewriter/teletypewriter/widget/teletypewriter.dart';

class CCITT5 extends Teletypewriter {
  CCITT5({Key key}) : super(key: key, defaultCodebook: TeletypewriterCodebook.CCITT_IA5, codebook: null);
}