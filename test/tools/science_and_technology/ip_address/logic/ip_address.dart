import "package:flutter_test/flutter_test.dart";
import "package:gc_wizard/tools/science_and_technology/ip_address/logic/ip_address.dart";

void main() {
  group("IPAddress.validateIP", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '0.0.0.0', 'expectedOutput' : true},
      {'input' : '255.255.255.255', 'expectedOutput' : true},
      {'input' : '192.168.1.188', 'expectedOutput' : true},
      {'input' : '...', 'expectedOutput' : true}, // == 0.0.0.0
      {'input' : '192..1.188', 'expectedOutput' : true},
      {'input' : '.168.1.188', 'expectedOutput' : true},
      {'input' : '192.168.1.', 'expectedOutput' : true},

      {'input' : '', 'expectedOutput' : false},
      {'input' : '192', 'expectedOutput' : false},
      {'input' : '192.-168.1.188', 'expectedOutput' : false},
      {'input' : '192,168,1,188', 'expectedOutput' : false},
      {'input' : '-192.168.1.188', 'expectedOutput' : false},
      {'input' : '192.756.1.188', 'expectedOutput' : false},
      {'input' : '192.756.1', 'expectedOutput' : false},
      {'input' : '192.756.1.', 'expectedOutput' : false},
      {'input' : '192.756.1A.188', 'expectedOutput' : false},
      {'input' : 'A.756.1.188', 'expectedOutput' : false},
      {'input' : '192.756.1.188.42', 'expectedOutput' : false},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = IP.fromString(elem['input'] as String);
        expect(_actual.isValid, elem['expectedOutput'] as bool);
      });
    }
  });

  group("IPAddress.validateSubnetMask", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '0.0.0.0', 'expectedOutput' : true},
      {'input' : '255.255.255.255', 'expectedOutput' : true},
      {'input' : '240.0.0.0', 'expectedOutput' : true},
      {'input' : '255.0.0.0', 'expectedOutput' : true},
      {'input' : '255.255.192.0', 'expectedOutput' : true},

      {'input' : '255.255.193.0', 'expectedOutput' : false},
      {'input' : '255.255.193.0', 'expectedOutput' : false},
      {'input' : '255.255.192.1', 'expectedOutput' : false},
      {'input' : '254.255.192.0', 'expectedOutput' : false},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = IPSubnetMask(IP.fromString(elem['input'] as String));
        expect(_actual.isValid, elem['expectedOutput'] as bool);
      });
    }
  });

  group("IPAddress.ipFromBinary", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'expectedOutput' : 'invalid'},
      {'input' : '11000000.10101000.00000001.10111100', 'expectedOutput' : '192.168.1.188'},
      {'input' : '...', 'expectedOutput' : '0.0.0.0'},
      {'input' : '.000.10100001.', 'expectedOutput' : '0.0.161.0'},
      {'input' : '11111111.000.10100001.00000000', 'expectedOutput' : '255.0.161.0'},
      {'input' : '11111111.000.10100001.100000000', 'expectedOutput' : 'invalid'},
      {'input' : '111111', 'expectedOutput' : 'invalid'},
      {'input' : '111111.', 'expectedOutput' : 'invalid'},
      {'input' : '111111...', 'expectedOutput' : '63.0.0.0'},
      {'input' : '1111111111111111111111111111111111111111111', 'expectedOutput' : 'invalid'},
      {'input' : '10001010.11001001.01001001.11011011', 'expectedOutput' : '138.201.73.219'},
      {'input' : '100010100.11001001.01001001.11011011', 'expectedOutput' : 'invalid'},
      {'input' : '10001012.11001001.01001001.11011011', 'expectedOutput' : 'invalid'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = IP.fromBinaryString(elem['input'] as String);
        if (_actual.isValid) {
          expect(_actual.toString(), elem['expectedOutput'] as String);
        } else {
          expect('invalid', elem['expectedOutput'] as String);
        }
      });
    }
  });

  group("IPAddress.ipToBinary", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'expectedOutput' : '00000000.00000000.00000000.00000000', 'input' : '0.0.0.0'},
      {'expectedOutput' : '11000000.10101000.00000001.10111100', 'input' : '192.168.1.188'},
      {'expectedOutput' : '10001010.11001001.01001001.11011011', 'input' : '138.201.73.219'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = IP.fromString(elem['input'] as String);
        expect(_actual.toBinaryString(), elem['expectedOutput'] as String);
      });
    }
  });

  group("IPAddress.subnetMaskFromBits", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : 0, 'expectedOutput' : '0.0.0.0'},
      {'input' : 32, 'expectedOutput' : '255.255.255.255'},
      {'input' : 24, 'expectedOutput' : '255.255.255.0'},
      {'input' : 27, 'expectedOutput' : '255.255.255.224'},
      {'input' : 12, 'expectedOutput' : '255.240.0.0'},
      {'input' : -1, 'expectedOutput' : 'invalid'},
      {'input' : 33, 'expectedOutput' : 'invalid'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = IPSubnetMask.fromBits(elem['input'] as int);
        if (_actual.isValid) {
          expect(_actual.subnet.toString(), elem['expectedOutput'] as String);
        } else {
          expect('invalid', elem['expectedOutput'] as String);
        }
      });
    }
  });

  group("IPAddress.subnetMaskToBits", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'expectedOutput' : 0, 'input' : '0.0.0.0'},
      {'expectedOutput' : 32, 'input' : '255.255.255.255'},
      {'expectedOutput' : 24, 'input' : '255.255.255.0'},
      {'expectedOutput' : 27, 'input' : '255.255.255.224'},
      {'expectedOutput' : 12, 'input' : '255.240.0.0'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = IPSubnetMask(IP.fromString(elem['input'] as String));
        expect(_actual.toBits(), elem['expectedOutput'] as int);
      });
    }
  });

  group("IPAddress.subnetMaskToBits", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {
        'inputIP' : '192.168.1.188',
        'inputSubnetMask': '255.255.255.224',
        'expectedNetwork' : '192.168.1.160/27',
        'expectedBroadcast': '192.168.1.191',
        'expectedStart': '192.168.1.161',
        'expectedEnd': '192.168.1.190',
        'expectedTotalIPs': 32,
        'expectedUsableIPs': 30,
        'expectedNetworkClass': 'C',
      },
      {
        'inputIP' : '192.168.1.188',
        'inputSubnetMask': '255.255.255.254',
        'expectedNetwork' : '192.168.1.188/31',
        'expectedBroadcast': '192.168.1.189',
        'expectedStart': '192.168.1.188',
        'expectedEnd': '192.168.1.189',
        'expectedTotalIPs': 2,
        'expectedUsableIPs': 2,
        'expectedNetworkClass': 'C',
      },
      {
        'inputIP' : '192.168.1.188',
        'inputSubnetMask': '255.255.255.255',
        'expectedNetwork' : '192.168.1.188/32',
        'expectedBroadcast': '',
        'expectedStart': '',
        'expectedEnd': '',
        'expectedTotalIPs': 1,
        'expectedUsableIPs': 0,
        'expectedNetworkClass': 'C',
      },
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var ip = (IP.fromString(elem['inputIP'] as String));
        var mask = (IPSubnetMask(IP.fromString(elem['inputSubnetMask'] as String)));
        var _actual = ipSubnet(ip, mask);
        expect(_actual.networkNameIPPart.toString() + '/' + _actual.subnetMask.toBits().toString(), elem['expectedNetwork'] as String);
        expect((_actual.broadcastIP ?? '').toString(), elem['expectedBroadcast'] as String);
        expect((_actual.startIP ?? '').toString(), elem['expectedStart'] as String);
        expect((_actual.endIP ?? '').toString(), elem['expectedEnd'] as String);
        expect(_actual.totalNumbersIPs, elem['expectedTotalIPs'] as int);
        expect(_actual.usableNumberIPs, elem['expectedUsableIPs'] as int);
        expect(_actual.networkClass, elem['expectedNetworkClass'] as String);
      });
    }
  });
}