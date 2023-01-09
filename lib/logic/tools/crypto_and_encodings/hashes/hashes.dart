import 'dart:convert';
import 'dart:typed_data';

import 'package:pointycastle/export.dart';

// Wrapper for PointyCastle library
String _digest(Digest digest, String data) {
  if (data == null) data = '';

  Uint8List dataToDigest = utf8.encode(data);
  return _toHexString(digest.process(dataToDigest));
}

// Wrapper for PointyCastle library
String _hMac(HMac hmac, String data, String key) {
  if (data == null) data = '';
  if (key == null) key = '';

  hmac..init(KeyParameter(utf8.encode(key)));
  Uint8List dataToDigest = utf8.encode(data);
  return _toHexString(hmac.process(dataToDigest));
}

String _toHexString(Uint8List bytes) {
  return bytes.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join();
}

final Map<String, Function> HASH_FUNCTIONS = {
  'hashes_md5': md5Digest,
  'hashes_sha1': sha1Digest,
  'hashes_sha224': sha224Digest,
  'hashes_sha256': sha256Digest,
  'hashes_sha384': sha384Digest,
  'hashes_sha512': sha512Digest,
  'hashes_sha512.224': sha512_224Digest,
  'hashes_sha512.256': sha512_256Digest,
  'hashes_sha3.224': sha3_224Digest,
  'hashes_sha3.256': sha3_256Digest,
  'hashes_sha3.384': sha3_384Digest,
  'hashes_sha3.512': sha3_512Digest,
  'hashes_blake2b160': blake2b_160Digest,
  'hashes_blake2b224': blake2b_224Digest,
  'hashes_blake2b256': blake2b_256Digest,
  'hashes_blake2b384': blake2b_384Digest,
  'hashes_blake2b512': blake2b_512Digest,
  'hashes_keccak128': keccak_128Digest,
  'hashes_keccak224': keccak_224Digest,
  'hashes_keccak256': keccak_256Digest,
  'hashes_keccak288': keccak_288Digest,
  'hashes_keccak384': keccak_384Digest,
  'hashes_keccak512': keccak_512Digest,
  'hashes_md2': md2Digest,
  'hashes_md4': md4Digest,
  'hashes_ripemd128': ripemd_128Digest,
  'hashes_ripemd160': ripemd_160Digest,
  'hashes_ripemd256': ripemd_256Digest,
  'hashes_ripemd320': ripemd_320Digest,
  'hashes_tiger192': tiger_192Digest,
  'hashes_whirlpool512': whirlpool_512Digest,
};

final Map<String, Function> HASHKEY_FUNCTIONS = {
  'hashes_md5hmac': md5Hmac,
  'hashes_sha1hmac': sha1Hmac,
  'hashes_sha224hmac': sha224Hmac,
  'hashes_sha256hmac': sha256Hmac,
  'hashes_sha384hmac': sha384Hmac,
  'hashes_sha512hmac': sha512Hmac,
  'hashes_sha512.224hmac': sha512_224Hmac,
  'hashes_sha512.256hmac': sha512_256Hmac,
  'hashes_sha3.224hmac': sha3_224Hmac,
  'hashes_sha3.256hmac': sha3_256Hmac,
  'hashes_sha3.384hmac': sha3_384Hmac,
  'hashes_sha3.512hmac': sha3_512Hmac,
  'hashes_md2hmac': md2Hmac,
  'hashes_md4hmac': md4Hmac,
  'hashes_ripemd128hmac': ripemd_128Hmac,
  'hashes_ripemd160hmac': ripemd_160Hmac,
  'hashes_ripemd256hmac': ripemd_256Hmac,
  'hashes_ripemd320hmac': ripemd_320Hmac,
  'hashes_tiger192hmac': tiger_192Hmac,
  'hashes_whirlpool512hmac': whirlpool_512Hmac,
};

String blake2b_160Digest(String data) {
  return _digest(Blake2bDigest(digestSize: (160 / 8).floor()), data);
}

String blake2b_224Digest(String data) {
  return _digest(Blake2bDigest(digestSize: (224 / 8).floor()), data);
}

String blake2b_256Digest(String data) {
  return _digest(Blake2bDigest(digestSize: (256 / 8).floor()), data);
}

String blake2b_384Digest(String data) {
  return _digest(Blake2bDigest(digestSize: (384 / 8).floor()), data);
}

String blake2b_512Digest(String data) {
  return _digest(Blake2bDigest(), data);
}

String md2Digest(String data) {
  return _digest(MD2Digest(), data);
}

String md2Hmac(String data, String key) {
  return _hMac(HMac(MD2Digest(), 16), data, key);
}

