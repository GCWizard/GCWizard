import 'package:flutter/material.dart';
import 'package:gc_wizard/tools/science_and_technology/teletypewriter/_common/logic/teletypewriter.dart';
import 'package:gc_wizard/tools/science_and_technology/teletypewriter/teletypewriter/widget/teletypewriter.dart';

class CCITT2 extends Teletypewriter {
  CCITT2({Key key})
      : super(key: key, defaultCodebook: TeletypewriterCodebook.CCITT_ITA2_1931, codebook: CCITT2_CODEBOOK);
}
