part of 'package:gc_wizard/tools/general_tools/gcwizardscript/logic/gcwizard_script.dart';

String _base(Object t, Object m, Object x) {
  if (_isNotAInt(t) || !_isANumber(m)) {
    _handleError(_INVALIDTYPECAST);
    return '';
  }
  switch (t as int) {
    case 16:
      if (m == 0) {
        return decodeBase16(x.toString());
      } else {
        return encodeBase16(x.toString());
      }
    case 32:
      if (m == 0) {
        return decodeBase32(x.toString());
      } else {
        return encodeBase32(x.toString());
      }
    case 58:
      if (m == 0) {
        return decodeBase58(x.toString());
      } else {
        return encodeBase58(x.toString());
      }
    case 64:
      if (m == 0) {
        return decodeBase64(x.toString());
      } else {
        return encodeBase64(x.toString());
      }
    case 85:
      if (m == 0) {
        return decodeBase85(x.toString());
      } else {
        return encodeBase85(x.toString());
      }
    case 91:
      if (m == 0) {
        return decodeBase91(x.toString());
      } else {
        return encodeBase91(x.toString());
      }
    case 122:
      if (m == 0) {
        return decodeBase122(x.toString());
      } else {
        return encodeBase122(x.toString());
      }
    default:
      _handleError(_INVALIDBASETYPE);
      return '';
  }
}
