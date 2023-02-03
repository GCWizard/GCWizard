import 'package:flutter/material.dart';
import 'package:gc_wizard/application/registry.dart';
import 'package:gc_wizard/common_widgets/gcw_selection.dart';
import 'package:gc_wizard/common_widgets/gcw_tool.dart';
import 'package:gc_wizard/common_widgets/gcw_toollist.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/hashes/hash_breaker/widget/hash_breaker.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/hashes/hashes/widget/hashes.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/hashes/hashes_identification/widget/hashes_identification.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/hashes/hashes_overview/widget/hashes_overview.dart';
import 'package:gc_wizard/tools/wherigo/urwigo_hashbreaker/widget/urwigo_hashbreaker.dart';
import 'package:gc_wizard/utils/ui_dependent_utils/common_widget_utils.dart';

class HashSelection extends GCWSelection {
  @override
  Widget build(BuildContext context) {
    final List<GCWTool> _toolList = registeredTools.where((element) {
      return [
        className(HashBreaker()),
        className(UrwigoHashBreaker()),
        className(HashOverview()),
        className(HashIdentification()),
        className(MD5()),
        className(SHA1()),
        className(SHA224()),
        className(SHA256()),
        className(SHA384()),
        className(SHA512()),
        className(SHA512_224()),
        className(SHA512_256()),
        className(SHA3_224()),
        className(SHA3_256()),
        className(SHA3_384()),
        className(SHA3_512()),
        className(BLAKE2b_160()),
        className(BLAKE2b_224()),
        className(BLAKE2b_256()),
        className(BLAKE2b_384()),
        className(BLAKE2b_512()),
        className(Keccak_128()),
        className(Keccak_224()),
        className(Keccak_256()),
        className(Keccak_288()),
        className(Keccak_384()),
        className(Keccak_512()),
        className(MD2()),
        className(MD4()),
        className(RIPEMD_128()),
        className(RIPEMD_160()),
        className(RIPEMD_256()),
        className(RIPEMD_320()),
        className(Tiger_192()),
        className(Whirlpool_512()),
        className(MD5HMac()),
        className(SHA1HMac()),
        className(SHA224HMac()),
        className(SHA256HMac()),
        className(SHA384HMac()),
        className(SHA512HMac()),
        className(SHA512_224HMac()),
        className(SHA512_256HMac()),
        className(SHA3_224HMac()),
        className(SHA3_256HMac()),
        className(SHA3_384HMac()),
        className(SHA3_512HMac()),
        className(MD2HMac()),
        className(MD4HMac()),
        className(RIPEMD_128HMac()),
        className(RIPEMD_160HMac()),
        className(RIPEMD_256HMac()),
        className(RIPEMD_320HMac()),
        className(Tiger_192HMac()),
        className(Whirlpool_512HMac()),
      ].contains(className(element.tool));
    }).toList();

    return Container(child: GCWToolList(toolList: _toolList));
  }
}
