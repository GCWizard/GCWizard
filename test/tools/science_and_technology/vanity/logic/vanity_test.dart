import 'package:flutter_test/flutter_test.dart';
import 'package:gc_wizard/tools/science_and_technology/vanity/_common/logic/phone_models.dart';
import 'package:gc_wizard/tools/science_and_technology/vanity/_common/logic/vanity.dart';

void main() {
  group("Vanity.decodeVanityMultitap:", () {
    List<Map<String, dynamic>> _inputsToExpected = [
      {'model': phoneModelByName(NAME_PHONEMODEL_NOKIA_6230), 'language': PhoneInputLanguage.GERMAN, 'input' : null, 'expectedOutput' : {'mode': PhoneCaseMode.CAMEL_CASE, 'output': ''}},
      {'model': phoneModelByName(NAME_PHONEMODEL_NOKIA_6230), 'language': PhoneInputLanguage.GERMAN, 'input' : '', 'expectedOutput' : {'mode': PhoneCaseMode.CAMEL_CASE, 'output': ''}},

      {'model': PHONEMODEL_SIMPLE_SPACE_0, 'language': PhoneInputLanguage.UNSPECIFIED, 'input' : '222 9999999 00 0 11 111 8888', 'expectedOutput' : {'mode': PhoneCaseMode.UPPER_CASE, 'output': 'CX0 111118'}},
      {'model': PHONEMODEL_SIMPLE_SPACE_0, 'language': PhoneInputLanguage.UNSPECIFIED, 'input' : '* 222 9999999 ## 00 0 11 111 8888 abc', 'expectedOutput' : {'mode': PhoneCaseMode.UPPER_CASE, 'output': 'CX0 111118'}},
      {'model': PHONEMODEL_SIMPLE_SPACE_1, 'language': PhoneInputLanguage.UNSPECIFIED, 'input' : '222 9999999 00 0 11 111 8888', 'expectedOutput' : {'mode': PhoneCaseMode.UPPER_CASE, 'output': 'CX0001 8'}},
      {'model': PHONEMODEL_SIMPLE_SPACE_1, 'language': PhoneInputLanguage.UNSPECIFIED, 'input' : '* 222 9999999 ## 00 0 11 111 8888 abc', 'expectedOutput' : {'mode': PhoneCaseMode.UPPER_CASE, 'output': 'CX0001 8'}},
      {'model': PHONEMODEL_SIMPLE_SPACE_HASH, 'language': PhoneInputLanguage.UNSPECIFIED, 'input' : '222 9999999 00 0 11 111 8888', 'expectedOutput' : {'mode': PhoneCaseMode.UPPER_CASE, 'output': 'CX000111118'}},
      {'model': PHONEMODEL_SIMPLE_SPACE_HASH, 'language': PhoneInputLanguage.UNSPECIFIED, 'input' : '* 222 9999999 ## 00 0 11 111 8888 abc', 'expectedOutput' : {'mode': PhoneCaseMode.UPPER_CASE, 'output': 'CX  000111118'}},

      {'model': phoneModelByName(NAME_PHONEMODEL_NOKIA_6230), 'language': PhoneInputLanguage.GERMAN, 'input' : '2', 'expectedOutput' : {'mode': PhoneCaseMode.LOWER_CASE, 'output': 'A'}},
      {'model': phoneModelByName(NAME_PHONEMODEL_NOKIA_6230), 'language': PhoneInputLanguage.GERMAN, 'input' : '2 22 222 99 999 9999', 'expectedOutput' : {'mode': PhoneCaseMode.LOWER_CASE, 'output': 'Abcxyz'}},
      {'model': phoneModelByName(NAME_PHONEMODEL_NOKIA_6230), 'language': PhoneInputLanguage.GERMAN, 'input' : '2 22 222 1111111 2222 3333 99 999 9999', 'expectedOutput' : {'mode': PhoneCaseMode.LOWER_CASE, 'output': 'Abc123xyz'}},
      {'model': phoneModelByName(NAME_PHONEMODEL_NOKIA_6230), 'language': PhoneInputLanguage.GERMAN, 'input' : '2 666 88 7777', 'expectedOutput' : {'mode': PhoneCaseMode.LOWER_CASE, 'output': 'Aous'}},

      {'model': phoneModelByName(NAME_PHONEMODEL_SIEMENS_S55), 'language': PhoneInputLanguage.GERMAN, 'input' : '2 666 88 7777', 'expectedOutput' : {'mode': PhoneCaseMode.LOWER_CASE, 'output': 'Aous'}},
      {'model': phoneModelByName(NAME_PHONEMODEL_SIEMENS_S55), 'language': PhoneInputLanguage.GREEK, 'input' : '2 666 88 7777', 'expectedOutput' : {'mode': PhoneCaseMode.UPPER_CASE, 'output': 'ΑΟΤΨ'}},

      {'model': phoneModelByName(NAME_PHONEMODEL_NOKIA_6230), 'language': PhoneInputLanguage.GERMAN, 'input' : '88888', 'expectedOutput' : {'mode': PhoneCaseMode.LOWER_CASE, 'output': 'Ü'}},
      {'model': phoneModelByName(NAME_PHONEMODEL_NOKIA_6230), 'language': PhoneInputLanguage.ENGLISH, 'input' : '88888888', 'expectedOutput' : {'mode': PhoneCaseMode.LOWER_CASE, 'output': 'Ü'}},

      {'model': phoneModelByName(NAME_PHONEMODEL_SIEMENS_C75), 'language': PhoneInputLanguage.FRENCH, 'input' : '222222', 'expectedOutput' : {'mode': PhoneCaseMode.LOWER_CASE, 'output': 'Æ'}},
      {'model': phoneModelByName(NAME_PHONEMODEL_SIEMENS_C75), 'language': PhoneInputLanguage.FRENCH, 'input' : '2222222', 'expectedOutput' : {'mode': PhoneCaseMode.LOWER_CASE, 'output': 'Å'}},
      {'model': phoneModelByName(NAME_PHONEMODEL_SIEMENS_C75), 'language': PhoneInputLanguage.FRENCH, 'input' : '22222222', 'expectedOutput' : {'mode': PhoneCaseMode.LOWER_CASE, 'output': 'A'}},
      {'model': phoneModelByName(NAME_PHONEMODEL_SIEMENS_C75), 'language': PhoneInputLanguage.FRENCH, 'input' : '222222222', 'expectedOutput' : {'mode': PhoneCaseMode.LOWER_CASE, 'output': 'B'}},
      {'model': phoneModelByName(NAME_PHONEMODEL_SIEMENS_C75), 'language': PhoneInputLanguage.TURKISH, 'input' : '222222', 'expectedOutput' : {'mode': PhoneCaseMode.LOWER_CASE, 'output': 'Â'}},
      {'model': phoneModelByName(NAME_PHONEMODEL_SIEMENS_C75), 'language': PhoneInputLanguage.TURKISH, 'input' : '2222222', 'expectedOutput' : {'mode': PhoneCaseMode.LOWER_CASE, 'output': 'A'}},
      {'model': phoneModelByName(NAME_PHONEMODEL_SIEMENS_C75), 'language': PhoneInputLanguage.TURKISH, 'input' : '22222222', 'expectedOutput' : {'mode': PhoneCaseMode.LOWER_CASE, 'output': 'B'}},
      {'model': phoneModelByName(NAME_PHONEMODEL_SIEMENS_C75), 'language': PhoneInputLanguage.TURKISH, 'input' : '222222222', 'expectedOutput' : {'mode': PhoneCaseMode.LOWER_CASE, 'output': 'C'}},

      {'model': phoneModelByName(NAME_PHONEMODEL_NOKIA_1650), 'language': PhoneInputLanguage.GERMAN, 'input' : '', 'expectedOutput' : {'mode': PhoneCaseMode.CAMEL_CASE, 'output': ''}},
      {'model': phoneModelByName(NAME_PHONEMODEL_NOKIA_1650), 'language': PhoneInputLanguage.GERMAN, 'input' : '222', 'expectedOutput' : {'mode': PhoneCaseMode.LOWER_CASE, 'output': 'C'}},
      {'model': phoneModelByName(NAME_PHONEMODEL_NOKIA_1650), 'language': PhoneInputLanguage.GERMAN, 'input' : '222 333', 'expectedOutput' : {'mode': PhoneCaseMode.LOWER_CASE, 'output': 'Cf'}},
      {'model': phoneModelByName(NAME_PHONEMODEL_NOKIA_1650), 'language': PhoneInputLanguage.GERMAN, 'input' : '222 333 1', 'expectedOutput' : {'mode': PhoneCaseMode.LOWER_CASE, 'output': 'Cf.'}},
      {'model': phoneModelByName(NAME_PHONEMODEL_NOKIA_1650), 'language': PhoneInputLanguage.GERMAN, 'input' : '222 333 1 0', 'expectedOutput' : {'mode': PhoneCaseMode.CAMEL_CASE, 'output': 'Cf. '}},
      {'model': phoneModelByName(NAME_PHONEMODEL_NOKIA_1650), 'language': PhoneInputLanguage.GERMAN, 'input' : '222 333 1 0 44', 'expectedOutput' : {'mode': PhoneCaseMode.LOWER_CASE, 'output': 'Cf. H'}},
      {'model': phoneModelByName(NAME_PHONEMODEL_NOKIA_1650), 'language': PhoneInputLanguage.GERMAN, 'input' : '222 333 1 00 44', 'expectedOutput' : {'mode': PhoneCaseMode.LOWER_CASE, 'output': 'Cf.0h'}},
      {'model': phoneModelByName(NAME_PHONEMODEL_NOKIA_1650), 'language': PhoneInputLanguage.GERMAN, 'input' : '222 333 1 000000 44', 'expectedOutput' : {'mode': PhoneCaseMode.LOWER_CASE, 'output': 'Cf.\nH'}},

      {'model': phoneModelByName(NAME_PHONEMODEL_NOKIA_3210), 'language': PhoneInputLanguage.GERMAN, 'input' : '', 'expectedOutput' : {'mode': PhoneCaseMode.LOWER_CASE, 'output': ''}},
      {'model': phoneModelByName(NAME_PHONEMODEL_NOKIA_3210), 'language': PhoneInputLanguage.GERMAN, 'input' : '222', 'expectedOutput' : {'mode': PhoneCaseMode.LOWER_CASE, 'output': 'c'}},
      {'model': phoneModelByName(NAME_PHONEMODEL_NOKIA_3210), 'language': PhoneInputLanguage.GERMAN, 'input' : '222 333', 'expectedOutput' : {'mode': PhoneCaseMode.LOWER_CASE, 'output': 'cf'}},
      {'model': phoneModelByName(NAME_PHONEMODEL_NOKIA_3210), 'language': PhoneInputLanguage.GERMAN, 'input' : '222 333 1', 'expectedOutput' : {'mode': PhoneCaseMode.LOWER_CASE, 'output': 'cf.'}},
      {'model': phoneModelByName(NAME_PHONEMODEL_NOKIA_3210), 'language': PhoneInputLanguage.GERMAN, 'input' : '222 333 1 0', 'expectedOutput' : {'mode': PhoneCaseMode.LOWER_CASE, 'output': 'cf. '}},
      {'model': phoneModelByName(NAME_PHONEMODEL_NOKIA_3210), 'language': PhoneInputLanguage.GERMAN, 'input' : '222 333 1 0 44', 'expectedOutput' : {'mode': PhoneCaseMode.LOWER_CASE, 'output': 'cf. h'}},
      {'model': phoneModelByName(NAME_PHONEMODEL_NOKIA_3210), 'language': PhoneInputLanguage.GERMAN, 'input' : '222 333 1 00 44', 'expectedOutput' : {'mode': PhoneCaseMode.LOWER_CASE, 'output': 'cf.0h'}},
      {'model': phoneModelByName(NAME_PHONEMODEL_NOKIA_3210), 'language': PhoneInputLanguage.GERMAN, 'input' : '222 333 1 000000 44', 'expectedOutput' : {'mode': PhoneCaseMode.LOWER_CASE, 'output': 'cf.0h'}},

      {'model': phoneModelByName(NAME_PHONEMODEL_SIEMENS_S55), 'language': PhoneInputLanguage.GERMAN, 'input' : '', 'expectedOutput' : {'mode': PhoneCaseMode.CAMEL_CASE, 'output': ''}},
      {'model': phoneModelByName(NAME_PHONEMODEL_SIEMENS_S55), 'language': PhoneInputLanguage.GERMAN, 'input' : '222', 'expectedOutput' : {'mode': PhoneCaseMode.LOWER_CASE, 'output': 'C'}},
      {'model': phoneModelByName(NAME_PHONEMODEL_SIEMENS_S55), 'language': PhoneInputLanguage.GERMAN, 'input' : '222 333', 'expectedOutput' : {'mode': PhoneCaseMode.LOWER_CASE, 'output': 'Cf'}},
      {'model': phoneModelByName(NAME_PHONEMODEL_SIEMENS_S55), 'language': PhoneInputLanguage.GERMAN, 'input' : '222 333 0', 'expectedOutput' : {'mode': PhoneCaseMode.LOWER_CASE, 'output': 'Cf.'}},
      {'model': phoneModelByName(NAME_PHONEMODEL_SIEMENS_S55), 'language': PhoneInputLanguage.GERMAN, 'input' : '222 333 0 1', 'expectedOutput' : {'mode': PhoneCaseMode.CAMEL_CASE, 'output': 'Cf. '}},
      {'model': phoneModelByName(NAME_PHONEMODEL_SIEMENS_S55), 'language': PhoneInputLanguage.GERMAN, 'input' : '222 333 0 1 44', 'expectedOutput' : {'mode': PhoneCaseMode.LOWER_CASE, 'output': 'Cf. H'}},
      {'model': phoneModelByName(NAME_PHONEMODEL_SIEMENS_S55), 'language': PhoneInputLanguage.GERMAN, 'input' : '222 333 00 1 44', 'expectedOutput' : {'mode': PhoneCaseMode.LOWER_CASE, 'output': 'Cf, h'}},
      {'model': phoneModelByName(NAME_PHONEMODEL_SIEMENS_S55), 'language': PhoneInputLanguage.GERMAN, 'input' : '222 333 000 1 44', 'expectedOutput' : {'mode': PhoneCaseMode.LOWER_CASE, 'output': 'Cf? H'}},

      {'model': phoneModelByName(NAME_PHONEMODEL_SIEMENS_S55), 'language': PhoneInputLanguage.GREEK, 'input' : '', 'expectedOutput' : {'mode': PhoneCaseMode.UPPER_CASE, 'output': ''}},
      {'model': phoneModelByName(NAME_PHONEMODEL_SIEMENS_S55), 'language': PhoneInputLanguage.GREEK, 'input' : '222', 'expectedOutput' : {'mode': PhoneCaseMode.UPPER_CASE, 'output': 'C'}},
      {'model': phoneModelByName(NAME_PHONEMODEL_SIEMENS_S55), 'language': PhoneInputLanguage.GREEK, 'input' : '222 333', 'expectedOutput' : {'mode': PhoneCaseMode.UPPER_CASE, 'output': 'CΘ'}},
      {'model': phoneModelByName(NAME_PHONEMODEL_SIEMENS_S55), 'language': PhoneInputLanguage.GREEK, 'input' : '222 333 0', 'expectedOutput' : {'mode': PhoneCaseMode.UPPER_CASE, 'output': 'CΘ.'}},
      {'model': phoneModelByName(NAME_PHONEMODEL_SIEMENS_S55), 'language': PhoneInputLanguage.GREEK, 'input' : '222 333 0 1', 'expectedOutput' : {'mode': PhoneCaseMode.UPPER_CASE, 'output': 'CΘ. '}},
      {'model': phoneModelByName(NAME_PHONEMODEL_SIEMENS_S55), 'language': PhoneInputLanguage.GREEK, 'input' : '222 333 0 1 44', 'expectedOutput' : {'mode': PhoneCaseMode.UPPER_CASE, 'output': 'CΘ. Η'}},
      {'model': phoneModelByName(NAME_PHONEMODEL_SIEMENS_S55), 'language': PhoneInputLanguage.GREEK, 'input' : '222 333 00 1 44', 'expectedOutput' : {'mode': PhoneCaseMode.UPPER_CASE, 'output': 'CΘ, Η'}},
      {'model': phoneModelByName(NAME_PHONEMODEL_SIEMENS_S55), 'language': PhoneInputLanguage.GREEK, 'input' : '222 333 000 1 44', 'expectedOutput' : {'mode': PhoneCaseMode.UPPER_CASE, 'output': 'CΘ? Η'}},

      {'model': phoneModelByName(NAME_PHONEMODEL_NOKIA_1650), 'language': PhoneInputLanguage.GERMAN, 'input' : '', 'expectedOutput' : {'mode': PhoneCaseMode.CAMEL_CASE, 'output': ''}},
      {'model': phoneModelByName(NAME_PHONEMODEL_NOKIA_1650), 'language': PhoneInputLanguage.GERMAN, 'input' : '#', 'expectedOutput' : {'mode': PhoneCaseMode.UPPER_CASE, 'output': ''}},
      {'model': phoneModelByName(NAME_PHONEMODEL_NOKIA_1650), 'language': PhoneInputLanguage.GERMAN, 'input' : '##', 'expectedOutput' : {'mode': PhoneCaseMode.LOWER_CASE, 'output': ''}},
      {'model': phoneModelByName(NAME_PHONEMODEL_NOKIA_1650), 'language': PhoneInputLanguage.GERMAN, 'input' : '# #', 'expectedOutput' : {'mode': PhoneCaseMode.LOWER_CASE, 'output': ''}},
      {'model': phoneModelByName(NAME_PHONEMODEL_NOKIA_1650), 'language': PhoneInputLanguage.GERMAN, 'input' : '# ##', 'expectedOutput' : {'mode': PhoneCaseMode.CAMEL_CASE, 'output': ''}},
      {'model': phoneModelByName(NAME_PHONEMODEL_NOKIA_1650), 'language': PhoneInputLanguage.GERMAN, 'input' : '# 222 333', 'expectedOutput' : {'mode': PhoneCaseMode.UPPER_CASE, 'output': 'CF'}},
      {'model': phoneModelByName(NAME_PHONEMODEL_NOKIA_1650), 'language': PhoneInputLanguage.GERMAN, 'input' : '# # 222 333', 'expectedOutput' : {'mode': PhoneCaseMode.LOWER_CASE, 'output': 'cf'}},
      {'model': phoneModelByName(NAME_PHONEMODEL_NOKIA_1650), 'language': PhoneInputLanguage.GERMAN, 'input' : '## # 222 333', 'expectedOutput' : {'mode': PhoneCaseMode.LOWER_CASE, 'output': 'Cf'}},
      {'model': phoneModelByName(NAME_PHONEMODEL_NOKIA_1650), 'language': PhoneInputLanguage.GERMAN, 'input' : '222 #', 'expectedOutput' : {'mode': PhoneCaseMode.UPPER_CASE, 'output': 'C'}},
      {'model': phoneModelByName(NAME_PHONEMODEL_NOKIA_1650), 'language': PhoneInputLanguage.GERMAN, 'input' : '222 # 333', 'expectedOutput' : {'mode': PhoneCaseMode.UPPER_CASE, 'output': 'CF'}},
      {'model': phoneModelByName(NAME_PHONEMODEL_NOKIA_1650), 'language': PhoneInputLanguage.GERMAN, 'input' : '222 ## 333', 'expectedOutput' : {'mode': PhoneCaseMode.LOWER_CASE, 'output': 'Cf'}},
      {'model': phoneModelByName(NAME_PHONEMODEL_NOKIA_1650), 'language': PhoneInputLanguage.GERMAN, 'input' : '222 # # 333', 'expectedOutput' : {'mode': PhoneCaseMode.LOWER_CASE, 'output': 'Cf'}},
      {'model': phoneModelByName(NAME_PHONEMODEL_NOKIA_1650), 'language': PhoneInputLanguage.GERMAN, 'input' : '222 ## 333 1 0', 'expectedOutput' : {'mode': PhoneCaseMode.CAMEL_CASE, 'output': 'Cf. '}},
      {'model': phoneModelByName(NAME_PHONEMODEL_NOKIA_1650), 'language': PhoneInputLanguage.GERMAN, 'input' : '222 ## 333 1 0 44', 'expectedOutput' : {'mode': PhoneCaseMode.LOWER_CASE, 'output': 'Cf. H'}},
      {'model': phoneModelByName(NAME_PHONEMODEL_NOKIA_1650), 'language': PhoneInputLanguage.GERMAN, 'input' : '222 ## 333 1 0 44 5', 'expectedOutput' : {'mode': PhoneCaseMode.LOWER_CASE, 'output': 'Cf. Hj'}},
      {'model': phoneModelByName(NAME_PHONEMODEL_NOKIA_1650), 'language': PhoneInputLanguage.GERMAN, 'input' : '222 # 333 1 0', 'expectedOutput' : {'mode': PhoneCaseMode.UPPER_CASE, 'output': 'CF. '}},
      {'model': phoneModelByName(NAME_PHONEMODEL_NOKIA_1650), 'language': PhoneInputLanguage.GERMAN, 'input' : '222 # 333 1 0 44', 'expectedOutput' : {'mode': PhoneCaseMode.UPPER_CASE, 'output': 'CF. H'}},
      {'model': phoneModelByName(NAME_PHONEMODEL_NOKIA_1650), 'language': PhoneInputLanguage.GERMAN, 'input' : '222 # 333 1 0 44 5', 'expectedOutput' : {'mode': PhoneCaseMode.UPPER_CASE, 'output': 'CF. HJ'}},

      {'model': phoneModelByName(NAME_PHONEMODEL_SIEMENS_A65), 'language': PhoneInputLanguage.GERMAN, 'input' : '', 'expectedOutput' : {'mode': PhoneCaseMode.LOWER_CASE, 'output': ''}},
      {'model': phoneModelByName(NAME_PHONEMODEL_SIEMENS_A65), 'language': PhoneInputLanguage.GERMAN, 'input' : '#', 'expectedOutput' : {'mode': PhoneCaseMode.CAMEL_CASE, 'output': ''}},
      {'model': phoneModelByName(NAME_PHONEMODEL_SIEMENS_A65), 'language': PhoneInputLanguage.GERMAN, 'input' : '##', 'expectedOutput' : {'mode': PhoneCaseMode.NUMBERS, 'output': ''}},
      {'model': phoneModelByName(NAME_PHONEMODEL_SIEMENS_A65), 'language': PhoneInputLanguage.GERMAN, 'input' : '# #', 'expectedOutput' : {'mode': PhoneCaseMode.NUMBERS, 'output': ''}},
      {'model': phoneModelByName(NAME_PHONEMODEL_SIEMENS_A65), 'language': PhoneInputLanguage.GERMAN, 'input' : '# ##', 'expectedOutput' : {'mode': PhoneCaseMode.LOWER_CASE, 'output': ''}},
      {'model': phoneModelByName(NAME_PHONEMODEL_SIEMENS_A65), 'language': PhoneInputLanguage.GERMAN, 'input' : '## 222 333', 'expectedOutput' : {'mode': PhoneCaseMode.NUMBERS, 'output': '222333'}},
      {'model': phoneModelByName(NAME_PHONEMODEL_SIEMENS_A65), 'language': PhoneInputLanguage.GERMAN, 'input' : '# # 222 333', 'expectedOutput' : {'mode': PhoneCaseMode.NUMBERS, 'output': '222333'}},
      {'model': phoneModelByName(NAME_PHONEMODEL_SIEMENS_A65), 'language': PhoneInputLanguage.GERMAN, 'input' : '## # 222 333', 'expectedOutput' : {'mode': PhoneCaseMode.LOWER_CASE, 'output': 'cf'}},
      {'model': phoneModelByName(NAME_PHONEMODEL_SIEMENS_A65), 'language': PhoneInputLanguage.GERMAN, 'input' : '222 #', 'expectedOutput' : {'mode': PhoneCaseMode.CAMEL_CASE, 'output': 'c'}},
      {'model': phoneModelByName(NAME_PHONEMODEL_SIEMENS_A65), 'language': PhoneInputLanguage.GERMAN, 'input' : '222 # 333', 'expectedOutput' : {'mode': PhoneCaseMode.LOWER_CASE, 'output': 'cF'}},
      {'model': phoneModelByName(NAME_PHONEMODEL_SIEMENS_A65), 'language': PhoneInputLanguage.GERMAN, 'input' : '222 ## 333', 'expectedOutput' : {'mode': PhoneCaseMode.LOWER_CASE, 'output': 'cf'}},
      {'model': phoneModelByName(NAME_PHONEMODEL_SIEMENS_A65), 'language': PhoneInputLanguage.GERMAN, 'input' : '222 # # 333', 'expectedOutput' : {'mode': PhoneCaseMode.LOWER_CASE, 'output': 'cf'}},
      {'model': phoneModelByName(NAME_PHONEMODEL_SIEMENS_A65), 'language': PhoneInputLanguage.GERMAN, 'input' : '222 # ##', 'expectedOutput' : {'mode': PhoneCaseMode.CAMEL_CASE, 'output': 'c'}},
      {'model': phoneModelByName(NAME_PHONEMODEL_SIEMENS_A65), 'language': PhoneInputLanguage.GERMAN, 'input' : '222 ### #', 'expectedOutput' : {'mode': PhoneCaseMode.NUMBERS, 'output': 'c'}},
      {'model': phoneModelByName(NAME_PHONEMODEL_SIEMENS_A65), 'language': PhoneInputLanguage.GERMAN, 'input' : '222 ### # 333', 'expectedOutput' : {'mode': PhoneCaseMode.NUMBERS, 'output': 'c333'}},
      {'model': phoneModelByName(NAME_PHONEMODEL_SIEMENS_A65), 'language': PhoneInputLanguage.GERMAN, 'input' : '222 #### 333 ##', 'expectedOutput' : {'mode': PhoneCaseMode.CAMEL_CASE, 'output': 'c333'}},
      {'model': phoneModelByName(NAME_PHONEMODEL_SIEMENS_A65), 'language': PhoneInputLanguage.GERMAN, 'input' : '222 ## ## 333 ## 44', 'expectedOutput' : {'mode': PhoneCaseMode.LOWER_CASE, 'output': 'c333H'}},
      {'model': phoneModelByName(NAME_PHONEMODEL_SIEMENS_A65), 'language': PhoneInputLanguage.GERMAN, 'input' : '222 # ### 333 ## 44 #', 'expectedOutput' : {'mode': PhoneCaseMode.UPPER_CASE, 'output': 'c333H'}},
      {'model': phoneModelByName(NAME_PHONEMODEL_SIEMENS_A65), 'language': PhoneInputLanguage.GERMAN, 'input' : '222   ###   # 333    ##   44 # 5', 'expectedOutput' : {'mode': PhoneCaseMode.UPPER_CASE, 'output': 'c333HJ'}},
      {'model': phoneModelByName(NAME_PHONEMODEL_SIEMENS_A65), 'language': PhoneInputLanguage.GERMAN, 'input' : '222 ### # 333 ## 44 # 5 0', 'expectedOutput' : {'mode': PhoneCaseMode.UPPER_CASE, 'output': 'c333HJ.'}},
      {'model': phoneModelByName(NAME_PHONEMODEL_SIEMENS_A65), 'language': PhoneInputLanguage.GERMAN, 'input' : '222 ### # 333 ## 44 # 5 0 #', 'expectedOutput' : {'mode': PhoneCaseMode.LOWER_CASE, 'output': 'c333HJ.'}},
      {'model': phoneModelByName(NAME_PHONEMODEL_SIEMENS_A65), 'language': PhoneInputLanguage.GERMAN, 'input' : '222 ### # 333 ## 44 # 5 0 # 1', 'expectedOutput' : {'mode': PhoneCaseMode.CAMEL_CASE, 'output': 'c333HJ. '}},
      {'model': phoneModelByName(NAME_PHONEMODEL_SIEMENS_A65), 'language': PhoneInputLanguage.GERMAN, 'input' : '222 ### # 333 ## 44 # 5 0 # 1 7777', 'expectedOutput' : {'mode': PhoneCaseMode.LOWER_CASE, 'output': 'c333HJ. S'}},
      {'model': phoneModelByName(NAME_PHONEMODEL_SIEMENS_A65), 'language': PhoneInputLanguage.GERMAN, 'input' : '222 ### # 333 ## 44 # 5 0 # 1 7777 6', 'expectedOutput' : {'mode': PhoneCaseMode.LOWER_CASE, 'output': 'c333HJ. Sm'}},
      {'model': phoneModelByName(NAME_PHONEMODEL_SIEMENS_A65), 'language': PhoneInputLanguage.GERMAN, 'input' : '222 ### # 333 ## 44 # 5 0 # 1 7777 ****', 'expectedOutput' : {'mode': PhoneCaseMode.LOWER_CASE, 'output': 'c333HJ. S_'}},

      {'model': phoneModelByName(NAME_PHONEMODEL_SAMSUNG_E1120), 'language': PhoneInputLanguage.GERMAN, 'input' : '', 'expectedOutput' : {'mode': PhoneCaseMode.CAMEL_CASE, 'output': ''}},
      {'model': phoneModelByName(NAME_PHONEMODEL_SAMSUNG_E1120), 'language': PhoneInputLanguage.GERMAN, 'input' : '*', 'expectedOutput' : {'mode': PhoneCaseMode.UPPER_CASE, 'output': ''}},
      {'model': phoneModelByName(NAME_PHONEMODEL_SAMSUNG_E1120), 'language': PhoneInputLanguage.GERMAN, 'input' : '**', 'expectedOutput' : {'mode': PhoneCaseMode.LOWER_CASE, 'output': ''}},
      {'model': phoneModelByName(NAME_PHONEMODEL_SAMSUNG_E1120), 'language': PhoneInputLanguage.GERMAN, 'input' : '222 *', 'expectedOutput' : {'mode': PhoneCaseMode.NUMBERS, 'output': 'C'}},
      {'model': phoneModelByName(NAME_PHONEMODEL_SAMSUNG_E1120), 'language': PhoneInputLanguage.GERMAN, 'input' : '222 * 333', 'expectedOutput' : {'mode': PhoneCaseMode.NUMBERS, 'output': 'C333'}},
      {'model': phoneModelByName(NAME_PHONEMODEL_SAMSUNG_E1120), 'language': PhoneInputLanguage.GERMAN, 'input' : '222 * * 333', 'expectedOutput' : {'mode': PhoneCaseMode.LOWER_CASE, 'output': 'CF'}},
      {'model': phoneModelByName(NAME_PHONEMODEL_SAMSUNG_E1120), 'language': PhoneInputLanguage.GERMAN, 'input' : '222 * * 333 44', 'expectedOutput' : {'mode': PhoneCaseMode.LOWER_CASE, 'output': 'CFh'}},
      {'model': phoneModelByName(NAME_PHONEMODEL_SAMSUNG_E1120), 'language': PhoneInputLanguage.GERMAN, 'input' : '#', 'expectedOutput' : {'mode': PhoneCaseMode.LOWER_CASE, 'output': ' '}},
      {'model': phoneModelByName(NAME_PHONEMODEL_SAMSUNG_E1120), 'language': PhoneInputLanguage.GERMAN, 'input' : '##', 'expectedOutput' : {'mode': PhoneCaseMode.LOWER_CASE, 'output': '  '}},
      {'model': phoneModelByName(NAME_PHONEMODEL_SAMSUNG_E1120), 'language': PhoneInputLanguage.GERMAN, 'input' : '222 #', 'expectedOutput' : {'mode': PhoneCaseMode.LOWER_CASE, 'output': 'C '}},
      {'model': phoneModelByName(NAME_PHONEMODEL_SAMSUNG_E1120), 'language': PhoneInputLanguage.GERMAN, 'input' : '222 # 333', 'expectedOutput' : {'mode': PhoneCaseMode.LOWER_CASE, 'output': 'C f'}},
      {'model': phoneModelByName(NAME_PHONEMODEL_SAMSUNG_E1120), 'language': PhoneInputLanguage.GERMAN, 'input' : '222 ## 333', 'expectedOutput' : {'mode': PhoneCaseMode.LOWER_CASE, 'output': 'C  f'}},
      {'model': phoneModelByName(NAME_PHONEMODEL_SAMSUNG_E1120), 'language': PhoneInputLanguage.GERMAN, 'input' : '222 1 # 333 44', 'expectedOutput' : {'mode': PhoneCaseMode.LOWER_CASE, 'output': 'C. Fh'}},

      {'model': phoneModelByName(NAME_PHONEMODEL_MOTOROLA_V600), 'language': PhoneInputLanguage.EXTENDED, 'input' : '00 ## 9999 0 111 # * 0 22 5', 'expectedOutput' : {'mode': PhoneCaseMode.UPPER_CASE, 'output': '#+! BJ'}},

      {'model': phoneModelByName(NAME_PHONEMODEL_NOKIA_1650), 'language': PhoneInputLanguage.GERMAN, 'input' : '222 AAA ## 333 a 1 0', 'expectedOutput' : {'mode': PhoneCaseMode.CAMEL_CASE, 'output': 'Cf. '}},
      {'model': phoneModelByName(NAME_PHONEMODEL_SIEMENS_A65), 'language': PhoneInputLanguage.GERMAN, 'input' : '222 ### # &%/()33mmmm3 ## 44 # 5 0 # 1 Abc 7777', 'expectedOutput' : {'mode': PhoneCaseMode.LOWER_CASE, 'output': 'c333HJ. S'}},
    ];

    _inputsToExpected.forEach((elem) {
      test('input: ${elem['input']}, model: ${elem['model']}, language: ${elem['language']}', () {
        var _actual = decodeVanityMultitap(elem['input'], elem['model'], elem['language']);
        expect(_actual, elem['expectedOutput']);
      });
    });
  });

  group("Vanity.encodeVanityMultitap:", () {
    List<Map<String, dynamic>> _inputsToExpected = [
      {'model': phoneModelByName(NAME_PHONEMODEL_NOKIA_6230), 'language': PhoneInputLanguage.GERMAN, 'input' : null, 'expectedOutput' : {'mode': PhoneCaseMode.CAMEL_CASE, 'output': ''}},
      {'model': phoneModelByName(NAME_PHONEMODEL_NOKIA_6230), 'language': PhoneInputLanguage.GERMAN, 'input' : '', 'expectedOutput' : {'mode': PhoneCaseMode.CAMEL_CASE, 'output': ''}},

      {'model': PHONEMODEL_SIMPLE_SPACE_0, 'language': PhoneInputLanguage.UNSPECIFIED, 'input' : ' ABC. DEF0123 ', 'expectedOutput' : {'mode': PhoneCaseMode.UPPER_CASE, 'output': '0 2 22 222 0 3 33 333 00 1 2222 3333 0'}},
      {'model': PHONEMODEL_SIMPLE_SPACE_1, 'language': PhoneInputLanguage.UNSPECIFIED, 'input' : ' ABC. DEF0123 ', 'expectedOutput' : {'mode': PhoneCaseMode.UPPER_CASE, 'output': '1 2 22 222 1 3 33 333 0 11 2222 3333 1'}},
      {'model': PHONEMODEL_SIMPLE_SPACE_HASH, 'language': PhoneInputLanguage.UNSPECIFIED, 'input' : ' ABC. DEF0123 ', 'expectedOutput' : {'mode': PhoneCaseMode.UPPER_CASE, 'output': '# 2 22 222 # 3 33 333 0 1 2222 3333 #'}},

      {'model': phoneModelByName(NAME_PHONEMODEL_NOKIA_6230), 'language': PhoneInputLanguage.GERMAN, 'input' : 'Abc', 'expectedOutput' : {'mode': PhoneCaseMode.LOWER_CASE, 'output': '2 22 222'}},
      {'model': phoneModelByName(NAME_PHONEMODEL_NOKIA_6230), 'language': PhoneInputLanguage.GERMAN, 'input' : 'AB', 'expectedOutput' : {'mode': PhoneCaseMode.UPPER_CASE, 'output': '2 # 22'}},
      {'model': phoneModelByName(NAME_PHONEMODEL_NOKIA_6230), 'language': PhoneInputLanguage.GERMAN, 'input' : 'Abc. Abc', 'expectedOutput' : {'mode': PhoneCaseMode.LOWER_CASE, 'output': '2 22 222 1 0 2 22 222'}},
      {'model': phoneModelByName(NAME_PHONEMODEL_NOKIA_6230), 'language': PhoneInputLanguage.GERMAN, 'input' : 'AB? AB', 'expectedOutput' : {'mode': PhoneCaseMode.UPPER_CASE, 'output': '2 # 22 111 0 2 # 22'}},
      {'model': phoneModelByName(NAME_PHONEMODEL_NOKIA_6230), 'language': PhoneInputLanguage.GERMAN, 'input' : 'abc', 'expectedOutput' : {'mode': PhoneCaseMode.LOWER_CASE, 'output': '# 2 22 222'}},
      {'model': phoneModelByName(NAME_PHONEMODEL_NOKIA_6230), 'language': PhoneInputLanguage.GERMAN, 'input' : 'Abc. ab2', 'expectedOutput' : {'mode': PhoneCaseMode.LOWER_CASE, 'output': '2 22 222 1 0 # 2 22 2222'}},
      {'model': phoneModelByName(NAME_PHONEMODEL_NOKIA_6230), 'language': PhoneInputLanguage.GERMAN, 'input' : 'Ab.c ab', 'expectedOutput' : {'mode': PhoneCaseMode.LOWER_CASE, 'output': '2 22 1 222 0 2 22'}},

      {'model': phoneModelByName(NAME_PHONEMODEL_SIEMENS_S35), 'language': PhoneInputLanguage.DUTCH, 'input' : 'Abc', 'expectedOutput' : {'mode': PhoneCaseMode.LOWER_CASE, 'output': '2 22 222'}},
      {'model': phoneModelByName(NAME_PHONEMODEL_SIEMENS_S35), 'language': PhoneInputLanguage.DUTCH, 'input' : 'ABC', 'expectedOutput' : {'mode': PhoneCaseMode.LOWER_CASE, 'output': '2 * 22 * 222'}},
      {'model': phoneModelByName(NAME_PHONEMODEL_SIEMENS_S35), 'language': PhoneInputLanguage.DUTCH, 'input' : 'Abc. Abc', 'expectedOutput' : {'mode': PhoneCaseMode.LOWER_CASE, 'output': '2 22 222 0000 1 * 2 22 222'}},
      {'model': phoneModelByName(NAME_PHONEMODEL_SIEMENS_S35), 'language': PhoneInputLanguage.DUTCH, 'input' : 'A1B2', 'expectedOutput' : {'mode': PhoneCaseMode.LOWER_CASE, 'output': '2 11 * 22 2222'}},
      {'model': phoneModelByName(NAME_PHONEMODEL_SIEMENS_S35), 'language': PhoneInputLanguage.DUTCH, 'input' : 'a1B2', 'expectedOutput' : {'mode': PhoneCaseMode.LOWER_CASE, 'output': '* 2 11 * 22 2222'}},

      {'model': phoneModelByName(NAME_PHONEMODEL_MOTOROLA_CD930), 'language': PhoneInputLanguage.UNSPECIFIED, 'input' : 'A1B2', 'expectedOutput' : {'mode': PhoneCaseMode.UPPER_CASE, 'output': '2 111 22 2222'}},
      {'model': phoneModelByName(NAME_PHONEMODEL_MOTOROLA_CD930), 'language': PhoneInputLanguage.UNSPECIFIED, 'input' : 'a1B2c', 'expectedOutput' : {'mode': PhoneCaseMode.UPPER_CASE, 'output': '111 22 2222'}},

      {'model': phoneModelByName(NAME_PHONEMODEL_MOTOROLA_V600), 'language': PhoneInputLanguage.EXTENDED, 'input' : 'Abc', 'expectedOutput' : {'mode': PhoneCaseMode.LOWER_CASE, 'output': '2 22 222'}},
      {'model': phoneModelByName(NAME_PHONEMODEL_MOTOROLA_V600), 'language': PhoneInputLanguage.EXTENDED, 'input' : 'AB', 'expectedOutput' : {'mode': PhoneCaseMode.LOWER_CASE, 'output': '2 0 22'}},
      {'model': phoneModelByName(NAME_PHONEMODEL_MOTOROLA_V600), 'language': PhoneInputLanguage.EXTENDED, 'input' : 'Abc. Abc', 'expectedOutput' : {'mode': PhoneCaseMode.LOWER_CASE, 'output': '2 22 222 1 * 2 22 222'}},
      {'model': phoneModelByName(NAME_PHONEMODEL_MOTOROLA_V600), 'language': PhoneInputLanguage.EXTENDED, 'input' : 'Ab.c aB', 'expectedOutput' : {'mode': PhoneCaseMode.LOWER_CASE, 'output': '2 22 1 222 * 2 0 22'}},
      {'model': phoneModelByName(NAME_PHONEMODEL_MOTOROLA_V600), 'language': PhoneInputLanguage.EXTENDED, 'input' : '%>?A14Bz&%! c', 'expectedOutput' : {'mode': PhoneCaseMode.LOWER_CASE, 'output': '11111111111111111111 1111111111111111111111111111111111 11 0 2 1111111111111111 4444 0 22 9999 1111111111111 11111111111111111111 111 * 00 222'}},

      {'model': phoneModelByName(NAME_PHONEMODEL_SIEMENS_C75), 'language': PhoneInputLanguage.ENGLISH, 'input' : 'Alle meine Entchen', 'expectedOutput' : {'mode': PhoneCaseMode.LOWER_CASE, 'output': '2 555 555 33 1 6 33 444 66 33 1 # 33 66 8 222 44 33 66'}},

      {'model': phoneModelByName(NAME_PHONEMODEL_NOKIA_6230), 'language': PhoneInputLanguage.GERMAN, 'input' : 'AẄb', 'expectedOutput' : {'mode': PhoneCaseMode.LOWER_CASE, 'output': '2 22'}},
    ];

    _inputsToExpected.forEach((elem) {
      test('input: ${elem['input']}, model: ${elem['model']}, language: ${elem['language']}', () {
        var _actual = encodeVanityMultitap(elem['input'], elem['model'], elem['language']);
        expect(_actual, elem['expectedOutput']);
      });
    });
  });

  group("Vanity.reverseEncodeVanityMultitap:", () {
    List<Map<String, dynamic>> _inputsToExpected = [
      {'model': PHONEMODEL_SIMPLE_SPACE_0, 'language': PhoneInputLanguage.UNSPECIFIED, 'expectedOutput' : ' ABC DEF0123 ', 'input' : '0 2 22 222 0 3 33 333 00 1 2222 3333 0'},
      {'model': PHONEMODEL_SIMPLE_SPACE_1, 'language': PhoneInputLanguage.UNSPECIFIED, 'expectedOutput' : ' ABC DEF0123 ', 'input' : '1 2 22 222 1 3 33 333 0 11 2222 3333 1'},
      {'model': PHONEMODEL_SIMPLE_SPACE_HASH, 'language': PhoneInputLanguage.UNSPECIFIED, 'expectedOutput' : ' ABC DEF0123 ', 'input' : '# 2 22 222 # 3 33 333 0 1 2222 3333 #'},

      {'model': phoneModelByName(NAME_PHONEMODEL_NOKIA_6230), 'language': PhoneInputLanguage.GERMAN, 'expectedOutput' : 'Abc', 'input' : '2 22 222'},
      {'model': phoneModelByName(NAME_PHONEMODEL_NOKIA_6230), 'language': PhoneInputLanguage.GERMAN, 'expectedOutput' : 'AB', 'input' : '2 # 22'},
      {'model': phoneModelByName(NAME_PHONEMODEL_NOKIA_6230), 'language': PhoneInputLanguage.GERMAN, 'expectedOutput' : 'Abc. Abc', 'input' : '2 22 222 1 0 2 22 222'},
      {'model': phoneModelByName(NAME_PHONEMODEL_NOKIA_6230), 'language': PhoneInputLanguage.GERMAN, 'expectedOutput' : 'AB? AB', 'input' : '2 # 22 111 0 2 # 22'},
      {'model': phoneModelByName(NAME_PHONEMODEL_NOKIA_6230), 'language': PhoneInputLanguage.GERMAN, 'expectedOutput' : 'abc', 'input' : '# 2 22 222'},
      {'model': phoneModelByName(NAME_PHONEMODEL_NOKIA_6230), 'language': PhoneInputLanguage.GERMAN, 'expectedOutput' : 'Abc. ab2', 'input' : '2 22 222 1 0 # 2 22 2222'},
      {'model': phoneModelByName(NAME_PHONEMODEL_NOKIA_6230), 'language': PhoneInputLanguage.GERMAN, 'expectedOutput' : 'Ab.c ab', 'input' : '2 22 1 222 0 2 22'},

      {'model': phoneModelByName(NAME_PHONEMODEL_SIEMENS_S35), 'language': PhoneInputLanguage.DUTCH, 'expectedOutput' : 'Abc', 'input' : '2 22 222'},
      {'model': phoneModelByName(NAME_PHONEMODEL_SIEMENS_S35), 'language': PhoneInputLanguage.DUTCH, 'expectedOutput' : 'ABC', 'input' : '2 * 22 * 222'},
      {'model': phoneModelByName(NAME_PHONEMODEL_SIEMENS_S35), 'language': PhoneInputLanguage.DUTCH, 'expectedOutput' : 'Abc. Abc', 'input' : '2 22 222 0000 1 * 2 22 222'},
      {'model': phoneModelByName(NAME_PHONEMODEL_SIEMENS_S35), 'language': PhoneInputLanguage.DUTCH, 'expectedOutput' : 'A1B2', 'input' : '2 11 * 22 2222'},
      {'model': phoneModelByName(NAME_PHONEMODEL_SIEMENS_S35), 'language': PhoneInputLanguage.DUTCH, 'expectedOutput' : 'a1B2', 'input' : '* 2 11 * 22 2222'},

      {'model': phoneModelByName(NAME_PHONEMODEL_MOTOROLA_CD930), 'language': PhoneInputLanguage.UNSPECIFIED, 'expectedOutput' : 'A1B2', 'input' : '2 111 22 2222'},
      {'model': phoneModelByName(NAME_PHONEMODEL_MOTOROLA_CD930), 'language': PhoneInputLanguage.UNSPECIFIED, 'expectedOutput' : '1B2', 'input' : '111 22 2222'},

      {'model': phoneModelByName(NAME_PHONEMODEL_MOTOROLA_V600), 'language': PhoneInputLanguage.EXTENDED, 'expectedOutput' : 'Abc', 'input' : '2 22 222'},
      {'model': phoneModelByName(NAME_PHONEMODEL_MOTOROLA_V600), 'language': PhoneInputLanguage.EXTENDED, 'expectedOutput' : 'AB', 'input' : '2 0 22'},
      {'model': phoneModelByName(NAME_PHONEMODEL_MOTOROLA_V600), 'language': PhoneInputLanguage.EXTENDED, 'expectedOutput' : 'Abc. Abc', 'input' : '2 22 222 1 * 2 22 222'},
      {'model': phoneModelByName(NAME_PHONEMODEL_MOTOROLA_V600), 'language': PhoneInputLanguage.EXTENDED, 'expectedOutput' : 'Ab.c aB', 'input' : '2 22 1 222 * 2 0 22'},
      {'model': phoneModelByName(NAME_PHONEMODEL_MOTOROLA_V600), 'language': PhoneInputLanguage.EXTENDED, 'expectedOutput' : '%>?A14Bz&%! c', 'input' : '11111111111111111111 1111111111111111111111111111111111 11 0 2 1111111111111111 4444 0 22 9999 1111111111111 11111111111111111111 111 * 00 222'},
    ];

    _inputsToExpected.forEach((elem) {
      test('input: ${elem['input']}, model: ${elem['model']}, language: ${elem['language']}', () {
        var _actual = decodeVanityMultitap(elem['input'], elem['model'], elem['language']);
        expect(_actual['output'], elem['expectedOutput']);
      });
    });
  });
}