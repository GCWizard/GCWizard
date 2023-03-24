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
  const HashSelection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<GCWTool> _toolList = registeredTools.where((element) {
      return [
        className(const HashBreaker()),
        className(const UrwigoHashBreaker()),
        className(const HashOverview()),
        className(const HashIdentification()),
        className(const MD5()),
        className(const SHA1()),
        className(const SHA224()),
        className(const SHA256()),
        className(const SHA384()),
        className(const SHA512()),
        className(const SHA512_224()),
        className(const SHA512_256()),
        className(const SHA3_224()),
        className(const SHA3_256()),
        className(const SHA3_384()),
        className(const SHA3_512()),
        className(const BLAKE2b_160()),
        className(const BLAKE2b_224()),
        className(const BLAKE2b_256()),
        className(const BLAKE2b_384()),
        className(const BLAKE2b_512()),
        className(const Keccak_128()),
        className(const Keccak_224()),
        className(const Keccak_256()),
        className(const Keccak_288()),
        className(const Keccak_384()),
        className(const Keccak_512()),
        className(const MD2()),
        className(const MD4()),
        className(const RIPEMD_128()),
        className(const RIPEMD_160()),
        className(const RIPEMD_256()),
        className(const RIPEMD_320()),
        className(const Tiger_192()),
        className(const Whirlpool_512()),
        className(const MD5HMac()),
        className(const SHA1HMac()),
        className(const SHA224HMac()),
        className(const SHA256HMac()),
        className(const SHA384HMac()),
        className(const SHA512HMac()),
        className(const SHA512_224HMac()),
        className(const SHA512_256HMac()),
        className(const SHA3_224HMac()),
        className(const SHA3_256HMac()),
        className(const SHA3_384HMac()),
        className(const SHA3_512HMac()),
        className(const MD2HMac()),
        className(const MD4HMac()),
        className(const RIPEMD_128HMac()),
        className(const RIPEMD_160HMac()),
        className(const RIPEMD_256HMac()),
        className(const RIPEMD_320HMac()),
        className(const Tiger_192HMac()),
        className(const Whirlpool_512HMac()),
      ].contains(className(element.tool));
    }).toList();

    return GCWToolList(toolList: _toolList);
  }
}
