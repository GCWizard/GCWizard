import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/science_and_technology/ufi/logic/ufi.dart';

void main() {
  List<Map<String, Object>> _testCases = [
    {'countryCode' : 'AT', 'vatNumber': 'U12345678', 'formulationNumber': 178956970, 'ufi' : 'C23S-PQ2V-AMH9-VVRF'},
    {'countryCode' : 'BE', 'vatNumber': '0987654321', 'formulationNumber': 89478485, 'ufi' : 'U1JV-SUMH-N988-U751'},
    {'countryCode' : 'BG', 'vatNumber': '987654321', 'formulationNumber': 89478485, 'ufi' : 'A1JV-EUD3-498W-U23R'},
    {'countryCode' : 'BG', 'vatNumber': '9987654321', 'formulationNumber': 252644556, 'ufi' : '80SW-N2UD-FGRY-F6DA'},
    {'countryCode' : 'CZ', 'vatNumber': '81726354', 'formulationNumber': 156920229, 'ufi' : 'HKC1-Q7N0-DKF6-7N3E'},
    {'countryCode' : 'CZ', 'vatNumber': '978563421', 'formulationNumber': 15790899, 'ufi' : '24VQ-VGV0-WF16-7WC9'},
    {'countryCode' : 'CZ', 'vatNumber': '9785634210', 'formulationNumber': 268435455, 'ufi' : 'W3NN-SKC4-JXSS-V4WG'},
    {'countryCode' : 'CY', 'vatNumber': '12345678C', 'formulationNumber': 87654321, 'ufi' : '7EHW-3KC7-748V-S1RH'},
    {'countryCode' : 'CY', 'vatNumber': '12345678Y', 'formulationNumber': 87654321, 'ufi' : 'FEHW-3KH5-X487-SNRD'},
    {'countryCode' : 'DE', 'vatNumber': '112358132', 'formulationNumber': 134217728, 'ufi' : 'KMTT-DSP3-7FD7-6RWY'},
    {'countryCode' : 'DK', 'vatNumber': '31415926', 'formulationNumber': 524544, 'ufi' : '3FQU-5GP0-Y105-J64N'},
    {'countryCode' : 'EE', 'vatNumber': '271828182', 'formulationNumber': 230087533, 'ufi' : 'QY3Q-327C-QDPR-EE11'},
    {'countryCode' : 'FR', 'vatNumber': 'RF987654321', 'formulationNumber': 134217728, 'ufi' : '6KTT-PSK1-AFDM-KEFU'},
    {'countryCode' : 'FR', 'vatNumber': 'ZY999999999', 'formulationNumber': 230087533, 'ufi' : 'NX3Q-2263-2DP5-UQ4T'},
    {'countryCode' : 'FR', 'vatNumber': '01012345678', 'formulationNumber': 268435455, 'ufi' : 'F3NN-3K1J-EXSK-7PHY'},
    {'countryCode' : 'FR', 'vatNumber': '10012345678', 'formulationNumber': 268435455, 'ufi' : '23NN-5KKE-GXSF-7MD3'},
    {'countryCode' : 'GB', 'vatNumber': '987654321', 'formulationNumber': 156920229, 'ufi' : 'GJC1-S7TH-AKFK-TR8P'},
    {'countryCode' : 'GB', 'vatNumber': '999987654321', 'formulationNumber': 156920229, 'ufi' : 'CJC1-47ES-AKFS-WTFW'},
    {'countryCode' : 'GB', 'vatNumber': '999999999999', 'formulationNumber': 156920229, 'ufi' : '3JC1-47ET-6KFH-WMV8'},
    {'countryCode' : 'GB', 'vatNumber': 'ZY123', 'formulationNumber': 268435455, 'ufi' : '53NN-7KTT-1XS1-DDPH'},
    {'countryCode' : 'GB', 'vatNumber': 'AB987', 'formulationNumber': 268435455, 'ufi' : 'M3NN-7KTS-YXSK-D8UW'},
    {'countryCode' : 'XN', 'vatNumber': '987654321', 'formulationNumber': 156920229, 'ufi' : 'GJC1-S7TH-AKFK-TR8P'},
    {'countryCode' : 'XN', 'vatNumber': '999987654321', 'formulationNumber': 156920229, 'ufi' : 'CJC1-47ES-AKFS-WTFW'},
    {'countryCode' : 'XN', 'vatNumber': '999999999999', 'formulationNumber': 156920229, 'ufi' : '3JC1-47ET-6KFH-WMV8'},
    {'countryCode' : 'XN', 'vatNumber': 'ZY123', 'formulationNumber': 268435455, 'ufi' : '53NN-7KTT-1XS1-DDPH'},
    {'countryCode' : 'XN', 'vatNumber': 'AB987', 'formulationNumber': 268435455, 'ufi' : 'M3NN-7KTS-YXSK-D8UW'},
    {'countryCode' : 'GR', 'vatNumber': '567438921', 'formulationNumber': 66260700, 'ufi' : 'QNWM-9X6E-E46N-G4GJ'},
    {'countryCode' : 'EL', 'vatNumber': '567438921', 'formulationNumber': 66260700, 'ufi' : 'QNWM-9X6E-E46N-G4GJ'},
    {'countryCode' : 'FI', 'vatNumber': '18273645', 'formulationNumber': 29979245, 'ufi' : 'VWF9-CDT4-2S2N-PDTV'},
    {'countryCode' : 'HR', 'vatNumber': '16021765654', 'formulationNumber': 268435455, 'ufi' : '53NN-KKPX-SXSD-QJY7'},
    {'countryCode' : 'HU', 'vatNumber': '22334455', 'formulationNumber': 238219293, 'ufi' : 'AU06-7HHD-64QN-8RHF'},
    {'countryCode' : 'IE', 'vatNumber': '9Z54321Y', 'formulationNumber': 134217728, 'ufi' : 'GMTT-2SQN-6FDD-6TV1'},
    {'countryCode' : 'IE', 'vatNumber': '9+54321Y', 'formulationNumber': 134217728, 'ufi' : 'KMTT-2SQQ-0FDQ-6A5D'},
    {'countryCode' : 'IE', 'vatNumber': '9*54321Y', 'formulationNumber': 134217728, 'ufi' : 'GMTT-2SQR-UFD0-6TFR'},
    {'countryCode' : 'IE', 'vatNumber': '9876543Z', 'formulationNumber': 230087533, 'ufi' : 'JY3Q-R2M8-GDP2-DQRS'},
    {'countryCode' : 'IE', 'vatNumber': '9876543ZW', 'formulationNumber': 230087533, 'ufi' : 'XY3Q-S215-2DPF-DA4U'},
    {'countryCode' : 'IE', 'vatNumber': '9876543AB', 'formulationNumber': 182319099, 'ufi' : 'TUG4-PE6C-4XHP-RSAM'},
    {'countryCode' : 'IS', 'vatNumber': 'AB3D5F', 'formulationNumber': 182319099, 'ufi' : 'XUG4-WE32-RXHD-RHWU'},
    {'countryCode' : 'IS', 'vatNumber': '1ZY2BA', 'formulationNumber': 268435455, 'ufi' : '53NN-1KDC-JXSH-W6WV'},
    {'countryCode' : 'IT', 'vatNumber': '14286244833', 'formulationNumber': 214783315, 'ufi' : 'WK3F-PYSX-TXM0-K9AV'},
    {'countryCode' : 'LI', 'vatNumber': '99999', 'formulationNumber': 182319099, 'ufi' : 'CUG4-FEHP-HXHW-SC4E'},
    {'countryCode' : 'LT', 'vatNumber': '987654321', 'formulationNumber': 15790899, 'ufi' : 'W3VQ-HGW8-UF12-W7QP'},
    {'countryCode' : 'LT', 'vatNumber': '987654321098', 'formulationNumber': 156920229, 'ufi' : 'SJC1-P7FR-DKF3-Y2YC'},
    {'countryCode' : 'LU', 'vatNumber': '16726218', 'formulationNumber': 214783315, 'ufi' : 'FK3F-8YC6-1XMK-SAQ5'},
    {'countryCode' : 'LV', 'vatNumber': '39903127176', 'formulationNumber': 182319099, 'ufi' : 'WUG4-5E2S-UXHN-M5C7'},
    {'countryCode' : 'MT', 'vatNumber': '99887766', 'formulationNumber': 83144621, 'ufi' : '7KW0-SMM5-2Q7N-4K8D'},
    {'countryCode' : 'NL', 'vatNumber': '999999999B77', 'formulationNumber': 96485337, 'ufi' : 'QJ0V-J1JU-9Y8W-37TG'},
    {'countryCode' : 'NO', 'vatNumber': '958473621', 'formulationNumber': 268435455, 'ufi' : '63NN-7KPT-WXS8-WGYA'},
    {'countryCode' : 'PL', 'vatNumber': '4835978701', 'formulationNumber': 19621109, 'ufi' : 'XRMW-9HU2-PT1U-7JNN'},
    {'countryCode' : 'PT', 'vatNumber': '998776554', 'formulationNumber': 30051977, 'ufi' : 'K9WS-JKK3-WS2E-1WSC'},
    {'countryCode' : 'RO', 'vatNumber': '98', 'formulationNumber': 252644556, 'ufi' : 'E0SW-U2CF-KGR6-FRKW'},
    {'countryCode' : 'RO', 'vatNumber': '9081726354', 'formulationNumber': 214783315, 'ufi' : '2K3F-QYHK-YXMU-RTN5'},
    {'countryCode' : 'SE', 'vatNumber': '987654321098', 'formulationNumber': 156920229, 'ufi' : '1KC1-87DH-0KFR-2WGE'},
    {'countryCode' : 'SI', 'vatNumber': '12345678', 'formulationNumber': 178956970, 'ufi' : 'U23S-WQK5-AMH7-V03N'},
    {'countryCode' : 'SK', 'vatNumber': '9987654321', 'formulationNumber': 252644556, 'ufi' : 'N0SW-W2AP-FGRV-F9RH'},
    {'countryCode' : 'ufi_companykey', 'vatNumber': '1828639338661', 'formulationNumber': 156920229, 'ufi' : 'NJC1-671A-UKF3-J0M8'},
  ];

  group("UFI.encodeUFI:", () {
    for (var elem in _testCases) {
      test('countryCode: ${elem['countryCode']}, vatNumber: ${elem['vatNumber']}, formulationNumber: ${elem['formulationNumber']}', () {
        var _actual = encodeUFI(UFI(countryCode: elem['countryCode'] as String, vatNumber: elem['vatNumber'] as String, formulationNumber: elem['formulationNumber'].toString()));
        expect(_actual, elem['ufi']);
      });
    }
  });

  group("UFI.decodeUFI:", () {
    for (var elem in _testCases) {
      test('ufi: ${elem['ufi']}, countryCode: ${elem['countryCode']}, vatNumber: ${elem['vatNumber']}, formulationNumber: ${elem['formulationNumber']}', () {
        var _actual = decodeUFI(elem['ufi'] as String);
        var _countryCode = elem['countryCode'] as String?;
        switch (_countryCode) {
          case 'EL': _countryCode = 'GR'; break;
          case 'XN': _countryCode = 'GB'; break;
          default: break;
        }
        expect(_actual.countryCode, _countryCode);
        expect(_actual.vatNumber, elem['vatNumber'] as String);
        expect(_actual.formulationNumber, elem['formulationNumber'].toString());
      });
    }
  });
}