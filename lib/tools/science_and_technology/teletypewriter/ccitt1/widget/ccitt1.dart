import 'package:gc_wizard/tools/science_and_technology/teletypewriter/_common/logic/teletypewriter.dart';
import 'package:gc_wizard/tools/science_and_technology/teletypewriter/teletypewriter/widget/teletypewriter.dart';

class CCITT1 extends Teletypewriter {
  const CCITT1({super.key})
      : super(defaultCodebook: TeletypewriterCodebook.CCITT_ITA1_1929, codebook: CCITT1_CODEBOOK);
}
