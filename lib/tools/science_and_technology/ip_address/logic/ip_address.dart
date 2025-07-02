import 'dart:math';

import 'package:gc_wizard/utils/string_utils.dart';
import 'package:pointycastle/asn1.dart';

class IP {
  late final bool isValid;
  final List<int> ipBlocks;

  IP(this.ipBlocks, {bool? valid}) {
    var _valid = valid ?? true;

    if (ipBlocks.length != 4) {
      _valid = false;
    }

    for (int i in ipBlocks) {
      if (i < 0 || i >= 256) {
        _valid = false;
      }
    }

    isValid = _valid;
  }

  static IP fromBinaryString(String binaryIP) {
    var binary = binaryIP.replaceAll(RegExp(r'[^01\.]'), '');
    var _valid = true;

    if (binary.length != binaryIP.length) {
      _valid = false;
    }

    if (binary.isEmpty) {
      binary = '0';
    }

    var binBlocks = binary.split('.').toList();
    if (binBlocks.length != 4) {
      _valid = false;
    }

    var binChunks = <int>[];
    for (String block in binBlocks) {
      if (block.isEmpty) {
        block = '0';
      }
      var i = int.parse(block, radix: 2);
      if (i < 0 || i >= 256) {
        _valid = false;
      }
      binChunks.add(i);
    }

    return IP(binChunks, valid: _valid);
  }

  static IP fromString(String ip) {
    var isValid = true;
    var str = ip.replaceAll(RegExp(r'[^\d\.]'), '');
    if (str.length != ip.length) {
      isValid = false;
    }

    var blocks = str
        .split('.')
        .map((String chunk) => int.tryParse(chunk) ?? 0)
        .toList();

    return IP(blocks, valid: isValid);
  }

  List<String> _toBinaryBlocks() {
    return ipBlocks.map((int block) => block.toRadixString(2).padLeft(8, '0')).toList();
  }

  String toBinary() {
    return _toBinaryBlocks().join('');
  }

  String toBinaryString() {
    return _toBinaryBlocks().join('.');
  }

  @override
  String toString() {
    return ipBlocks.join('.');
  }
}

class IPSubnetMask {
  final IP subnet;
  late final bool isValid;

  IPSubnetMask(this.subnet, {bool? valid}) {
    var _valid = valid ?? true;

    if (!subnet.isValid) {
      _valid = false;
    }

    if (trimCharactersRight(subnet.toBinary(), '0').contains('0')) {
      _valid = false;
    }

    isValid = _valid;
  }

  static IPSubnetMask fromBits(int bits) {
    var isValid = true;

    if (bits < 0 || bits > 32) {
      isValid = false;
    }

    var bin = ('1' * bits).padRight(32, '0');
    bin = insertEveryNthCharacter(bin, 8, '.');
    IP subnetIP = IP.fromBinaryString(bin);
    return IPSubnetMask(subnetIP, valid: isValid);
  }

  int toBits() {
    var bin = subnet.toBinary();
    return trimCharactersRight(bin, '0').length;
  }

  @override
  String toString() {
    return subnet.toString() + ' (' + toBits().toString() + ')';
  }
}

class IPSubnet {
  IP networkNameIPPart;
  IPSubnetMask subnetMask;
  IP? broadcastIP;
  IP? startIP;
  IP? endIP;
  String? networkClass;
  int usableNumberIPs;
  int totalNumbersIPs;

  IPSubnet({
    required this.networkNameIPPart,
    required this.subnetMask,
    required this.broadcastIP,
    required this.startIP,
    required this.endIP,
    required this.networkClass,
    required this.usableNumberIPs,
    required this.totalNumbersIPs,
  });

  @override
  String toString() {
    return
      'Netmask: $subnetMask (${subnetMask.toBits()})\n'
        'Network: $networkNameIPPart/${subnetMask.toBits()}\n'
        'Broadcast: $broadcastIP\n'
        'StartIP: $startIP\n'
        'EndIP: $endIP\n'
        'Usable IPs: $usableNumberIPs\n'
        'Uotal IPs: $totalNumbersIPs\n'
        'Class: $networkClass\n';
  }
}

IP _networkName(IP ip, IPSubnetMask mask) {
  var blocks = <int>[];
  for (int i = 0; i < 4; i++) {
    blocks.add(ip.ipBlocks[i] & mask.subnet.ipBlocks[i]);
  }

  return IP(blocks);
}

String? _networkClass(IP ip) {
  var bin = ip.toBinary();

  if (bin.startsWith('0')) return 'A';
  if (bin.startsWith('10')) return 'B';
  if (bin.startsWith('110')) return 'C';
  if (bin.startsWith('1110')) return 'D';
  if (bin.startsWith('1111')) return 'E';

  return null;
}

IP _addIP(IP ip, int value) {
  var binIn = ip.toBinary();
  var i = int.parse(binIn, radix: 2) + value;
  var binOut = i.toRadixString(2).padLeft(32, '0');
  return IP.fromBinaryString(insertEveryNthCharacter(binOut, 8, '.'));
}

IPSubnet ipSubnet(IP ip, IPSubnetMask subnetMask) {
  if (!ip.isValid || !subnetMask.isValid) {
    throw Exception();
  }

  var subnetBits = subnetMask.toBits();
  var networkName = _networkName(ip, subnetMask);
  int totalNumbersIPs = pow(2, 32 - subnetBits).toInt();

  IP? startIP;
  IP? endIP;
  IP? broadcastIP;
  int usableNumbersIPs = 0;
  if (subnetBits < 32) {
    usableNumbersIPs = subnetBits == 31 ? 2 : totalNumbersIPs - 2;
    startIP = subnetBits == 31 ? networkName : _addIP(networkName, 1);
    endIP = _addIP(networkName, subnetBits == 31 ? 1 : totalNumbersIPs - 2);
    broadcastIP = _addIP(networkName, totalNumbersIPs - 1);
  }

  var networkClass = _networkClass(ip);
  
  return IPSubnet(
    networkNameIPPart: networkName,
    subnetMask: subnetMask,
    broadcastIP: broadcastIP,
    startIP: startIP,
    endIP: endIP,
    networkClass: networkClass,
    usableNumberIPs: usableNumbersIPs,
    totalNumbersIPs: totalNumbersIPs,
  );
}