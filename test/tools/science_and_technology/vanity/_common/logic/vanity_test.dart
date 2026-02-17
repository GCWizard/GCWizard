import 'package:flutter_test/flutter_test.dart';
import 'package:gc_wizard/tools/science_and_technology/vanity/_common/logic/phone_models.dart';
import 'package:gc_wizard/tools/science_and_technology/vanity/_common/logic/vanity.dart';

void main() {
  group("Vanity.decodeVanityMultitap:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'model': phoneModelByName(NAME_PHONEMODEL_NOKIA_6230), 'language': PhoneInputLanguage.GERMAN, 'input' : '', 'expectedOutput' : const (mode: PhoneCaseMode.CAMEL_CASE, text: '')},

      {'model': PHONEMODEL_SIMPLE_SPACE_0, 'language': PhoneInputLanguage.UNSPECIFIED, 'input' : '222 9999999 00 0 11 111 8888', 'expectedOutput' : const (mode: PhoneCaseMode.UPPER_CASE, text: 'CX0 111118')},
      {'model': PHONEMODEL_SIMPLE_SPACE_0, 'language': PhoneInputLanguage.UNSPECIFIED, 'input' : '* 222 9999999 ## 00 0 11 111 8888 abc', 'expectedOutput' : const (mode: PhoneCaseMode.UPPER_CASE, text: 'CX0 111118')},
      {'model': PHONEMODEL_SIMPLE_SPACE_1, 'language': PhoneInputLanguage.UNSPECIFIED, 'input' : '222 9999999 00 0 11 111 8888', 'expectedOutput' : const (mode: PhoneCaseMode.UPPER_CASE, text: 'CX0001 8')},
      {'model': PHONEMODEL_SIMPLE_SPACE_1, 'language': PhoneInputLanguage.UNSPECIFIED, 'input' : '* 222 9999999 ## 00 0 11 111 8888 abc', 'expectedOutput' : const (mode: PhoneCaseMode.UPPER_CASE, text: 'CX0001 8')},
      {'model': PHONEMODEL_SIMPLE_SPACE_HASH, 'language': PhoneInputLanguage.UNSPECIFIED, 'input' : '222 9999999 00 0 11 111 8888', 'expectedOutput' : const (mode: PhoneCaseMode.UPPER_CASE, text: 'CX000111118')},
      {'model': PHONEMODEL_SIMPLE_SPACE_HASH, 'language': PhoneInputLanguage.UNSPECIFIED, 'input' : '* 222 9999999 ## 00 0 11 111 8888 abc', 'expectedOutput' : const (mode: PhoneCaseMode.UPPER_CASE, text: 'CX  000111118')},

      {'model': phoneModelByName(NAME_PHONEMODEL_NOKIA_6230), 'language': PhoneInputLanguage.GERMAN, 'input' : '2', 'expectedOutput' : const (mode: PhoneCaseMode.LOWER_CASE, text: 'A')},
      {'model': phoneModelByName(NAME_PHONEMODEL_NOKIA_6230), 'language': PhoneInputLanguage.GERMAN, 'input' : '2 22 222 99 999 9999', 'expectedOutput' : const (mode: PhoneCaseMode.LOWER_CASE, text: 'Abcxyz')},
      {'model': phoneModelByName(NAME_PHONEMODEL_NOKIA_6230), 'language': PhoneInputLanguage.GERMAN, 'input' : '2 22 222 1111111 2222 3333 99 999 9999', 'expectedOutput' : const (mode: PhoneCaseMode.LOWER_CASE, text: 'Abc123xyz')},
      {'model': phoneModelByName(NAME_PHONEMODEL_NOKIA_6230), 'language': PhoneInputLanguage.GERMAN, 'input' : '2 666 88 7777', 'expectedOutput' : const (mode: PhoneCaseMode.LOWER_CASE, text: 'Aous')},

      {'model': phoneModelByName(NAME_PHONEMODEL_SIEMENS_S55), 'language': PhoneInputLanguage.GERMAN, 'input' : '2 666 88 7777', 'expectedOutput' : const (mode: PhoneCaseMode.LOWER_CASE, text: 'Aous')},
      {'model': phoneModelByName(NAME_PHONEMODEL_SIEMENS_S55), 'language': PhoneInputLanguage.GREEK, 'input' : '2 666 88 7777', 'expectedOutput' : const (mode: PhoneCaseMode.UPPER_CASE, text: 'ΑΟΤΨ')},

      {'model': phoneModelByName(NAME_PHONEMODEL_NOKIA_6230), 'language': PhoneInputLanguage.GERMAN, 'input' : '88888', 'expectedOutput' : const (mode: PhoneCaseMode.LOWER_CASE, text: 'Ü')},
      {'model': phoneModelByName(NAME_PHONEMODEL_NOKIA_6230), 'language': PhoneInputLanguage.ENGLISH, 'input' : '88888888', 'expectedOutput' : const (mode: PhoneCaseMode.LOWER_CASE, text: 'Ü')},

      {'model': phoneModelByName(NAME_PHONEMODEL_SIEMENS_C75), 'language': PhoneInputLanguage.FRENCH, 'input' : '222222', 'expectedOutput' : const (mode: PhoneCaseMode.LOWER_CASE, text: 'Æ')},
      {'model': phoneModelByName(NAME_PHONEMODEL_SIEMENS_C75), 'language': PhoneInputLanguage.FRENCH, 'input' : '2222222', 'expectedOutput' : const (mode: PhoneCaseMode.LOWER_CASE, text: 'Å')},
      {'model': phoneModelByName(NAME_PHONEMODEL_SIEMENS_C75), 'language': PhoneInputLanguage.FRENCH, 'input' : '22222222', 'expectedOutput' : const (mode: PhoneCaseMode.LOWER_CASE, text: 'A')},
      {'model': phoneModelByName(NAME_PHONEMODEL_SIEMENS_C75), 'language': PhoneInputLanguage.FRENCH, 'input' : '222222222', 'expectedOutput' : const (mode: PhoneCaseMode.LOWER_CASE, text: 'B')},
      {'model': phoneModelByName(NAME_PHONEMODEL_SIEMENS_C75), 'language': PhoneInputLanguage.TURKISH, 'input' : '222222', 'expectedOutput' : const (mode: PhoneCaseMode.LOWER_CASE, text: 'Â')},
      {'model': phoneModelByName(NAME_PHONEMODEL_SIEMENS_C75), 'language': PhoneInputLanguage.TURKISH, 'input' : '2222222', 'expectedOutput' : const (mode: PhoneCaseMode.LOWER_CASE, text: 'A')},
      {'model': phoneModelByName(NAME_PHONEMODEL_SIEMENS_C75), 'language': PhoneInputLanguage.TURKISH, 'input' : '22222222', 'expectedOutput' : const (mode: PhoneCaseMode.LOWER_CASE, text: 'B')},
      {'model': phoneModelByName(NAME_PHONEMODEL_SIEMENS_C75), 'language': PhoneInputLanguage.TURKISH, 'input' : '222222222', 'expectedOutput' : const (mode: PhoneCaseMode.LOWER_CASE, text: 'C')},

      {'model': phoneModelByName(NAME_PHONEMODEL_NOKIA_1650), 'language': PhoneInputLanguage.GERMAN, 'input' : '', 'expectedOutput' : const (mode: PhoneCaseMode.CAMEL_CASE, text: '')},
      {'model': phoneModelByName(NAME_PHONEMODEL_NOKIA_1650), 'language': PhoneInputLanguage.GERMAN, 'input' : '222', 'expectedOutput' : const (mode: PhoneCaseMode.LOWER_CASE, text: 'C')},
      {'model': phoneModelByName(NAME_PHONEMODEL_NOKIA_1650), 'language': PhoneInputLanguage.GERMAN, 'input' : '222 333', 'expectedOutput' : const (mode: PhoneCaseMode.LOWER_CASE, text: 'Cf')},
      {'model': phoneModelByName(NAME_PHONEMODEL_NOKIA_1650), 'language': PhoneInputLanguage.GERMAN, 'input' : '222 333 1', 'expectedOutput' : const (mode: PhoneCaseMode.LOWER_CASE, text: 'Cf.')},
      {'model': phoneModelByName(NAME_PHONEMODEL_NOKIA_1650), 'language': PhoneInputLanguage.GERMAN, 'input' : '222 333 1 0', 'expectedOutput' : const (mode: PhoneCaseMode.CAMEL_CASE, text: 'Cf. ')},
      {'model': phoneModelByName(NAME_PHONEMODEL_NOKIA_1650), 'language': PhoneInputLanguage.GERMAN, 'input' : '222 333 1 0 44', 'expectedOutput' : const (mode: PhoneCaseMode.LOWER_CASE, text: 'Cf. H')},
      {'model': phoneModelByName(NAME_PHONEMODEL_NOKIA_1650), 'language': PhoneInputLanguage.GERMAN, 'input' : '222 333 1 00 44', 'expectedOutput' : const (mode: PhoneCaseMode.LOWER_CASE, text: 'Cf.0h')},
      {'model': phoneModelByName(NAME_PHONEMODEL_NOKIA_1650), 'language': PhoneInputLanguage.GERMAN, 'input' : '222 333 1 000000 44', 'expectedOutput' : const (mode: PhoneCaseMode.LOWER_CASE, text: 'Cf.\nH')},

      {'model': phoneModelByName(NAME_PHONEMODEL_NOKIA_3210), 'language': PhoneInputLanguage.GERMAN, 'input' : '', 'expectedOutput' : const (mode: PhoneCaseMode.LOWER_CASE, text: '')},
      {'model': phoneModelByName(NAME_PHONEMODEL_NOKIA_3210), 'language': PhoneInputLanguage.GERMAN, 'input' : '222', 'expectedOutput' : const (mode: PhoneCaseMode.LOWER_CASE, text: 'c')},
      {'model': phoneModelByName(NAME_PHONEMODEL_NOKIA_3210), 'language': PhoneInputLanguage.GERMAN, 'input' : '222 333', 'expectedOutput' : const (mode: PhoneCaseMode.LOWER_CASE, text: 'cf')},
      {'model': phoneModelByName(NAME_PHONEMODEL_NOKIA_3210), 'language': PhoneInputLanguage.GERMAN, 'input' : '222 333 1', 'expectedOutput' : const (mode: PhoneCaseMode.LOWER_CASE, text: 'cf.')},
      {'model': phoneModelByName(NAME_PHONEMODEL_NOKIA_3210), 'language': PhoneInputLanguage.GERMAN, 'input' : '222 333 1 0', 'expectedOutput' : const (mode: PhoneCaseMode.LOWER_CASE, text: 'cf. ')},
      {'model': phoneModelByName(NAME_PHONEMODEL_NOKIA_3210), 'language': PhoneInputLanguage.GERMAN, 'input' : '222 333 1 0 44', 'expectedOutput' : const (mode: PhoneCaseMode.LOWER_CASE, text: 'cf. h')},
      {'model': phoneModelByName(NAME_PHONEMODEL_NOKIA_3210), 'language': PhoneInputLanguage.GERMAN, 'input' : '222 333 1 00 44', 'expectedOutput' : const (mode: PhoneCaseMode.LOWER_CASE, text: 'cf.0h')},
      {'model': phoneModelByName(NAME_PHONEMODEL_NOKIA_3210), 'language': PhoneInputLanguage.GERMAN, 'input' : '222 333 1 000000 44', 'expectedOutput' : const (mode: PhoneCaseMode.LOWER_CASE, text: 'cf.0h')},

      {'model': phoneModelByName(NAME_PHONEMODEL_SIEMENS_S55), 'language': PhoneInputLanguage.GERMAN, 'input' : '', 'expectedOutput' : const (mode: PhoneCaseMode.CAMEL_CASE, text: '')},
      {'model': phoneModelByName(NAME_PHONEMODEL_SIEMENS_S55), 'language': PhoneInputLanguage.GERMAN, 'input' : '222', 'expectedOutput' : const (mode: PhoneCaseMode.LOWER_CASE, text: 'C')},
      {'model': phoneModelByName(NAME_PHONEMODEL_SIEMENS_S55), 'language': PhoneInputLanguage.GERMAN, 'input' : '222 333', 'expectedOutput' : const (mode: PhoneCaseMode.LOWER_CASE, text: 'Cf')},
      {'model': phoneModelByName(NAME_PHONEMODEL_SIEMENS_S55), 'language': PhoneInputLanguage.GERMAN, 'input' : '222 333 0', 'expectedOutput' : const (mode: PhoneCaseMode.LOWER_CASE, text: 'Cf.')},
      {'model': phoneModelByName(NAME_PHONEMODEL_SIEMENS_S55), 'language': PhoneInputLanguage.GERMAN, 'input' : '222 333 0 1', 'expectedOutput' : const (mode: PhoneCaseMode.CAMEL_CASE, text: 'Cf. ')},
      {'model': phoneModelByName(NAME_PHONEMODEL_SIEMENS_S55), 'language': PhoneInputLanguage.GERMAN, 'input' : '222 333 0 1 44', 'expectedOutput' : const (mode: PhoneCaseMode.LOWER_CASE, text: 'Cf. H')},
      {'model': phoneModelByName(NAME_PHONEMODEL_SIEMENS_S55), 'language': PhoneInputLanguage.GERMAN, 'input' : '222 333 00 1 44', 'expectedOutput' : const (mode: PhoneCaseMode.LOWER_CASE, text: 'Cf, h')},
      {'model': phoneModelByName(NAME_PHONEMODEL_SIEMENS_S55), 'language': PhoneInputLanguage.GERMAN, 'input' : '222 333 000 1 44', 'expectedOutput' : const (mode: PhoneCaseMode.LOWER_CASE, text: 'Cf? H')},

      {'model': phoneModelByName(NAME_PHONEMODEL_SIEMENS_S55), 'language': PhoneInputLanguage.GREEK, 'input' : '', 'expectedOutput' : const (mode: PhoneCaseMode.UPPER_CASE, text: '')},
      {'model': phoneModelByName(NAME_PHONEMODEL_SIEMENS_S55), 'language': PhoneInputLanguage.GREEK, 'input' : '222', 'expectedOutput' : const (mode: PhoneCaseMode.UPPER_CASE, text: 'C')},
      {'model': phoneModelByName(NAME_PHONEMODEL_SIEMENS_S55), 'language': PhoneInputLanguage.GREEK, 'input' : '222 333', 'expectedOutput' : const (mode: PhoneCaseMode.UPPER_CASE, text: 'CΘ')},
      {'model': phoneModelByName(NAME_PHONEMODEL_SIEMENS_S55), 'language': PhoneInputLanguage.GREEK, 'input' : '222 333 0', 'expectedOutput' : const (mode: PhoneCaseMode.UPPER_CASE, text: 'CΘ.')},
      {'model': phoneModelByName(NAME_PHONEMODEL_SIEMENS_S55), 'language': PhoneInputLanguage.GREEK, 'input' : '222 333 0 1', 'expectedOutput' : const (mode: PhoneCaseMode.UPPER_CASE, text: 'CΘ. ')},
      {'model': phoneModelByName(NAME_PHONEMODEL_SIEMENS_S55), 'language': PhoneInputLanguage.GREEK, 'input' : '222 333 0 1 44', 'expectedOutput' : const (mode: PhoneCaseMode.UPPER_CASE, text: 'CΘ. Η')},
      {'model': phoneModelByName(NAME_PHONEMODEL_SIEMENS_S55), 'language': PhoneInputLanguage.GREEK, 'input' : '222 333 00 1 44', 'expectedOutput' : const (mode: PhoneCaseMode.UPPER_CASE, text: 'CΘ, Η')},
      {'model': phoneModelByName(NAME_PHONEMODEL_SIEMENS_S55), 'language': PhoneInputLanguage.GREEK, 'input' : '222 333 000 1 44', 'expectedOutput' : const (mode: PhoneCaseMode.UPPER_CASE, text: 'CΘ? Η')},

      {'model': phoneModelByName(NAME_PHONEMODEL_NOKIA_1650), 'language': PhoneInputLanguage.GERMAN, 'input' : '', 'expectedOutput' : const (mode: PhoneCaseMode.CAMEL_CASE, text: '')},
      {'model': phoneModelByName(NAME_PHONEMODEL_NOKIA_1650), 'language': PhoneInputLanguage.GERMAN, 'input' : '#', 'expectedOutput' : const (mode: PhoneCaseMode.UPPER_CASE, text: '')},
      {'model': phoneModelByName(NAME_PHONEMODEL_NOKIA_1650), 'language': PhoneInputLanguage.GERMAN, 'input' : '##', 'expectedOutput' : const (mode: PhoneCaseMode.LOWER_CASE, text: '')},
      {'model': phoneModelByName(NAME_PHONEMODEL_NOKIA_1650), 'language': PhoneInputLanguage.GERMAN, 'input' : '# #', 'expectedOutput' : const (mode: PhoneCaseMode.LOWER_CASE, text: '')},
      {'model': phoneModelByName(NAME_PHONEMODEL_NOKIA_1650), 'language': PhoneInputLanguage.GERMAN, 'input' : '# ##', 'expectedOutput' : const (mode: PhoneCaseMode.CAMEL_CASE, text: '')},
      {'model': phoneModelByName(NAME_PHONEMODEL_NOKIA_1650), 'language': PhoneInputLanguage.GERMAN, 'input' : '# 222 333', 'expectedOutput' : const (mode: PhoneCaseMode.UPPER_CASE, text: 'CF')},
      {'model': phoneModelByName(NAME_PHONEMODEL_NOKIA_1650), 'language': PhoneInputLanguage.GERMAN, 'input' : '# # 222 333', 'expectedOutput' : const (mode: PhoneCaseMode.LOWER_CASE, text: 'cf')},
      {'model': phoneModelByName(NAME_PHONEMODEL_NOKIA_1650), 'language': PhoneInputLanguage.GERMAN, 'input' : '## # 222 333', 'expectedOutput' : const (mode: PhoneCaseMode.LOWER_CASE, text: 'Cf')},
      {'model': phoneModelByName(NAME_PHONEMODEL_NOKIA_1650), 'language': PhoneInputLanguage.GERMAN, 'input' : '222 #', 'expectedOutput' : const (mode: PhoneCaseMode.UPPER_CASE, text: 'C')},
      {'model': phoneModelByName(NAME_PHONEMODEL_NOKIA_1650), 'language': PhoneInputLanguage.GERMAN, 'input' : '222 # 333', 'expectedOutput' : const (mode: PhoneCaseMode.UPPER_CASE, text: 'CF')},
      {'model': phoneModelByName(NAME_PHONEMODEL_NOKIA_1650), 'language': PhoneInputLanguage.GERMAN, 'input' : '222 ## 333', 'expectedOutput' : const (mode: PhoneCaseMode.LOWER_CASE, text: 'Cf')},
      {'model': phoneModelByName(NAME_PHONEMODEL_NOKIA_1650), 'language': PhoneInputLanguage.GERMAN, 'input' : '222 # # 333', 'expectedOutput' : const (mode: PhoneCaseMode.LOWER_CASE, text: 'Cf')},
      {'model': phoneModelByName(NAME_PHONEMODEL_NOKIA_1650), 'language': PhoneInputLanguage.GERMAN, 'input' : '222 ## 333 1 0', 'expectedOutput' : const (mode: PhoneCaseMode.CAMEL_CASE, text: 'Cf. ')},
      {'model': phoneModelByName(NAME_PHONEMODEL_NOKIA_1650), 'language': PhoneInputLanguage.GERMAN, 'input' : '222 ## 333 1 0 44', 'expectedOutput' : const (mode: PhoneCaseMode.LOWER_CASE, text: 'Cf. H')},
      {'model': phoneModelByName(NAME_PHONEMODEL_NOKIA_1650), 'language': PhoneInputLanguage.GERMAN, 'input' : '222 ## 333 1 0 44 5', 'expectedOutput' : const (mode: PhoneCaseMode.LOWER_CASE, text: 'Cf. Hj')},
      {'model': phoneModelByName(NAME_PHONEMODEL_NOKIA_1650), 'language': PhoneInputLanguage.GERMAN, 'input' : '222 # 333 1 0', 'expectedOutput' : const (mode: PhoneCaseMode.UPPER_CASE, text: 'CF. ')},
      {'model': phoneModelByName(NAME_PHONEMODEL_NOKIA_1650), 'language': PhoneInputLanguage.GERMAN, 'input' : '222 # 333 1 0 44', 'expectedOutput' : const (mode: PhoneCaseMode.UPPER_CASE, text: 'CF. H')},
      {'model': phoneModelByName(NAME_PHONEMODEL_NOKIA_1650), 'language': PhoneInputLanguage.GERMAN, 'input' : '222 # 333 1 0 44 5', 'expectedOutput' : const (mode: PhoneCaseMode.UPPER_CASE, text: 'CF. HJ')},

      {'model': phoneModelByName(NAME_PHONEMODEL_SIEMENS_A65), 'language': PhoneInputLanguage.GERMAN, 'input' : '', 'expectedOutput' : const (mode: PhoneCaseMode.LOWER_CASE, text: '')},
      {'model': phoneModelByName(NAME_PHONEMODEL_SIEMENS_A65), 'language': PhoneInputLanguage.GERMAN, 'input' : '#', 'expectedOutput' : const (mode: PhoneCaseMode.CAMEL_CASE, text: '')},
      {'model': phoneModelByName(NAME_PHONEMODEL_SIEMENS_A65), 'language': PhoneInputLanguage.GERMAN, 'input' : '##', 'expectedOutput' : const (mode: PhoneCaseMode.NUMBERS, text: '')},
      {'model': phoneModelByName(NAME_PHONEMODEL_SIEMENS_A65), 'language': PhoneInputLanguage.GERMAN, 'input' : '# #', 'expectedOutput' : const (mode: PhoneCaseMode.NUMBERS, text: '')},
      {'model': phoneModelByName(NAME_PHONEMODEL_SIEMENS_A65), 'language': PhoneInputLanguage.GERMAN, 'input' : '# ##', 'expectedOutput' : const (mode: PhoneCaseMode.LOWER_CASE, text: '')},
      {'model': phoneModelByName(NAME_PHONEMODEL_SIEMENS_A65), 'language': PhoneInputLanguage.GERMAN, 'input' : '## 222 333', 'expectedOutput' : const (mode: PhoneCaseMode.NUMBERS, text: '222333')},
      {'model': phoneModelByName(NAME_PHONEMODEL_SIEMENS_A65), 'language': PhoneInputLanguage.GERMAN, 'input' : '# # 222 333', 'expectedOutput' : const (mode: PhoneCaseMode.NUMBERS, text: '222333')},
      {'model': phoneModelByName(NAME_PHONEMODEL_SIEMENS_A65), 'language': PhoneInputLanguage.GERMAN, 'input' : '## # 222 333', 'expectedOutput' : const (mode: PhoneCaseMode.LOWER_CASE, text: 'cf')},
      {'model': phoneModelByName(NAME_PHONEMODEL_SIEMENS_A65), 'language': PhoneInputLanguage.GERMAN, 'input' : '222 #', 'expectedOutput' : const (mode: PhoneCaseMode.CAMEL_CASE, text: 'c')},
      {'model': phoneModelByName(NAME_PHONEMODEL_SIEMENS_A65), 'language': PhoneInputLanguage.GERMAN, 'input' : '222 # 333', 'expectedOutput' : const (mode: PhoneCaseMode.LOWER_CASE, text: 'cF')},
      {'model': phoneModelByName(NAME_PHONEMODEL_SIEMENS_A65), 'language': PhoneInputLanguage.GERMAN, 'input' : '222 ## 333', 'expectedOutput' : const (mode: PhoneCaseMode.LOWER_CASE, text: 'cf')},
      {'model': phoneModelByName(NAME_PHONEMODEL_SIEMENS_A65), 'language': PhoneInputLanguage.GERMAN, 'input' : '222 # # 333', 'expectedOutput' : const (mode: PhoneCaseMode.LOWER_CASE, text: 'cf')},
      {'model': phoneModelByName(NAME_PHONEMODEL_SIEMENS_A65), 'language': PhoneInputLanguage.GERMAN, 'input' : '222 # ##', 'expectedOutput' : const (mode: PhoneCaseMode.CAMEL_CASE, text: 'c')},
      {'model': phoneModelByName(NAME_PHONEMODEL_SIEMENS_A65), 'language': PhoneInputLanguage.GERMAN, 'input' : '222 ### #', 'expectedOutput' : const (mode: PhoneCaseMode.NUMBERS, text: 'c')},
      {'model': phoneModelByName(NAME_PHONEMODEL_SIEMENS_A65), 'language': PhoneInputLanguage.GERMAN, 'input' : '222 ### # 333', 'expectedOutput' : const (mode: PhoneCaseMode.NUMBERS, text: 'c333')},
      {'model': phoneModelByName(NAME_PHONEMODEL_SIEMENS_A65), 'language': PhoneInputLanguage.GERMAN, 'input' : '222 #### 333 ##', 'expectedOutput' : const (mode: PhoneCaseMode.CAMEL_CASE, text: 'c333')},
      {'model': phoneModelByName(NAME_PHONEMODEL_SIEMENS_A65), 'language': PhoneInputLanguage.GERMAN, 'input' : '222 ## ## 333 ## 44', 'expectedOutput' : const (mode: PhoneCaseMode.LOWER_CASE, text: 'c333H')},
      {'model': phoneModelByName(NAME_PHONEMODEL_SIEMENS_A65), 'language': PhoneInputLanguage.GERMAN, 'input' : '222 # ### 333 ## 44 #', 'expectedOutput' : const (mode: PhoneCaseMode.UPPER_CASE, text: 'c333H')},
      {'model': phoneModelByName(NAME_PHONEMODEL_SIEMENS_A65), 'language': PhoneInputLanguage.GERMAN, 'input' : '222   ###   # 333    ##   44 # 5', 'expectedOutput' : const (mode: PhoneCaseMode.UPPER_CASE, text: 'c333HJ')},
      {'model': phoneModelByName(NAME_PHONEMODEL_SIEMENS_A65), 'language': PhoneInputLanguage.GERMAN, 'input' : '222 ### # 333 ## 44 # 5 0', 'expectedOutput' : const (mode: PhoneCaseMode.UPPER_CASE, text: 'c333HJ.')},
      {'model': phoneModelByName(NAME_PHONEMODEL_SIEMENS_A65), 'language': PhoneInputLanguage.GERMAN, 'input' : '222 ### # 333 ## 44 # 5 0 #', 'expectedOutput' : const (mode: PhoneCaseMode.LOWER_CASE, text: 'c333HJ.')},
      {'model': phoneModelByName(NAME_PHONEMODEL_SIEMENS_A65), 'language': PhoneInputLanguage.GERMAN, 'input' : '222 ### # 333 ## 44 # 5 0 # 1', 'expectedOutput' : const (mode: PhoneCaseMode.CAMEL_CASE, text: 'c333HJ. ')},
      {'model': phoneModelByName(NAME_PHONEMODEL_SIEMENS_A65), 'language': PhoneInputLanguage.GERMAN, 'input' : '222 ### # 333 ## 44 # 5 0 # 1 7777', 'expectedOutput' : const (mode: PhoneCaseMode.LOWER_CASE, text: 'c333HJ. S')},
      {'model': phoneModelByName(NAME_PHONEMODEL_SIEMENS_A65), 'language': PhoneInputLanguage.GERMAN, 'input' : '222 ### # 333 ## 44 # 5 0 # 1 7777 6', 'expectedOutput' : const (mode: PhoneCaseMode.LOWER_CASE, text: 'c333HJ. Sm')},
      {'model': phoneModelByName(NAME_PHONEMODEL_SIEMENS_A65), 'language': PhoneInputLanguage.GERMAN, 'input' : '222 ### # 333 ## 44 # 5 0 # 1 7777 ****', 'expectedOutput' : const (mode: PhoneCaseMode.LOWER_CASE, text: 'c333HJ. S_')},

      {'model': phoneModelByName(NAME_PHONEMODEL_SAMSUNG_E1120), 'language': PhoneInputLanguage.GERMAN, 'input' : '', 'expectedOutput' : const (mode: PhoneCaseMode.CAMEL_CASE, text: '')},
      {'model': phoneModelByName(NAME_PHONEMODEL_SAMSUNG_E1120), 'language': PhoneInputLanguage.GERMAN, 'input' : '*', 'expectedOutput' : const (mode: PhoneCaseMode.UPPER_CASE, text: '')},
      {'model': phoneModelByName(NAME_PHONEMODEL_SAMSUNG_E1120), 'language': PhoneInputLanguage.GERMAN, 'input' : '**', 'expectedOutput' : const (mode: PhoneCaseMode.LOWER_CASE, text: '')},
      {'model': phoneModelByName(NAME_PHONEMODEL_SAMSUNG_E1120), 'language': PhoneInputLanguage.GERMAN, 'input' : '222 *', 'expectedOutput' : const (mode: PhoneCaseMode.NUMBERS, text: 'C')},
      {'model': phoneModelByName(NAME_PHONEMODEL_SAMSUNG_E1120), 'language': PhoneInputLanguage.GERMAN, 'input' : '222 * 333', 'expectedOutput' : const (mode: PhoneCaseMode.NUMBERS, text: 'C333')},
      {'model': phoneModelByName(NAME_PHONEMODEL_SAMSUNG_E1120), 'language': PhoneInputLanguage.GERMAN, 'input' : '222 * * 333', 'expectedOutput' : const (mode: PhoneCaseMode.LOWER_CASE, text: 'CF')},
      {'model': phoneModelByName(NAME_PHONEMODEL_SAMSUNG_E1120), 'language': PhoneInputLanguage.GERMAN, 'input' : '222 * * 333 44', 'expectedOutput' : const (mode: PhoneCaseMode.LOWER_CASE, text: 'CFh')},
      {'model': phoneModelByName(NAME_PHONEMODEL_SAMSUNG_E1120), 'language': PhoneInputLanguage.GERMAN, 'input' : '#', 'expectedOutput' : const (mode: PhoneCaseMode.LOWER_CASE, text: ' ')},
      {'model': phoneModelByName(NAME_PHONEMODEL_SAMSUNG_E1120), 'language': PhoneInputLanguage.GERMAN, 'input' : '##', 'expectedOutput' : const (mode: PhoneCaseMode.LOWER_CASE, text: '  ')},
      {'model': phoneModelByName(NAME_PHONEMODEL_SAMSUNG_E1120), 'language': PhoneInputLanguage.GERMAN, 'input' : '222 #', 'expectedOutput' : const (mode: PhoneCaseMode.LOWER_CASE, text: 'C ')},
      {'model': phoneModelByName(NAME_PHONEMODEL_SAMSUNG_E1120), 'language': PhoneInputLanguage.GERMAN, 'input' : '222 # 333', 'expectedOutput' : const (mode: PhoneCaseMode.LOWER_CASE, text: 'C f')},
      {'model': phoneModelByName(NAME_PHONEMODEL_SAMSUNG_E1120), 'language': PhoneInputLanguage.GERMAN, 'input' : '222 ## 333', 'expectedOutput' : const (mode: PhoneCaseMode.LOWER_CASE, text: 'C  f')},
      {'model': phoneModelByName(NAME_PHONEMODEL_SAMSUNG_E1120), 'language': PhoneInputLanguage.GERMAN, 'input' : '222 1 # 333 44', 'expectedOutput' : const (mode: PhoneCaseMode.LOWER_CASE, text: 'C. Fh')},

      {'model': phoneModelByName(NAME_PHONEMODEL_MOTOROLA_V600), 'language': PhoneInputLanguage.EXTENDED, 'input' : '00 ## 9999 0 111 # * 0 22 5', 'expectedOutput' : const (mode: PhoneCaseMode.UPPER_CASE, text: '#+! BJ')},

      {'model': phoneModelByName(NAME_PHONEMODEL_NOKIA_1650), 'language': PhoneInputLanguage.GERMAN, 'input' : '222 AAA ## 333 a 1 0', 'expectedOutput' : const (mode: PhoneCaseMode.CAMEL_CASE, text: 'Cf. ')},
      {'model': phoneModelByName(NAME_PHONEMODEL_SIEMENS_A65), 'language': PhoneInputLanguage.GERMAN, 'input' : '222 ### # &%/()33mmmm3 ## 44 # 5 0 # 1 Abc 7777', 'expectedOutput' : const (mode: PhoneCaseMode.LOWER_CASE, text: 'c333HJ. S')},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}, model: ${elem['model']}, language: ${elem['language']}', () {
        var _actual = decodeVanityMultitap(elem['input'] as String, elem['model'] as PhoneModel, elem['language'] as PhoneInputLanguage);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("Vanity.encodeVanityMultitap:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'model': phoneModelByName(NAME_PHONEMODEL_NOKIA_6230), 'language': PhoneInputLanguage.GERMAN, 'input' : '', 'expectedOutput' : const (mode:  PhoneCaseMode.CAMEL_CASE, text: '')},

      {'model': PHONEMODEL_SIMPLE_SPACE_0, 'language': PhoneInputLanguage.UNSPECIFIED, 'input' : ' ABC. DEF0123 ', 'expectedOutput' : const (mode:  PhoneCaseMode.UPPER_CASE, text: '0 2 22 222 0 3 33 333 00 1 2222 3333 0')},
      {'model': PHONEMODEL_SIMPLE_SPACE_1, 'language': PhoneInputLanguage.UNSPECIFIED, 'input' : ' ABC. DEF0123 ', 'expectedOutput' : const (mode:  PhoneCaseMode.UPPER_CASE, text: '1 2 22 222 1 3 33 333 0 11 2222 3333 1')},
      {'model': PHONEMODEL_SIMPLE_SPACE_HASH, 'language': PhoneInputLanguage.UNSPECIFIED, 'input' : ' ABC. DEF0123 ', 'expectedOutput' : const (mode:  PhoneCaseMode.UPPER_CASE, text: '# 2 22 222 # 3 33 333 0 1 2222 3333 #')},

      {'model': phoneModelByName(NAME_PHONEMODEL_NOKIA_6230), 'language': PhoneInputLanguage.GERMAN, 'input' : 'Abc', 'expectedOutput' : const (mode:  PhoneCaseMode.LOWER_CASE, text: '2 22 222')},
      {'model': phoneModelByName(NAME_PHONEMODEL_NOKIA_6230), 'language': PhoneInputLanguage.GERMAN, 'input' : 'AB', 'expectedOutput' : const (mode:  PhoneCaseMode.UPPER_CASE, text: '2 # 22')},
      {'model': phoneModelByName(NAME_PHONEMODEL_NOKIA_6230), 'language': PhoneInputLanguage.GERMAN, 'input' : 'Abc. Abc', 'expectedOutput' : const (mode:  PhoneCaseMode.LOWER_CASE, text: '2 22 222 1 0 2 22 222')},
      {'model': phoneModelByName(NAME_PHONEMODEL_NOKIA_6230), 'language': PhoneInputLanguage.GERMAN, 'input' : 'AB? AB', 'expectedOutput' : const (mode:  PhoneCaseMode.UPPER_CASE, text: '2 # 22 111 0 2 # 22')},
      {'model': phoneModelByName(NAME_PHONEMODEL_NOKIA_6230), 'language': PhoneInputLanguage.GERMAN, 'input' : 'abc', 'expectedOutput' : const (mode:  PhoneCaseMode.LOWER_CASE, text: '# 2 22 222')},
      {'model': phoneModelByName(NAME_PHONEMODEL_NOKIA_6230), 'language': PhoneInputLanguage.GERMAN, 'input' : 'Abc. ab2', 'expectedOutput' : const (mode:  PhoneCaseMode.LOWER_CASE, text: '2 22 222 1 0 # 2 22 2222')},
      {'model': phoneModelByName(NAME_PHONEMODEL_NOKIA_6230), 'language': PhoneInputLanguage.GERMAN, 'input' : 'Ab.c ab', 'expectedOutput' : const (mode:  PhoneCaseMode.LOWER_CASE, text: '2 22 1 222 0 2 22')},

      {'model': phoneModelByName(NAME_PHONEMODEL_SIEMENS_S35), 'language': PhoneInputLanguage.DUTCH, 'input' : 'Abc', 'expectedOutput' : const (mode:  PhoneCaseMode.LOWER_CASE, text: '2 22 222')},
      {'model': phoneModelByName(NAME_PHONEMODEL_SIEMENS_S35), 'language': PhoneInputLanguage.DUTCH, 'input' : 'ABC', 'expectedOutput' : const (mode:  PhoneCaseMode.LOWER_CASE, text: '2 * 22 * 222')},
      {'model': phoneModelByName(NAME_PHONEMODEL_SIEMENS_S35), 'language': PhoneInputLanguage.DUTCH, 'input' : 'Abc. Abc', 'expectedOutput' : const (mode:  PhoneCaseMode.LOWER_CASE, text: '2 22 222 0000 1 * 2 22 222')},
      {'model': phoneModelByName(NAME_PHONEMODEL_SIEMENS_S35), 'language': PhoneInputLanguage.DUTCH, 'input' : 'A1B2', 'expectedOutput' : const (mode:  PhoneCaseMode.LOWER_CASE, text: '2 11 * 22 2222')},
      {'model': phoneModelByName(NAME_PHONEMODEL_SIEMENS_S35), 'language': PhoneInputLanguage.DUTCH, 'input' : 'a1B2', 'expectedOutput' : const (mode:  PhoneCaseMode.LOWER_CASE, text: '* 2 11 * 22 2222')},

      {'model': phoneModelByName(NAME_PHONEMODEL_MOTOROLA_CD930), 'language': PhoneInputLanguage.UNSPECIFIED, 'input' : 'A1B2', 'expectedOutput' : const (mode:  PhoneCaseMode.UPPER_CASE, text: '2 111 22 2222')},
      {'model': phoneModelByName(NAME_PHONEMODEL_MOTOROLA_CD930), 'language': PhoneInputLanguage.UNSPECIFIED, 'input' : 'a1B2c', 'expectedOutput' : const (mode:  PhoneCaseMode.UPPER_CASE, text: '111 22 2222')},

      {'model': phoneModelByName(NAME_PHONEMODEL_MOTOROLA_V600), 'language': PhoneInputLanguage.EXTENDED, 'input' : 'Abc', 'expectedOutput' : const (mode:  PhoneCaseMode.LOWER_CASE, text: '2 22 222')},
      {'model': phoneModelByName(NAME_PHONEMODEL_MOTOROLA_V600), 'language': PhoneInputLanguage.EXTENDED, 'input' : 'AB', 'expectedOutput' : const (mode:  PhoneCaseMode.LOWER_CASE, text: '2 0 22')},
      {'model': phoneModelByName(NAME_PHONEMODEL_MOTOROLA_V600), 'language': PhoneInputLanguage.EXTENDED, 'input' : 'Abc. Abc', 'expectedOutput' : const (mode:  PhoneCaseMode.LOWER_CASE, text: '2 22 222 1 * 2 22 222')},
      {'model': phoneModelByName(NAME_PHONEMODEL_MOTOROLA_V600), 'language': PhoneInputLanguage.EXTENDED, 'input' : 'Ab.c aB', 'expectedOutput' : const (mode:  PhoneCaseMode.LOWER_CASE, text: '2 22 1 222 * 2 0 22')},
      {'model': phoneModelByName(NAME_PHONEMODEL_MOTOROLA_V600), 'language': PhoneInputLanguage.EXTENDED, 'input' : '%>?A14Bz&%! c', 'expectedOutput' : const (mode:  PhoneCaseMode.LOWER_CASE, text: '11111111111111111111 1111111111111111111111111111111111 11 0 2 1111111111111111 4444 0 22 9999 1111111111111 11111111111111111111 111 * 00 222')},

      {'model': phoneModelByName(NAME_PHONEMODEL_SIEMENS_C75), 'language': PhoneInputLanguage.ENGLISH, 'input' : 'Alle meine Entchen', 'expectedOutput' : const (mode:  PhoneCaseMode.LOWER_CASE, text: '2 555 555 33 1 6 33 444 66 33 1 # 33 66 8 222 44 33 66')},

      {'model': phoneModelByName(NAME_PHONEMODEL_NOKIA_6230), 'language': PhoneInputLanguage.GERMAN, 'input' : 'AẄb', 'expectedOutput' : const (mode:  PhoneCaseMode.LOWER_CASE, text: '2 22')},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}, model: ${elem['model']}, language: ${elem['language']}', () {
        var _actual = encodeVanityMultitap(elem['input'] as String, elem['model'] as PhoneModel, elem['language'] as PhoneInputLanguage);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("Vanity.reverseEncodeVanityMultitap:", () {
    List<Map<String, Object?>> _inputsToExpected = [
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

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}, model: ${elem['model']}, language: ${elem['language']}', () {
        var _actual = decodeVanityMultitap(elem['input'] as String, elem['model'] as PhoneModel, elem['language'] as PhoneInputLanguage);
        expect(_actual?.text, elem['expectedOutput']);
      });
    }
  });
}