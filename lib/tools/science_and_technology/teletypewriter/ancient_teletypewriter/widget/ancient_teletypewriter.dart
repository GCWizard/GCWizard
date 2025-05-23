import 'package:gc_wizard/tools/science_and_technology/teletypewriter/_common/logic/teletypewriter.dart';
import 'package:gc_wizard/tools/science_and_technology/teletypewriter/teletypewriter/widget/teletypewriter.dart';

class AncientTeletypewriter extends Teletypewriter {
  const AncientTeletypewriter({super.key})
      : super(defaultCodebook: TeletypewriterCodebook.BAUDOT_12345, codebook: ANCIENT_CODEBOOK);
}