String md4Digest(String data) {
  return _digest(MD4Digest(), data);
}

String md4Hmac(String data, String key) {
  return _hMac(HMac(MD4Digest(), 64), data, key);
}

String md5Digest(String data) {
  return _digest(MD5Digest(), data);
}

String md5Hmac(String data, String key) {
  return _hMac(HMac(MD5Digest(), 64), data, key);
}

String ripemd_128Digest(String data) {
  return _digest(RIPEMD128Digest(), data);
}

String ripemd_128Hmac(String data, String key) {
  return _hMac(HMac(RIPEMD128Digest(), 64), data, key);
}

String ripemd_160Digest(String data) {
  return _digest(RIPEMD160Digest(), data);
}

String ripemd_160Hmac(String data, String key) {
  return _hMac(HMac(RIPEMD160Digest(), 64), data, key);
}

String ripemd_256Digest(String data) {
  return _digest(RIPEMD256Digest(), data);
}

String ripemd_256Hmac(String data, String key) {
  return _hMac(HMac(RIPEMD256Digest(), 64), data, key);
}

String ripemd_320Digest(String data) {
  return _digest(RIPEMD320Digest(), data);
}

String ripemd_320Hmac(String data, String key) {
  return _hMac(HMac(RIPEMD320Digest(), 64), data, key);
}

String sha1Digest(String data) {
  return _digest(SHA1Digest(), data);
}

String sha1Hmac(String data, String key) {
  return _hMac(HMac(SHA1Digest(), 64), data, key);
}

String sha224Digest(String data) {
  return _digest(SHA224Digest(), data);
}

String sha224Hmac(String data, String key) {
  return _hMac(HMac(SHA224Digest(), 64), data, key);
}

String sha256Digest(String data) {
  return _digest(SHA256Digest(), data);
}

String sha256Hmac(String data, String key) {
  return _hMac(HMac(SHA256Digest(), 64), data, key);
}

String sha384Digest(String data) {
  return _digest(SHA384Digest(), data);
}

String sha384Hmac(String data, String key) {
  return _hMac(HMac(SHA384Digest(), 128), data, key);
}

String sha512Digest(String data) {
  return _digest(SHA512Digest(), data);
}

String sha512Hmac(String data, String key) {
  return _hMac(HMac(SHA512Digest(), 128), data, key);
}

String sha512_224Digest(String data) {
  return _digest(SHA512tDigest((224 / 8).floor()), data);
}

String sha512_224Hmac(String data, String key) {
  return _hMac(HMac(SHA512tDigest((224 / 8).floor()), 128), data, key);
}

String sha512_256Digest(String data) {
  return _digest(SHA512tDigest((256 / 8).floor()), data);
}

String sha512_256Hmac(String data, String key) {
  return _hMac(HMac(SHA512tDigest((256 / 8).floor()), 128), data, key);
}

String sha3_224Digest(String data) {
  return _digest(SHA3Digest(224), data);
}

String sha3_224Hmac(String data, String key) {
  return _hMac(HMac(SHA3Digest(224), 144), data, key);
}

String sha3_256Digest(String data) {
  return _digest(SHA3Digest(256), data);
}

String sha3_256Hmac(String data, String key) {
  return _hMac(HMac(SHA3Digest(256), 136), data, key);
}

String sha3_384Digest(String data) {
  return _digest(SHA3Digest(384), data);
}

String sha3_384Hmac(String data, String key) {
  return _hMac(HMac(SHA3Digest(384), 104), data, key);
}

String sha3_512Digest(String data) {
  return _digest(SHA3Digest(512), data);
}

String sha3_512Hmac(String data, String key) {
  return _hMac(HMac(SHA3Digest(512), 72), data, key);
}

String keccak_128Digest(String data) {
  return _digest(KeccakDigest(128), data);
}

String keccak_224Digest(String data) {
  return _digest(KeccakDigest(224), data);
}

String keccak_256Digest(String data) {
  return _digest(KeccakDigest(256), data);
}

String keccak_288Digest(String data) {
  return _digest(KeccakDigest(288), data);
}

String keccak_384Digest(String data) {
  return _digest(KeccakDigest(384), data);
}

String keccak_512Digest(String data) {
  return _digest(KeccakDigest(512), data);
}

String tiger_192Digest(String data) {
  return _digest(TigerDigest(), data);
}

String tiger_192Hmac(String data, String key) {
  return _hMac(HMac(TigerDigest(), 64), data, key);
}

String whirlpool_512Digest(String data) {
  return _digest(WhirlpoolDigest(), data);
}

String whirlpool_512Hmac(String data, String key) {
  return _hMac(HMac(WhirlpoolDigest(), 64), data, key);
}
