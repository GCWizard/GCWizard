import 'package:gc_wizard/tools/science_and_technology/teletypewriter/_common/logic/teletypewriter.dart';
import 'package:gc_wizard/tools/science_and_technology/teletypewriter/teletypewriter/widget/teletypewriter.dart';

class OtherTeletypewriter extends Teletypewriter {
  const OtherTeletypewriter({super.key})
      : super(defaultCodebook: TeletypewriterCodebook.ILLIAC, codebook: OTHER_CODEBOOK);
}
