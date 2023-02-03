import 'package:flutter_test/flutter_test.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/hashes/logic/hashes.dart';

void main() {
  group("Hashes:", () {
    test('input: ABC, Blake2b 160}', () {expect(blake2b_160Digest('ABC'), '4bd5cccca8d964c750542e2f144f27659cfd667d');});
    test('input: ABC, Blake2b 224}', () {expect(blake2b_224Digest('ABC'), '6e577b4b289acc9c218b5fa56b0122eaba8d9bbff3dcb4b6289c073e');});
    test('input: ABC, Blake2b 256}', () {expect(blake2b_256Digest('ABC'), '9fe8acb2641296906a8c91de51516972827e3e2aef2e2c892e5f3b1426cea920');});
    test('input: ABC, Blake2b 384}', () {expect(blake2b_384Digest('ABC'), 'bfd5efad5187f60b33cb8ffb1e20bcc13741914dfa11a65080f538a7fbdcd1b80865e2d4e12137cafbe75ad06525ca40');});
    test('input: ABC, Blake2b 512}', () {expect(blake2b_512Digest('ABC'), '253d75df7b1bbc7a3f98fbc975d31bf25a8f3af84a42f37f15ca326c3feab2a2647673feeb1a4746bd0c59bbfb474dd97434afd4890b00e4ee1201f8c5c9806f');});
    test('input: ABC, MD2}', () {expect(md2Digest('ABC'), '67c7a694b8f99396bb1946eb7950e2c4');});
    test('input: ABC, MD4}', () {expect(md4Digest('ABC'), '6a86685756167ca49fa5ac194f812c61');});
    test('input: ABC, MD5}', () {expect(md5Digest('ABC'), '902fbdd2b1df0c4f70b4a5d23525e932');});
    test('input: ABC, RipeMD 128}', () {expect(ripemd_128Digest('ABC'), 'f1428f840d3a194eccb1b8cb7ea98f4a');});
    test('input: ABC, RipeMD 160}', () {expect(ripemd_160Digest('ABC'), 'df62d400e51d3582d53c2d89cfeb6e10d32a3ca6');});
    test('input: ABC, RipeMD 256}', () {expect(ripemd_256Digest('ABC'), 'b2a837fc4b66a964abd5809333896de83b9f914d00f469e6a5d836879d32cc2e');});
    test('input: ABC, RipeMD 320}', () {expect(ripemd_320Digest('ABC'), '6c46fb0fafd948b8477463d0eb96e1836fefc062adfc4e6a38b52bb61385eee173ce866de6c375f7');});
    test('input: ABC, SHA-1}', () {expect(sha1Digest('ABC'), '3c01bdbb26f358bab27f267924aa2c9a03fcfdb8');});
    test('input: ABC, SHA-224}', () {expect(sha224Digest('ABC'), '107c5072b799c4771f328304cfe1ebb375eb6ea7f35a3aa753836fad');});
    test('input: ABC, SHA-256}', () {expect(sha256Digest('ABC'), 'b5d4045c3f466fa91fe2cc6abe79232a1a57cdf104f7a26e716e0a1e2789df78');});
    test('input: ABC, SHA-384}', () {expect(sha384Digest('ABC'), '1e02dc92a41db610c9bcdc9b5935d1fb9be5639116f6c67e97bc1a3ac649753baba7ba021c813e1fe20c0480213ad371');});
    test('input: ABC, SHA-512}', () {expect(sha512Digest('ABC'), '397118fdac8d83ad98813c50759c85b8c47565d8268bf10da483153b747a74743a58a90e85aa9f705ce6984ffc128db567489817e4092d050d8a1cc596ddc119');});
    test('input: ABC, SHA-512/224}', () {expect(sha512_224Digest('ABC'), '2a2aa10c3ca33a979d6cc7d36f94425fb72a09d3d7137c8b9b5b4474');});
    test('input: ABC, SHA-512/256}', () {expect(sha512_256Digest('ABC'), '625c3e642852cb343b9b06eae14b47a7da0fd292a7be7b8a251208a65271af36');});
    test('input: ABC, SHA3-224}', () {expect(sha3_224Digest('ABC'), '51e6db7cba212f1490b290e44c588e3a028c8334055c877910c3ebe6');});
    test('input: ABC, SHA3-256}', () {expect(sha3_256Digest('ABC'), '7fb50120d9d1bc7504b4b7f1888d42ed98c0b47ab60a20bd4a2da7b2c1360efa');});
    test('input: ABC, SHA3-384}', () {expect(sha3_384Digest('ABC'), '38078331baaa86dbe9b38224a0780e9661daa35b42066a804efd5215b2487b9728a19ae4940ddbcbda39b697f13ebebb');});
    test('input: ABC, SHA3-512}', () {expect(sha3_512Digest('ABC'), '077aa33882b1aaf06da41c7ed3b6a40d7128dee23505ca2689c47637111c4701645fabc5ee1b9dcd039231d2d086bff9819ce2da8647432a73966494dd1a77ad');});
    test('input: ABC, Keccak-224}', () {expect(keccak_224Digest('ABC'), 'e751bc65acf5b088140fc76b934be15ac2caebba4d403ef60a6662a3');});
    test('input: ABC, Keccak-256}', () {expect(keccak_256Digest('ABC'), 'e1629b9dda060bb30c7908346f6af189c16773fa148d3366701fbaa35d54f3c8');});
    test('input: ABC, Keccak-288}', () {expect(keccak_288Digest('ABC'), 'c5c7a3dd87e9a340b960e8fedf3c7741ef767c043a18116ca0a7f9e0ef5ade4aec84c2c4');});
    test('input: ABC, Keccak-384}', () {expect(keccak_384Digest('ABC'), 'a786995442b0677bdcde1f0187c971518a79c65b2726ed9ba0098d6227560c768258db19d9a7e2842d80dc3e50a8a630');});
    test('input: ABC, Keccak-512}', () {expect(keccak_512Digest('ABC'), '49a28c786e950ae7a361416c198873a40fdfd374653e396abc2c9d779c13bd786accd1d0e40374222827d6ddabc2032b698edc48e192175352340afb48e40af4');});
    test('input: ABC, Tiger 192}', () {expect(tiger_192Digest('ABC'), 'c7188daee93509ecce198de5a43c8db47210db7e8d8bb8dd');});
    test('input: ABC, Whirlpool 512}', () {expect(whirlpool_512Digest('ABC'), 'd6e73067f0c7f37151c283c95ff41eb4e69fbade1c8e1437a40809b2acc0b9ab0a22690e853ffe7b4a804d7238f48a4984c2e5d745ccc223420b0af5bb3dc3ed');});
  });

  group("Hashes HMac:", () {
    // https://onlinephp.io/hash-hmac
    test('input: ABC, abc, MD2}', () {expect(md2Hmac('ABC','abc'), '5d728a928ab5cff4bdbc0a5c444cb5ce');});
    test('input: ABC, abc, MD4}', () {expect(md4Hmac('ABC','abc'), '07631a6cb46fde547dc9bb543db981db');});
    test('input: ABC, abc, MD5}', () {expect(md5Hmac('ABC','abc'), '14eb1aefe12f566110a492e32a910815');});
    test('input: ABC, abc, SHA-1}', () {expect(sha1Hmac('ABC','abc'), '65407f12e70655129f1921f787d840bb862323cf');});
    test('input: ABC, abc, SHA-224}', () {expect(sha224Hmac('ABC','abc'), '4e2f40737e2787c08db9dc00314043444e4f67746aff1f97471be38a');});
    test('input: ABC, abc, SHA-256}', () {expect(sha256Hmac('ABC','abc'), 'f135a005a928da55166790c43fa7b18a4a82277ee8910ca72de56a2b0f0fde6a');});
    test('input: ABC, abc, SHA-384}', () {expect(sha384Hmac('ABC','abc'), 'ccbc6e6c40bea20583ccde82255642fe8563332718c554e386df51f0ebec3e783b7f43127a8dbda3414b1d170052f89f');});
    test('input: ABC, abc, SHA-512}', () {expect(sha512Hmac('ABC','abc'), 'ba52bef9bfa29f8a563fe365758bcb2ef5e62ae906729dfa5708e3fc2468d5608874984dce8f9a7da91e314299721c265abf608f749e364ae285531243151626');});
    test('input: ABC, abc, SHA-512/224}', () {expect(sha512_224Hmac('ABC','abc'), '3a6a54b83be2671d15a6003deed7fadbc9174fcce7a7c72cc3b7f5e2');});
    test('input: ABC, abc, SHA-512/256}', () {expect(sha512_256Hmac('ABC','abc'), 'f6ad003ba2a19171e7c5103d3c991fd40ab4ad4b6fb69c044a5cf54d0c3fe538');});
    test('input: ABC, abc, SHA3-224}', () {expect(sha3_224Hmac('ABC','abc'), 'a0b6ff16b31f82f5444290c019d8932ade64c7e674095b4d03edb64c');});
    test('input: ABC, abc, SHA3-256}', () {expect(sha3_256Hmac('ABC','abc'), '83c0e282004c6fe46dda0fa315fb848afaee85107b3888b843dc629f638ea053');});
    test('input: ABC, abc, SHA3-384}', () {expect(sha3_384Hmac('ABC','abc'), '851bec4f15cbddb701277c68e8bb2b9d9969a38d6a60f309c257ff575c7504c3e2be2c5ec3a2d8c73a2289a8f1fad573');});
    test('input: ABC, abc, SHA3-512}', () {expect(sha3_512Hmac('ABC','abc'), '1e1b01dd4520c065b65687f2f2e2d4a8ddf4c73418ca4d488cae3141b7eb05e408c861a7d0df7f6759904ada89b3338d41eaffc1b8617a93d4505ba24e82d1ad');});
    test('input: ABC, abc, RipeMD 128}', () {expect(ripemd_128Hmac('ABC','abc'), 'a6c24d723a13ee63215004826d50452b');});
    test('input: ABC, abc, RipeMD 160}', () {expect(ripemd_160Hmac('ABC','abc'), '2c61a274d9bba24cc176b87f0d1dc8b8899bd39a');});
    test('input: ABC, abc, RipeMD 256}', () {expect(ripemd_256Hmac('ABC','abc'), '8b4e039d1c8f6bdb64709a6ec260b8dbd3019ee32c30d4b2cd2062d733e3092a');});
    test('input: ABC, abc, RipeMD 320}', () {expect(ripemd_320Hmac('ABC','abc'), '01bf278f97a4997d38c2e367e31cbd70238781d4a015224b9286a3ae3150738f6caf759a219bffcb');});
    test('input: ABC, abc, Tiger 192}', () {expect(tiger_192Hmac('ABC','abc'), '75bc8c3bf5164a091299f3a9e9d2f47b97c6e8d744c3f041');});
    test('input: ABC, abc, Whirlpool 512}', () {expect(whirlpool_512Hmac('ABC','abc'), 'af146523d51f512e0560a001859aa3c8424fb2023ae4a9e2ace05629b01456b3d7969cfff26db2317ee3aee14c66a2f8a6e8a3dff0365d86396c082f70483f3c');});
  });
}