import 'package:gc_wizard/tools/crypto_and_encodings/bcd/_common/logic/bcd.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/bcd/_common/widget/bcd.dart';

class BCDTompkins extends AbstractBCD {
  const BCDTompkins({super.key})
      : super(
          type: BCDType.TOMPKINS,
        );
}
