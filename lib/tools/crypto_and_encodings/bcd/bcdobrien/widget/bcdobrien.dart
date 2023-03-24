import 'package:flutter/material.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/bcd/_common/logic/bcd.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/bcd/_common/widget/bcd.dart';

class BCDOBrien extends AbstractBCD {
  const BCDOBrien({Key? key})
      : super(
          key: key,
          type: BCDType.OBRIEN,
        );
}
