part of 'package:gc_wizard/tools/science_and_technology/uic_wagoncode/logic/uic_wagoncode.dart';

class UICWagonCodeWagon extends UICWagonCode {
  late final String interoperabilityCode;

  UICWagonCodeWagon(String number) : super(number) {
    interoperabilityCode = _getInteroperabilityCode(number);
  }

  String _getInteroperabilityCode(String number) {
    return number.substring(0, 2);
  }
}