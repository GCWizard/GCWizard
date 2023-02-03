import 'package:flutter/material.dart';
import 'package:gc_wizard/tools/science_and_technology/teletypewriter/_common/logic/teletypewriter.dart';
import 'package:gc_wizard/tools/science_and_technology/teletypewriter/teletypewriter/widget/teletypewriter.dart';

class CCITTTeletypewriter extends Teletypewriter {
  CCITTTeletypewriter({Key key})
      : super(key: key, defaultCodebook: TeletypewriterCodebook.CCITT_ITA1_1929, codebook: CCITT_CODEBOOK);
}
